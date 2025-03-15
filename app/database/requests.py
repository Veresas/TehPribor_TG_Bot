from app.database.models import async_session
import app.database.models as tb
from sqlalchemy import select
import logging
from datetime import datetime

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
async def get_orders(session, start: int, end: int):
    limit = end - start + 1
    offset = start - 1
    stmt = select(tb.Order).order_by(tb.Order.time).limit(limit).offset(offset)
    result = await session.execute(stmt)
    orders = result.scalars().all()    
    
    order_keys = []
    formatted_orders = []
    for order in orders:
        status = statuses.get(order.orderStatusId)
        formatted_order = (
            f"Заказ #{order.idOrder}:\n"
            f"Груз '{order.cargoName}'\n"
            f"Описание: '{order.cargoDescription}'\n"
            f"Время: {order.time.strftime('%Y-%m-%d %H:%M')}\n"
            f"Статус: {status}\n"
        )
        formatted_orders.append(formatted_order)
        order_keys.append(order.idOrder)
    return formatted_orders, order_keys

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



