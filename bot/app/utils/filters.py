from aiogram.filters import BaseFilter
from aiogram.types import Message
import app.database.requests as rq

from aiogram.filters import BaseFilter
from aiogram.types import Message, CallbackQuery

from typing import Union, List
from aiogram.filters import BaseFilter
from aiogram.types import Message, CallbackQuery

class RoleFilter(BaseFilter):
    def __init__(
        self,
        roles: Union[str, List[str]],
        deny_message: str = "🚫 У вас нет доступа к этой функции."
    ):
        if isinstance(roles, str):
            roles = [role.strip() for role in roles.split(",")]
        self.roles = roles
        self.deny_message = deny_message

    async def __call__(self, obj) -> bool:
        user_id = None
        send_method = None
        
        if isinstance(obj, Message):
            user_id = obj.from_user.id
            send_method = obj.answer
        elif isinstance(obj, CallbackQuery):
            user_id = obj.from_user.id
            send_method = obj.message.answer

        if user_id:
            user_role = await rq.get_user_role(tg_id=user_id)
            if user_role in self.roles:
                return True

            if send_method:
                await send_method(self.deny_message)
            return False

        return False

class AccessFilter(BaseFilter):
    def __init__(
        self,
        deny_message: str = "🚫 Ваш доступ в систему ограничен. Обратитесь к администратору."
    ):
        self.deny_message = deny_message
        self.public_commands = ["/start", "/register"]
    async def __call__(self, obj: Union[Message, CallbackQuery]) -> bool:
        user_id = None
        send_method = None

        user_id = obj.from_user.id
        send_method = obj.answer
        if not obj.text:
            return True
        
        if any(obj.text.startswith(cmd) for cmd in self.public_commands) or obj.text[0] != '/':
            return True
        
        if not user_id:
            return False
        user = await rq.get_user(tg_id=user_id)

        # Если пользователь не найден или доступ запрещён
        if not user or user.is_denied:
            if send_method:
                await send_method(self.deny_message)
            return False
            
        return True