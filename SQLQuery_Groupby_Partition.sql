
Id  FirstName                   LastName                  Quantity
-------------------------------------------------------------------
1   arun                         prasanth                    40
2   ann                          antony                      45
3   sruthy                       abc                         41
6   new                          abc                         47
1   arun                         prasanth                    45
1   arun                         prasanth                    49
2   ann                          antony                      49





USE [EllensWorkDB]

CREATE TABLE EmployeeSales
     (ID int NOT NULL
	 ,FirstName VARCHAR(25) NOT NULL
	 ,LastName VARCHAR(25) NOT NULL
	 ,Quantity int NOT NULL
	 )

INSERT INTO EmployeeSales
       VALUES(1, 'arun', 'prasanth', 40),
	         (1, 'arun', 'prasanth', 45),
			 (1, 'arun', 'prasanth', 49),
			 (2, 'ann', 'antony', 45),
			 (2, 'ann', 'antony', 49),
			 (3, 'sruthy','abc', 41),
             (6, 'new',   'abc', 47);
	   

--SELECT * FROM EmployeeSales



SELECT FirstName, SUM(Quantity) AS TotalQuantity
FROM EmployeeSales
GROUP BY FirstName

SELECT FirstName, SUM(Quantity) OVER(PARTITION BY ID) AS TotalQuantity
FROM EmployeeSales


SELECT DISTINCT ID, FirstName, SUM(Quantity) OVER(PARTITION BY ID) AS TotalQuantity
FROM EmployeeSales
