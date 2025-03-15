from app.database.models import async_session
import app.database.models as tb
from sqlalchemy import select, and_, update
import logging
from datetime import datetime, timedelta

def conection(func):
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

@conection
async def check_user(session, tg_id)-> bool:
    user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))

    return user is not None


@conection
async def reg_user(session, data, tg_id)-> None:
    role = await session.scalar(select(tb.Role).where(tb.Role.roleName == data['role']))

    new_user = tb.User(
        tgId = tg_id,
        phone=data.get("number"),
        fio=data.get("fio"),
        age=data.get("age"),
        roleId = role.idRole
    )

    session.add(new_user)

@conection
async def get_cargo_types(session):
    result = await session.execute(select(tb.CargoType))
    cargo_types = result.scalars().all()
    return {cargo.idCargoType: cargo.cargoTypeName for cargo in cargo_types}

@conection
async def get_cargo_type_name_by_id(session, data):
    cargo_type_name = await session.scalar(select(tb.CargoType).where(tb.CargoType.idCargoType == data))

    return cargo_type_name.cargoTypeName



@conection
async def add_new_order(session, data)-> None:
    disp_id = await session.scalar(select(tb.User).where(tb.User.tgId == data["tg_id"]))
    new_order = tb.Order(
        cargoName=data["cargo_name"],
        cargoDescription=data["cargo_description"],
        cargoTypeId=int(data["cargo_type_id"]),
        cargo_weight=float(data["cargo_weight"]),
        depart_loc=int(data["depart_loc"]),
        goal_loc=int(data["goal_loc"]),
        time=datetime.strptime(data["time"], '%H:%M %d.%m.%Y'),
        orderStatusId = 1,
        dispatcherId = disp_id.idUser,
        driverId=None
    )

    session.add(new_order)

statuses = {
    1: "Доступен",
    2: "В работе",
    3: "Завершен"
}

@conection
async def get_order_keys(session, dateTime: datetime = None, tg_id = None, isActual = False):

    stmt = select(tb.Order).order_by(tb.Order.time)
    if tg_id == None:
        if(dateTime != None):
            start_time = dateTime
            end_time = dateTime + timedelta(days=1)
            stmt = stmt.where(and_(tb.Order.time > start_time,
                                    tb.Order.time < end_time))

    else:
        user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
        match user.roleId:
            case 1: #Диспетчер
                role_condition= tb.Order.dispatcherId == user.idUser
            case 2:  # Водитель
                role_condition = tb.Order.driverId == user.idUser
            case _:
                raise ValueError(f"Роль {user.roleId} не поддерживается")
        
        stmt = stmt.where(role_condition)

        if isActual:
            stmt = stmt.where(tb.Order.orderStatusId.in_([1,2]))
            
    result = await session.execute(stmt)
    orders = result.scalars().all()    
    
    order_keys = []
    for order in orders:
        order_keys.append(order.idOrder)
    return order_keys

@conection
async def get_orders(session, ordersKeys, start: int, end: int):
    actiual_order_list = ordersKeys[start:end]
    stmt = select(tb.Order).order_by(tb.Order.time).where(tb.Order.idOrder.in_(actiual_order_list))
    result = await session.execute(stmt)
    orders = result.scalars().all()    
    
    formatted_orders = []
    for order in orders:
        formatted_order = form_order(order=order)
        formatted_orders.append(formatted_order)
    return formatted_orders

def form_order(order, status = None, witoutStatus = False)-> str:
    if witoutStatus:
                formatted_order = (
                f"Заказ #{order.idOrder}:\n"
                f"Груз '{order.cargoName}'\n"
                f"Описание: '{order.cargoDescription}'\n"
                f"Время: {order.time.strftime('%Y-%m-%d %H:%M')}\n"
            )
    else:
        if status == None:
            status = statuses.get(order.orderStatusId)
        formatted_order = (
                f"Заказ #{order.idOrder}:\n"
                f"Груз '{order.cargoName}'\n"
                f"Описание: '{order.cargoDescription}'\n"
                f"Время: {order.time.strftime('%Y-%m-%d %H:%M')}\n"
                f"Статус: {status}\n"
            )
    return formatted_order

@conection
async def get_user_role(session, tg_id):
    user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
    role = await session.scalar(select(tb.Role).where(tb.Role.idRole == user.roleId))
    return role.roleName

@conection
async def chek_next_record(session, end)-> bool:
    limit = 1
    offset = end - 1
    stmt = select(tb.Order).order_by(tb.Order.time).limit(limit).offset(offset)
    result = await session.execute(stmt)
    order = result.scalar()
    return order is not None

@conection
async def take_order(session, tg_id, order_id)-> bool:

    if await check_order_status(order_id=order_id, expectStatus = 1):
        user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
        new_data={
            "driverId": user.idUser,
            "orderStatusId": 2
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

@conection
async def check_order_status(session, order_id, expectStatus)-> bool:

    order = await session.scalar(select(tb.Order).where(tb.Order.idOrder == order_id))

    return order.orderStatusId == expectStatus

@conection
async def get_user_for_send(session, orderId, driver_id, action_text: str):
    order = await session.scalar(select(tb.Order).where(tb.Order.idOrder == orderId))
    disp = await session.scalar(select(tb.User).where(tb.User.idUser == order.dispatcherId))
    driver = await session.scalar(select(tb.User).where(tb.User.tgId == driver_id))
    formatted_order = form_order(order=order, witoutStatus=True)
    fromatted_mes = (
        f"Траспортировщик {driver.fio}\n"
        f"Телефон: {driver.phone}\n"
        f"{action_text}:\n"
    )
    final_message = fromatted_mes + formatted_order
    return disp.tgId, final_message

@conection
async def complete_order(session, tg_id, order_id)-> bool:

    if await check_order_status(order_id=order_id, expectStatus= 2):
        user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))
        new_data={
            "orderStatusId": 3
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