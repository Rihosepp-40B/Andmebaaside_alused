create database TARge25

--db valimine (use Master või use TARge25, et valida DB)
use TARge25

--db kustutamine
drop database TARge25

--table tegemine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (2, 'Male'),
(1, 'Female'),
(3, 'Unknown')

--tabeli sisu vaatamine
select * from Gender

--tehke tabel nimega Person
--id int, not null, primary key
--Name nvarchar 30
--Email nvarchar 30
--GenderId Int
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderID int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderID)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'cat@cat.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

--soovime näha Person tabeli sisu
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderID) references Gender(Id)

--kui sisestada uue rea andmeid ja ei ole sisestanud genderID alla väärtust, siis
--see automaatselt sisestab sellele reale väärtuse 3 e mis on meil unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email, GenderID)
values(7, 'Flash', 'f@f.com', NULL)

insert into Person (Id, Name, Email)
values(9, 'Black Panther', 'p@p.com')

select * from Person

--kustutada DF_Persons_GenderId piirang koodiga
alter table Person
drop constraint DF_Persons_GenderId

--lisame koodiga veeru
alter table Person
add Age nvarchar(10)

--lisame nr piirangu vanuse sisestamisel (add lisab alter muudab)
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--kui tead veergude järjekorda peast, siis ei pea neid sisestama
insert into Person
values (10, 'Green Arrow', 'g@g.com', 2, 154)

--constrainti kustutamine
alter table Person
drop constraint CK_Person_Age

alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 130)

--kustutame rea
delete from person where Id = 10

--kuidas uuendada andmeid koodiga
--Id 3 uus vanus on 50
update Person
set Age = 50
where Id = 3

