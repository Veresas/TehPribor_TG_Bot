from app.database.models import async_session
import app.database.models as tb
from sqlalchemy import select
import logging

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
    user = await session.scalar(select(tb.User).where(tb.User.tg_id == tg_id))

    return user is None


@conection
async def reg_user(session, data)-> None:


