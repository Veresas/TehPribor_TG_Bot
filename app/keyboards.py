from aiogram.types import (ReplyKeyboardMarkup, KeyboardButton, 
                           InlineKeyboardMarkup, InlineKeyboardButton,)
from aiogram.utils.keyboard import InlineKeyboardBuilder, ReplyKeyboardBuilder
import app.database.requests as rq

main = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='📦 Экран заказов'),
                                      KeyboardButton(text='Помощь')]], 
                            resize_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')

choseOrderStatusList = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='Доступен'),
                                      KeyboardButton(text='В работе')],
                                      [KeyboardButton(text='Завершен'),
                                      KeyboardButton(text='Все')]], 
                            resize_keyboard=True,
                            one_time_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')

roles = InlineKeyboardMarkup(inline_keyboard= [
    [InlineKeyboardButton(text="Диспетчер", callback_data='role_disp')],
    [InlineKeyboardButton(text="Транспортировщик", callback_data='role_driver')],
    [InlineKeyboardButton(text="Администратор", callback_data='role_admin')]
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

exportchoice = InlineKeyboardMarkup(inline_keyboard = [
    [InlineKeyboardButton(text='Заказы', callback_data=f'export:orders'),
     InlineKeyboardButton(text='Транспортировщики', callback_data=f'export:drivers')]
])

publicCatalogKey = InlineKeyboardMarkup(inline_keyboard = [
    [InlineKeyboardButton(text='Подтвердить взятие заказа', callback_data=f'accept_take_order')]
])

async def order_select_keyboard(data, isHistoruPraviteCatalog = False, isPrivatCatalog = False):
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
    
    if(data["userRole"] != "Водитель" and isPrivatCatalog):
        for kye in actiual_order_list:
            if await rq.check_order_status(order_id=kye,expectStatus=[1]):
                keyboard.add(InlineKeyboardButton(text=str(kye), callback_data=f'cmd_choice_order:{kye}'))

    if start >= 5:
        keyboard.add(InlineKeyboardButton(text="<", callback_data=f'order_move_back'))
    if (size - end>= 1):
        keyboard.add(InlineKeyboardButton(text=">", callback_data=f'order_move_forward'))
    
    return keyboard.adjust(1).as_markup()

async def dispPrivetOrdersKey(orderId):
    keyboard = InlineKeyboardBuilder()
    keyboard.add(InlineKeyboardButton(text="Редактировать", callback_data=f'cmd_edit_order:{orderId}'))
    keyboard.add(InlineKeyboardButton(text="Отменить", callback_data=f'cmd_cancel_order:{orderId}'))
    return keyboard.as_markup()


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
        one_time_keyboard=True,
        input_field_placeholder='Выберите пункт меню...'
    )
    return order_list_categori


private_order_list_kb = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='Активные заказы'),
                                      KeyboardButton(text='История заказов')]], 
                            resize_keyboard=True,
                            one_time_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')

async def alarm_kb(orderId):
    keyboard = InlineKeyboardBuilder()
    keyboard.add(InlineKeyboardButton(text=str("Взять заказ"), callback_data=f'cmd_take_alarm_order:{orderId}'))
    return keyboard.as_markup()


edit_order_keyboard = InlineKeyboardMarkup(inline_keyboard=[
        [
            InlineKeyboardButton(
                text="📦 Груз",
                callback_data=f"edit_order_cargo"
            )
        ],
        [
            InlineKeyboardButton(
                text="📝 Описание",
                callback_data=f"edit_order_description"
            )
        ],
        [
            InlineKeyboardButton(
                text="⚖️ Вес",
                callback_data=f"edit_order_weight"
            )
        ],
        [
            InlineKeyboardButton(
                text="📌 Тип",
                callback_data=f"edit_order_type"
            )
        ],
        [
            InlineKeyboardButton(
                text="📍 Отправление",
                callback_data=f"edit_order_departure"
            )
        ],
        [
            InlineKeyboardButton(
                text="🏁 Доставка",
                callback_data=f"edit_order_delivery"
            )
        ],
        [
            InlineKeyboardButton(
                text="🕒 Дата/время",
                callback_data=f"edit_order_time"
            )
        ],
                [
            InlineKeyboardButton(
                text="Сохранить изменения",
                callback_data=f"edit_order_fin"
            )
        ],
    ])

