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

async def main():
        await async_main()
        load_dotenv()
        bot = Bot(token=os.getenv('TOKEN'))
        dp = Dispatcher()
        dp.include_router(router)
        await dp.start_polling(bot)

if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print('Бот выключен')  



        