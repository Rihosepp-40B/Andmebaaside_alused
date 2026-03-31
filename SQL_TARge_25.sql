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
-- 4 tund
-- 31.03.2026
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

--stored procedure
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
exec spGetNameById 9, @FirstName out
print 'Name of employee = ' + @FirstName
-- ei anna tulemust, sest sp's on loogika viga. sest @ Id on parameeter, mis on mõeldud selleks,
--et me saaksime sisestada id'd ja saada nime, aga sp's on loogika viga, sest see üritab määrata
--@Id väärtuseks Id veeru väärtust, mis on vale