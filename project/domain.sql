-- Since MySQL doesn't support domains directly, you achieve similar functionality using ENUM for string-based domains and CHECK constraints for numeric ranges:

ALTER TABLE `Order`
    ADD COLUMN status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending';

ALTER TABLE Item
    ADD CONSTRAINT ck_positive_quantity CHECK (item_quantity > 0);

-- The status column in the Order table ensures that every order has a clearly defined status within a controlled set of values. The ck_positive_quantity constraint in the Item table ensures that items cannot have a quantity of zero or less, which could represent invalid or nonsensical data within the context of inventory management.