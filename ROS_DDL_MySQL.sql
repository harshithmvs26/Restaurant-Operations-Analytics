-- ROS — Restaurant Operations System
-- DDL Script (MySQL)
-- Creates all 15 tables in dependency order with PK and FK constraints.
-- Compatible with MySQL.

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `Banking`;
DROP TABLE IF EXISTS `Cash_Up`;
DROP TABLE IF EXISTS `Deliveries`;
DROP TABLE IF EXISTS `Expenses`;
DROP TABLE IF EXISTS `Sales`;
DROP TABLE IF EXISTS `Orders`;
DROP TABLE IF EXISTS `Users`;
DROP TABLE IF EXISTS `Restaurants`;
DROP TABLE IF EXISTS `Clients`;
DROP TABLE IF EXISTS `Subscriptions`;
DROP TABLE IF EXISTS `Roles`;
DROP TABLE IF EXISTS `Departments`;
DROP TABLE IF EXISTS `TaxInfo`;
DROP TABLE IF EXISTS `Currencies`;
DROP TABLE IF EXISTS `Countries`;

SET FOREIGN_KEY_CHECKS = 1;

-- Countries
CREATE TABLE `Countries` (
  `lang` VARCHAR(255) NOT NULL,
  `lan_name` VARCHAR(255) NOT NULL,
  `country_alpha2_code` VARCHAR(255) NOT NULL,
  `country_code` VARCHAR(255) NOT NULL,
  `country_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`country_alpha2_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Currencies
CREATE TABLE `Currencies` (
  `currency_id` INT NOT NULL,
  `currency_type` VARCHAR(255) NOT NULL,
  `currency_symbol` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- TaxInfo
CREATE TABLE `TaxInfo` (
  `tax_type_id` INT NOT NULL,
  `country` VARCHAR(255) NOT NULL,
  `Tax_Type` VARCHAR(255) NOT NULL,
  `tax_percentage` DECIMAL(5,4) NOT NULL,
  PRIMARY KEY (`tax_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Departments
CREATE TABLE `Departments` (
  `Department_id` INT NOT NULL,
  `department_name` VARCHAR(255) NOT NULL,
  `department_code` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Roles
CREATE TABLE `Roles` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `guard_name` VARCHAR(255) NOT NULL,
  `created_at` DATETIME,
  `updated_at` DATETIME,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Subscriptions
CREATE TABLE `Subscriptions` (
  `subscription_id` INT NOT NULL,
  `display_name` VARCHAR(255) NOT NULL,
  `subscription_name` VARCHAR(255) NOT NULL,
  `product_code` VARCHAR(255) NOT NULL,
  `subscription_active` TINYINT(1) NOT NULL,
  `subscription_code` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255),
  `Cost` DECIMAL(8,2) NOT NULL,
  `No Of Users` INT NOT NULL,
  `Frequency` VARCHAR(255),
  PRIMARY KEY (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Clients
CREATE TABLE `Clients` (
  `client_id` INT NOT NULL,
  `client_name` VARCHAR(255) NOT NULL,
  `country` VARCHAR(255) NOT NULL,
  `currency_id` INT NOT NULL,
  `subscription_id` INT NOT NULL,
  `activation_date` DATE NOT NULL,
  `inactivation_date` DATE,
  `status` VARCHAR(255) NOT NULL,
  `contact_email` VARCHAR(255) NOT NULL,
  `contact_phone` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`client_id`),
  CONSTRAINT `fk_Clients_currency_id` FOREIGN KEY (`currency_id`) REFERENCES `Currencies` (`currency_id`),
  CONSTRAINT `fk_Clients_subscription_id` FOREIGN KEY (`subscription_id`) REFERENCES `Subscriptions` (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Restaurants
CREATE TABLE `Restaurants` (
  `restaurant_id` INT NOT NULL,
  `restaurant_name` VARCHAR(255) NOT NULL,
  `client_id` INT NOT NULL,
  `country` VARCHAR(255) NOT NULL,
  `currency_id` INT NOT NULL,
  `city` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `post_code` VARCHAR(255) NOT NULL,
  `cuisine_type` VARCHAR(255) NOT NULL,
  `opening_date` DATE NOT NULL,
  PRIMARY KEY (`restaurant_id`),
  CONSTRAINT `fk_Restaurants_client_id` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`client_id`),
  CONSTRAINT `fk_Restaurants_currency_id` FOREIGN KEY (`currency_id`) REFERENCES `Currencies` (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Users
CREATE TABLE `Users` (
  `user_id` INT NOT NULL,
  `user_name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255) NOT NULL,
  `is_active` TINYINT(1) NOT NULL,
  `client_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `role_id` INT NOT NULL,
  `department_id` INT NOT NULL,
  `subscription_id` INT NOT NULL,
  `activation_date` DATE NOT NULL,
  `inactivation_date` DATE,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_Users_client_id` FOREIGN KEY (`client_id`) REFERENCES `Clients` (`client_id`),
  CONSTRAINT `fk_Users_restaurant_id` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`restaurant_id`),
  CONSTRAINT `fk_Users_role_id` FOREIGN KEY (`role_id`) REFERENCES `Roles` (`id`),
  CONSTRAINT `fk_Users_department_id` FOREIGN KEY (`department_id`) REFERENCES `Departments` (`Department_id`),
  CONSTRAINT `fk_Users_subscription_id` FOREIGN KEY (`subscription_id`) REFERENCES `Subscriptions` (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Orders
CREATE TABLE `Orders` (
  `order_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `order_date` DATE NOT NULL,
  `order_time` TIME NOT NULL,
  `order_type` VARCHAR(255) NOT NULL,
  `drinks_amount` DECIMAL(10,2) NOT NULL,
  `food_amount` DECIMAL(10,2) NOT NULL,
  `other_payment` DECIMAL(10,2) NOT NULL,
  `service_charges` DECIMAL(10,2) NOT NULL,
  `delivery_charges` DECIMAL(10,2) NOT NULL,
  `order_amount` DECIMAL(10,2) NOT NULL,
  `tax_amount` DECIMAL(10,2) NOT NULL,
  `order_total` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`order_id`),
  CONSTRAINT `fk_Orders_restaurant_id` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`restaurant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sales
CREATE TABLE `Sales` (
  `sales_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `creditcard_tip` DECIMAL(4,2) NOT NULL,
  `drinks_payment` DECIMAL(12,2) NOT NULL,
  `food_payment` DECIMAL(12,2) NOT NULL,
  `other_payment` DECIMAL(12,2) NOT NULL,
  `service_charges` DECIMAL(12,2) NOT NULL,
  `delivery_charges` DECIMAL(12,2) NOT NULL,
  `Date` DATE NOT NULL,
  PRIMARY KEY (`sales_id`),
  CONSTRAINT `fk_Sales_restaurant_id` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`restaurant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Expenses
CREATE TABLE `Expenses` (
  `expense_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `bills` DECIMAL(10,2) NOT NULL,
  `vendors` DECIMAL(10,2) NOT NULL,
  `wage advances` DECIMAL(10,2) NOT NULL,
  `repairs` DECIMAL(10,2) NOT NULL,
  `sundries` DECIMAL(10,2) NOT NULL,
  `Exp Date` DATE NOT NULL,
  PRIMARY KEY (`expense_id`),
  CONSTRAINT `fk_Expenses_restaurant_id` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`restaurant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Deliveries
CREATE TABLE `Deliveries` (
  `delivery_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `order_amount` DECIMAL(10,2) NOT NULL,
  `api_amount` DECIMAL(10,2) NOT NULL,
  `match_status` TINYINT(1) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `delivery_date` DATE NOT NULL,
  PRIMARY KEY (`delivery_id`),
  CONSTRAINT `fk_Deliveries_restaurant_id` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`restaurant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Banking
CREATE TABLE `Banking` (
  `banking_id` INT NOT NULL,
  `banked_total` DECIMAL(12,2) NOT NULL,
  `banking_total` DECIMAL(12,2) NOT NULL,
  `banking_date` DATE NOT NULL,
  `banking_time_indicator` VARCHAR(255) NOT NULL,
  `reconcile_status` VARCHAR(255) NOT NULL,
  `restaurant_id` INT NOT NULL,
  `sealed_by` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`banking_id`),
  CONSTRAINT `fk_Banking_restaurant_id` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`restaurant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Cash_Up
CREATE TABLE `Cash_Up` (
  `cashup_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `bod_amount` DECIMAL(12,2) NOT NULL,
  `sales` DECIMAL(12,2) NOT NULL,
  `expenses` DECIMAL(12,2) NOT NULL,
  `tax` DECIMAL(12,2) NOT NULL,
  `delivery_charges` DECIMAL(12,2) NOT NULL,
  `eod_amount` DECIMAL(12,2) NOT NULL,
  `match_status` TINYINT(1) NOT NULL,
  `banking_id` INT NOT NULL,
  `cash_up_date` DATE NOT NULL,
  `cashup_status` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`cashup_id`),
  CONSTRAINT `fk_Cash_Up_restaurant_id` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurants` (`restaurant_id`),
  CONSTRAINT `fk_Cash_Up_banking_id` FOREIGN KEY (`banking_id`) REFERENCES `Banking` (`banking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- End of DDL script
-- Total tables: 15
-- Total rows expected: 840,152