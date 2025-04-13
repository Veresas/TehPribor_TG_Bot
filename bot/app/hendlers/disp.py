from aiogram import F, Router
from aiogram.types import Message, CallbackQuery, ReplyKeyboardRemove
from aiogram.filters import Command

from aiogram.fsm.context import FSMContext
import app.validators as valid
import app.keyboards as kb
import app.database.requests as rq

from datetime import datetime, timedelta
import logging
import app.utils.states as st

router = Router()

# region создание заказа
@router.message(Command('new_order'))
async def order_creat_start(message: Message, state:FSMContext):
       await state.clear()
       userRole = await rq.get_user_role(tg_id=message.from_user.id)
       if(userRole != "Водитель"):
              await state.set_state(st.Order.cargo_name)
              await message.answer('Начало создания заказа. Введите название груза')
       else:
              await message.answer('Эта команда вам недоступна')

@router.message(st.Order.cargo_name)
async def order_cargo_name(message: Message, state:FSMContext):
       await state.update_data(cargo_name=message.text)
       await state.update_data(tg_id=message.from_user.id)
       await state.set_state(st.Order.cargo_description)
       await message.answer('Введите краткое описание груза при необходимости. В случае отсутствия описания введите "Нет"')

@router.message(st.Order.cargo_description)
async def order_cargo_description(message: Message, state:FSMContext):
       await state.update_data(cargo_description=message.text)
       await state.set_state(st.Order.cargo_type)
       await message.answer('Пожалуйста, выберите тип груза', reply_markup= await kb.cargo_types_keyboard())

@router.callback_query(st.Order.cargo_type, F.data.startswith('cargo_'))
async def order_cargo_type(callback: CallbackQuery, state: FSMContext):
       await callback.answer()
       cargo_key = callback.data.split("_")[1]
       await state.update_data(cargo_type_id = cargo_key)
       await state.set_state(st.Order.cargo_weight)
       await callback.message.answer('Введите вес груза (кг)', reply_markup=ReplyKeyboardRemove())

@router.message(st.Order.cargo_weight)
async def order_cargo_weight(message: Message, state: FSMContext):
       if valid.valid_weight(message.text):
              await state.set_state(st.DepChoise.dep_choise)
              mes = await message.answer("Выберете категорию точки отправления", reply_markup= kb.dep_keyboard)
              await state.update_data(cargo_weight = float(message.text), next_state = st.Order.depart_loc)
       else:
              await message.answer('Некорректные данные. Повторите попытку. Если число дробное - введите его через точку')
       
@router.callback_query(st.Order.depart_loc, F.data.startswith('depart_build'))
async def order_depart_loc(callback: CallbackQuery, state: FSMContext):
       dep_buld_id = callback.data.split(':')[1]
       dep_buld_id = int(dep_buld_id)
       depart = rq.get_dep_build_input(dep_buld_id)
       await callback.answer()
       await state.update_data(depart_loc = depart, depart_loc_id = dep_buld_id, next_state = st.Order.goal_loc)
       await state.set_state(st.DepChoise.dep_choise)

       await callback.message.edit_text(f"Корпус отправки: {depart}")
       await callback.message.answer("Выберете категорию точки доставки", reply_markup= kb.dep_keyboard)


@router.callback_query(st.Order.goal_loc, F.data.startswith('depart_build'))
async def order_goal_loc(callback: CallbackQuery, state: FSMContext): 
       dep_buld_id = callback.data.split(':')[1]
       dep_buld_id = int(dep_buld_id)
       goal = rq.get_dep_build_input(dep_buld_id)
       await callback.answer()
       await state.update_data(goal_loc = goal, goal_loc_id = dep_buld_id)
       await state.set_state(st.Order.photo)
       await callback.message.edit_text(f"Корпус доставки: {goal}")
       await callback.message.answer('Хотите ли вы добавить фото к грузу?', reply_markup= kb.photoQuestKey)

@router.callback_query(st.Order.photo, F.data == ("cmd_photo_quest_accept"))
async def acept_order_photo(calback: CallbackQuery, state: FSMContext):
       await calback.answer()
       await calback.message.answer('Отправьте фото груза')

@router.callback_query(st.Order.photo, F.data == ("cmd_photo_quest_cancel"))
async def acept_order_photo(calback: CallbackQuery, state: FSMContext):
       await calback.answer()
       await state.set_state(st.Order.alarm)
       await calback.message.answer('Это срочный заказ?', reply_markup= kb.alarmOrderKey)

