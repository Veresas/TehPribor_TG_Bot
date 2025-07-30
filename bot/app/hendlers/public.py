from aiogram import F, Router, Bot
from aiogram.types import Message, CallbackQuery, ReplyKeyboardRemove, ContentType
from aiogram.filters import CommandStart, Command, StateFilter

from aiogram.fsm.context import FSMContext
import app.validators as valid
import app.keyboards as kb
import app.database.requests as rq

from datetime import datetime, timedelta

import logging
import app.utils.states as st
import app.utils.help_func as util
from app.utils.help_func import clean_user_input

router = Router()
publicRouter = Router()

@publicRouter.message(CommandStart())
async def cmd_start(message:Message):
       if await rq.check_user(tg_id=message.from_user.id):
              await message.answer('Добро пожаловать в программу оптимизации логистики!')
       else:
              await message.answer('Вы еще не зарегистрированы. Пожалуйста, введите /register')

@router.message(Command('reload_comand'))
async def reload_comand(message: Message, bot: Bot):
    try:
        await util.set_user_commands(bot, message.from_user.id)
        await message.answer('Список команд успешно обновлен')
    except Exception as e:
        logging.error(f"Ошибка обновления команд: {e}")
        await message.answer('Ошибка обновления команд, попробуйте позже')

# region регистрация
@publicRouter.message(Command('register'))
async def register(message: Message, state:FSMContext):

       await state.clear()
       if await rq.check_user(tg_id=message.from_user.id):
               await message.answer('Вы уже зарегистрированы')
       else:
              await state.set_state(st.Register.fio)
              await message.answer('Введите ваше ФИО')

@publicRouter.message(st.Register.fio)
async def register_name (message: Message, state: FSMContext):
       if valid.valid_fio(message.text):
              await state.update_data(fio=clean_user_input(message.text))
              await state.set_state (st.Register.number)
              await message.answer('Отправьте ваш номер телефона', reply_markup=kb.get_number)
       else:
              await message.answer('Введены некорректные данные. Ожидалась строка, содержащая 2 или 3 слова, начинающихся с большой буквы. Повторите попытку.')

@publicRouter.message(st.Register.number, F.contact)
async def register_number(message: Message, state: FSMContext):
       await state.update_data(number=message.contact.phone_number)
       await state.set_state(st.Register.role)
       await message.answer('Выберите роль', reply_markup = kb.roles)
       

@publicRouter.callback_query(StateFilter(st.Register.role, st.ChangeRole.start), F.data.startswith('role_') )
async def register_role(calback: CallbackQuery, state: FSMContext):
       calbackRole = calback.data.split('_')[1]
       match calbackRole:
              case 'disp':
                     calbackRole = 'Диспетчер'
              case 'driver':
                     calbackRole = 'Водитель'
              case 'admin':
                     calbackRole = 'Администратор'
       await state.update_data(role = calbackRole)
       data = await state.get_data()
       await state.set_state(st.Register.final)
       await calback.answer()
       await calback.message.answer(f'Ваше имя: {data["fio"]}\nВаш номер: {data["number"]}\nВаша роль: {data["role"]}', reply_markup=kb.regKey)

@publicRouter.callback_query(st.Register.final, F.data == 'cmd_register_accept')
async def new_register_accept(callback: CallbackQuery, state: FSMContext, bot: Bot):
       data = await state.get_data()
       await callback.answer()
       await state.clear()
       await callback.answer()
       await rq.reg_user(data=data,tg_id=callback.from_user.id)
       await request_to_admin(callback.from_user.id, bot, data)
       await callback.message.answer('Ожидайте подтверждения администратора', reply_markup=ReplyKeyboardRemove())

async def request_to_admin(tgId: int, bot: Bot, data):
       adminIds = await rq.get_admins_for_alarm()
       mes = f'Запрос на регистрацию:\n\n Имя: {data["fio"]}\nНомер: {data["number"]}\nРоль: {data["role"]}'
       for adminId in adminIds:
             await bot.send_message(adminId, text= mes, reply_markup=kb.regAdminAcepts(tgId))

@publicRouter.callback_query(st.Register.final, F.data == 'cmd_register_cancel')
async def new_register_cancel(callback: CallbackQuery, state: FSMContext):
       await state.clear()
       await callback.answer()
       await callback.message.answer('Регистрация отменена. Для повторной попытки введите /register')



