from app.database.models import async_session
import app.database.models as tb
from sqlalchemy import select, and_, update, func
from sqlalchemy.orm import joinedload, selectinload
import logging
from datetime import datetime, timedelta
from aiogram.utils.markdown import hbold, hunderline
from aiogram.types import BufferedInputFile
from aiogram import Bot
from typing import List
import pandas as pd
from io import BytesIO
from openpyxl.utils import get_column_letter
import app.keyboards as kb
from sqlalchemy.ext.asyncio import AsyncSession
from openpyxl.styles import Alignment
import matplotlib.pyplot as plt
from cachetools import TTLCache

from staticmap import StaticMap, Line
import asyncio

user_cache = TTLCache(maxsize=100, ttl=300)
dep_build_cache = TTLCache(maxsize=200, ttl=86400)

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
async def reg_user(session: AsyncSession, data, tg_id)-> int:
    tg_id = int(tg_id)
    new_user = tb.User(
        tgId = tg_id,
        phone=data.get("number"),
        fio=data.get("fio"),
        roleId = None,
        is_denied = True
    )

    session.add(new_user)

@connection
async def add_role_and_acess(session: AsyncSession, tgId, role):
    role = await session.scalar(select(tb.Role).where(tb.Role.roleName == role))
    new_data={
        "roleId": role.idRole,
        "is_denied": False
    }

    stmt = (
        update(tb.User)
        .where(tb.User.tgId == int(tgId))
        .values(**new_data)
    )

    await session.execute(stmt)

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
        depart_loc=data["depart_loc_id"],
        goal_loc=data["goal_loc_id"],
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
    mes = f'Срочный заказ:\n\n' + await form_order(order=order, cargo_type=order.cargoType.cargoTypeName)
    for driver in drivers:
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
        f"📍 Отправление: {get_dep_build_input(order.depart_loc)}",
        f"🏁 Доставка: {get_dep_build_input(order.goal_loc)}",
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
    await session.refresh(
        user,
        attribute_names=[
            "idUser",
            "tgId",
            "phone",
            "fio",
            "roleId",
            "is_denied"
        ]
    )
    session.expunge(user)
    return user

