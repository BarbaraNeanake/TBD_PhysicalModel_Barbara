-------------- NO 1
-- Pembuatan Database
CREATE DATABASE IF NOT EXISTS TugasTBDBar;
USE TugasTBDBar;

-- Tabel Supplier Daging
CREATE TABLE Supplier_Daging (
  SupplierID INT PRIMARY KEY,
  SupplierName VARCHAR(50),
  SupplierContact VARCHAR(15)
);

-- Tabel Restaurant
CREATE TABLE Restaurant (
  RestaurantID INT PRIMARY KEY,
  RestaurantName VARCHAR(50),
  RestaurantAddress VARCHAR(50),
  SupplierID INT,
  FOREIGN KEY (SupplierID) REFERENCES Supplier_Daging(SupplierID)
);

-- Tabel Employee
CREATE TABLE Employee (
  EmployeeID INT PRIMARY KEY,
  EmployeeName VARCHAR(50),
  EmployeePosition VARCHAR(50),
  EmployeeShift VARCHAR(50)
);

-- Tabel Menu
CREATE TABLE Menu (
  MenuID INT PRIMARY KEY,
  MenuName VARCHAR(50),
  MenuPrice INT
);

-- Tabel Tables
CREATE TABLE Tables (
  TableNumber INT PRIMARY KEY,
  Capacity INT,
  Availability VARCHAR(50)
);

-- Tabel Customer
CREATE TABLE Customer (
  OrderID INT PRIMARY KEY,
  OrderTime TIMESTAMP,
  OrderDetails VARCHAR(50),
  TableNumber INT,
  FOREIGN KEY (TableNumber) REFERENCES Tables(TableNumber)
);

-- Tabel Payment
CREATE TABLE Payment (
  PaymentID INT PRIMARY KEY,
  TotalAmount INT,
  PaymentMethod VARCHAR(10),
  PaymentTime TIMESTAMP,
  OrderID INT,
  FOREIGN KEY (OrderID) REFERENCES Customer(OrderID)
);

-- Tabel Supplier Daging
INSERT INTO Supplier_Daging (SupplierID, SupplierName, SupplierContact)
VALUES (1001, 'Savory Meats Co.', '123-456-789'),
       (1002, 'Delicious Cuts Ltd.', '987-654-321'),
       (1003, 'Prime Protein Providers', '555-555-555'),
       (1004, 'Gourmet Carnivore', '111-222-333'),
       (1005, 'Tender Tastes Butchery', '444-555-666');

-- Tabel Restaurant
INSERT INTO Restaurant (RestaurantID, RestaurantName, RestaurantAddress, SupplierID)
VALUES (2001, 'Flavors of Fire BBQ', '123 Heaven Grace Lane', 1001),
       (2002, 'Sizzling Spice Eatery', '456 Spicy Street', 1002),
       (2003, 'Tasty Temptations Grill', '789 Grillers Avenue', 1003),
       (2004, 'Smoke and Sizzle Resto by Simanjuntak', '321 Barbecue Boulevard', 1004),
       (2005, 'Barbara"s Delight', '555 Kaliurang RingRoad', 1005);

-- Tabel Employee
INSERT INTO Employee (EmployeeID, EmployeeName, EmployeePosition, EmployeeShift)
VALUES (3001, 'Neanake Pwetty', 'Waiter', 'Morning1'),
       (3002, 'Olana Razenna', 'Chef', 'Evening1'),
       (3003, 'Livia Ordovia', 'Manager', 'Morning1'),
       (3004, 'Nirmala Tatum', 'Server', 'Evening1'),
       (3005, 'Bobby Renatta', 'Bartender', 'Night2');

-- Tabel Menu
INSERT INTO Menu (MenuID, MenuName, MenuPrice)
VALUES (07, 'Spicey Grilled Chicken', 350000),
       (09, 'Sizzling Beef Ribs', 300000),
       (02, 'Smoked Pork Belly', 400000),
       (27, 'Grilled Seafood Platter', 450000),
       (19, 'Vegetarian Delight Bowl', 250000);

-- Tabel Tables
INSERT INTO Tables (TableNumber, Capacity, Availability)
VALUES (2, 4, 'Available'),
       (5, 6, 'Booked'),
       (7, 8, 'Available'),
       (1, 10, 'Booked'),
       (11, 12, 'Available');