@publicRouter.message(Command('cancel'), StateFilter('*'))
async def cancelCom(message: Message, state:FSMContext):
       await state.clear()
       await message.answer('Команда отменена', reply_markup=ReplyKeyboardRemove())
# endregion

# region Просмотр каталога заказов
@router.message(Command("orders"))
async def order_catalog_choice(message: Message, state:FSMContext):
       await state.clear()

       userRole = await rq.get_user_role(tg_id=message.from_user.id)
       await state.update_data(indexStart = 0, indexEnd = 5, userRole = userRole, tg_id=message.from_user.id, button_text="take_order")  
       if(userRole != "Водитель"):
              await message.answer("Выберите требуемый статус у заказа", reply_markup=kb.choseOrderStatusList)
              await state.set_state(st.Order_list.order_ststus)
       else:
              await message.answer("Выберите, на какой день вы хотите просмотреть список заказов", reply_markup= await kb.order_day(message.from_user.id))
              await state.set_state(st.Order_list.start)

@router.message(st.Order_list.order_ststus, F.text.lower().in_(["доступен ✅", "в работе 🔧", "завершен ✔️", "все 🌐"]))
async def status_order_catalog(message: Message, state:FSMContext):
       status = message.text.lower()
       if status == "доступен ✅":
              await state.update_data(statusId = 1)
       elif status == "в работе 🔧":
              await state.update_data(statusId = 2)
       elif status == "завершен ✔️":
              await state.update_data(statusId = 3)
       
       await state.set_state(st.Order_list.start)
       await message.answer("Выберите, на какой день вы хотите просмотреть список заказов", reply_markup= await kb.order_day(message.from_user.id))


@router.message(st.Order_list.start, F.text.lower().in_(["сегодня ☀️", "завтра 🌤️", "все 🌐"]))
async def order_catalog(message: Message, state:FSMContext):
       data = await state.get_data()
       if message.text.lower() == "сегодня ☀️":
              orderKyes = await rq.get_order_keys(dateTime=datetime.today().date(), tg_id=data["tg_id"], statusId=data.get("statusId", None))
       elif message.text.lower() == "завтра 🌤️":
              orderKyes = await rq.get_order_keys(dateTime=datetime.today().date() + timedelta(days=1), tg_id=data["tg_id"], statusId=data.get("statusId", None))
       elif data["userRole"] != "Водитель":
              if message.text.lower() == "все 🌐" :
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

@router.callback_query(StateFilter(st.Order_list.start, st.Privat_order_list.start), F.data ==('order_move_back'))
async def order_move_back(callback: CallbackQuery, state: FSMContext):
       await callback.answer()
       data = await state.get_data()
       await state.update_data(indexStart = (data["indexStart"]-5), indexEnd = (data["indexEnd"]-5))
       orders = await rq.get_orders(ordersKeys= data["orderList"], start=data["indexStart"]-5, end=data["indexEnd"]-5)
       mes = "\n".join(orders)
       current_state = await state.get_state()
       data["indexStart"] = (data["indexStart"]-5)
       data["indexEnd"] = (data["indexEnd"]-5)
       await callback.message.edit_text(mes, reply_markup= await kb.order_select_keyboard(data=data, isHistoruPraviteCatalog=data.get("isHistoruPraviteCatalog", False)), parse_mode="HTML")

@router.callback_query(StateFilter(st.Order_list.start, st.Privat_order_list.start), F.data == ('order_move_forward'))
async def order_move_forward(callback: CallbackQuery, state: FSMContext):
       await callback.answer()
       data = await state.get_data()
       await state.update_data(indexStart = (data["indexStart"]+5), indexEnd = (data["indexEnd"]+5))
       orders = await rq.get_orders(ordersKeys= data["orderList"], start=data["indexStart"]+5, end=data["indexEnd"]+5)
       mes = "\n".join(orders)
       data["indexStart"] = (data["indexStart"]+5)
       data["indexEnd"] = (data["indexEnd"]+5)
       await callback.message.edit_text(mes, reply_markup= await kb.order_select_keyboard(data=data, isHistoruPraviteCatalog=data.get("isHistoruPraviteCatalog", False) ), parse_mode="HTML")

