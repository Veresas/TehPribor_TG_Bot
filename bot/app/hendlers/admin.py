from aiogram import F, Router, Bot 
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
import logging
from app.utils.help_func import clean_user_input

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
       if (exp_type == "diograms"):
              await callback.message.answer("Какую диаграмму отобразить?", reply_markup=kb.diogramChoise)
       else:
              await callback.message.answer("За какой период выгрузить данные?", reply_markup=kb.exp_orders_kb)

@router.callback_query(st.ExportOrder.choise, F.data.startswith("diogram:"))
async def exp_diogram(callback: CallbackQuery, state: FSMContext):
       diogramType = callback.data.split(':')[1]
       await callback.answer()
       await state.update_data(diogramType = diogramType)
       await callback.message.answer("За какой период выгрузить данные?", reply_markup=kb.exp_orders_kb)

@router.message(st.ExportOrder.choise, F.text.lower().in_(["день ☀️", "неделя 📅", "месяц 🌙", "год 🗓️", "свой ✏️"]))
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
              if data["expType"] == "diograms":
                     diograms = await rq.export_diagrama(diogramType = data["diogramType"], date_from=date_from, date_to=date_to)
                     for diogram in diograms:           
                            await message.answer_photo(diogram, reply_markup=ReplyKeyboardRemove())
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
                     mes = "Список транспортировщиков:\n" + await rq.get_stuff_List_mes(roleId=2)
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

# region Поддтверждение регистрации
@router.callback_query(F.data.startswith('cmd_admin_reg'))
async def actionWithRegRquest (callbacke: CallbackQuery, bot: Bot):
       _, action, tgId, role = callbacke.data.split(':')
       match action:
              case 'accept':
                     await rq.add_role_and_acess(tgId=tgId,role=role)
                     mes = f'Доступ разрешен, ваша роль {role}'
                     await util.set_user_commands(bot, tgId)
              case 'cancel':
                     mes = f'Доступ в систему воспрещен'
       await callbacke.answer()
       await callbacke.bot.edit_message_text(
            text="Открытие доступа: успешно",
            chat_id=callbacke.message.chat.id,
            message_id=callbacke.message.message_id)
       await bot.send_message(tgId, text=mes)

@router.message(Command("drivers_salary"))
async def drivers_payment (message: Message, state: FSMContext):
       await message.answer("Введите чило в формате ДД.ММ.ГГГГ-ДД.ММ.ГГГГ")
       await state.set_state(st.DriverSalyre.set_period)


@router.message(st.DriverSalyre.set_period)
async def salary_period(message: Message, state:FSMContext):
       if valid.valid_exp_period (message.text):
              date_from, date_to = message.text.split('-')
              await state.set_state(st.DriverSalyre.start)
              mes = await rq.get_drivers_payment(last_month_12=date_from, current_month_12=date_to)
              await message.answer(mes)
       else:
              await message.answer("Некорректный формат введных данных. Повторите еще раз")

# endregion

@router.message(Command('add_building'))
async def start_add_building(message: Message, state: FSMContext):
    try:
        kb_markup = kb.dep_keyboard
        await message.answer('Выберите тип подразделения:', reply_markup=kb_markup)
        await state.set_state(st.AddBuilding.choose_department_type)
    except Exception as e:
        logging.error(f"Ошибка в start_add_building: {e}")
        await message.answer('Ошибка при запуске добавления корпуса.')

@router.callback_query(st.AddBuilding.choose_department_type, F.data.startswith('dep_type_choise:'))
async def add_building_choose_department_type(callback: CallbackQuery, state: FSMContext):
    try:
        dep_type_id = int(callback.data.split(':')[1])
        kb_markup = kb.dep_chose(dep_type_id, is_ap = True)
        await callback.answer()
        await callback.message.edit_text('Выберите отдел:', reply_markup=kb_markup)
        await state.set_state(st.AddBuilding.choose_department)
    except Exception as e:
        logging.error(f"Ошибка в add_building_choose_department_type: {e}")
        await callback.answer('Ошибка при выборе типа подразделения.', show_alert=True)

