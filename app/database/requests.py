from app.database.models import async_session
import app.database.models as tb
from sqlalchemy import select, and_, update
from sqlalchemy.orm import joinedload, selectinload
import logging
from datetime import datetime, timedelta
from aiogram.utils.markdown import hbold, hunderline, hpre
from aiogram.types import BufferedInputFile
from aiogram import Bot
from typing import List
import pandas as pd
from io import BytesIO
from openpyxl.utils import get_column_letter
import app.keyboards as kb
from sqlalchemy.ext.asyncio import AsyncSession

def connection(func):
    async def inner(*args, **kwargs):
        async with async_session() as session:
            try:
                result = await func(session, *args, **kwargs)
                await session.commit()
                return result
            except Exception as e:
                await session.rollback()
                logging.error(f"Ошибка в функции {func.__name__}: {e}")
                raise e
            finally:
                await session.close()
    return inner

@connection
async def check_user(session: AsyncSession, tg_id)-> bool:
    user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))

    return user is not None


@connection
async def reg_user(session: AsyncSession, data, tg_id)-> None:
    role = await session.scalar(select(tb.Role).where(tb.Role.roleName == data['role']))

    new_user = tb.User(
        tgId = tg_id,
        phone=data.get("number"),
        fio=data.get("fio"),
        roleId = role.idRole
    )

    session.add(new_user)

@connection
async def get_cargo_types(session: AsyncSession):
    result = await session.execute(select(tb.CargoType).order_by(tb.CargoType.cargoTypeName))
    cargo_types = result.scalars().all()
    return {cargo.idCargoType: cargo.cargoTypeName for cargo in cargo_types}

@connection
async def get_cargo_type_name_by_id(session: AsyncSession, data):
    cargo_type_name = await session.scalar(select(tb.CargoType).where(tb.CargoType.idCargoType == data))

    return cargo_type_name.cargoTypeName



@connection
async def add_new_order(session: AsyncSession, data):
    disp_id = await session.scalar(select(tb.User).where(tb.User.tgId == data["tg_id"]))
    new_order = tb.Order(
        cargoName=data["cargo_name"],
        cargoDescription=data["cargo_description"],
        cargoTypeId=int(data["cargo_type_id"]),
        cargo_weight=float(data["cargo_weight"]),
        depart_loc=data["depart_loc"],
        goal_loc=data["goal_loc"],
        time=datetime.strptime(data["time"], '%H:%M %d.%m.%Y'),
        orderStatusId = 1,
        dispatcherId = disp_id.idUser,
        driverId=None,
        create_order_time = datetime.now(),
    )
    if "photoId" in data:
        new_order.photoId = data["photoId"]
    if "isUrgent" in data:
        new_order.isUrgent = data["isUrgent"]

    session.add(new_order)
    await session.flush()
    await session.refresh(new_order)
    return new_order.idOrder

@connection
async def alarm_for_drivers(session: AsyncSession, orderId, bot: Bot):
    drivers = await session.scalars(select(tb.User).where(tb.User.roleId == 2))
    order = await session.scalar(select(tb.Order).options(joinedload(tb.Order.cargoType)).where(tb.Order.idOrder == orderId))
    mes = f'Срочный заказа:\n\n' + await form_order(order=order, cargo_type=order.cargoType.cargoTypeName)
    for driver in drivers:
        print("Оповещение пользователя")
        await bot.send_message(driver.tgId, mes, reply_markup=await kb.alarm_kb(orderId=orderId), parse_mode="HTML")

statuses = {
    1: "Доступен",
    2: "В работе",
    3: "Завершен",
    4: "Отменен"
}