@connection
async def get_user_role(session: AsyncSession, tg_id):
    tg_id = int(tg_id)
    user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
    role = await session.scalar(select(tb.Role).where(tb.Role.idRole == user.roleId))
    if role == None:
        return None
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
async def get_user_for_send(session: AsyncSession, orderId, driver_id, action_text: str, optin_mes: str = None):
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
    if optin_mes != None:
        final_message = final_message + optin_mes
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
    #"Описание груза": "cargoDescription",
    "Тип груза": lambda order: order.cargoType.cargoTypeName if order.cargoType else "Не указан",
    #"Вес груза (кг)": "cargo_weight",
    "Место отправления": lambda order: f'Отдел: {order.depart_loc_ref.department.department_name}, корпус: {order.depart_loc_ref.building.building_name}'
    if order.depart_loc_ref and order.depart_loc_ref.department and order.depart_loc_ref.building else "Не указано",
    "Место назначения": lambda order: f'Отдел: {order.goal_loc_ref.department.department_name}, корпус: {order.goal_loc_ref.building.building_name}'
    if order.goal_loc_ref and order.goal_loc_ref.department and order.goal_loc_ref.building else "Не указано",
    "Время заказа": lambda order: order.time.strftime("%Y-%m-%d %H:%M:%S"),
    #"Статус": lambda order: order.orderStatus.orderStatusName if order.orderStatus else "Не указан",
    "Диспетчер": lambda order: order.dispatcher.fio if order.dispatcher else "Не указан",
    "Водитель": lambda order: order.executor.fio if order.executor else "Не назначен",
    "Время забора": lambda order: order.pickup_time.strftime("%Y-%m-%d %H:%M:%S") if order.pickup_time else "Не указано",
    "Время завершения": lambda order: order.completion_time.strftime("%Y-%m-%d %H:%M:%S") if order.completion_time else "Не указано",
    "Время создания": lambda order: order.create_order_time.strftime("%Y-%m-%d %H:%M:%S"),
    "Время выполнения заказа": lambda order:( 
        (str(order.completion_time - order.pickup_time)).split('.')[0]
        if order.completion_time and order.pickup_time else None),
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
            .options(
                        joinedload(tb.Order.depart_loc_ref)
                        .joinedload(tb.DepartmentBuilding.department)
                    )
            .options(
                        joinedload(tb.Order.depart_loc_ref)
                        .joinedload(tb.DepartmentBuilding.building)
                    )
            .options(
                        joinedload(tb.Order.goal_loc_ref)
                        .joinedload(tb.DepartmentBuilding.department)
                    )
            .options(
                        joinedload(tb.Order.goal_loc_ref)
                        .joinedload(tb.DepartmentBuilding.building)
                    )
        )

        if date_from:
            stmt = stmt.where(tb.Order.create_order_time >= date_from)

        stmt = stmt.where(tb.Order.create_order_time <= date_to).order_by(tb.Order.create_order_time)

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
            time_to_take_column = "Время забора"
            time_to_complete_column = "Время завершения"
            postponed_column = "Перенесен"
            
            #Попроавака на часовой пояс москвы +3 добавлен + pd.Timedelta(hours=3)
            df[time_to_take_column] = pd.to_datetime(df[time_to_take_column], errors='coerce') + pd.Timedelta(hours=3)
            df[time_to_complete_column] = pd.to_datetime(df[time_to_complete_column], errors='coerce') + pd.Timedelta(hours=3)
            df[date_column] = pd.to_datetime(df[date_column], errors='coerce') + pd.Timedelta(hours=3)
            
            df.sort_values(by=date_column, inplace=True)

            # Получаем уникальные даты
            dates = df[date_column].dt.date.unique()

            # Список для хранения DataFrame'ов каждого дня
            dfs = []
            summary_rows = []  # Номера строк для объединения
            current_row = 0
            # Обрабатываем каждый день
            for date in dates:

                day_df = df[df[date_column].dt.date == date].copy()

                # Вычисляем метрики для дня
                avg_time_to_take = (day_df[time_to_take_column] - day_df[date_column]).mean()
                avg_time_to_complete = (day_df[time_to_complete_column] - day_df[time_to_take_column]).mean()
                num_transferred = (day_df[postponed_column] == "Да").sum()
                
                avg_time_to_take_str = str(avg_time_to_take).split(' ')[-1] if pd.notna(avg_time_to_take) else "Не указано"
                avg_time_to_complete_str = str(avg_time_to_complete).split(' ')[-1] if pd.notna(avg_time_to_complete) else "Не указано"
                # Создаем строку сводки для текущего дня
                summary_text = (
                            f"Дата: {date.strftime('%d.%m.%Y')} "
                            f"среднее время выполнения: {avg_time_to_complete_str.split('.')[0]} "
                            f"среднее время взятия: {avg_time_to_take_str.split('.')[0]} "
                            f"количество перенесенных: {num_transferred}"
                        )
                summary_df = pd.DataFrame([[summary_text] + [""] * (len(FIELDS) - 1)], columns=df.columns)

                # Объединяем сводку и данные заказов за день
                day_combined = pd.concat([summary_df, day_df], ignore_index=True)

                summary_rows.append(current_row + 1)  # +1 для учета заголовка в Excel
                current_row += len(day_combined)

                dfs.append(day_combined)

            # Вычисляем общие метрики за весь период
            overall_avg_time_to_take = (df[time_to_take_column] - df[date_column]).mean()
            overall_avg_time_to_complete = (df[time_to_complete_column] - df[time_to_take_column]).mean()
            overall_num_transferred = (df[postponed_column] == "Да").sum()

            overall_avg_time_to_take_str = str(overall_avg_time_to_take).split(' ')[-1] if pd.notna(overall_avg_time_to_take) else "Не указано"
            overall_avg_time_to_complete_str = str(overall_avg_time_to_complete).split(' ')[-1] if pd.notna(overall_avg_time_to_complete) else "Не указано"

            # Форматируем итоговую строку
            overall_summary_text = (
                f"Итого "
                f"среднее время выполнения: {overall_avg_time_to_complete_str.split('.')[0]} "
                f"среднее время взятия: {overall_avg_time_to_take_str.split('.')[0]} "
                f"количество перенесенных: {overall_num_transferred}"
            )
            overall_summary_df = pd.DataFrame([[overall_summary_text] + [""] * (len(FIELDS) - 1)], columns=df.columns)
            summary_rows.append(current_row + 1)
            final_df = pd.concat(dfs + [overall_summary_df], ignore_index=True)

            excel_file = BytesIO()
            with pd.ExcelWriter(excel_file, engine='openpyxl') as writer:
                final_df.to_excel(writer, index=False, sheet_name='Orders')
                worksheet = writer.sheets['Orders']

                num_columns = len(final_df.columns)
                for row_idx in summary_rows:
                    worksheet.merge_cells(start_row=row_idx + 1, start_column=1, end_row=row_idx + 1, end_column=num_columns)
                    worksheet.cell(row=row_idx + 1, column=1).alignment = Alignment(horizontal='left')

                # Форматируем колонки с временем


                col_idx = list(FIELDS.keys()).index("Время выполнения заказа") + 1
                for row in range(2, len(final_df) + 2):
                    worksheet.cell(row=row, column=col_idx).number_format = '[h]:mm:ss'

                # Настраиваем ширину колонок
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

    target_time = datetime.now() + timedelta(minutes=1)
    stmt = (
        select(tb.Order)
        .options(joinedload(tb.Order.executor))
        .options(joinedload(tb.Order.dispatcher))
        .options(joinedload(tb.Order.cargoType))
        .where(and_(
            tb.Order.orderStatusId == 2,
            tb.Order.time >= target_time - timedelta(seconds=30),
            tb.Order.time <= target_time + timedelta(seconds=30)
        ))
    )

    result = await session.execute(stmt)
    orders = result.scalars().all()
    for order in orders:
        mes = "Напоминание:\n\n" + await form_order(order=order, cargo_type=order.cargoType.cargoTypeName)
        try:

            await bot.send_message(order.executor.tgId, mes)
        except Exception as e:
            logging.error(f"Ошибка отправки сообщения для заказа {order.idOrder}: {e}")

