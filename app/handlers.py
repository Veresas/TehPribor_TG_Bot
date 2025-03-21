from aiogram import F, Router, Bot
from aiogram.types import Message, CallbackQuery, ReplyKeyboardRemove
from aiogram.filters import CommandStart, Command, StateFilter
from aiogram.fsm.state import State, StatesGroup
from aiogram.fsm.context import FSMContext
import app.validators as valid
import app.keyboards as kb
import app.database.requests as rq
import os
from datetime import datetime, timedelta
from aiogram.types import BotCommand
import logging

router = Router()

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
       BotCommand(command="export", description="Имопрт данных о заказах в Exel"),
    ],
}

async def set_user_commands(bot: Bot, tg_id: int):
    role = await rq.get_user_role(tg_id=tg_id)
    commands = COMMANDS_BY_ROLE.get(role)
    await bot.set_my_commands(commands, scope={"type": "chat", "chat_id": tg_id})

class Register(StatesGroup):
       role = State()
       pas = State()
       fio = State()
       number = State()
       final = State()

class Order(StatesGroup):
       cargo_name = State()
       cargo_description = State()
       cargo_type = State()
       cargo_weight = State()
       depart_loc = State()
       goal_loc = State()
       photo = State()
       alarm = State()
       time = State()
       final = State()

class Order_list(StatesGroup):
       order_ststus = State()
       start = State()
       end = State()

class Privat_order_list(StatesGroup):
       order_ststus = State()
       start = State()
       end = State()

class EditOrder(StatesGroup):
    select_field = State()
    edit_cargo_name = State()
    edit_cargo_description = State()
    edit_cargo_weight = State()
    edit_cargo_type = State()
    edit_depart_loc = State()
    edit_goal_loc = State()
    edit_time = State()
    confirm = State()

class ExportOrder(StatesGroup):
       choise = State()
       period_set = State()
       start = State()

@router.message(CommandStart())
async def cmd_start(message:Message):
       if await rq.check_user(tg_id=message.from_user.id):
              await message.answer('Добро пожаловать в программу оптимизации логистики!')
       else:
              await message.answer('Вы еще не зарегистрированы. Пожалуйста, введите /register')

@router.message(Command('reload_comand'))
async def register(message: Message, bot: Bot):
    try:
        await set_user_commands(bot, message.from_user.id)
        await message.answer('Список команд успешно обновлен')
    except Exception as e:
        logging.error(f"Ошибка обновления команд: {e}")
        await message.answer('Ошибка обновления команд, попробуйте позже')

@router.message(Command('register'))
async def register(message: Message, state:FSMContext):
       await state.clear()
       if await rq.check_user(tg_id=message.from_user.id):
               await message.answer('Вы уже зарегистрированы')
       else:
              await state.set_state(Register.role)
              await message.answer('Выберите роль. Для отмены регистрации введите /cancel', reply_markup = kb.roles)
             

@router.callback_query(Register.role, F.data.startswith('role_') )
async def register_role(calback: CallbackQuery, state: FSMContext):
       calbackRole = calback.data.split('_')[1]
       await state.update_data(role = calbackRole)
       await state.set_state(Register.pas)
       await calback.answer()
       await calback.message.answer('Введите выданный вам пароль', reply_markup=ReplyKeyboardRemove())

@router.message(Register.pas)
async def register_pas(message: Message, state:FSMContext):
       data = await state.get_data()
       match data['role']:
              case 'disp':
                     if message.text == os.getenv('DSPETCHER_PAS'):
                            await state.set_state(Register.fio)
                            await state.update_data(role='Диспетчер')
                            await message.answer('Введите ваше ФИО')
                     else:
                            await message.answer('Пароль неверный')
              case 'driver':
                     if message.text == os.getenv('DRIVERS_PAS'):
                            await state.set_state(Register.fio)
                            await state.update_data(role='Водитель')
                            await message.answer('Введите ваше ФИО')
                     else:
                            await message.answer('Пароль неверный')
              case 'admin':
                     if message.text == os.getenv('ADMIN_PAS'):
                            await state.set_state(Register.fio)
                            await state.update_data(role='Администратор')
                            await message.answer('Введите ваше ФИО')
                     else:
                            await message.answer('Пароль неверный')

@router.message(Command('cancel'), StateFilter('*'))
async def cancelCom(message: Message, state:FSMContext):
       await state.clear()
       await message.answer('Команда отменена', reply_markup=ReplyKeyboardRemove())

@router.message(Register.fio)
async def register_name (message: Message, state: FSMContext):
       if valid.valid_fio(message.text):
              await state.update_data(fio=message.text)
              await state.set_state (Register.number)
              await message.answer('Отправьте ваш номер телефона', reply_markup=kb.get_number)
       else:
              await message.answer('Введены некорректные данные. Ожидалась строка, содержащая 2 или 3 слова, начинающихся с большой буквы. Повторите попытку.')