@connection
async def get_order_keys(session: AsyncSession, dateTime: datetime = None, tg_id = None, isActual = False, isPrivateCatalog =False, statusId:int = None):
    stmt = select(tb.Order)
    user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
    if not isPrivateCatalog:
        if(dateTime != None):
            start_time = dateTime
            end_time = dateTime + timedelta(days=1)
            stmt = stmt.where(and_(tb.Order.time > start_time,
                                    tb.Order.time < end_time))
        if user.roleId == 2:
            stmt = stmt.where(tb.Order.orderStatusId == 1)
        stmt = stmt.order_by(tb.Order.time)

    else:
        match user.roleId:
            case 1: #Диспетчер
                role_condition= tb.Order.dispatcherId == user.idUser
                
            case 2:  # Водитель
                role_condition = tb.Order.driverId == user.idUser
            case 3:
                role_condition= tb.Order.dispatcherId == user.idUser
            case _:
                raise ValueError(f"Роль {user.roleId} не поддерживается")
        
        stmt = stmt.where(role_condition)

        if isActual:
            if statusId in [1,2]:
                stmt = stmt.where(tb.Order.orderStatusId == statusId)
            else:
                stmt = stmt.where(tb.Order.orderStatusId.in_([1,2]))
            statusId = None
        
        stmt = stmt.order_by(tb.Order.time.desc())
    
    if statusId is not None:

        stmt = stmt.where(tb.Order.orderStatusId == statusId)    

    result = await session.execute(stmt)
    orders = result.scalars().all()    

    
    order_keys = []
    for order in orders:
        order_keys.append(order.idOrder)
    return order_keys

@connection
async def get_orders(session: AsyncSession, ordersKeys, start: int, end: int):
    actiual_order_list = ordersKeys[start:end]
    stmt = (
        select(tb.Order)
        .options(joinedload(tb.Order.executor))  # Загружаем связанный объект Driver
        .options(joinedload(tb.Order.dispatcher))  # Загружаем связанный объект Dispatcher
        .order_by(tb.Order.time)
        .where(tb.Order.idOrder.in_(actiual_order_list))
    )

    
    result = await session.execute(stmt)
    orders = result.unique().scalars().all()    
    formatted_orders = []
    for order in orders:
        cargo_type = await session.scalar(select(tb.CargoType).where(tb.CargoType.idCargoType == order.cargoTypeId))
        formatted_order = await form_order(order=order, cargo_type=cargo_type)
        formatted_orders.append(formatted_order)
    return formatted_orders

@connection
async def get_order(session: AsyncSession, orderId):
    stmt = (
        select(tb.Order)
        .options(joinedload(tb.Order.cargoType))
        .where(tb.Order.idOrder == orderId)
    )
    result = await session.execute(stmt)
    order = result.scalar()

    order.orderTypeName = order.cargoType.cargoTypeName

    session.expunge(order)

    return order

@connection
async def get_cargo_type_name(session: AsyncSession, cargoTypeId):
     cargoType = await session.scalar(select(tb.CargoType).where(tb.CargoType.idCargoType == cargoTypeId))

     return cargoType.cargoTypeName

async def form_order(order, cargo_type, status=None, witoutStatus=False) -> str:
    if hasattr(cargo_type, 'cargoTypeName'):
        cargo_type_name = cargo_type.cargoTypeName  # Используем атрибут
    else:
        cargo_type_name = str(cargo_type)
    # Основной блок
    formatted_order = [
        hbold(f"🚚 ЗАКАЗ #{order.idOrder}"),
        f"📦 Груз: {order.cargoName}",
        f"📝 Описание: {order.cargoDescription}",
        f"⚖️ Вес: {order.cargo_weight} кг",
        f"📌 Тип: {cargo_type_name}",
        f"📍 Отправление: {order.depart_loc}",
        f"🏁 Доставка: {order.goal_loc}",
        f"🕒 Дата/время: {order.time.strftime('%d.%m.%Y %H:%M')}",
    ]

    if not witoutStatus:
        status = status or statuses.get(order.orderStatusId)
        formatted_order.append(f"🔖 Статус: {hunderline(status)}")

    if order.driverId is not None:
        executors_block = [
            "👤 Ответственные:",
            f"📞 Диспетчер: {order.dispatcher.phone}",
            f"🚜 Исполнитель: {order.executor.fio}",
        ]
        formatted_order.extend(executors_block)

    if order.photoId is not None:
        formatted_order.append("📸 Фото груза: приложено")
            

    formatted_order.append('\n━━━━━━━━━━━━━━━━━━\n')

    return "\n".join(formatted_order)