exp_orders_kb = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='День'),
                                      KeyboardButton(text='Неделя')],
                                      [KeyboardButton(text='Месяц'),
                                      KeyboardButton(text="Год")],
                                      [KeyboardButton(text="Свой")]], 
                            resize_keyboard=True,
                            one_time_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')

async def dayEndKb (orderId):
    keyboard = InlineKeyboardBuilder()
    keyboard.add(InlineKeyboardButton(text=str("Перенести заказ"), callback_data=f'cmd_postpend_order:{orderId}'))
    keyboard.add(InlineKeyboardButton(text=str("Отменить заказ"), callback_data=f'cmd_disp_cancel_order:{orderId}'))
    return keyboard.adjust(2).as_markup()

shearGPS = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text="Поделиться геопозицией", request_location=True)]],
                                resize_keyboard=True, one_time_keyboard=True)

async def rateKey(orderId):
    rateKey = InlineKeyboardMarkup(inline_keyboard=[
        [
            InlineKeyboardButton(text='1', callback_data=f'cmd_rate:1:{orderId}'),
            InlineKeyboardButton(text='2', callback_data=f'cmd_rate:2:{orderId}'),
            InlineKeyboardButton(text='3', callback_data=f'cmd_rate:3:{orderId}'),
            InlineKeyboardButton(text='4', callback_data=f'cmd_rate:4:{orderId}'),
            InlineKeyboardButton(text='5', callback_data=f'cmd_rate:5:{orderId}')
        ]
    ])
    return rateKey

departments = InlineKeyboardMarkup(inline_keyboard=[
    [InlineKeyboardButton(text='21', callback_data='departments:21'),
     InlineKeyboardButton(text='25', callback_data='departments:25'),
     InlineKeyboardButton(text='30', callback_data='departments:30'),
     InlineKeyboardButton(text='31', callback_data='departments:31')],
    [InlineKeyboardButton(text='35', callback_data='departments:35'),
     InlineKeyboardButton(text='39', callback_data='departments:39'),
     InlineKeyboardButton(text='79', callback_data='departments:79'),
     InlineKeyboardButton(text='946', callback_data='departments:946')]
])

workshops = InlineKeyboardMarkup(inline_keyboard=[
    [InlineKeyboardButton(text='6', callback_data='workshops:6'),
     InlineKeyboardButton(text='9', callback_data='workshops:9'),
     InlineKeyboardButton(text='41', callback_data='workshops:41'),
     InlineKeyboardButton(text='43', callback_data='workshops:43')],
    [InlineKeyboardButton(text='44', callback_data='workshops:44'),
     InlineKeyboardButton(text='45', callback_data='workshops:45'),
     InlineKeyboardButton(text='46', callback_data='workshops:46'),
     InlineKeyboardButton(text='51', callback_data='workshops:51')],
    [InlineKeyboardButton(text='52', callback_data='workshops:52'),
     InlineKeyboardButton(text='58', callback_data='workshops:58'),
     InlineKeyboardButton(text='59', callback_data='workshops:59'),
     InlineKeyboardButton(text='61', callback_data='workshops:61')],
    [InlineKeyboardButton(text='64', callback_data='workshops:64'),
     InlineKeyboardButton(text='72', callback_data='workshops:72'),
     InlineKeyboardButton(text='945', callback_data='workshops:945')]
])

warehouses = InlineKeyboardMarkup(inline_keyboard=[
    [InlineKeyboardButton(text='6', callback_data='warehouses:6'),
     InlineKeyboardButton(text='14', callback_data='warehouses:14'),
     InlineKeyboardButton(text='44', callback_data='warehouses:44'),
     InlineKeyboardButton(text='79', callback_data='warehouses:79')]
])

others = InlineKeyboardMarkup(inline_keyboard=[
    [InlineKeyboardButton(text='8', callback_data='others:8'),
     InlineKeyboardButton(text='13', callback_data='others:13'),
     InlineKeyboardButton(text='40', callback_data='others:40'),
     InlineKeyboardButton(text='53', callback_data='others:53')],
    [InlineKeyboardButton(text='71', callback_data='others:71'),
     InlineKeyboardButton(text='77', callback_data='others:77'),
     InlineKeyboardButton(text='80', callback_data='others:80')]
])