from sqlalchemy import BigInteger, Index, String, ForeignKey, DateTime, Text, Float, Boolean, func, UniqueConstraint
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship
from sqlalchemy.ext.asyncio import AsyncAttrs, async_sessionmaker, create_async_engine
import os 
from dotenv import load_dotenv
from datetime import datetime
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
    locations: Mapped[list['UserLocation']] = relationship(back_populates='user')

class Role(Base):
    __tablename__ = 'roles'
    
    idRole: Mapped[int] = mapped_column(primary_key=True)
    roleName: Mapped[str] = mapped_column(String(50))
    
    users: Mapped[list['User']] = relationship(back_populates='role')

class UserLocation(Base):
    __tablename__ = 'userLocations'
    
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey('users.idUser'), nullable=False)
    latitude: Mapped[float] = mapped_column(Float, nullable=False)
    longitude: Mapped[float] = mapped_column(Float, nullable=False)
    timestamp: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now()
    )
    
    __table_args__ = (
        Index('idx_user_locations_user_id_timestamp', 'user_id', 'timestamp'),
    )

    user: Mapped['User'] = relationship(back_populates='locations') 

class Order (Base):
    __tablename__= 'orders'

    idOrder: Mapped[int] = mapped_column(primary_key=True)
    cargoName: Mapped[str] = mapped_column(Text())
    cargoDescription: Mapped[str] = mapped_column(Text())
    cargoTypeId: Mapped[int] = mapped_column(ForeignKey('cargoTypes.idCargoType'))
    cargo_weight: Mapped[float] = mapped_column(Float)
    depart_loc: Mapped[int] = mapped_column(ForeignKey('department_buildings.department_building_id'))
    goal_loc: Mapped[int] = mapped_column(ForeignKey('department_buildings.department_building_id'))
    time: Mapped[DateTime] = mapped_column(DateTime())
    orderStatusId: Mapped[int] = mapped_column(ForeignKey('orderStatuses.idOrderStatus'))
    dispatcherId: Mapped[int] = mapped_column(ForeignKey('users.idUser'))
    driverId: Mapped[int | None] = mapped_column(
        ForeignKey('users.idUser'),
        nullable=True
    )
    photoId: Mapped[str|None] = mapped_column(String(255), nullable=True)
    pickup_time: Mapped[DateTime|None] = mapped_column(DateTime())
    completion_time: Mapped[DateTime|None] = mapped_column(DateTime())
    create_order_time: Mapped[DateTime] = mapped_column(DateTime())
    isUrgent: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    isPostponed: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    driverRate: Mapped[int| None] = mapped_column(default=None)
    
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
    depart_loc_ref: Mapped['DepartmentBuilding'] = relationship(foreign_keys=[depart_loc])
    goal_loc_ref: Mapped['DepartmentBuilding'] = relationship(foreign_keys=[goal_loc])

class CargoType (Base):
    __tablename__='cargoTypes'

    idCargoType: Mapped[int] = mapped_column(primary_key=True)
    cargoTypeName: Mapped[str] =  mapped_column(String(50))
    ratio: Mapped[float] = mapped_column(Float, nullable=False, default=1.0)

    orders: Mapped[list['Order']] = relationship(back_populates='cargoType')

class OrderStatus (Base):
    __tablename__= 'orderStatuses'

    idOrderStatus: Mapped[int] = mapped_column(primary_key=True)
    orderStatusName: Mapped[str] = mapped_column(String(40))

    orders: Mapped[list['Order']] = relationship(back_populates='orderStatus')

# Модель для таблицы department_types
class DepartmentType(Base):
    __tablename__ = 'department_types'

    department_type_id: Mapped[int] = mapped_column(primary_key=True)
    department_type_name: Mapped[str] = mapped_column(String(255), nullable=False, unique=True)

    departments: Mapped[list['Department']] = relationship(back_populates='departmentType')

# Модель для таблицы departments
class Department(Base):
    __tablename__ = 'departments'

    department_id: Mapped[int] = mapped_column(primary_key=True)
    department_name: Mapped[str] = mapped_column(String(255), nullable=False)
    department_type_id: Mapped[int] = mapped_column(ForeignKey('department_types.department_type_id'))

    departmentType: Mapped['DepartmentType'] = relationship(back_populates='departments')
    departmentBuildings: Mapped[list['DepartmentBuilding']] = relationship(back_populates='department')

    # Добавление индекса idx_departments_department_name
    __table_args__ = (
        Index('idx_departments_department_name', 'department_name'),
    )

# Модель для таблицы buildings
class Building(Base):
    __tablename__ = 'buildings'

    building_id: Mapped[int] = mapped_column(primary_key=True)
    building_name: Mapped[str] = mapped_column(String(255), nullable=False)

    departmentBuildings: Mapped[list['DepartmentBuilding']] = relationship(back_populates='building')

    # Добавление индекса idx_buildings_building_name
    __table_args__ = (
        Index('idx_buildings_building_name', 'building_name'),
    )

# Модель для таблицы department_buildings
class DepartmentBuilding(Base):
    __tablename__ = 'department_buildings'

    department_building_id: Mapped[int] = mapped_column(primary_key=True)
    department_id: Mapped[int] = mapped_column(ForeignKey('departments.department_id'))
    building_id: Mapped[int] = mapped_column(ForeignKey('buildings.building_id'))
    description: Mapped[str] = mapped_column(String(255), nullable=True)

    department: Mapped['Department'] = relationship(back_populates='departmentBuildings')
    building: Mapped['Building'] = relationship(back_populates='departmentBuildings')

    __table_args__ = (
        UniqueConstraint('department_id', 'building_id', name='department_buildings_department_id_building_id_key'),
        Index('idx_department_buildings_department_id', 'department_id'),
        Index('idx_department_buildings_building_id', 'building_id'),
    )


class TimeCoeff(Base):
    __tablename__ = "time_coefficent"

    time_coefficent_id: Mapped[int] = mapped_column(primary_key=True)
    value: Mapped[int] = mapped_column()
    coefficent: Mapped[float] = mapped_column(Float, nullable=False, default=1.0)

    __table_args__ = (
        Index('ix_time_coefficent_value', 'value'),
    )

class WeightCoeff(Base):
    __tablename__ = "weight_coefficent"
    
    weight_coefficent_id: Mapped[int] = mapped_column(primary_key=True)
    value: Mapped[float] = mapped_column(Float)
    coefficent: Mapped[float] = mapped_column(Float, nullable=False, default=1.0)
    
    __table_args__ = (
        Index('ix_weight_coefficent_value', 'value'),
    )

async def async_main():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