@connection
async def notiNewOrders(session: AsyncSession,  bot: Bot):
    target_time = datetime.now().replace(hour=0,minute=0,second=0)
    stmt = (
        select(tb.Order)
        .where(and_(
            tb.Order.orderStatusId == 1,
            tb.Order.create_order_time > target_time
        ))
    )
    result = await session.execute(stmt)
    orders = result.scalars().all()
    countOrders = len(orders)
    if countOrders > 0:
        drivers = await session.scalars(select(tb.User).where(tb.User.roleId == 2))
        drivers = drivers.all()
        for driver in drivers:
            try:

                await bot.send_message(driver.tgId, f'Доступно {countOrders} заказов')
            except Exception as e:
                logging.error(f"Ошибка отправки сообщения для водителя {driver.tgId}: {e}")


@connection
async def dayEnd(session: AsyncSession, bot: Bot):
    stmt = (
        select(tb.Order)
        .options(joinedload(tb.Order.executor))
        .options(joinedload(tb.Order.dispatcher))
        .options(joinedload(tb.Order.cargoType))
        .where(and_(
            tb.Order.orderStatusId == 1,
            tb.Order.time >= datetime.today().replace(hour=0, minute=0, second=0, microsecond=0)
        ))
    )

    orders = (await session.execute(stmt)).scalars().all()
    for order in orders:

        mes = "Перенос заказа:\n\n" + await form_order(order=order, cargo_type=order.cargoType.cargoTypeName)
        try:

            await bot.send_message(order.dispatcher.tgId, mes, reply_markup= await kb.dayEndKb(orderId=order.idOrder), parse_mode='HTML')
        except Exception as e:
            logging.error(f"Ошибка отправки сообщения для заказа {order.idOrder}: {e}")