@router.message(st.Order.photo, F.photo)
async def get_order_photo(message: Message, state: FSMContext):
       file_id = message.photo[-1].file_id
       await state.update_data(photoId = file_id)
       await state.set_state(st.Order.alarm)
       await message.answer('Это срочный заказ?', reply_markup= kb.alarmOrderKey)

       
@router.callback_query(st.Order.alarm, F.data == "cmd_alarm_order_accept")
async def accept_alarm_order(calback: CallbackQuery, state: FSMContext):
       await calback.answer()
       await state.update_data(isUrgent= True)
       await state.set_state(st.Order.time)
       await calback.message.answer('Выберите день', reply_markup= kb.dateOrder)

@router.callback_query(st.Order.alarm, F.data == "cmd_alarm_order_cancel")
async def cancel_alarm_order(calback: CallbackQuery, state: FSMContext):
       await calback.answer()
       await state.update_data(isUrgent = False)
       await state.set_state(st.Order.time)
       await calback.message.answer('Выберите день', reply_markup= kb.dateOrder)

@router.callback_query(st.Order.time, F.data.startswith("date_order"))
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
       await state.set_state(st.Order.time)
       await calback.message.edit_text('Выберите час', reply_markup= kb.hourOrder)

@router.callback_query(st.Order.time, F.data.startswith("hour_date_order"))
async def hour_date_order(calback: CallbackQuery, state: FSMContext):
       hour = calback.data.split(':')[1]
       await calback.answer(f'{hour}')
       await state.update_data(hour=hour)
       await calback.message.edit_text('Выберите минуту', reply_markup= kb.minuteOrder)

@router.callback_query(st.Order.time, F.data.startswith("minute_date_order"))
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
       await state.set_state(st.Order.final)
       await calback.message.answer(f'Заказ \nНазвание груза: {data["cargo_name"]} \nОписание груза: {data["cargo_description"]} \nТип груза: {type_name} \nВес груза: {data["cargo_weight"]} \nЦех/корпус отправки: {data["depart_loc"]} '
              f'\nЦех/корпус назначения: {data["goal_loc"]} \nВремя забора груза: {data["time"]}', reply_markup = kb.orderKey)