@connection
async def get_user(session: AsyncSession, tg_id=None, id= None):
    if tg_id != None:
        user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
    if id != None:
        user = await session.scalar(select(tb.User).where(tb.User.idUser == id))
    return user

@connection
async def get_user_role(session: AsyncSession, tg_id):
    user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
    role = await session.scalar(select(tb.Role).where(tb.Role.idRole == user.roleId))
    return role.roleName

@connection
async def chek_next_record(session: AsyncSession, end)-> bool:
    limit = 1
    offset = end - 1
    stmt = select(tb.Order).order_by(tb.Order.time).limit(limit).offset(offset)
    result = await session.execute(stmt)
    order = result.scalar()
    return order is not None

@connection
async def take_order(session: AsyncSession, tg_id, order_id)-> bool:

    if await check_order_status(order_id=order_id, expectStatus = [1]):
        user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
        new_data={
            "driverId": user.idUser,
            "orderStatusId": 2,
            "pickup_time":datetime.now(),
        }

        stmt = (
            update(tb.Order)
            .where(tb.Order.idOrder == order_id)
            .values(**new_data)
        )

        await session.execute(stmt)
        return True
    else:
        return False

@connection
async def check_order_status(session: AsyncSession, order_id, expectStatus: List[int])-> bool:

    order = await session.scalar(select(tb.Order).where(tb.Order.idOrder == order_id))

    return order.orderStatusId in expectStatus

@connection
async def get_order_photo(session: AsyncSession, order_id):

    order = await session.scalar(select(tb.Order).where(tb.Order.idOrder == int(order_id)))
    
    return order.photoId

@connection
async def get_user_for_send(session: AsyncSession, orderId, driver_id, action_text: str):
    order = await session.scalar(select(tb.Order).where(tb.Order.idOrder == orderId))
    disp = await session.scalar(select(tb.User).where(tb.User.idUser == order.dispatcherId))
    driver = await session.scalar(select(tb.User).where(tb.User.tgId == driver_id))
    cargo_type = await session.scalar(select(tb.CargoType).where(tb.CargoType.idCargoType == order.cargoTypeId))
    formatted_order = await form_order(order=order, cargo_type=cargo_type, witoutStatus=True)
    fromatted_mes = (
        f'{action_text}\n'
        f"Траспортировщик {driver.fio}\n"
        f"Телефон: {driver.phone}\n\n"       
    )
    final_message = fromatted_mes + formatted_order
    return disp.tgId, final_message

@connection
async def get_drivers_for_alarm(session: AsyncSession, order):
    drivers = await session.scalars(select(tb.User).where(tb.User.roleId == 2))

@connection
async def complete_order(session: AsyncSession, tg_id, order_id)-> bool:

    if await check_order_status(order_id=order_id, expectStatus= [2]):
        user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
        new_data={
            "orderStatusId": 3,
            "completion_time":datetime.now(),
        }

        stmt = (
            update(tb.Order)
            .where(tb.Order.idOrder == order_id)
            .values(**new_data)
        )

        await session.execute(stmt)
        return True
    else:
        return False

@connection
async def edit_order(session: AsyncSession, data):
    
    updates = {
        "cargoName": data.get("edit_cargo_name"),
        "cargoDescription": data.get("edit_cargo_description"),
        "cargo_weight": data.get("edit_cargo_weight"),
        "cargoTypeId": data.get("edit_cargo_type_id"),
        "depart_loc": data.get("edit_depart_loc"),
        "goal_loc": data.get("edit_goal_loc"),
        "orderStatusId": data.get("edit_order_status"),
        "isPostponed": data.get("set_postponned")
    }
    if data.get("edit_time") is not None:
        updates["time"] = datetime.strptime(data.get("edit_time"), '%H:%M %d.%m.%Y')
        
    updates = {k: v for k, v in updates.items() if v is not None}
    stmt = (
        update(tb.Order)
        .where(tb.Order.idOrder == int(data["order_id"]))
        .values(**updates)
    )
    await session.execute(stmt)
    
