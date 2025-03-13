from aiogram import F, Router
from aiogram.types import Message, CallbackQuery
from aiogram.filters import CommandStart, Command 
from aiogram.fsm.state import State, StatesGroup
from aiogram.fsm.context import FSMContext
import app.validators as valid
import app.keyboards as kb
import app.database.requests as rq

router = Router()

class Register(StatesGroup):
       name = State()
       age = State()
       number = State()

@router.message(CommandStart())
async def cmd_start(message:Message):
       await rq.set_user(message.from_user.id)
       await message.answer('Добро пожаловать в программу оптимизации логистики!', reply_markup=kb.main)

@router.message(Command('register'))
async def register(message: Message, state:FSMContext):
       await state.set_state(Register.name)
       await message.answer('Введите ваше имя')

@router.message(Register.name)
async def register_name (message: Message, state: FSMContext):
       if valid.valid_fio(message.text):
              await state.update_data(name=message.text)
              await state.set_state (Register.age)
              await message.answer('Введите ваш возраст')
       else:
              await message.answer('Введены некорректные данные. Ожидалась строка содержашая 2 или 3 слова начинающихся с большой буквы.'
              'Поторите попытку')

@router.message(Register.age)
async def register_age(message: Message, state: FSMContext):
       await state.update_data(age=message.text)
       await state.set_state (Register.number)
       await message.answer('Отправьте Ваш номер телефона', reply_markup=kb.get_number)

@router.message(Register.number, F.contact)
async def register_number(message: Message, state: FSMContext):
       await state.update_data(number=message.contact.phone_number)
       data = await state.get_data()
       await message.answer(f'Ваше имя:{data["name"]}\nВаш возраст: {data["age"]}\nВаш номер: {data["number"]}')
       await state.clear()

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