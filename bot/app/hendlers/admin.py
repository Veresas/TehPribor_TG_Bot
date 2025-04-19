from aiogram import F, Router
from aiogram.types import Message, CallbackQuery, ReplyKeyboardRemove
from aiogram.filters import Command, StateFilter

from aiogram.fsm.context import FSMContext
import app.validators as valid
import app.keyboards as kb
import app.database.requests as rq

from datetime import datetime, timedelta
import app.utils.states as st
import app.utils.filters as fl
import app.utils.help_func as util
router = Router()

# region экспорт
@router.message(fl.RoleFilter("Администратор, Мастер_админ"), Command('export'))
async def cmd_export(message: Message, state: FSMContext):
       await state.clear()
       await message.answer("Какие данные экспортировать?", reply_markup=kb.exportchoice)
       await state.set_state(st.ExportOrder.choise)

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

@router.callback_query(
       StateFilter(st.ChangRatio.choose_type,
                     st.ChangRatio.select_cargo_type,
                     st.ChangRatio.select_time,
                     st.ChangRatio.select_weight),
       F.data.startswith("ratio_type:")
)
async def select_ratio_type(callback: CallbackQuery, state: FSMContext):
       _, ratio_type = callback.data.split(":")
       await callback.answer()

       await state.update_data(ratio_type=ratio_type)

       match ratio_type:
              case "cargo":
                     items = await rq.get_cargo_type_list()
                     mst = st.ChangRatio.select_cargo_type
                     mes = "Выберите тип груза:"
                     kb_markup = kb.generic_coeff_keyboard(items, "cargo")
              case "time":
                     items = await rq.get_time_coeffs()
                     mst = st.ChangRatio.select_time
                     mes = "Выберите значение времени:"
                     kb_markup = kb.generic_coeff_keyboard(items, "time")
              case "weight":
                     items = await rq.get_weight_coeffs()
                     mst = st.ChangRatio.select_weight
                     mes = "Выберите значение веса:"
                     kb_markup = kb.generic_coeff_keyboard(items, "weight")

       await util.push_scene(
              state,
              message_id=callback.message.message_id,
              text=mes,
              keyboard=kb_markup,
              state_name=mst.state
       )

       await state.set_state(mst)
       await callback.message.edit_text(mes, reply_markup=kb_markup)


@router.callback_query(
       StateFilter(st.ChangRatio.select_cargo_type,
                     st.ChangRatio.select_time,
                     st.ChangRatio.select_weight),
       F.data.startswith("change_coeff:")
)
async def change_any_ratio(callback: CallbackQuery, state: FSMContext):
       _, prefix, item_id = callback.data.split(":")
       await callback.answer()

       await state.update_data(coeff_id=item_id, coeff_type=prefix)
       await state.set_state(st.ChangRatio.set_generic_ratio)

       await callback.message.edit_text("Введите новое значение коэффициента:")


@router.callback_query(
       StateFilter(st.ChangRatio.select_cargo_type,
                     st.ChangRatio.select_time,
                     st.ChangRatio.select_weight),
       F.data.startswith("add_coeff:")
)
async def add_any_ratio(callback: CallbackQuery, state: FSMContext):
       _, prefix = callback.data.split(":")
       await callback.answer()

       await state.update_data(coeff_type=prefix)
       await state.set_state(st.ChangRatio.set_group_ratio)

       match prefix:
              case "cargo":
                     text = "Введите новое значение для группы груза (только слова):"
              case "time":
                     text = "Введите новое значение времени в минутах (только число):"
              case "weight":
                     text = "Введите новое значение веса в килограммах (только число):"

       await callback.message.edit_text(text)



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


