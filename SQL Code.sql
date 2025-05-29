Use AdventureWorks2016;
select * from HumanResources.Department;

select * from HumanResources.Employee;

select * from HumanResources.EmployeeDepartmentHistory;

select * from HumanResources.EmployeePayHistory;

select * from HumanResources.Shift;

SELECT * from HumanResources.JobCandidate;

select * from dbo.Human_resource_Data;

select * from dbo.Human_resource_Data;


select * from HumanResources.Employee as H_emp
Inner Join HumanResources.EmployeeDepartmentHistory as emp_hist
on H_emp.BusinessEntityID = emp_hist.BusinessEntityID 
Inner Join HumanResources.Department as emp_dpt
on emp_hist.DepartmentID = emp_dpt.DepartmentID ;



-- Create temporaty table for human resouce section
SELECT H_emp.BusinessEntityID,H_emp.NationalIDNumber,H_emp.OrganizationLevel,H_emp.JobTitle,
H_emp.BirthDate,H_emp.MaritalStatus,H_emp.Gender,H_emp.SalariedFlag,H_emp.VacationHours,H_emp.SickLeaveHours,
emp_hist.DepartmentID,emp_dpt.Name,emp_dpt.GroupName
INTO #HR
FROM HumanResources.Employee AS H_emp
INNER JOIN HumanResources.EmployeeDepartmentHistory AS emp_hist
    ON H_emp.BusinessEntityID = emp_hist.BusinessEntityID
INNER JOIN HumanResources.Department AS emp_dpt
    ON emp_hist.DepartmentID = emp_dpt.DepartmentID;


