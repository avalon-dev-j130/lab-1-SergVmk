/*
 * TODO(Студент): Опишите процесс создания базы данных
 * 1. Создайте все таблицы, согласно предложенной диаграмме.
 * 2. Опишите все необходимые отношения между таблицами.
 * 3. Добавьте в каждую таблицу минимум три записи.
 */

--Создание таблиц
--Блок пользователи и роли
create table UserInfo
(
    Id int not null primary key generated always as identity (start with 1, increment by 1),
    "NAME" varchar(255),
    SurName varchar(255)
);

create table Roles
(
    Id int not null unique
        generated always as identity (start with 1, increment by 1),
    "NAME" varchar(255) not null primary key
);

create table "USER"
(
    Id int not null unique
        generated always as identity (start with 1, increment by 1),
    Email varchar(255) not null primary key,
    Password varchar(255),
    Info int not null unique,
    "ROLE" int, 
    Constraint FK_User_To_UserInfo Foreign key (Info) references UserInfo(Id),    
    Constraint FK_User_To_Role Foreign key ("ROLE") references "ROLES"(Id)  
);

--Поставщик
create table Supplier
(
    Id int not null unique generated always as identity (start with 1, increment by 1),
    "NAME" varchar(255) not null primary key, 
    Adress varchar(255) not null,
    Phone varchar(255),
    Representive varchar(255) not null
);

--Товар
create table Product
(
    Id int not null unique 
       generated always as identity(start with 1, increment by 1),
    Code varchar(255) not null primary key,
    Title varchar(255),
    Supplier int ,
    Initial_Price double,
    Retail_Price double,
    Constraint FK_Product_To_Supplier Foreign key (Supplier) references Supplier(Id)    
);
--Заказ
 create table "ORDER"
 (
     Id int unique not null generated always as identity(start with 1, increment by 1),
     "USER" int,
     created timestamp, 
     Constraint FK_Order_To_Users Foreign key ("USER") references "USER"(Id)    
 );
--Связь заказа и товара
create table "ORDER2PRODUCT"
(
    "ORDER" int,
    Product int,
    Constraint PK_Order2Product Primary key ("ORDER",Product), 
    Constraint FK_Order2Product_To_Order Foreign key ("ORDER") references "ORDER"(Id),    
    Constraint FK_Order2Product_To_Product Foreign key (Product) references Product(Id)    
);

--Добавим записи в таблицы
--Сначала поставщики
Insert into Supplier 
("NAME",Adress,Phone,Representive) 
values
('Балтика','Спб пр-т Энгельса д.12','678-09-22','Иванов Петр Аркадьевич');

Insert into Supplier 
("NAME",Adress,Phone,Representive) 
values
('Эфес','Спб пр-т Стачек д 114','433-32-21','Воронов Максим Павлович');

Insert into Supplier 
("NAME",Adress,Phone,Representive) 
values
('Карлсберг','Спб ул. Пролетарская д 89','588-22-11','Пронин Василий Васильевич');

--Товары
Insert into Product
(Code,Title,Supplier,Initial_Price,Retail_Price)
values
('1','Балтика №3',1,33.50,55);

Insert into Product
(Code,Title,Supplier,Initial_Price,Retail_Price)
values
('131','Балтика №7',1,33.50,55);

Insert into Product
(Code,Title,Supplier,Initial_Price,Retail_Price)
values
('132','Балтика Портер',1,38.20,62.50);

Insert into Product
(Code,Title,Supplier,Initial_Price,Retail_Price)
values
('231','ЭфесПилснер',2,46.45,71.20);

--Пользователи
--Роли
Insert into roles
("NAME") values ('Admin');
Insert into roles
("NAME") values ('User');
Insert into roles
("NAME") values ('Castomer');

--Инфо + пользователь
Insert into UserInfo
("NAME",SurName)
values
('Вася', 'Админчег');

insert into "USER"
(Email,Password,Info,"ROLE")
values
('admin@ggg.ru','123',
(select max(UserInfo.ID) from UserInfo)
,(select Roles.ID from Roles where Roles."NAME" = 'Admin'));

Insert into UserInfo
("NAME",SurName)
values
('Лена', 'Бухгалтер');

insert into "USER"
(Email,Password,Info,"ROLE")
values
('buh@ggg.ru','456',
(select max(UserInfo.ID) from UserInfo)
,(select Roles.ID from Roles where Roles."NAME" = 'User'));

Insert into UserInfo
("NAME",SurName)
values
('Олег', 'Клиент1');

insert into "USER"
(Email,Password,Info,"ROLE")
values
('Oleg@client.ru','111',
(select max(UserInfo.ID) from UserInfo)
,(select Roles.ID from Roles where Roles."NAME" = 'Castomer'));

Insert into UserInfo
("NAME",SurName)
values
('Николай', 'Клиент2');

insert into "USER"
(Email,Password,Info,"ROLE")
values
('Nikolai@client.ru','333',
(select max(UserInfo.ID) from UserInfo)
,(select Roles.ID from Roles where Roles."NAME" = 'Castomer'));

--Заказы
insert into "ORDER"
("USER",created)
values
( 14,CURRENT TIMESTAMP);

insert into ORDER2PRODUCT
("ORDER",Product)
values
((select max("ORDER".ID) from "ORDER"),1);

insert into "ORDER"
("USER",created)
values
( 15,CURRENT TIMESTAMP);

insert into ORDER2PRODUCT
("ORDER",Product)
values
((select max("ORDER".ID) from "ORDER"),4);


insert into "ORDER"
("USER",created)
values
( 14,CURRENT TIMESTAMP);

insert into ORDER2PRODUCT
("ORDER",Product)
values
((select max("ORDER".ID) from "ORDER"),3);

--Все заказы по одному из клиентов
select 
UserInfo.SURNAME||' '||UserInfo."NAME" as FIO,
Product.TITLE as title,
Supplier."NAME" as supplier
from 
"USER"
left join UserInfo on UserInfo.ID = "USER".INFO
left join "ORDER" on "ORDER"."USER" = "USER".ID
left join  Order2Product on Order2Product."ORDER" = "ORDER".ID
left join Product on Product.ID = Order2Product.PRODUCT
left join Supplier on Supplier.ID = Product.SUPPLIER
where "USER".ID = 14




