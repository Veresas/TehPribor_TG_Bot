from app.database.models import async_session
from app.database.models import User, Client, Driver, Cargo
from sqlalchemy import select

def conection(func):
    async def inner(*args, **kwargs):
        async with async_session() as session:
            return await func(session, *args, **kwargs)
    return inner

@conection
async def set_user(session, tg_id)-> None:
    user = await session.scalar(select(User).where(User.tg_id == tg_id))

    if not user:
        session.add(User(tg_id=tg_id))
        await session.commit()