@connection
async def export_diagrama(session, 
    date_from: datetime = None,
    date_to: datetime = datetime.today() + timedelta(days = 1)) -> BufferedInputFile:
    print("date_from: ", date_from)
    print("date_to: ", date_to)
    stmt = (
        select(tb.Order)
        .options(joinedload(tb.Order.cargoType))
        .options(joinedload(tb.Order.executor))
        .options(joinedload(tb.Order.depart_loc_ref).joinedload(tb.DepartmentBuilding.department).joinedload(tb.Department.departmentType))
        .options(joinedload(tb.Order.goal_loc_ref).joinedload(tb.DepartmentBuilding.department).joinedload(tb.Department.departmentType))
        .where(and_(
            tb.Order.orderStatusId == 3,
            tb.Order.completion_time.isnot(None),
            tb.Order.pickup_time.isnot(None),
            tb.Order.completion_time >= date_from,
            tb.Order.completion_time <= date_to
        ))
    )

    result = await session.execute(stmt)
    orders = result.scalars().all()
    for order in orders:
        print(order.idOrder)
    if not orders:
        raise ValueError("Нет выполненных заказов за указанный период")
    
    dataToTime = [
        {"Водитель": order.executor.fio,
         "Время выполнения (сек)": (
         (order.completion_time - order.pickup_time).total_seconds() 
         if order.completion_time.date() == order.pickup_time.date() 
         else None
        )
         }
        for order in orders if order.executor and order.cargoType and order.completion_time.date() == order.pickup_time.date()
    ]

    dataToOrderCount = [
        {"Водитель": order.executor.fio,
         "Группа груза": order.cargoType.cargoTypeName
         }
        for order in orders if order.executor and order.cargoType
    ]

    df = pd.DataFrame(dataToTime)
    driver_time = df.groupby("Водитель")["Время выполнения (сек)"].mean()

    df2 = pd.DataFrame(dataToOrderCount)
    driver_cargo = pd.crosstab(df2["Водитель"], df2["Группа груза"])
    driver_counts = df2["Водитель"].value_counts()
    cargo_counts = df2["Группа груза"].value_counts()

    orders_from_workshops = [
        o for o in orders
        if o.depart_loc_ref and
        o.depart_loc_ref.department and
        o.depart_loc_ref.department.departmentType and
        o.depart_loc_ref.department.departmentType.department_type_id == 1
        and o.cargoType
    ]

    orders_to_workshops = [
        o for o in orders
        if o.goal_loc_ref and
        o.goal_loc_ref.department and
        o.goal_loc_ref.department.departmentType and
        o.goal_loc_ref.department.departmentType.department_type_id == 1
        and o.cargoType
    ]

    from_stats = pd.crosstab(
        [o.depart_loc_ref.department.department_name for o in orders_from_workshops],
        [o.cargoType.cargoTypeName for o in orders_from_workshops]
    )

    to_stats = pd.crosstab(
        [o.goal_loc_ref.department.department_name for o in orders_to_workshops],
        [o.cargoType.cargoTypeName for o in orders_to_workshops]
    )
    period_str = f"Период: {date_from.strftime('%d.%m.%Y')} — {date_to.strftime('%d.%m.%Y')}"
    fig1, (ax1, ax2) = plt.subplots(2, 1, figsize=(17, 19), height_ratios=[1, 1])
    fig1.suptitle(period_str, fontsize=16, fontweight='bold')
    plt.subplots_adjust(left=0.1, right=0.65, top=0.95, bottom=0.1, hspace=0.3)

    fig2, (ax3, ax4) = plt.subplots(2, 1, figsize=(21, 12), height_ratios=[1, 1])
    fig2.suptitle(period_str, fontsize=16, fontweight='bold')
    plt.subplots_adjust(left=0.1, right=0.65, top=0.95, bottom=0.1, hspace=0.3)



    driver_cargo.plot(kind='bar', stacked=True, ax=ax1, color=plt.cm.Set3(range(len(driver_cargo.columns))), edgecolor='black')
    ax1.set_title("Количество заказов по водителям с разбиением по типам грузов")
    ax1.set_xlabel("Водитель")
    ax1.set_ylabel("Количество заказов")
    ax1.tick_params(axis='x', rotation=45)
    ax1.grid(True, axis='y')
    ax1.legend(title="Группа груза", bbox_to_anchor=(1.05, 1), loc='upper left')

    for i, driver in enumerate(driver_cargo.index):
        cumulative_height = 0  
        for j, cargo_type in enumerate(driver_cargo.columns):
            value = driver_cargo.loc[driver, cargo_type]
            if value > 0: 
                cumulative_height += value
            
                text_y = cumulative_height - (value / 2)
                ax1.text(i, text_y, int(value), ha='center', va='center', fontsize=8, color='black')

    for i, total in enumerate(driver_cargo.sum(axis=1)):
        ax1.text(i, total + 0.5, int(total), ha='center', va='bottom')

    bars2 = ax2.bar(driver_time.index, driver_time.values / 60, color='lightgreen', edgecolor='black')  # Переводим секунды в минуты
    ax2.set_title("Среднее время выполнения заказов по водителям (в минутах)")
    ax2.set_xlabel("Водитель")
    ax2.set_ylabel("Среднее время (мин)")
    ax2.tick_params(axis='x', rotation=45)
    ax2.grid(True, axis='y')
    for bar in bars2:
        yval = bar.get_height()
        ax2.text(bar.get_x() + bar.get_width()/2, yval + 0.5, f"{yval:.1f}", ha='center', va='bottom')

    cargo_stats = pd.DataFrame({"Количество": cargo_counts})
    cargo_table_data = [["Группа груза", "Количество"]] + cargo_stats.reset_index().values.tolist()
    cargo_table = plt.table(cellText=cargo_table_data,
                           colWidths=[0.15, 0.1],
                           loc='right',
                           bbox=[1.35, 0.55, 0.45, 0.45])  # Справа от верхней диаграммы
    cargo_table.auto_set_font_size(False)
    cargo_table.set_fontsize(10)
    cargo_table.auto_set_column_width([0, 1])

    driver_stats = pd.DataFrame({"Количество": driver_counts})
    driver_table_data = [["ФИО исполнителя", "Количество"]] + driver_stats.reset_index().values.tolist()
    driver_table = plt.table(cellText=driver_table_data,
                            colWidths=[0.15, 0.1],
                            loc='right',
                            bbox=[1.35, 0.05, 0.45, 0.45])  # Справа от нижней диаграммы
    driver_table.auto_set_font_size(False)
    driver_table.set_fontsize(10)
    driver_table.auto_set_column_width([0, 1])
    
    ax1.legend(title="Группа груза", bbox_to_anchor=(1.0, 1), loc='upper left')

    from_stats.plot(kind="bar", stacked=True, ax=ax3, colormap="tab20", edgecolor='black')

    for i, (index, row) in enumerate(from_stats.iterrows()):
        cumulative = 0
        for j, value in enumerate(row):
            if value > 0:
                cumulative += value
                ax3.text(i, cumulative - value / 2, str(int(value)), ha='center', va='center', fontsize=8, color='black')
        ax3.text(i, cumulative + 0.5, str(int(row.sum())), ha='center', va='bottom', fontsize=9, fontweight='bold')   
    # 📊 3-я диаграмма: поступление заказов из цехов по типам
    ax3.set_title("Поступление заказов из цехов по типам")
    ax3.set_xlabel("Цех (откуда)")
    ax3.set_ylabel("Количество")
    ax3.tick_params(axis='x', rotation=45)
    ax3.grid(True, axis='y')
    ax3.legend(title="Группа груза", bbox_to_anchor=(1.05, 1), loc='upper left')

    for i, (index, row) in enumerate(to_stats.iterrows()):
        cumulative = 0
        for j, value in enumerate(row):
            if value > 0:
                cumulative += value
                ax4.text(i, cumulative - value / 2, str(int(value)), ha='center', va='center', fontsize=8, color='black')
        ax4.text(i, cumulative + 0.5, str(int(row.sum())), ha='center', va='bottom', fontsize=9, fontweight='bold')
    
    # 📊 4-я диаграмма: поступление заказов в цеха по типам
    to_stats.plot(kind="bar", stacked=True, ax=ax4, colormap="tab20c", edgecolor='black')
    ax4.set_title("Поступление заказов в цеха по типам")
    ax4.set_xlabel("Цех (куда)")
    ax4.set_ylabel("Количество")
    ax4.tick_params(axis='x', rotation=45)
    ax4.grid(True, axis='y')
    ax4.legend(title="Группа груза", bbox_to_anchor=(1.05, 1), loc='upper left')

    plt.tight_layout()

    hist_file1 = BytesIO()
    fig1.savefig(hist_file1, format='png', bbox_inches='tight')
    plt.close(fig1)
    hist_file1.seek(0)

    # Сохраняем второй график
    hist_file2 = BytesIO()
    fig2.savefig(hist_file2, format='png', bbox_inches='tight')
    plt.close(fig2)
    hist_file2.seek(0)

    return [
        BufferedInputFile(hist_file1.getvalue(), filename=f"Водители_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"),
        BufferedInputFile(hist_file2.getvalue(), filename=f"Цеха_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"),
    ]

