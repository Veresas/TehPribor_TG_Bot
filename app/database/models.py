from sqlalchemy import BigInteger, String, ForeignKey, DateTime, Text, Float
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship
from sqlalchemy.ext.asyncio import AsyncAttrs, async_sessionmaker, create_async_engine
import os 
from dotenv import load_dotenv
load_dotenv()

DATABASE_URL = os.getenv('SQLALCHEMY_URL')
if not DATABASE_URL:
    raise ValueError("Переменная окружения SQLALCHEMY_URL не определена.")
engine = create_async_engine(url=DATABASE_URL)

async_session = async_sessionmaker(engine)


class Base(AsyncAttrs, DeclarativeBase):
    pass

class User (Base):
    __tablename__ = 'users'

    idUser: Mapped[int] = mapped_column(primary_key=True)
    tgId: Mapped[int] = mapped_column(BigInteger, unique=True)
    phone: Mapped[str] = mapped_column(String(15))
    fio: Mapped[str] = mapped_column(String(100))
    roleId: Mapped[int] = mapped_column(ForeignKey('roles.idRole'))

    disp: Mapped[list['Order']] = relationship(
        back_populates='dispatcher',
        foreign_keys='Order.dispatcherId'
    )
    driver: Mapped[list['Order']] = relationship(
        back_populates='executor',
        foreign_keys='Order.driverId'
    )
    role: Mapped['Role'] = relationship(back_populates='users')

class Role(Base):
    __tablename__ = 'roles'
    
    idRole: Mapped[int] = mapped_column(primary_key=True)
    roleName: Mapped[str] = mapped_column(String(50))
    
    users: Mapped[list['User']] = relationship(back_populates='role')

class Order (Base):
    __tablename__= 'orders'

    idOrder: Mapped[int] = mapped_column(primary_key=True)
    cargoName: Mapped[str] = mapped_column(Text())
    cargoDescription: Mapped[str] = mapped_column(Text())
    cargoTypeId: Mapped[int] = mapped_column(ForeignKey('cargoTypes.idCargoType'))
    cargo_weight: Mapped[float] = mapped_column(Float)
    depart_loc: Mapped[str] = mapped_column(String(20))
    goal_loc: Mapped[str] = mapped_column(String(20))
    time: Mapped[DateTime] = mapped_column(DateTime())
    orderStatusId: Mapped[int] = mapped_column(ForeignKey('orderStatuses.idOrderStatus'))
    dispatcherId: Mapped[int] = mapped_column(ForeignKey('users.idUser'))
    driverId: Mapped[int | None] = mapped_column(
        ForeignKey('users.idUser'),
        nullable=True
    )
    photoId: Mapped[str|None] = mapped_column(String(max), nullable=True)

    cargoType: Mapped['CargoType'] = relationship(back_populates='orders')
    orderStatus: Mapped['OrderStatus'] = relationship(back_populates='orders')
    dispatcher: Mapped['User'] = relationship(
        back_populates='disp',
        foreign_keys=[dispatcherId]
    )
    executor: Mapped['User | None'] = relationship(
        back_populates='driver',
        foreign_keys=[driverId]
    )

class CargoType (Base):
    __tablename__='cargoTypes'

    idCargoType: Mapped[int] = mapped_column(primary_key=True)
    cargoTypeName: Mapped[str]=  mapped_column(String(50))

    orders: Mapped[list['Order']] = relationship(back_populates='cargoType')

class OrderStatus (Base):
    __tablename__= 'orderStatuses'

    idOrderStatus: Mapped[int] = mapped_column(primary_key=True)
    orderStatusName: Mapped[str] = mapped_column(String(40))

    orders: Mapped[list['Order']] = relationship(back_populates='orderStatus')

async def async_main():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
