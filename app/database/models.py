from sqlalchemy import BigInteger, String, ForeignKey, DateTime
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship
from sqlalchemy.ext.asyncio import AsyncAttrs, async_sessionmaker, create_async_engine
import os 
from dotenv import load_dotenv
load_dotenv()

engine = create_async_engine(url=os.getenv('SQLALCHEMY_URL'))

async_session = async_sessionmaker(engine)


class Base(AsyncAttrs, DeclarativeBase):
    pass

class User (Base):
    __tablename__ = 'users'

    idUser: Mapped[int] = mapped_column(primary_key=True)
    tgId=mapped_column(BigInteger, unique=True)
    phone: Mapped[str] = mapped_column(String(15))
    fio: Mapped[str] = mapped_column(String(100))
    age: Mapped[int] = mapped_column()
    roleId: Mapped[int] = mapped_column(ForeignKey('roles.idRole'))

    orders: Mapped[list['Order']] = relationship(back_populates='user')
    role: Mapped['Role'] = relationship(back_populates='users')

class Role(Base):
    __tablename__ = 'roles'
    
    idRole: Mapped[int] = mapped_column(primary_key=True)
    roleName: Mapped[str] = mapped_column(String(50))
    
    users: Mapped[list['User']] = relationship(back_populates='role')

class Order (Base):
    __tablename__= 'orders'

    idOrder: Mapped[int] = mapped_column(primary_key=True)
    cargoTypeId: Mapped[int] = mapped_column(ForeignKey('cargoTypes.idCargoType'))
    cargo_weight: Mapped[int] = mapped_column()
    depart_loc: Mapped[int] = mapped_column()
    goal_loc: Mapped[int] = mapped_column()
    time: Mapped[DateTime] = mapped_column(DateTime())
    orderStatusId: Mapped[int] = mapped_column(ForeignKey('orderStatuses'))

    cargoType: Mapped['CargoType'] = relationship(back_populates='order')
    orderStatus: Mapped['OrderSatus'] = relationship(back_populates='order')

class CargoType (Base):
    __tablename__='cargoTypes'
    idCargoType: Mapped[int] = mapped_column(primary_key=True)
    cargoTypeName: Mapped[str]=  mapped_column(String(50))

    order: Mapped['Order'] = relationship(back_populates='cargoType')

class OrderSatus (Base):
    __tablename__= 'orderStatuses'

    idOrderStatus: Mapped[int] = mapped_column(primary_key=True)
    orderStatusName: Mapped[str] = mapped_column(String)

    order: Mapped['Order'] = relationship(back_populates='orderStatus')

"""class Cargo (Base):
    __tablename__ = 'Cargos'

    idCargo: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(25))
    description: Mapped[str] = mapped_column(String(120))
    cargosTypeId: Mapped[int] = mapped_column(ForeignKey('cargoType'))

"""

async def async_main():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
