-- simple where clause query
SELECT * FROM `order` WHERE price > 100.00;

-- This query will group orders by their customer_id to count the number of orders each customer has placed.
SELECT customer_id, COUNT(order_id) AS total_orders
FROM `order`
GROUP BY
    customer_id;

-- This query will use the HAVING clause to filter the groups based on a condition. It will group orders by customer_id, but only include those customers who have placed more than 5 orders.
SELECT customer_id, COUNT(order_id) AS total_orders
FROM `order`
GROUP BY
    customer_id
HAVING
    COUNT(order_id) > 5;

-- Join using where clause
SELECT *
FROM customer, `order`
WHERE
    customer.customer_id = `order`.customer_id;

-- Join using on clause

SELECT *
FROM customer
    JOIN `order` ON customer.customer_id = `order`.customer_id;

-- inner join
SELECT customer.customer_id, customer.person_id, `order`.order_id, `order`.date, `order`.price
FROM customer
    INNER JOIN `order` ON customer.customer_id = `order`.customer_id;

-- left outer join
SELECT customer.customer_id, customer.person_id, `order`.order_id, `order`.date, `order`.price
FROM customer
    LEFT OUTER JOIN `order` ON customer.customer_id = `order`.customer_id;

-- right outer join
SELECT customer.customer_id, customer.person_id, `order`.order_id, `order`.date, `order`.price
FROM customer
    RIGHT OUTER JOIN `order` ON customer.customer_id = `order`.customer_id;
-- * Important to note that since we are using MySQL, Full Outer Join is not supported.*
-- This query finds customers who have placed orders with a price above the average price of all orders.
SELECT c.customer_id, c.person_id, o.order_id, o.price
FROM customer c
    JOIN `order` o ON c.customer_id = o.customer_id
WHERE
    o.price > (
        SELECT AVG(price)
        FROM `order`
        WHERE
            customer_id = c.customer_id
    );

-- This query finds reviewers who have written more reviews for items than the average number of reviews for those items.
SELECT r.reviewers_id, r.person_id, ri.item_id, COUNT(ri.review_item_id) AS reviews_count
FROM reviewers r
    JOIN review_item ri ON r.reviewers_id = ri.review_item_id
GROUP BY
    r.reviewers_id,
    ri.item_id
HAVING
    COUNT(ri.review_item_id) > (
        SELECT AVG(sub.num_reviews)
        FROM (
                SELECT COUNT(ri_inner.review_item_id) as num_reviews
                FROM review_item ri_inner
                WHERE
                    ri_inner.item_id = ri.item_id
                GROUP BY
                    ri_inner.item_id
            ) sub
    );

-- Equivalent of intersect using inner join
SELECT DISTINCT
    ri.item_id
FROM review_item ri
    INNER JOIN `order` o ON ri.review_item_id = o.order_id;

-- example of union
SELECT customer_id
FROM customer
UNION
SELECT reviewers_id
FROM reviewers;

-- equivalent of except using left join and where null
SELECT c.customer_id
FROM customer c
    LEFT JOIN `order` o ON c.customer_id = o.customer_id
WHERE
    o.order_id IS NULL;

-- Example of view with hard coded criteria
CREATE VIEW `Detailed_Reviewers_View` AS
SELECT r.reviewers_id, p.name, r.review_title, LENGTH(r.review_content) AS content_length
FROM `Reviewers` r
    JOIN `Person` p ON r.person_id = p.id
WHERE
    LENGTH(r.review_content) > 100;

-- Not in nested Query
SELECT DISTINCT
    r.reviewers_id
FROM Reviewers r
WHERE
    r.reviewers_id NOT IN(
        SELECT ri.reviewer_id
        FROM review_item ri
        WHERE
            ri.item_id NOT IN(
                SELECT i.item_id
                FROM Item i
            )
    );

-- Not exists nested Query

SELECT DISTINCT
    r.reviewers_id
FROM Reviewers r
WHERE
    NOT EXISTS (
        SELECT *
        FROM Item i
        WHERE
            NOT EXISTS (
                SELECT *
                FROM review_item ri
                WHERE
                    ri.item_id = i.item_id
                    AND ri.reviewer_id = r.reviewers_id
            )
    );