from aiogram.types import (ReplyKeyboardMarkup, KeyboardButton, 
                           InlineKeyboardMarkup, InlineKeyboardButton,)
from aiogram.utils.keyboard import InlineKeyboardBuilder

main = ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text='Диспетчер')], 
                                     [KeyboardButton(text='Транспортировщик')],
                                     [KeyboardButton(text='Экран заказов'),
                                      KeyboardButton(text='Помощь')]], 
                            resize_keyboard=True,
                            input_field_placeholder='Выберите пункт меню...')



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

cargo_types = {
    "details": "Детали",
    "assemblies": "Сборочные единицы",
    "final_assemblies": "Окончательные сборки",
    "materials": "Материалы, комплектующие, ПКИ",
    "water": "Вода",
    "waste": "Производственные отходы",
    "household_waste": "Бытовые отходы",
    "tools": "Инструменты, оснастка",
    "other": "Прочее",
}

async def cargo_types_keyboard():
    keyboard = InlineKeyboardBuilder()
    for key, value in cargo_types.items():
        keyboard.add(InlineKeyboardButton(text=value, callback_data=f'cargo_{key}'))
    return keyboard.adjust(1).as_markup()

orderKey = InlineKeyboardMarkup(keyboard = [
    [InlineKeyboardButton(text='Подтвердить', callback_data=f'cmd_order_accept'),
     InlineKeyboardButton(text='Отменить', callback_data=f'cmd_order_cancel')]
])