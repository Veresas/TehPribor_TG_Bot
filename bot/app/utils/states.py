from aiogram.fsm.state import State, StatesGroup


class Register(StatesGroup):
       fio = State()
       number = State()
       role = State()
       final = State()
       adminAcept = State()

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
       diogram = State()
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

class ChangRatio(StatesGroup):
       choose_type = State()
       select_cargo_type= State()
       select_time = State()
       select_weight = State()
       set_new_ratio = State()
       set_generic_ratio = State()
       set_group_ratio = State()
       set_value_ratio = State()
       
class Test(StatesGroup):
       start = State()

class AdminPanel(StatesGroup):
       menu = State()
       stuffCat = State()
       coefCat = State()
       buildCat = State()

class AP_Staff(StatesGroup):
       deivet = State()
       disp = State()
       admins =State()

class DriverSalyre(StatesGroup):
       set_period = State()
       start = State()

class AddBuilding(StatesGroup):
    choose_department_type = State()
    choose_department = State()
    input_name = State()
    input_description = State()
    confirm = State()

class AddDepartment(StatesGroup):
    choose_type = State()
    input_name = State()
    choose_building = State()
    input_description = State()
    confirm = State()

class AddDepartmentAndBuilding(StatesGroup):
    choose_type = State()
    input_department_name = State()
    input_building_name = State()
    input_description = State()
    confirm = State()