@router.message(Register.number, F.contact)
async def register_number(message: Message, state: FSMContext):
       await state.update_data(tg_id=message.from_user.id)
       await state.update_data(number=message.contact.phone_number)
       await state.set_state(Register.final)
       data = await state.get_data()
       await message.answer(f'Ваше имя: {data["fio"]}\nВаш номер: {data["number"]}', reply_markup=kb.regKey)

@router.callback_query(Register.final, F.data == 'cmd_register_accept')
async def new_register_accept(callback: CallbackQuery, state: FSMContext, bot: Bot):
       data = await state.get_data()
       await callback.answer()
       
       await rq.reg_user(data=data, tg_id=data["tg_id"])
       await state.clear()
       await callback.answer()
       await callback.message.answer('Регистрация успешна. Для получения инструкции по использованию бота выберите /help')
       await set_user_commands(bot, data["tg_id"])

@router.callback_query(Register.final, F.data == 'cmd_register_cancel')
async def new_register_accept(callback: CallbackQuery, state: FSMContext):
       await state.clear()
       await callback.answer()
       await callback.message.answer('Регистрация отменена. Для повторной попытки введите /register')


#Создание нового заказа
@router.message(Command('new_order'))
async def order_creat_start(message: Message, state:FSMContext):
       await state.clear()
       userRole = await rq.get_user_role(tg_id=message.from_user.id)
       if(userRole != "Водитель"):
              await state.set_state(Order.cargo_name)
              await message.answer('Начало создания заказа. Введите название груза')
       else:
              await message.answer('Эта команда вам недоступна')

@router.message(Order.cargo_name)
async def order_cargo_name(message: Message, state:FSMContext):
       await state.update_data(cargo_name=message.text)
       await state.update_data(tg_id=message.from_user.id)
       await state.set_state(Order.cargo_description)
       await message.answer('Введите краткое описание груза при необходимости. В случае отсутствия описания введите "Нет"')

@router.message(Order.cargo_description)
async def order_cargo_description(message: Message, state:FSMContext):
       await state.update_data(cargo_description=message.text)
       await state.set_state(Order.cargo_type)
       await message.answer('Пожалуйста, выберите тип груза', reply_markup= await kb.cargo_types_keyboard())

@router.callback_query(Order.cargo_type, F.data.startswith('cargo_'))
async def order_cargo_type(callback: CallbackQuery, state: FSMContext):
       await callback.answer()
       cargo_key = callback.data.split("_")[1]
       await state.update_data(cargo_type_id = cargo_key)
       await state.set_state(Order.cargo_weight)
       await callback.message.answer('Введите вес груза (кг)', reply_markup=ReplyKeyboardRemove())

@router.message(Order.cargo_weight)
async def order_cargo_weight(message: Message, state: FSMContext):
       if valid.valid_weight(message.text):
              await state.update_data(cargo_weight = float(message.text))
              await state.set_state(Order.depart_loc)
              await message.answer('Введите номер цеха/корпуса отправления')
       else:
              await message.answer('Некорректные данные. Повторите попытку. Если число дробное - введите его через точку')
       
@router.message(Order.depart_loc)
async def order_depart_loc(message: Message, state: FSMContext):
       await state.update_data(depart_loc = message.text)
       await state.set_state(Order.goal_loc)
       await message.answer('Введите номер цеха/корпуса назначения')


@router.message(Order.goal_loc)
async def order_goal_loc(message: Message, state: FSMContext):    
       await state.update_data(goal_loc = message.text)
       await state.set_state(Order.photo)
       await message.answer('Хотите ли вы добавить фото к грузу?', reply_markup= kb.photoQuestKey)


@router.callback_query(Order.photo, F.data == ("cmd_photo_quest_accept"))
async def acept_order_photo(calback: CallbackQuery, state: FSMContext):
       await calback.answer()
       await calback.message.answer('Отправьте фото груза')

@router.callback_query(Order.photo, F.data == ("cmd_photo_quest_cancel"))
async def acept_order_photo(calback: CallbackQuery, state: FSMContext):
       await calback.answer()
       await state.set_state(Order.alarm)
       await calback.message.answer('Это срочный заказ?', reply_markup= kb.alarmOrderKey)

@router.message(Order.photo, F.photo)
async def get_order_photo(message: Message, state: FSMContext):
       file_id = message.photo[-1].file_id
       await state.update_data(photoId = file_id)
       await state.set_state(Order.alarm)
       await message.answer('Это срочный заказ?', reply_markup= kb.alarmOrderKey)

       