@router.callback_query(st.AddBuilding.choose_department, F.data.startswith('depart:'))
async def add_building_choose_department(callback: CallbackQuery, state: FSMContext):
    try:
        dep_id = int(callback.data.split(':')[1])
        await state.update_data(department_id=dep_id)
        await callback.answer()
        await callback.message.answer('Введите название корпуса:')
        await state.set_state(st.AddBuilding.input_name)
    except Exception as e:
        logging.error(f"Ошибка в add_building_choose_department: {e}")
        await callback.answer('Ошибка при выборе отдела.', show_alert=True)

@router.message(st.AddBuilding.input_name)
async def add_building_input_name(message: Message, state: FSMContext):
    try:
        await state.update_data(building_name=clean_user_input(message.text.strip()))
        await message.answer('Введите описание точки (или "-" если не требуется):')
        await state.set_state(st.AddBuilding.input_description)
    except Exception as e:
        logging.error(f"Ошибка в add_building_input_name: {e}")
        await message.answer('Ошибка при вводе названия корпуса.')

@router.message(st.AddBuilding.input_description)
async def add_building_input_description(message: Message, state: FSMContext):
    try:
        desc = clean_user_input(message.text.strip())
        await state.update_data(description=desc)
        data = await state.get_data()
        dep_id = data['department_id']
        name = data['building_name']
        description = data['description']
        confirm_text = f'Добавить корпус "{name}"\nОтдел ID: {dep_id}\nОписание: {description or "-"}?'
        kb_markup = kb.confirm_kb()
        await message.answer(confirm_text, reply_markup=kb_markup)
        await state.set_state(st.AddBuilding.confirm)
    except Exception as e:
        logging.error(f"Ошибка в add_building_input_description: {e}")
        await message.answer('Ошибка при вводе описания.')

@router.callback_query(st.AddBuilding.confirm, F.data == 'confirm')
async def add_building_confirm(callback: CallbackQuery, state: FSMContext):
    try:
        data = await state.get_data()
        build_id = await rq.add_building(name=data['building_name'])
        await rq.add_department_building(department_id=data['department_id'], building_id=build_id, description=data['description'])
        await rq.dep_build_set()
        await callback.answer('Корпус добавлен!')
        await callback.message.edit_text('Корпус успешно добавлен.')
        await state.clear()
    except Exception as e:
        logging.error(f"Ошибка в add_building_confirm: {e}")
        await callback.answer('Ошибка при добавлении корпуса.', show_alert=True)
        await callback.message.edit_text('Ошибка при добавлении корпуса.')
        await state.clear()

@router.callback_query(st.AddBuilding.confirm, F.data == 'cancel')
async def add_building_cancel(callback: CallbackQuery, state: FSMContext):
    try:
        await callback.answer('Отмена')
        await callback.message.edit_text('Добавление корпуса отменено.')
        await state.clear()
    except Exception as e:
        logging.error(f"Ошибка в add_building_cancel: {e}")

@router.message(Command('add_department'))
async def start_add_department(message: Message, state: FSMContext):
    try:
        kb_markup = kb.dep_keyboard
        await message.answer('Выберите тип подразделения для нового отдела:', reply_markup=kb_markup)
        await state.set_state(st.AddDepartment.choose_type)
    except Exception as e:
        logging.error(f"Ошибка в start_add_department: {e}")
        await message.answer('Ошибка при запуске добавления отдела.')

@router.callback_query(st.AddDepartment.choose_type, F.data.startswith('dep_type_choise:'))
async def add_department_choose_type(callback: CallbackQuery, state: FSMContext):
    try:
        dep_type_id = int(callback.data.split(':')[1])
        await state.update_data(dep_type_id=dep_type_id)
        await callback.answer()
        await callback.message.answer('Введите название отдела:')
        await state.set_state(st.AddDepartment.input_name)
    except Exception as e:
        logging.error(f"Ошибка в add_department_choose_type: {e}")
        await callback.answer('Ошибка при выборе типа подразделения.', show_alert=True)

