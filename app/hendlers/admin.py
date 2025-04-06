from aiogram import F, Router
from aiogram.types import Message, CallbackQuery, ReplyKeyboardRemove
from aiogram.filters import Command

from aiogram.fsm.context import FSMContext
import app.validators as valid
import app.keyboards as kb
import app.database.requests as rq

from datetime import datetime, timedelta
import app.utils.states as st

router = Router()

# region экспорт
@router.message(Command('export'))
async def cmd_export(message: Message, state: FSMContext):
       await state.clear()
       role = await rq.get_user_role(tg_id=message.from_user.id)
       if (role == "Администратор"):
              await message.answer("Какие данные экспортировать?", reply_markup=kb.exportchoice)
              await state.set_state(st.ExportOrder.choise)
       else:
              await message.answer("У вас не хватает прав доступа для использования этой команды")

@router.callback_query(st.ExportOrder.choise, F.data.startswith("export:"))
async def exp_type_choise(callback: CallbackQuery, state: FSMContext):
       exp_type = callback.data.split(':')[1]
       await callback.answer()
       await state.update_data(expType = exp_type)
       await callback.message.answer("За какой период выгрузить данные?", reply_markup=kb.exp_orders_kb)

@router.message(st.ExportOrder.choise, F.text.lower().in_(["день ☀️", "неделя 📅", "месяц 🌙", "год 🗓️", "свой"]))
async def status_order_catalog(message: Message, state:FSMContext):
       per = message.text.lower()
       match per:
              case "день ☀️":
                     date_from = datetime.now().replace(hour=0, minute=0, second=0)
              case "неделя 📅":
                     date_from = datetime.now() - timedelta(days=7)
              case "месяц 🌙":
                     date_from = datetime.now() - timedelta(days=30)
              case "год 🗓️":
                     date_from = datetime.now() - timedelta(days=365)
              case "свой ✏️":
                     await state.set_state(st.ExportOrder.period_set)
                     await message.answer("Введите чило в формате ДД.ММ.ГГГГ-ДД.ММ.ГГГГ")
                     return
              case _:
                     await message.answer("Не верная команда")
                     return
       
       await make_export(message, state, date_from)
       

@router.message(st.ExportOrder.period_set)
async def status_order_catalog(message: Message, state:FSMContext):
       if valid.valid_exp_period (message.text):
              date_from, date_to = message.text.split('-')
              await state.set_state(st.ExportOrder.start)
              await make_export(message, state, date_from, date_to)
       else:
              await message.answer("Некорректный формат введных данных. Повторите еще раз")


async def make_export(message: Message, state:FSMContext, date_from, date_to = None):
       data = await state.get_data()
       if type(date_from) != datetime:
              date_from = datetime.strptime(date_from, '%d.%m.%Y')

       if date_to != None:
              date_to = datetime.strptime(date_to, '%d.%m.%Y')
       else:
             date_to = datetime.today()
       try:
              if data["expType"] == "orders":
                     file = await rq.export_orders_to_excel(date_from=date_from, date_to=date_to)
                     await message.answer_document(file, caption="Выгрузка заказов", reply_markup=ReplyKeyboardRemove())
              if data["expType"] == "drivers":
                     diogram = await rq.export_diagrama(date_from=date_from, date_to=date_to)
                     await message.answer_photo(diogram, caption="Гистограмма продуктивности водителей", reply_markup=ReplyKeyboardRemove())
       except Exception as e:
              if str(e) == "Нет выполненных заказов за указанный период":             
                     await message.answer(f"В заданный период данных нет")
              else:
                     await message.answer(f"Произошла ошибка при экспорте. Попробуйте позже")
#endregion

@router.message(Command('cargo_ratios'))
async def show_ratio(message: Message, state: FSMContext):
       role = await rq.get_user_role(tg_id=message.from_user.id)
       if (role == "Администратор"):
              count, mes = await rq.get_cargo_type_output()
              await state.set_state(st.ChangRatio.start)
              await message.answer(mes, reply_markup=kb.ratio_keyboard(count))
       else:
              await message.answer("У вас не хватает прав доступа для использования этой команды")

@router.callback_query(st.ChangRatio.start, F.data.startswith("change_ratio:"))
async def change_ratio(callback: CallbackQuery, state: FSMContext):
       id_type = callback.data.split(':')[1]
       await callback.answer()
       await state.update_data(id_type = id_type)
       await state.set_state(st.ChangRatio.set_new_ratio)
       await callback.message.answer(f"Вы выбрали тип под номером: {id_type}. Введите новое значение коэфицента через точку.")

@router.message(st.ChangRatio.set_new_ratio)
async def new_ratio(message: Message, state:FSMContext):
       value = message.text
       data = await state.get_data()
       try:
              ratio = float(value)
              await rq.update_ratio(id=data["id_type"], ratio=ratio)
              await message.answer("Коэффициент успешно обновлен")
              await state.clear()
       except ValueError:
              await message.answer("Неверный формат. Попробуйте еще раз")
       except Exception as e:
              await message.answer(f"При обновлении коэффициента произошла ошибка. Попробуйте позже")