@connection
async def get_user_id(session: AsyncSession, tg_id: int) -> int:
    if tg_id in user_cache:  
        return user_cache[tg_id]  
    
    user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
    user_cache[tg_id] = user.idUser
    return user.idUser

@connection
async def save_location(session: AsyncSession, user_id, latitude, longitude, timestamp):

    new_loc = tb.UserLocation(
        user_id=user_id,
        latitude=latitude,
        longitude=longitude,
        timestamp=timestamp,
    )

    session.add(new_loc)

@connection
async def get_map(session: AsyncSession, tg_id, date):
    
    #user_id = await get_user_id(tg_id = tg_id)
    user_id = 2
    date = datetime.today() - timedelta(days=1)

    stmt = (
        select(tb.UserLocation)
        .where(and_ (func.date(tb.UserLocation.timestamp) == date.date(),
                     tb.UserLocation.user_id == user_id))
        .order_by((tb.UserLocation.created_at))
    )

    results = await session.stream(stmt)
    locations = await results.scalars().all()

    if len(locations) < 2:
        return "Недостаточно данных для построения маршрута. Требуется хотя бы две точки."
    
    coordinates = [(loc.longitude, loc.latitude) for loc in locations]
    coordinates = coordinates[::10]
    route_points = ','.join([f'{lat},{lon}' for lat, lon in coordinates])

    loop = asyncio.get_event_loop()
    image_data = await loop.run_in_executor(None, generate_map, coordinates)

    return BufferedInputFile(file=image_data, filename="route_map.png")

