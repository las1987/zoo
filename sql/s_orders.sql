ALTER TABLE `s_orders` ADD COLUMN `pickuppoint_id` int(20) DEFAULT NULL AFTER UPDATE_TYPE;
ALTER TABLE `s_orders` ADD COLUMN `pickup_summ` decimal(6,2) DEFAULT NULL AFTER pickuppoint_id;