@connection
async def take_off_complete_order(session: AsyncSession, tg_id, order_id)-> None:

        user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
        new_data={
            "orderStatusId": 1,
            "driverId": None,
            "pickup_time": None,
        }

        stmt = (
            update(tb.Order)
            .where(tb.Order.idOrder == order_id)
            .values(**new_data)
        )

        await session.execute(stmt)

FIELDS = {
    "ID заказа": "idOrder",
    "Название груза": "cargoName",
    "Описание груза": "cargoDescription",
    "Тип груза": lambda order: order.cargoType.cargoTypeName if order.cargoType else "Не указан",
    "Вес груза (кг)": "cargo_weight",
    "Место отправления": "depart_loc",
    "Место назначения": "goal_loc",
    "Время заказа": lambda order: order.time.strftime("%Y-%m-%d %H:%M:%S"),
    "Статус": lambda order: order.orderStatus.orderStatusName if order.orderStatus else "Не указан",
    "Диспетчер": lambda order: order.dispatcher.fio if order.dispatcher else "Не указан",
    "Водитель": lambda order: order.executor.fio if order.executor else "Не назначен",
    "Время забора": lambda order: order.pickup_time.strftime("%Y-%m-%d %H:%M:%S") if order.pickup_time else "Не указано",
    "Время завершения": lambda order: order.completion_time.strftime("%Y-%m-%d %H:%M:%S") if order.completion_time else "Не указано",
    "Время создания": lambda order: order.create_order_time.strftime("%Y-%m-%d %H:%M:%S"),
    "Время выполнения заказа": lambda order:( 
        (str(order.completion_time - order.pickup_time)).split('.')[0]
        if order.completion_time else None),
    "Перенесен": lambda order: "Да" if order.isPostponed == True else "Нет"
}

@connection 
async def export_orders_to_excel(
    session,
    date_from: datetime = None,
    date_to: datetime = datetime.today() + timedelta(days = 1),
) -> BufferedInputFile:
    
    try:
        # Формируем запрос с учетом фильтров
        stmt = (
            select(tb.Order)
            .options(selectinload(tb.Order.cargoType))
            .options(selectinload(tb.Order.executor))
            .options(selectinload(tb.Order.dispatcher))
            .options(selectinload(tb.Order.orderStatus))
        )

        if date_from:
            stmt = stmt.where(tb.Order.create_order_time >= date_from)

        stmt = stmt.where(tb.Order.create_order_time <= date_to)

        # Потоковая обработка данных для экономии памяти
        result = await session.stream(stmt)

        async def process_data():
            data = []
            async for order in result.scalars():

                order_data = {}
                for display_name, field in FIELDS.items():
                    if callable(field):
                        order_data[display_name] = field(order)
                    else:
                        value = getattr(order, field)
                        order_data[display_name] = value if value is not None else "Не указано"
                data.append(order_data)
            if not data:
                raise ValueError("В базе данных нет заказов для указанных параметров")

            df = pd.DataFrame(data)

            date_column = "Время создания"
            time_to_take_column = "Время взятия заказа"
            time_to_complete_column = "Время выполнения заказа"
            postponed= "Перенесен"

            df["Среднее время взятия"] = pd.NA
            df["Среднее время выполнения"] = pd.NA
            df["Количество перенесенных"] = pd.NA

            df.sort_values(by=date_column, inplace=True)

            # Получаем уникальные даты
            dates = df[date_column].unique()

            # Список для хранения DataFrame'ов каждого дня
            dfs = []

            # Обрабатываем каждый день
            for date in dates:
                # Извлекаем данные за текущий день
                day_df = df[df[date_column] == date].copy()

                # Вычисляем метрики для дня
                avg_time_to_take = day_df[time_to_take_column].mean()
                avg_time_to_complete = day_df[time_to_complete_column].mean()
                num_transferred = day_df[postponed].sum()

                # Создаем строку сводки для текущего дня
                summary_row = pd.Series({
                    date_column: date,
                    "Среднее время взятия": avg_time_to_take,
                    "Среднее время выполнения": avg_time_to_complete,
                    "Количество перенесенных": num_transferred
                })
                summary_df = pd.DataFrame([summary_row])

                # Объединяем сводку и данные заказов за день
                day_combined = pd.concat([summary_df, day_df], ignore_index=True)
                dfs.append(day_combined)

            # Вычисляем общие метрики за весь период
            overall_avg_time_to_take = df[time_to_take_column].mean()
            overall_avg_time_to_complete = df[time_to_complete_column].mean()
            overall_num_transferred = df[postponed].sum()

            # Создаем итоговую сводную строку
            overall_summary_row = pd.Series({
                date_column: "Итого",
                "Среднее время взятия": overall_avg_time_to_take,
                "Среднее время выполнения": overall_avg_time_to_complete,
                "Количество перенесенных": overall_num_transferred
            })
            overall_summary_df = pd.DataFrame([overall_summary_row])
            final_df = pd.concat(dfs + [overall_summary_df], ignore_index=True)

            excel_file = BytesIO()
            with pd.ExcelWriter(excel_file, engine='openpyxl') as writer:
                final_df.to_excel(writer, index=False, sheet_name='Orders')
                worksheet = writer.sheets['Orders']

                time_columns = [time_to_complete_column, time_to_take_column]
                for col in time_columns:
                    col_idx = final_df.columns.get_loc(col) + 1
                    for row in range(2, len(final_df) + 2):
                        worksheet.cell(row=row, column=col_idx).number_format = '[h]:mm:ss'
                
                summary_time_columns = ["Среднее время взятия", "Среднее время выполнения"]
                for col in summary_time_columns:
                    col_idx = final_df.columns.get_loc(col) + 1
                    for row in range(2, len(final_df) + 2):
                        worksheet.cell(row=row, column=col_idx).number_format = '[h]:mm:ss'

                col_idx = list(FIELDS.keys()).index("Время выполнения заказа") + 1
                for row in range(2, len(final_df) + 2):
                    worksheet.cell(row=row, column=col_idx).number_format = '[h]:mm:ss'
                    
                for idx, column in enumerate(final_df.columns, 1):
                    max_length = max(final_df[column].astype(str).map(len).max(), len(column)) + 2
                    worksheet.column_dimensions[get_column_letter(idx)].width = max_length

            excel_file.seek(0)
            return excel_file.getvalue()

        excel_data = await process_data()

        filename = f"orders_export_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"

        file_for_telegram = BufferedInputFile(
            file=excel_data,
            filename=filename
        )

        return file_for_telegram

    except Exception as e:
        logging.error(f"Ошибка при экспорте заказов в Excel: {e}")
        raise

