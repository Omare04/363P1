-- trigger to update review log table
CREATE TRIGGER update_log_review AFTER INSERT ON review_item 
FOR EACH ROW 
BEGIN 
	-- Increment the number of reviews for the item in Log_Review table
	UPDATE Log_Review
	SET
	    num_reviews = num_reviews + 1
	WHERE
	    item_id = NEW.item_id;
END; 

-- trigger to update order log table
CREATE TRIGGER update_log_order AFTER INSERT ON `Order` 
FOR EACH ROW 
BEGIN 
	-- Increment the total_orders_placed for the customer_id in Log_Order table
	UPDATE Log_Order
	SET
	    total_orders_placed = total_orders_placed + 1
	WHERE
	    customer_id = NEW.customer_id;
END; 

-- trigger to delete item review log if item is delet from Item table
CREATE TRIGGER remove_log_review AFTER DELETE ON Item 
FOR EACH ROW 
BEGIN 
	-- Delete the log entry for the deleted item from Log_Review table
	DELETE FROM Log_Review WHERE item_id = OLD.item_id;
END; 

-- trigger to delete customer order log when customer info  is deleted
CREATE TRIGGER remove_log_order AFTER DELETE ON Customer 
FOR EACH ROW 
BEGIN 
	-- Delete the log entry for the deleted customer from Log_Order table
	DELETE FROM Log_Order WHERE customer_id = OLD.customer_id;
END; 