@router.callback_query(Order.alarm, F.data == "cmd_alarm_order_accept")
async def accept_alarm_order(calback: CallbackQuery, state: FSMContext):
       print("Устанвка срочности заказа")
       await calback.answer()
       await state.update_data(isUrgent= True)
       await state.set_state(Order.time)
       await calback.message.answer('Выберите день', reply_markup= kb.dateOrder)

@router.callback_query(Order.alarm, F.data == "cmd_alarm_order_cancel")
async def cancel_alarm_order(calback: CallbackQuery, state: FSMContext):
       await calback.answer()
       await state.update_data(isUrgent = False)
       await state.set_state(Order.time)
       await calback.message.answer('Выберите день', reply_markup= kb.dateOrder)

@router.callback_query(Order.time, F.data.startswith("date_order"))
async def date_order(calback: CallbackQuery, state: FSMContext):
       day = calback.data.split(':')[1]
       today = datetime.today()
       if day == "today":
              selected_date = today
       else:
              selected_date = today + timedelta(days=1)

       formatted_date = selected_date.strftime('%d.%m.%Y')
       await state.update_data(day=formatted_date)
       await calback.answer()
       await state.set_state(Order.time)
       await calback.message.edit_text('Выберите час', reply_markup= kb.hourOrder)

@router.callback_query(Order.time, F.data.startswith("hour_date_order"))
async def hour_date_order(calback: CallbackQuery, state: FSMContext):
       hour = calback.data.split(':')[1]
       await calback.answer(f'{hour}')
       await state.update_data(hour=hour)
       await calback.message.edit_text('Выберите минуту', reply_markup= kb.minuteOrder)

@router.callback_query(Order.time, F.data.startswith("minute_date_order"))
async def minute_date_order(calback: CallbackQuery, state: FSMContext):
       minute = calback.data.split(':')[1]
       await calback.answer(f'{minute}')
       data = await state.get_data()
       hour = data["hour"]
       day = data["day"]
       time = f'{hour}:{minute} {day}'
       await state.update_data(time = time)
       data = await state.get_data() 
       type_name = await rq.get_cargo_type_name_by_id(data=int(data["cargo_type_id"]))
       await state.set_state(Order.final)
       await calback.message.answer(f'Заказ \nНазвание груза: {data["cargo_name"]} \nОписание груза: {data["cargo_description"]} \nТип груза: {type_name} \nВес груза: {data["cargo_weight"]} \nЦех/корпус отправки: {data["depart_loc"]} '
              f'\nЦех/корпус назначения: {data["goal_loc"]} \nВремя забора груза: {data["time"]}', reply_markup = kb.orderKey)


