--create database RentCarDb

--use RentCarDb

--create table DamageStatuses (
--Id int primary key identity,
--DamageStatusName nvarchar(40)
--)

--create table PaymentMethods (
--Id int primary key identity,
--PaymentMethodName nvarchar(40)
--)

--create table DriverLicenseTypes (
--Id int primary key identity,
--DriverLicenseType nvarchar(40)
--)

--create table Brands (
--Id int primary key identity,
--BrandName nvarchar(50)
--)

--create table CarTypes(
--Id int primary key identity,
--TypeName nvarchar(30)
--)

--create table CarStatuses (
--Id int primary key identity,
--Status nvarchar(40)
--)

--create table Customers(
--Id int primary key identity,
--Fullname nvarchar(80),
--Age int check(Age>18),
--PhoneNumber nvarchar(50),
--Address nvarchar(100),
--IsDeleted bit not null default 0,
--DriverLicenseType int references DriverLicenseTypes(Id)
--)

--create table ExtraServicesTypes(
--Id int primary key identity,
--ExtraServiceName nvarchar(50),
--ExtraServicePrice int not null
--)

--create table RentOrders(
--Id int primary key identity,
--CustomerId int references Customers(Id),
--Price decimal(10,2) not null,
--StatusId int references CarStatuses(Id)
--)


--create table Cars(
--Id int primary key identity,
--Model nvarchar(50),
--BrandId int references Brands(Id),
--TypeId int references CarTypes(Id),
--Availability nvarchar(20) default 'Available',
--IsDeleted bit not null default 0
--)

--create table CarDetails(
--Id int primary key identity,
--CarId int references Cars(Id),
--Year nvarchar(10),
--Color nvarchar(20),
--PlateNumber nvarchar(50) not null,
--Km int not null,
--Engine  decimal(2,1)
--)

--create table RentalExtraServices(
--Id int primary key identity,
--RentalId int references RentOrders(Id),
--ExtraServiceId int references ExtraServicesTypes(Id)
--)

--create table RentalDetails(
--Id int primary key identity,
--RentalId int references RentOrders(Id),
--PickUpDate datetime,
--DropDate datetime,
--CarId int references Cars(Id)
--)

--create table Payments(
--Id int primary key identity,
--Amount decimal(10,2),
--RentalId int references RentOrders(Id),
--MethodId int references PaymentMethods(Id)
--)

--create table RentalHandoverReport(
--Id int primary key identity,
--RentalId int references RentOrders(Id),
--DamageStatusId int references DamageStatuses(Id),
--Description nvarchar(250),
--TotalAmount decimal(10,2)
--)

--insert into PaymentMethods values
--('Cash'),
--('Card'),
--('Credit Card')

--insert into DriverLicenseTypes values 
--('A'),
--('B'),
--('C'),
--('D'),
--('BE')

--insert into CarStatuses values
--('At Costumer'),
--('Reserved'),
--('Returned')


--insert into Brands values 
--('Mercedes'),
--('Hyundai'),
--('Kia'),
--('Ford')

--insert into CarTypes values 
--('Standart'),
--('Comfort'),
--('Lux')

--insert into DamageStatuses values
--('Undamaged'),
--('Scratch'),
--('Damaged')

--insert into ExtraServicesTypes values
--('Baby Seat',30),
--('GPS',20),
--('Address Delivery',10),
--('Snow Chain Set',40)

--insert into Customers (Fullname,Age,PhoneNumber,Address,DriverLicenseType)values
--('Ilkin Bayramov',22,'123456','Baku,Bakikhanov',2),
--('Aytac Ramazanli',23,'123456','Baku,Ramana',2),
--('Lale Rzayeva',23,'123456','Baku,Bakikhanov',2)

--insert into Cars (Model,BrandId,TypeId)values 
--('Accent',2,1),
--('Rio',3,1),
--('Soul',1,1),
--('Fusion',4,2),
--('Optima',3,2)

--insert into CarDetails values
--(1,2015,'Grey','99 BT 058',117000,2.0),
--(2,2015,'White','99 CK 287',98000,1.4),
--(3,2015,'Black','10 MS 876',122000,1.6),
--(4,2018,'Grey','99 GF 426',87540,2.0),
--(5,2018,'White','99 ED 319',90230,2.0)

--insert into RentOrders values
--(1,60,2),
--(3,100,2),
--(2,80,1)

--insert into RentalDetails  values 
--(1,'2022-02-2 10:00','2022-02-4',3),
--(2,'2022-02-10 12:00','2022-02-15',5),
--(3,'2022-02-5 10:00','2022-02-7',1)

--insert into RentalExtraServices values
--(1,1),
--(2,3)

--insert into RentalHandoverReport (RentalId,DamageStatusId,TotalAmount) values
--(2,1,300)

--update RentOrders set StatusId=3
--where Id=2

--insert into Payments values 
--(200,2,1)


--create view v_getAllRentals
--as
--select r.Id,c.Fullname 'Customer', cs.CarStatusName, rd.PickUpDate, rd.DropDate, Cars.Model from RentOrders r

--join Customers c
--on r.CustomerId=c.Id

--join CarStatuses cs
--on r.StatusId=cs.Id

--join RentalDetails rd
--on rd.RentalId=r.Id

--join Cars 
--on Cars.Id=rd.CarId


--create view v_GetHandoverInfo
--as
--select  v.Id, v.Customer, v.Model, ds.DamageStatusName, rhr.TotalAmount, p.Amount 'Paid', pm.PaymentMethodName ,rhr.Description from v_getAllRentals v

--join RentalHandoverReport rhr
--on v.Id=rhr.RentalId

--join DamageStatuses ds
--on rhr.DamageStatusId=ds.Id

--join Payments p
--on p.RentalId=v.Id

--join PaymentMethods pm
--on p.MethodId=pm.Id


--select * from v_GetHandoverInfo
--where TotalAmount>Paid


--create procedure InfoByAge @Age int
--as
--select * from Customers
--where Age>@Age

--create procedure GetCarsByEngine @Engine decimal
--as
--select * from CarDetails
--where Engine=@Engine

--create function GetPaymentById (@RentalId int)
--returns decimal
--as 
--begin
--declare @TotalPayment decimal
--select @TotalPayment=sum(Amount) from Payments
--where @RentalId=RentalId
--return @TotalPayment
--end

--select dbo.GetPaymentById(2)

--create function GetAvgAgeByAge (@Age int)
--returns int
--as
--begin
--declare @AvgAge int
--select @AvgAge=Avg(Age) from Customers 
--where Age>@Age
--return @AvgAge
--end

--select dbo.GetAvgAgeByAge(22)

--create trigger SoftDelete on Customers
--instead of Delete
--as
--begin
--update Customers set IsDeleted=1
--where Id in (select Id from deleted)
--end

--delete from Customers
--where Id=3

--create trigger SoftDeleteCars on Cars
--instead of Delete
--as 
--begin
--update Cars set IsDeleted=1
--where Id in (select Id from deleted)
--end

--create trigger SelectAllAfterInsertRental on RentOrders
--after insert
--as
--begin
--select * from RentOrders
--end

--insert into RentOrders values
--(3,50,1)

