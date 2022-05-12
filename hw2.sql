Use AdventureWorks2019
Go
--Joins: (AdventureWorks)
--1. Write a query that lists the country and province names from person.CountryRegion 
--and person. StateProvince tables. Join them and produce a result set similar to the following.
--    Country                        Province
SELECT pc.Name AS Country,pe.Name AS Province
FROM person.CountryRegion AS pc JOIN person. StateProvince AS pe ON pe.CountryRegionCode=pc.CountryRegionCode

--2. Write a query that lists the country and province names from person. CountryRegion 
--and person. StateProvince tables and list the countries filter them by Germany and Canada.
--Join them and produce a result set similar to the following.
--    Country                        Province

SELECT pc.Name AS Country,pe.Name AS Province
FROM (SELECT Name,CountryRegionCode FROM person. CountryRegion 
WHERE Name in ('Germany','Canada')) AS pc 
JOIN person. StateProvince AS pe ON pe.CountryRegionCode=pc.CountryRegionCode



-- Using Northwind Database: (Use aliases for all the Joins)
USE Northwind



--3. List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT od.ProductID
FROM (SELECT OrderDate,OrderID FROM orders 
WHERE OrderDate > DATEADD(year,-25, GETDATE()))  AS o
JOIN [Order Details] AS od ON o.OrderID=od.OrderID



--4. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 ShipPostalCode FROM orders AS o
JOIN [Order Details]  AS od ON o.OrderID =  od.OrderID
WHERE OrderDate > DATEADD(year,-25, GETDATE())
GROUP BY ShipPostalCode
ORDER BY SUM(od.Quantity)



--5. List all city names and number of customers in that city.     
SELECT City, COUNT(DISTINCT customerID) AS [Number of Customers]
FROM Customers
GROUP BY City



--6. List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(DISTINCT customerID) AS [Number of Customers]
FROM Customers
GROUP BY City
HAVING COUNT(DISTINCT customerID)>2



--7. Display the names of all customers  along with the  count of products they bought
SELECT CompanyName,[count of products] FROM customers
JOIN (SELECT CustomerID, SUM(Quantity) AS [count of products] FROM orders 
JOIN [order details] ON orders.OrderID=[order details].OrderID
GROUP BY  CustomerID) AS oc ON customers.CustomerID=oc.CustomerID




--8. Display the customer ids who bought more than 100 Products with count of products.
SELECT CustomerID FROM orders 
JOIN [order details] ON orders.OrderID=[order details].OrderID
GROUP BY  CustomerID
HAVING SUM(Quantity)>100




--9. List all of the possible ways that suppliers can ship their products. Display the results as below
          -- Supplier Company Name                Shipping Company Name
    ---------------------------------            ----------------------------------
SELECT sup.CompanyName, ship.CompanyName
FROM suppliers AS sup, shippers AS ship



--10. Display the products order each day. Show Order date and Product Name.
SELECT DISTINCT OrderDate,  ProductName FROM (orders 
JOIN [Order Details] ON orders.orderID = [Order Details].OrderID)
JOIN Products ON [Order Details].productID = Products.productID



--11. Displays pairs of employees who have the same job title.
SELECT e1.employeeID AS [Employee 1], e2.employeeID AS  [Employee 2]
FROM employees AS e1, employees AS e2
where e1.Title = e2.Title AND e1.employeeID > e2.employeeID



--12. Display all the Managers who have more than 2 employees reporting to them.
SELECT m.employeeID as [Manager ID]
FROM employees AS m
where (SELECT COUNT(employeeID) FROM employees WHERE m.employeeID=ReportsTo)>2



--13. Display the customers and suppliers by city. The results should have the following columns
--City
--Name
--Contact Name,
--Type (Customer or Supplier)

SELECT City, CompanyName, ContactName, 'Customer' AS Type
FROM customers
UNION
SELECT City, CompanyName, ContactName, 'Supplier' AS Type
FROM suppliers

--All scenarios are based on Database NORTHWIND.
Use Northwind
Go
--14. List all cities that have both Employees and Customers.
Select distinct city From dbo.Customers 
Where city in (Select city From dbo.Employees);

--15. List all cities that have Customers but no Employee.
--a.  Usesub-query
Select Distinct city From dbo.Customers 
Where city not in (Select city From dbo.Employees);

--b. Do not use sub-query
Select Distinct a.city 
From dbo.Customers a, dbo.Employees b Where a.City <> b.city;

--16. List all products and their total order quantities throughout all orders.
Select b.productname , Sum(a.quantity) "total order Quantities" 
From dbo.Products b Inner Join dbo.[Order Details] a
On a.ProductID = b.ProductID Group By b.productname

--17. List all Customer Cities that have at least two customers.
--a.  Use union
Select city From dbo.Customers Group By city Having count(customerid) = 2
Union
Select city From dbo.Customers Group By city Having count(customerid) > 2;

--b. Use sub-query and no union
Select city From dbo.Customers Where city in 
(Select city From dbo.Customers Group By city Having count(customerid) >= 2);

--18. List all Customer Cities that have ordered at least two different kinds of products.
Select d.city , count(Distinct b.ProductID) "total products" From dbo.Products b
Inner Join dbo.[Order Details] a
On a.ProductID = b.ProductID Inner Join dbo.Orders c On c.OrderID = a.OrderID
Inner Join dbo.Customers d on d.CustomerID = c.CustomerID Group By d.City
Having count(Distinct b.productid) >= 2
 


--19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
Select Top 5 b.productname, Avg(b.UnitPrice) "Average price", d.city From
dbo.Products b Inner Join dbo.[Order Details] a
On a.ProductID = b.ProductID Inner Join dbo.Orders c On c.OrderID = a.OrderID
Inner Join dbo.Customers d On d.CustomerID = c.CustomerID Group By
b.ProductName, d.city Order By Sum(a.quantity) Desc ;
 


--20. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is,
--and also the city of most total quantity of products ordered from. (tip: join  sub-query)
Select Distinct b.city From orders a Inner Join customers b On a.CustomerID =b.CustomerID 
Where b.city In (Select Top 1 d.city From dbo.Products b Inner Join dbo.[Order Details] a
On a.ProductID = b.ProductID Inner Join dbo.Orders c On c.OrderID = a.OrderID
Inner Join dbo.Customers d On d.CustomerID = c.CustomerID 
Group By d.City 
Order By Count(c.orderid) Desc)
And 
b.city In (Select Top 1 d.city From dbo.Products b Inner Join dbo.[Order Details] a
on a.ProductID = b.ProductID Inner Join dbo.Orders c On c.OrderID = a.OrderID
Inner Join dbo.Customers d On d.CustomerID = c.CustomerID 
Group By d.City 
Order By Count(a.ProductID) Desc);



--21. How do you remove the duplicates record of a table?

--method 1. Use Group By  groups the results by one or more columns then use delete statement to delete duplicate records.
--method 2. Distinct Statement which returns Non-Duplicate rows then you will have to create a new table with an exact definition like your previous table. Then insert all ‘Non-Duplicate’ rows from the previous table to the new table.
--method 3. Use CTE to with ‘PARTITION BY’ statement to delete duplicate records
          --Row_Number() function which provides consecutive numbering of the rows in the result by the order selected in the OVER clause. It will assign the value 1 for the first row and increase the number for the subsequent rows.
		  --ranking functions are applied to each record partition separately and the rank will restart from 1 for each record partition separately. 