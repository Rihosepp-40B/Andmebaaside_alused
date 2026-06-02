use AdventureWorksLT2019

CREATE FUNCTION fn_GetAllCustomers_ITVF()
RETURNS TABLE
AS
RETURN
(
    SELECT FirstName, MiddleName, LastName FROM SalesLT.Customer
);

select * from fn_GetAllCustomers_ITVF()


CREATE FUNCTION fn_GetCustomerByID_ITVF (@CustomerID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT FirstName, LastName
    FROM SalesLT.Customer
    WHERE CustomerID = @CustomerID
);

select * from fn_GetCustomerByID_ITVF(1)


CREATE FUNCTION fn_GetOrdersByCustomer_ITVF (@CustomerID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM SalesLT.SalesOrderHeader
    WHERE CustomerID = @CustomerID
);

select * from fn_GetOrdersByCustomer_ITVF(29957)


CREATE FUNCTION fn_GetProductsByPrice_ITVF (@MinPrice MONEY, @MaxPrice MONEY)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM SalesLT.Product
    WHERE ListPrice BETWEEN @MinPrice AND @MaxPrice
);

select * from fn_GetProductsByPrice_ITVF(1, 100)


CREATE FUNCTION fn_GetTopExpensiveProducts_ITVF()
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 10 * FROM SalesLT.Product
    ORDER BY ListPrice DESC
);

select * from fn_GetTopExpensiveProducts_ITVF()


--- osa 2
CREATE FUNCTION fn_GetCustomerFullInfo_MSTVF (@CustomerID INT)
RETURNS @Result TABLE 
(
    FullName NVARCHAR(150),
    EmailAddress NVARCHAR(50),
    Phone NVARCHAR(25)
)
AS
BEGIN
    INSERT INTO @Result (FullName, EmailAddress, Phone)
    SELECT 
        CONCAT(FirstName, ' ', LastName) AS FullName,
        EmailAddress,
        Phone
    FROM SalesLT.Customer
    WHERE CustomerID = @CustomerID
    RETURN
END

select * from fn_GetCustomerFullInfo_MSTVF(1)


CREATE FUNCTION fn_GetCustomerOrderSummary_MSTVF (@CustomerID INT)
RETURNS @Result TABLE
(
    OrderCount INT,
    TotalAmount MONEY
)
AS
BEGIN
    INSERT INTO @Result (OrderCount, TotalAmount)
    SELECT 
        COUNT(SalesOrderID) AS OrderCount,
        ISNULL(SUM(TotalDue), 0) AS TotalAmount
    FROM SalesLT.SalesOrderHeader
    WHERE CustomerID = @CustomerID
    RETURN
END

select * from fn_GetCustomerOrderSummary_MSTVF(29957)


CREATE FUNCTION fn_GetProductPriceCategory_MSTVF()
RETURNS @Result TABLE
(
    ProductID INT,
    Name NVARCHAR(50),
    ListPrice MONEY,
    PriceCategory NVARCHAR(20)
)
AS
BEGIN
    INSERT INTO @Result (ProductID, Name, ListPrice, PriceCategory)
    SELECT 
        ProductID,
        Name,
        ListPrice,
        CASE 
            WHEN ListPrice < 100 THEN 'Odav'
            WHEN ListPrice BETWEEN 100 AND 1000 THEN 'Keskmine'
            ELSE 'Kallis'
        END AS PriceCategory
    FROM SalesLT.Product
    RETURN
END

select * from fn_GetProductPriceCategory_MSTVF()


CREATE FUNCTION fn_GetCustomersWithOrders_MSTVF()
RETURNS @Result TABLE
(
    CustomerID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
)
AS
BEGIN
    INSERT INTO @Result (CustomerID, FirstName, LastName)
    SELECT DISTINCT 
        C.CustomerID, 
        C.FirstName, 
        C.LastName
    FROM SalesLT.Customer C
    INNER JOIN SalesLT.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
    RETURN
END

select * from fn_GetCustomersWithOrders_MSTVF()


CREATE FUNCTION fn_GetTopCustomersBySpending_MSTVF()
RETURNS @Result TABLE
(
    CustomerID INT,
    FullName NVARCHAR(150),
    TotalSpent MONEY
)
AS
BEGIN
    INSERT INTO @Result (CustomerID, FullName, TotalSpent)
    SELECT TOP 5
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS FullName,
        SUM(O.TotalDue) AS TotalSpent
    FROM SalesLT.Customer C
    INNER JOIN SalesLT.SalesOrderHeader O ON C.CustomerID = O.CustomerID
    GROUP BY C.CustomerID, C.FirstName, C.LastName
    ORDER BY TotalSpent DESC
    RETURN
END

select * from fn_GetTopCustomersBySpending_MSTVF()