-- DISPLAY TEMP HR TABLE( REMEMBER TO INSTANCIATE IT WHEN ITS NEEDED AGAIN
SELECT * FROM #HR;



-- Sales analysis
select * from Sales.CountryRegionCurrency;

select * from Sales.CreditCard;

select * from Sales.Currency;

select * from Sales.CurrencyRate

select * from Sales.PersonCreditCard


select * from Sales.SalesOrderDetail;

select * from Sales.SalesOrderHeader;

select * from Sales.SalesOrderHeaderSalesReason  -- usable: join on SalesOrderID

select * from Sales.SalesPerson                  -- usable

select * from Sales.SalesPersonQuotaHistory


select * from Sales.SalesReason					-- usable

select * from Sales.SalesTaxRate

select * from Sales.SalesTerritory				-- usable

select * from Sales.SalesTerritoryHistory;

select * from Sales.SpecialOffer

select * from Sales.SpecialOfferProduct



--joining tables
select * from Sales.SalesOrderDetail;

select * from Sales.SalesOrderHeader;

select * from Sales.SalesOrderHeaderSalesReason  -- usable: join on SalesOrderID
   

select * from Sales.SalesReason			


-- SALES REASONING
select SOH.SalesOrderID,SR.Name, SR.ReasonType  from Sales.SalesOrderHeaderSalesReason As SOH
Inner Join Sales.SalesReason As SR
on SOH.SalesReasonID = SR.SalesReasonID;


select * from Production.Product;

--Sales and Product
Select SLO.SalesOrderID,SLO.SalesOrderDetailID,SLO.ProductID,SLO.CarrierTrackingNumber,Prod.Name,Prod.Color,Prod.Size,SLO.OrderQty,
 SLO.UnitPrice, SLO.UnitPriceDiscount,SP.Type as Specia_Offer_type,SLO.LineTotal
from Sales.SalesOrderDetail As SLO
Inner Join Production.Product AS Prod
On SLO.ProductID = Prod.ProductID
Inner join Sales.SpecialOffer AS SP
On SLO.SpecialOfferID = SP.SpecialOfferID


--Grouping Sales data


--Geography sale : Sale order hearder and Sale territory
Select SH.SalesOrderID,SH.TerritoryID,ST.[Name],ST.[Group], ST.CountryRegionCode INTO #Sales_Geo
FROM Sales.SalesOrderHeader AS SH
Inner Join Sales.SalesTerritory as ST
On SH.TerritoryID = ST.TerritoryID
Select * from #Sales_Geo;

-- sales, product,speial offer group : Sales_SPO
Select SLO.SalesOrderID,SLO.SalesOrderDetailID,SLO.ProductID,SLO.CarrierTrackingNumber,Prod.[Name],Prod.Color,Prod.Size,SLO.OrderQty,
 SLO.UnitPrice, SLO.UnitPriceDiscount,SP.[Type] as Specia_Offer_type,SLO.LineTotal
 INTO #Sales_SPO
from Sales.SalesOrderDetail As SLO
Inner Join Production.Product AS Prod
On SLO.ProductID = Prod.ProductID
Inner join Sales.SpecialOffer AS SP
On SLO.SpecialOfferID = SP.SpecialOfferID


-- combine Sales_Geo & Sales_SPO
select * from #Sales_SPO
Inner Join  #Sales_Geo
on #Sales_SPO.SalesOrderID = #Sales_Geo.SalesOrderID ;


--Sales final table
select SLO.SalesOrderID,SLO.SalesOrderDetailID,SLO.ProductID,SLO.CarrierTrackingNumber,SLO.[Name],SLO.Color,SLO.Size,SLO.OrderQty,
 SLO.UnitPrice, SLO.UnitPriceDiscount,SLO.Specia_Offer_type,SLO.LineTotal,SH.TerritoryID,SH.[Name] as CountryName,SH.[Group], SH.CountryRegionCode
 
 Into #Sales_Final 
from #Sales_SPO As SLO
Inner Join  #Sales_Geo AS SH
on SLO.SalesOrderID = SH.SalesOrderID;


select * from #Sales_Final;
--cross apply string_split([Name],'-')
--cross apply string_split([Name],',');

--SELECT DISTINCT *
--FROM (
--    SELECT
  --      sf.*,
 --       LTRIM(RTRIM(value)) AS CleanedName
  --  FROM #Sales_Final sf
   -- CROSS APPLY STRING_SPLIT(
    --    REPLACE(REPLACE([Name], '-', ','), ' ', ','), 
    --    ','
   -- )
    --WHERE LTRIM(RTRIM(value)) <> ''
--) AS DistinctResults;



-- Product section
select * from Production.Culture;
select * from Production.Product;


select * from Production.ProductCategory;
select * from Production.ProductCostHistory;

select * from Production.ProductInventory;
select * from Production.UnitMeasure;


-- person stuff: (uusable)
select * from Person.[Address];
select * from Person.AddressType;
select * from Person.BusinessEntity;
select * from Person.Person;

SELECT 
  COLUMN_NAME,
  DATA_TYPE,
  ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME   = 'Sales_report'
ORDER BY ORDINAL_POSITION;



-- Exporting the new data
--convert temp table to actual table

-- Select * Into Sales_report from #Sales_Final;  --Salesfinal table

-- Select * into Human_resource_Data from #HR;    --compiled HR data


-- export data from progam export menu
--Database > Tasks>Export> CSV/EXCEL> SQl Table code



-- --------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------
---------------------------------------Testing Group BY ---------------------------------------------
-- --------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------
---------------------------------------sales report--------------------------------------------------

select * from Sales_report;
-- Lets group by Country
select [Name],Color, Size,CountryName, UnitPrice, Floor(Unitprice * OrderQty) as Total_Price from Sales_report
order by Total_Price Desc;

--group by all that---
select [Name],CountryName, Floor(Unitprice * OrderQty) as Total_Price from Sales_report
group by [Name],CountryName,Floor(Unitprice * OrderQty);


--group by and order by country name
select CountryName, Floor(Unitprice * OrderQty) as Total_Price from Sales_report
group by CountryName,Floor(Unitprice * OrderQty)
order by CountryName Desc;


-- Sum of all sales in various countries
-- when using agregation functions, no need to add it to the group by clause
select CountryName, Sum(Floor(Unitprice * OrderQty)) as Total_Price from Sales_report
group by CountryName
order by CountryName desc;


-- trying out having
Select CountryName, Sum(Floor(Unitprice * OrderQty)) as Total_Price from Sales_report
group by CountryName
Having Sum(UnitPrice * OrderQty) > 10000000 
order by CountryName desc;


-- trying CTE's on Person's Table

select * from Person.Person;
select * from Person.Address;
select * from Person.AddressType;
select * from Person.BusinessEntityAddress;


With Person_Address_data AS(

select Biz.BusinessEntityID, Biz.AddressID, PP.FirstName,PP.LastName,ADT.[Name] As Address_Name_type,
PP.Title, PP.PersonType from Person.BusinessEntityAddress As Biz
Join Person.AddressType as ADT
on Biz.AddressTypeID = ADT.AddressTypeID
Join Person.Person as PP 
on Biz.BusinessEntityID = PP.BusinessEntityID

)
Select * from Person_Address_data;


-- testing ot grace'squerty
select * from dbo.Human_resource_Data;

select * from dbo.Sales_report;