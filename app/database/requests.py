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
async def cheсk_user(session, tg_id)-> bool:
    user = await session.scalar(select(tb.User).where(tb.User.tgId == tg_id))

    return user is None


@conection
async def reg_user(session, data, tg_id)-> None:
    role = await session.scalar(select(tb.Role).where(tb.Role.idRole == data['role']))

    new_user = tb.User(
        tgId = tg_id,
        phone=data.get("number"),
        fio=data.get("fio"),
        age=data.get("age"),
        roleId = role.idRole
    )

    session.add(new_user)

@conection
async def get_cargo_types(session, data):
    result = await session.execute(select(tb.CargoType))
    cargo_types = result.scalars().all()
    return {cargo.idCargoType: cargo.cargoTypeName for cargo in cargo_types}

@conection
async def get_cargo_type_name_by_id(session, data):
    cargo_type_name = await session.scalar(select(tb.CargoType.cargoTypeName).where(tb.CargoType.idCargoType == data))

    return cargo_type_name



@conection
async def add_new_order(session, data)-> None:

    new_order = tb.Order(
        cargoName=data["cargo_name"],
        cargoDescription=data["cargo_description"],
        cargoTypeId=int(data["cargo_type_id"]),
        cargo_weight=float(data["cargo_weight"]),
        depart_loc=int(data["depart_loc"]),
        goal_loc=int(data["goal_loc"]),
        time=datetime.strptime(data["time"], '%H:%M %d.%m.%Y'),
        orderStatusId = 1
    )

    session.add(new_order)





