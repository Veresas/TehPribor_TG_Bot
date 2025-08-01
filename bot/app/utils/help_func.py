from aiogram import Bot
from aiogram.fsm.context import FSMContext
from aiogram.types import BotCommand

import app.database.requests as rq
async def push_scene(state: FSMContext, *, message_id: int, text: str, keyboard, state_name: str):
       data = await state.get_data()
       history = data.get("history", [])

       history.append({
              "message_id": message_id,
              "text": text,
              "keyboard": keyboard,
              "state": state_name
       })

       await state.update_data(history=history)

async def pop_scene(state: FSMContext):
       data = await state.get_data()
       history = data.get("history", [])

       if len(history) < 2:
              return None  # Нечего откатывать

       # Удаляем текущий экран
       history.pop()

       # Берем предыдущий
       last_scene = history[-1]

       await state.update_data(history=history)
       await state.set_state(last_scene["state"])

       return last_scene

COMMANDS_BY_ROLE = {
    "Диспетчер": [
       BotCommand(command="start", description="Запустить бота"),
       BotCommand(command="help", description="Помощь"),
       BotCommand(command="my_orders", description="Ваш список заказов"),
       BotCommand(command="orders", description="Список всех заказов"),
       BotCommand(command="new_order", description="Создание нового заказа"),
       BotCommand(command="cancel", description="Отмена команды"),
    ],
    "Водитель": [
       BotCommand(command="start", description="Запустить бота"),
       BotCommand(command="help", description="Помощь"),
       BotCommand(command="my_orders", description="Ваш список заказов"),
       BotCommand(command="orders", description="Список всех доступных заказов"),
       BotCommand(command="cancel", description="Отмена команды"),
    ],
    "Администратор": [
       BotCommand(command="start", description="Запустить бота"),
       BotCommand(command="help", description="Помощь"),
       BotCommand(command="my_orders", description="Ваш список заказов"),
       BotCommand(command="orders", description="Список всех заказов"),
       BotCommand(command="new_order", description="Создание нового заказа"),
       BotCommand(command="cancel", description="Отмена команды"),
       BotCommand(command="export", description="Импорт данных о заказах в Exel"),
       BotCommand(command="admin_panel", description="Панель администратора"),
       BotCommand(command="reload_comand", description="Обновление списка команд"),
       BotCommand(command="change_role", description="Смена роли"),
       BotCommand(command="drivers_salary", description="Выписка зарплат транспортировщиков")
    ],
    "Мастер_админ": [
       BotCommand(command="start", description="Запустить бота"),
       BotCommand(command="help", description="Помощь"),
       BotCommand(command="my_orders", description="Ваш список заказов"),
       BotCommand(command="orders", description="Список всех заказов"),
       BotCommand(command="new_order", description="Создание нового заказа"),
       BotCommand(command="cancel", description="Отмена команды"),
       BotCommand(command="export", description="Импорт данных о заказах в Exel"),
       BotCommand(command="admin_panel", description="Панель администратора"),
       BotCommand(command="reload_comand", description="Обновление списка команд"),
       BotCommand(command="change_role", description="Смена роли"),
       BotCommand(command="drivers_salary", description="Выписка зарплат транспортировщиков"),
       BotCommand(command="add_building", description="Добавление корпуса"),
       BotCommand(command="add_department", description="Добавление отдела"),
       BotCommand(command="add_department_and_building", description="Добавление отдела и корпуса")
    ]
}

async def set_user_commands(bot: Bot, tg_id: int):
    role = await rq.get_user_role(tg_id=tg_id)
    commands = COMMANDS_BY_ROLE.get(role)
    await bot.set_my_commands(commands, scope={"type": "chat", "chat_id": tg_id})

def clean_user_input(text: str) -> str:
    return text.replace('<', '‹').replace('>', '›')