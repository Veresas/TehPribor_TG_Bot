import os
import asyncio
from aiogram import Bot, Dispatcher
from dotenv import load_dotenv
from app.hendlers import public, disp, admin
from app.database.models import async_main
import app.database.requests as rq
from apscheduler.schedulers.asyncio import AsyncIOScheduler

load_dotenv()
bot = Bot(token=os.getenv('TOKEN'))
dp = Dispatcher()
dp.include_router(router=public.router)
dp.include_router(router=disp.router)
dp.include_router(router=admin.router)
scheduler = AsyncIOScheduler()

async def on_startup():

    scheduler.add_job(
        rq.notificationDrivers,  
        'cron',  
        day_of_week='mon-fri',  
        hour='7-18',  
        minute='*/15', 
        timezone='Europe/Moscow',
        args=[bot]
    )

    scheduler.add_job(
        rq.dayEnd,  
        'cron',  
        day_of_week='mon-fri',  
        hour='22',
        minute='42',  
        timezone='Europe/Moscow',
        args=[bot]
    )

    scheduler.start()

async def on_shutdown():
    scheduler.shutdown()

dp.startup.register(on_startup)
dp.shutdown.register(on_shutdown)

async def main():
        await async_main()
        await dp.start_polling(bot)
     
if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print('Бот выключен')  



        