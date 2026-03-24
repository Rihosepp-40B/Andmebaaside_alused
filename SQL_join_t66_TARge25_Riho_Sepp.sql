use AdventureWorksDW2019

--- left join ühendab DimCustomer ja DimGeography tabeli kasutades sobivuse leidmiseks GeographyKey,
--- mis on DimCustomeri tabelis võõrvõti ning DimGeography tabelis primaarvõti.
--- Väljastab ühendtabeli kus on kõik read, mis on vasakus ehk DimCustomer tabelis, koos lisatud veergudega.
select Firstname, MiddleName, LastName, EnglishCountryRegionName As Country, City
from DimCustomer C
left join DimGeography G
on C.GeographyKey = G.GeographyKey


--- right join ühendab tabelid "parema" tabeli ridade järgi. All variandi puhul ühendab DimGeography ja
--- DimSalesTerritory, kasutades ühenduseks võtmeks SalesTerritoryKey.
--- Väljastab tabeli, mis näitab müügipiirkonnas asuvate linnade arvu.
select SalesTerritoryGroup, count(City) As [Total City's]
from DimGeography G
right join DimSalesTerritory S
on G.SalesTerritoryKey = S.SalesTerritoryKey
group by SalesTerritoryGroup having count(City) > 0


--- inner join ühendab "vasaku" ja "parema" väljastades tabeli, kus ühendamise aluseks olevates veergudes
--- mõlemal poolel on olemas väärtus (ei ole NULL väärtust). All variandi puhul ühendatu DimOrganization
--- iseendaga, et näidata mis organisatsioonile mingi organisatsioon allub.
select O2.OrganizationName as [Parent organization], O.OrganizationName as [Child organization]
from DimOrganization O
inner join DimOrganization O2
on O.ParentOrganizationKey = O2.OrganizationKey


--- full outer join või siis full join ühendab tabelid ja väljastab mõlema poole kõik read mõlemast tabelist,
--- ka need millel pole sobivat vastas väärtust. Read millel on mitu sobivat väärtust väljastatakse mitme reaga.
--- All variant ühendab DimOrganization ja DimCurrency tabelid, väljastades valuuta tabeli, näidates mis valuuta
--- on kasutusel nimetatud organistasioonide puhul ja millised mitte.
select CurrencyName, OrganizationName, CurrencyAlternateKey
from DimOrganization O
full outer join DimCurrency C
on O.CurrencyKey = C.CurrencyKey


--- cross join ühendab kaks tabelit paaritades mõlema tabeli iga rea vastas poolega. All variant ühendab tabelid DimOrganization
--- ja DimProductCategory, väljastades tabeli, mis näitab igat toote kategooriat iga organisatsiooni küljes.
select OrganizationName, EnglishProductCategoryName As ProductCategoryName
from DimOrganization
cross join DimProductCategory


--- Uue tabeli tegemine
create table NewRecruits
(Id int not NULL primary key,
Firstname nvarchar(50),
Lastname nvarchar(50),
Gender nvarchar(10),
Age int not NUll,
City nvarchar(50),
[E-mail] nvarchar(50)
)

select * from NewRecruits


insert into NewRecruits (Id, Firstname, Lastname, Gender, Age, City, [E-mail])
values (1, 'Aadu', 'Aavik','Mees', 28, 'Pärnu', 'Aadu@aavik.com'),
(2, 'Peedu', 'Peet', 'Mees', 35, 'Tartu', 'Peedu@peet.com'),
(3, 'Tiit', 'Tuut', 'Mees', 46, 'Tallinn', 'Tiit@tuut.com'),
(4, 'Stiina', 'Saar', 'Naine', 23, 'Tallinn', 'Stiina@saar.com'),
(5, 'Jaan', 'Jaaniuss', 'Mees', 27, 'Paide', 'Jaan@jaaniuss.com'),
(6, 'Heidi', 'Häving', 'Naine', 30, 'Viljandi', 'Heidi@h2ving.com'),
(7, 'Laura', 'Lagrits', 'Naine', 39, 'Pärnu', 'Laura@lagrits.com'),
(8, 'Olev', 'Olevipoeg', 'Mees', 60, 'Haapsalu', 'Olev@olevipoeg.com'),
(9, 'Kalev', 'Kalevipoeg', 'Mees', 57, 'Paide', 'Kalev@kalevipoeg.com'),
(10, 'Toomas', 'Toome', 'Mees', 33, 'Haapsalu', 'Toomas@toome.com')

select * from NewRecruits