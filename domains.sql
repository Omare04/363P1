-- Ensuring item_quantity is non-negative
ALTER TABLE Item
ADD CONSTRAINT chk_item_quantity_non_negative CHECK (item_quantity >= 0);

-- Ensuring price is positive
ALTER TABLE `Order`
ADD CONSTRAINT chk_order_price_positive CHECK (price > 0);