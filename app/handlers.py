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
       BotCommand(command="my_orders", description="Ваш лист заказов"),
       BotCommand(command="orders", description="Лист всех заказов"),
       BotCommand(command="new_order", description="Создание нового заказа"),
       BotCommand(command="cancel", description="Отмена команды"),
    ],
    "Водитель": [
       BotCommand(command="start", description="Запустить бота"),
       BotCommand(command="help", description="Помощь"),
       BotCommand(command="my_orders", description="Ваш лист заказов"),
       BotCommand(command="orders", description="Лист всех доступных заказов"),
       BotCommand(command="cancel", description="Отмена команды"),
    ],
    "Администратор": [
       BotCommand(command="start", description="Запустить бота"),
       BotCommand(command="help", description="Помощь"),
       BotCommand(command="my_orders", description="Ваш лист заказов"),
       BotCommand(command="orders", description="Лист всех заказов"),
       BotCommand(command="new_order", description="Создание нового заказа"),
       BotCommand(command="cancel", description="Отмена команды"),
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
       time = State()
       final = State()

class Order_list(StatesGroup):
       start = State()
       end = State()

class Privat_order_list(StatesGroup):
       start = State()
       end = State()

@router.message(CommandStart())
async def cmd_start(message:Message):
       if await rq.check_user(tg_id=message.from_user.id):
              await message.answer('Добро пожаловать в программу оптимизации логистики!', reply_markup=kb.main)
       else:
              await message.answer('Вы еще не зарегестрированны. Пожайлуста, введите /register')

@router.message(Command('reload_comand'))
async def register(message: Message, bot: Bot):
    try:
        await set_user_commands(bot, message.from_user.id)
        await message.answer('Список команд успешно обнавлен')
    except Exception as e:
        logging.error(f"Ошибка обнавления команд: {e}")
        await message.answer('Ошибка обнавления команд, поробуйте позже')

@router.message(Command('register'))
async def register(message: Message, state:FSMContext):
       if await rq.check_user(tg_id=message.from_user.id):
               await message.answer('Вы уже зарегестрированны')
       else:
              await state.set_state(Register.role)
              await message.answer('Выберет роль. Для отмены регистрации введите /cancel', reply_markup = kb.roles)
             

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
       if data['role'] == 'disp':
              if message.text == os.getenv('DSPETCHER_PAS'):
                     await state.set_state(Register.fio)
                     await state.update_data(role='Диспетчер')
                     await message.answer('Введите ваше ФИО')
              else:
                     await message.answer('Пароль неверный')
       else:
              if message.text == os.getenv('DRIVERS_PAS'):
                     await state.set_state(Register.fio)
                     await state.update_data(role='Водитель')
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
              await message.answer('Отправьте Ваш номер телефона', reply_markup=kb.get_number)
       else:
              await message.answer('Введены некорректные данные. Ожидалась строка содержашая 2 или 3 слова начинающихся с большой буквы.'
              'Поторите попытку.')

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
       await callback.message.answer('Регистрация успешна. Для получения инструкции по пользованию ботом выберите /help')
       await set_user_commands(bot, data["tg_id"])

@router.callback_query(Register.final, F.data == 'cmd_register_cancel')
async def new_register_accept(callback: CallbackQuery, state: FSMContext):
       await state.clear()
       await callback.answer()
       await callback.message.answer('Регистация отменена. Для повторной попытки введите /register')


#Создание нового заказа
@router.message(Command('new_order'))
async def order_creat_start(message: Message, state:FSMContext):
       await state.set_state(Order.cargo_name)
       await message.answer('Начало создание заказ. Введите название груза')

@router.message(Order.cargo_name)
async def order_cargo_name(message: Message, state:FSMContext):
       await state.update_data(cargo_name=message.text)
       await state.update_data(tg_id=message.from_user.id)
       await state.set_state(Order.cargo_description)
       await message.answer('Введите краткое описание груза при необходимости. Вслучае отсутсвтия описания введите "Нет"')

@router.message(Order.cargo_description)
async def order_cargo_description(message: Message, state:FSMContext):
       await state.update_data(cargo_description=message.text)
       await state.set_state(Order.cargo_type)
       await message.answer('Пожайлуста, выберете тип груза', reply_markup= await kb.cargo_types_keyboard())

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
       if valid.valid_loc(message.text):
              await state.update_data(depart_loc = int(message.text))
              await state.set_state(Order.goal_loc)
              await message.answer('Введите номер цеха/корпуса назначения')
       else:
              await message.answer('Некорректные данные. Повторите попытку.')

@router.message(Order.goal_loc)
async def order_goal_loc(message: Message, state: FSMContext):
       if valid.valid_loc(message.text):
              await state.update_data(goal_loc = int(message.text))
              await state.set_state(Order.time)
              await message.answer('Время и дату забора груза (формат ЧЧ:ММ ДД.ММ.ГГГГ)')
       else:
              await message.answer('Некорректные данные. Повторите попытку.')

@router.message(Order.time)
async def order_time(message: Message, state: FSMContext):
       if valid.valid_time(message.text):
              await state.update_data(time = message.text)
              data = await state.get_data() 
              type_name = await rq.get_cargo_type_name_by_id(data=int(data["cargo_type_id"]))
              await state.set_state(Order.final)
              await message.answer(f'Заказ \nНазвание груза: {data["cargo_name"]} \nОписание груза: {data["cargo_description"]} \nТип груза: {type_name} \nВес груза: {data["cargo_weight"]} \nЦех/корпус отправки: {data["depart_loc"]} '
              f'\nЦех/корпус назначения: {data["goal_loc"]} \nВремя забора груза: {data["time"]}', reply_markup = kb.orderKey)
       else:
              await message.answer('Некорректные данные. Повторите попытку.')

@router.callback_query(Order.final, F.data == 'cmd_order_accept')
async def new_order_accept(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data() 
       await rq.add_new_order(data=data)
       await state.clear()
       await callback.answer()
       await callback.message.answer('Заказ успешно добавлен')

@router.callback_query(Order.final, F.data == 'cmd_order_cancel')
async def new_order_accept(callback: CallbackQuery, state: FSMContext):
       await state.clear()
       await callback.answer()
       await callback.message.answer('Добавление заказа отменено. Для повторной попытки введите /new_order')


#Просмотр каталога заказов
@router.message(Command("orders"))
async def order_catalog_choice(message: Message, state:FSMContext):
       await state.set_state(Order_list.start)
       userRole = await rq.get_user_role(tg_id=message.from_user.id)
       await state.update_data(indexStart = 0, indexEnd = 5, userRole = userRole, tg_id=message.from_user.id, button_text="take_order")  
       await message.answer("Выберете, на какой день вы хотите просмотреть лист заказов", reply_markup= await kb.order_day(message.from_user.id))

@router.message(Order_list.start, F.text.lower().in_(["сегодня", "завтра", "все"]))
async def order_catalog(message: Message, state:FSMContext):
       data = await state.get_data()
       if message.text.lower() == "сегодня":
              orderKyes = await rq.get_order_keys(dateTime=datetime.today().date(), tg_id=data["tg_id"])
       elif message.text.lower() == "завтра":
              orderKyes = await rq.get_order_keys(dateTime=datetime.today().date() + timedelta(days=1), tg_id=data["tg_id"])
       elif data["userRole"] != "Водитель":
              if message.text.lower() == "все" :
                     orderKyes = await rq.get_order_keys(tg_id=data["tg_id"])
              else: 
                     await message.answer("Вы не можете просмотреть эту категорию. Выберете одну из предоставленных")
       else:
              await message.answer("Вы не можете просмотреть эту категорию. Выберете одну из предоставленных")

       if len(orderKyes) != 0: 
              size = len(orderKyes)
              if size < 5:
                     await state.update_data(indexEnd = size)
              await state.update_data(orderList = orderKyes)
              orders = await rq.get_orders(ordersKeys=orderKyes, start=0,end=5)
              mes = "\n".join(orders)
              await message.answer(mes, reply_markup= await kb.order_select_keyboard(user_role=data["userRole"], order_keys=orderKyes, start=data["indexStart"], end=data["indexEnd"], button_text=data["button_text"] ))
       else:
              await message.answer("Заказов нет")

@router.callback_query(StateFilter(Order_list.start, Privat_order_list.start), F.data ==('order_move_back'))
async def order_move_back(callback: CallbackQuery, state: FSMContext):
       await callback.answer()
       data = await state.get_data()
       await state.update_data(indexStart = (data["indexStart"]-5), indexEnd = (data["indexEnd"]-5))
       orders = await rq.get_orders(ordersKeys= data["orderList"], start=data["indexStart"]-5, end=data["indexEnd"]-5)
       mes = "\n".join(orders)
       await callback.message.edit_text(mes, reply_markup= await kb.order_select_keyboard(user_role=data["userRole"], order_keys=data["orderList"], start=data["indexStart"] -5, end=data["indexEnd"]-5, button_text=data["button_text"], isHistoruPraviteCatalog=data.get("isHistoruPraviteCatalog", False)))

@router.callback_query(StateFilter(Order_list.start, Privat_order_list.start), F.data == ('order_move_forward'))
async def order_move_back(callback: CallbackQuery, state: FSMContext):
       await callback.answer()
       data = await state.get_data()
       await state.update_data(indexStart = (data["indexStart"]+5), indexEnd = (data["indexEnd"]+5))
       orders = await rq.get_orders(ordersKeys= data["orderList"], start=data["indexStart"]+5, end=data["indexEnd"]+5)
       mes = "\n".join(orders)
       await callback.message.edit_text(mes, reply_markup= await kb.order_select_keyboard(user_role=data["userRole"], order_keys=data["orderList"], start=data["indexStart"] +5, end=data["indexEnd"]+5, button_text=data["button_text"], isHistoruPraviteCatalog=data.get("isHistoruPraviteCatalog", False) ))

@router.callback_query(Order_list.start, F.data.startswith('take_order:'))
async def order_take(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await state.update_data(orderId = orderId)
       await callback.answer()
       await callback.message.answer(f'Вы выбрали заказа №{orderId}', reply_markup= kb.publicCatalogKey)


@router.callback_query(Order_list.start, F.data ==('accept_take_order'))
async def order_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       await callback.answer()
       try:
              if await rq.take_order(tg_id=data["tg_id"], order_id=int(data["orderId"])):
                     await callback.message.answer(f'Вы взяли заказ: {data["orderId"]}', reply_markup=ReplyKeyboardRemove())
                     chat_id, mes = await rq.get_user_for_send(orderId=int(data["orderId"]), driver_id=data["tg_id"], action_text="Взятие в работу")
                     await callback.message.bot.send_message(chat_id=chat_id, text=mes)
                     await state.clear()
              else:
                     await callback.message.answer(f'Этот заказ уже взят')
       except Exception as e:
              await callback.message.answer(f'При взятии заказа произошла ошибка. Попробуйте позже')

#Личные каталоги доставщиков/диспетчеров
@router.message(Command("my_orders"))
async def private_order_catalog_choice(message: Message, state:FSMContext):   
       await state.set_state(Privat_order_list.start)
       userRole = await rq.get_user_role(tg_id=message.from_user.id)
       await state.update_data(indexStart = 0, indexEnd = 5, userRole = userRole, tg_id=message.from_user.id, button_text="complete_order")  
       await message.answer("Выберете, категорию листа заказов", reply_markup= kb.private_order_list_kb)

@router.message(Privat_order_list.start, F.text.lower().in_(["активные заказы", "история заказов"]))
async def private_order_catalog(message: Message, state:FSMContext):
       data = await state.get_data()
       if message.text.lower() == "активные заказы":
              orderKyes = await rq.get_order_keys(tg_id=data["tg_id"], isActual=True, isPrivateCatalog=True)
       elif message.text.lower() == "история заказов":
              orderKyes = await rq.get_order_keys(tg_id=data["tg_id"], isPrivateCatalog=True)
              await state.update_data(isHistoruPraviteCatalog = True)
       elif data["userRole"] != "Водитель":
              if message.text.lower() == "все" :
                     orderKyes = await rq.get_order_keys()
              else: 
                     await message.answer("Вы не можете просмотреть эту категорию. Выберете одну из предоставленных")
       else:
              await message.answer("Вы не можете просмотреть эту категорию. Выберете одну из предоставленных")

       if len(orderKyes) != 0:      
              size = len(orderKyes)
              if size < 5:
                     await state.update_data(indexEnd = size)
              await state.update_data(orderList = orderKyes)
              orders = await rq.get_orders(ordersKeys=orderKyes, start=0,end=5)
              mes = "\n".join(orders)
              await message.answer(mes, reply_markup= await kb.order_select_keyboard(user_role=data["userRole"], order_keys=orderKyes, start=data["indexStart"], end=data["indexEnd"], button_text=data["button_text"], isHistoruPraviteCatalog=data.get("isHistoruPraviteCatalog", False) ) )
       else:
              await message.answer("Заказов нет")

@router.callback_query(Privat_order_list.start, F.data.startswith('complete_order:'))
async def complete_take(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await state.update_data(orderId = orderId)
       await callback.answer()
       await callback.message.answer(f'Вы выбрали заказа №{orderId}', reply_markup= kb.privateCatalogKey)

@router.callback_query(Privat_order_list.start, F.data == ('accept_complete_order'))
async def acept_complete_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       await callback.answer()
       try:
              if await rq.complete_order(tg_id=data["tg_id"], order_id=int(data["orderId"])):
                     await callback.message.answer(f'Вы завершили заказ: {data["orderId"]}', reply_markup=ReplyKeyboardRemove())
                     chat_id, mes = await rq.get_user_for_send(orderId=int(data["orderId"]), driver_id=data["tg_id"], action_text="Завершение")
                     await callback.message.bot.send_message(chat_id=chat_id, text=mes)
                     await state.clear()
              else:
                     await callback.message.answer(f'Этот заказ уже завершен')
       except Exception as e:
              await callback.message.answer(f'При завершении заказа произошла ошибка. Попробуйте позже')

@router.callback_query(Privat_order_list.start, F.data == ('take_off_complete_order'))
async def take_off_complete_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       await callback.answer()
       try:
              await rq.take_off_complete_order(tg_id=data["tg_id"], order_id=int(data["orderId"]))
              await callback.message.answer(f'Вы отказались от заказа: {data["orderId"]}', reply_markup=ReplyKeyboardRemove())
              chat_id, mes = await rq.get_user_for_send(orderId=int(data["orderId"]), driver_id=data["tg_id"], action_text="Отмена выполнения")
              await callback.message.bot.send_message(chat_id=chat_id, text=mes)
              await state.clear()
       except Exception as e:
              await callback.message.answer(f'При отказе от заказа произошла ошибка. Попробуйте позже')




@router.message(Command('help'))
async def cmd_help(message: Message):
       user_role = rq.get_user_role(tg_id=message.from_user.id)
       if(user_role == "Водитель"):
              mes =(
                     f'Инструкция как пользоваться ботом:\n\n'
                     f'Для просмотра всех доступных к работе заказов выберите команду /orders. Вам нужно выбрать, на какой день просмотреть заказы, и появится список заказов, отсортированный по сроку взятия от самого раннего до самого позднего.'
                     f'Под каталогом до 5 кнопок с номерами заказов. При нажатии на любую из них вы принимаете заказ. Стрелки внизу позволяют прокручивать каталог.\n\n'
                     f'Для просмотра взятых в работу заказов выберите /my_orders. Для завершения заказа найдите его номер в каталоге активных заказов и нажмите соответствующую кнопку. Нажав на нее, заказ будет завершен.\n\n'
                     f'Для выхода из каталога без взятия заказа или отмены другой длительной команды используйте /cancel.'              
                     )
       else:
              mes = (
                     f'Инструкция как пользоваться ботом:\n\n'
                     f'Для создания заказа выберите команду /new_order. Вам нужно последовательно внести данные в требуемых форматах. Рекомендуется проверить корректность введенных данных и в случае ошибки отменить и заполнить форму заново.\n\n'
                     f'Для просмотра всех заказов выберите команду /orders. Вам нужно выбрать, на какой день просмотреть заказы, и появится список заказов, отсортированный по сроку взятия от самого раннего до самого позднего.'
                     f'Стрелки внизу позволяют прокручивать каталог.\n\n'
                     f'Для просмотра созданных вами заказов выберите /my_orders. Здесь можно отслеживать их статус выполнения.\n\n'
                     f'Для выхода из каталога или отмены другой длительной команды используйте /cancel.'
              )
       await message.answer(mes)    

@router.message(F.text == 'Помощь')  
async def bothelper(mesage:Message):
      await mesage.answer('Выберите вопрос', reply_markup=kb.bothelper)

@router.callback_query(F.data =='Do_Order')
async def Do_Order(callback: CallbackQuery):
       await callback.answer('Вы выбрали первый пункт', show_alert=True)
       await callback.message.answer('Инструкция к заказу')