--lisame Person tabelisse veeru City nvarchar(50)
alter table Person
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
--kõik, kes ei ela Gothamis (!= või <> või NOT (kus) = (mis)
select * from Person where NOT City = 'Gotham'
select * from Person where City != 'Gotham'
select * from Person where City <> 'Gotham'

--näitab teatud vanusega inimesi
--35, 42, 23
select * from Person where Age = 35 or Age = 42 or Age = 23
select * from Person where Age in (35, 42, 23)

--näitab teatud vanusevahemikus olevaid isikuid 22 kuni 39
select * from Person where Age > 22 and Age < 39
select * from Person where Age between 22 and 39

--wildcardi kasutamine
--näitab kõik g-tähega algavad linnad
select * from Person where City like 'g%'

--näitab kõik g tähte sisaldavad linnad
select * from Person where City like '%g%' -- * valib kõik (võib asendada veeru valikuga, mida näidata)
--email, kus on @ märk sees
select * from Person where Email like '%@%'

--näitab, kellel on emailis ees ja peale @-märki ainult üks täht ja omakorda .com
select * from Person where Email like '_@_.com'

--kõik, kellel on nimes esimene täht w,a,s
--katusega ^ välistab tähed
select * from Person where Name like '[was]%'
select * from Person where Name like '[^was]%'

--kes elavad Gothamis ja New Yorkis (sulud on visuaalne)
select * from Person Where (city = 'Gotham' or City = 'New York')

--kes elavad Gothamis ja New Yorkis ja on vanemad, kui 29
select * from Person Where (city = 'Gotham' or City = 'New York') and Age > 29

--rida 142
-- 3 tund
-- 10.03.2026

-- kuvab tähestikulises järjekorras inimesi ja võtab aluseks nime
select * from Person order by Name
--kuvab tagurpidi
select * from Person order by Name DESC

--võtab kolm esimest rida person tabelist
select top 3 * from Person

--kolm esimest, aga tabeli järjestus on Age ja siis Name
select * from Person
select top 3 Age, Name from Person order by cast(Age as INT) --cast abil teeme Age INT muidu oli varchar

--näita esimesed 50% tabelist
select top 50 percent * from Person

--kõikide isikute koondvanus
select sum(cast(Age as INT)) from Person

--näitab kõige nooremat isikut
select min(cast(Age as Int)) from Person

--muudame Age veeru int andmetüübiks
alter table Person alter column Age int;

--näeme konkteetses linnades olevate isikute koondvanust
select sum(Age) from Person where City like 'Gotham' -- leiab ühe linna kohta
select City, sum(Age) as TotalAge from Person group by City -- arvutab kõik linnad

-- kuvab 1. reas välja toodud järestuses ja kuvab Age TotalAge'ks
-- Järjestab City's olevate nimede järgi ja siis GenderID järgi
select City, GenderID, sum(Age) as TotalAge from Person group by city, GenderID order by City

--näitab, et mitu rida on selles tabelis
select * from Person
select count(*) from Person

--näitab tulemust, et mitu inimest on GenderId väärtusega 2 konkreetses linnas
--arvutab vanuse kokku konkteetses linnas
select GenderID, City, sum(Age) As TotalAge, count(Id) as [Total Person(s)]
from Person
where GenderId = '2'
group by GenderID, City

--näitab ära inimeste koondvanuse linnas, mis on üle 41 a ja kui palju neid igas linnas elab
--eristab soo järgi
select GenderID, City, sum(Age) As TotalAge, Count(Id) as [Total Person(s)]
from Person
-- where Age > 41 -- sellega arvutaks isikud kelle vanus üksi on üle 41
group by GenderID, City having sum(age) > 41 -- having... osa võtab koond vanus üle 41

--loome tabelid Employees ja Department
create table Department
(
Id int not null primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int not null primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentID int
)

--andmete sisestamine
insert into Employees (Id, Name, Gender, Salary, DepartmentID)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800,2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russel', 'Male', 8800, NULL)

insert into Department(Id, DepartmentName, Location, DepartmentHead)
values (1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cinderella')

alter table Employees add constraint tblEmployees_DepartmentID_FK
foreign key (DepartmentID) references Department(Id)

--
select name, Gender, Salary, DepartmentName from Employees
left join Department
on Employees.DepartmentId = Department.Id

--arvutame kõikide palgad kokku -- muudame INT'iks cast abil cast(... as int)
select sum(cast(Salary as int)) as SumSalary from Employees
--min palga saja
select min(cast(Salary as int)) MinSalary from Employees

--- Rida 251
--- 4 tund
--- 17.03.26
--- teeme left join päringu
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentID = Department.Id
group by Location --ühe kuu palgafond linnade lõikes

-- Teeme veeru nimega City Employees tabelisse
--nvarchar 30
alter table Employees
add City nvarchar(30)

select * from Employees

-- peale selecti tuleb veergude nimed
select City, Gender, sum(cast(Salary as int)) as TotalSalary
--tabelist Employees ja mis on grupitatud City ja Gender järgi
from Employees group by City, Gender
--oleks vaja, et linnad oleksid tähestukulises järjekorras
order by City --- order by järjestab linnad tähestikuliselt, kui on NULLID siis need tulevad kõige ette

select count(*) from Employees --loeb mitu rida on tabelis Employees
-- * asemel võob panna ka veeru nime, aga siis loeb ainult selle veeru väärtusi, mis ei ole NULL'id

-- mitu töötajat on soo ja linna kaupa
select Gender, City, sum(cast(Salary as int)) as TotalSalary, count(*) as 'Total Employee(s)'
from Employees group by Gender, City

--Kuvab ainult kõik mehed linnade kaupa
select Gender, City, sum(cast(Salary as int)) as TotalSalary, count(*) as 'Total Employee(s)'
from Employees where Gender = 'Male' group by Gender, City

--sama tulemus, aga kasutage having klauslit
select Gender, City, sum(cast(Salary as int)) as TotalSalary, count(*) as 'Total Employee(s)'
from Employees group by Gender, City having Gender = 'Male'

--näitab meile ainult need töötajad, kellel on palga summa üle 4000
select * from Employees where Salary > 4000

--havinguga, näi´tab kus kui palju töötajaid üle 4000 palgaga
select City, sum(cast(Salary as INT)) As [TotalSalary], Count(id) as [Total Empoyee(s)]
from Employees
Group by salary, City, Name
having sum(cast(Salary as INT)) > 4000

-- loome tabeli, milles hakatakse automaatselt nummberdama Id'd
create table Test1
(Id int identity(1, 1) primary key,
Value nvarchar(30)
)

insert into Test1 values('X')
select * from Test1

---kustutame veeru nimega City Employees tabelist
alter table Employees
drop column City

-- inner join
--kuvab neid, kellel on DepartmentName all olemas väärtus
select name, Gender, Salary, DepartmentName
from Employees inner join Department
on Employees.DepartmentID = Department.Id

--left join
-- kuvab kõik read Employees tabelist,
--aga DepartmentName näitab ainult siis, kui on olemas
-- Kui DepartmentID on on NULL, siis Department Name näitab NULL
select name, Gender, Salary, DepartmentName
from Employees
left join Department on Employees.DepartmentID = Department.Id

-- right join
-- kuvab Departmenti DepartmentName'id ning iga rea Employees tabelist,
-- millel on olemas sobiv DepartmentID, DepartmentNamed millele ei ole
-- vasteid täidetakse NULL väärtustega.
select name, Gender, Salary, DepartmentName
from Employees
right join Department on Employees.DepartmentID = Department.Id

--full outer join = full join
-- kuvab kõik read (väärtused) mõlemast tabelist, kui sobituv väärtus puudub, kuvatakse NULL
select name, Gender, Salary, DepartmentName
from Employees
full join Department on Employees.DepartmentID = Department.Id

-- cross join
-- kuvab kõik read mõlemast tabelist, aga ei võta aluseks mingit veergu
-- vaid lihtsalt kombineerib kõik read omavahel
-- kasutatakse harva, aga kui on vaja kombineerida kõik
-- võimalikke komninatasioone kahe tabeli vahel, siis võib kasutada cross joini
select name, Gender, Salary, DepartmentName
from Employees
cross join Department

--päringu sisu (üldine näide)---------------
select ColumnList
from LeftTable
joinType RightTable
on JoinCondition
--^^^^^^^^ JOIN üldine näide ^^^^^^^^--

-- kuidas kuvada ainult need isikud, kellel on DepartmentName NULL
select Name, Gender, Salary, DepartmentName
from Employees
full join Department -- saab ka left
on Department.Id = DepartmentId
where DepartmentName IS NULL
--variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Department.Id = DepartmentId
where DepartmentId is null
---variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Department.Id = DepartmentId
where Department.Id is null

--- kuidas saame department tabelis oleva rea, kus on NULL
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Department.Id = DepartmentId
where Employees.ID is null

-- full join
-- kus on vaja kuvada kõik read mõlemast tabelist,
-- millel ei ole vastet.
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Department.Id = DepartmentId
where Employees.ID is null or Department.ID is null

--tabeli nimetuse muutmine koodiga
sp_rename 'Employees', 'Employees1'

-- kasutame Employees tabeli asemel, lühedit E ja M
-- aga enne seda lisame uue veeru nimega ManagerID ja see on int
alter table Employees
add ManagerID int

-- antud juhl E on Employees tabeli lühend ja M on samuti Employees tabeli lühend,
-- aga me kasutame seda, et näidata, et see on manageri tabel
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerID = M.Id

-- inner join ja kasutame lühendeid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerID = M.Id

-- cross join ja kasutame lühendeid
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

use AdventureWorksLT2019

--
select FirstName, LastName, Phone, AddressID, AddressType
from SalesLT.CustomerAddress
left join SalesLT.Customer
on SalesLT.CustomerAddress.CustomerID = SalesLT.Customer.CustomerID

--- Teha päring, kus kasutate ProductModelit ja Product, et näha,
--- millised tooted on millise mudeliga seotud
select PM.Name as ProductModel, P.Name as Product
from SalesLT.Product P
left join SalesLT.ProductModel PM
on PM.ProductModelID = P.ProductModelID

--harjutused JOIN, näidiseks
-- rida 1: select [veerud, mida näidata]
-- rida 2: from kust_tabelist_vask(left)_tabel
-- rida 3: join_meetod (left join, right join, inner join, cross join, full join millise_tabeliga_parem(right)_tabel
-- rida 4: on ühendus_tingimus (milliseid veerge kahe tabeli vahel võrrelda)
-- rida 6: where tingimus (see rida kui täpsustada milliseid ridu näidata)
select E.id, Name, Gender, Salary, D.DepartmentName, D.Location, D2.DepartmentHead
from Employees E
left join Department D
on E.DepartmentID = D.ID
left join Department D2 --teine tingimus, et liita nö kolmas tabel ühendusse
on E.ManagerID = D2.ID

-------------------- Erinevad joinid ---------------------
select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
left join Department D ---- näitab kõik vasakpoolse tabeli ridu, koos parempoolse väärtusega, kui parempoolse vaste puudub, siis parempoolne on NULL
on E.DepartmentID = D.ID

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
right join Department D ----- näitab kõiki vaskpoolse ridu millel on parempoolse vaste, kui vaste puudub, siis vasteta parempoolsed read koos vaskpoolseosas NULL väärtusega
on E.DepartmentID = D.ID

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
inner join Department D ---- näitab ridu millel on vasakul ja paremal väärtused olemas (EI ole NULL väärtusi) sama mis lihtsalt join
on E.DepartmentID = D.ID

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
full join Department D --- näitab molema poole kõik read, kõik millel on vaste ja millel pole vastet (null väärtused)
on E.DepartmentID = D.ID

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
cross join Department D --- ei kasuta on tingimust, ühendab tabelid andes iga parempoolse võimaliku rea väärtuse igale vasakpoolse tabeli reale

-------täpsustatud tingimustega-----------
select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
left join Department D
on E.DepartmentID = D.ID
where D.id is NULL -- left joiniga näitab ainult left ridasid, millel seatud tingimus nõutud väärtus

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
right join Department D
on E.DepartmentID = D.ID
where E.DepartmentID is NULL -- right joiniga näitab ainult right ridasid, millel seatud tingimus nõutud väärtus

select E.id, Name, Gender, Salary, D.DepartmentName, Location, DepartmentHead
from Employees E
full join Department D
on E.DepartmentID = D.ID
where E.departmentID is NULL or D.ID is NULL -- full joiniga näitab lef and right ridu, millel seatud tingimus nõutud väärtus (or abil saab mitu tingimust

-----self join, endaga ühendamine ----
select E.id, E.Name, E.Gender, E.Salary, M.Name as Manager
from Employees E
left join Employees M -- ühendame sama tabeli endaga andes lühendite abil "uue" tabeli funktsiooni
on E.ManagerID = M.ID

select E.id, E.Name, E.Gender, E.Salary, M.Name as Manager
from Employees E
right join Employees M --- see jätab välja isikud kellel ei ole manageri ning näitab kes pole kellegi manager.
on E.ManagerID = M.ID

select E.id, E.Name, E.Gender, E.Salary, M.Name as Manager
from Employees E
full join Employees M --- näitab nii left kui ka right join tulemust koos.
on E.ManagerID = M.ID

-- rida 502
-- 4 tund -- 31.03.2026
select ISNULL('Sinu Nimi', 'No Manager') as Manager

select coalesce(null, 'No Manager') as Manager

--Neil kellel ei ole ülemust, siis paneb neile No Manager teksti
select E.Name as Employee, isnull(M.Name, 'No Manager') as manager
from Employees E
left join Employees M
on E.ManagerID = M.ID

-- kui Expression on õige, siis paneb väärtuse, mida soovid või vastasel juhul paneb No manager teksti
case when Expression Then '' else '' end

-- teeme päringu, kus kasutame case-i, tuleb kasutada ka left join
select E.Name as Employee, case	when M.Name is NULL	Then 'No Manager'
else M.Name end as Manager
from Employees E
left join Employees M
on E.ManagerID = M.ID

--lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)
alter table Employees
add Lastname nvarchar(30)

--muudame veeru nime koodiga
sp_rename 'Employees.MiddleName1', 'MiddleName'
select * from Employees

update Employees
set MiddleName = 'Nick', LastName = 'Jones' where id = 1
update Employees
set LastName = 'Anderson' where id = 2
update Employees
set LastName = 'Smith' where id = 4
update Employees
set MiddleName = 'Todd', FirstName = NULL, LastName = 'Someone' where id = 5
update Employees
set MiddleName = 'Ten', LastName = 'Sven' where id = 6
update Employees
set LastName = 'Connor' where id = 7
update Employees
set MiddleName = 'Balerine' where id = 8
update Employees
set MiddleName = '007', LastName = 'Bond' where id = 9
update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe' where id = 10

--igast reast võtab esimesena mitte nulli väärtuse ja panemb Name veergu kasutada coalesce
select id, coalesce(FirstName, MiddleName, LastName) as Name --coalesce võtab väärtused järjest läbi, kui 1 on NULL siis võtab teise, kui see ka NULL, siis kolmas, kui kõik NULL siis annab väärtuse NULL
from Employees

create table IndianCustomers
(
ID int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
ID int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutate union all kahe tabeli andmete vaatamiseks, näitab mõlema tabeli read ühes tabelis
select * from IndianCustomers
Union all
select * from UKCustomers

--korduvate väärtuste eemaldamiseks kasutame union
select * from IndianCustomers
Union
select * from UKCustomers

--kuidas tulemust sorteerida nime järgi, kasutada union all-i
select * from IndianCustomers
Union all 
select * from UKCustomers
order by Name

--stored procedure ---------------- STORED PROCEDURE ------------------------------- TALLETATUD PROTSEDUUR
--salvestatud protseduurid on SQL'i koodid, mis on salvestatud andmebaasis ja mida saab
--käivitada, et teha mingi kindel töö ära
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--nüüd saame kasutada spGetEmployees'i
spGetEmployees
exec spGetEmployees
execute spGetEmployees -- kõik annavad sama tulemuse

---
create proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(10),
@DepartmentId int
as begin
	select FirstName, Gender, DepartmentID from Employees
	where Gender = @Gender and DepartmentId = @DepartmentId
end

--ilma @ parameetriteta annab errori
spGetEmployeesByGenderAndDepartment 'male', 1
--kuidas minna sp järjekorrast mööda --kirjuta välja parameetrid
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'male'

sp_helptext spGetEmployeesByGenderAndDepartment

--muudame sp'd ja võti peale, et keegi teine peale teie ei saaks seda muuta.
alter procedure spGetEmployeesByGenderAndDepartment
@Gender nvarchar(10),
@DepartmentId int
with encryption -- paneb võtme peale
as begin
	select FirstName, Gender, DepartmentID from Employees
	where Gender = @Gender and DepartmentId = @DepartmentId
end

--
create proc spGetEmployeeCountByGender
@Gender nvarchar(10),
--mis on output parameeter ja kuidas seda kasutada
--on parameeter, mis võimaldab meil salvestada protseduuri
--sees tehtud arvutuse tulemuse ja kasutada seda väljaspool protseduuri
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end

--annab tulemuse, kus loendab ära nõuetele vastavad read, prindib tulemuse, mis on parameetris @EmployeeCount
declare @TotalCount int
exec spGetEmployeeCountByGender 'male', @TotalCount output -- output sama mis out
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@TotalCount is not null'
print @TotalCount

--näitab ära mitu rida vastab nõuetele
declare @TotalCount int
--out on parameeter, mis võimaldab meil salvestada protseduuri
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--tabeli info
sp_help Employees
--kui soovid sp teksti näha
sp_helptext spGetEmployeeCountByGender

--vaatame, millest sõltub see sp
sp_depends spGetEmployeeCountByGender
--vaatame tabelit sp_depends'ga
sp_depends Employees

---
create proc spGetNameById
@Id int,
@Name nvarchar(25) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end

--tahame näha kogu tabelite ridade arvu, count kasutada
create proc spGetRowCount
@IdCount int output
as begin
	select @IdCount = COUNT(Id) from Employees
end

spGetRowCount

declare @TotalEmployees int
execute spGetRowCount @TotalEmployees out
select @TotalEmployees as Eployees

--mis id all on keegi nime järgi
create proc spGetNameByID1
@Id int,
@FirstName nvarchar(30) output
as begin
	select @FirstName = FirstName from Employees where @Id = Id
end

--annab tulemuse, kus id 1 real on keegi koos nimega
declare @FirstName nvarchar(30)
exec spGetNameByID1 1, @FirstName out
print 'Name of employee = ' + @Firstname

---
declare @FirstName nvarchar(30)
exec spGetNameById 3, @FirstName output
print 'Name of employee = ' + @FirstName
-- ei anna tulemust, sest sp's on loogika viga. sest @ Id on parameeter, mis on mõeldud selleks,
--et me saaksime sisestada id'd ja saada nime, aga sp's on loogika viga, sest see üritab määrata
--@Id väärtuseks Id veeru väärtust, mis on vale

--rida 718
--tund 5 -- 07.04.26
declare @FirstName nvarchar(30)
exec spGetNameById 1, @FirstName out
print 'Name of employee = ' + @FirstName

sp_help spGetNamebyId

create proc spGetNameById2
@Id int
as begin
	return (select FirstName from Employees where Id = @Id)
end

declare @EmployeeName nvarchar(30)
execute @EmployeeName = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName

alter proc spGetNameById2
@Id int
as begin
	select FirstName from Employees where Id = @Id
end
--return annab ainult int tüüpi väärtuset, seega ei saa kasutada returni, et tagastada nime, mis
--on nvarchar tüüpi

----sisseehitatud string funktsioonid
-- see konventeerib ASCII tähe väärtuse numbriks
select ascii('A')
-- kuvab A-tähr
select char(65)

--prindime kogu tähestiku välja A-st Z-ni
--kasutame while tsüklit
declare @x INT
set @x = 65
while @x <= ascii('Z')
begin
	print char(@x)
	set @x = @x + 1
end

-- eemaldame tühjad kohad sulgudes
select ltrim('                              Hello')

-- tühikute eemaldamine sõnas
select ltrim(FirstName) as FirstName, Middlename, Lastname
from Employees

--keerab kooloni sees olevad andmed vastupidiseks
--vastavalt upper ja lower'ga saan muuta märkide suurust
--reverse funktsioon keerab stringi tagurpidi
select reverse(upper(ltrim(FirstName))) as FirstName, MiddleName,
lower(Lastname), rtrim(ltrim(FirstName)) + ' ' + MiddleName + ' ' + 
LastName as FullName from Employees


--left, right, substring
--left / right võta stringi vasakult / paremalt poolt neli esimest tähte
select left('ABCDEF', 4)
select right('ABCDEF', 4)

--kuvab @tähemärgi asetust
select CHARINDEX('@', 'sara@aaa.com')

--alates viiendast tähemärgist võtab kaks tähte
select substring('leo@bbb.com', 5, 2)

--- @-märgist kuvab kolm tähemärki. Viimase nr saab määrata pikkust
select substring('leo@bbb.com', charindex('@', 'leo@bbb.com') + 1, 3)

---peale @-märki reguleerin tähemärkide pikkuse näitamist
select substring('leo@bbb.com', CHARINDEX('@', 'leo@bbb.com') + 2,
len('leo@bbb.com') - CHARINDEX('@', 'leo@bbb.com'))

--saame teada domeeninimed emalides, kasutame Person tabelit
--ja substringi, len ja charindex
select substring(Email, CHARINDEX('@', Email) + 1,
len(Email) - charindex('@', Email)) as Domainname
from Person


alter table Employees
add Email nvarchar(20)

update Employees
set Email = 'Tom@aaa.com' where Id = 1
update Employees
set Email = 'Pam@bbb.com' where Id = 2
update Employees
set Email = 'John@aaa.com' where Id = 3
update Employees
set Email = 'Sam@bbb.com' where Id = 4
update Employees
set Email = 'Todd@bbb.com' where Id = 5
update Employees
set Email = 'Ben@ccc.com' where Id = 6
update Employees
set Email = 'Sara@ccc.com' where Id = 7
update Employees
set Email = 'Valarie@aaa.com' where Id = 8
update Employees
set Email = 'James@bbb.com' where Id = 9
update Employees
set Email = 'Russel@bbb.com' where Id = 10

--lisame *-märgi alates teatud kohast
select FirstName, LastName,
	substring(Email, 1, 2) + replicate('*', 5) +
	--peale tesist tähemärki paneb viis tärni
	substring(Email, charindex('@', Email), len(Email)
	- len(charindex('@', Email) + 1)) as MaskedEmail
	--kuni@märgini paneb tärnid ja siis jätkab emaili näitamist on
	--dünaamiline, sest kui emaili pikkus on erinev, siis paneb
	--vastavalt tähed
from Employees

--kolm korda näitab stringis olevat väärtust
select replicate ('Hello', 3)

--kuidas sisestada tühikut kahe nime vahele, kasutada funktsiooni
select space(5)
--võtame tabeli Employees ja kuvame eesnimi ja perekonnanime vahele tühikut
select FirstName + space(1) + LastName as Fullname from Employees

--PATINDEX
--sama, mis charindex, aga patindex võimaldab kasutada wildcardi
--kasutame tabelit Employees ja leiame kõik read, kus emaili lõpus on aaa.com
select Email, patindex('%@aaa.com',Email) As Position from Employees
where patindex('%@aaa.com',Email) > 0
--leiame kõik read, kus emaili lõpus on aaa.com või bbb.com


--asendame emaili lõpus olevat domeeninimed, .com asemel .net'ga, kasutage replac'i
select replace(Email, '.com', '.net') from Employees

--soovin asendada peale esimest märki olevad tähed viie tärniga
select Firstname, lastname, Email,
stuff(Email, 2, 3, '*****') as StuffedEmail from Employees

---ajaga seotud andmetüübid
create table DateTest
(c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTest

--sinu masina kellaaeg
select getdate() as CurrentDateTime

insert into DateTest
values (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())

update DateTest set c_datetimeoffset = '2026-04-07 12:13:09.6066667 +02:00'
where c_datetimeoffset = '2026-04-07 17:13:09.6066667 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' --aja päring
select SYSDATETIME(), 'SYSDATETIME()' --veel täpsem aja päring
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET()' --täpne aja ja ajavööndi päring
select GETUTCDATE(), 'GETUTCDATE()' --UTC aja päring

select isdate('asdasd') --tagastab 0, sest see ei ole kehtiv kuupäev
select isdate(getdate()) --tagastab 1, sest on kuupäev
select isdate('2026-04-07 17:13:09.6066667 +00:00') --tagastab 0 kuna max kolm komakohta võib olla
select isdate('2026-04-07 17:13:09.606') --tagastab 1
select day(getdate()) --annab tänase päeva numbri
select day('03/29/2026') --annab stringis oleva kp ja järjestus peab olema õige
select month(getdate()) --kuu
select month('03/29/2026') --kuu
select year(getdate()) --aasta
select year('03/29/2026') --aasta

--rida 894
--tund 6 -- 14.04.26
select datename(day, '2026-04-07 17:13:09.606') --annab sõnes oleva päeva nime (kuupäev)
select datename(weekday, '2026-04-07 17:13:09.606') --annab sõnes oleva nädalapäeva nime
select datename(month, '2026-04-07 17:13:09.606') --annab sõnes oleva kuu nime
select datename(week, '2026-04-07 17:13:09.606') --annab sõnes oleva kuupäeva nädala numbri

create table EmployeesWithDates
(
	Id nvarchar(2),
	Name nvarchar(20),
	DateOfBirth datetime
)

insert into EmployeesWithDates (Id, Name, DateOfBirth)
values (1, 'Sam', '1980-12-30 00:00:00.000'),
(2, 'Pam', '1982-09-01 12:02:36.260'),
(3, 'John', '1985-08-22 12:03:30.370'),
(4, 'Sara', '1979-11-29 12:59:30.670')

--kuidas võtta ühest veerust andmeid ja selle abil luua uued veerud
select Name, DateOfBirth, datename(weekday, DateOfBirth) As [Day],
	month(DateOfBirth) as MonthNumber,
	datename(month, DateOfBirth) as [MonthName],
	year(DateOfBirth) as [Year] from EmployeesWithDates

select Datepart(weekday, '2026-04-07 17:13:09.606') -- annab sõnes oleva nädalapäeva numbri (USA süsteemis)
select Datepart(month, '2026-04-07 17:13:09.606') -- annab sõnes oleva kuu numbri
select dateadd(day, 20, '2026-04-07 17:13:09.606') --liidab sõnes olevale kp'le päevi
select dateadd(day, -20, '2026-04-07 17:13:09.606') --lahutab sõnes olevast kp'st päevi
select datediff(month, '04/30/2025', '01/31/2026') --annab kahe kp vahelist vahet kuudes
select datediff(year, '04/30/2025', '01/31/2026') --annab kahe kp vahelist vahet aastates
select datediff(day, '04/30/2025', '01/31/2026') --annab kahe kp vahelist vahet päevades


----------- FUNKTSIOONID FUNCTIONS --------------------

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int  -- @ märk tähistab muutujat
	select @tempdate = @DOB

	select @years = datediff(year, @tempdate, getdate()) - case when (month(@DOB) > month(getdate())) or (month(@DOB))
	= month(getdate()) and day(@DOB) > day(getdate()) then 1 else 0 end
	select @tempdate = dateadd(year, @years, @tempdate)

	select @months = datediff(month, @tempdate, getdate()) - case when day(@DOB) > day(getdate()) then 1 else 0 end
	select @tempdate = dateadd(month, @months, @tempdate)

	select @days = datediff(day, @tempdate, getdate())

	declare @Age nvarchar(50)
		set @Age = cast(@years as nvarchar(10)) + ' years, '
		+ cast(@months as nvarchar(10)) + ' months, '
		+ cast(@days as nvarchar(10)) + ' days old'
	return @Age
end

--saame vanuse välja arvutada, kui kasutame fnComupteAge funktsiooni
select Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age
from EmployeesWithDates

--kui kasutame seda funktsiooni, siis saame teada tänase päeva vahet stringis olevaga
select dbo.fnComputeAge('03/23/2008')

--nr peale DOB muutujat näitab, et missugusena järjestuses me tahame näidata veeru sisu
select Id, Name, DateOfBirth,
convert(nvarchar, DateOfBirth, 126) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-ID]
from EmployeesWithDates

select cast(getdate() as date) -- tänane kp
select convert(date, getdate()) --tänane kp

--matemaatilised funktsioonid
select abs(-101.5) --absoluutväärtus, tagastab 101.5
select ceiling(101.5) --ümardab üles, tagastab 102
select ceiling(-101.5) --ümardab üles positiivsema nr poole, tagastab -101
select floor(101.5) --ümardab alla, tagastab 101
select floor(-101.5) --ümardab alla negatiivsema poole, tagastab 102
select round(101.556, 1) --ümardab lähima numbrini, teine väärtus ütleb mitu komakohta tagastab 101.5
select power(2, 4) --tagastab 16, astendab 1. sisendit 2. sisendiga. 2 astmel 4 e 2*2*2*2
select square(5) --tagastab 25, võtab arvu ja korrutab iseendaga
select sqrt(25) -- tagastab 5, võtab arvu ja leiab selle ruutjuure

select rand() --tagastab juhusliku vahemiku 0 kuni 1
--oleks vaja, et iga kord annab rand meile ühe täisarva 1 kuni 100
select ceiling(rand() * 100)
select round((rand() * 99) + 1, 0)

--annab juhusliku numbri vahemikus 1 kuni 1000
--ja teeb seda 10 korda, et näha erinevaid numbreid
declare @x INT
set @x = 1
while @x <= 10
begin
	print round((rand() * 999) + 1, 0)
	set @x = @x + 1
end

select round(850.5546, 2, 1) --ümardab alla ja ära ümardatud numbrid annab 0'na, tagastab 850.5500
select round(850.556, 1, 1)
select round(850.556, -2) -- ümardab kuni lähima sajani, tagastab 900.00
select round(850.556, -1) -- ümardab kuni lähima kümnendini, tagastab 850.00

create function dbo.CalculateAge (@DOB date)
returns int
as begin
declare @Age int

set @Age = datediff(year, @DOB, getDate()) -
	case
		when (month(@DOB) > month(getdate())) or
			(month(@DOB) > month(getdate()) and day(@DOB) > day(getdate()))
		then 1
		else 0
		end
	return @Age
end
-----
execute CalculateAge '10/25/1980'

---arvutab välja, kui vana on isik ja võtab arvesse, kas isiku sünnipäev on juba
---sel aastal olnud või mitte. Antud juhul näitab, kes on üle 40 aasta vanad.
select Id, dbo.CalculateAge(DateOfBirth) as Age
from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 40

---inline table valued function
--teha EmployeesWithDates tabelisse
--uus veerg nimega DepartmentID int,
--ja teine veerg on Gender nvarchat(10)

alter table EmployeesWithDates
add DepartmentID int,
Gender nvarchar(10)

insert into EmployeesWithDates
values (5, 'Todd', '1978-11-29 12:59:30.670', 1, 'Male')
update EmployeesWithDates set Gender = 'Male', departmentId = 1
where Id = 1
update EmployeesWithDates set Gender = 'Female', departmentId = 2
where Id = 2
update EmployeesWithDates set Gender = 'Male', departmentId = 1
where Id = 3
update EmployeesWithDates set Gender = 'Female', departmentId = 3
where Id = 4

--scalar function e skaleeritav funktsioon annab mingis vahemikus olevaid
--väärtusi, aga inline table valued function tagastab tabeli
--ja seal ei kasutata begin ja endi vahele kirjutamist,
--vaid lihtsalt kirjutad selecti.
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeesWithDates
		where Gender = @Gender)

--soovime vaadata kõiki naisi EmployeesWithDates tabelist
select * from fn_EmployeesByGender('Female')

--soovin ainult näha Pam ja kasutan funktsiooni fn_EmployeesByGender
select * from fn_EmployeesByGender('Female') where Name = 'Pam'

--kahest erinevast tabelist andmete võtmine ja koos kuvamine
--esimene on funktsioon ja teine on Department tabel
select Name, Gender, DepartmentName from fn_EmployeesByGender('Male') E
join Department D on D.Id = E.DepartmentId

--inline funktsioon
create function fn_GetEmployees()
returns table as
return (select Id, Name, cast(DateOfBirth as date)
	as DOB
	from EmployeesWithDates)

select * from fn_GetEmployees()

--multi statement table valued function
create function fn_MS_GetEmployees()
returns @Table Table (Id int, Name nvarchar(20), DOB date)
as begin
	insert into @Table
	select Id, Name, cast(DateOfBirth as date) from EmployeesWithDates

	return
end

select * from fn_MS_GetEmployees()

--inline tabeli funktsioonid on paremini töötamas kuna käisitletakse vaatena
--Multi statement tabeli valued funktsioonid on nagu tavalised funktsioonid,
--pm on tegemist stored procedurega ja see võib olla aeglasem
--sest see ei saa kasutada vaate optimeerimist e kulutab rohkem ressurssi
select * from EmployeesWithDates
update fn_GetEmployees() set Name = 'Sara' where Id = 4 --saab muuta andmeid
select * from EmployeesWithDates

update fn_MS_GetEmployees set Name = 'Sara' where Id = 4 --multi state puhul ei saa andmed muuta valued funktsioonis,
--sest see on nagu stored procedure

--rida 1096
--tund 7 --21.04.26

--determnistic vs nondeterministic functions. Ettemääratud ja mitte ettemääratud
select count(*) from EmployeesWithDates
-- kõik märgid on deterministic, sest nad annavad alati sama tulemuse,
-- kui sisend on sama. Selle alla kuuluvad veel sum, avg, min, max, count
select square(3)

---nondeterministic. Võivad anda erinevaid tulemusi
select getdate() -- kuna see annab alati jooksva aja, siis on nondeterministic
select CURRENT_TIMESTAMP
select rand()

--loome funktsiooni
create function fn_GetNameById(@id int)
returns nvarchar(20)
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end

--kuidas saab kasutada fn_GetNameById funktsiooni
select dbo.fn_GetNameById(3)
--sellega saab näha funktsiooni sisu
sp_helptext fn_GetNameById

--muuta funktsiooni fn_GetNameById ja krüpteerida see ära, et keegi teine peale sinu ei saaks seda muuta
alter function fn_GetNameById(@id int)
returns nvarchar(20)
with encryption -- paneb võtme peale
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end
--nüüd kui tahame sisu näha fn_ siis ei saa
sp_helptext fn_GetNameById

create function fn_GetEmployeeNameById(@id int)
returns nvarchar(20)
with schemabinding
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end
--tuleb vea teade: Cannot schema bind function 'fn_GetEmployeeNameById' because
--name 'EmployeesWithDates' is invalid for schema binding. Names must be in
---two-part format and an object cannot reference itself.

--nüüd on korras
create function dbo.fn_GetEmployeeNameById(@id int)
returns nvarchar(20)
with schemabinding
as begin
	return (select Name from dbo.EmployeesWithDates where Id = @id)
end
--Schemabinding seob päringus oleva tabeli ära ja ei luba seda muuta
-- See annab meile jõudluse eelise, sest SQL Server teab, et see tabel ei muutu
--veergude osas (tabeli struktuur on lukus, andmeid saab sisestada)

-- ei saa tabelit kustutada, kui sellel on schemabindinguga funktsioon
drop table EmployeesWithDates

create function dbo.fn_GetEmployeeNameById(@id int)
returns nvarchar(20)
with encryption, schemabinding
as begin
	return (select Name from dbo.EmployeesWithDates where Id = @id)
end

--temporary tables ------- TEMP TABLE, AJUTISED TABELID --------- AJUTINE TABEL ------
--need on tabelid, mis on loodud ajutiselt ja kustutatakse automaatselt
--neid on kahte tüüpi: local temporary tables ja global temporary tables
--#'ga algavad local ja ##'ga global temporary tables

create table #PersonDetails(Id int, Name nvarchar(20))
insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'Max')
insert into #PersonDetails values(3, 'Uhura')
go --tee ülemine ja tee siis järgnev
select * from #PersonDetails

--saame otsida seda objekti
select * from sysobjects
where name like '#PersonDetails%'

--kustutame tabeli ära
drop table #PersonDetails

--teeme stored procedure, mis loob local temp tabeli ja täidab selel andmetega
create proc spCreateLocalTempTable
as begin
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'Max')
insert into #PersonDetails values(3, 'Uhura')

select * from #PersonDetails
end

exec spCreateLocalTempTable

select * from sysobjects
where name like '[dbo].[#A989D1BE]%'

--globaalse tabeli loomine
create table ##GlobalPersonDetails(Id int, Name nvarchar(20))
--mis on globaalse ja lokaalse tabeli erinevus
--local on nähtav ainult sessioonis mis selle tegi ja suletakse kui ühendus suletakse
--global on nähtav kõigile sessioonidele, kustutatakse kui viimane viitav sessioon suletakse.

--index ------------------- INDEX INDEKS -----------------
create table EmployeesWithSalary
(
Id int primary key,
Name nvarchar(25),
Salary int,
Gender nvarchar(10)
)

insert into EmployeesWithSalary
values (1, 'Sam', 2500, 'Male'),
(2, 'Pam', 6500, 'Female'),
(3, 'John', 4500, 'Male'),
(4, 'Sara', 5500, 'Female'),
(5, 'Todd', 3100, 'Male')

select * from EmployeesWithSalary
where Salary > 5000 and Salary < 7000

--loome indeksi, mis asetab palga kahanevasse järjestusse
create index IX_Employee_Salary
on EmployeesWithSalary(Salary desc)

--proovige pärida tabelit EmployeeWithSalary ja kasutada index'it IX_Employee_Salary
select * from EmployeesWithSalary with (index (IX_Employee_Salary))

--indeksi kustutamine
drop index IX_Employee_Salary on EmployeeWithSalary
drop index EmployeeWithSalary.IX_Employee_Salary

--- indeksi tüübid:
--1. Klasterites olevad
--2. Mitte-klasteris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Täistekst
--7. Ruumiline
--8. Veerusäilitav
--9. Veergude indeksid
--10. Välja arvatud veergudega indeksid

--Klastris olev indeks määrab ära tabelis oleva füüsilise järjestuse ja  selle tulemusel saab tabelis olla ainult üks klastris olev indeks kui
--lisad primaarvõtme, siis luuakse automaatselt klastris olev indeks

create table EmployeeCity
(
Id int primary key,
Name nvarchar(25),
Salary int,
Gender nvarchar(10),
City nvarchar(20)
)

--andmete õige järjestuse loovad klastris olevad indeksid ja kasutab selleks
--Id nr't. Põhjus, miks antud juhul kasutab Id'd tuleneb primaarvõtmest

insert into EmployeeCity
values (3, 'John', 4500, 'Male', 'New Yourk'),
(1, 'Sam', 2500, 'Male', 'London'),
(4, 'Sara', 5500, 'Female', 'Tokyo'),
(5, 'Todd', 3100, 'Male', 'Toronto'),
(2, 'Pam', 6500, 'Female', 'Sydney')

select * from EmployeeCity

--klastris olevad indeksid dikteerivad säilitatud andmete järjestuse tabelis ja seda saab klastrite puhul olla ainult üks
create clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)
--annab veateate, et tabelis saab olla ainult üks klastris olev indeks, kui soovid
--uut indeksit luua, siis kustuta olemasolev

