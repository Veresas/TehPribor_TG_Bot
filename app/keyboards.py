from aiogram.types import (ReplyKeyboardMarkup, KeyboardButton, 
                           InlineKeyboardMarkup, InlineKeyboardButton,)
from aiogram.utils.keyboard import InlineKeyboardBuilder, ReplyKeyboardBuilder
import app.database.requests as rq

main = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='📦 Экран заказов'),
                                      KeyboardButton(text='Помощь')]], 
                            resize_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')

choseOrderStatusList = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='Доступные'),
                                      KeyboardButton(text='В работе')],
                                      [KeyboardButton(text='Завершенные'),
                                      KeyboardButton(text='Все')]], 
                            resize_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')

roles = InlineKeyboardMarkup(inline_keyboard= [
    [InlineKeyboardButton(text="Диспетчер", callback_data='role_disp')],
    [InlineKeyboardButton(text="Транспортировщик", callback_data='role_driver')]
])

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

photoQuestKey = InlineKeyboardMarkup(inline_keyboard = [
    [InlineKeyboardButton(text='Да', callback_data=f'cmd_photo_quest_accept'),
     InlineKeyboardButton(text='Нет', callback_data=f'cmd_photo_quest_cancel')]
])

alarmOrderKey = InlineKeyboardMarkup(inline_keyboard = [
    [InlineKeyboardButton(text='Да', callback_data=f'cmd_alarm_order_accept'),
     InlineKeyboardButton(text='Нет', callback_data=f'cmd_alarm_order_cancel')]
])


dateOrder = InlineKeyboardMarkup(inline_keyboard = [
    [InlineKeyboardButton(text='Сегодня', callback_data=f'date_order:today'),
     InlineKeyboardButton(text='Завтра', callback_data=f'date_order:tomorow')],
])

hourOrder = InlineKeyboardMarkup(inline_keyboard=[
    [InlineKeyboardButton(text='7', callback_data='hour_date_order:07'),
     InlineKeyboardButton(text='8', callback_data='hour_date_order:08')],
    [InlineKeyboardButton(text='9', callback_data='hour_date_order:09'),
     InlineKeyboardButton(text='10', callback_data='hour_date_order:10')],
    [InlineKeyboardButton(text='11', callback_data='hour_date_order:11'),
     InlineKeyboardButton(text='12', callback_data='hour_date_order:12')],
    [InlineKeyboardButton(text='13', callback_data='hour_date_order:13'),
     InlineKeyboardButton(text='14', callback_data='hour_date_order:14')],
    [InlineKeyboardButton(text='15', callback_data='hour_date_order:15'),
     InlineKeyboardButton(text='16', callback_data='hour_date_order:16')],
    [InlineKeyboardButton(text='17', callback_data='hour_date_order:17'),
     InlineKeyboardButton(text='18', callback_data='hour_date_order:18')]
])

minuteOrder = InlineKeyboardMarkup(inline_keyboard=[
    [InlineKeyboardButton(text='00', callback_data='minute_date_order:00'),
     InlineKeyboardButton(text='15', callback_data='minute_date_order:15')],
    [InlineKeyboardButton(text='30', callback_data='minute_date_order:30'),
     InlineKeyboardButton(text='45', callback_data='minute_date_order:45')]
])

privateCatalogKey = InlineKeyboardMarkup(inline_keyboard = [
    [InlineKeyboardButton(text='Выполнить', callback_data=f'accept_complete_order'),
     InlineKeyboardButton(text='Отказаться', callback_data=f'take_off_complete_order')],
    [InlineKeyboardButton(text='Посмотреть фото', callback_data=f'wath_photo_complete_order')]
])

publicCatalogKey = InlineKeyboardMarkup(inline_keyboard = [
    [InlineKeyboardButton(text='Подтвердить взятие заказа', callback_data=f'accept_take_order')]
])

async def order_select_keyboard(data, isHistoruPraviteCatalog = False):
    order_keys = data["orderList"]
    start =data["indexStart"]
    end=data["indexEnd"]
    button_text = data["button_text"]
    actiual_order_list =order_keys[start:end]
    size = len(order_keys)
    keyboard = InlineKeyboardBuilder()
    if(data["userRole"] == "Водитель" and not isHistoruPraviteCatalog):
        for kye in actiual_order_list:
            keyboard.add(InlineKeyboardButton(text=str(kye), callback_data=f'{button_text}:{kye}'))
    if start >= 5:
        keyboard.add(InlineKeyboardButton(text="<", callback_data=f'order_move_back'))
    if (size - end>= 1):
        keyboard.add(InlineKeyboardButton(text=">", callback_data=f'order_move_forward'))
    
    return keyboard.adjust(1).as_markup()

async def order_day(tg_id):
    user_role = await rq.get_user_role(tg_id=tg_id)
    builder = ReplyKeyboardBuilder()

    builder.add(KeyboardButton(text='Сегодня'))
    builder.add(KeyboardButton(text='Завтра'))
    if(user_role == "Диспетчер"):
        builder.add(KeyboardButton(text='Все'))

    builder.adjust(2, 1)

    order_list_categori = builder.as_markup(
        resize_keyboard=True,
        input_field_placeholder='Выберите пункт меню...'
    )
    return order_list_categori


private_order_list_kb = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='Активные заказы'),
                                      KeyboardButton(text='История заказов')]], 
                            resize_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')

async def alarm_kb(orderId):
    keyboard = InlineKeyboardBuilder()
    keyboard.add(InlineKeyboardButton(text=str("Взять заказ"), callback_data=f'cmd_take_alarm_order:{orderId}'))
    return keyboard.as_markup()