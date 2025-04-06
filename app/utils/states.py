from aiogram.fsm.state import State, StatesGroup


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

class PostponedOrder(StatesGroup):
       selectTime = State()

class ChangeRole(StatesGroup):
       start = State()
       pas = State()

class DepChoise(StatesGroup):
       dep_choise = State()
       build_choise = State()

class Test(StatesGroup):
       start = State()