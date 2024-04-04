-- Active: 1711842980835@@127.0.0.1@3306@orders
Create DATABASE Amazon_Order_reviews

Use Amazon_Order_reviews

CREATE TABLE `Person` (
    `id` VARCHAR(255) NOT NULL PRIMARY KEY, `name` VARCHAR(100) NOT NULL
);

CREATE TABLE `Customer` (
    `customer_id` VARCHAR(255) NOT NULL PRIMARY KEY, `person_id` VARCHAR(255) NOT NULL, FOREIGN KEY (`person_id`) REFERENCES `Person` (`id`)
);

CREATE TABLE `Reviewers` (
    `reviewers_id` VARCHAR(255) PRIMARY KEY, `person_id` VARCHAR(255) NOT NULL, `review_title` VARCHAR(255), `review_content` VARCHAR(255), FOREIGN KEY (`person_id`) REFERENCES `Person` (`id`)
);

CREATE TABLE `Item` (
    `item_id` VARCHAR(255) NOT NULL PRIMARY KEY, `item_name` VARCHAR(255) NOT NULL, `item_quantity` BIGINT NOT NULL
);

CREATE TABLE `Order` (
    `order_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, `date` DATE NOT NULL, `customer_id` VARCHAR(255) NOT NULL, `price` DECIMAL(10, 2) NOT NULL, FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`customer_id`)
);

CREATE TABLE `review_item` (
    `review_item_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, `item_id` VARCHAR(255) NOT NULL, `unit_price` DECIMAL(10, 2) NOT NULL, `reviewer_id` VARCHAR(255) NOT NULL, FOREIGN KEY (`reviewer_id`) REFERENCES `Reviewers` (`reviewers_id`), FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`)
);

CREATE TABLE `Log_order` (
    `log_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, `customer_id` VARCHAR(255) NOT NULL, `total_orders_placed` INT NOT NULL DEFAULT 0, FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`customer_id`)
);

CREATE TABLE IF NOT EXISTS `Log_Review` (
    `log_review_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, `item_id` VARCHAR(255) NOT NULL, `num_reviews` INT NOT NULL DEFAULT 0, FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`)
);

-- Ensuring item_quantity is non-negative
ALTER TABLE Item
ADD CONSTRAINT chk_item_quantity_non_negative CHECK (item_quantity >= 0);

-- Ensuring price is positive
ALTER TABLE `Order`
ADD CONSTRAINT chk_order_price_positive CHECK (price > 0);

-- Ensuring review_title is not empty
ALTER TABLE Reviewers
ADD CONSTRAINT chk_review_title_not_empty CHECK (CHAR_LENGTH(review_title) > 0);

-- Ensuring review_content is not empty
ALTER TABLE Reviewers
ADD CONSTRAINT chk_review_content_not_empty CHECK (
    CHAR_LENGTH(review_content) > 0
);

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