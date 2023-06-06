
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--Default Location Database With Custom Properties--
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

USE master
DROP DATABASE IF EXISTS E_CommerceDB
GO

USE master
GO

DECLARE @data_path NVARCHAR(256);
SET @data_path = (SELECT SUBSTRING(physical_name,1,CHARINDEX(N'master.mdf', LOWER (physical_name))-1)
	FROM master.sys.master_files
	WHERE database_id=1 AND file_id=1);

EXEC ('CREATE DATABASE E_CommerceDB
	ON PRIMARY (Name= E_CommerceDB_data,Filename='''+@data_path+'E_CommerceDB_data.mdf'',Size=25mb,Maxsize=100mb,Filegrowth=5%)
	LOG ON (Name= E_CommerceDB_log,Filename='''+@data_path+'E_CommerceDB_log.ldf'',Size=10mb,Maxsize=50mb,Filegrowth=1%)');
GO

------~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------SCHEMA CREATE-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

USE E_CommerceDB
GO
CREATE SCHEMA ec
GO
----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Table Create-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

USE E_CommerceDB
CREATE TABLE ec.Supplier
	(
	SupplierID INT PRIMARY KEY IDENTITY,
	SupplierName VARCHAR(25) SPARSE NULL,
	Phone CHAR(11) NOT NULL CHECK ((Phone Like '018%' or Phone Like '017%' or Phone Like '019%' or Phone Like '016%' or Phone Like '015%'or Phone Like '013%')),
	Address VARCHAR(50),
	Email VARCHAR(20) CHECK (Email Like '%@gmail.com' or Email Like '%@outlook.com' or Email Like '%@yahoo.com')
	);
GO


USE E_CommerceDB
CREATE TABLE ec.Product
	(
	ProductID INT PRIMARY KEY IDENTITY,
	ProductName VARCHAR(15) NOT NULL,
	Color VARCHAR(10) SPARSE NULL
	);
GO


USE E_CommerceDB
CREATE TABLE ec.Catagory
	(
	CatagoryID INT PRIMARY KEY IDENTITY,
	CatagoryName VARCHAR(15) Not Null
	);
GO


USE E_CommerceDB
CREATE TABLE ec.ProductInfo
	(
	PurInfoID INT PRIMARY KEY IDENTITY,
	SupplierID INT FOREIGN KEY REFERENCES ec.Supplier(SupplierID), 
	CatagoryID INT FOREIGN KEY REFERENCES ec.Catagory(CatagoryID),
	ProductID INT FOREIGN KEY REFERENCES ec.Product(ProductID),
	Quantity INT,
	UnitPrice MONEY,
	);
GO


USE E_CommerceDB
CREATE TABLE ec.Stock
	(
	StockID INT Not Null,
	ProdCode INT PRIMARY KEY IDENTITY,
	StockName VARCHAR(15) Not Null,
	PurInfoID INT FOREIGN KEY REFERENCES ec.ProductInfo(PurInfoID),
	AvailQuantity INT,
	);
GO


USE E_CommerceDB
CREATE TABLE ec.Customer
	(
	CustomerID INT PRIMARY KEY IDENTITY,
	CustomerName VARCHAR(20) Not Null,
	Phone CHAR(11) Not Null CHECK ((Phone Like '018%' or Phone Like '017%' or Phone Like '019%' or Phone Like '016%' or Phone Like '015%'or Phone Like '013%')),
	Address VARCHAR(50) NOT NULL,
	Email VARCHAR(20) CHECK (Email Like '%@gmail.com' or Email Like '%@outlook.com' or Email Like '%@yahoo.com')
	);
Go


USE E_CommerceDB
CREATE TABLE ec.Orders
	(
	OrdersID INT PRIMARY KEY IDENTITY,
	OrderDate DATE,
	CustomerID INT FOREIGN KEY REFERENCES ec.Customer(CustomerID) ON DELETE CASCADE,
	);
Go



USE E_CommerceDB
CREATE TABLE ec.OrderDetails
	(
	OrderDetID INT PRIMARY KEY IDENTITY,
	OrdersID INT FOREIGN KEY REFERENCES ec.Orders(OrdersID),
	ProdCode INT FOREIGN KEY REFERENCES ec.Stock(ProdCode),
	Quantity INT,
	UnitPrice MONEY,
	Discount  AS (Quantity*UnitPrice*0.05),
	Total AS (Quantity*UnitPrice +(Quantity*UnitPrice*0.05)),
	PurchaseDate DATETIME
	);
Go


USE E_CommerceDB
CREATE TABLE ec.Payment
	(
	PaymentID INT IDENTITY,
	ProductType VARCHAR(15) Not Null,
	OrderDetID INT FOREIGN KEY REFERENCES ec.OrderDetails(OrderDetID)
	);
GO
----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Select Quary-----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
--------Alter Table -----------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ALTER TABLE ec.Supplier
ADD CompanyName VARCHAR(20)
GO

ALTER TABLE ec.Supplier
DROP COLUMN CompanyName
GO

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Temporary Table---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE TABLE #Sales
	 (
	 SalesID INT,
	 SalesDate DATE NOT NULL CONSTRAINT cn_date DEFAULT (Getdate())
	 );
GO


----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Global Table---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE TABLE ##Employee
	 (
	 EmployeeID INT PRIMARY KEY IDENTITY,
	 EmployeeName VARCHAR(20),
	 Address VARCHAR(50),
	 Email VARCHAR(20),
	 Salary MONEY
	 );
GO


DROP TABLE #Sales
GO


DROP TABLE ##Employee
GO
----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Tabular and Scalar Function---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE FUNCTION dbo.Fn_Tabular(@color VARCHAR(20))
RETURNS TABLE
AS
RETURN
	(
	SELECT Product.ProductID,ProductName,Color,ec.ProductInfo.CatagoryID,Quantity,UnitPrice
	FROM ec.Product JOIN ec.ProductInfo
	ON ec.Product.ProductID=ec.ProductInfo.ProductID
	WHERE Color=@color
	)
GO
SELECT * FROM dbo.Fn_Tabular('White')
GO
SELECT * FROM ec.Product
GO


CREATE FUNCTION dbo.fn_Scalar(@orderDetails int)
RETURNS INT
AS
BEGIN
	RETURN
	(SELECT sum(Discount) FROM ec.OrderDetails)
END
GO

PRINT dbo.fn_Scalar(10)
GO


---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Create Clustered and NonClustered Index---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


CREATE CLUSTERED INDEX cs_orderdet on ec.Payment(PaymentID)
GO

CREATE NONCLUSTERED INDEX ncs_payment on ec.Payment(producttype)
GO


---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Store Procedures r---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE PROC sp_Product
@supplierid INT,
@suppliername VARCHAR(20),
@phone CHAR(20),
@address VARCHAR(100),
@email VARCHAR(20),
@productid INT,
@productname VARCHAR(20),
@color VARCHAR(15),
@tablename VARCHAR(20),
@operationname VARCHAR(20)
AS
Begin
	if(@tablename= 'Supplier' and @operationname= 'Insert')
	Begin
		Insert into ec.Supplier values (@suppliername,@phone,@address,@email)
	End
		if(@tablename= 'Supplier' and @operationname='Update')
	Begin
		Update ec.Supplier set SupplierName=@suppliername where SupplierID=@supplierid
	End
		if(@tablename='Supplier'and @operationname='Delete')
	Begin
		Delete From ec.Supplier where SupplierID=@supplierid
	End

		if(@tablename='Product'and @operationname='Insert')
	Begin
		Insert into ec.Product values (@productname,@color)
	End
		if(@tablename='Product'and @operationname='Update')
	Begin
		Update ec.Product set ProductName=@productname where ProductID=@productid
	End
		if(@tablename='Product'and @operationname='Delete')
	Begin
		Delete From ec.Product where ProductID=@productid
	End

End
Go



---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Store Procedures For Try, Begin Tran, Commit, Catch, Rollback Tran, Print---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE PROC sp_PurchaseInfo
@purInfoid INT ,
@supplierid INT, 
@catagoryid INT,
@productid INT,
@quantity INT,
@unitpricepur Money,
@message VARCHAR(30) OUTPUT
AS
	Begin
		Begin Try
			Begin Tran
				Insert ec.ProductInfo(PurInfoID,SupplierID,CatagoryID,ProductID,Quantity,UnitPrice)
				Values(@purInfoid,@supplierid,@catagoryid,@productid,@quantity,@unitpricepur)
				Set @message='Acttion Completed'
				Print @message
			Commit Tran
		End Try
			Begin Catch
				Rollback Tran
				Print 'Unsucsessful'
			End Catch
	End
GO


Declare @ar VARCHAR(30)
exec sp_PurchaseInfo 8,8,8,8,100,200,@ar output
GO


---~~~~~~~~~~~~~~~~~~~~~
--------TRIGGER---------
--~~~~~~~~~~~~~~~~~~~~~~

CREATE TABLE ProductAudit
	(
	ProductID int,
	ProductName VARCHAR(20),
	Color VARCHAR(20),
	Audit_Action VARCHAR(80),
	Audit_Time VARCHAR
	);
GO

CREATE TRIGGER Tr_AfterInsert ON ec.Product
FOR INSERT
AS
DECLARE @productid int, @productname varchar(20),@color varchar(20),@audit_action varchar(100);
SELECT @productid=i.ProductID From inserted i;
SELECT @productname=i.ProductName From inserted i; 
SELECT @color=i.Color From inserted i;
SET @audit_action='Inserted';
INSERT INTO ProductAudit(ProductID,ProductName,Color,Audit_Action,Audit_Time)
VALUES (@productid, @productname,@color,@audit_action,Getdate());
Print 'After insert Trigger Fired'
GO


---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Update & Delete Trigger---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


UPDATE ec.Product
SET ProductName='Rahim'
WHERE ProductID=2
GO

DELETE ec.Product
WHERE ProductID=2
GO


---~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Schemabinding---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create View vw_Stock
With Schemabinding
AS
SELECT Stock.StockName,AvailQuantity
FROM ec.Stock JOIN ec.ProductInfo
ON Stock.PurInfoID=ec.ProductInfo.PurInfoID
GO

---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------Create View with Encryption---------
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE VIEW vw_PurchaseInfo
WITH ENCRYPTION
AS
SELECT PurInfoID,SupplierID,ProductID,UnitPrice
FROM ec.ProductInfo
GO
