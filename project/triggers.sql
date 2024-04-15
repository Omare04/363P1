-- Trigger to prevent insertion of items without a corresponding order
CREATE TRIGGER check_order_existence
BEFORE INSERT ON Order_item
FOR EACH ROW
BEGIN
    DECLARE order_count INT;

    SELECT COUNT(*) INTO order_count
    FROM Order
    WHERE order_id = NEW.order_id;

    IF order_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert item without a corresponding order';
    END IF;
END;


-- Trigger to delete associated items when an order is deleted
CREATE TRIGGER delete_order_items
AFTER DELETE ON `Order`
FOR EACH ROW
BEGIN
    DELETE FROM `Order_item` WHERE order_id = OLD.order_id;
END;


-- Updates the orders total when an order item has been inserted or deleted
CREATE TRIGGER update_order_total
AFTER INSERT, UPDATE ON `Order_item`
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(`Order_item`.`unit_price`) INTO total
    FROM order_items
    WHERE order_id = NEW.order_id;
    
    UPDATE `Order`
    SET total_price = total
    WHERE order_id = NEW.order_id;
END;


-- Trigger tp log UPDATE, DELETE, And INSERT changes on the Order Table 
-- Fix Errors
CREATE TRIGGER log_order_modifications
AFTER INSERT, UPDATE, DELETE ON `Order`
FOR EACH ROW
BEGIN
    DECLARE action_message VARCHAR(100);

    IF (INSERTING) THEN
        SET action_message = 'Inserted';
    ELSEIF (UPDATING) THEN
        SET action_message = 'Updated';
    ELSEIF (DELETING) THEN
        SET action_message = 'Deleted';
    END IF;

    INSERT INTO `Log` (`date`, `item_id`, `action`)
    VALUES (CURRENT_TIMESTAMP, NEW.order_id, action_message);
END;