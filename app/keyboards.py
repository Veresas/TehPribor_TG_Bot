from aiogram.types import (ReplyKeyboardMarkup, KeyboardButton, 
                           InlineKeyboardMarkup, InlineKeyboardButton,)
from aiogram.utils.keyboard import InlineKeyboardBuilder
import app.database.requests as rq

main = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='Экран заказов'),
                                      KeyboardButton(text='Помощь')]], 
                            resize_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')

order_list_categori = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='Сегодня'),
                                      KeyboardButton(text='Завтра')],
                                      [KeyboardButton(text='Все')]], 
                            resize_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')

roles = InlineKeyboardMarkup(inline_keyboard= [
    [InlineKeyboardButton(text="Диспетчер", callback_data='role_disp')],
    [InlineKeyboardButton(text="Транспортировщик", callback_data='role_driver')]
])

bothelper = InlineKeyboardMarkup(inline_keyboard=[
    [InlineKeyboardButton(text='Как сделать заказ?', 
                          callback_data='Do_Order')],
    [InlineKeyboardButton(text='Как взять заказ в работу?', 
                          callback_data='Take_Order')],
    [InlineKeyboardButton(text='Как пользоваться экраном заказа?', 
                          callback_data='Orders_screen')]])

get_number = ReplyKeyboardMarkup(keyboard=
    [[KeyboardButton(text='Отправить номер', request_contact=True)]],
    resize_keyboard=True)

async def cargo_types_keyboard():
    cargo_types = await rq.get_cargo_types()

    keyboard = InlineKeyboardBuilder()
    for cargo_id, cargo_name in cargo_types.items():
        keyboard.add(InlineKeyboardButton(text=cargo_name, callback_data=f'cargo_{cargo_id}'))
    return keyboard.adjust(1).as_markup()

orderKey = InlineKeyboardMarkup(inline_keyboard = [
    [InlineKeyboardButton(text='Подтвердить', callback_data=f'cmd_order_accept'),
     InlineKeyboardButton(text='Отменить', callback_data=f'cmd_order_cancel')]
])

regKey = InlineKeyboardMarkup(inline_keyboard = [
    [InlineKeyboardButton(text='Подтвердить', callback_data=f'cmd_register_accept'),
     InlineKeyboardButton(text='Отменить', callback_data=f'cmd_register_cancel')]
])

async def order_select_keyboard(user_role, order_keys, start, end):
    actiual_order_list = order_keys[start:end]
    size = len(order_keys)
    keyboard = InlineKeyboardBuilder()
    if(user_role == "Водитель"):
        for kye in actiual_order_list:
            keyboard.add(InlineKeyboardButton(text=kye, callback_data=f'take_order:{kye}'))
    if start > 5:
        keyboard.add(InlineKeyboardButton(text="<", callback_data=f'order_move_back'))
    if (size - (end + 1) > 5):
        keyboard.add(InlineKeyboardButton(text=">", callback_data=f'order_move_forward'))
    
    return keyboard.adjust(1).as_markup()

