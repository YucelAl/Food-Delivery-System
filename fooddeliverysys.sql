-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: food_delivery_system
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'dcb25e16-dde6-11f0-82cc-00fffc834a20:1-22';

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `address` varchar(255) NOT NULL,
  `registration_date` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'John','Smith','john.smith@email.com','07712345678','12 High Street, Ipswich, IP1 1AA','2026-01-18'),(2,'Emma','Wilson','emma.wilson@email.com','07723456789','45 Queen Street, Ipswich, IP2 2BB','2026-01-18'),(3,'James','Brown','james.brown@email.com','07734567890','78 King Road, Colchester, CO1 1CC','2026-01-18'),(4,'Sarah','Taylor','sarah.taylor@email.com','07745678901','23 Church Lane, Norwich, NR1 1DD','2026-01-18'),(5,'Michael','Davies','michael.davies@email.com','07756789012','56 Market Place, Cambridge, CB1 1EE','2026-01-18'),(6,'Oliver','Johnson','oliver.johnson@email.com','07767890123','14 Station Road, Bury St Edmunds, IP33 1AB','2026-01-25'),(7,'Amelia','Clark','amelia.clark@email.com','07778901234','62 London Road, Chelmsford, CM1 1AA','2026-01-25'),(8,'Harry','Walker','harry.walker@email.com','07789012345','9 Mill Lane, Sudbury, CO10 2BB','2026-01-25'),(9,'Isla','Hall','isla.hall@email.com','07790123456','101 Riverside, Ely, CB7 4DD','2026-01-25'),(10,'Jack','Allen','jack.allen@email.com','07801234567','27 Park Avenue, Lowestoft, NR33 1EE','2026-01-25'),(11,'Sophia','Young','sophia.young@email.com','07812345678','33 Victoria Street, Felixstowe, IP11 7AA','2026-01-25'),(12,'Charlie','Harris','charlie.harris@email.com','07823456789','88 Grove Road, Clacton-on-Sea, CO15 3BB','2026-01-25'),(13,'Emily','Lewis','emily.lewis@email.com','07834567890','6 Meadow Close, Stowmarket, IP14 1CC','2026-01-25'),(14,'Thomas','Roberts','thomas.roberts@email.com','07845678901','52 Oak Street, Thetford, IP24 2DD','2026-01-25'),(15,'Mia','Turner','mia.turner@email.com','07856789012','19 School Lane, Diss, IP22 4EE','2026-01-25'),(16,'Noah','Phillips','noah.phillips@email.com','07867890123','74 Bridge Road, Great Yarmouth, NR30 1FF','2026-01-25'),(17,'Lily','Campbell','lily.campbell@email.com','07878901234','11 Castle Street, Colchester, CO1 1GG','2026-01-25'),(18,'Leo','Parker','leo.parker@email.com','07889012345','5 North Hill, Ipswich, IP4 1HH','2026-01-25'),(19,'Grace','Edwards','grace.edwards@email.com','07901234567','41 Newmarket Road, Cambridge, CB5 8JJ','2026-01-25'),(20,'Ethan','Mitchell','ethan.mitchell@email.com','07912345678','29 Broad Street, March, PE15 8KK','2026-01-25');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `driver`
--

