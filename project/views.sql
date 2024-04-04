-- View to Retrieve Order Details including Customer and Item Information:
CREATE VIEW Order_Details AS
SELECT o.order_id, o.date, c.customer_id, c.person_id, p.name AS customer_name,
       oi.item_id, i.item_name, oi.unit_price, oi.order_id AS order_item_order_id
FROM `Order` o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Person p ON c.person_id = p.id
JOIN Order_item oi ON o.order_id = oi.order_id
JOIN Item i ON oi.item_id = i.item_id;

-- View to Show Total Order Amounts by Customer:
CREATE VIEW Customer_Order_Total AS
SELECT c.customer_id, p.name AS customer_name, SUM(o.price) AS total_order_amount
FROM `Order` o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Person p ON c.person_id = p.id
GROUP BY c.customer_id, p.name;

-- View to List Items with Quantity Below 10:
CREATE VIEW Low_Quantity_Items AS
SELECT item_id, item_name, item_quantity
FROM Item
WHERE item_quantity < 10;