@router.callback_query(Order.final, F.data == 'cmd_order_accept')
async def new_order_accept(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data() 
       order_id = await rq.add_new_order(data=data)
       print("Получение ордер айди", {order_id})
       if data["isUrgent"]:
              print("Активация функции оповищения")
              await rq.alarm_for_drivers(orderId=order_id, bot= callback.bot)
       await state.clear()
       await callback.answer()
       await callback.message.answer('Заказ успешно добавлен')

@router.callback_query(F.data.startswith('cmd_take_alarm_order:'))
async def alarm_order_take(callback: CallbackQuery):
       orderId = int(callback.data.split(':')[1])
       print("Получение заказа", orderId)
       driverId = callback.from_user.id
       print("ТГ ID водителя", driverId)
       await callback.answer()
       if await rq.take_order(tg_id=driverId, order_id=orderId):
              await callback.message.answer(f'Вы взяли заказ: {orderId}', reply_markup=ReplyKeyboardRemove())
              chat_id, mes = await rq.get_user_for_send(orderId=orderId, driver_id=driverId, action_text="Взятие в работу")
              await callback.message.bot.send_message(chat_id=chat_id, text=mes, parse_mode="HTML")
       else:
              await callback.message.answer("Заказ уже взят")

@router.callback_query(Order.final, F.data == 'cmd_order_cancel')
async def new_order_accept(callback: CallbackQuery, state: FSMContext):
       await state.clear()
       await callback.answer()
       await callback.message.answer('Добавление заказа отменено. Для повторной попытки введите /new_order')


#Просмотр каталога заказов
@router.message(Command("orders"))
async def order_catalog_choice(message: Message, state:FSMContext):
       await state.clear()

       userRole = await rq.get_user_role(tg_id=message.from_user.id)
       await state.update_data(indexStart = 0, indexEnd = 5, userRole = userRole, tg_id=message.from_user.id, button_text="take_order")  
       if(userRole != "Водитель"):
              await message.answer("Выберите требуемый статус у заказа", reply_markup=kb.choseOrderStatusList)
              await state.set_state(Order_list.order_ststus)
       else:
              await message.answer("Выберите, на какой день вы хотите просмотреть список заказов", reply_markup= await kb.order_day(message.from_user.id))
              await state.set_state(Order_list.start)

@router.message(Order_list.order_ststus, F.text.lower().in_(["доступен", "в работе", "завершен", "все"]))
async def status_order_catalog(message: Message, state:FSMContext):
       status = message.text.lower()
       if status == "доступен":
              await state.update_data(statusId = 1)
       elif status == "в работе":
              await state.update_data(statusId = 2)
       elif status == "завершен":
              await state.update_data(statusId = 3)
       
       await state.set_state(Order_list.start)
       await message.answer("Выберите, на какой день вы хотите просмотреть список заказов", reply_markup= await kb.order_day(message.from_user.id))


@router.message(Order_list.start, F.text.lower().in_(["сегодня", "завтра", "все"]))
async def order_catalog(message: Message, state:FSMContext):
       data = await state.get_data()
       if message.text.lower() == "сегодня":
              orderKyes = await rq.get_order_keys(dateTime=datetime.today().date(), tg_id=data["tg_id"], statusId=data.get("statusId", None))
       elif message.text.lower() == "завтра":
              orderKyes = await rq.get_order_keys(dateTime=datetime.today().date() + timedelta(days=1), tg_id=data["tg_id"], statusId=data.get("statusId", None))
       elif data["userRole"] != "Водитель":
              if message.text.lower() == "все" :
                     orderKyes = await rq.get_order_keys(tg_id=data["tg_id"])
              else: 
                     await message.answer("Вы не можете просмотреть эту категорию. Выберите одну из предоставленных")
       else:
              await message.answer("Вы не можете просмотреть эту категорию. Выберите одну из предоставленных")

       if len(orderKyes) != 0: 
              size = len(orderKyes)
              if size < 5:
                     await state.update_data(indexEnd = size)
              await state.update_data(orderList = orderKyes)
              data["orderList"] = orderKyes
              orders = await rq.get_orders(ordersKeys=orderKyes, start=0,end=5)
              mes = "\n".join(orders)
              data = await state.get_data()
              await message.answer(mes, reply_markup= await kb.order_select_keyboard(data=data), parse_mode="HTML")
       else:
              await message.answer("Заказов нет")

@router.callback_query(StateFilter(Order_list.start, Privat_order_list.start), F.data ==('order_move_back'))
async def order_move_back(callback: CallbackQuery, state: FSMContext):
       await callback.answer()
       data = await state.get_data()
       await state.update_data(indexStart = (data["indexStart"]-5), indexEnd = (data["indexEnd"]-5))
       orders = await rq.get_orders(ordersKeys= data["orderList"], start=data["indexStart"]-5, end=data["indexEnd"]-5)
       mes = "\n".join(orders)
       data["indexStart"] = (data["indexStart"]-5)
       data["indexEnd"] = (data["indexEnd"]-5)
       print(f'Пользоавтель {data["tg_id"]} с ролью {data["userRole"]} наживает назад при списке {data["orderList"]} и индексами начала = {data["indexStart"]} и конца = {data["indexEnd"]}')
       await callback.message.edit_text(mes, reply_markup= await kb.order_select_keyboard(data=data, isHistoruPraviteCatalog=data.get("isHistoruPraviteCatalog", False)), parse_mode="HTML")

@router.callback_query(StateFilter(Order_list.start, Privat_order_list.start), F.data == ('order_move_forward'))
async def order_move_back(callback: CallbackQuery, state: FSMContext):
       await callback.answer()
       data = await state.get_data()
       await state.update_data(indexStart = (data["indexStart"]+5), indexEnd = (data["indexEnd"]+5))
       orders = await rq.get_orders(ordersKeys= data["orderList"], start=data["indexStart"]+5, end=data["indexEnd"]+5)
       mes = "\n".join(orders)
       data["indexStart"] = (data["indexStart"]+5)
       data["indexEnd"] = (data["indexEnd"]+5)
       await callback.message.edit_text(mes, reply_markup= await kb.order_select_keyboard(data=data, isHistoruPraviteCatalog=data.get("isHistoruPraviteCatalog", False) ), parse_mode="HTML")

@router.callback_query(Order_list.start, F.data.startswith('take_order:'))
async def order_take(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await state.update_data(orderId = orderId)
       await callback.answer()
       await callback.message.answer(f'Вы выбрали заказ №{orderId}', reply_markup= kb.publicCatalogKey)


@router.callback_query(Order_list.start, F.data ==('accept_take_order'))
async def order_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       await callback.answer()
       try:
              if await rq.take_order(tg_id=data["tg_id"], order_id=int(data["orderId"])):
                     await callback.message.answer(f'Вы взяли заказ: {data["orderId"]}', reply_markup=ReplyKeyboardRemove())
                     chat_id, mes = await rq.get_user_for_send(orderId=int(data["orderId"]), driver_id=data["tg_id"], action_text="Взятие в работу")
                     await callback.message.bot.send_message(chat_id=chat_id, text=mes, parse_mode="HTML")
                     await state.clear()
              else:
                     await callback.message.answer(f'Этот заказ уже взят')
       except Exception as e:
              await callback.message.answer(f'При взятии заказа произошла ошибка. Попробуйте позже.')

#Личные каталоги доставщиков/диспетчеров
@router.message(Command("my_orders"))
async def private_order_catalog_choice(message: Message, state:FSMContext): 
       await state.clear()  

       userRole = await rq.get_user_role(tg_id=message.from_user.id)
       await state.update_data(indexStart = 0, indexEnd = 5, userRole = userRole, tg_id=message.from_user.id, button_text="complete_order")
       if userRole != "Водитель":
              await message.answer("Выберите требуемый статус у заказа", reply_markup=kb.choseOrderStatusList)
              await state.set_state(Privat_order_list.order_ststus)
       else:
              await message.answer("Выберите категорию списка заказов", reply_markup= kb.private_order_list_kb)
              await state.set_state(Privat_order_list.start)

@router.message(Privat_order_list.order_ststus, F.text.lower().in_(["доступен", "в работе", "завершен", "все"]))
async def status_order_catalog(message: Message, state:FSMContext):
       status = message.text.lower()
       if status == "доступен":
              await state.update_data(statusId = 1)
       elif status == "в работе":
              await state.update_data(statusId = 2)
       elif status == "завершен":
              await state.update_data(statusId = 3)
       
       await state.set_state(Privat_order_list.start)      
       await message.answer("Выберите категорию списка заказов", reply_markup= kb.private_order_list_kb)

@router.message(Privat_order_list.start, F.text.lower().in_(["активные заказы", "история заказов"]))
async def private_order_catalog(message: Message, state:FSMContext):
       data = await state.get_data()
       if message.text.lower() == "активные заказы":
              orderKyes = await rq.get_order_keys(tg_id=data["tg_id"], isActual=True, isPrivateCatalog=True, statusId=data.get("statusId", None))
              await state.update_data(isPrivatCatalog = True)
       elif message.text.lower() == "история заказов":
              orderKyes = await rq.get_order_keys(tg_id=data["tg_id"], isPrivateCatalog=True, statusId=data.get("statusId", None))
              await state.update_data(isHistoruPraviteCatalog = True)
       elif data["userRole"] != "Водитель":
              if message.text.lower() == "все" :
                     orderKyes = await rq.get_order_keys()
              else: 
                     await message.answer("Вы не можете просмотреть эту категорию. Выберите одну из предоставленных")
       else:
              await message.answer("Вы не можете просмотреть эту категорию. Выберите одну из предоставленных")

       if len(orderKyes) != 0:      
              size = len(orderKyes)
              if size < 5:
                     await state.update_data(indexEnd = size)
              await state.update_data(orderList = orderKyes)
              data["orderList"] = orderKyes
              orders = await rq.get_orders(ordersKeys=orderKyes, start=0,end=5)
              mes = "\n".join(orders)
              data = await state.get_data()
              await message.answer(mes, reply_markup= await kb.order_select_keyboard(data, isHistoruPraviteCatalog=data.get("isHistoruPraviteCatalog", False), isPrivatCatalog=data.get("isPrivatCatalog", False) ), parse_mode="HTML" )
       else:
              await message.answer("Заказов нет")

@router.callback_query(Privat_order_list.start, F.data.startswith('complete_order:'))
async def complete_take(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await state.update_data(orderId = orderId)
       await callback.answer()
       await callback.message.answer(f'Вы выбрали заказ №{orderId}', reply_markup= kb.privateCatalogKey)

@router.callback_query(Privat_order_list.start, F.data == ('accept_complete_order'))
async def acept_complete_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       await callback.answer()
       try:
              if await rq.complete_order(tg_id=data["tg_id"], order_id=int(data["orderId"])):
                     await callback.message.answer(f'Вы завершили заказ: {data["orderId"]}', reply_markup=ReplyKeyboardRemove())
                     chat_id, mes = await rq.get_user_for_send(orderId=int(data["orderId"]), driver_id=data["tg_id"], action_text="Завершение")
                     await callback.message.bot.send_message(chat_id=chat_id, text=mes, parse_mode="HTML")
                     await state.clear()
              else:
                     await callback.message.answer(f'Этот заказ уже завершен')
       except Exception as e:
              await callback.message.answer(f'При завершении заказа произошла ошибка. Попробуйте позже.')

@router.callback_query(Privat_order_list.start, F.data == ('take_off_complete_order'))
async def take_off_complete_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       await callback.answer()
       try:
              await rq.take_off_complete_order(tg_id=data["tg_id"], order_id=int(data["orderId"]))
              await callback.message.answer(f'Вы отказались от заказа: {data["orderId"]}', reply_markup=ReplyKeyboardRemove())
              chat_id, mes = await rq.get_user_for_send(orderId=int(data["orderId"]), driver_id=data["tg_id"], action_text="Отмена выполнения")
              await callback.message.bot.send_message(chat_id=chat_id, text=mes, parse_mode="HTML")
              await state.clear()
       except Exception as e:
              await callback.message.answer(f'При отказе от заказа произошла ошибка. Попробуйте позже.')

@router.callback_query(Privat_order_list.start, F.data == ('wath_photo_complete_order'))
async def wath_photo_complete_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       photoId  = await rq.get_order_photo(order_id=data["orderId"])
       await callback.answer()
       if photoId is not None:
              await callback.message.answer_photo(photoId )
       else:
              await callback.message.answer(f'У этого заказа нет фото')


@router.callback_query(Privat_order_list.start, F.data.startswith('cmd_edit_order:'))
async def edit_order(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await state.clear()
       await state.set_state(EditOrder.select_field)
       order = await rq.get_order(orderId=int(orderId))
       cargo_type = order.orderTypeName
       mes = f'Редактирование заказа\n'
       mes = mes + await rq.form_order(order=order, cargo_type=cargo_type)
       await state.update_data(order_id=orderId, order = order)
       await callback.answer()
       await callback.message.answer(mes, reply_markup= kb.edit_order_keyboard , parse_mode="HTML")

@router.callback_query(EditOrder.select_field, F.data.startswith("edit_order_"))
async def select_field_to_edit(callback: CallbackQuery, state: FSMContext):
    field = callback.data.split('_')[2]
    await state.update_data(editing_field=field)
    
    match field:
        case 'cargo':
            await state.set_state(EditOrder.edit_cargo_name)
            await callback.message.answer("Введите новое название груза:")

        case 'description':
            await state.set_state(EditOrder.edit_cargo_description)
            await callback.message.answer("Введите новое описание груза. Если описание не требуется, введите 'Нет':")

        case 'weight':
            await state.set_state(EditOrder.edit_cargo_weight)
            await callback.message.answer("Введите новый вес груза (кг). Если число дробное, используйте точку:")

        case 'type':
            await state.set_state(EditOrder.edit_cargo_type)
            await callback.message.answer("Выберите новый тип груза:", reply_markup=await kb.cargo_types_keyboard())

        case 'departure':
            await state.set_state(EditOrder.edit_depart_loc)
            await callback.message.answer("Введите новый номер цеха/корпуса отправления:")

        case 'delivery':
            await state.set_state(EditOrder.edit_goal_loc)
            await callback.message.answer("Введите новый номер цеха/корпуса назначения:")

        case 'time':
            await state.set_state(EditOrder.edit_time)
            await callback.message.answer("Выберите новую дату и время забора груза:", reply_markup=kb.dateOrder)

        case 'fin':
              try:
                     data = await state.get_data()
                     await rq.edit_order(data=data)
                     await callback.answer("Заказ успешно обнавлен")
                     await state.clear()
              except Exception as e:
                     await callback.answer("Ошибка при созранении изменений. Попробуйте позже")
        case _:
            await callback.answer("Неизвестное поле для редактирования.")
            return
        
    await callback.answer()

@router.message(EditOrder.edit_cargo_name)
async def process_edit_cargo_name(message: Message, state: FSMContext):
    new_cargo_name = message.text
    await state.update_data(edit_cargo_name=new_cargo_name) 
    await state.set_state(EditOrder.select_field) 
    await message.answer("Название груза обновлено.")

@router.message(EditOrder.edit_cargo_description)
async def process_edit_cargo_description(message: Message, state: FSMContext):
    new_cargo_description = message.text
    await state.update_data(edit_cargo_description=new_cargo_description)  
    await state.set_state(EditOrder.select_field) 
    await message.answer("Описание груза обновлено.")

@router.message(EditOrder.edit_cargo_weight)
async def process_edit_cargo_weight(message: Message, state: FSMContext):
    new_cargo_weight = message.text
    if valid.valid_weight(new_cargo_weight):
       await state.update_data(edit_cargo_weight=float(new_cargo_weight)) 
       await state.set_state(EditOrder.select_field) 
       await message.answer("Вес груза обновлен.")
    else:
       await message.answer('Некорректные данные. Повторите попытку. Если число дробное - введите его через точку') 

@router.callback_query(EditOrder.edit_cargo_type, F.data.startswith("cargo_"))
async def process_edit_cargo_type(callback: CallbackQuery, state: FSMContext):
    cargo_type_id = callback.data.split("_")[1]
    await state.update_data(edit_cargo_type_id=int(cargo_type_id))
    await state.set_state(EditOrder.select_field)
    await callback.message.answer("Тип груза обновлен.")
    await callback.answer()

@router.message(EditOrder.edit_depart_loc)
async def process_edit_depart_loc(message: Message, state: FSMContext):
       new_depart_loc = message.text

       await state.update_data(edit_depart_loc=new_depart_loc)
       await state.set_state(EditOrder.select_field)
       await message.answer("Место отправления обновлено.")


@router.message(EditOrder.edit_goal_loc)
async def process_edit_goal_loc(message: Message, state: FSMContext):
       new_goal_loc = message.text

       await state.update_data(edit_goal_loc=new_goal_loc)  
       await state.set_state(EditOrder.select_field)  
       await message.answer("Место доставки обновлено.")


@router.callback_query(EditOrder.edit_time, F.data.startswith("date_order"))
async def process_edit_date(callback: CallbackQuery, state: FSMContext):
    day = callback.data.split(':')[1]
    today = datetime.today()
    selected_date = today if day == "today" else today + timedelta(days=1)
    formatted_date = selected_date.strftime('%d.%m.%Y')

    await state.update_data(edit_day=formatted_date)  # Сохраняем новый день
    await callback.message.edit_text('Выберите час:', reply_markup=kb.hourOrder)
    await callback.answer()

@router.callback_query(EditOrder.edit_time, F.data.startswith("hour_date_order"))
async def process_edit_hour(callback: CallbackQuery, state: FSMContext):
    hour = callback.data.split(':')[1]
    await state.update_data(edit_hour=hour)  # Сохраняем новый час
    await callback.message.edit_text('Выберите минуту:', reply_markup=kb.minuteOrder)
    await callback.answer()

@router.callback_query(EditOrder.edit_time, F.data.startswith("minute_date_order"))
async def process_edit_time(callback: CallbackQuery, state: FSMContext):
    minute = callback.data.split(':')[1]
    data = await state.get_data()
    hour = data["edit_hour"]
    day = data["edit_day"]
    new_time = f'{hour}:{minute} {day}'

    await state.update_data(edit_time=new_time)  # Сохраняем новое время
    await state.set_state(EditOrder.select_field)  # Возвращаемся к выбору поля
    await callback.message.answer("Дата и время обновлены.")
    await callback.answer()

@router.message(Command('help'))
async def cmd_help(message: Message):
       user_role = await rq.get_user_role(tg_id=message.from_user.id)

       match user_role:
              case "Водитель":
                     mes = (
                            "📌 Инструкция по использованию бота\n\n"
                            "Работа с заказами:\n"
                            "Для просмотра доступных заказов используйте команду /orders. Выберите дату, после чего отобразится список заказов, "
                            "отсортированный по сроку взятия (от самого раннего к позднему).\n"
                            "Под списком могут отображаться до 5 кнопок с номерами заказов. Нажатие на кнопку означает принятие заказа.\n"
                            "Используйте стрелки внизу для пролистывания каталога.\n\n"
                            "Ваши заказы:\n"
                            "Для просмотра текущих принятых заказов используйте /my_orders.\n"
                            "Чтобы завершить заказ, найдите его в списке активных и нажмите соответствующую кнопку.\n\n"
                            "Отмена действий:\n"
                            "Для выхода из каталога без принятия заказа или отмены команды используйте /cancel."
                     )
              case "Диспетчер":
                     mes = (
                            "📌 Инструкция по использованию бота\n\n"
                            "Создание заказов:\n"
                            "Для создания нового заказа используйте команду /new_order.\n"
                            "Следуйте инструкциям по вводу данных. Проверьте корректность информации перед подтверждением.\n"
                            "В случае ошибки можно отменить заполнение и начать заново.\n\n"
                            "Просмотр заказов:\n"
                            "Используйте /orders для просмотра всех заказов на выбранную дату. "
                            "Заказы отсортированы по сроку взятия (от раннего к позднему). Можно пролистывать каталог стрелками.\n\n"
                            "Ваши заказы:\n"
                            "Используйте /my_orders для просмотра созданных вами заказов и их статуса выполнения.\n\n"
                            "Отмена действий:\n"
                            "Для выхода из каталога или отмены команды используйте /cancel.\n\n"
                            "Редактирование заказов:\n"
                            "Для редактирования заказов войдите в /my_orders -> доступен -> сегодня/завтра и нажмите на кнопку с номер заказа, который вы ходите отредактировать." 
                            "Появится описаие заказа с кнопками тем. Нажмите на нужный раздел заказа и введите данные."
                            "Если нужно изменить несколько разделов вернитесь к первоначальному описанию заказа и нажмите на нужный раздел"
                            "После внесения нужных изменений вернитесь к первоначальному описанию заказа и нажмите Сохранить изменения. Только после этого измения вступят в силу"
                     )
              case "Администратор":
                     mes = (
                            "📌 Инструкция по использованию бота\n\n"
                            "Создание заказов:\n"
                            "Для создания нового заказа используйте команду /new_order.\n"
                            "Следуйте инструкциям по вводу данных. Проверьте корректность информации перед подтверждением.\n"
                            "В случае ошибки можно отменить заполнение и начать заново.\n\n"
                            "Просмотр заказов:\n"
                            "Используйте /orders для просмотра всех заказов на выбранную дату. "
                            "Заказы отсортированы по сроку взятия (от раннего к позднему). Можно пролистывать каталог стрелками.\n\n"
                            "Ваши заказы:\n"
                            "Используйте /my_orders для просмотра созданных вами заказов и их статуса выполнения.\n\n"
                            "Отмена действий:\n"
                            "Для выхода из каталога или отмены команды используйте /cancel.\n\n"
                            "Редактирование заказов:\n"
                            "Для редактирования заказов войдите в /my_orders -> доступен -> сегодня/завтра и нажмите на кнопку с номер заказа, который вы ходите отредактировать." 
                            "Появится описаие заказа с кнопками тем. Нажмите на нужный раздел заказа и введите данные."
                            "Если нужно изменить несколько разделов вернитесь к первоначальному описанию заказа и нажмите на нужный раздел"
                            "После внесения нужных изменений вернитесь к первоначальному описанию заказа и нажмите Сохранить изменения. Только после этого измения вступят в силу\n\n"
                            "Экспорт в Excel:\n"
                            "Для экспорта данных о заказах в файл Excel нужно: выбрать команду /export и выбрать нужный период."
                            "Каждая из команд (день, неделя, месяц, год) отсчитывает от настоящего дня минус соответствующее число дней."
                     )

       await message.answer(mes)


@router.message(Command('export'))
async def cmd_export(message: Message, state: FSMContext):
       role = await rq.get_user_role(tg_id=message.from_user.id)
       if (role == "Администратор"):
              await message.answer("За какой период выгрузить данные?", reply_markup=kb.exp_orders_kb)
              await state.set_state(ExportOrder.choise)
       else:
              await message.answer("У вас не хватает прав доступа для использования этой команды")

@router.message(ExportOrder.choise, F.text.lower().in_(["день", "неделя", "месяц", "год"]))
async def status_order_catalog(message: Message, state:FSMContext):
       per = message.text.lower()
       match per:
              case "день":
                     date_from = datetime.now().replace(hour=0, minute=0, second=0)
              case "неделя":
                     date_from = datetime.now() - timedelta(days=7)
              case "месяц":
                     date_from = datetime.now() - timedelta(days=30)
              case "год":
                     date_from = datetime.now() - timedelta(days=365)
              case "Свой период":
                     await state.set_state(ExportOrder.period_set)
                     await message.answer("Введите чило в формате ДД.ММ.ГГГГ-ДД.ММ.ГГГГ")
                     return
              case _:
                     await message.answer("Не верная команда")
                     return
       
       await make_export(message, state, date_from)
       

@router.message(ExportOrder.period_set)
async def status_order_catalog(message: Message, state:FSMContext):
       if valid.valid_exp_period (message.text):
              date_from, date_to = message.text.split('-')
              await state.get_state(ExportOrder.start)
              await make_export(message, state, date_from, date_to)
       else:
              await message.answer("Некорректный формат введных данных. Повторите еще раз")


async def make_export(message: Message, state:FSMContext, date_from, date_to = None):
       if type(date_from) != datetime:
              date_from = datetime.strptime(date_from, '%d.%m.%Y')

       if date_to != None:
              date_to = datetime.strptime(date_to, '%d.%m.%Y')
       else:
             date_to = datetime.today()
       try:
              file = await rq.export_orders_to_excel(date_from=date_from,date_to=date_to)
              await message.answer_document(file, caption="Выгрузка заказов")
       except Exception as e:
              if str(e) == "В базе данных нет заказов для указанных параметров":             
                     await message.answer(f"В заданный период данных нет")
              else:
                     await message.answer(f"Произошла ошибка при экспорте. Попробуйте позже")
              print("Ошибка экспорта: ", str(e))
