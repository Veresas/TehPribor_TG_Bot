from aiogram import F, Router
from aiogram.types import Message, CallbackQuery, ReplyKeyboardRemove
from aiogram.filters import Command, StateFilter

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

@router.message(Command('coefficients'))
async def show_ratio(message: Message, state: FSMContext):
       role = await rq.get_user_role(tg_id=message.from_user.id)
       if role == "Администратор":
              await state.set_state(st.ChangRatio.choose_type)
              await message.answer("Выберите, какой коэффициент хотите изменить:", reply_markup=kb.ratio_type_keyboard())
       else:
              await message.answer("У вас не хватает прав доступа для использования этой команды")

@router.callback_query(st.ChangRatio.choose_type, F.data.startswith("ratio_type:"))
async def select_ratio_type(callback: CallbackQuery, state: FSMContext):
       _, ratio_type = callback.data.split(":")
       await callback.answer()
       await state.update_data(ratio_type=ratio_type)

       if ratio_type == "cargo":
              items = await rq.get_cargo_type_list()
              await state.set_state(st.ChangRatio.select_cargo_type)
              await callback.message.answer("Выберите тип груза:", reply_markup=kb.generic_coeff_keyboard(items, "cargo"))
       elif ratio_type == "time":
              items = await rq.get_time_coeffs()
              await state.set_state(st.ChangRatio.select_time)
              await callback.message.answer("Выберите значение времени:", reply_markup=kb.generic_coeff_keyboard(items, "time"))
       elif ratio_type == "weight":
              items = await rq.get_weight_coeffs()
              await state.set_state(st.ChangRatio.select_weight)
              await callback.message.answer("Выберите значение веса:", reply_markup=kb.generic_coeff_keyboard(items, "weight"))

@router.callback_query(st.ChangRatio.select_cargo_type, F.data.startswith("change_ratio:"))
async def change_ratio(callback: CallbackQuery, state: FSMContext):
       id_type = callback.data.split(':')[1]
       await callback.answer()
       await state.update_data(id_type = id_type)
       await state.set_state(st.ChangRatio.set_new_ratio)
       await callback.message.answer(f"Вы выбрали тип под номером: {id_type}. Введите новое значение коэфицента через точку.")

@router.callback_query(StateFilter(st.ChangRatio.select_cargo_type,
                                   st.ChangRatio.select_time,
                                   st.ChangRatio.select_weight ) , F.data.startswith("change_coeff:"))
async def change_any_ratio(callback: CallbackQuery, state: FSMContext):
       _, prefix, item_id = callback.data.split(":")
       await callback.answer()
       await state.update_data(coeff_id=item_id, coeff_type=prefix)
       await state.set_state(st.ChangRatio.set_generic_ratio)
       await callback.message.answer("Введите новое значение коэффициента:")

@router.callback_query(StateFilter(st.ChangRatio.select_cargo_type,
                                   st.ChangRatio.select_time,
                                   st.ChangRatio.select_weight ) , F.data.startswith("add_coeff:"))
async def add_any_ratio(callback: CallbackQuery, state: FSMContext):
       _, prefix = callback.data.split(":")
       await callback.answer()
       await state.update_data(coeff_type=prefix)
       await state.set_state(st.ChangRatio.set_group_ratio)
       match prefix:
              case "cargo":
                     await callback.message.answer("Введите новое значение для группы груза (только слова):")
              case "time":
                     await callback.message.answer("Введите новое значение времени в минутах (только число):")
              case "weight":
                     await callback.message.answer("Введите новое значение веса в килограммах (только число):")


@router.message(st.ChangRatio.set_group_ratio)
async def set_new_generic_ratio(message: Message, state: FSMContext):
       data = await state.get_data()
       coeff_type = data['coeff_type']
       user_input = message.text.strip()

       match coeff_type:
              case "cargo":
                     if not user_input.isalpha():
                            await message.answer("Ошибка: Введите только текст без чисел.")
                            return
                     await rq.add_ratio(coeff_type=coeff_type, value=user_input)
                     await message.answer(f"Грузовая группа '{user_input}' успешно добавлена.")
              
              case "time":
                     if not user_input.isdigit():
                            await message.answer("Ошибка: Введите только число (минуты).")
                            return
                     await rq.add_ratio(coeff_type=coeff_type, value=int(user_input))
                     await message.answer(f"Временной коэффициент '{user_input} мин' успешно добавлен.")
              
              case "weight":
                     if not user_input.isdigit():
                            await message.answer("Ошибка: Введите только число (в кг).")
                            return
                     await rq.add_ratio(coeff_type=coeff_type, value=int(user_input))
                     await message.answer(f"Весовой коэффициент '{user_input} кг' успешно добавлен.")
       
       await state.clear()

@router.message(st.ChangRatio.set_generic_ratio)
async def set_new_generic_ratio(message: Message, state: FSMContext):
       try:
              value = float(message.text)
              data = await state.get_data()
              coeff_type = data['coeff_type']
              coeff_id = int(data['coeff_id'])

              match coeff_type:
                     case "cargo":
                            await rq.update_ratio(coeff_id, value)
                     case "time":
                            await rq.update_time_coeff(coeff_id, value)
                     case "weight":
                            await rq.update_weight_coeff(coeff_id, value)

              await message.answer("Коэффициент успешно обновлен")
              await state.clear()
       except ValueError:
              await message.answer("Неверный формат. Попробуйте снова.")
       except Exception as e:
              await message.answer(f"Ошибка обновления: {e}")