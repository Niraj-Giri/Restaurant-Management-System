CREATE DATABASE  IF NOT EXISTS `restaurant` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `restaurant`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: restaurant
-- ------------------------------------------------------
-- Server version	5.7.44-log

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

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_date` datetime DEFAULT NULL,
  `guest_session_id` varchar(100) DEFAULT NULL,
  `is_deleted` bit(1) DEFAULT NULL,
  `is_order_placed` bit(1) DEFAULT NULL,
  `order_id` bigint(20) DEFAULT NULL,
  `total_price` double DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `restaurant_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKg5uhi8vpsuy0lgloxk2h4w5o6` (`user_id`),
  KEY `FKq2wpofykuqfnhwpyd4mo944yw` (`restaurant_id`),
  CONSTRAINT `FKg5uhi8vpsuy0lgloxk2h4w5o6` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKq2wpofykuqfnhwpyd4mo944yw` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,'2026-02-19 11:08:50',NULL,_binary '\0',_binary '',NULL,320,NULL,1,NULL),(2,'2026-02-19 12:00:18',NULL,_binary '\0',_binary '',NULL,320,NULL,1,NULL),(3,'2026-02-19 12:11:21',NULL,_binary '\0',_binary '',NULL,280,NULL,1,NULL),(4,'2026-02-19 12:26:05',NULL,_binary '\0',_binary '',NULL,350,NULL,1,NULL),(5,'2026-02-19 12:30:06',NULL,_binary '\0',_binary '',NULL,820,NULL,1,NULL),(6,'2026-02-19 12:57:19',NULL,_binary '\0',_binary '',NULL,280,NULL,1,NULL),(7,'2026-02-19 13:00:33',NULL,_binary '\0',_binary '',NULL,0,NULL,2,NULL),(8,'2026-02-19 13:00:52',NULL,_binary '\0',_binary '',NULL,220,NULL,2,NULL),(9,'2026-02-19 14:02:21','guest_sp19mjo1z1771487192264',_binary '\0',_binary '\0',NULL,0,NULL,NULL,NULL),(10,'2026-02-19 16:01:50',NULL,_binary '\0',_binary '',NULL,0,NULL,3,NULL),(11,'2026-02-19 16:02:45','guest_1779l0qgh1771496716822',_binary '\0',_binary '\0',NULL,0,NULL,NULL,NULL),(12,'2026-02-19 16:55:31',NULL,_binary '\0',_binary '',NULL,280,NULL,2,NULL),(13,'2026-02-19 16:56:28',NULL,_binary '\0',_binary '',NULL,280,NULL,2,NULL),(14,'2026-02-19 17:00:30',NULL,_binary '\0',_binary '',NULL,280,NULL,2,NULL),(15,'2026-02-19 18:35:01','guest_l4kl5nhti1771505947661',_binary '',_binary '\0',NULL,280,NULL,NULL,NULL),(16,'2026-02-19 18:36:37',NULL,_binary '\0',_binary '',NULL,280,NULL,1,NULL),(17,'2026-02-19 21:06:30',NULL,_binary '\0',_binary '',NULL,150,NULL,3,NULL),(18,'2026-02-19 21:14:59',NULL,_binary '\0',_binary '',NULL,280,NULL,3,NULL),(19,'2026-02-19 21:36:52','guest_i9sy55bxp1771517211689',_binary '\0',_binary '\0',NULL,0,NULL,NULL,NULL),(20,'2026-02-20 10:53:19','guest_udfv6htqe1771517289982',_binary '',_binary '\0',NULL,280,NULL,NULL,NULL),(21,'2026-02-20 10:54:19',NULL,_binary '\0',_binary '',NULL,120,NULL,1,NULL),(22,'2026-02-20 10:56:58',NULL,_binary '\0',_binary '',NULL,90,NULL,1,NULL),(23,'2026-02-20 11:02:03',NULL,_binary '\0',_binary '',NULL,220,NULL,1,1),(24,'2026-02-20 11:37:26','guest_sj3zmwry01771567645967',_binary '',_binary '\0',NULL,280,NULL,NULL,NULL),(25,'2026-02-20 11:38:05',NULL,_binary '\0',_binary '',NULL,220,NULL,3,NULL),(26,'2026-02-20 14:37:14','guest_agpa5axff1771578433849',_binary '\0',_binary '\0',NULL,0,NULL,NULL,NULL),(27,'2026-02-20 15:05:51',NULL,_binary '\0',_binary '',NULL,220,NULL,3,NULL),(28,'2026-02-20 15:11:19',NULL,_binary '\0',_binary '',NULL,0,NULL,3,NULL),(29,'2026-02-20 15:25:25',NULL,_binary '\0',_binary '',NULL,60,NULL,3,NULL),(30,'2026-02-20 15:36:08',NULL,_binary '\0',_binary '',NULL,190,NULL,3,NULL),(31,'2026-02-20 16:24:40','guest_i5alcp42h1771584879786',_binary '',_binary '\0',NULL,150,NULL,NULL,NULL),(32,'2026-02-20 16:48:53','guest_hqr06c1mn1771586333239',_binary '',_binary '\0',NULL,40,NULL,NULL,NULL),(33,'2026-02-20 16:49:30',NULL,_binary '\0',_binary '',NULL,320,NULL,3,NULL),(34,'2026-02-20 17:13:14','guest_m8b7tssxs1771587793904',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(35,'2026-02-20 17:40:49',NULL,_binary '\0',_binary '\0',NULL,0,NULL,101,NULL),(36,'2026-02-20 18:53:28',NULL,_binary '\0',_binary '',NULL,90,NULL,3,NULL),(37,'2026-02-20 18:57:51','guest_9l1n1lvna1771594071203',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(38,'2026-02-20 18:58:23',NULL,_binary '\0',_binary '',NULL,150,NULL,3,NULL),(39,'2026-02-20 19:04:14',NULL,_binary '\0',_binary '',NULL,150,NULL,3,NULL),(40,'2026-02-20 19:12:00','guest_tvt4epjs01771594920010',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(41,'2026-02-20 21:30:53','guest_ccuo1e91b1771603061924',_binary '',_binary '\0',NULL,150,NULL,NULL,NULL),(42,'2026-02-20 21:32:03',NULL,_binary '\0',_binary '',NULL,320,NULL,3,NULL),(43,'2026-02-20 21:32:20','guest_zrmq5ae7o1771603339954',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(44,'2026-02-20 21:34:02',NULL,_binary '\0',_binary '',NULL,300,NULL,3,NULL),(45,'2026-02-20 21:36:15',NULL,_binary '\0',_binary '',NULL,90,NULL,3,NULL),(46,'2026-02-20 21:45:32',NULL,_binary '\0',_binary '',NULL,60,NULL,2,NULL),(47,'2026-02-20 21:46:17',NULL,_binary '\0',_binary '',NULL,320,NULL,2,1),(48,'2026-02-20 22:06:57','guest_a4779chu71771605416474',_binary '',_binary '\0',NULL,150,NULL,NULL,NULL),(49,'2026-02-20 22:09:50','guest_l12br9t2p1771605589676',_binary '',_binary '\0',NULL,90,NULL,NULL,NULL),(50,'2026-02-20 22:14:10',NULL,_binary '\0',_binary '',NULL,70,NULL,3,NULL),(51,'2026-02-20 22:14:14','guest_8r1llc4ol1771605854119',_binary '',_binary '\0',NULL,280,NULL,NULL,NULL),(52,'2026-02-20 22:14:51','guest_0kx1b2mfj1771605891187',_binary '',_binary '\0',NULL,220,NULL,NULL,NULL),(53,'2026-02-20 22:16:35','guest_lz1ew6vf51771605995228',_binary '',_binary '\0',NULL,40,NULL,NULL,NULL),(54,'2026-02-20 22:17:04','guest_2ih9zd98t1771606023531',_binary '',_binary '\0',NULL,70,NULL,NULL,NULL),(55,'2026-02-20 22:18:08',NULL,_binary '\0',_binary '',NULL,320,NULL,3,NULL),(56,'2026-02-21 11:12:40','guest_4gjpqin2n1771652560126',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(57,'2026-02-21 11:13:08',NULL,_binary '\0',_binary '',NULL,220,NULL,3,NULL),(58,'2026-02-21 11:13:39',NULL,_binary '\0',_binary '',NULL,150,NULL,3,NULL),(59,'2026-02-21 11:17:53',NULL,_binary '\0',_binary '',NULL,40,NULL,3,NULL),(60,'2026-02-21 11:20:03',NULL,_binary '\0',_binary '',NULL,70,NULL,3,NULL),(61,'2026-02-21 11:24:36',NULL,_binary '\0',_binary '',NULL,220,NULL,3,NULL),(62,'2026-02-21 11:25:06',NULL,_binary '\0',_binary '',NULL,280,NULL,3,NULL),(63,'2026-02-21 11:28:17',NULL,_binary '\0',_binary '',NULL,90,NULL,3,NULL),(64,'2026-02-21 11:37:33',NULL,_binary '\0',_binary '',NULL,150,NULL,3,NULL),(65,'2026-02-21 11:38:07',NULL,_binary '\0',_binary '',NULL,320,NULL,3,NULL),(66,'2026-02-21 11:41:56',NULL,_binary '\0',_binary '',NULL,320,NULL,3,NULL),(67,'2026-02-21 11:42:50',NULL,_binary '\0',_binary '',NULL,280,NULL,3,NULL),(68,'2026-02-21 11:43:22',NULL,_binary '\0',_binary '',NULL,120,NULL,3,NULL),(69,'2026-02-21 11:47:58',NULL,_binary '\0',_binary '',NULL,60,NULL,3,NULL),(70,'2026-02-21 11:48:17',NULL,_binary '\0',_binary '',NULL,180,NULL,3,NULL),(71,'2026-02-21 11:51:25',NULL,_binary '\0',_binary '',NULL,220,NULL,3,NULL),(72,'2026-02-21 11:53:34',NULL,_binary '\0',_binary '',NULL,40,NULL,3,NULL),(73,'2026-02-21 11:53:55',NULL,_binary '\0',_binary '',NULL,70,NULL,3,NULL),(74,'2026-02-21 11:57:28',NULL,_binary '\0',_binary '',NULL,280,NULL,3,NULL),(75,'2026-02-21 12:50:14','guest_i2sx5zean1771658414267',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(76,'2026-02-21 12:50:31',NULL,_binary '\0',_binary '',NULL,40,NULL,3,NULL),(77,'2026-02-21 13:05:03','guest_pn2q2bl051771659303232',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(78,'2026-02-21 13:05:26',NULL,_binary '\0',_binary '',NULL,150,NULL,3,NULL),(79,'2026-02-21 13:05:46',NULL,_binary '\0',_binary '\0',NULL,0,NULL,3,2),(80,'2026-02-21 14:07:45','guest_27ak3x9d81771663065302',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(81,'2026-02-21 14:10:19','guest_z1wi10qzm1771663219317',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(82,'2026-02-21 14:16:56','guest_oucxyhc6k1771663615656',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(83,'2026-02-21 14:22:51','guest_rbkrgcq8r1771663970958',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(84,'2026-02-21 14:38:30','guest_f7lkvo3yf1771664905055',_binary '',_binary '\0',NULL,600,NULL,NULL,NULL),(85,'2026-02-21 14:49:37','guest_bspoby3d31771665576750',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(86,'2026-02-21 14:50:42','guest_ocetlsvj61771665642383',_binary '',_binary '\0',NULL,320,NULL,NULL,NULL),(87,'2026-02-21 14:53:27','guest_jicdwrosc1771665806691',_binary '',_binary '\0',NULL,150,NULL,NULL,NULL),(88,'2026-02-21 14:56:03','guest_g4fwb44s11771665962741',_binary '',_binary '\0',NULL,320,NULL,NULL,1),(89,'2026-02-21 15:03:59','guest_rn3pjhxhl1771666439071',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(90,'2026-02-21 15:04:12','guest_hno9tp7l41771666452055',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(91,'2026-02-21 15:04:38','guest_lz6snciz11771666477493',_binary '',_binary '\0',NULL,320,NULL,NULL,1),(92,'2026-02-21 15:11:01','guest_leuzpv0dc1771666860461',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(93,'2026-02-21 15:11:13','guest_ak8s94skj1771666872497',_binary '',_binary '\0',NULL,320,NULL,NULL,1),(94,'2026-02-21 15:11:38','guest_q72aepuv61771666898316',_binary '',_binary '\0',NULL,320,NULL,NULL,1),(95,'2026-02-21 15:12:06','guest_empzaanus1771666925746',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(96,'2026-02-21 15:12:42','guest_bb9yhtcfr1771666962322',_binary '',_binary '\0',NULL,100,NULL,NULL,2),(97,'2026-02-21 15:12:59','guest_klgw6u7a01771666979384',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(98,'2026-02-21 15:21:00','guest_lobiwamud1771667459945',_binary '',_binary '\0',NULL,320,NULL,NULL,1),(99,'2026-02-21 15:28:49','guest_jrhudwa3g1771667928621',_binary '',_binary '\0',NULL,320,NULL,NULL,1),(100,'2026-02-21 15:32:33','guest_tx7m4zyzu1771668153051',_binary '\0',_binary '\0',NULL,320,NULL,NULL,1),(101,'2026-02-21 15:33:00','guest_esbtdr27q1771668179639',_binary '\0',_binary '\0',NULL,280,NULL,NULL,1),(102,'2026-02-21 15:36:18','guest_4gd8y33rs1771668377464',_binary '\0',_binary '\0',NULL,280,NULL,NULL,1),(103,'2026-02-21 15:38:14','guest_wlxptrppd1771668493470',_binary '\0',_binary '\0',NULL,280,NULL,NULL,1),(104,'2026-02-21 15:48:34','guest_qujgmtbtp1771669113540',_binary '\0',_binary '\0',NULL,280,NULL,NULL,1),(105,'2026-02-21 15:51:33','guest_9os9g4boo1771669293355',_binary '\0',_binary '\0',NULL,280,NULL,NULL,1),(106,'2026-02-21 15:54:24','guest_tykkklc441771669463415',_binary '\0',_binary '\0',NULL,150,NULL,NULL,1),(107,'2026-02-21 16:10:11','guest_145cjpcxh1771670410711',_binary '\0',_binary '\0',NULL,320,NULL,NULL,1),(108,'2026-02-21 16:22:24','guest_082hmmkh41771671143998',_binary '\0',_binary '\0',NULL,280,NULL,NULL,1),(109,'2026-02-21 16:31:24','guest_83timxv3g1771671683996',_binary '\0',_binary '\0',NULL,150,NULL,NULL,1),(110,'2026-02-21 16:43:13','guest_s10m7808v1771672392482',_binary '\0',_binary '\0',NULL,280,NULL,NULL,1),(111,'2026-02-21 16:46:03','guest_wfxfbkitw1771672563213',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(112,'2026-02-21 16:46:18','guest_slio0jtkc1771672577873',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL),(113,'2026-02-21 16:46:39',NULL,_binary '\0',_binary '',NULL,120,NULL,1,2),(114,'2026-02-21 16:47:19','guest_pdzx4o32c1771672638748',_binary '\0',_binary '\0',NULL,150,NULL,NULL,1),(115,'2026-02-21 16:51:59',NULL,_binary '\0',_binary '',NULL,0,NULL,1,NULL),(116,'2026-02-21 16:52:06','guest_7xuvpp5g41771672925531',_binary '\0',_binary '\0',NULL,320,NULL,NULL,1),(117,'2026-02-21 16:52:27','guest_8nwog1bhz1771672947305',_binary '\0',_binary '\0',NULL,150,NULL,NULL,1),(118,'2026-02-21 16:53:04','guest_00xgwtd471771672984081',_binary '\0',_binary '\0',NULL,220,NULL,NULL,1),(119,'2026-02-21 17:03:47','guest_ed4cftlwq1771673626774',_binary '\0',_binary '\0',NULL,70,NULL,NULL,1),(120,'2026-02-21 22:55:39','guest-123',_binary '\0',_binary '\0',NULL,1920,NULL,NULL,NULL),(121,'2026-02-21 23:26:34','guest-125',_binary '\0',_binary '\0',NULL,640,NULL,NULL,NULL),(122,'2026-02-21 23:28:39','guest-126',_binary '\0',_binary '\0',NULL,920,NULL,NULL,NULL),(123,'2026-02-22 02:01:32',NULL,_binary '\0',_binary '\0',NULL,0,NULL,2,NULL),(124,'2026-02-22 13:32:10',NULL,_binary '\0',_binary '\0',NULL,280,NULL,105,1),(125,'2026-02-22 13:32:24',NULL,_binary '\0',_binary '\0',NULL,100,NULL,1,2),(126,'2026-02-22 13:37:01',NULL,_binary '\0',_binary '',NULL,90,NULL,4,2),(127,'2026-02-22 13:49:10',NULL,_binary '\0',_binary '\0',NULL,0,NULL,108,NULL),(128,'2026-02-22 14:00:59',NULL,_binary '\0',_binary '\0',NULL,0,NULL,4,NULL),(129,'2026-02-22 14:03:03',NULL,_binary '\0',_binary '\0',NULL,100,NULL,110,2),(130,'2026-02-22 14:18:30','guest_h3z29bxc61771750110453',_binary '',_binary '\0',NULL,0,NULL,NULL,NULL);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_date` datetime DEFAULT NULL,
  `is_deleted` bit(1) DEFAULT NULL,
  `order_id` bigint(20) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `cart_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK99e0am9jpriwxcm6is7xfedy3` (`cart_id`),
  KEY `FKl7je3auqyq1raj52qmwrgih8x` (`product_id`),
  CONSTRAINT `FK99e0am9jpriwxcm6is7xfedy3` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  CONSTRAINT `FKl7je3auqyq1raj52qmwrgih8x` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (1,'2026-02-19 11:47:41',_binary '',NULL,100,1,NULL,1,12),(2,'2026-02-19 11:58:38',_binary '\0',NULL,320,1,NULL,1,1),(3,'2026-02-19 12:07:39',_binary '\0',NULL,320,1,NULL,2,1),(4,'2026-02-19 12:22:54',_binary '\0',NULL,280,1,NULL,3,2),(5,'2026-02-19 12:29:44',_binary '\0',NULL,350,1,NULL,4,22),(6,'2026-02-19 12:51:12',_binary '\0',NULL,320,1,NULL,5,1),(7,'2026-02-19 12:57:07',_binary '\0',NULL,220,1,NULL,5,3),(8,'2026-02-19 12:57:10',_binary '\0',NULL,280,1,NULL,5,2),(9,'2026-02-19 12:58:25',_binary '',NULL,280,1,'2026-02-19 12:58:31',6,2),(10,'2026-02-19 12:58:26',_binary '',NULL,320,1,'2026-02-19 12:58:32',6,1),(11,'2026-02-19 12:58:27',_binary '',NULL,220,1,'2026-02-19 12:58:32',6,3),(12,'2026-02-19 12:59:25',_binary '',NULL,320,1,'2026-02-19 13:05:35',6,1),(13,'2026-02-19 12:59:27',_binary '',NULL,280,1,'2026-02-19 13:05:36',6,2),(14,'2026-02-19 15:47:11',_binary '',NULL,320,1,'2026-02-19 16:55:26',8,1),(15,'2026-02-19 15:54:04',_binary '\0',NULL,220,1,'2026-02-19 16:55:25',8,3),(16,'2026-02-19 16:56:23',_binary '\0',NULL,280,1,NULL,12,2),(17,'2026-02-19 16:59:59',_binary '',NULL,70,1,'2026-02-19 17:00:12',13,10),(18,'2026-02-19 17:00:26',_binary '\0',NULL,280,1,NULL,13,2),(19,'2026-02-19 18:20:37',_binary '',NULL,280,1,'2026-02-19 18:20:40',14,2),(20,'2026-02-19 18:20:44',_binary '',NULL,100,1,'2026-02-19 18:21:08',14,12),(21,'2026-02-19 18:27:46',_binary '',NULL,280,1,'2026-02-19 18:27:52',14,2),(22,'2026-02-19 18:35:20',_binary '\0',NULL,280,1,NULL,6,2),(23,'2026-02-19 21:05:49',_binary '',NULL,40,1,'2026-02-20 21:44:24',14,5),(24,'2026-02-19 21:14:25',_binary '\0',NULL,150,1,NULL,17,6),(25,'2026-02-20 10:53:44',_binary '\0',NULL,280,1,NULL,16,2),(26,'2026-02-20 10:56:43',_binary '\0',NULL,120,1,NULL,21,11),(27,'2026-02-20 11:00:21',_binary '\0',NULL,90,1,NULL,22,13),(28,'2026-02-20 11:37:34',_binary '\0',NULL,280,1,NULL,18,2),(29,'2026-02-20 15:00:10',_binary '\0',NULL,220,1,NULL,25,3),(30,'2026-02-20 15:11:04',_binary '\0',NULL,220,1,NULL,27,3),(31,'2026-02-20 15:36:02',_binary '\0',NULL,60,1,NULL,29,4),(32,'2026-02-20 16:24:46',_binary '\0',NULL,150,1,NULL,30,6),(33,'2026-02-20 16:49:00',_binary '\0',NULL,40,1,NULL,30,5),(34,'2026-02-20 18:44:00',_binary '',NULL,280,1,'2026-02-20 18:51:22',33,2),(35,'2026-02-20 18:51:31',_binary '',NULL,40,1,'2026-02-20 18:52:46',33,5),(36,'2026-02-20 18:53:15',_binary '\0',NULL,320,1,NULL,33,1),(37,'2026-02-20 18:53:41',_binary '\0',NULL,90,1,NULL,36,9),(38,'2026-02-20 18:57:55',_binary '',NULL,320,1,'2026-02-20 18:58:16',36,1),(39,'2026-02-20 18:58:35',_binary '',NULL,280,1,'2026-02-20 19:03:44',38,2),(40,'2026-02-20 19:03:55',_binary '\0',NULL,150,1,NULL,38,6),(41,'2026-02-20 19:12:03',_binary '',NULL,320,1,'2026-02-20 19:14:55',39,1),(42,'2026-02-20 21:31:00',_binary '\0',NULL,150,1,NULL,39,6),(43,'2026-02-20 21:32:31',_binary '\0',NULL,320,1,NULL,42,1),(44,'2026-02-20 21:35:20',_binary '\0',NULL,150,2,'2026-02-20 21:35:47',44,6),(45,'2026-02-20 21:43:16',_binary '',NULL,180,1,'2026-02-20 21:44:24',14,8),(46,'2026-02-20 21:44:30',_binary '\0',NULL,280,1,NULL,14,2),(47,'2026-02-20 21:46:10',_binary '\0',NULL,60,1,NULL,46,4),(48,'2026-02-20 22:06:47',_binary '',NULL,220,1,'2026-02-22 02:01:14',47,3),(49,'2026-02-20 22:07:01',_binary '',NULL,150,1,'2026-02-20 22:09:39',45,6),(50,'2026-02-20 22:09:55',_binary '\0',NULL,90,1,NULL,45,9),(51,'2026-02-20 22:14:16',_binary '',NULL,280,1,'2026-02-20 22:14:40',50,2),(52,'2026-02-20 22:14:54',_binary '',NULL,220,1,'2026-02-20 22:16:59',50,3),(53,'2026-02-20 22:16:43',_binary '',NULL,40,1,'2026-02-20 22:16:59',50,5),(54,'2026-02-20 22:17:48',_binary '\0',NULL,70,1,NULL,50,10),(55,'2026-02-21 11:12:49',_binary '\0',NULL,320,1,NULL,55,1),(56,'2026-02-21 11:13:26',_binary '\0',NULL,220,1,NULL,57,3),(57,'2026-02-21 11:17:48',_binary '\0',NULL,150,1,NULL,58,6),(58,'2026-02-21 11:19:42',_binary '\0',NULL,40,1,NULL,59,5),(59,'2026-02-21 11:24:28',_binary '\0',NULL,70,1,NULL,60,10),(60,'2026-02-21 11:25:01',_binary '\0',NULL,220,1,NULL,61,3),(61,'2026-02-21 11:27:47',_binary '\0',NULL,280,1,NULL,62,2),(62,'2026-02-21 11:37:11',_binary '\0',NULL,90,1,NULL,63,9),(63,'2026-02-21 11:37:50',_binary '\0',NULL,150,1,NULL,64,6),(64,'2026-02-21 11:41:44',_binary '\0',NULL,320,1,NULL,65,1),(65,'2026-02-21 11:42:45',_binary '\0',NULL,320,1,NULL,66,1),(66,'2026-02-21 11:43:14',_binary '\0',NULL,280,1,NULL,67,2),(67,'2026-02-21 11:47:54',_binary '\0',NULL,120,1,NULL,68,11),(68,'2026-02-21 11:48:13',_binary '\0',NULL,60,1,NULL,69,4),(69,'2026-02-21 11:51:17',_binary '\0',NULL,180,1,NULL,70,8),(70,'2026-02-21 11:53:29',_binary '\0',NULL,220,1,NULL,71,3),(71,'2026-02-21 11:53:45',_binary '\0',NULL,40,1,NULL,72,5),(72,'2026-02-21 11:57:24',_binary '\0',NULL,70,1,NULL,73,10),(73,'2026-02-21 12:02:55',_binary '',NULL,320,1,'2026-02-21 12:50:23',74,1),(74,'2026-02-21 12:50:27',_binary '\0',NULL,280,1,NULL,74,2),(75,'2026-02-21 13:05:16',_binary '\0',NULL,40,1,NULL,76,5),(76,'2026-02-21 13:05:38',_binary '\0',NULL,150,1,NULL,78,6),(77,'2026-02-21 14:09:49',_binary '',NULL,320,1,'2026-02-21 14:22:43',79,1),(78,'2026-02-21 14:10:23',_binary '',NULL,320,1,NULL,81,1),(79,'2026-02-21 14:17:00',_binary '',NULL,320,1,NULL,82,1),(80,'2026-02-21 14:22:53',_binary '',NULL,320,1,'2026-02-21 14:50:20',79,1),(81,'2026-02-21 14:38:30',_binary '',NULL,320,1,NULL,84,1),(82,'2026-02-21 14:38:59',_binary '',NULL,280,1,'2026-02-21 14:50:21',79,2),(83,'2026-02-21 14:49:40',_binary '',NULL,320,1,NULL,85,1),(84,'2026-02-21 14:50:28',_binary '',NULL,320,1,'2026-02-21 14:53:22',79,1),(85,'2026-02-21 14:50:45',_binary '',NULL,320,1,NULL,86,1),(86,'2026-02-21 14:53:30',_binary '',NULL,150,1,'2026-02-21 14:55:55',79,6),(87,'2026-02-21 14:56:09',_binary '\0',NULL,320,1,NULL,88,1),(88,'2026-02-21 15:04:30',_binary '',NULL,320,1,'2026-02-21 16:46:27',23,1),(89,'2026-02-21 15:10:37',_binary '\0',NULL,320,1,NULL,91,1),(90,'2026-02-21 15:11:18',_binary '\0',NULL,320,1,NULL,93,1),(91,'2026-02-21 15:11:41',_binary '\0',NULL,320,1,NULL,94,1),(92,'2026-02-21 15:12:45',_binary '',NULL,100,1,'2026-02-21 15:12:55',79,12),(93,'2026-02-21 15:21:05',_binary '\0',NULL,320,1,NULL,98,1),(94,'2026-02-21 15:28:51',_binary '\0',NULL,320,1,NULL,99,1),(95,'2026-02-21 15:32:37',_binary '\0',NULL,320,1,NULL,100,1),(96,'2026-02-21 15:33:02',_binary '\0',NULL,280,1,NULL,101,2),(97,'2026-02-21 15:36:20',_binary '\0',NULL,280,1,NULL,102,2),(98,'2026-02-21 15:38:16',_binary '\0',NULL,280,1,NULL,103,2),(99,'2026-02-21 15:48:36',_binary '\0',NULL,280,1,NULL,104,2),(100,'2026-02-21 15:51:36',_binary '\0',NULL,280,1,NULL,105,2),(101,'2026-02-21 15:54:27',_binary '\0',NULL,150,1,NULL,106,6),(102,'2026-02-21 16:10:14',_binary '\0',NULL,320,1,NULL,107,1),(103,'2026-02-21 16:22:28',_binary '\0',NULL,280,1,NULL,108,2),(104,'2026-02-21 16:31:43',_binary '',NULL,320,1,'2026-02-21 16:36:53',109,1),(105,'2026-02-21 16:36:59',_binary '\0',NULL,150,1,NULL,109,6),(106,'2026-02-21 16:43:17',_binary '\0',NULL,280,1,NULL,110,2),(107,'2026-02-21 16:46:33',_binary '\0',NULL,220,1,NULL,23,3),(108,'2026-02-21 16:47:24',_binary '\0',NULL,150,1,NULL,114,6),(109,'2026-02-21 16:51:52',_binary '\0',NULL,120,1,NULL,113,11),(110,'2026-02-21 16:52:08',_binary '\0',NULL,320,1,NULL,116,1),(111,'2026-02-21 16:52:30',_binary '\0',NULL,150,1,NULL,117,6),(112,'2026-02-21 16:53:12',_binary '\0',NULL,220,1,NULL,118,3),(113,'2026-02-21 17:03:56',_binary '\0',NULL,70,1,NULL,119,10),(114,'2026-02-21 22:55:39',_binary '\0',NULL,320,6,NULL,120,1),(115,'2026-02-21 23:26:34',_binary '\0',NULL,320,2,NULL,121,1),(116,'2026-02-21 23:28:39',_binary '\0',NULL,320,2,NULL,122,1),(117,'2026-02-21 23:28:51',_binary '\0',NULL,280,1,NULL,122,2),(118,'2026-02-22 02:01:08',_binary '\0',NULL,320,1,NULL,47,1),(119,'2026-02-22 13:32:14',_binary '\0',NULL,280,1,NULL,124,2),(120,'2026-02-22 13:32:33',_binary '\0',NULL,100,1,NULL,125,12),(121,'2026-02-22 13:56:46',_binary '\0',NULL,90,1,NULL,126,13),(122,'2026-02-22 14:18:16',_binary '\0',NULL,100,1,NULL,129,12);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `restaurant_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Appetizers',1),(2,'Pasta & Pizza',1),(3,'Desserts',1),(4,'Gourmet Burgers',2),(5,'Sides & Shareables',2),(6,'Beverages',2);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon`
--

DROP TABLE IF EXISTS `coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `coupon_code` varchar(255) DEFAULT NULL,
  `coupon_type` varchar(255) DEFAULT NULL,
  `coupon_value` double DEFAULT NULL,
  `minimum_order_amount` double DEFAULT NULL,
  `is_deleted` bit(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_sre2vcap4vs6qucaksomk3c7s` (`coupon_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
INSERT INTO `coupon` VALUES (1,'WELCOME50','FLAT',50,299,_binary '\0'),(2,'SAVE10','PERCENTAGE',10,199,_binary '\0'),(3,'BIGDEAL100','FLAT',100,499,_binary '\0'),(4,'FESTIVE20','PERCENTAGE',20,399,_binary '\0'),(5,'FIRSTORDER75','FLAT',75,249,_binary '\0');
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `price_at_purchase` double DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `order_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKt4dc2r9nbvbujrljv3e23iibt` (`order_id`),
  KEY `FK551losx9j75ss5d6bfsqvijna` (`product_id`),
  CONSTRAINT `FK551losx9j75ss5d6bfsqvijna` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKt4dc2r9nbvbujrljv3e23iibt` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,320,1,1,1),(2,320,1,2,1),(3,280,1,3,2),(4,350,1,4,22),(5,320,1,5,1),(6,220,1,5,3),(7,280,1,5,2),(8,320,1,6,1),(9,280,1,6,2),(10,220,1,7,3),(11,280,1,8,2),(12,280,1,9,2),(13,280,1,10,2),(14,40,1,11,5),(15,150,1,12,6),(16,280,1,13,2),(17,120,1,14,11),(18,90,1,15,13),(19,280,1,16,2),(20,220,1,17,3),(21,220,1,18,3),(22,40,1,19,5),(23,60,1,20,4),(24,150,1,21,6),(25,40,1,21,5),(26,320,1,22,1),(27,90,1,23,9),(28,150,1,24,6),(29,150,1,25,6),(30,320,1,26,1),(31,150,2,27,6),(32,280,1,28,2),(33,60,1,29,4),(34,90,1,30,9),(35,70,1,31,10),(36,320,1,32,1),(37,220,1,33,3),(38,150,1,34,6),(39,40,1,35,5),(40,70,1,36,10),(41,220,1,37,3),(42,280,1,38,2),(43,90,1,39,9),(44,150,1,40,6),(45,320,1,41,1),(46,320,1,42,1),(47,280,1,43,2),(48,120,1,44,11),(49,60,1,45,4),(50,180,1,46,8),(51,220,1,47,3),(52,40,1,48,5),(53,70,1,49,10),(54,280,1,50,2),(55,40,1,51,5),(56,150,1,52,6),(57,220,1,53,3),(58,120,1,54,11),(59,320,2,55,1),(60,280,2,55,2),(61,320,1,56,1),(62,100,1,57,12),(63,90,1,58,13);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_tracking`
--

DROP TABLE IF EXISTS `order_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_tracking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `delivered` bit(1) NOT NULL,
  `trip_started` bit(1) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `order_id` bigint(20) DEFAULT NULL,
  `delivery_staff_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKeu0lumcx8bcx6lk035xiklty0` (`order_id`),
  KEY `FK78gf8hx777p4r8vpl36yc1pib` (`delivery_staff_id`),
  CONSTRAINT `FK78gf8hx777p4r8vpl36yc1pib` FOREIGN KEY (`delivery_staff_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKeu0lumcx8bcx6lk035xiklty0` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_tracking`
--

LOCK TABLES `order_tracking` WRITE;
/*!40000 ALTER TABLE `order_tracking` DISABLE KEYS */;
INSERT INTO `order_tracking` VALUES (1,'2026-02-20 11:49:06',_binary '\0',_binary '','2026-02-20 14:58:37',16,101),(2,'2026-02-20 15:06:30',_binary '\0',_binary '\0','2026-02-20 15:06:30',17,101),(3,'2026-02-20 15:11:39',_binary '\0',_binary '','2026-02-20 21:20:35',18,101),(4,'2026-02-20 15:25:44',_binary '',_binary '','2026-02-20 15:26:46',19,101),(5,'2026-02-20 15:36:34',_binary '',_binary '','2026-02-20 15:37:15',20,101),(6,'2026-02-20 16:50:04',_binary '',_binary '','2026-02-20 21:20:02',21,101),(7,'2026-02-20 19:16:00',_binary '',_binary '','2026-02-20 19:17:40',24,101),(8,'2026-02-21 11:54:43',_binary '\0',_binary '','2026-02-21 13:04:07',48,101),(9,'2026-02-21 17:25:11',_binary '\0',_binary '\0','2026-02-21 17:25:11',53,101),(10,'2026-02-22 02:03:26',_binary '',_binary '','2026-02-22 02:04:40',56,101);
/*!40000 ALTER TABLE `order_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `applied_coupon_code` varchar(255) DEFAULT NULL,
  `applied_coupon_type` varchar(255) DEFAULT NULL,
  `applied_coupon_value` double NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `tax_rate` double DEFAULT NULL,
  `tip_amount` double DEFAULT NULL,
  `total_amount` double DEFAULT NULL,
  `total_amount_after_tax` double DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `coupon_id` bigint(20) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `restaurant_id` bigint(20) DEFAULT NULL,
  `delivery_otp` varchar(20) DEFAULT NULL,
  `delivery_address_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKa5ei0aklq6wrjl8vrr7ied3bx` (`coupon_id`),
  KEY `FKsjfs85qf6vmcurlx43cnc16gy` (`customer_id`),
  KEY `FK2m9qulf12xm537bku3jnrrbup` (`restaurant_id`),
  KEY `FKhfo1wkpi8up8lihj147oo59v7` (`delivery_address_id`),
  CONSTRAINT `FK2m9qulf12xm537bku3jnrrbup` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`),
  CONSTRAINT `FKa5ei0aklq6wrjl8vrr7ied3bx` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`id`),
  CONSTRAINT `FKhfo1wkpi8up8lihj147oo59v7` FOREIGN KEY (`delivery_address_id`) REFERENCES `user_address` (`id`),
  CONSTRAINT `FKsjfs85qf6vmcurlx43cnc16gy` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,NULL,NULL,0,'2026-02-19 11:59:58','PROCESSING',9,0,320,348.8,'2026-02-19 21:54:34',NULL,1,1,'0',NULL),(2,'SAVE10','PERCENTAGE',10,'2026-02-19 12:10:20','PROCESSING',9,150,320,466.8,'2026-02-19 12:10:20',2,1,1,'0',NULL),(3,'FIRSTORDER75','FLAT',75,'2026-02-19 12:23:31','IN_ROUTE',9,0,280,230.2,'2026-02-19 12:23:31',5,1,1,'0',NULL),(4,NULL,NULL,0,'2026-02-19 12:30:04','PROCESSING',9,0,350,381.5,'2026-02-19 12:30:04',NULL,1,3,'0',NULL),(5,NULL,NULL,0,'2026-02-19 12:57:16','IN_ROUTE',9,0,820,893.8,'2026-02-19 21:52:16',NULL,1,1,'0',NULL),(6,NULL,NULL,0,'2026-02-19 13:00:50','IN_ROUTE',9,0,600,654,'2026-02-19 15:48:00',NULL,2,1,'0',NULL),(7,NULL,NULL,0,'2026-02-19 16:55:28','IN_ROUTE',9,0,220,239.8,'2026-02-19 16:56:00',NULL,2,1,'0',NULL),(8,NULL,NULL,0,'2026-02-19 16:56:27','CANCELED',9,0,280,305.2,'2026-02-19 16:56:43',NULL,2,1,'0',NULL),(9,NULL,NULL,0,'2026-02-19 17:00:29','CANCELED',9,0,280,305.2,'2026-02-19 17:00:51',NULL,2,1,'0',NULL),(10,NULL,NULL,0,'2026-02-19 18:36:35','IN_ROUTE',9,0,280,305.2,'2026-02-19 21:47:30',NULL,1,1,'0',NULL),(11,NULL,NULL,0,'2026-02-19 21:06:28','PLACED',9,0,40,43.6,'2026-02-19 21:06:28',NULL,3,1,'0',NULL),(12,NULL,NULL,0,'2026-02-19 21:14:57','IN_ROUTE',9,0,150,163.5,'2026-02-19 21:15:37',NULL,3,1,'0',NULL),(13,NULL,NULL,0,'2026-02-20 10:54:17','CANCELED',9,0,280,305.2,'2026-02-20 10:56:30',NULL,1,1,'0',NULL),(14,NULL,NULL,0,'2026-02-20 10:56:57','PLACED',9,100,120,230.8,'2026-02-20 10:56:57',NULL,1,2,'0',NULL),(15,NULL,NULL,0,'2026-02-20 11:02:01','PLACED',9,60,90,158.1,'2026-02-20 11:02:01',NULL,1,2,'0',NULL),(16,'SAVE10','PERCENTAGE',10,'2026-02-20 11:38:01','IN_ROUTE',9,10,280,287.2,'2026-02-20 11:49:06',2,3,1,'8469',NULL),(17,NULL,NULL,0,'2026-02-20 15:05:49','IN_ROUTE',9,0,220,239.8,'2026-02-20 15:06:30',NULL,3,1,'8862',NULL),(18,NULL,NULL,0,'2026-02-20 15:11:18','IN_ROUTE',9,59,220,298.8,'2026-02-20 15:11:39',NULL,3,1,'4893',NULL),(19,NULL,NULL,0,'2026-02-20 15:25:24','DELIVERED',9,0,40,43.6,'2026-02-20 15:26:46',NULL,3,1,'5058',NULL),(20,NULL,NULL,0,'2026-02-20 15:36:06','RECEIVED',9,0,60,65.4,'2026-02-20 15:37:15',NULL,3,1,'1187',NULL),(21,NULL,NULL,0,'2026-02-20 16:49:28','RECEIVED',9,0,190,207.1,'2026-02-20 21:20:02',NULL,3,1,'6477',9),(22,NULL,NULL,0,'2026-02-20 18:53:23','CANCELED',9,0,320,348.8,'2026-02-20 18:53:31',NULL,3,1,NULL,11),(23,NULL,NULL,0,'2026-02-20 18:58:22','CANCELED',9,0,90,98.1,'2026-02-20 18:58:27',NULL,3,1,NULL,12),(24,NULL,NULL,0,'2026-02-20 19:04:11','RECEIVED',9,0,150,163.5,'2026-02-20 19:17:40',NULL,3,1,'6426',14),(25,NULL,NULL,0,'2026-02-20 21:31:56','PLACED',9,100,150,263.5,'2026-02-20 21:31:56',NULL,3,1,NULL,15),(26,'WELCOME50','FLAT',50,'2026-02-20 21:34:00','PLACED',9,100,320,398.8,'2026-02-20 21:34:00',1,3,1,NULL,15),(27,'WELCOME50','FLAT',50,'2026-02-20 21:36:11','PLACED',9,50,300,327,'2026-02-20 21:36:11',1,3,1,NULL,15),(28,NULL,NULL,0,'2026-02-20 21:45:27','PLACED',9,0,280,305.2,'2026-02-20 21:45:27',NULL,2,1,NULL,2),(29,NULL,NULL,0,'2026-02-20 21:46:15','PLACED',9,0,60,65.4,'2026-02-20 21:46:15',NULL,2,1,NULL,2),(30,NULL,NULL,0,'2026-02-20 22:14:08','PLACED',9,0,90,98.1,'2026-02-20 22:14:08',NULL,3,1,NULL,15),(31,NULL,NULL,0,'2026-02-20 22:18:06','PLACED',9,0,70,76.3,'2026-02-20 22:18:06',NULL,3,1,NULL,15),(32,'WELCOME50','FLAT',50,'2026-02-21 11:13:06','PLACED',9,150,320,448.8,'2026-02-21 11:13:06',1,3,1,NULL,15),(33,NULL,NULL,0,'2026-02-21 11:13:30','CANCELED',9,0,220,239.8,'2026-02-21 11:17:32',NULL,3,1,NULL,15),(34,NULL,NULL,0,'2026-02-21 11:17:52','PLACED',9,0,150,163.5,'2026-02-21 11:17:52',NULL,3,1,NULL,15),(35,NULL,NULL,0,'2026-02-21 11:19:57','PLACED',9,0,40,43.6,'2026-02-21 11:19:57',NULL,3,1,NULL,15),(36,NULL,NULL,0,'2026-02-21 11:24:34','PLACED',9,0,70,76.3,'2026-02-21 11:24:34',NULL,3,1,NULL,15),(37,NULL,NULL,0,'2026-02-21 11:25:04','PLACED',9,0,220,239.8,'2026-02-21 11:25:04',NULL,3,1,NULL,15),(38,NULL,NULL,0,'2026-02-21 11:28:10','PLACED',9,0,280,305.2,'2026-02-21 11:28:10',NULL,3,1,NULL,15),(39,NULL,NULL,0,'2026-02-21 11:37:30','PLACED',9,0,90,98.1,'2026-02-21 11:37:30',NULL,3,1,NULL,15),(40,NULL,NULL,0,'2026-02-21 11:38:06','PLACED',9,0,150,163.5,'2026-02-21 11:38:06',NULL,3,1,NULL,15),(41,NULL,NULL,0,'2026-02-21 11:41:54','PLACED',9,0,320,348.8,'2026-02-21 11:41:54',NULL,3,1,NULL,15),(42,NULL,NULL,0,'2026-02-21 11:42:47','PLACED',9,0,320,348.8,'2026-02-21 11:42:47',NULL,3,1,NULL,15),(43,NULL,NULL,0,'2026-02-21 11:43:17','PLACED',9,0,280,305.2,'2026-02-21 11:43:17',NULL,3,1,NULL,15),(44,NULL,NULL,0,'2026-02-21 11:47:57','PLACED',9,0,120,130.8,'2026-02-21 11:47:57',NULL,3,2,NULL,15),(45,NULL,NULL,0,'2026-02-21 11:48:15','PLACED',9,0,60,65.4,'2026-02-21 11:48:15',NULL,3,1,NULL,15),(46,NULL,NULL,0,'2026-02-21 11:51:23','PLACED',9,0,180,196.2,'2026-02-21 11:51:23',NULL,3,1,NULL,15),(47,NULL,NULL,0,'2026-02-21 11:53:32','PLACED',9,0,220,239.8,'2026-02-21 11:53:32',NULL,3,1,NULL,15),(48,NULL,NULL,0,'2026-02-21 11:53:48','IN_ROUTE',9,0,40,43.6,'2026-02-21 13:04:07',NULL,3,1,'5489',15),(49,NULL,NULL,0,'2026-02-21 11:57:27','PLACED',9,0,70,76.3,'2026-02-21 11:57:27',NULL,3,1,NULL,15),(50,NULL,NULL,0,'2026-02-21 12:50:30','CANCELED',9,0,280,305.2,'2026-02-21 12:50:36',NULL,3,1,NULL,15),(51,NULL,NULL,0,'2026-02-21 13:05:24','PLACED',9,0,40,43.6,'2026-02-21 13:05:24',NULL,3,1,NULL,15),(52,NULL,NULL,0,'2026-02-21 13:05:43','PLACED',9,0,150,163.5,'2026-02-21 13:05:43',NULL,3,1,NULL,15),(53,NULL,NULL,0,'2026-02-21 16:46:37','ASSIGNED',9,0,220,239.8,'2026-02-21 17:25:11',NULL,1,1,'5062',6),(54,NULL,NULL,0,'2026-02-21 16:51:56','PLACED',9,0,120,130.8,'2026-02-21 16:51:56',NULL,1,2,NULL,6),(55,NULL,NULL,0,'2026-02-21 23:21:55','PLACED',9,20,1200,1328,'2026-02-21 23:21:55',NULL,1,2,NULL,1),(56,'SAVE10','PERCENTAGE',10,'2026-02-22 02:01:29','RECEIVED',9,100,320,416.8,'2026-02-22 02:04:40',2,2,1,'8700',2),(57,NULL,NULL,0,'2026-02-22 13:36:59','PLACED',9,0,100,109,'2026-02-22 13:36:59',NULL,4,2,NULL,6),(58,NULL,NULL,0,'2026-02-22 13:57:58','PLACED',9,0,90,98.1,'2026-02-22 13:57:58',NULL,4,2,NULL,16);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `restaurant_id` bigint(20) DEFAULT NULL,
  `is_deleted` bit(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKlmkxy39f530rpupdybext0n33` (`restaurant_id`),
  CONSTRAINT `FKlmkxy39f530rpupdybext0n33` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Creamy tomato gravy','Butter Chicken',320,1,_binary '\0'),(2,'Rich paneer curry','Paneer Butter Masala',280,1,_binary '\0'),(3,'Slow cooked dal','Dal Makhani',220,1,_binary '\0'),(4,'Buttery naan','Garlic Naan',60,1,_binary '\0'),(5,'Clay oven roti','Tandoori Roti',40,1,_binary '\0'),(6,'Cumin flavored rice','Jeera Rice',150,1,_binary '\0'),(7,'Smoky grilled chicken','Chicken Tikka',300,1,_binary '\0'),(8,'Vegetable rice','Veg Pulao',180,1,_binary '\0'),(9,'Sweet dessert','Gulab Jamun',90,1,_binary '\0'),(10,'Crunchy starter','Masala Papad',70,1,_binary '\0'),(11,'Crispy dosa','Masala Dosa',120,2,_binary '\0'),(12,'Classic dosa','Plain Dosa',100,2,_binary '\0'),(13,'Soft idlis','Idli Sambar',90,2,_binary '\0'),(14,'Fried lentil donut','Vada',80,2,_binary '\0'),(15,'Thick dosa','Uttapam',130,2,_binary '\0'),(16,'Crispy rava dosa','Rava Dosa',140,2,_binary '\0'),(17,'Rice with sambar','Sambar Rice',150,2,_binary '\0'),(18,'Cooling rice','Curd Rice',110,2,_binary '\0'),(19,'South Indian coffee','Filter Coffee',60,2,_binary '\0'),(20,'Sweet dessert','Payasam',100,2,_binary '\0'),(21,'Hyderabadi style','Chicken Biryani',280,3,_binary '\0'),(22,'Slow cooked mutton','Mutton Biryani',350,3,_binary '\0'),(23,'Aromatic rice','Veg Biryani',220,3,_binary '\0'),(24,'Spicy fried chicken','Chicken 65',240,3,_binary '\0'),(25,'Chilli curry','Mirchi Ka Salan',120,3,_binary '\0'),(26,'Extra egg','Boiled Egg',30,3,_binary '\0'),(27,'Curd based side','Raita',60,3,_binary '\0'),(28,'Sweet bread dessert','Double Ka Meetha',100,3,_binary '\0'),(29,'Charcoal grilled','Chicken Kebab',260,3,_binary '\0'),(30,'Cold beverage','Soft Drink',50,3,_binary '\0'),(31,'more Tomoto','Tomoto',100,1,_binary '\0'),(32,'Biryani Veg and Non Veg','Biryan',300,12,_binary '\0');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_blocked_users`
--

DROP TABLE IF EXISTS `restaurant_blocked_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_blocked_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `blocked_at` datetime DEFAULT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `restaurant_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `active` bit(1) NOT NULL,
  `unblocked_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKje7kr4yi2ae9hxm8582csqkek` (`restaurant_id`,`user_id`),
  KEY `FK8f59srrdm04thwctai5775ewe` (`user_id`),
  CONSTRAINT `FK8f59srrdm04thwctai5775ewe` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKac5o7mm081cy8mwjynml72hoy` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_blocked_users`
--

LOCK TABLES `restaurant_blocked_users` WRITE;
/*!40000 ALTER TABLE `restaurant_blocked_users` DISABLE KEYS */;
INSERT INTO `restaurant_blocked_users` VALUES (1,'2026-02-21 14:09:27','Test',1,3,_binary '',NULL),(2,'2026-02-21 16:47:03','nriaj',1,1,_binary '\0',NULL);
/*!40000 ALTER TABLE `restaurant_blocked_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant_staff`
--

DROP TABLE IF EXISTS `restaurant_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_staff` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `restaurant_id` bigint(20) DEFAULT NULL,
  `staff_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKj2un48ulj0maqh7qbn9vv8jts` (`restaurant_id`),
  KEY `FKfw7m2tc23502px5214s82omnq` (`staff_id`),
  CONSTRAINT `FKfw7m2tc23502px5214s82omnq` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKj2un48ulj0maqh7qbn9vv8jts` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_staff`
--

LOCK TABLES `restaurant_staff` WRITE;
/*!40000 ALTER TABLE `restaurant_staff` DISABLE KEYS */;
INSERT INTO `restaurant_staff` VALUES (1,'2026-02-20 11:23:04','2026-02-20 11:23:04',1,101),(2,'2026-02-20 11:23:04','2026-02-20 11:23:04',1,102),(3,'2026-02-20 11:23:04','2026-02-20 11:23:04',1,103),(4,'2026-02-20 11:23:04','2026-02-20 11:23:04',1,104),(5,'2026-02-20 11:23:04','2026-02-20 11:23:04',1,105);
/*!40000 ALTER TABLE `restaurant_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurants`
--

DROP TABLE IF EXISTS `restaurants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurants` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_deleted` bit(1) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owner_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKp5mmmypepihvmkdb83qwugr4d` (`owner_id`),
  CONSTRAINT `FKp5mmmypepihvmkdb83qwugr4d` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurants`
--

LOCK TABLES `restaurants` WRITE;
/*!40000 ALTER TABLE `restaurants` DISABLE KEYS */;
INSERT INTO `restaurants` VALUES (1,NULL,'North Indian specialty',_binary '\0','Spice Garden Updated','2026-02-22 00:54:26',2),(2,NULL,'Traditional South Indian meals',_binary '\0','South Delight',NULL,4),(3,NULL,'Hyderabadi biryani specialists',_binary '\0','Biryani Blues',NULL,4),(4,NULL,'Punjabi dhaba style food',_binary '\0','Punjabi Tandoor',NULL,4),(5,NULL,'Famous Mumbai street food',_binary '','Mumbai Street Eats',NULL,4),(6,NULL,'Rajasthani royal thali',_binary '\0','Royal Rajasthan',NULL,4),(7,NULL,'Authentic Bengali food',_binary '\0','Bengal Bhoj',NULL,4),(8,NULL,'Quick South Indian snacks',_binary '\0','Chennai Express',NULL,4),(9,NULL,'Chaat & snacks hub',_binary '\0','Delhi Chaat House',NULL,4),(10,NULL,'Kathi rolls & fast food',_binary '\0','Kolkata Rolls',NULL,4),(11,'2026-02-21 16:15:56','niraj123',_binary '\0','Niraj','2026-02-21 16:15:56',4),(12,'2026-02-21 22:23:46','Authentic Indian cuisine',_binary '\0','Spice Garden','2026-02-21 22:23:46',2),(13,'2026-02-21 22:26:16','Authentic Indian cuisine',_binary '\0','Spice Garden','2026-02-21 22:26:16',2),(14,'2026-02-22 00:31:57','Authentic Indian cuisine',_binary '\0','Spice Gardenzzz','2026-02-22 00:31:57',2),(15,'2026-02-22 00:33:51','Authentic Indian cuisine',_binary '\0','Spice Gardenzzz','2026-02-22 00:33:51',2),(16,'2026-02-22 00:34:01','Authentic Indian cuisine',_binary '\0','Spice Gardenzzzaa','2026-02-22 00:34:01',2);
/*!40000 ALTER TABLE `restaurants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `is_deleted` bit(1) DEFAULT NULL,
  `landmark` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `receiver_name` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKrmincuqpi8m660j1c57xj7twr` (`user_id`),
  CONSTRAINT `FKrmincuqpi8m660j1c57xj7twr` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address`
--

LOCK TABLES `user_address` WRITE;
/*!40000 ALTER TABLE `user_address` DISABLE KEYS */;
INSERT INTO `user_address` VALUES (1,'sharda university\r\nknowledge park 3','greater noida','2026-02-19 12:30:04',_binary '\0',NULL,'09650879935','niraj',NULL,'2026-02-19 12:30:04','201310',1),(2,'sharda university\r\nknowledge park 3','greater noida','2026-02-19 13:00:50',_binary '\0',NULL,'98989089998','niraj ',NULL,'2026-02-19 13:00:50','201310',2),(3,'sharda university','greater noida','2026-02-19 18:36:35',_binary '\0',NULL,'9650879935','Giri',NULL,'2026-02-19 18:36:35','201310',1),(4,'lodi colony, c3/255\r\nhirsaj','Central Delhi','2026-02-19 21:06:28',_binary '\0',NULL,'09650879935','giri ',NULL,'2026-02-19 21:06:28','110003',3),(5,'lodi colony, c3/255\r\nhirsaj','Central Delhi','2026-02-19 21:14:57',_binary '\0',NULL,'09650879935','giri',NULL,'2026-02-19 21:14:57','110003',3),(6,'sharda university\r\nknowledge park 3','greater noida','2026-02-20 10:54:17',_binary '\0',NULL,'9650879935','Giri',NULL,'2026-02-20 10:54:17','201310',1),(7,'lodi colony, c3/255\r\nhirsaj','Central Delhi','2026-02-20 11:38:00',_binary '\0',NULL,'09650879935','Niraj Giri',NULL,'2026-02-20 11:38:00','110003',3),(8,'lodi colony, c3/255\r\nhirsaj','Central Delhi','2026-02-20 15:25:24',_binary '\0',NULL,'09650879935','Niraj Giri',NULL,'2026-02-20 15:25:24','110003',3),(9,'lodi colony, c3/255\r\nhirsaj','Central Delhi','2026-02-20 16:25:21',_binary '\0',NULL,'09650879935','Niraj Giri',NULL,'2026-02-20 16:25:21','110003',3),(10,'Nirja','Mumbai','2026-02-20 18:44:26',_binary '\0',NULL,'09316194349','Niraj Giri',NULL,'2026-02-20 18:44:26','203090',3),(11,'Nirja','Mumbai','2026-02-20 18:51:56',_binary '\0',NULL,'09316194349','Niraj Giri',NULL,'2026-02-20 18:51:56','203090',3),(12,'Nirja','Mumbai','2026-02-20 18:53:59',_binary '\0',NULL,'09316194349','Niraj Giri',NULL,'2026-02-20 18:53:59','203090',3),(13,'Nirja','Mumbai','2026-02-20 18:58:51',_binary '\0',NULL,'09316194349','Niraj Giri',NULL,'2026-02-20 18:58:51','203090',3),(14,'Nirja','Mumbai','2026-02-20 19:04:11',_binary '\0',NULL,'09316194349','Niraj Giri',NULL,'2026-02-20 19:04:11','203090',3),(15,'Nirja','Mumbai','2026-02-20 21:31:56',_binary '\0',NULL,'09316194349','Niraj Giri',NULL,'2026-02-20 21:31:56','203090',3),(16,'Lane no 3 , Timbatktoo , Karnatake','Karkardooma','2026-02-22 13:57:58',_binary '\0',NULL,'9999999999','Monika',NULL,'2026-02-22 13:57:58','888888',4);
/*!40000 ALTER TABLE `user_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `is_blocked` bit(1) DEFAULT NULL,
  `is_deleted` bit(1) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `mobile_number` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_6dotkott2kjsp8vw4d0m25fb7` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'2026-02-19 11:05:45','customer1@gmail.com','Chander',_binary '\0',_binary '\0','Chauhan','+919650879935','123456','CUSTOMER','2026-02-19 11:05:45'),(2,'2026-02-19 13:00:14','owner2@gmail.com','niraj',_binary '\0',_binary '\0','niraj','+912022819549','123456',' RESTAURANT_OWNER','2026-02-19 13:00:14'),(3,'2026-02-19 15:58:02','nirajgiri01@gmail.com','niraj1',_binary '\0',_binary '\0','niraj','+919650879935','niraj123','CUSTOMER','2026-02-19 15:58:02'),(4,'2026-02-21 16:15:56','owner3@gmail.com','Niraj',_binary '\0',_binary '\0','Giri','+919999999999','123456','RESTAURANT_OWNER','2026-02-21 16:15:56'),(101,'2026-02-20 11:21:22','amit.delivery@restaurant1.com','Amit',_binary '\0',_binary '\0','Sharma','+919876543001','123456','RESTAURANT_STAFF','2026-02-20 11:21:22'),(102,'2026-02-20 11:21:22','rahul.speed@restaurant1.com','Rahul',_binary '\0',_binary '\0','Verma','+919876543002','$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HCGKK2RxFhCg0C6.k.V/6','RESTAURANT_STAFF','2026-02-20 11:21:22'),(103,'2026-02-20 11:21:22','priya.logistics@restaurant1.com','Priya',_binary '\0',_binary '\0','Singh','+919876543003','$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HCGKK2RxFhCg0C6.k.V/6','RESTAURANT_STAFF','2026-02-20 11:21:22'),(104,'2026-02-20 11:21:22','vikram.rider@restaurant1.com','Vikram',_binary '\0',_binary '\0','Patel','+919876543004','$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HCGKK2RxFhCg0C6.k.V/6','RESTAURANT_STAFF','2026-02-20 11:21:22'),(105,'2026-02-20 11:21:22','admin1@gmail.com','Neha',_binary '\0',_binary '\0','Gupta','+919876543005','123456','ADMIN','2026-02-20 11:21:22'),(107,'2026-02-22 12:14:19','james@gmail.com','James',_binary '\0',_binary '\0','Dcosta',NULL,'123456','RESTAURANT_OWNER','2026-02-22 12:14:19'),(108,'2026-02-22 13:45:52','martha@gmail.com','Martha',_binary '\0',_binary '\0','Merchant','+919999999999','123456','RESTAURANT_OWNER','2026-02-22 13:45:52'),(109,'2026-02-22 13:49:44','david@gmail.com','David',_binary '\0',_binary '\0','M','+918888888888','123456','RESTAURANT_OWNER','2026-02-22 13:49:44'),(110,'2026-02-22 14:18:02','dream@gmail.com','Dream',_binary '\0',_binary '\0','machine','+918888888888','123456','CUSTOMER','2026-02-22 14:18:02');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-22 14:41:22
