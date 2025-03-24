import os
import asyncio
import logging
from aiogram import Bot, Dispatcher
from aiogram.filters import Command
from aiogram.types import Message
from dotenv import load_dotenv
from app.handlers import router
from app.database.models import async_main
import app.database.requests as rq
from apscheduler.schedulers.asyncio import AsyncIOScheduler

load_dotenv()
bot = Bot(token=os.getenv('TOKEN'))
dp = Dispatcher()
dp.include_router(router)
scheduler = AsyncIOScheduler()

async def main():
        await async_main()
        await dp.start_polling(bot)


async def on_startup(dp):

    scheduler.add_job(
        rq.notificationDrivers,  
        'cron',  
        day_of_week='mon-fri',  
        hour='7-18',  
        minute='*/15', 
        timezone='Europe/Moscow',
        args=[bot]
    )
    scheduler.start()

async def on_shutdown(dp):
    scheduler.shutdown()
     
if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print('Бот выключен')  



        