def generate_map(coordinates):
    
    
    # Создаём объект карты с размерами 800x600 пикселей
    m = StaticMap(800, 600)
    
    # Создаём линию маршрута: синяя, толщиной 5 пикселей
    line = Line(coordinates, 'blue', 5)
    m.add_line(line)

    # Рендерим карту в изображение
    image = m.render()

    # Сохраняем изображение в буфер памяти
    image_io = BytesIO()
    image.save(image_io, 'PNG')
    image_io.seek(0)

    return image_io.getvalue()

@connection
async def change_role(session: AsyncSession, data, id_role):
        
        user = await session.scalar(select(tb.User).where(tb.User.tgId == data["tg_id"]))
        new_data={
            "roleId": id_role
        }

        stmt = (
            update(tb.User)
            .where(tb.User.idUser == user.idUser)
            .values(**new_data)
        )

        await session.execute(stmt)

@connection
async def set_driver_rate(session: AsyncSession, orderId, rate):
    updates = {
        "driverRate": rate
    }

    stmt = (
        update(tb.Order)
        .where(tb.Order.idOrder == orderId)
        .values(**updates)
    )

    await session.execute(stmt)


def get_dep_build_id(dep_id: int, build_id: int) -> int:
    for entry in dep_build_cache["department_buildings"]:
        if entry["department_id"] == dep_id and entry["building_id"] == build_id:
            return entry["id"] 
    raise ValueError(f"Не найдена запись DepartmentBuilding в кеше. Атрубуты: department_id={dep_id} and building_id={build_id}")

def get_dep_build_description(dep_build_id: int) -> str:
    for entry in dep_build_cache["department_buildings"]:
        if entry["id"] == dep_build_id:
            return entry["description"] 
    raise ValueError(f"Не найдено описание для dep_build_id = {dep_build_id}")

