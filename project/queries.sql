-- 1. Basic select with simple where clause
SELECT * FROM `Order_item` WHERE `reordered` = 1;

-- 2. Basic select with simple group by clause (with and without having clause).
SELECT `user_id`, COUNT(*) AS `order_count`
FROM `Order`
GROUP BY `user_id`;

SELECT `user_id`, COUNT(*) AS `order_count`
FROM `Order`
GROUP BY `user_id`
HAVING COUNT(*) > 5;

-- 3. A simple join select query using cartesian product and where clause vs. a join query using on.
SELECT D.`department`, I.`item_name`
FROM `Department` D, `Item` I
WHERE D.`department_id` = I.`department_id`;

SELECT D.`department`, I.`item_name`
FROM `Department` D
INNER JOIN `Item` I ON D.`department_id` = I.`department_id`;

--4. inner join , find all persons who are also admin
SELECT P.`name`, A.`admin_id`
FROM `Person` P
INNER JOIN `Admin` A ON P.`id` = A.`person_id`;

--left-join, find all persons who are customers, and those are not customers display NULL for customer_id
SELECT P.`name`, C.`customer_id`
FROM `Person` P
LEFT JOIN `Customer` C ON P.`id` = C.`person_id`;

--right join, find all customers who made orders, and those who did not display NULL for order_id
SELECT C.`customer_id`, O.`order_id`
FROM `Customer` C
LEFT JOIN `Order` O ON C.`customer_id` = O.`customer_id`
WHERE O.`order_id` IS NULL;

--full outer join, combines all records from both the Person and Customer tables, showing names and customer ids with NULL values for any non-matching records between the two tables.
SELECT P.`name`, C.`customer_id`
FROM `Person` P
LEFT JOIN `Customer` C ON P.`id` = C.`person_id`
UNION
SELECT P.`name`, C.`customer_id`
FROM `Person` P
RIGHT JOIN `Customer` C ON P.`id` = C.`person_id`;

-- 5. Correlated sub-query. We're looking to select all the order_id values from the Order_Item where the maximum add_to_cart_order for each order_id does not exceed the overall average maximum add_to_cart_order across all order_id values
SELECT `order_id`
FROM `Order_Item` AS OI1
GROUP BY `order_id`
HAVING MAX(OI1.`add_to_cart_order`) <= (
    SELECT AVG(max_add_to_cart)
    FROM (
        SELECT MAX(`add_to_cart_order`) as max_add_to_cart
        FROM `Order_item`
        GROUP BY `order_id`
    ) AS SubQuery
);

-- Correlated sub-query #2. We're looking to select all user ids from the Order table where the maximum order_number for the particular user is equal to the average of the maximum order_number for all users.
SELECT `user_id`
FROM `Order` AS O1
GROUP BY `user_id`
HAVING MAX(O1.`order_number`) = (
    SELECT AVG(MAX(`order_number`)) 
    FROM `Order` 
    GROUP BY `user_id`
);

--6. UNION Combine aisle_ids from Item Starting with "A" and "B"
SELECT `aisle_id` FROM `Item` WHERE `item_name` LIKE 'A%'
UNION
SELECT `aisle_id` FROM `Item` WHERE `item_name` LIKE 'B%';

--UNION equivalent
SELECT DISTINCT `aisle_id`
FROM `Item`
WHERE `item_name` LIKE 'A%' OR `item_name` LIKE 'B%';

--INTERSECT Retrieve all order_ids that have these product_ids under the order
SELECT `order_id` FROM `Order_item` WHERE `product_id` = 33120
INTERSECT
SELECT `order_id` FROM `Order_item` WHERE `product_id` = 28985;

--INTERSECT equivalent
SELECT DISTINCT a.`order_id`
FROM `Order_item` a
INNER JOIN `Order_item` b ON a.`order_id` = b.`order_id`
WHERE a.`product_id` = 33120 AND b.`product_id` = 28985;

--EXCEPT Retrieve all order_ids that contain only products that have been reordered
SELECT order_id FROM Order_item WHERE reordered = 1
EXCEPT
SELECT order_id FROM Order_item WHERE reordered = 0;

--EXCEPT equivalent
SELECT order_id
FROM Order_item
GROUP BY order_id
HAVING SUM(CASE WHEN reordered = 0 THEN 1 ELSE 0 END) = 0 -- the sum of instances where reordered is 0 is exactly 0 
AND SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) > 0;  --at least one instance where reordered is 1

-- 7. View with hard-coded criteria
CREATE VIEW `db_order_items_for_product_33120` AS
SELECT * FROM `Order_Item`
WHERE `product_id` = 33120;
--If product_id is modified or deleted, then the corresponding row will be effected as well.

--8. *********MUST DO***********

-- 9. Demonstrating overlap for isa relationship.
SELECT P.`id`, P.`name`, A.`admin_id`, C.`customer_id`
FROM `Person` P
JOIN `Admin` A ON P.`id` = A.`person_id`
JOIN `Customer` C ON P.`id` = C.`person_id`;
--This query selects all persons who are both admins and customers. If it returns rows, it shows that the database allows for a Person to hold both roles, thus demonstrating the overlap constraint.

-- also demonstrating coverage for isa relationship
SELECT A.`admin_id`
FROM `Admin` A
WHERE NOT EXISTS (SELECT 1 FROM `Person` P WHERE P.`id` = A.`person_id`);
SELECT C.`customer_id`
FROM `Customer` C
WHERE NOT EXISTS (SELECT 1 FROM `Person` P WHERE P.`id` = C.`person_id`);
--both should return empty set since convering constraint is enforced (a person must either be a customer or an admin)

