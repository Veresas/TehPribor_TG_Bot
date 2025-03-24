from aiogram.filters import BaseFilter
from aiogram.types import Message
import app.database.requests as rq

class RoleFilter(BaseFilter):
    def __init__(self, role: str):
        self.role = role

    async def __call__(self, message: Message) -> bool:
        user_role = await rq.get_user_role(tg_id=message.from_user.id)
        return user_role == self.role