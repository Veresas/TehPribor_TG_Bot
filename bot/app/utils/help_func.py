from aiogram.fsm.context import FSMContext

async def push_scene(state: FSMContext, *, message_id: int, text: str, keyboard, state_name: str):
       data = await state.get_data()
       history = data.get("history", [])

       history.append({
              "message_id": message_id,
              "text": text,
              "keyboard": keyboard,
              "state": state_name
       })

       await state.update_data(history=history)

async def pop_scene(state: FSMContext):
       data = await state.get_data()
       history = data.get("history", [])

       if len(history) < 2:
              return None  # Нечего откатывать

       # Удаляем текущий экран
       history.pop()

       # Берем предыдущий
       last_scene = history[-1]

       await state.update_data(history=history)
       await state.set_state(last_scene["state"])

       return last_scene