@router.callback_query(st.Order.final, F.data == 'cmd_order_accept')
async def new_order_accept(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data() 
       order_id = await rq.add_new_order(data=data)
       if data["isUrgent"]:
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

@router.callback_query(st.Order.final, F.data == 'cmd_order_cancel')
async def new_order_accept(callback: CallbackQuery, state: FSMContext):
       await state.clear()
       await callback.answer()
       await callback.message.answer('Добавление заказа отменено. Для повторной попытки введите /new_order')
# endregion

# region изменение заказа
@router.callback_query(st.EditOrder.select_field, F.data.startswith("edit_order_"))
async def select_field_to_edit(callback: CallbackQuery, state: FSMContext):
    field = callback.data.split('_')[2]
    await state.update_data(editing_field=field)
    
    match field:
        case 'cargo':
            await state.set_state(st.EditOrder.edit_cargo_name)
            await callback.message.answer("Введите новое название груза:")

        case 'description':
            await state.set_state(st.EditOrder.edit_cargo_description)
            await callback.message.answer("Введите новое описание груза. Если описание не требуется, введите 'Нет':")

        case 'weight':
            await state.set_state(st.EditOrder.edit_cargo_weight)
            await callback.message.answer("Введите новый вес груза (кг). Если число дробное, используйте точку:")

        case 'type':
            await state.set_state(st.EditOrder.edit_cargo_type)
            await callback.message.answer("Выберите новый тип груза:", reply_markup=await kb.cargo_types_keyboard())

        case 'departure':
            await state.set_state(st.DepChoise.dep_choise)
            await state.update_data(next_state = st.EditOrder.edit_depart_loc)
            await callback.message.answer("Выберете категорию точки отправления", reply_markup= kb.dep_keyboard)

        case 'delivery':
            await state.set_state(st.DepChoise.dep_choise)
            await state.update_data(next_state = st.EditOrder.edit_goal_loc)
            await callback.message.answer("Выберете категорию точки назначения", reply_markup= kb.dep_keyboard)

        case 'time':
            await state.set_state(st.EditOrder.edit_time)
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

@router.message(st.EditOrder.edit_cargo_name)
async def process_edit_cargo_name(message: Message, state: FSMContext):
    new_cargo_name = message.text
    await state.update_data(edit_cargo_name=new_cargo_name) 
    await state.set_state(st.EditOrder.select_field) 
    await message.answer("Название груза обновлено.")

@router.message(st.EditOrder.edit_cargo_description)
async def process_edit_cargo_description(message: Message, state: FSMContext):
    new_cargo_description = message.text
    await state.update_data(edit_cargo_description=new_cargo_description)  
    await state.set_state(st.EditOrder.select_field) 
    await message.answer("Описание груза обновлено.")

@router.message(st.EditOrder.edit_cargo_weight)
async def process_edit_cargo_weight(message: Message, state: FSMContext):
    new_cargo_weight = message.text
    if valid.valid_weight(new_cargo_weight):
       await state.update_data(edit_cargo_weight=float(new_cargo_weight)) 
       await state.set_state(st.EditOrder.select_field) 
       await message.answer("Вес груза обновлен.")
    else:
       await message.answer('Некорректные данные. Повторите попытку. Если число дробное - введите его через точку') 

@router.callback_query(st.EditOrder.edit_cargo_type, F.data.startswith("cargo_"))
async def process_edit_cargo_type(callback: CallbackQuery, state: FSMContext):
    cargo_type_id = callback.data.split("_")[1]
    await state.update_data(edit_cargo_type_id=int(cargo_type_id))
    await state.set_state(st.EditOrder.select_field)
    await callback.message.answer("Тип груза обновлен.")
    await callback.answer()

@router.callback_query(st.EditOrder.edit_depart_loc, F.data.startswith('depart_build'))
async def process_edit_depart_loc(callback: CallbackQuery, state: FSMContext):
       dep_buld_id = callback.data.split(':')[1]
       dep_buld_id = int(dep_buld_id)
       await callback.answer()
       await state.update_data(edit_depart_loc=dep_buld_id)
       await state.set_state(st.EditOrder.select_field)
       await callback.message.answer("Место отправления обновлено.")


@router.callback_query(st.EditOrder.edit_goal_loc, F.data.startswith('depart_build'))
async def process_edit_goal_loc(callback: CallbackQuery, state: FSMContext):
       dep_buld_id = callback.data.split(':')[1]
       dep_buld_id = int(dep_buld_id)
       await callback.answer()
       await state.update_data(edit_goal_loc=dep_buld_id)  
       await state.set_state(st.EditOrder.select_field)  
       await callback.message.answer("Место доставки обновлено.")


@router.callback_query(st.EditOrder.edit_time, F.data.startswith("date_order"))
async def process_edit_date(callback: CallbackQuery, state: FSMContext):
    day = callback.data.split(':')[1]
    today = datetime.today()
    selected_date = today if day == "today" else today + timedelta(days=1)
    formatted_date = selected_date.strftime('%d.%m.%Y')

    await state.update_data(edit_day=formatted_date)  # Сохраняем новый день
    await callback.message.edit_text('Выберите час:', reply_markup=kb.hourOrder)
    await callback.answer()

@router.callback_query(st.EditOrder.edit_time, F.data.startswith("hour_date_order"))
async def process_edit_hour(callback: CallbackQuery, state: FSMContext):
    hour = callback.data.split(':')[1]
    await state.update_data(edit_hour=hour)  # Сохраняем новый час
    await callback.message.edit_text('Выберите минуту:', reply_markup=kb.minuteOrder)
    await callback.answer()

@router.callback_query(st.EditOrder.edit_time, F.data.startswith("minute_date_order"))
async def process_edit_time(callback: CallbackQuery, state: FSMContext):
    minute = callback.data.split(':')[1]
    data = await state.get_data()
    hour = data["edit_hour"]
    day = data["edit_day"]
    new_time = f'{hour}:{minute} {day}'

    await state.update_data(edit_time=new_time)  # Сохраняем новое время
    await state.set_state(st.EditOrder.select_field)  # Возвращаемся к выбору поля
    await callback.message.answer("Дата и время обновлены.")
    await callback.answer()
# endregion

# region перенос заказа
@router.callback_query(F.data.startswith("cmd_postpend_order"))
async def postpend_order(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await callback.answer()
       await state.set_state(st.PostponedOrder.selectTime)
       formatted_date = datetime.today() + timedelta(days=1)
       await state.update_data(edit_day=formatted_date.strftime('%d.%m.%Y'), order_id = orderId)
       await callback.message.edit_text('Выберите час:', reply_markup=kb.hourOrder)

@router.callback_query(st.PostponedOrder.selectTime, F.data.startswith("hour_date_order"))
async def postpend_edit_hour(callback: CallbackQuery, state: FSMContext):
       hour = callback.data.split(':')[1]
       await state.update_data(edit_hour=hour)
       await callback.message.edit_text('Выберите минуту:', reply_markup=kb.minuteOrder)
       await callback.answer()

@router.callback_query(st.PostponedOrder.selectTime, F.data.startswith("minute_date_order"))
async def postpend_edit_time(callback: CallbackQuery, state: FSMContext):
       minute = callback.data.split(':')[1]
       data = await state.get_data()
       hour = data["edit_hour"]
       day = data["edit_day"]
       new_time = f'{hour}:{minute} {day}'
       await state.update_data(edit_time=new_time, set_postponned = True)
       data = await state.get_data()
       try:
              await rq.edit_order(data=data)
              await callback.message.answer(f"Новое время: {new_time} сохранено")
              await state.clear()
       except Exception as e:
            logging.error(f'В функции переноса заказа произошла ошибка: {e} ')
            await callback.message.answer(f"При переносе заказа произошла ошибка. Повторите попытку позже")
       
       await callback.answer()

@router.callback_query(F.data.startswith("cmd_disp_cancel_order"))
async def dayEnd_cancel_order(callback: CallbackQuery):
       orderId = callback.data.split(':')[1]
       await callback.answer()
       data = {
              "order_id": orderId,
              "edit_order_status": 4
       }
       try:
              await rq.edit_order(data=data)
              await callback.message.answer(f"Заказ {data.get('order_id')} отменен")
       except Exception as e:
              logging.error(f"При отмене заказа {orderId} произошла ошибка: {e}")
              await callback.message.answer(f"При отмене заказа поизошла ошибка. Побробуйте позже")
# endregion

@router.callback_query(F.data.startswith('cmd_rate:'))
async def set_rate(callback: CallbackQuery):
       _, rate, orderId = callback.data.split(':')
       rate = int(rate)
       orderId= int(orderId)
       await callback.answer()
       try:
              await rq.set_driver_rate(orderId=orderId,rate=rate)
              await callback.message.edit_reply_markup(reply_markup=None)
              await callback.message.answer("Оценка записана")
       except Exception as e:
              await callback.message.answer("Ошибка добавления оценки. Попробуйте позже")

@router.callback_query(st.DepChoise.build_choise, F.data == 'back_to_dep_choise')
async def back_to_dep_type(callback: CallbackQuery, state: FSMContext):
    await callback.answer()
    await state.set_state(st.DepChoise.dep_choise)
    await callback.message.edit_text("Выберите категорию точки", reply_markup=kb.dep_keyboard)
      
@router.callback_query(F.data == 'back_to_build_choise')
async def back_to_dep_list(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       dep_type = data.get("dep_type")
       if dep_type is None:
              await callback.answer("Ошибка возврата: тип подразделения не найден", show_alert=True)
              return
       await state.set_state(st.DepChoise.build_choise)
       await callback.answer()
       await callback.message.edit_text("Выберите номер подразделения", reply_markup=kb.dep_chose(int(dep_type)))

@router.callback_query(st.DepChoise.dep_choise, F.data.startswith('dep_type_choise'))
async def dep_choise(callbacke: CallbackQuery, state: FSMContext):
       dep_type = callbacke.data.split(':')[1]
       await callbacke.answer()
       await state.set_state(st.DepChoise.build_choise)
       await state.update_data(dep_type=dep_type)
       await callbacke.message.edit_text('Выберите номер подразделения', reply_markup= kb.dep_chose(int(dep_type)))

@router.callback_query(st.DepChoise.build_choise, F.data.startswith('depart'))
async def build_choise(callbacke: CallbackQuery, state: FSMContext):
       dep_id = callbacke.data.split(':')[1]
       data = await state.get_data()
       await callbacke.answer()
       await state.set_state(data["next_state"])
       await callbacke.message.edit_text('Выберите корпус', reply_markup= kb.build_chose(int(dep_id)))
