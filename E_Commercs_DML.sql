USE E_CommerceDB
GO
--~~~~~~~~~~~~~~~~~~~~~~~~~
--Value Insert in Table
--~~~~~~~~~~~~~~~~~~~~~~~~~

INSERT INTO ec.Supplier VALUES ('Nijam','01830328616','CTG','nijam@gmail.com'),
							('Jahid','01960328616','DHK','Jahid@gmail.com'),
							('Yousuf','01540328616','SLT','Yousuf@gmail.com'),
							('Minhaj','01680328616','CML','minhaj@gmail.com'),
							('Hasan','01730328617','KHL','hasan@gmail.com');
GO

INSERT INTO ec.Product VALUES ('SSD','White'),
						('Watcg','Blue'),
						('Monitor','Red'),
						('SSD','Black'),
						('Mouse','White');
GO

--SP insert in e.product table
Exec sp_Product 7,'Sulaiman','01650321456','ctg','sulaiman@gmail.com',9,'SSD','White','Product','Insert'
GO




INSERT INTO ec.Catagory VALUES('Cat : 01'),
							('Cat : 02'),
							('Cat : 03'),
							('Cat : 04'),
							('Cat : 05');
GO


INSERT INTO ec.ProductInfo VALUES(1,1,1,100,200),
								(2,2,2,200,400),
								(3,3,3,300,500),
								(4,4,4,400,600),
								(5,5,5,500,700);
GO

INSERT INTO ec.Stock VALUES(1,'stock :01',1,150),
						(2,'stock :02',2,250),
						(3,'stock :03',3,350),
						(4,'stock :04',4,450),
						(5,'stock :05',5,550);
GO


INSERT INTO ec.Customer VALUES('Sakib','01753328616','ctg','Sakib@gmail.com'),
							('Abswer','01953328617','Dhaka','Abswer@gmail.com'),
							('Nizam','01653328618','Sylet','Nizam@gmail.com'),
							('Newaz','01573328619','Cox','Newaz@gmail.com'),
							('Hamid','01653328612','Kholna','Hamid@gmail.com');
GO

INSERT INTO ec.Orders VALUES('2022/12/02',1),
							('2022/11/02',2),
							('2022/11/03',3),
							('2022/11/05',4),
							('2022/11/06',5);
GO

INSERT INTO ec.OrderDetails VALUES(5,1,30,550,GETDATE()),(3,2,40,750,GETDATE())



INSERT INTO ec.Payment VALUES('Bkash',1),('Nagad',2)
GO

GO

INSERT INTO ec.Stock VALUES(1,'stock :01',1,150)
GO

--Select Value
SELECT * FROM ec.Supplier
SELECT * FROM ec.Product
SELECT * FROM ec.Catagory
SELECT * FROM ec.ProductInfo
SELECT * FROM ec.Orders
SELECT * FROM ec.Stock
SELECT * FROM ec.Customer
SELECT * FROM ec.OrderDetails
SELECT * FROM ec.Payment
GO

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Update Value-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Update ec.Product
Set ProductName='Mustofa'
Where ProductID=2
Go

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Delete Valuee-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DELETE FROM ec.Payment WHERE PaymentID=1
GO

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-------Inner Join-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


SELECT s.SupplierID,p.PurInfoID,Quantity,pr.ProductID,cat.CatagoryName,st.StockName
FROM ec.Supplier AS s
Inner Join ec.ProductInfo AS p
ON s.SupplierID=p.SupplierID
Inner join ec.Product AS pr
ON pr.ProductID=p.ProductID
Inner join ec.Catagory AS cat
ON cat.CatagoryID=p.CatagoryID
Inner join ec.Stock AS st
ON st.PurInfoID=p.PurInfoID

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-------Left Outer Join---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT s.SupplierID,p.PurInfoID,Quantity,pr.ProductID,cat.CatagoryName,st.StockName
FROM ec.Supplier as s
Left Join ec.ProductInfo as p
ON s.SupplierID=p.SupplierID
Left join ec.Product as pr
ON pr.ProductID=p.ProductID
Left join ec.Catagory as cat
ON cat.CatagoryID=p.CatagoryID
Left join ec.Stock as st
ON st.PurInfoID=p.PurInfoID


----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-------Right outer Join---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT s.SupplierID,p.PurInfoID,Quantity,pr.ProductID,cat.CatagoryName,st.StockName
FROM ec.Supplier as s
Right Join ec.ProductInfo as p
ON s.SupplierID=p.SupplierID
Right join ec.Product as pr
ON pr.ProductID=p.ProductID
Right join ec.Catagory as cat
ON cat.CatagoryID=p.CatagoryID
Right join ec.Stock as st
ON st.PurInfoID=p.PurInfoID


----~~~~~~~~~~~~~~~~~~~~~~~~
--------Full Join-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT s.SupplierID,p.PurInfoID,Quantity,pr.ProductID,cat.CatagoryName,st.StockName
FROM ec.Supplier as s
Full Join ec.ProductInfo as p
ON s.SupplierID=p.SupplierID
Full join ec.Product as pr
ON pr.ProductID=p.ProductID
Full join ec.Catagory as cat
ON cat.CatagoryID=p.CatagoryID
Full join ec.Stock as st
ON st.PurInfoID=p.PurInfoID