@connection
async def notificationDrivers(session: AsyncSession,  bot: Bot):
    target_time = datetime.now + timedelta(minutes=15)
    stmt = (
        select(tb.Order)
        .options(joinedload(tb.Order.executor))
        .options(joinedload(tb.Order.cargoType))
        .where(and_(
            tb.Order.orderStatusId == 2,
            tb.Order.time >= target_time - timedelta(seconds=30),
            tb.Order.time <= target_time + timedelta(seconds=30)
        ))
    )

    orders = await session.stream(stmt)
    async for order in orders:
        mes = "Напоминание:\n\n" + await form_order(order=order, cargo_type=order.cargoType.cargoTypeName)
        try:
            await bot.send_message(order.executor.tgId, mes)
        except Exception as e:
            logging.error(f"Ошибка отправки сообщения для заказа {order.idOrder}: {e}")

@connection
async def dayEnd(session: AsyncSession, bot: Bot):
    stmt = (
        select(tb.Order)
        .options(joinedload(tb.Order.dispatcher))
        .options(joinedload(tb.Order.cargoType))
        .where(and_(
            tb.Order.orderStatusId == 1,
            tb.Order.time == datetime.today()
        ))
    )

    orders = (await session.execute(stmt)).scalars().all()

    for order in orders:
        mes = "Перенос заказа:\n\n" + await form_order(order=order, cargo_type=order.cargoType.cargoTypeName)
        try:
            await bot.send_message(order.dispatcher.tgId, mes, reply_markup= await kb.dayEndKb(orderId=order.idOrder))
        except Exception as e:
            logging.error(f"Ошибка отправки сообщения для заказа {order.idOrder}: {e}")