@router.callback_query(st.Order_list.start, F.data.startswith('take_order:'))
async def order_take(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await state.update_data(orderId = orderId)
       await callback.answer()
       await callback.message.answer(f'Вы выбрали заказ №{orderId}', reply_markup= kb.publicCatalogKey)


@router.callback_query(st.Order_list.start, F.data ==('accept_take_order'))
async def order_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       await callback.answer()
       try:
              result = await rq.take_order(tg_id=data["tg_id"], order_id=int(data["orderId"]))
              if result == 'ok':
                     await callback.message.answer(f'Вы взяли заказ: {data["orderId"]}', reply_markup=ReplyKeyboardRemove())
                     chat_id, mes = await rq.get_user_for_send(orderId=int(data["orderId"]), driver_id=data["tg_id"], action_text="Взятие в работу")
                     await callback.message.bot.send_message(chat_id=chat_id, text=mes, parse_mode="HTML")
                     await state.clear()
              elif result == 'too_many':
                     await callback.message.answer('У вас слишком много активных заказов. Сначала завершите часть из них.')
              else:
                     await callback.message.answer(f'Этот заказ уже взят')
       except Exception as e:
              await callback.message.answer(f'При взятии заказа произошла ошибка. Попробуйте позже.')
# endregion

# region Личные каталоги доставщиков/диспетчеров
@router.message( Command("my_orders"))
async def private_order_catalog_choice(message: Message, state:FSMContext): 
       await state.clear()  

       userRole = await rq.get_user_role(tg_id=message.from_user.id)
       await state.update_data(indexStart = 0, indexEnd = 5, userRole = userRole, tg_id=message.from_user.id, button_text="complete_order")
       if userRole != "Водитель":
              await message.answer("Выберите требуемый статус у заказа", reply_markup=kb.choseOrderStatusList)
              await state.set_state(st.Privat_order_list.order_ststus)
       else:
              await message.answer("Выберите категорию списка заказов", reply_markup= kb.private_order_list_kb)
              await state.set_state(st.Privat_order_list.start)

@router.message(st.Privat_order_list.order_ststus, F.text.lower().in_(["доступен ✅", "в работе 🔧", "завершен ✔️", "все 🌐"]))
async def status_order_catalog(message: Message, state:FSMContext):
       status = message.text.lower()
       if status == "доступен ✅":
              await state.update_data(statusId = 1)
       elif status == "в работе 🔧":
              await state.update_data(statusId = 2)
       elif status == "завершен ✔️":
              await state.update_data(statusId = 3)
       
       await state.set_state(st.Privat_order_list.start)      
       await message.answer("Выберите категорию списка заказов", reply_markup= kb.private_order_list_kb)

@router.message(st.Privat_order_list.start, F.text.lower().in_(["активные заказы 🚀", "история заказов 📜"]))
async def private_order_catalog(message: Message, state:FSMContext):
       data = await state.get_data()
       if message.text.lower() == "активные заказы 🚀":
              orderKyes = await rq.get_order_keys(tg_id=data["tg_id"], isActual=True, isPrivateCatalog=True, statusId=data.get("statusId", None))
              await state.update_data(isPrivatCatalog = True)
       elif message.text.lower() == "история заказов 📜":
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

@router.callback_query(st.Privat_order_list.start, F.data.startswith('complete_order:'))
async def complete_take(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await state.update_data(orderId = orderId)
       await callback.answer()
       await callback.message.answer(f'Вы выбрали заказ №{orderId}', reply_markup= kb.privateCatalogKey)

@router.callback_query(st.Privat_order_list.start, F.data == ('accept_complete_order'))
async def acept_complete_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       await callback.answer()
       try:
              if await rq.complete_order(tg_id=data["tg_id"], order_id=int(data["orderId"])):
                     await callback.message.answer(f'Вы завершили заказ: {data["orderId"]}', reply_markup=ReplyKeyboardRemove())
                     chat_id, mes = await rq.get_user_for_send(orderId=int(data["orderId"]), driver_id=data["tg_id"], action_text="Завершение", optin_mes="Оцените работу транспортировщика: ")
                     await callback.message.bot.send_message(chat_id=chat_id, text=mes, reply_markup=await kb.rateKey(data["orderId"]), parse_mode="HTML")
                     await state.clear()
              else:
                     await callback.message.answer(f'Этот заказ уже завершен')
       except Exception as e:
              await callback.message.answer(f'При завершении заказа произошла ошибка. Попробуйте позже.')

@router.callback_query(st.Privat_order_list.start, F.data == ('take_off_complete_order'))
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

@router.callback_query(st.Privat_order_list.start, F.data == ('wath_photo_complete_order'))
async def wath_photo_complete_take(callback: CallbackQuery, state: FSMContext):
       data = await state.get_data()
       photoId  = await rq.get_order_photo(order_id=data["orderId"])
       await callback.answer()
       if photoId is not None:
              await callback.message.answer_photo(photoId )
       else:
              await callback.message.answer(f'У этого заказа нет фото')


@router.callback_query(st.Privat_order_list.start, F.data.startswith('cmd_choice_order:'))
async def disp_chois_order_action(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await callback.answer()
       await callback.message.answer(f'Выберите действие над заказом {orderId}', reply_markup= await kb.dispPrivetOrdersKey(orderId=orderId))

@router.callback_query(st.Privat_order_list.start, F.data.startswith('cmd_cancel_order:'))
async def cancel_order(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await callback.answer()
       data = {
              "order_id": orderId,
              "edit_order_status": 4
       }
       try:
              await rq.edit_order(data=data)
              await callback.message.answer(f'Заказ {orderId} успешно отменен', reply_markup=ReplyKeyboardRemove())
              await state.clear()
       except Exception as e:
              await callback.message.answer(f"При отмене заказа поизошла ошибка. Побробуйте позже")


@router.callback_query(st.Privat_order_list.start, F.data.startswith('cmd_edit_order:'))
async def edit_order(callback: CallbackQuery, state: FSMContext):
       orderId = callback.data.split(':')[1]
       await state.clear()
       await state.set_state(st.EditOrder.select_field)
       order = await rq.get_order(orderId=int(orderId))
       cargo_type = order.orderTypeName
       mes = f'Редактирование заказа\n'
       mes = mes + await rq.form_order(order=order, cargo_type=cargo_type)
       await state.update_data(order_id=orderId, order = order)
       await callback.answer()
       await callback.message.answer(mes, reply_markup= kb.edit_order_keyboard , parse_mode="HTML")
# endregion

@router.message( Command('start_work'))
async def driver_start_work(message: Message):
       await message.answer("Отправь свою геопозицию. Для отслеживания в реальном времени выбери live location.", reply_markup=kb.shearGPS)
                

@router.message(F.content_type == ContentType.LOCATION)
async def handle_location(message: Message):
    user_id = await rq.get_user_id(message.from_user.id)
    loc = message.location

    # Сохраняем каждую точку в БД
    await rq.save_location(
        user_id=user_id,
        latitude=loc.latitude,
        longitude=loc.longitude,
        timestamp=message.date
    )

@router.edited_message(F.content_type == ContentType.LOCATION)
async def handle_location_edit(message: Message):
       await handle_location(message)

@router.message( Command('map'))
async def get_map(message: Message):

       map_image = await rq.get_map(tg_id=message.from_user.id, date=datetime.today())

       if isinstance(map_image, str):
        # Если вернулась строка, это сообщение об ошибке
              await message.answer(map_image)
       else:
              # Если вернулся BufferedInputFile, отправляем фото
              await message.answer_photo(photo=map_image, caption="Ваш маршрут")

@router.message( Command('change_role'))
async def cahnge_role(message: Message, state: FSMContext):
       await state.clear()
       await state.set_state(st.ChangeRole.start)
       await state.update_data(tg_id = message.from_user.id)
       await message.answer('Выберите роль. Для отмены регистрации введите /cancel', reply_markup = kb.roles)  


@router.message( Command('help'))
async def cmd_help(message: Message):
       user_role = await rq.get_user_role(tg_id=message.from_user.id)
       mes = "Заглушка"
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
                            "Панель администратора: /admin_panel \n"
                            "Панелт админстратора предоставляет функции для просмотра сотрудников, отдеов/корпусов и коэфицентов."
                     )

       await message.answer(mes)

@router.callback_query(F.data == "go_back")
async def go_back(callback: CallbackQuery, state: FSMContext):
       last = await util.pop_scene(state)

       if not last:
              await callback.answer("🔙 Назад недоступен", show_alert=True)
              return

       await callback.message.edit_text(
              text=last["text"],
              reply_markup=last["keyboard"]
       )

       await callback.answer("🔙 Возврат назад")