----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Cross Join-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT s.SupplierID,p.PurInfoID,Quantity
FROM ec.Supplier as s
Cross Join ec.ProductInfo as p

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Self Join-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT p.ProductID, c.ProductName
FROM ec.Product as p, ec.Product as c
Where p.ProductID <> c.ProductID

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Union Operator----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT ProductID FROM ec.Product
Union 
SELECT CatagoryID FROM ec.Catagory
GO


----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
----Intersection Operator-------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT ProductID FROM ec.Product
Interrsection
SELECT CatagoryID FROM ec.Catagory
GO

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
----Cast, Convert, Concatenation-----
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT 'Today :' + Cast(Getdate() as varchar)
SELECT 'Today :' + CONVERT(varchar,Getdate())

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Basic Clause (Select,From, Where, Having, Group By, Order By---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT count(ProductID)
FROM ec.Product
where Color='White'
Group by Color
Having count (ProductID)<1
order by Color desc 
GO
Go

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Distinct-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT Distinct PurInfoID,SupplierID,ProductID,UnitPrice
from ec.ProductInfo
Go

----~~~~~~~~~~~~~~~~~~~~~~~~~
--------Sub Query-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT * 
FROM ec.Product
Where Color in (Select Color From ec.Product Where Color='Red')
Go


----~~~~~~~~~~~~~~~~~~~~~~~~~
--------WildCard -----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT *
FROM ec.Product
Where ProductName Like 'Mo__t%'
Go

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---Cube, Rollup, Grouping Set-------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT ProductID,SupplierID,Sum(Quantity)
FROM ec.ProductInfo
Group By ProductID,SupplierID With Cube
Go

SELECT ProductID,SupplierID,Sum(Quantity)
FROM ec.ProductInfo
Group By ProductID,SupplierID With ROLLUP
Go

SELECT ProductID,SupplierID, Sum(Quantity)
FROM ec.ProductInfo
Group By Grouping Sets(
(ProductID,SupplierID,Quantity),
(ProductID)
)
Go


----~~~~~~~~~~~~~~~~
-----Sequence-------
--~~~~~~~~~~~~~~~~~~

Create Sequence sn_pur
As Bigint
Start with 1
increment by 2
Minvalue 1
Maxvalue 99
Cycle
Cache 10
Go
SELECT next value for sn_pur
GO

----~~~~~~~~~~~~~~~~
-----CTE-------
--~~~~~~~~~~~~~~~~~~

WITH pur_CTE (PurInfoID,SupplierID,ProductID,UnitPricePur)
AS
	(
	SELECT PurInfoID,SupplierID,ProductID,UnitPrice
	FROM ec.ProductInfo
	)

SELECT * FROM pur_CTE
GO

----~~~~~~~~~~~~~~~~
----CASE-------
--~~~~~~~~~~~~~~~~~~

SELECT SupplierID, ProductID,
	Case ProductID
	When 1 then 'Mobail'
	When 2 then 'Laptop'
	When 3 then 'Monitor'
	When 4 then 'KeyBoard'
	When 5 then 'Mouse'
	Else 'No Product'
End	 
FROM ec.ProductInfo
Go

----~~~~~~~~~~~~~~~~
----Operator-------
--~~~~~~~~~~~~~~~~~~

SELECT 100+2 as [Sum]
Go
SELECT 50-2 as [Substraction]
Go
SELECT 30*3 as [Multiplication]
Go
SELECT 50/2 as [Divide]
Go
SELECT 10%3 as [Remainder]
Go

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Distinct, AND, OR,,NOT,BETWEEN,ALL,Any
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT AVG(DISTINCT Quantity)  
FROM ec.ProductInfo

Go
SELECT *   
FROM ec.ProductInfo 
WHERE PurInfoID=2
OR ProductID=2   
AND UnitPrice > 200
ORDER BY PurInfoID DESC

SELECT Quantity,UnitPrice   
FROM ec.ProductInfo   
WHERE Quantity = ANY (SELECT Quantity FROM ec.ProductInfo WHERE UnitPrice >= 400 )
Go

SELECT Quantity,UnitPrice
FROM ec.ProductInfo  
WHERE UnitPrice > ALL (SELECT AVG (UnitPrice)  FROM ec.ProductInfo  Group BY Quantity )
ORDER BY UnitPrice ;
 

Go

SELECT PurInfoID,Quantity
FROM ec.ProductInfo
WHERE UnitPrice BETWEEN  400 AND 500
ORDER By UnitPrice

Go

SELECT PurInfoID,Quantity
FROM ec.ProductInfo
WHERE UnitPrice NOT BETWEEN  400 AND 500
ORDER By UnitPrice 
Go

--~~~~~~~~~~~~~~~~~~~~~~~~~
-- Floor, Round , Celling
--~~~~~~~~~~~~~~~~~~~~~~~~~
Declare @Value decimal (10,2)
Set @Value =11.05
Select Round(@value,0)
Select Ceiling (@value)
Select Floor (@value)

-- Date Format
Select Getdate()
Select DATEDIFF ( YY,cast('06/06/1993' as datetime),GETDATE()) as Years,
       DATEDIFF ( MM,cast('06/06/1993' as datetime),GETDATE()) %12 As Months,
	   DATEDIFF ( DD,cast('06/06/1993' as datetime),GETDATE()) %30 as Days

Go