DROP TABLE IF EXISTS `driver`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `driver` (
  `driver_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `vehicle_type` varchar(20) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`driver_id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `driver`
--

LOCK TABLES `driver` WRITE;
/*!40000 ALTER TABLE `driver` DISABLE KEYS */;
INSERT INTO `driver` VALUES (1,'David','Johnson','07798765432','Car',1),(2,'Lisa','Anderson','07787654321','Motorcycle',1),(3,'Robert','Thomas','07776543210','Bicycle',0),(4,'Jennifer','White','07765432109','Scooter',1);
/*!40000 ALTER TABLE `driver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menuitem`
--

DROP TABLE IF EXISTS `menuitem`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menuitem` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `price` decimal(6,2) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`item_id`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `menuitem_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`restaurant_id`),
  CONSTRAINT `menuitem_chk_1` CHECK ((`price` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menuitem`
--

LOCK TABLES `menuitem` WRITE;
/*!40000 ALTER TABLE `menuitem` DISABLE KEYS */;
INSERT INTO `menuitem` VALUES (1,1,'Margherita Pizza','Classic tomato and mozzarella',8.99,1),(2,1,'Pepperoni Pizza','Spicy pepperoni with cheese',10.99,1),(3,1,'Garlic Bread','Freshly baked with garlic butter',3.99,1),(4,2,'Sweet and Sour Chicken','Crispy chicken in tangy sauce',9.50,1),(5,2,'Egg Fried Rice','Wok-fried rice with egg',4.50,1),(6,2,'Spring Rolls','Vegetable spring rolls (4 pieces)',3.99,1),(7,3,'Chicken Tikka Masala','Creamy tomato curry',11.99,1),(8,3,'Lamb Biryani','Fragrant rice with tender lamb',13.99,1),(9,3,'Naan Bread','Traditional Indian flatbread',2.49,1),(10,4,'Classic Burger','Beef patty with lettuce and tomato',7.99,1),(11,4,'Cheese Fries','Crispy fries with melted cheese',4.49,1),(12,4,'Milkshake','Creamy vanilla milkshake',3.99,1);
/*!40000 ALTER TABLE `menuitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `restaurant_id` int NOT NULL,
  `driver_id` int DEFAULT NULL,
  `order_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_amount` decimal(8,2) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Pending',
  `is_paid` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`order_id`),
  KEY `customer_id` (`customer_id`),
  KEY `restaurant_id` (`restaurant_id`),
  KEY `driver_id` (`driver_id`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `order_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`restaurant_id`),
  CONSTRAINT `order_ibfk_3` FOREIGN KEY (`driver_id`) REFERENCES `driver` (`driver_id`),
  CONSTRAINT `order_chk_1` CHECK ((`total_amount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1,1,1,1,'2025-01-15 18:30:00',23.97,'Delivered',1),(2,2,2,2,'2025-01-15 19:00:00',17.99,'Delivered',1),(3,3,3,NULL,'2025-01-16 12:30:00',28.47,'Preparing',0),(4,1,4,4,'2025-01-16 13:00:00',16.47,'Out for Delivery',1),(5,4,1,NULL,'2025-01-16 19:30:00',19.98,'Pending',0),(6,5,1,3,'2025-01-17 18:30:00',14.98,'Delivered',1),(7,8,2,1,'2025-01-17 19:00:00',13.49,'Delivered',1),(8,6,3,NULL,'2025-01-18 12:30:00',16.48,'Preparing',0),(9,7,4,4,'2025-01-18 13:00:00',12.48,'Out for Delivery',1),(10,9,1,NULL,'2025-01-19 19:30:00',10.99,'Pending',0),(11,11,1,1,'2025-01-19 18:30:00',19.98,'Delivered',1),(12,10,2,2,'2025-01-20 19:00:00',14.00,'Delivered',1),(13,12,3,NULL,'2025-01-20 12:30:00',13.99,'Preparing',0),(14,15,4,4,'2025-01-21 13:00:00',11.98,'Out for Delivery',1),(15,18,1,NULL,'2025-01-21 19:30:00',8.99,'Pending',0);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderitem`
--

DROP TABLE IF EXISTS `orderitem`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderitem` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `subtotal` decimal(8,2) NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `orderitem_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`),
  CONSTRAINT `orderitem_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `menuitem` (`item_id`),
  CONSTRAINT `orderitem_chk_1` CHECK ((`quantity` >= 1)),
  CONSTRAINT `orderitem_chk_2` CHECK ((`subtotal` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderitem`
--

LOCK TABLES `orderitem` WRITE;
/*!40000 ALTER TABLE `orderitem` DISABLE KEYS */;
INSERT INTO `orderitem` VALUES (1,1,1,1,8.99),(2,1,2,1,10.99),(3,1,3,1,3.99),(4,2,4,1,9.50),(5,2,5,1,4.50),(6,2,6,1,3.99);
/*!40000 ALTER TABLE `orderitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `restaurant_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `cuisine_type` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `opening_time` time NOT NULL,
  `closing_time` time NOT NULL,
  PRIMARY KEY (`restaurant_id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
INSERT INTO `restaurant` VALUES (1,'Pizza Palace','Italian','10 London Road, Ipswich, IP1 2AB','01473111111','10:00:00','22:00:00'),(2,'Dragon Garden','Chinese','25 Crown Street, Ipswich, IP1 3CD','01473222222','11:30:00','23:00:00'),(3,'Spice House','Indian','8 Westgate Street, Ipswich, IP1 4EF','01473333333','12:00:00','23:30:00'),(4,'Burger Barn','American','42 Tavern Street, Ipswich, IP1 5GH','01473444444','09:00:00','21:00:00');
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-26 0:46:06