def get_dep_name(dep_id: int, isWithTypeName: False) -> str:
    deps = dep_build_cache.get("departments", [])
    res = ''
    for dep in deps:
        if dep["idDepartment"] == dep_id:
            if isWithTypeName:
                match dep["typeId"]:
                    case 1: res = "Цех "
                    case 2: res = "Отдел "
                    case _: res = "Тип не определен. Номер: "
            return res + dep["departmentName"]
    raise ValueError(f"Не найдена запись Department в кеше. Атрибут: id={dep_id}")

def get_build_name(build_id: int) -> str:
    bulds = dep_build_cache.get("buildings", [])
    for buld in bulds:
        if buld["idBuilding"] == build_id:
            return buld["buildingName"]
    raise ValueError(f"Не найдена запись Building в кеше. Атрибут: id={build_id}")

def get_bilds_List(dep_id: int) -> List[dict]:
    return [{"id": entry["id"], "building_id": entry["building_id"]}
            for entry in dep_build_cache["department_buildings"]
            if entry["department_id"] == dep_id]

def get_dep_List(dep_type_id: int) -> List[dict]:
    departments = dep_build_cache.get("departments", [])
    return [{'id': dep["idDepartment"], 'name': dep["departmentName"]}
            for dep in departments if dep["typeId"] == dep_type_id]

def get_dep_build_input(dep_build_id: int) -> str:
    for entry in dep_build_cache["department_buildings"]:
        if entry["id"] == dep_build_id:
            dep_name = get_dep_name(entry["department_id"], isWithTypeName=True)
            build_name = get_build_name(entry["building_id"])
            res = f'{dep_name}, корпус {build_name}, {entry["description"]}'
            return res
@connection
async def dep_build_set(session: AsyncSession):
    deps = list(await session.scalars(select(tb.Department).order_by(tb.Department.department_name)))
    build = list(await session.scalars(select(tb.Building).order_by(tb.Building.building_name)))
    dep_build = list(await session.scalars(select(tb.DepartmentBuilding)))

    dep_build_cache.clear()
    dep_build_cache["department_buildings"] = [
        {"id": db.department_building_id, "department_id": db.department_id, "building_id": db.building_id, "description": db.description}
        for db in dep_build
    ]
    dep_build_cache["departments"] = [
        {"idDepartment": dep.department_id, "departmentName": dep.department_name, "typeId": dep.department_type_id}
        for dep in deps
    ]
    dep_build_cache["buildings"] = [
        {"idBuilding": b.building_id, "buildingName": b.building_name}
        for b in build
    ]

@connection
async def get_cargo_type_list(session: AsyncSession):
    rows = await session.scalars(select(tb.CargoType).order_by(tb.CargoType.idCargoType))
    return [{"id": row.idCargoType, "label": row.cargoTypeName, "coefficent": row.ratio} for row in rows]

@connection
async def update_ratio(session: AsyncSession, id, ratio):
    stmt = update(tb.CargoType).where(tb.CargoType.idCargoType == id).values(ratio=ratio)
    await session.execute(stmt)

@connection
async def get_time_coeffs(session: AsyncSession):
    rows = await session.scalars(select(tb.TimeCoeff).order_by(tb.TimeCoeff.value))
    return [{"id": row.time_coefficent_id, "label": f"{row.value} мин", "coefficent": row.coefficent} for row in rows]

@connection
async def update_time_coeff(session: AsyncSession, id: int, coeff: float):
    stmt = update(tb.TimeCoeff).where(tb.TimeCoeff.time_coefficent_id == id).values(coefficent=coeff)
    await session.execute(stmt)

@connection
async def get_weight_coeffs(session: AsyncSession):
    rows = await session.scalars(select(tb.WeightCoeff).order_by(tb.WeightCoeff.value))
    return [{"id": row.weight_coefficent_id, "label": f"{row.value} кг", "coefficent": row.coefficent} for row in rows]

@connection
async def update_weight_coeff(session: AsyncSession, id: int, coeff: float):
    stmt = update(tb.WeightCoeff).where(tb.WeightCoeff.weight_coefficent_id == id).values(coefficent=coeff)
    await session.execute(stmt)

@connection
async def update_ratio(session: AsyncSession, id, ratio):
    updates ={
        "ratio": ratio,
    }

    stmt = (
        update(tb.CargoType)
        .where(tb.CargoType.idCargoType == int(id))
        .values(**updates)
    )

    await session.execute(stmt)