-- Tabel Customer
INSERT INTO Customer (OrderID, OrderDetails, OrderTime, TableNumber)
VALUES (132, 'Spicey Grilled Chicken, Iced Tea', CURRENT_TIMESTAMP, 2),
       (268, 'Sizzling Beef Ribs, Lemonade', CURRENT_TIMESTAMP, 5),
       (197, 'Smoked Pork Belly, Coke', CURRENT_TIMESTAMP, 7),
       (91, 'Grilled Seafood Platter, Sparkling Water', CURRENT_TIMESTAMP, 1),
       (214, 'Vegetarian Delight Bowl, Green Tea', CURRENT_TIMESTAMP, 11);

-- Tabel Payment
INSERT INTO Payment (PaymentID, TotalAmount, PaymentMethod, PaymentTime, OrderID)
VALUES (7001, 40000, 'Cash', CURRENT_TIMESTAMP, 132),
       (7002, 50000, 'Credit Card', CURRENT_TIMESTAMP, 268),
       (7003, 60000, 'Debit Card', CURRENT_TIMESTAMP, 197),
       (7004, 35000, 'Cash', CURRENT_TIMESTAMP, 91),
       (7005, 25000, 'Credit Card', CURRENT_TIMESTAMP, 214);

-------------- NO 2
-- Query dengan Pengondisian 
SELECT *
FROM Customer
WHERE OrderID = 91;

-- Query dengan Pengelompokkan
SELECT OrderID, COUNT(OrderID) AS TotalOrders
FROM Customer
GROUP BY OrderID
LIMIT 25;

-- Query dengan Pengondisian Pengelompokkan
SELECT Customer.OrderID, COUNT(Customer.OrderID) AS TotalSuccessOrders
FROM Customer
JOIN Payment ON Customer.OrderID = Payment.OrderID
WHERE Payment.PaymentMethod IN ('Cash', 'Credit Card', 'Debit Card') 
GROUP BY Customer.OrderID
LIMIT 0, 25;

-- Query dengan Pengurutan
SELECT *
FROM Customer
ORDER BY OrderID DESC;

-- Query dengan Aggregat Function
SELECT Customer.OrderID, SUM(Menu.MenuPrice) AS TotalPrice
FROM Customer
JOIN Menu ON Customer.OrderDetails = Menu.MenuName
WHERE Customer.OrderID = 132
GROUP BY Customer.OrderID
LIMIT 0, 25;

-------------- NO 3 
-- 1
SELECT *
FROM Customer
WHERE OrderID IN (
    SELECT OrderID
    FROM Payment
    GROUP BY OrderID
    HAVING SUM(TotalAmount) > (
        SELECT AVG(TotalAmount)
        FROM Payment
    )
);

-- 2
SELECT MenuName, (
    SELECT COUNT(*) 
    FROM Customer 
    WHERE OrderDetails LIKE CONCAT('%', Menu.MenuName, '%')
) AS TotalOrders
FROM Menu
ORDER BY TotalOrders DESC
LIMIT 25;


-- 3 
SELECT EmployeeName
FROM Employee
WHERE EmployeeID IN (
    SELECT DISTINCT EmployeeID
    FROM Restaurant
    WHERE RestaurantID = (
        SELECT RestaurantID
        FROM Tables
        WHERE Capacity = (
            SELECT MAX(Capacity)
            FROM Tables
        )
    )
) LIMIT 0, 25;

-- 4
SELECT *
FROM Menu
WHERE MenuID NOT IN (
    SELECT DISTINCT OrderDetails
    FROM Customer
);


-- 5
SELECT *
FROM Menu
WHERE MenuID NOT IN (
    SELECT DISTINCT OrderDetails
    FROM Customer
);

-------------- NO 4 
-- 1
SELECT Customer.OrderID, Customer.OrderDetails, Menu.MenuID, Menu.MenuName
FROM Customer
JOIN Menu ON Customer.OrderDetails LIKE CONCAT('%', Menu.MenuName, '%')
LIMIT 25;

-- 2
SELECT Customer.OrderID, Customer.OrderDetails, Payment.PaymentID, Payment.TotalAmount
FROM Customer
JOIN Payment ON Customer.OrderID = Payment.OrderID
LIMIT 25;

-- 3
SELECT Customer.OrderID, Customer.OrderDetails, Tables.TableNumber, Tables.Capacity
FROM Customer
JOIN Tables ON Customer.TableNumber = Tables.TableNumber
LIMIT 25;

-- 4
SELECT Menu.MenuID, Menu.MenuName, Tables.TableNumber, Tables.Capacity
FROM Menu
JOIN Tables ON Menu.MenuID = Tables.TableNumber
LIMIT 0, 25;

-- 5
SELECT Menu.MenuID, Menu.MenuName
FROM Menu
LEFT JOIN Customer ON Menu.MenuID = Customer.OrderDetails
WHERE Customer.OrderDetails IS NULL
LIMIT 25;


