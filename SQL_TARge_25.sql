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

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int  -- @ märk töhistab muutujat
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

--soocin ainult näha Pam ja kasutan funktsiooni fn_EmployeesByGender
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
--Multi statement tabeli valued funktsioonid on nagu tavalised funktsiooid,
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

--temporary tables
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

--index
create table EmployeesWithSalary
(
Id int primary key,
Name nvarchar(25),
Salary int,
Gender nvarchar(10)
)

insert into EmployeeWithSalary
values (1, 'Sam', 2500, 'Male'),
(2, 'Pam', 6500, 'Female'),
(3, 'John', 4500, 'Male'),
(4, 'Sara', 5500, 'Female'),
(5, 'Todd', 3100, 'Male')

select * from EmployeeWithSalary
where Salary > 5000 and Salary < 7000

--loome indeksi, mis asetab palga kahanevasse järjestusse
create index IX_Employee_Salary
on EmployeeWithSalary(Salary desc)

--proovige pärida tabelit EmployeeWithSalary ja kasutada index'it IX_Employee_Salary
select * from EmployeeWithSalary with (index (IX_Employee_Salary))

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

--Klastris olev indeks määrab ära tabelis oleva füüsilise järjestuse ja
--selle tulemusel saab tabelis olla ainult üks klastris olev indeks kui
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

--klastris olevad ineksid dikteerivad säilitatud andmete järjestuse tabelis ja
--seda saab klastrite puhul olla ainult üks
create clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)
--annab veateate, et tabelis saab olla inult üks klastris olev indeks, kui soovid
--uut indeksit luua, siis kustuta olemasolev

--saame luua inult ühe klasteris oleva indeksi tabeli peale. Klastris olev indeks
--on analoogne telefoni numbrile
--enne seda päringut kustutasime primaarvõtme indeksi ära
select * from EmployeeCity

--mitte klastris olev indeks
create nonclustered index IX_EmployeeCity_Name123
on EmployeeCity(name)

exec sp_helpindex EmployeeCity

Select * from EmployeeCity

--Erinevused kahe indeksi vahel
--1. ainult üks klastris olev indeks saaab olal tabeli peale,
--mitte-klastris olevadi indekseid saab olla mittu
--2. klastris olevad indeksid on kiiremad kuna indeks peab tagasi viitama tabelile
--Juhul, kui selekteeritud veerg ei ole olemas indeksis
--3. klastris olev indeks määratleb ära tabeli ridade salvestusjärjestuse
--ja ei nõua kettal lisa ruumi- Samas mitte klastris olevad indeksid on
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