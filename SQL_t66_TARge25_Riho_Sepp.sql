use AdventureWorksDW2019

create procedure spGetEmployeesByGender
@Gender nvarchar(10)
as begin
	select FirstName, LastName, MiddleName, Gender, Title, DepartmentName from DimEmployee
	where Gender = @Gender
end

exec spGetEmployeesByGender 'm'


create function fn_EmployeesByDepartment(@Department nvarchar(50))
returns table as
return (select FirstName, LastName, MiddleName, BirthDate, Title, DepartmentName
	from DimEmployee
	where DepartmentName =  @Department)

select * from fn_EmployeesByDepartment('Marketing')


create function fn_GetAge(@Age date)
returns int
as begin
declare @Age date



create table #PersonCarColor(Id int, Name nvarchar(20), CarColor nvarchar(10))
insert into #PersonCarColor values
(1, 'Mart', 'red'),
(2, 'Tiit', 'green'),
(3, 'Peep', 'blue'),
(4, 'Teele', 'pink')
go
select * from #PersonCarColor


create table ##GlobalPersonDetails(Id Int, Name nvarchar(20), DateOfBirth date)
insert into ##GlobalPersonDetails values
(1, 'Mart', '2006-05-12'),
(2, 'Tiit', '2000-02-20'),
(3, 'Peep', '1999-03-7'),
(4, 'Teele', '2007-12-30')
go
select * from ##GlobalPersonDetails


create index IX_Employees_DOB
on DimEmployee(BirthDate desc)

select FirstName, LastName, MiddleName, BirthDate, Title, DepartmentName
from DimEmployee
with (index (IX_Employees_DOB))


create view vEmployeeDOB
as
select FirstName, LastName, MiddleName, BirthDate
from DimEmployee

select * from vEmployeeDOB


create view vEmployeeSalesTerritory
as
select FirstName, LastName, MiddleName, SalesTerritoryCountry, SalesTerritoryGroup
from DimEmployee E
join DimSalesTerritory S
on E.SalesTerritoryKey = S.SalesTerritoryKey

select * from vEmployeeSalesTerritory


create view vEmployeeParentEmployee
as
select E.FirstName, E.LastName, E.MiddleName, CONCAT(P.FirstName,' ', P.LastName) as ParentEmployee
from DimEmployee E
join DimEmployee P
on E.ParentEmployeeKey = P.EmployeeKey

select * from vEmployeeParentEmployee