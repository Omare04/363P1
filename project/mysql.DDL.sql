CREATE TABLE `Person` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `date_of_birth` DATE NOT NULL
);


CREATE TABLE `Customer` (
    `customer_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `person_id` BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (`person_id`) REFERENCES `Person`(`id`)
);

CREATE TABLE `Company` (
    `company_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `company_name` VARCHAR(255) NOT NULL
);

CREATE TABLE `Admin` (
    `admin_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `person_id` BIGINT UNSIGNED NOT NULL,
    `company_id` BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (`person_id`) REFERENCES `Person` (`id`),
    FOREIGN KEY (`company_id`) REFERENCES `Company` (`company_id`)
);

CREATE TABLE `Item` (
    `item_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_name` VARCHAR(255) NOT NULL,
    `item_quantity` BIGINT NOT NULL
);

CREATE TABLE `Order` (
    `order_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `date` DATE NOT NULL,
    `customer_id` BIGINT UNSIGNED NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`customer_id`)
);


CREATE TABLE `Log` (
    `record_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `item_id` BIGINT UNSIGNED NOT NULL,
    `action` VARCHAR(100) NOT NULL,
    FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`)
);

CREATE TABLE `Order_item` (
    `order_item_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_id` BIGINT UNSIGNED NOT NULL,
    `unit_price` DECIMAL(10, 2) NOT NULL,
    `order_id` BIGINT NOT NULL,
    FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`)
);