--saame luua ainult ühe klasteris oleva indeksi tabeli peale. Klastris olev indeks
--on analoogne telefoni numbrile
--enne seda päringut kustutasime primaarvõtme indeksi ära
select * from EmployeeCity

--mitte klastris olev indeks
create nonclustered index IX_EmployeeCity_Name123
on EmployeeCity(name)

exec sp_helpindex EmployeeCity

Select * from EmployeeCity

--Erinevused kahe indeksi vahel
--1. ainult üks klastris olev indeks saab olla tabeli peale, mitte-klastris olevaid indekseid saab olla mittu
--2. klastris olevad indeksid on kiiremad kuna indeks peab tagasi viitama tabelile. Juhul, kui selekteeritud veerg ei ole olemas indeksis
--3. klastris olev indeks määratleb ära tabeli ridade salvestusjärjestuse ja ei nõua kettal lisa ruumi- Samas mitte klastris olevad indeksid on
--salvestatud tabelist eraldi ja nõuab lisa ruumi.

create table EmployeeFirstName
(
	Id int primary key,
	FirstName nvarchar(25),
	LastName nvarchar(25),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(20)
)

exec sp_helpindex EmployeeFirstName

--Neid andmeid ei saa sisestada (id sama)
insert into EmployeeFirstName
values
(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York'),
(1, 'John', 'Menco', 2500, 'Male', 'London')

--kustutame indeksi ära
drop index EmployeeFirstName.PK__Employee__3214EC078E31DDF5
--kui käivitad ülevalpool koodi, siis tuleb veateade, et sQL server kasutab
--unikaalset ineksit jõustamaks väärtuste unikaalsust ja koodiga Unikaalseid
--indekseid ei saa kustutada, aga käsitsi saab
------------- Üleval insert kood uuesti ------------

create unique nonclustered index IX_Employee_FirstName_FirstName
on EmployeeFirstName(FirstName, LastName)

insert into EmployeeFirstName
values
(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York'),
(2, 'John', 'Menco', 2500, 'Male', 'London')
--alguses annab veateate, et Mike on kaks korda
--Tabel kustutatud ning tehtud uuesti siis töötab

---create table EmployeeFirstName -- uuesti ---

--lisame uue unikaalse piirangu
alter table EmployeeFirstName
add constraint UQ_Employee_FirstName_City
unique nonclustered(City)

insert into EmployeeFirstName
values
(3, 'John', 'Menco', 4500, 'Male', 'London')

--rida 1347
--tund 8 28.04.26

---
-- 1. Vaikimisi primaarvõti loob unikaalse klastris oleva indeksi, samas unikaalne piirang
-- loob unikaalse mitte-klasteris oleva indeksi
-- 2. Unkikaalset indeksit või piirangut ei saa luua olemasolevasse tabelisse, kui tabel juba
-- väärtusi võtmeveerus
-- 3. Vaikimisi korduvaid väärtusi ei ole veerus lubatud, kui peaks olema unikaalne indeks või piirang.
-- Nt, kui tahad sisestada 10 rida andmeid, millest 5 sisaldavad korduvaid andmeid, siis kõik 10
--lükatakse tagasi. Kui soovin ainult 5 rea tagasi lükkamist ja ülejäänud 5 rea sisestamist, siis selleks
-- kasutatakse IGNORE_DUP_KEY

--koodinäide
create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key

select * from EmployeeFirstName

insert into EmployeeFirstName
values
(3, 'John', 'Menco', 2345, 'Male', 'London'),
(4, 'John', 'Menco', 1234, 'Male', 'London1'),
(4, 'John', 'Menco', 3456, 'Male', 'London1')
-- enne ignore käsku oleks kõik kolm rida tagasi lükatud, aga nüüd läks keskmine rida läbi kuna linna nimi on unikaalne

--view -------------VIEW , VAADE ---------------------
--view on salvestatud SQL'i päring. Saab käsitleda ka virtuaalse tabelina

select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

---loome view
create view vEmployeesByDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--view päringu esile kutsumine
select * from vEmployeesByDepartment

-- view ei salvesta andmeid vaikimisi seda tasub võtta kui salvestatud virtuaalse tabelina

-- milleks vaja:
-- saab kasutada andmebaasi skeemi keerukuse lihtsustamiseks, mitte IT-inimesele
-- piiratud ligipääs andmetele, ei näe kõiki veerge


--teeme view, kus näeb ainult IT-tootajaid, view nimi on vITEmployeesInDepartment
create view vITEmployeesInDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id
where DepartmentName = 'IT'

select * from vITEmployeesInDepartment

--veeru taseme turvalisus peale selecti määratled veergude näitamise ära
create view vEmployeeInDepartmentSalaryNoShow
as
select FirstName, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeeInDepartmentSalaryNoShow

--saab kasutada esitlemaks koondandmeid ja üksikasjalike andmeid view, mis tagastab sumeeritud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentName, count(FirstName) as Total
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName


select * from vEmployeesCountByDepartment
--kui soovid vaadata view sisu
sp_helptext vEmployeesCountByDepartment
--muutmiseks kasutame sõna alter
alter view vEmployeesCountByDepartment
--kustutamine
drop view vEmployeesCountByDepartment

--kasutame view'd andmete uuendamiseks
create view vEmployeesDataExpectSalary
as
select Id, FirstName, Gender, DepartmentId
from Employees

select * from vEmployeesDataExpectSalary

-- muutke Id 2 olev rida ja uus eesnimi on Tom
update vEmployeesDataExpectSalary
set FirstName = 'Tom'
where id = 2

--kustutame ja sisestame andmeid
delete from vEmployeesDataExpectSalary where Id = 2
insert into vEmployeesDataExpectSalary (id, Gender, DepartmentId, FirstName)
values (2, 'Female', 2, 'Pam')

---indekseeritud view
--MS sql-s on indekseeritud view nime all ja Oracle's materjaliseeritud view

create table Product
(Id int primary key,
Name nvarchar(20),
UnitPrice int
)

Insert into Product values
(1, 'Book', 20),
(2, 'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10)

create table ProductSales
(
Id int,
QuantitySold int
)

insert into ProductSales values
(1, 10),
(3, 23),
(4, 21),
(2, 12),
(1, 13),
(3, 12),
(4, 13),
(1, 11),
(2, 12),
(1, 14)

--loome view, mis annab meile veerud TotalSales ja TotalTransaction
create view vTotalSalesByProduct
with schemabinding
as
select Name,
sum(isnull((QuantitySold * UnitPrice), 0 )) as TotalSales,
COUNT_BIG(*) as TotalTransactuions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by Name

Select * from vTotalSalesByProduct

--- kui soovid luua indeksi view sisse, siis peab järgima teatud reegleid
-- 1. view tuleb luua koos schemabinding'ga
-- 2. kui lisafunktsioon select list viitab väljendile ja selle tulemuseks võib olla NULL,
-- siis asendusväärtus peaks olema täpsustatud. Antud juhul kasutasime ISNULL funktsiooni
--asendamaks NULL väärtust.
-- 3. Kui Groupby on täpsustatud, siis view select list peab sisaldama COUNT_BIG(*) väljendit
-- 4. Baastabaleis peaksid view'd olema viidatud kaheosalise nimega e antud juhul dbo.Produvt ja
-- dbo.ProductSales.
-- COUNT_BIG vs COUNT?
-- COUNT_BIG tagastab bigint väärtuse, mis on suurem

create unique clustered index UIX_vTotalSalesByProduct_Name
on vTotalSalesByProduct(Name)
--paneb selle view tähestikulisse järjestusse

select * from vTotalSalesByProduct


--view piirangud
create view vEmployeeDetails
@Gender nvarchar(20)
as
select Id, FirstName, Gender, DepartmentId
From Employees
where Gender = @Gender

--vaatesse ei saa panna parameetreid e antud juhul Gender

create function fnEmployeeDetails(@Gender nvarchar(20))
returns table
as return
(select id, FirstName, Gender, DepartmentId
from Employees where Gender = @Gender)

select * from fnEmployeeDetails('male')

-- order by kasutamine
create view vEmployeeDetailsSorted
as
select Id, FirstName, Gender, Department
from Employees
order by Id
--order by'd ei saa kasutada view sees

--temp table kasutamine
create table ##TestTempTable(Id int, FirstName nvarchar(20), Gender nvarchar(10))

insert into ##TestTempTable values
(101, 'Martin', 'Male'),
(102, 'Joe', 'Male'),
(103, 'Pam', 'Female'),
(104, 'james', 'Male')

--tehke view, mis kasutab ##TestTempTable
--view nimi on vOnTempTable
create view vOnTempTable
as
select Id, FirstName, Gender
from ##TestTempTable
-- temp tabel's eo saa kasutada view'd

--triggerid
-- DML triggerid
-- kokku on kolme tüüpi: DML, DDl ja LOGON

--trigger on stored procedure eriliik, mis automaatselt käivitub,
-- kui mingi tegevus peaks andmebaasis aset leidma

--DML - data manipulation language
-- DML'i põhilised käsklused: insert, update ja delete

--DML triggerid saab klassifitseerida kahte tüüpi:
-- 1. After trigger (kutsutakse ka FOR triggeriks)
-- 2. Instead of trigger (selmet trigger e selle asemel trigger)

-- after trigger käivitub peale sündmust, kui kuskilon tehtyd insert, update ja delete

create table EmployeeAudit
(
Id int identity(1,1) primary key,
AuditData nvarchar(1000)
)

--peale iga töötaja sisestamist tahame teada saada töötaja Id-d päeva ning aega(millal sisestati)
-- kõik andmed tulevad EmployeeAudit tabelisse

create trigger trEmployeeForInsert
on Employees
for insert
as begin
declare @Id int
select @Id = Id from inserted
insert into EmployeeAudit
values ('New employee with Id = ' + cast(@Id as nvarchar(5)) + ' is added at ' +
cast(getdate() as nvarchar(20)))
end

select * from Employees
insert into Employees values
(11, 'Bob', 'Blob', 'Bomb', 'Male', 3000, 1, 3, 'bob@bob.com')

select * from EmployeeAudit

create trigger trEmployeeForDelete
on Employees
for delete
as begin
	declare @Id int
	select @Id = Id from deleted
	
	insert into EmployeeAudit
	values('An existing employee with Id = ' + cast(@Id as nvarchar(5)) +
	' is deleted at ' + cast(getdate() as nvarchar(20)))
end

delete from Employees where Id = 11

select * from EmployeeAudit

--- update trigger

create trigger trEmployeeForUpdate
on Employees
for update
as begin
	--muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId int
	declare @OldManagerId int, @NewManagerId int
	declare @OldFirstName nvarchar(20), @NewFirstName nvarchar(20)
	declare @OldMiddleName nvarchar(20), @NewMiddleName nvarchar(20)
	declare @OldLastName nvarchar(20), @NewLastName nvarchar(20)
	declare @OldEmail nvarchar(50), @NewEmail nvarchar(50)

	--muutuja, kuhu läheb lõpptekst
	declare @AuditString nvarchar(1000)

	--laeb kõik uuendatud andmed temp tabeli alla
	select * into #TempTable
	from inserted

	--käib läbi kõik andmed temp tabel-s
	while(exists(select Id from #TempTable))
	begin
		set @AuditString = ''
	--selekteerib esimese rea andmed  temp tabel-st
	select top 1 @Id = Id, @NewGender = Gender,
	@NewSalary = Salary, @NewDepartmentId = DepartmentId,
	@NewManagerId = ManagerId, @NewFirstName = FirstName,
	@NewMiddleName = MiddleName, @NewLastName = LastName,
	@NewEmail = Email
	from #TempTable
	--võtab vanad andmed kustutatud tabelist
	select @OldGender = Gender,
	@OldSalary = Salary, @OldDepartmentId = DepartmentId,
	@OldManagerId = ManagerId, @OldFirstName = FirstName,
	@OldMiddleName = MiddleName, @OldLastName = LastName,
	@OldEmail = Email
	from deleted where Id = @Id

	--toimub v]rdlus veergude osas, et kas toimus andmete muutmine
	set @AuditString = 'Employee with Id = ' + cast(@Id as nvarchar(4)) + ' changed '
	if(@OldGender <> @NewGender)
		set @AuditString = @AuditString + ' Gender from ' + @OldGender + ' to ' +
		@NewGender

	if(@OldSalary <> @NewSalary)
		set @AuditString = @AuditString + ' Salary from ' + cast(@OldSalary as nvarchar(20))
		+ ' to ' + cast(@NewSalary as nvarchar(10))

--rida 1676
--tund 9 --05.05.26
	if(@OldDepartmentId <> @NewDepartmentId)
		set @AuditString = @AuditString + ' DepartmentId from ' + cast(@OldDepartmentId as nvarchar(20))
		+ ' to ' + cast(@NewDepartmentId as nvarchar(10))

	if(@OldManagerId <> @NewManagerId)
		set @AuditString = @AuditString + ' ManagerId from ' + cast(@OldManagerId as nvarchar(20))
		+ ' to ' + cast(@NewManagerId as nvarchar(10))

	if(@OldFirstName <> @NewFirstName)
		set @AuditString = @AuditString + ' FirstName from ' + @OldFirstName + ' to ' +
		@NewFirstName

	if(@OldMiddleName <> @NewMiddleName)
		set @AuditString = @AuditString + ' MiddleName from ' + @OldMiddleName + ' to ' +
		@NewMiddleName

	if(@OldLastName <> @NewLastName)
		set @AuditString = @AuditString + ' LastName from ' + @OldLastName + ' to ' +
		@NewLastName

	if(@OldEmail <> @NewEmail)
		set @AuditString = @AuditString + ' Email from ' + @OldEmail + ' to ' +
		@NewEmail

	insert into dbo.EmployeeAudit values (@AuditString)
	-- kustutab temp tabelist rea, et saaksime liikuda uue rea juurde
	delete from #TempTable where Id = @Id
	end
end
----------

update Employees set FirstName = 'test12356', Salary = 3945, MiddleName = 'test987'
where Id = 10

select * from Employees
select * from EmployeeAudit

create table Employee
(Id int primary key,
Name nvarchar(30),
Gender nvarchar(10),
DepartmentId int
)

select * from Employee

insert into Employee values
(1, 'John', 'Male', 3),
(2, 'Mike', 'Male', 2),
(3, 'Pam', 'Female', 1),
(4, 'Todd', 'Male', 4),
(5, 'Sara', 'Female', 1),
(6, 'Ben', 'Male', 3)

--instead oftriggeri eripära seisneb selles, et kasutab view'd
create view vEmployeeDetails
as
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Employee.DepartmentId = Department.Id

select * from vEmployeeDetails

insert into vEmployeeDetails values(7,'Valarie', 'Female', 'IT')
--Tuleb veateade
--nüüd vaatame, et kuidas saab instead of triggeriga seda probleemi lahendada

create trigger tr_vEmployeeDetails_InsteadOfInsert
on vEmployeeDetails
instead of insert
as begin
	declare @DeptId int

	select @DeptId = dbo.Department.Id
	from Department
	join inserted
	on inserted.DepartmentName = Department.DepartmentName

	if(@DeptId is null)
		begin
			raiserror('Invalid department name. Statement terminated', 16, 1)
			return
		end

		insert into dbo.Employee(Id, Name, Gender, DepartmentId)
		select Id, Name, Gender, @DeptId
		from inserted
end

--- raiserror funktsioon
-- selle eesmärk on tuua välja veateade, kui DepartmentName veerus ei ole väärtust
-- ja ei klapi uue sisestatud väärtusega.
-- Esimene on parameeter ja veateate sisu, teine on veataseme nr (nr 16 tähendab üldiseid
-- kolmas on olek

delete from Employee where Id = 7

--kasutada update juures view'd nimega vEmployeeDetails
--nimi on tal Johny ja osakonnanimi IT, ID on 1

update vEmployeeDetails set Name = 'Johny' where Id = 1
update vEmployeeDetails set DepartmentName = 'IT' where Id = 1
--ei saa uundada mitut kui mitu tabelit on sellest mõjutatud, eraldi ükshaaval saab

select * from vEmployeeDetails

--nüüd kasutame view'd triggeri sees
create trigger tr_vEmployeeDetails_InsteadOfUpdate
on vEmployeeDetails
instead of update
as begin
	
	if(Update(Id))
	begin
		raiserror('Id cannot be changed', 16, 1)
		return
	end

	if(update(departmentName))
	begin
		declare @DeptId int
		select @DeptId = Department.Id
		from Department
		join inserted
		on inserted.Departmentname = Department.DepartmentName

		if(@DeptId is Null)
		begin
			raiserror('Invalid Department Name', 16, 1)
			return
		end

		update Employee set DepartmentId = @DeptId
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end

	if(update(Gender))
	begin
		update Employee set Gender = inserted.Gender
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end

	if(update(Name))
	begin
		update Employee set name = inserted.Name
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end
end

--tehke tavaline update kus on Id 1, nimeks John123, Gender male ja deptId 3.

update Employee set Name = 'John123', Gender = 'Male', DepartmentId = 3 where Id = 1

-- teha view, mis kasutab join ja tabelid on Employee ja department
-- selectis kasutame veerge DeptId, DeptName ja siis loendab ridade arvu tabelis
--lõpus grupitab ära DeptName ja DeptId järgi
create view vEmployeeCount
as
select DepartmentId, DepartmentName, count(*) as Total
From Employee E
join Department D
on E.DepartmentId = D.Id
group by DepartmentName, DepartmentID

select * from vEmployeeCount

--näitab ära osakonnad, kus on töötajaid rohkem või võrdne kui 2

select DepartmentName, Total from vEmployeeCount where Total >= 2

select DepartmentName, DepartmentId, count(*) as TotalEmployees
into #TempEmployeeCount
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select * from #TempEmployeeCount

--proovime info saada temp tabelist ja kus >= 2 töötajaga osakond
select DepartmentName, TotalEmployees from #TempEmployeeCount 
where TotalEmployees >= 2

--- kui kustutada InsteadOfDlete triggeri vEmployeeDetailsi alt, siis saab veateate läbi view kustutamisega.

create trigger tr_vEmployeeDetails_InsteadOfDelete
on vEmployeeDetails
instead of delete
as begin
	delete Employee
	from Employee
	join deleted
	on Employee.Id = deleted.id
end

delete from vEmployeeDetails where Id = 3

--CTE e Common Table Expression

insert into Employee values(2, 'Mike', 'Male', 2)

with EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)
as
(
select DepartmentName, DepartmentId, count(*) as TotalEmployees
---peate tegema join päringu
	from Employee E
	join Department D
	on E.DepartmentId = D.Id
	group by DepartmentName, E.DepartmentId
)
--- näitab ära töötajad, kus >= 2
select DepartmentName, TotalEmployees from EmployeeCount
where TotalEmployees >= 2

--CTE'd võivad sarnaneda temp tabeliga, sarnane päritud tabelile ja ei ole salvestatud objektina
--ning kestab päringu ulatuses

--päritud tabel
select DepartmentName, TotalEmployees
from
(
	select DepartmentName, DepartmentId, count(*) as TotalEmployees
		from Employee E
		join Department D
		on E.DepartmentId = D.Id
		group by DepartmentName, E.DepartmentId
)
as EmployeeCount
where TotalEmployees >= 2

-- mitu CTE'd järjest
with EmployeeCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
(
	select DepartmentName, count(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	where DepartmentName in('Payroll', 'IT')
	group by DepartmentName
),
-- peale koma panemist saad uue CTE juurde kirjutada.
EmployeeCountBy_Payroll_HR_Dept(DepartmentName, Total)
as
(
	select DepartmentName, count(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName
)
-- kui on kaks CTE'd, siis unioni abil ühendab päringud
select * from EmployeeCountBy_Payroll_IT_Dept
union
select * from EmployeeCountBy_Payroll_HR_Dept

--- Miks CTE?: Parem loetavus: CTE'd jagavad keerulised päringud väiksemateks loogilisteks osadeks.
---Selle asemel, et kasutada sügavalt pesastatud alampäringuid, defineerid sa sammud WITH-klausli
--- abil päringu alguses.

--- Koodi taaskasutatavus: Saad defineerida CTE üks kord ja viidata sellele sama päringu piires
--- korduvalt. See hoiab koodi puhtana.

--- Rekursiivsus: See on VTE'de eriline omadus. Rekursiivne CTE saab viidata iseendale, mis on hädavajalik
--- hierarhiliste andmete (nt organisatsiooni struktuuri või puukujuliste menüüd) töötlemiseks.

--- Lihtsam testimine: Kuna iga osa on eraldi nimega plokk, on konkreetseid loogika osi lihtsam
--- kontrollida ja veatuvastust teha.

--- korduv CTE
--- CTE, mis iseendale viitab, kutsutakse korduvaks CTE-ks kui tahad andmeid nädata hierarhiliselt


--Tund 10 -- 12.05.2026
--rida 1960
drop table Employee

create table Employee
(
	EmployeeID int primary key,
	Name nvarchar (30),
	ManagerId int
)

insert into Employee
values
(1, 'Tom', 2),
(2, 'Josh', Null),
(3, 'Mike', 2),
(4, 'John', 3),
(5, 'Pam', 1),
(6, 'Mary', 3),
(7, 'James', 1),
(8, 'Sam', 5),
(9, 'Simon', 1)

select * from Employee

-- üks võimalus on teha seda self joiniga, kuvada NULL veeru asemel Super Boss
select Emp.Name as [Employee Name],
isnull(Manager.Name, 'Super Boss') as [Manager Name]
from dbo.Employee Emp
left join Employee Manager
on Emp.ManagerId = Manager.EmployeeId

--kasutame CTE
with EmployeesCTE(EmployeeId, Name, ManagerId, [Level])
as
(
	select EmployeeId, Name, ManagerId, 1
	from Employee
	where ManagerId is null

	union all

	select Employee.EmployeeId, Employee.Name,
	Employee.ManagerId, EmployeesCTE.[Level] + 1
	from Employee
	join EmployeesCTE
	on Employee.ManagerId = EmployeesCTE.EmployeeId
)

select EmpCTE.Name as Employee,
isnull(MgrCTE.Name, 'Super Boss') as [Manager Name],
EmpCTE.[Level]
from EmployeesCTE EmpCTE
left join EmployeesCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.EmployeeId

-- PIVOT
create table ProductSales
(
	SalesAgent nvarchar(20),
	SalesCountry nvarchar(20),
	SalesAmount int
)

insert into ProductSales
values
('Tom', 'UK', 200),
('John', 'US', 180),
('John', 'UK', 260),
('David', 'India', 450),
('Tom', 'India', 350),
('David', 'US', 200),
('Tom', 'US', 130),
('John', 'India', 540),
('John', 'UK', 120),
('David', 'UK', 220),
('John', 'UK', 420),
('David', 'US', 320),
('Tom', 'US', 340),
('Tom', 'UK', 660),
('John', 'India', 430),
('David', 'India', 230),
('David', 'India', 280),
('Tom', 'UK', 480),
('John', 'UK', 360),
('David', 'UK', 140)


select * from ProductSales

select SalesCountry, SalesAgent, sum(SalesAmount) as Total
from ProductSales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent

-- nüüd päring pivot
select SalesAgent, India, US, UK
from ProductSales
pivot (
	sum(SalesAmount)
	for SalesCountry in (India, US, UK)
) As PivotTable

--- pivot võimaldab meil muuta ridu veergudeks ja teha andmete koondamist

-- lisada veerg nimega Id int primary key
alter table ProductSales
add Id int identity(1, 1) primary key

--- nüüd on veerg Id olmas aga see ei mõjuta pivotit, kuna me ei k..
-- võrreldes eelmise päringuga, tulemus teistsugune
select SalesAgent, India, US, UK
from (select SalesAgent, SalesCountry, SalesAmount
	from ProductSales) as SourceTable
pivot (
	sum(SalesAmount) for SalesCountry in (India, US, UK)
) as PivotTable

-- Transactions

-- transaction on SQL'i käskluste kogum, mis täidetakse ühtse tööüksusena.
-- kontrollib vigu. Kui on viga, siis taastab algse oleku

create table MailingAddress
(
	Id int not null primary key,
	EmployeeNumber int,
	HouseNumber nvarchar(50),
	StreetNumber nvarchar(50),
	City nvarchar(20),
	PostalCode nvarchar(20)
)

insert into MailingAddress
values (1, 101, '#10', 'King Street', 'London', 'CR25DW')

create table PhysicalAadress
(
	Id int not null primary key,
	EmployeeNumber int,
	HouseNumber nvarchar(50),
	StreetNumber nvarchar(50),
	City nvarchar(20),
	PostalCode nvarchar(20)
)

insert into PhysicalAadress
values (1, 101, '#10', 'King Street', 'Londoon', 'CR25DW')

create proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update MailingAddress set City = 'LONDON'
			where MailingAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end
---
spUpdateAddress

select * from MailingAddress
select * from PhysicalAddress


--kasutame sama sp'd aga muudame sisu
Alter proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON 12'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end


-- juhul kui teine uuendus ei lähe läbi, siis esimene uuendus ei lähe läbi,
-- kuna meil on transaction sees

--- transaction ACID test

-- edukas transaction peab läbima ACID testi:
-- A - atomic e aatomlikus
-- C - consistent e järjepidevus
-- I - isolated e isoleeritus
-- D - durable e vastupidav

--- Atomic - kõik tehingud transactionis on kas edukalt täidetud või need 
-- lükatakse tagasi. Nt, mõlemad käsud peaksid alati õnnesutma. Andmebaas 
-- teeb sellisel juhul: võtab esimese update tagasi ja veeretab selle algasendisse
-- e taastab algsed andmed

--- Consistent - kõik transactioni puudutavad andmed jäetakse loogiliselt 
-- järjepidevasse olekusse. Nt, kui laos saadaval olevaid esemete hulka 
-- vähendatakse, siis tabelis peab olema vastav kanne. Inventuur ei saa
-- lihtsalt kaduda

--- Isolated - transaction peab andmeid mõjutama, sekkumata teistesse
-- samaaegsetesse transactionitesse. See takistab andmete muutmist, mis 
-- põhinevad sidumata tabelitel. Nt, muudatused kirjas, mis hiljem tagasi 
-- muudetakse. Enamik DB-d kasutab tehingute isoleerimise säilitamiseks 
-- lukustamist

--- Durable - kui muudatus on tehtud, siis see on püsiv. Kui süsteemiviga või
-- voolukatkestus ilmneb enne käskude komplekti valmimist, siis tühistatkse need 
-- käsud ja andmed taastakse algsesse olekusse. Taastamine toimub peale 
-- süsteemi taaskäivitamist.


--- subqueries
--tabel tühjaks
truncate table Product
truncate table ProducSales

create table ProductSales
(
	Id int primary key identity,
	ProductId int foreign key references Product(Id),
	UnitPrice int,
	QuantitySold int
)

create table Product
(
	Id int identity primary key,
	name nvarchar(50),
	Description nvarchar(250)
)

insert into Product values
('TV', '52 inch black color TV'),
('Laptop', 'Very thin silver color laptop'),
('Desktop', 'HP high performance desktop')

insert into ProductSales values
(3, 450, 5),
(2, 250, 7),
(3, 450, 4),
(3, 450, 9)

select * from Product
select * from ProductSales

--- kirjutame päringu, mis annab infot müümata toodetest
select Id, Name, Description
from Product
where Id not in (select distinct ProductId from ProductSales)
-- distinct tagastab ainult unikaalsed väärtused

-- enamus juhtudel saab asendada subquerit JOIN'ga
--teeme sama päringut, aga JOIN'ga
select Product.Id, Name, Description
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is null

-- teeme subqueri, kus kasutame select'i. Kirjutame päringu, kus saame teada
-- Name ja TotalQuantity veeru andmed
select Name,
(select sum(QuantitySold) from ProductSales where ProductId = Product.Id) as
TotalQuantity
from Product
order by Name

-- sama tulemus JOIÑ'ga
select Name, sum(QuantitySold) as TotalQuantity
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
group by Name
order by Name

-- subqueryt saab subquery sisse panna
-- subquerid on alati sulgudes ja neid nimetatakse sisemisteks päringuteks

-- rida 2246
-- tund 11 -- 25.05.2026

--- rohkete anmetega testimise tabel

truncate table Product
truncate table ProductSales

create table Product
(
	Id int identity primary key,
	name nvarchar(50),
	Description nvarchar(250)
)

create table ProductSales
(
Id int primary key identity,
ProductId int foreign key references Product(Id),
UnitPrice int,
QuantitySold int
)

--- sisestame näidisandmed Product tabelisse
declare @Id int
set @Id = 1
while(@Id <= 3000000)
begin
	insert into Product
	values('Product ' + cast(@Id as nvarchar(20)),
	'Description for product ' + cast(@Id as nvarchar(20)))

	print @Id
	set @Id = @Id + 1
end

declare @RandomProductId int
declare @RandomUnitPrice int
declare @RandomQuantitySold int

--ProductId
declare @LowerLimitForProductId int
declare @UpperLimitForProductId int

set @LowerLimitForProductId = 1
set @UpperLimitForProductId = 3000

--UnitPrice
declare @LowerLimitForUnitPrice int
declare @UpperLimitForUnitPrice int

set @LowerLimitForUnitPrice = 1
set @UpperLimitForUnitPrice = 3000

--QuantitySold
declare @LowerLimitForQuantitySold int
declare @UpperLimitForQuantitySold int

set @LowerLimitForQuantitySold = 1
set @UpperLimitForQuantitySold = 100

declare @Counter int
set @Counter = 1

while(@Counter <= 900000)
begin
	set @RandomProductId = round(((@UpperLimitForProductId -
	@LowerLimitForProductId) * rand() + @LowerLimitForProductId), 0)

	set @RandomUnitPrice = round(((@UpperLimitForUnitPrice -
	@LowerLimitForUnitPrice) * rand() + @LowerLimitForUnitPrice), 0)

	set @RandomQuantitySold = round(((@UpperLimitForQuantitySold -
	@LowerLimitForQuantitySold) * rand() + @LowerLimitForQuantitySold), 0)

	insert into ProductSales
	values(@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

	print @Counter
	set @Counter = @Counter + 1
end

select * from Product
select * from ProductSales

-- võrdleme subquerit ja joini jõudlust
select Id, Name, Description
from Product
where Id in
(
select Product.Id from ProductSales
)

-- 3 miljonit rida 34 sekundit

-- teeme cache puhtaks, et uut päringut ei oleks kuskile vahemällu salvestatud
checkpoint;
go
dbcc DropCleanBuffers; -- puhastab päringu cache'i
go
dbcc FreeProcCache; -- puhastab protseduuride cache'i
go

-- teha sama tabeliga, aga JOIN'iga
select distinct ProductSales.Id, Name, Description
From Product
inner Join ProductSales
on Product.Id = ProductSales.ProductId

-- 10 sekundit 900 000

select Id, Name, Description
from Product
where not exists
(
select * from ProductSales where ProductId = Product.Id
)

--- 33 sekundit 2 997 000 rida

-- kasutame join'i
-- left join ja where ProductSales.ProductId is null
select Product.Id, Name, Description
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is null

--- 32 sekundit 2 997 000 rida

--Cursor
--relatsiooniliste DB'de haldussüsteemid saavad väga hästi hakkama
--SETS'ga. SETS lubab mitut päringut kombineerida üheks tulemuseks.
--Sinna alla käivad UNION, INTERSECT ja EXCEPT

update ProductSales set UnitPrice = 50
where ProductSales.ProductId = 101

--- kui on vaja rea kaupa andmeid töödelda, siis kõige parem oleks kasutada 
--- Cursoreid. Samas on need jõudlusele halvad ja võimalusel vältida. 
--- Soovitav oleks kasutada JOIN-i.

-- Cursorid jagunevad omakorda neljaks:
-- 1. Forward-Only e edasi-ainult
-- 2. Static e staatilised
-- 3. Keyset e võtmele seadistatud
-- 4. Dynamic e dünaamiline

-- näide
declare @ProductId int
--deklareerime cursori
declare ProductIdCursor cursor for
select ProductId from ProductSales
--open avaldusega täidab select avaldust
--ja sisestan tulemuse
open ProductIdCursor

fetch next from ProductIdCursor into @ProductId
-- kui tulemuses on veel ridu, siis @@Fetch_status on 0
while(@@FETCH_STATUS = 0)
begin
	declare @ProductName nvarchar(50)
	select @ProductName = Name from Product where Id = @ProductId

	if (@ProductName = 'Product 999')
	begin
		update ProductSales set UnitPrice = 999 where Productid = @ProductId
	end

	else if (@ProductName = 'Product 888')
	begin
		update ProductSales set UnitPrice = 888 where Productid = @ProductId
	end

	else if (@ProductName = 'Product 777')
	begin
		update ProductSales set UnitPrice = 777 where Productid = @ProductId
	end

	fetch next from ProductIdCursor into @ProductId
end
--vabastab rea seadistuse e suleb cursori
close ProductIdCursor
-- vabastab ressrursid, mis on seotud  cursoriga
deallocate ProductIdCursor
--päring lõppes

select * from ProductSales

--vaatame, kas read on uuendatud
--kasutage join ja where
select Name, UnitPrice
from Product
join ProductSales
on Product.Id = ProductSales.ProductId
where (Name = 'Product 777' or Name = 'Product 888' or Name = 'Product 999')

--asendame cursori joiniga
--tuleb kasutada case ja lihtsalt join'i
update ProductSales
set UnitPrice =
	case
		when Name = 'Product 777' then 1777
		when Name = 'Product 888' then 1888
		when Name = 'Product 999' then 1999
	end
from ProductSales
join Product
on Product.Id = ProductSales.ProductId
where (Name = 'Product 777' or Name = 'Product 888' or Name = 'Product 999')

--tabelite info
--nimekiri tabelitest
select * from sysObjects where xtype = 'S'

select * from sys.tables
--nimekiri tabelitest ja view'st
select * from INFORMATION_SCHEMA.TABLES

--kui soovid erinevaid objektitüüpe vaadata, siis kasuta XTYPE süntaksit
select distinct XTYPE from sysobjects

-- IT - internal table
-- P - stored procedure
-- PK - primary key constraint
-- S - system table
-- SQ - service queue
-- U - user table
-- V - view

--- annab teada, kas sellise nimega tabel on juba olemas
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Employee1232')
	begin
		create table Employee1232
		(
			Id int primary key,
			Name nvarchar(30),
			ManagerId int
		)
		print 'Table created'
	end
else
	begin
		print 'Table already exists'
	end

-- saab kasutada ka sisseehitatud funktsiooni: OBJECT_ID()
if OBJECT_ID('Employee') is null
	begin
		print 'Table created'
	end
else
	begin
		print 'Table already exists'
	end

--tahame Employee nimega tabeli ära kustutada ja siis uuesti luua
--kasutame OBJECT_ID'd
if OBJECT_ID('Employee') is not null
	begin
		drop table Employee
		print 'Table deleted'
		create table Employee
		(
			Id int primary key,
			Name nvarchar(30),
			ManagerId int
		)
		print 'Table created'
	end
else
	begin
		print 'Table not found'
	end

-- kui teha uuesti käivitavaks veeru kontrollimist ja loomist
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where
COLUMN_NAME = 'Email' and TABLE_NAME = 'Employee' and TABLE_SCHEMA = 'dbo')
	begin
		alter table Employee
		add Email nvarchar(50)
	end
else
	begin
		print 'Column already exists'
	end

--kontrollime, kas mingi nimega veerg on olemas??
--kasutame COL_LENGTH
if COL_LENGTH('Employee', 'Email') is not null
	begin
		print ' Column already exists'
	end
else
	begin
		print 'Column does not exists'
	end

--MERGE
--tutvustati aastal 2008, mis lubab teha sisestamist, uuendamist ja kustutamist
-- ei pea kasutama mitut käsku e saab ühega hakkama

--merge puhul peab alati olema vähemalt kaks tabelit:
--1. algallikas tabel e source table
--2. sihtmärk tabel e target table

--ühendab sihttabeli lähtetabeliga ja kasutab mõlemas tabelis ühist veergu
-- koodinäide
merge [TARGET] as T
using [SOURCE] as S
	on [JOIN_CONDITIONS]
when matched then
	[UPDATE_STATEMENT]
when not matched by target then
	[INSERT_STATEMENT]
when not matched by source then
	[DELETE_STATEMENT]

create table StudentSource
(
	id int primary key,
	Name nvarchar(20)
)
go
insert into StudentSource values(1, 'Mike')
insert into StudentSource values(2, 'Sara')
go

create table StudentTarget
(
	id int primary key,
	Name nvarchar(20)
)
go
insert into StudentTarget values(1, 'Mike M')
insert into StudentTarget values(2, 'John')

select * from StudentTarget
select * from StudentSource

-- 1. kui leitakse klappiv rida, siis StudentTarget tabel on uuendatud
-- 2. kui read on StudentSource tabelis olemas, aga neid ei ole StudentTarget's
-- siis puuduolevad read sisestatakse
-- 3. kui read on olemas StudentTarget's, aga mitte StudentSource's, siis StudentTarget
-- tabelis read kustutkse ära
--vaja teha merge, kasuta match

merge StudentTarget as T
using StudentSource as S
	on T.Id = S.Id
when matched then
	update set
		T.Name = S.Name
when not matched by target then
	insert (Id, Name)
	VALUES (S.Id, S.Name)
when not matched by source then
	Delete;

truncate table StudentTarget
truncate table StudentSource

insert into StudentSource values(1, 'Mike')
insert into StudentSource values(2, 'Sara')

insert into StudentTarget values(1, 'Mike M')
insert into StudentTarget values(3, 'John')

merge StudentTarget as T
using StudentSource as S
	on T.Id = S.Id
when matched then
	update set
		T.Name = S.Name
when not matched by target then
	insert (Id, Name)
	VALUES (S.Id, S.Name);

-- transaction'd

-- See on rühm käske, mis muudavad DB's salvestatud andmeid. Tehnigut käsitletakse
-- ühe tööüksusena. Kas kõik käsud õnnestuvad või mitte. Kui üks tehing sellest ebaõnnestub
-- siis kõik käsud õnnestuvad või mitte. Kui üks tehing sellest ebaõnnestub
--siis kõik juba muudetud andmed muudetakse tagasi

-- rida 2631 tund 13 02.06.2026

create table Account
(
	Id int primary key,
	AccountName nvarchar(25),
	Balance int
)

insert into Account values
(1, 'Mark', 1000),
(2, 'Mary', 2000)

--- transaction näide, et mõlemad uuendatavad read peavad õnnestuma, et muudatused jääksid kehtima

begin try
	begin transaction
		update Account set Balance = Balance - 100 where Id = 1
		update Account set Balance = Balance + 100 where Id = 2
	commit transaction
	print 'Transaction completed successfully'
end try
begin catch
	rollback transaction
	print 'Transaction failed'
end catch
go
select * from Account

--- mõned levinumad probleemid:
--- 1. Dirty read e must lugemine
--- 2. Lost Updates e kadunud uuendused
--- 3. Nonrepeatable reads e kordumatud lugemised
--- 4. Phantom read e fantoom lugemine

--- kõik eelnevad probleemid lahendakse ära, kui lubaksite igal ajal
--- korraga ühel kasutajal ühe tehingu teha. Selle tulemusel kõik tehingud
-- satuvad järjekorda ja neil võib tekkida vajadus kaua oodata, enne
--- kui võimalus tehingut teha saabub

--- kui lubada samaaegselt kõik tehingud ära teha, siis see omakorda tekitab probleeme
--- Probleemi lahendamiseks pakub MSSQL server erinevaid tehinguisolatsiooni tasemeid,
--- et tasakaalustada samaaegsete andmete CRUD(create, read, update ja delete) probleeme:

-- 1. read uncommited e lugemine ei ole teostatud
-- 2. read commited e lugemine tehtud
-- 3. repeatable read e korduv lugemine
-- 4. snapshot e kuvatõmmis
-- 5. serializable e serialiseerimine

--- igale juhtumile tuleb läheneda juhtumipõhiselt ja
--- mida vähem valet lugemist tuleb, seda aeglasem

--dirty read näide
create table Inventory
(
Id int identity primary key,
Product nvarchar(100),
ItemsInStock int
)
go
insert into Inventory values('TV', 10)
select * from Inventory

--1. käsklus
--1. transaction
begin tran
update Inventory set ItemsInStock = 9 where Id = 1
--klientidele tuleb arve
waitfor delay '00:00:15'
-- ebapiisav saldojääk ja teeb rollback-i
rollback tran

-- 2. käsklus
--- samal ajal tegin uue päringu akna,
--- kus kohe peale esimest käsklust käivitan
--- teise
--- 2 transaction
set tran isolation level read uncommitted
select * from Inventory where Id = 1


--- 3. käsklus
--- nüüd panen selle käskluse tööle
--- käivita, kui käsklus 1 on möödas
select * from Inventory (nolock) where Id = 1


---muutsin esimes käsuga 9 TV peale, aga ikka on 10 TV-d

--- lost update e kaunud uuendused
select * from Inventory
--- 1 transaction
--- 1 käsklus
begin tran
declare @ItemsInStock int

select @ItemsInStock = ItemsInStock
from Inventory where Id = 1

waitfor delay '00:00:15'
set @ItemsInStock = @ItemsInStock - 1

update Inventory
set ItemsInStock = @ItemsInStock
where Id = 1

print @ItemsInStock
commit transaction

--- 2 transaction
--- 2 käsklus
set tran isolation level repeatable read
begin tran
declare @ItemsInStock int

select @ItemsInStock = ItemsInStock
from Inventory where Id = 1

waitfor delay '00:00:01'
set @ItemsInStock = @ItemsInStock - 2

update Inventory
set ItemsInStock = @ItemsInStock
where Id = 1

print @ItemsInStock
commit tran

--- non repeatable read näide

-- see juhtub, kui üks transaction loeb samu andmeid kaks korda
-- ja teine transaction uuendab neid andmeid esimese ning teise
-- käsu vahel esimese transactioni jooksutamise ajal

-- 1 transaction
--set tran isolation level repeatable read
begin tran
select ItemsInStock from Inventory where Id = 1

waitfor delay '00:00:15'

select ItemsInStock from Inventory where Id = 1
commit tran
--- 2 transaction
--- 2 käsklus
update Inventory set ItemsInStock = 5
where Id = 1

--non repeatable read probleemi lahendamiseks kasutatakse tran 1 ees
--set tran isolation level repeatable read

--phantom read e fantoom lugemine

create table Employee
(
Id int primary key,
Name nvarchar(30)
)

insert into Employee values(1, 'Mark'),
(3, 'Sara'),
(100, 'Mary')

-- 1 transaction
-- 1 käsklus
set tran isolation level serializable

begin tran
select * from Employee where Id between 1 and 3

waitfor delay '00:00:15'
select * from Employee where Id between 1 and 3
commit tran

--- 2 transaction
--- 2 käsklus
insert into Employee
values (2, 'Marcus')

-- vastuseks tuleb: Mark ja Sara. Marcust ei näita, aga peaks

-- erinevus korduvlugemisega ja serialiseerimisega
--korduv lugemine hoiab ära ainult kordumatud lugemised
--serialiseerimine hoiab ära  kordumatud lugemised ja
--phantom read probleemid
--isolatsioonitase tagab et ühe tehingu loetud andmed ei
--takistaks muid transactioneid

-- DEADLOCK
create table TableA
(
Id int identity primary key,
Name nvarchar(20)
)
go
Insert into TableA values('Mark')
go
create table TableB
(
Id int identity primary key,
Name nvarchar(20)
)
go
Insert into TableB values('Mary')

---Transaction 1
-- samm nr 1
begin tran
update TableA set Name = 'Mark Transaction 1' where Id = 1

-- samm nr 3
update TableB set Name = 'Mary Transaction 1' where Id = 1

commit tran

--- teine server
-- samm nr 2
begin tran
update TableB set Name = 'Mark Transaction 2' where Id = 1

--samm nr 4
update TableA set Name = 'Mary Transaction 2' where Id = 1

commit tran


--- Kuidas SQL server tuvastab deadlocki?
--- Lukustatakse serveri lõim, mis töötab vaikimisi iga 5 sek järel
--- et tuvastada ummikuid. Kui leiab deadlocki, siis langeb 
--- deadlocki intervall 5 sek-lt 100 millisekundini.

--- mis juhtub deadlocki tuvastamisel
--- Tuvastamisel lõpetab DB-mootor deadlocki ja valib ühe lõime 
--- ohvriks. Seejärel keeratakse deadlockiohvri tehing tagasi ja 
--- tagastatakse rakendusele viga 1205. Ohvri tehingu tagasitõmbamine
--- vabastab kõik selle transactioni valduses olevad lukud.
--- See võimaldab teistel transactionitel blokeringut tühistada ja
--- edasi liikuda.

--- mis on DEADLOCK_PRIORITY
--- vaikimisi valib SQL server deadlockiohvri tehingu, mille 
--- tagasivõtmine on kõige odavam (võtab vähem ressurssi). Seanside 
--- prioriteeti saab muuta SET DEADLOCK_PRIORTY

--- DEADLOCK_PRIORTY
--- 1. vaikimisi on see Normali peal
--- 2. Saab seadistada LOW, NORMAL ja HIGH peale
--- 3. saab seadistada ka nr väärtusena -10-st kuni 10-ni

--- Ohvri valimise kriteeriumid
--- 1. Kui prioriteedid on erinevad, siis kõige madalama 
--- tähtsusega valitakse ohvriks
--- 2. Kui mõlemal sessioonil on sama prioriteet, siis valitakse 
--- ohvriks transaction,
--- mille tagasi viimine on kõige vähem ressurssi nõudev.
--- 3. Kui mõlemal sessioonil on sama prioriteet ja sama 
--- ressursi kulutamine, siis ohver valitakse juhuslikuse alusel

truncate table TableA
truncate table TableB

insert into TableA values('Mark')
insert into TableA values('Ben')
insert into TableA values('Todd')
insert into TableA values('Pam')
insert into TableA values('Sara')

insert into TableB values('Mary')

--- transaction 1
-- samm nr 1
begin tran
update TableA set Name = 
Name + 'Transaction 1' where Id in (1, 2, 3, 4, 5)

-- samm nr 3
update TableB set Name = Name + 
'Transaction 1' where Id = 1
-- samm nr 5
commit tran

-- transaction 2
-- samm nr 2
set deadlock_priority high
go
begin tran
update TableB set Name =
Name + 'Transaction 1' where Id = 1

--- samm nr 4
update TableA set Name =
Name + 'Transaction 1' where Id in (1, 2, 3, 4, 5)

--- samm nr 6
commit tran

--- deadlocki logimine
dbcc Traceon(1222, -1)

dbcc TraceStatus(1222, -1)

--kasutatakse, et globaalselt oleks keelatud 
dbcc Traceoff(1222, -1)

truncate table TableA
truncate table TableB

create proc spTransaction1
as begin
	begin tran
	update TableA set Name = 'Mark Transaction 1' where Id = 1
	waitfor delay '00:00:05'
	update TableB set Name = 'Mary Transaction 1' where Id = 1
	commit tran
end

create proc spTransaction2
as begin
	begin tran
	update TableA set Name = 'Mark Transaction 2' where Id = 1
	waitfor delay '00:00:05'
	update TableB set Name = 'Mary Transaction 2' where Id = 1
	commit tran
end

exec spTransaction1
exec spTransaction2
--- errorlogi kuvamine
exec sp_readerrorlog

-- kuidas leida viga koodi abil
-- selleks on meil vaja õiget objectId, aga hetkel ei ole teada
select OBJECT_NAME([OBJECT_ID])
from sys.partitions
where hobt_id = 72057594037927936
-- see nr on suvaline

alter proc spTransaction1
as begin
	begin tran
	begin try
		update TableA set Name = 'Mark Transaction 1' where Id = 1
		waitfor delay '00:00:05'
		update TableB set Name = 'Mary Transaction 1' where Id = 1

		commit tran
		select 'Transactionn Successful'
	end try
	begin catch
		--vaatab, kas see error on deadlocki oma
		if error_number() = 1205
		begin
			select 'Deadlock Detected'
		end

		rollback
	end catch
end

--muudame ka teise sp ära
alter proc spTransaction2
as begin
	begin tran
	begin try
		update TableA set Name = 'Mark Transaction 2' where Id = 1
		waitfor delay '00:00:05'
		update TableB set Name = 'Mary Transaction 2' where Id = 1

		commit tran
		select 'Transactionn Successful'
	end try
	begin catch
		--vaatab, kas see error on deadlocki oma
		if error_number() = 1205
		begin
			select 'Deadlock Detected'
		end

		rollback
	end catch
end

-- nüüd käivitan esimeses serveris spTransaction1 ja 
-- teises serveris spTransaction2
spTransaction1


SELECT
    [s_tst].[session_id],
    [s_es].[login_name] AS [Login Name],
    DB_NAME (s_tdt.database_id) AS [Database],
    [s_tdt].[database_transaction_begin_time] AS [Begin Time],
    [s_tdt].[database_transaction_log_bytes_used] AS [Log Bytes],
    [s_tdt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
    [s_est].text AS [Last T-SQL Text],
    [s_eqp].[query_plan] AS [Last Plan]
FROM
    sys.dm_tran_database_transactions [s_tdt]
JOIN
    sys.dm_tran_session_transactions [s_tst]
ON
    [s_tst].[transaction_id] = [s_tdt].[transaction_id]
JOIN
    sys.[dm_exec_sessions] [s_es]
ON
    [s_es].[session_id] = [s_tst].[session_id]
JOIN
    sys.dm_exec_connections [s_ec]
ON
    [s_ec].[session_id] = [s_tst].[session_id]
LEFT OUTER JOIN
    sys.dm_exec_requests [s_er]
ON
    [s_er].[session_id] = [s_tst].[session_id]
CROSS APPLY
    sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est]
OUTER APPLY
    sys.dm_exec_query_plan ([s_er].[plan_handle]) AS [s_eqp]
ORDER BY
    [Begin Time] ASC;
GO