@connection
async def add_ratio(session: AsyncSession, coeff_type, value):
    match coeff_type:
        case "cargo":
            data_save = tb.CargoType(
                cargoTypeName = value,
                ratio = 1.0,
            )

        case "time":
            data_save = tb.TimeCoeff(
                value = value,
                coefficent = 1.0,
            )

        case "weight":
            data_save = tb.WeightCoeff(
                value = value,
                coefficent = 1.0,
            )
            
    session.add(data_save)

@connection
async def get_stuff_List_mes(session: AsyncSession, roleId: int):
    stmt = (
        select(tb.User)
        .where(tb.User.roleId == roleId)
        .order_by(tb.User.fio)
    )

    res = await session.execute(stmt)
    stuffList = res.scalars().all()

    mes = "\n"
    for stuff in stuffList:
        mes = mes + stuff.fio
        if roleId == 2:
            rate, count = await get_driver_rate(stuff.idUser)
            mes = mes + f'\n\t⭐ рейтинг: {str(rate)} \n\t📦 всего заказов с оценкой: {str(count)}'
        mes = mes +"\n\n"
    return mes

@connection
async def get_driver_rate(session: AsyncSession, driverId: int):
    stmt = select(
        func.avg(tb.Order.driverRate),
        func.count(tb.Order.driverRate)
        ).where(
        tb.Order.driverId == driverId,
        tb.Order.driverRate.isnot(None)
    )

    result = await session.execute(stmt)
    average_rate, count = result.one_or_none()

    average_rate = round(average_rate, 2) if average_rate is not None else 0.0
    count = count or 0
    return average_rate, count
async def get_admins_for_alarm(session: AsyncSession):
    stmt = (
        select(tb.User)
        .where(tb.User.roleId == 4)
    )

    result = await session.execute(stmt)
    admins = result.scalars().all()
    admin_ids = [admin.tgId for admin in admins]
    return admin_ids

@connection
async def get_drivers_payment(session: AsyncSession, last_month_12 = None, current_month_12 = None):
    today = datetime.now()

    total_bonus = 200000
    salary = 50000

    if (current_month_12 is None):
        current_month_12 = today.replace(day=12)
        if today.month == 1:  # Если январь, берём декабрь прошлого года
            last_month_12 = today.replace(year=today.year - 1, month=12, day=12)
        else:
            last_month_12 = today.replace(month=today.month - 1, day=12)

    drivers = await session.execute(
            select(tb.User.idUser, tb.User.fio)
            .where(tb.User.roleId == 2))
    
    drivers = drivers.all()

    drivers_names = {idUser: fio for idUser, fio in drivers}
    drivers_dict = {idUser: 0 for idUser, _ in drivers}

    stmt = (
        select(tb.Order)
        .options(joinedload(tb.Order.executor))
        .options(joinedload(tb.Order.cargoType))
        .where(
            tb.Order.completion_time >= last_month_12,
            tb.Order.completion_time < current_month_12
        )
    )
    result = await session.execute(stmt)
    orders = result.scalars().all()

    for order in orders:
        drivers_dict[order.executor.idUser] = drivers_dict[order.executor.idUser] + 1 * order.cargoType.ratio

    total_orders = sum(drivers_dict.values())
    if total_orders == 0:
        return "Нет заказов за период."
    sum_on_order = total_bonus / total_orders
    
    mes = f'📊Расчёт зарплат за период с {last_month_12.strftime("%d-%m-%Y")} по {current_month_12.strftime("%d-%m-%Y")}\n📦Всего отвезено заказов (с учетом коэффициентов): {total_orders}\n💰Общая сумма на премии: {total_bonus}\n📈Сумма премии на единицу заказа: {sum_on_order:.2f}\n💵Фиксированный оклад: {salary}\n\n'    
    for driver_id in drivers_dict:
        bonus = drivers_dict[driver_id] * sum_on_order
        total_salary = bonus + salary
        mes += f'👤{drivers_names[driver_id]}\n💵Премия: {bonus:.2f}\n💼Зарплата: {total_salary:.2f} \n\n'

    return mes
    


