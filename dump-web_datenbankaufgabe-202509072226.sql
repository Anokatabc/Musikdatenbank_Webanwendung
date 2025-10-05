-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: web_datenbankaufgabe
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `album`
--

DROP TABLE IF EXISTS `album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `album` (
  `albumID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `albumname` varchar(100) NOT NULL,
  `jahr` year(4) DEFAULT 2155,
  `plattformID` int(10) unsigned DEFAULT 7,
  PRIMARY KEY (`albumID`),
  UNIQUE KEY `albumname` (`albumname`),
  KEY `plattformID` (`plattformID`),
  CONSTRAINT `album_ibfk_1` FOREIGN KEY (`plattformID`) REFERENCES `erscheinungsplattform` (`plattformID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album`
--

LOCK TABLES `album` WRITE;
/*!40000 ALTER TABLE `album` DISABLE KEYS */;
INSERT INTO `album` VALUES (1,'Bound By Flame',2155,1),(2,'Deuter',2155,6),(3,'Silk Music',2155,2),(4,'One Piece',2155,1),(17,'One Piece_1757262627_6713',2155,9),(18,'One Piece_1757262676_7310',2155,1),(19,'Test',2155,10);
/*!40000 ALTER TABLE `album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artist`
--

DROP TABLE IF EXISTS `artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist` (
  `artistID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `artistname` varchar(50) NOT NULL,
  `maingenre` varchar(50) NOT NULL DEFAULT 'unassigned',
  `ortsID` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`artistID`),
  KEY `ortsID` (`ortsID`),
  KEY `idx_artistname` (`artistname`),
  CONSTRAINT `artist_ibfk_1` FOREIGN KEY (`ortsID`) REFERENCES `ort` (`ortsID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist`
--

LOCK TABLES `artist` WRITE;
/*!40000 ALTER TABLE `artist` DISABLE KEYS */;
INSERT INTO `artist` VALUES (1,'Olivier Derivière','Soundtrack',NULL),(2,'Deuter','New Age',NULL),(3,'Abd Burst','Electronic',NULL),(4,'Amarante','Electronic',NULL),(5,'City Lies','Electronic',NULL),(6,'Dan Sieg','Electronic',NULL),(7,'Dandelion','Electronic',NULL),(8,'State Azure','Electronic',NULL),(9,'Zak Rush','Electronic',NULL),(10,'Sina Vodjani','New Age',NULL),(11,'Kohei Tanaka','Soundtrack',NULL),(12,'Kohei Tanaka_1757262627_7425','unassigned',NULL),(13,'Kohei Tanaka_1757262676_8068','unassigned',NULL);
/*!40000 ALTER TABLE `artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auffuehrung`
--

DROP TABLE IF EXISTS `auffuehrung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auffuehrung` (
  `auffuehrungsID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `auffuehrungsname` varchar(100) DEFAULT 'Lokale Auffuehrung',
  `artistID` int(10) unsigned DEFAULT NULL,
  `ortsID` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`auffuehrungsID`),
  KEY `artistID` (`artistID`),
  KEY `ortsID` (`ortsID`),
  CONSTRAINT `auffuehrung_ibfk_1` FOREIGN KEY (`artistID`) REFERENCES `artist` (`artistID`) ON DELETE SET NULL,
  CONSTRAINT `auffuehrung_ibfk_2` FOREIGN KEY (`ortsID`) REFERENCES `ort` (`ortsID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auffuehrung`
--

LOCK TABLES `auffuehrung` WRITE;
/*!40000 ALTER TABLE `auffuehrung` DISABLE KEYS */;
/*!40000 ALTER TABLE `auffuehrung` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cover`
--

DROP TABLE IF EXISTS `cover`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cover` (
  `coverID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`coverID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cover`
--

LOCK TABLES `cover` WRITE;
/*!40000 ALTER TABLE `cover` DISABLE KEYS */;
INSERT INTO `cover` VALUES (1,'public/img/presets/Bound_By_Flame.jpg'),(2,'public/img/presets/Deuter.jpg'),(3,'public/img/presets/Silk_Music.jpg'),(4,'public/img/presets/One_Piece.jpg'),(5,'public/img/presets/One_Piece.jpg'),(6,'public/img/presets/One_Piece.jpg'),(7,'public/img/presets/One_Piece.jpg'),(8,'public/img/presets/One_Piece.jpg'),(9,'public/img/presets/One_Piece.jpg'),(10,'public/img/presets/One_Piece.jpg'),(11,'public/img/presets/One_Piece.jpg'),(12,'public/img/presets/One_Piece.jpg'),(13,'public/img/presets/Bound_By_Flame.jpg'),(14,'public/img/presets/Bound_By_Flame.jpg'),(15,'public/img/presets/Bound_By_Flame.jpg');
/*!40000 ALTER TABLE `cover` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erscheinungsplattform`
--

DROP TABLE IF EXISTS `erscheinungsplattform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `erscheinungsplattform` (
  `plattformID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plattformname` varchar(50) NOT NULL,
  PRIMARY KEY (`plattformID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erscheinungsplattform`
--

LOCK TABLES `erscheinungsplattform` WRITE;
/*!40000 ALTER TABLE `erscheinungsplattform` DISABLE KEYS */;
INSERT INTO `erscheinungsplattform` VALUES (1,'Soundtrack'),(2,'Youtube'),(3,'Spotify'),(4,'Soundcloud'),(5,'Apple Music'),(6,'Retail'),(7,'Unbekannt'),(8,'test'),(9,'Soundtrac'),(10,'Ne');
/*!40000 ALTER TABLE `erscheinungsplattform` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `genreID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `genrename` varchar(50) NOT NULL,
  `genrebeschreibung` varchar(100) DEFAULT 'unassigned',
  PRIMARY KEY (`genreID`),
  UNIQUE KEY `genrename` (`genrename`),
  KEY `idx_genrename` (`genrename`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'Soundtrack','Musik aus Filmen und Spielen'),(2,'Electronic','Elektronische Musik und EDM'),(3,'New Age','Entspannungs- und Meditationsmusik'),(4,'test','unassigned'),(5,'Soundtrack2_1757262627_1556','unassigned'),(6,'Soundtrack23_1757262676_8250','unassigned'),(7,'Soundtrack2','unassigned'),(8,'Soundtrac','unassigned');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `land`
--

DROP TABLE IF EXISTS `land`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `land` (
  `landID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `landname` varchar(50) NOT NULL,
  `kontinent` varchar(50) NOT NULL,
  PRIMARY KEY (`landID`),
  UNIQUE KEY `landname` (`landname`,`kontinent`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `land`
--

LOCK TABLES `land` WRITE;
/*!40000 ALTER TABLE `land` DISABLE KEYS */;
INSERT INTO `land` VALUES (1,'Deutschland','Europa'),(3,'Japan','Asien'),(2,'USA','Nordamerika');
/*!40000 ALTER TABLE `land` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mood`
--

DROP TABLE IF EXISTS `mood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mood` (
  `moodID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `moodname` varchar(50) NOT NULL,
  `moodbeschreibung` varchar(100) DEFAULT 'unassigned',
  PRIMARY KEY (`moodID`),
  UNIQUE KEY `moodname` (`moodname`),
  KEY `idx_moodname` (`moodname`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mood`
--

LOCK TABLES `mood` WRITE;
/*!40000 ALTER TABLE `mood` DISABLE KEYS */;
INSERT INTO `mood` VALUES (1,'melancholic','Melancholisch und nachdenklich'),(2,'fierce','Kraftvoll und intensiv'),(3,'meditative','Meditativ und beruhigend'),(4,'dreamlike','Verträumt und surreal'),(5,'nostalgic','Nostalgisch und erinnerungsvoll'),(6,'hopeful','Hoffnungsvoll und optimistisch'),(7,'lively','Lebhaft und energisch'),(8,'restful','Entspannend und friedlich'),(9,'cool','Cool und gelassen'),(10,'sad','Traurig und emotional'),(11,'epic','Episch und erhaben'),(12,'disharmonic','Disharmonisch und spannungsgeladen'),(13,'dreamful','Träumerisch'),(14,'building','Aufbauend und steigernd'),(15,'building_1757262627_2696','unassigned'),(16,'disharmonic_1757262676_8140','unassigned'),(17,'foreboding','unassigned'),(18,'restfuls','unassigned');
/*!40000 ALTER TABLE `mood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ort`
--

DROP TABLE IF EXISTS `ort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ort` (
  `ortsID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ortsname` varchar(50) NOT NULL,
  `landID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ortsID`),
  UNIQUE KEY `landID` (`landID`,`ortsname`),
  CONSTRAINT `ort_ibfk_1` FOREIGN KEY (`landID`) REFERENCES `land` (`landID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ort`
--

LOCK TABLES `ort` WRITE;
/*!40000 ALTER TABLE `ort` DISABLE KEYS */;
INSERT INTO `ort` VALUES (1,'Berlin',1),(2,'Los Angeles',2),(3,'Tokyo',3);
/*!40000 ALTER TABLE `ort` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setlist`
--

DROP TABLE IF EXISTS `setlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setlist` (
  `auffuehrungsID` int(10) unsigned NOT NULL,
  `songID` int(10) unsigned NOT NULL,
  `position` int(10) unsigned DEFAULT 999,
  PRIMARY KEY (`auffuehrungsID`,`songID`),
  KEY `songID` (`songID`),
  CONSTRAINT `setlist_ibfk_1` FOREIGN KEY (`auffuehrungsID`) REFERENCES `auffuehrung` (`auffuehrungsID`),
  CONSTRAINT `setlist_ibfk_2` FOREIGN KEY (`songID`) REFERENCES `song` (`songID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setlist`
--

LOCK TABLES `setlist` WRITE;
/*!40000 ALTER TABLE `setlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `setlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song` (
  `songID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `songname` varchar(50) NOT NULL,
  `kollaboration` tinyint(1) DEFAULT 0,
  `isSingle` tinyint(1) DEFAULT 0,
  `albumID` int(10) unsigned DEFAULT NULL,
  `genreID` int(10) unsigned DEFAULT NULL,
  `moodID` int(10) unsigned DEFAULT NULL,
  `coverID` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`songID`),
  KEY `coverID` (`coverID`),
  KEY `albumID` (`albumID`),
  KEY `genreID` (`genreID`),
  KEY `moodID` (`moodID`),
  KEY `idx_songname` (`songname`),
  CONSTRAINT `song_ibfk_1` FOREIGN KEY (`coverID`) REFERENCES `cover` (`coverID`) ON DELETE SET NULL,
  CONSTRAINT `song_ibfk_2` FOREIGN KEY (`albumID`) REFERENCES `album` (`albumID`) ON DELETE SET NULL,
  CONSTRAINT `song_ibfk_3` FOREIGN KEY (`genreID`) REFERENCES `genre` (`genreID`) ON DELETE SET NULL,
  CONSTRAINT `song_ibfk_4` FOREIGN KEY (`moodID`) REFERENCES `mood` (`moodID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'Exploration Atmosphere',0,0,1,1,8,15),(2,'LIFE (ft. Iré)',0,0,1,1,2,1),(3,'MiiO (ft. Iré)',0,0,1,1,1,1),(4,'Souls (ft. Iré)',0,0,1,1,2,1),(5,'Temple Music',0,0,1,1,1,1),(6,'Valvenor (Extended)',0,0,1,1,1,1),(7,'World Heart Music',0,0,1,1,1,1),(8,'Sina Vodjani - Vision Of Mahakala',0,0,2,3,3,2),(9,'Temple of Silence',0,0,2,3,3,2),(10,'Night, Snow',0,0,2,3,4,2),(11,'Slow Love',0,0,2,3,5,2),(12,'Night, Minstrels',0,0,2,3,4,2),(13,'Prelude D',0,0,2,3,5,2),(14,'Sina Vodjani - Straight to the Heart',0,0,2,3,3,2),(15,'Deuter - Silence is the Answer',0,0,2,3,3,2),(16,'Play in the Sunshine',0,0,2,3,6,2),(17,'It - Silence is the Answer (It)',0,0,2,3,3,2),(18,'Changes',0,0,3,2,7,3),(19,'Lover\'s Song ~Beaches~',0,0,3,2,7,3),(20,'Eastbound',0,0,3,2,8,3),(21,'Beatmuse',0,0,3,2,7,3),(22,'Kalabi',0,0,3,2,7,3),(23,'Something Unseen',0,0,3,2,3,3),(24,'Te Amo',0,0,3,2,8,3),(25,'Shinkenshoubu',0,0,4,1,9,4),(26,'Grand Line Island Cold',0,0,4,1,5,4),(27,'If You Live',0,0,4,1,1,4),(28,'Bet Your Life On It',0,0,4,1,1,4),(29,'Gold And Oden',0,0,4,1,1,4),(30,'Mother Sea',0,0,4,1,1,4),(31,'Peace O',0,0,4,1,13,4),(32,'Sanji\'s Theme',0,0,4,1,9,4),(33,'UunanAndTheStoneStorageRoom',0,0,4,1,10,4),(34,'Whitebeard (Difficult)',0,0,4,7,11,7),(35,'Pirate',0,0,4,1,17,11),(36,'Departure Of The King of Pirates',0,0,4,1,12,12);
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song_artist`
--

DROP TABLE IF EXISTS `song_artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song_artist` (
  `songID` int(10) unsigned NOT NULL,
  `artistID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`songID`,`artistID`),
  KEY `artistID` (`artistID`),
  CONSTRAINT `song_artist_ibfk_1` FOREIGN KEY (`songID`) REFERENCES `song` (`songID`) ON DELETE CASCADE,
  CONSTRAINT `song_artist_ibfk_2` FOREIGN KEY (`artistID`) REFERENCES `artist` (`artistID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song_artist`
--

LOCK TABLES `song_artist` WRITE;
/*!40000 ALTER TABLE `song_artist` DISABLE KEYS */;
INSERT INTO `song_artist` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,10),(9,2),(10,2),(11,2),(12,2),(13,2),(14,10),(15,2),(16,2),(17,2),(18,3),(19,4),(20,5),(21,6),(22,7),(23,8),(24,9),(25,11),(26,11),(27,11),(28,11),(29,11),(30,11),(31,11),(32,11),(33,11),(34,11),(35,11),(36,11);
/*!40000 ALTER TABLE `song_artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'web_datenbankaufgabe'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-07 22:26:13
