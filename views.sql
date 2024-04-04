-- This view would provide a convenient way to query all orders along with customer names.
CREATE VIEW Customer_Orders_View AS
SELECT o.order_id, o.date, o.price, c.customer_id, p.name
FROM
    `Order` o
    JOIN Customer c ON o.customer_id = c.customer_id
    JOIN Person p ON c.person_id = p.id;

-- This view might aggregate item details with review information.

CREATE VIEW Item_Reviews_View AS
SELECT i.item_id, i.item_name, r.review_title, r.review_content
FROM
    Item i
    JOIN review_item ri ON i.item_id = ri.item_id
    JOIN Reviewers r ON ri.reviewer_id = r.reviewers_id;

-- View to List Items with Quantity Below 10:
CREATE VIEW Low_Quantity_Items AS
SELECT
    item_id,
    item_name,
    item_quantity
FROM Item
WHERE
    item_quantity < 10;