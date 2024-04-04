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