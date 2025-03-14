from aiogram import F, Router
from aiogram.types import Message, CallbackQuery
from aiogram.filters import CommandStart, Command, StateFilter
from aiogram.fsm.state import State, StatesGroup
from aiogram.fsm.context import FSMContext
import app.validators as valid
import app.keyboards as kb
import app.database.requests as rq
import os

router = Router()

class Register(StatesGroup):
       role = State()
       pas = State()
       fio = State()
       age = State()
       number = State()

class Order(StatesGroup):
       cargo_name = State()
       cargo_description = State()
       cargo_type = State()
       cargo_weight = State()
       depart_loc = State()
       goal_loc = State()
       time = State()
       final = State()

@router.message(CommandStart())
async def cmd_start(message:Message):
       if rq.cheсk_user(tg_id=message.from_user.id):
              await message.answer('Добро пожаловать в программу оптимизации логистики!', reply_markup=kb.main)
       else:
              await message.answer('Вы еще не зарегестрированны. Пожайлуста, введите /register')

@router.message(Command('register'))
async def register(message: Message, state:FSMContext):
       if rq.cheсk_user(tg_id=message.from_user.id):
              await state.set_state(Register.role)
              await message.answer('Выберет роль. Для отмены регистрации введете /cancel', kb.roles)
       else:
              await message.answer('Вы уже зарегестрированны')

@router.callback_query(Register.role, F.data.startwith('role_') )
async def register_role(calback: CallbackQuery, state: FSMContext):
       calbackRole = calback.data.split(_)[1]
       await state.set_data(role = calbackRole)
       await state.set_state(Register.pas)
       await calback.answer()
       await calback.message.answer('Введите выданный вам пароль')

@router.message(Register.pas)
async def register_pas(message: Message, state:FSMContext):
       data = state.get_data()
       if data['role'] == 'disp':
              if message.text == os.getenv('DSPETCHER_PAS'):
                     await state.set_state(Register.fio)
                     await state.set_data(role='Диспетчер')
                     await message.answer('Введите ваше ФИО')
              else:
                     await message.answer('Пароль неверный')
       else:
              if message.text == os.getenv('DRIVERS_PAS'):
                     await state.set_state(Register.fio)
                     await state.set_data(role='Водитель')
                     await message.answer('Введите ваше ФИО')
              else:
                     await message.answer('Пароль неверный')

@router.message(Command('cancel'), StateFilter('*'))
async def cancelCom(message: Message, state:FSMContext):
       await state.clear()
       await message.answer('Команда отменена')

@router.message(Register.fio)
async def register_name (message: Message, state: FSMContext):
       if valid.valid_fio(message.text):
              await state.update_data(fio=message.text)
              await state.set_state (Register.age)
              await message.answer('Введите ваш возраст числом')
       else:
              await message.answer('Введены некорректные данные. Ожидалась строка содержашая 2 или 3 слова начинающихся с большой буквы.'
              'Поторите попытку.')

@router.message(Register.age)
async def register_age(message: Message, state: FSMContext):
       if valid.valid_age(message.text):
              await state.update_data(age=int(message.text))
              await state.set_state (Register.number)
              await message.answer('Отправьте Ваш номер телефона', reply_markup=kb.get_number)
       else:
              await message.answer('Некорректные данные. Повторите попытку.')

@router.message(Register.number, F.contact)
async def register_number(message: Message, state: FSMContext):
       await state.update_data(number=message.contact.phone_number)
       data = await state.get_data()
       await message.answer(f'Ваше имя:{data["fio"]}\nВаш возраст: {data["age"]}\nВаш номер: {data["number"]}')
       data = await state.get_data()
       await rq.reg_user(data=data, tg_id=message.from_user.id)
       await state.clear()


#Создание нового заказа
@router.message(Command('new_order'))
async def order_creat_start(message: Message, state:FSMContext):
       await state.set_state(Order.cargo_name)
       await message.answer('Начало создание заказ. Введите название груза')

@router.message(Order.cargo_name)
async def order_cargo_name(message: Message, state:FSMContext):
       await state.set_data(cargo_name=message.text)
       await state.set_state(Order.cargo_description)
       await message.answer('Введите краткое описание груза при необходимости. Вслучае отсутсвтия описания введите "Нет"')

@router.message(Order.cargo_description)
async def order_cargo_description(message: Message, state:FSMContext):
       await state.set_data(cargo_name=message.text)
       await state.set_state(Order.cargo_type)
       await message.answer('Пожайлуста, выберете тип груза', reply_markup= await kb.cargo_types_keyboard())

@router.callback_query(Order.cargo_type, F.data.startswith('cargo_'))
async def order_cargo_type(callback: CallbackQuery, state: FSMContext):
       await callback.answer()
       cargo_key = callback.data.split("_")[1]
       cargo_value = kb.cargo_types.get(cargo_key) # TODO: возможно добавить в БД таблицу с типами грузов
       await state.update_data(cargo_type = cargo_value)
       await state.set_state(Order.cargo_weight)
       await callback.message.answer('Введите вес груза (число, кг)')

@router.message(Order.cargo_weight)
async def order_cargo_weight(message: Message, state: FSMContext):
       if valid.valid_weight(message.text):
              await state.update_data(cargo_weight = int(message.text))
              await state.set_state(Order.depart_loc)
              await message.answer('Введите номер цеха/корпуса отправления')
       else:
              await message.answer('Некорректные данные. Повторите попытку.')
              
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
              await message.answer('Время забора груза (формат ЧЧ:ММ)')
       else:
              await message.answer('Некорректные данные. Повторите попытку.')

@router.message(Order.time)
async def order_time(message: Message, state: FSMContext):
       if valid.valid_time(message.text):
              await state.update_data(time = message.text)
              data = await state.get_data() 
              await state.set_data(Order.final)
              await message.answer(f'Заказ \nНазвание груза:{data["cargo_name"]} \nОписание груза{data["cargo_description"]} \nТип груза:{data["cargo_type"]} \nВес груза: {data["cargo_weight"]} \nЦех/корпус отправки: {data["depart_loc"]} '
              f'\nЦех/корпус назначения: {data["goal_loc"]} \nВремя забора груза {data["time"]}', reply_markup = kb.orderKey)
       else:
              await message.answer('Некорректные данные. Повторите попытку.')

@router.callback_query(Order.final, F.data == 'cmd_order_accept')
async def new_order_accept(callback: CallbackQuery, state: FSMContext):
       #TODO: обработка добавление заказа в БД
       await state.clear()
       await CallbackQuery.answer()
       await CallbackQuery.message.answer('Заказ успешно добавлен')

@router.callback_query(Order.final, F.data == 'cmd_order_cancel')
async def new_order_accept(callback: CallbackQuery, state: FSMContext):
       await state.clear()
       await CallbackQuery.answer()
       await CallbackQuery.message.answer('Добавление заказа отменено. Для повторной попытки введите /new_order')
       
"""    
@router.message(Command('help'))
async def cmd_help(message: Message):
      await message.answer('Инструкция как пользоваться ботом')    

@router.message(F.text == 'Помощь')  
async def bothelper(mesage:Message):
      await mesage.answer('Выберите вопрос', reply_markup=kb.bothelper)

@router.callback_query(F.data =='Do_Order')
async def Do_Order(callback: CallbackQuery):
       await callback.answer('Вы выбрали первый пункт', show_alert=True)
       await callback.message.answer('Инструкция к заказу')


"""    