@router.message(fl.RoleFilter("Администратор, Мастер_админ"), Command("admin_panel"))
async def admin_panel(message: Message, state: FSMContext):
       mes = "Выберете пункт меню"
       mkb = kb.admin_panel_kb
       mst = st.AdminPanel.menu

       sent = await message.answer(text=mes, reply_markup=mkb)
       await util.push_scene(
              state,
              message_id=sent.message_id,
              text=mes,
              keyboard=mkb,
              state_name=mst.state
       )

       await state.set_state(mst)

@router.callback_query(st.AdminPanel.menu, F.data.startswith("ap_choise"))
async def ap__categori(callback: CallbackQuery, state: FSMContext):
       categori = callback.data.split(":")[1]

       match categori:
              case "staff":
                     mes = "Выберите категорию сотрудников"
                     mkb = await kb.ap_staff_cat_keyboard(callback.from_user.id)
                     mst = st.AdminPanel.stuffCat
              case "departments":
                     mes = "Выберите категорию отдела"
                     mkb = kb.ap_dep_keyboard
                     mst = st.AdminPanel.buildCat
              case "coefficients":
                     mes = "Выберите категорию коэффициентов"
                     mkb = kb.ratio_type_keyboard()
                     mst = st.ChangRatio.choose_type

       await util.push_scene(
              state,
              message_id=callback.message.message_id,
              text=mes,
              keyboard=mkb,
              state_name=mst.state
       )

       await state.set_state(mst)
       await callback.answer()
       await callback.message.edit_text(text=mes, reply_markup=mkb)


@router.callback_query(st.AdminPanel.stuffCat, F.data.startswith("ap_staff_role"))
async def ap_staff(callback: CallbackQuery, state: FSMContext):
       categori = callback.data.split(":")[1]

       match categori:
              case "couriers":
                     mes = "Список курьеров" + await rq.get_stuff_List_mes(roleId=2)
                     mst = st.AP_Staff.disp
              case "dispatchers":
                     mes = "Список диспетчеров" + await rq.get_stuff_List_mes(roleId=1)
                     mst = st.AP_Staff.disp
              case "admins":
                     mes = "Список админов" + await rq.get_stuff_List_mes(roleId=3)
                     mst = st.AP_Staff.disp

       mkb = kb.go_back_kb

       await util.push_scene(
              state,
              message_id=callback.message.message_id,
              text=mes,
              keyboard=mkb,
              state_name=mst.state
       )

       await state.set_state(mst)
       await callback.answer()
       await callback.message.edit_text(text=mes, reply_markup=mkb)

@router.callback_query(st.AdminPanel.buildCat, F.data.startswith('dep_type_choise'))
async def dep_choise(callbacke: CallbackQuery, state: FSMContext):
       dep_type = callbacke.data.split(':')[1]
       await callbacke.answer()
       await state.update_data(dep_type=dep_type)
       mes = 'Подразделения'
       mkb = kb.dep_chose(int(dep_type), is_ap = True)
       mst = st.AdminPanel.buildCat

       await util.push_scene(
              state,
              message_id=callbacke.message.message_id,
              text=mes,
              keyboard=mkb,
              state_name=mst.state
       )

       await callbacke.message.edit_text(mes, reply_markup= mkb)

@router.callback_query(st.AdminPanel.buildCat, F.data.startswith('depart'))
async def build_choise(callbacke: CallbackQuery, state: FSMContext):
       dep_id = callbacke.data.split(':')[1]
       mes = 'Корпуса'
       mkb = kb.build_chose(int(dep_id), is_ap = True)
       mst = st.AdminPanel.buildCat

       await util.push_scene(
              state,
              message_id=callbacke.message.message_id,
              text=mes,
              keyboard=mkb,
              state_name=mst.state
       )

       await callbacke.answer()
       await callbacke.message.edit_text(mes,reply_markup= mkb)
       
"""
@router. ()
async def (message: Message, calback: CallbackQuery, state: FSMContext):
       mes = ""
       mkb = kb
       mst = st
       await state.update_data(message_id=message.message_id,
                                   text=mes,
                                   keyboard=mkb,
                                   state=mst.state)
"""