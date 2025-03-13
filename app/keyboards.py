from aiogram.types import (ReplyKeyboardMarkup, KeyboardButton, 
                           InlineKeyboardMarkup, InlineKeyboardButton)

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