@router.message(st.AddDepartment.input_name)
async def add_department_input_name(message: Message, state: FSMContext):
    try:
        await state.update_data(department_name=message.text.strip())
        kb_markup = kb.build_chose_all(is_ap = True)
        await message.answer('Выберите корпус для отдела:', reply_markup=kb_markup)
        await state.set_state(st.AddDepartment.choose_building)
    except Exception as e:
        logging.error(f"Ошибка в add_department_input_name: {e}")
        await message.answer('Ошибка при вводе названия отдела.')

@router.callback_query(st.AddDepartment.choose_building, F.data.startswith('depart_build:'))
async def add_department_choose_building(callback: CallbackQuery, state: FSMContext):
    try:
        build_id = int(callback.data.split(':')[1])
        await state.update_data(building_id=build_id)
        await callback.answer()
        await callback.message.answer('Введите описание точки (или "-" если не требуется):')
        await state.set_state(st.AddDepartment.input_description)
    except Exception as e:
        logging.error(f"Ошибка в add_department_choose_building: {e}")
        await callback.answer('Ошибка при выборе корпуса.', show_alert=True)

@router.message(st.AddDepartment.input_description)
async def add_department_input_description(message: Message, state: FSMContext):
    try:
        desc = message.text.strip()
        await state.update_data(description=desc)
        data = await state.get_data()
        dep_type_id = data['dep_type_id']
        name = data['department_name']
        build_id = data['building_id']
        description = data['description']
        confirm_text = f'Добавить отдел "{name}"\nТип: {"Цех" if dep_type_id==1 else "Отдел"}\nКорпус ID: {build_id}\nОписание: {description or "-"}?'
        kb_markup = kb.confirm_kb()
        await message.answer(confirm_text, reply_markup=kb_markup)
        await state.set_state(st.AddDepartment.confirm)
    except Exception as e:
        logging.error(f"Ошибка в add_department_input_description: {e}")
        await message.answer('Ошибка при вводе описания.')

@router.callback_query(st.AddDepartment.confirm, F.data == 'confirm')
async def add_department_confirm(callback: CallbackQuery, state: FSMContext):
    try:
        data = await state.get_data()
        dep_id = await rq.add_department(name=data['department_name'], type_id=data['dep_type_id'])
        await rq.add_department_building(department_id=dep_id, building_id=data['building_id'], description=data['description'])
        await rq.dep_build_set()
        await callback.answer('Отдел добавлен!')
        await callback.message.edit_text('Отдел успешно добавлен.')
        await state.clear()
    except Exception as e:
        logging.error(f"Ошибка в add_department_confirm: {e}")
        await callback.answer('Ошибка при добавлении отдела.', show_alert=True)
        await callback.message.edit_text('Ошибка при добавлении отдела.')
        await state.clear()

@router.callback_query(st.AddDepartment.confirm, F.data == 'cancel')
async def add_department_cancel(callback: CallbackQuery, state: FSMContext):
    try:
        await callback.answer('Отмена')
        await callback.message.edit_text('Добавление отдела отменено.')
        await state.clear()
    except Exception as e:
        logging.error(f"Ошибка в add_department_cancel: {e}")

@router.message(Command('add_dep_and_build'))
async def start_add_dep_and_build(message: Message, state: FSMContext):
    try:
        kb_markup = kb.dep_keyboard
        await message.answer('Выберите тип подразделения для нового отдела:', reply_markup=kb_markup)
        await state.set_state(st.AddDepartmentAndBuilding.choose_type)
    except Exception as e:
        logging.error(f"Ошибка в start_add_dep_and_build: {e}")
        await message.answer('Ошибка при запуске добавления отдела и корпуса.')

@router.callback_query(st.AddDepartmentAndBuilding.choose_type, F.data.startswith('dep_type_choise:'))
async def dep_and_build_choose_type(callback: CallbackQuery, state: FSMContext):
    try:
        dep_type_id = int(callback.data.split(':')[1])
        await state.update_data(dep_type_id=dep_type_id)
        await callback.answer()
        await callback.message.answer('Введите название отдела:')
        await state.set_state(st.AddDepartmentAndBuilding.input_department_name)
    except Exception as e:
        logging.error(f"Ошибка в dep_and_build_choose_type: {e}")
        await callback.answer('Ошибка при выборе типа подразделения.', show_alert=True)

@router.message(st.AddDepartmentAndBuilding.input_department_name)
async def dep_and_build_input_department_name(message: Message, state: FSMContext):
    try:
        await state.update_data(department_name=message.text.strip())
        await message.answer('Введите название корпуса:')
        await state.set_state(st.AddDepartmentAndBuilding.input_building_name)
    except Exception as e:
        logging.error(f"Ошибка в dep_and_build_input_department_name: {e}")
        await message.answer('Ошибка при вводе названия отдела.')

@router.message(st.AddDepartmentAndBuilding.input_building_name)
async def dep_and_build_input_building_name(message: Message, state: FSMContext):
    try:
        await state.update_data(building_name=message.text.strip())
        await message.answer('Введите описание точки (или "-" если не требуется):')
        await state.set_state(st.AddDepartmentAndBuilding.input_description)
    except Exception as e:
        logging.error(f"Ошибка в dep_and_build_input_building_name: {e}")
        await message.answer('Ошибка при вводе названия корпуса.')

@router.message(st.AddDepartmentAndBuilding.input_description)
async def dep_and_build_input_description(message: Message, state: FSMContext):
    try:
        desc = message.text.strip()
        await state.update_data(description=desc)
        data = await state.get_data()
        dep_type_id = data['dep_type_id']
        dep_name = data['department_name']
        build_name = data['building_name']
        description = data['description']
        confirm_text = f'Добавить отдел "{dep_name}"\nТип: {"Цех" if dep_type_id==1 else "Отдел"}\nКорпус: {build_name}\nОписание: {description or "-"}?'
        kb_markup = kb.confirm_kb()
        await message.answer(confirm_text, reply_markup=kb_markup)
        await state.set_state(st.AddDepartmentAndBuilding.confirm)
    except Exception as e:
        logging.error(f"Ошибка в dep_and_build_input_description: {e}")
        await message.answer('Ошибка при вводе описания.')

@router.callback_query(st.AddDepartmentAndBuilding.confirm, F.data == 'confirm')
async def dep_and_build_confirm(callback: CallbackQuery, state: FSMContext):
    try:
        data = await state.get_data()
        await rq.add_department_and_building(
            department_name=data['department_name'],
            department_type_id=data['dep_type_id'],
            building_name=data['building_name'],
            description=data['description']
        )
        await rq.dep_build_set()
        await callback.answer('Отдел и корпус добавлены!')
        await callback.message.edit_text('Отдел и корпус успешно добавлены.')
        await state.clear()
    except Exception as e:
        logging.error(f"Ошибка в dep_and_build_confirm: {e}")
        await callback.answer('Ошибка при добавлении.', show_alert=True)
        await callback.message.edit_text('Ошибка при добавлении отдела и корпуса.')
        await state.clear()

@router.callback_query(st.AddDepartmentAndBuilding.confirm, F.data == 'cancel')
async def dep_and_build_cancel(callback: CallbackQuery, state: FSMContext):
    try:
        await callback.answer('Отмена')
        await callback.message.edit_text('Добавление отменено.')
        await state.clear()
    except Exception as e:
        logging.error(f"Ошибка в dep_and_build_cancel: {e}")

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