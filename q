[1mdiff --git a/connection.php b/connection.php[m
[1mdeleted file mode 100644[m
[1mindex 78a9c7c..0000000[m
[1m--- a/connection.php[m
[1m+++ /dev/null[m
[36m@@ -1,16 +0,0 @@[m
[31m-<?php[m
[31m-// Alle Daten, die gebraucht werden: "Du verbindest dich mit Datenbank c unter IP-Adresse a, mit Port b. Nutzer 'root' und kein Passwort"[m
[31m-$host = '127.0.0.1'; //Host angeben: Hier Localhost[m
[31m-$port = 3306; //Standard-Port XAMPPP - WSL = 3324. VM 3307 oder 3308[m
[31m-$dbname ='test-dump'; //Datenbankname gemäß "CREATE DATABASE xyz"[m
[31m-$username = 'root';[m
[31m-$password = ''; //Wenn kein Passwort gesetzt, wie bei XAMPP[m
[31m-[m
[31m-try {[m
[31m-    $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8mb4"; //alle Verbindungsparameter[m
[31m-    $pdo = new PDO($dsn, $username, $password); //alle restlichen Parameter, die PDO benötigt (erkennbar wenn man "PDO()" schreibt)[m
[31m-} catch (PDOException $e) {[m
[31m-    echo "Verbindung fehlgeschlagen: " . $e->getMessage(); //Punkt . ist Konkatenationszeichen, wie + in Java[m
[31m-}[m
[31m-?>[m
[31m-<!-- Potenzielle Verbesserung: in Funktion verpacken -->[m
\ No newline at end of file[m
[1mdiff --git a/delete.php b/delete.php[m
[1mdeleted file mode 100644[m
[1mindex b73b268..0000000[m
[1m--- a/delete.php[m
[1m+++ /dev/null[m
[36m@@ -1,52 +0,0 @@[m
[31m-<?php [m
[31m-include "connection.php";[m
[31m-[m
[31m-if ($_SERVER['REQUEST_METHOD'] === 'POST') {[m
[31m-    [m
[31m-    $songID = $_POST['songID'] ?? '';[m
[31m-    [m
[31m-    if (empty($songID)) {[m
[31m-        header("Location: index.php?error=no_song_id");[m
[31m-        exit;[m
[31m-    }[m
[31m-    [m
[31m-    try {[m
[31m-        // Song-Name für Erfolgsmeldung holen[m
[31m-        $nameStmt = $pdo->prepare("SELECT songname FROM song WHERE songID = :songID");[m
[31m-        $nameStmt->execute(['songID' => $songID]);[m
[31m-        $songname = $nameStmt->fetchColumn();[m
[31m-        [m
[31m-        if (!$songname) {[m
[31m-            throw new Exception("Song nicht gefunden");[m
[31m-        }[m
[31m-        [m
[31m-        // Transaktion starten[m
[31m-        $pdo->beginTransaction();[m
[31m-        [m
[31m-        // Song löschen (CASCADE löscht automatisch song_artist)[m
[31m-        $stmt = $pdo->prepare("DELETE FROM song WHERE songID = :songID");[m
[31m-        $stmt->execute(['songID' => $songID]);[m
[31m-        [m
[31m-        // AUTO_INCREMENT zurücksetzen[m
[31m-        $pdo->exec("ALTER TABLE song AUTO_INCREMENT = 1");[m
[31m-        [m
[31m-        if ($pdo->inTransaction()) {[m
[31m-            $pdo->commit();[m
[31m-        }[m
[31m-        header("Location: index.php?success=deleted&song=" . urlencode($songname));[m
[31m-        exit;[m
[31m-        [m
[31m-    } catch (Exception $e) {[m
[31m-        // rollback wenn Transaktion aktiv[m
[31m-        if ($pdo->inTransaction()) {[m
[31m-            $pdo->rollBack();[m
[31m-        }[m
[31m-        header("Location: index.php?error=delete_failed&msg=" . urlencode($e->getMessage()));[m
[31m-        exit;[m
[31m-    }[m
[31m-    [m
[31m-} else {[m
[31m-    header("Location: index.php?error=invalid_request");[m
[31m-    exit;[m
[31m-}[m
[31m-?>[m
\ No newline at end of file[m
[1mdiff --git a/dump-web_datenbankaufgabe-202509072226.sql b/dump-web_datenbankaufgabe-202509072226.sql[m
[1mdeleted file mode 100644[m
[1mindex f881466..0000000[m
[1m--- a/dump-web_datenbankaufgabe-202509072226.sql[m
[1m+++ /dev/null[m
[36m@@ -1,366 +0,0 @@[m
[31m--- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)[m
[31m---[m
[31m--- Host: localhost    Database: web_datenbankaufgabe[m
[31m--- ------------------------------------------------------[m
[31m--- Server version	5.5.5-10.4.32-MariaDB[m
[31m-[m
[31m-/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;[m
[31m-/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;[m
[31m-/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;[m
[31m-/*!50503 SET NAMES utf8mb4 */;[m
[31m-/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;[m
[31m-/*!40103 SET TIME_ZONE='+00:00' */;[m
[31m-/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;[m
[31m-/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;[m
[31m-/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;[m
[31m-/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `album`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `album`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `album` ([m
[31m-  `albumID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `albumname` varchar(100) NOT NULL,[m
[31m-  `jahr` year(4) DEFAULT 2155,[m
[31m-  `plattformID` int(10) unsigned DEFAULT 7,[m
[31m-  PRIMARY KEY (`albumID`),[m
[31m-  UNIQUE KEY `albumname` (`albumname`),[m
[31m-  KEY `plattformID` (`plattformID`),[m
[31m-  CONSTRAINT `album_ibfk_1` FOREIGN KEY (`plattformID`) REFERENCES `erscheinungsplattform` (`plattformID`) ON DELETE CASCADE[m
[31m-) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `album`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `album` WRITE;[m
[31m-/*!40000 ALTER TABLE `album` DISABLE KEYS */;[m
[31m-INSERT INTO `album` VALUES (1,'Bound By Flame',2155,1),(2,'Deuter',2155,6),(3,'Silk Music',2155,2),(4,'One Piece',2155,1),(17,'One Piece_1757262627_6713',2155,9),(18,'One Piece_1757262676_7310',2155,1),(19,'Test',2155,10);[m
[31m-/*!40000 ALTER TABLE `album` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `artist`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `artist`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `artist` ([m
[31m-  `artistID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `artistname` varchar(50) NOT NULL,[m
[31m-  `maingenre` varchar(50) NOT NULL DEFAULT 'unassigned',[m
[31m-  `ortsID` int(10) unsigned DEFAULT NULL,[m
[31m-  PRIMARY KEY (`artistID`),[m
[31m-  KEY `ortsID` (`ortsID`),[m
[31m-  KEY `idx_artistname` (`artistname`),[m
[31m-  CONSTRAINT `artist_ibfk_1` FOREIGN KEY (`ortsID`) REFERENCES `ort` (`ortsID`)[m
[31m-) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `artist`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `artist` WRITE;[m
[31m-/*!40000 ALTER TABLE `artist` DISABLE KEYS */;[m
[31m-INSERT INTO `artist` VALUES (1,'Olivier Derivière','Soundtrack',NULL),(2,'Deuter','New Age',NULL),(3,'Abd Burst','Electronic',NULL),(4,'Amarante','Electronic',NULL),(5,'City Lies','Electronic',NULL),(6,'Dan Sieg','Electronic',NULL),(7,'Dandelion','Electronic',NULL),(8,'State Azure','Electronic',NULL),(9,'Zak Rush','Electronic',NULL),(10,'Sina Vodjani','New Age',NULL),(11,'Kohei Tanaka','Soundtrack',NULL),(12,'Kohei Tanaka_1757262627_7425','unassigned',NULL),(13,'Kohei Tanaka_1757262676_8068','unassigned',NULL);[m
[31m-/*!40000 ALTER TABLE `artist` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `auffuehrung`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `auffuehrung`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `auffuehrung` ([m
[31m-  `auffuehrungsID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `auffuehrungsname` varchar(100) DEFAULT 'Lokale Auffuehrung',[m
[31m-  `artistID` int(10) unsigned DEFAULT NULL,[m
[31m-  `ortsID` int(10) unsigned DEFAULT NULL,[m
[31m-  PRIMARY KEY (`auffuehrungsID`),[m
[31m-  KEY `artistID` (`artistID`),[m
[31m-  KEY `ortsID` (`ortsID`),[m
[31m-  CONSTRAINT `auffuehrung_ibfk_1` FOREIGN KEY (`artistID`) REFERENCES `artist` (`artistID`) ON DELETE SET NULL,[m
[31m-  CONSTRAINT `auffuehrung_ibfk_2` FOREIGN KEY (`ortsID`) REFERENCES `ort` (`ortsID`) ON DELETE SET NULL[m
[31m-) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `auffuehrung`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `auffuehrung` WRITE;[m
[31m-/*!40000 ALTER TABLE `auffuehrung` DISABLE KEYS */;[m
[31m-/*!40000 ALTER TABLE `auffuehrung` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `cover`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `cover`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `cover` ([m
[31m-  `coverID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `link` varchar(255) DEFAULT NULL,[m
[31m-  PRIMARY KEY (`coverID`)[m
[31m-) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `cover`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `cover` WRITE;[m
[31m-/*!40000 ALTER TABLE `cover` DISABLE KEYS */;[m
[31m-INSERT INTO `cover` VALUES (1,'public/img/presets/Bound_By_Flame.jpg'),(2,'public/img/presets/Deuter.jpg'),(3,'public/img/presets/Silk_Music.jpg'),(4,'public/img/presets/One_Piece.jpg'),(5,'public/img/presets/One_Piece.jpg'),(6,'public/img/presets/One_Piece.jpg'),(7,'public/img/presets/One_Piece.jpg'),(8,'public/img/presets/One_Piece.jpg'),(9,'public/img/presets/One_Piece.jpg'),(10,'public/img/presets/One_Piece.jpg'),(11,'public/img/presets/One_Piece.jpg'),(12,'public/img/presets/One_Piece.jpg'),(13,'public/img/presets/Bound_By_Flame.jpg'),(14,'public/img/presets/Bound_By_Flame.jpg'),(15,'public/img/presets/Bound_By_Flame.jpg');[m
[31m-/*!40000 ALTER TABLE `cover` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `erscheinungsplattform`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `erscheinungsplattform`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `erscheinungsplattform` ([m
[31m-  `plattformID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `plattformname` varchar(50) NOT NULL,[m
[31m-  PRIMARY KEY (`plattformID`)[m
[31m-) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `erscheinungsplattform`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `erscheinungsplattform` WRITE;[m
[31m-/*!40000 ALTER TABLE `erscheinungsplattform` DISABLE KEYS */;[m
[31m-INSERT INTO `erscheinungsplattform` VALUES (1,'Soundtrack'),(2,'Youtube'),(3,'Spotify'),(4,'Soundcloud'),(5,'Apple Music'),(6,'Retail'),(7,'Unbekannt'),(8,'test'),(9,'Soundtrac'),(10,'Ne');[m
[31m-/*!40000 ALTER TABLE `erscheinungsplattform` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `genre`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `genre`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `genre` ([m
[31m-  `genreID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `genrename` varchar(50) NOT NULL,[m
[31m-  `genrebeschreibung` varchar(100) DEFAULT 'unassigned',[m
[31m-  PRIMARY KEY (`genreID`),[m
[31m-  UNIQUE KEY `genrename` (`genrename`),[m
[31m-  KEY `idx_genrename` (`genrename`)[m
[31m-) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `genre`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `genre` WRITE;[m
[31m-/*!40000 ALTER TABLE `genre` DISABLE KEYS */;[m
[31m-INSERT INTO `genre` VALUES (1,'Soundtrack','Musik aus Filmen und Spielen'),(2,'Electronic','Elektronische Musik und EDM'),(3,'New Age','Entspannungs- und Meditationsmusik'),(4,'test','unassigned'),(5,'Soundtrack2_1757262627_1556','unassigned'),(6,'Soundtrack23_1757262676_8250','unassigned'),(7,'Soundtrack2','unassigned'),(8,'Soundtrac','unassigned');[m
[31m-/*!40000 ALTER TABLE `genre` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `land`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `land`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `land` ([m
[31m-  `landID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `landname` varchar(50) NOT NULL,[m
[31m-  `kontinent` varchar(50) NOT NULL,[m
[31m-  PRIMARY KEY (`landID`),[m
[31m-  UNIQUE KEY `landname` (`landname`,`kontinent`)[m
[31m-) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `land`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `land` WRITE;[m
[31m-/*!40000 ALTER TABLE `land` DISABLE KEYS */;[m
[31m-INSERT INTO `land` VALUES (1,'Deutschland','Europa'),(3,'Japan','Asien'),(2,'USA','Nordamerika');[m
[31m-/*!40000 ALTER TABLE `land` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `mood`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `mood`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `mood` ([m
[31m-  `moodID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `moodname` varchar(50) NOT NULL,[m
[31m-  `moodbeschreibung` varchar(100) DEFAULT 'unassigned',[m
[31m-  PRIMARY KEY (`moodID`),[m
[31m-  UNIQUE KEY `moodname` (`moodname`),[m
[31m-  KEY `idx_moodname` (`moodname`)[m
[31m-) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `mood`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `mood` WRITE;[m
[31m-/*!40000 ALTER TABLE `mood` DISABLE KEYS */;[m
[31m-INSERT INTO `mood` VALUES (1,'melancholic','Melancholisch und nachdenklich'),(2,'fierce','Kraftvoll und intensiv'),(3,'meditative','Meditativ und beruhigend'),(4,'dreamlike','Verträumt und surreal'),(5,'nostalgic','Nostalgisch und erinnerungsvoll'),(6,'hopeful','Hoffnungsvoll und optimistisch'),(7,'lively','Lebhaft und energisch'),(8,'restful','Entspannend und friedlich'),(9,'cool','Cool und gelassen'),(10,'sad','Traurig und emotional'),(11,'epic','Episch und erhaben'),(12,'disharmonic','Disharmonisch und spannungsgeladen'),(13,'dreamful','Träumerisch'),(14,'building','Aufbauend und steigernd'),(15,'building_1757262627_2696','unassigned'),(16,'disharmonic_1757262676_8140','unassigned'),(17,'foreboding','unassigned'),(18,'restfuls','unassigned');[m
[31m-/*!40000 ALTER TABLE `mood` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `ort`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `ort`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `ort` ([m
[31m-  `ortsID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `ortsname` varchar(50) NOT NULL,[m
[31m-  `landID` int(10) unsigned NOT NULL,[m
[31m-  PRIMARY KEY (`ortsID`),[m
[31m-  UNIQUE KEY `landID` (`landID`,`ortsname`),[m
[31m-  CONSTRAINT `ort_ibfk_1` FOREIGN KEY (`landID`) REFERENCES `land` (`landID`)[m
[31m-) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `ort`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `ort` WRITE;[m
[31m-/*!40000 ALTER TABLE `ort` DISABLE KEYS */;[m
[31m-INSERT INTO `ort` VALUES (1,'Berlin',1),(2,'Los Angeles',2),(3,'Tokyo',3);[m
[31m-/*!40000 ALTER TABLE `ort` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `setlist`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `setlist`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `setlist` ([m
[31m-  `auffuehrungsID` int(10) unsigned NOT NULL,[m
[31m-  `songID` int(10) unsigned NOT NULL,[m
[31m-  `position` int(10) unsigned DEFAULT 999,[m
[31m-  PRIMARY KEY (`auffuehrungsID`,`songID`),[m
[31m-  KEY `songID` (`songID`),[m
[31m-  CONSTRAINT `setlist_ibfk_1` FOREIGN KEY (`auffuehrungsID`) REFERENCES `auffuehrung` (`auffuehrungsID`),[m
[31m-  CONSTRAINT `setlist_ibfk_2` FOREIGN KEY (`songID`) REFERENCES `song` (`songID`)[m
[31m-) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `setlist`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `setlist` WRITE;[m
[31m-/*!40000 ALTER TABLE `setlist` DISABLE KEYS */;[m
[31m-/*!40000 ALTER TABLE `setlist` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `song`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `song`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `song` ([m
[31m-  `songID` int(10) unsigned NOT NULL AUTO_INCREMENT,[m
[31m-  `songname` varchar(50) NOT NULL,[m
[31m-  `kollaboration` tinyint(1) DEFAULT 0,[m
[31m-  `isSingle` tinyint(1) DEFAULT 0,[m
[31m-  `albumID` int(10) unsigned DEFAULT NULL,[m
[31m-  `genreID` int(10) unsigned DEFAULT NULL,[m
[31m-  `moodID` int(10) unsigned DEFAULT NULL,[m
[31m-  `coverID` int(10) unsigned DEFAULT NULL,[m
[31m-  PRIMARY KEY (`songID`),[m
[31m-  KEY `coverID` (`coverID`),[m
[31m-  KEY `albumID` (`albumID`),[m
[31m-  KEY `genreID` (`genreID`),[m
[31m-  KEY `moodID` (`moodID`),[m
[31m-  KEY `idx_songname` (`songname`),[m
[31m-  CONSTRAINT `song_ibfk_1` FOREIGN KEY (`coverID`) REFERENCES `cover` (`coverID`) ON DELETE SET NULL,[m
[31m-  CONSTRAINT `song_ibfk_2` FOREIGN KEY (`albumID`) REFERENCES `album` (`albumID`) ON DELETE SET NULL,[m
[31m-  CONSTRAINT `song_ibfk_3` FOREIGN KEY (`genreID`) REFERENCES `genre` (`genreID`) ON DELETE SET NULL,[m
[31m-  CONSTRAINT `song_ibfk_4` FOREIGN KEY (`moodID`) REFERENCES `mood` (`moodID`) ON DELETE SET NULL[m
[31m-) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `song`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `song` WRITE;[m
[31m-/*!40000 ALTER TABLE `song` DISABLE KEYS */;[m
[31m-INSERT INTO `song` VALUES (1,'Exploration Atmosphere',0,0,1,1,8,15),(2,'LIFE (ft. Iré)',0,0,1,1,2,1),(3,'MiiO (ft. Iré)',0,0,1,1,1,1),(4,'Souls (ft. Iré)',0,0,1,1,2,1),(5,'Temple Music',0,0,1,1,1,1),(6,'Valvenor (Extended)',0,0,1,1,1,1),(7,'World Heart Music',0,0,1,1,1,1),(8,'Sina Vodjani - Vision Of Mahakala',0,0,2,3,3,2),(9,'Temple of Silence',0,0,2,3,3,2),(10,'Night, Snow',0,0,2,3,4,2),(11,'Slow Love',0,0,2,3,5,2),(12,'Night, Minstrels',0,0,2,3,4,2),(13,'Prelude D',0,0,2,3,5,2),(14,'Sina Vodjani - Straight to the Heart',0,0,2,3,3,2),(15,'Deuter - Silence is the Answer',0,0,2,3,3,2),(16,'Play in the Sunshine',0,0,2,3,6,2),(17,'It - Silence is the Answer (It)',0,0,2,3,3,2),(18,'Changes',0,0,3,2,7,3),(19,'Lover\'s Song ~Beaches~',0,0,3,2,7,3),(20,'Eastbound',0,0,3,2,8,3),(21,'Beatmuse',0,0,3,2,7,3),(22,'Kalabi',0,0,3,2,7,3),(23,'Something Unseen',0,0,3,2,3,3),(24,'Te Amo',0,0,3,2,8,3),(25,'Shinkenshoubu',0,0,4,1,9,4),(26,'Grand Line Island Cold',0,0,4,1,5,4),(27,'If You Live',0,0,4,1,1,4),(28,'Bet Your Life On It',0,0,4,1,1,4),(29,'Gold And Oden',0,0,4,1,1,4),(30,'Mother Sea',0,0,4,1,1,4),(31,'Peace O',0,0,4,1,13,4),(32,'Sanji\'s Theme',0,0,4,1,9,4),(33,'UunanAndTheStoneStorageRoom',0,0,4,1,10,4),(34,'Whitebeard (Difficult)',0,0,4,7,11,7),(35,'Pirate',0,0,4,1,17,11),(36,'Departure Of The King of Pirates',0,0,4,1,12,12);[m
[31m-/*!40000 ALTER TABLE `song` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Table structure for table `song_artist`[m
[31m---[m
[31m-[m
[31m-DROP TABLE IF EXISTS `song_artist`;[m
[31m-/*!40101 SET @saved_cs_client     = @@character_set_client */;[m
[31m-/*!50503 SET character_set_client = utf8mb4 */;[m
[31m-CREATE TABLE `song_artist` ([m
[31m-  `songID` int(10) unsigned NOT NULL,[m
[31m-  `artistID` int(10) unsigned NOT NULL,[m
[31m-  PRIMARY KEY (`songID`,`artistID`),[m
[31m-  KEY `artistID` (`artistID`),[m
[31m-  CONSTRAINT `song_artist_ibfk_1` FOREIGN KEY (`songID`) REFERENCES `song` (`songID`) ON DELETE CASCADE,[m
[31m-  CONSTRAINT `song_artist_ibfk_2` FOREIGN KEY (`artistID`) REFERENCES `artist` (`artistID`) ON DELETE CASCADE[m
[31m-) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;[m
[31m-/*!40101 SET character_set_client = @saved_cs_client */;[m
[31m-[m
[31m---[m
[31m--- Dumping data for table `song_artist`[m
[31m---[m
[31m-[m
[31m-LOCK TABLES `song_artist` WRITE;[m
[31m-/*!40000 ALTER TABLE `song_artist` DISABLE KEYS */;[m
[31m-INSERT INTO `song_artist` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,10),(9,2),(10,2),(11,2),(12,2),(13,2),(14,10),(15,2),(16,2),(17,2),(18,3),(19,4),(20,5),(21,6),(22,7),(23,8),(24,9),(25,11),(26,11),(27,11),(28,11),(29,11),(30,11),(31,11),(32,11),(33,11),(34,11),(35,11),(36,11);[m
[31m-/*!40000 ALTER TABLE `song_artist` ENABLE KEYS */;[m
[31m-UNLOCK TABLES;[m
[31m-[m
[31m---[m
[31m--- Dumping routines for database 'web_datenbankaufgabe'[m
[31m---[m
[31m-/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;[m
[31m-[m
[31m-/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;[m
[31m-/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;[m
[31m-/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;[m
[31m-/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;[m
[31m-/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;[m
[31m-/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;[m
[31m-/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;[m
[31m-[m
[31m--- Dump completed on 2025-09-07 22:26:13[m
[1mdiff --git a/footer.php b/footer.php[m
[1mdeleted file mode 100644[m
[1mindex 12c5cc2..0000000[m
[1m--- a/footer.php[m
[1m+++ /dev/null[m
[36m@@ -1,17 +0,0 @@[m
[31m-<footer class="footer">[m
[31m-    <div class="toTopDiv"><a href="#top" class="toTop">&emsp;&#32;<b>⇧</b> <br>   &emsp;Top</a></div>    [m
[31m-    <div class="contact">[m
[31m-        <h3>Contact</h3>[m
[31m-        <p class="information-text">Phone Number:<br>☎ 123/456789</p><br>[m
[31m-        <p class="information-text">For Business Inquiries:<br>✉ max.mustermann@beispiel.de</p><br>[m
[31m-    </div>[m
[31m-    <div class="location">[m
[31m-        <h3>Location</h3>[m
[31m-        <p class="location-text">🌍 Heidelberg-Wieblingen 69123</p>[m
[31m-        <div class="bottom-footer">[m
[31m-            <div class="copyright"><p class="copyright-text">Ⓒ 2025 Julian Voigt. All rights reserved.</p></div>[m
[31m-            <div class="decoration"></div>[m
[31m-        </div>[m
[31m-    </div>   [m
[31m-</footer>[m
[31m-    [m
\ No newline at end of file[m
[1mdiff --git a/header.php b/header.php[m
[1mdeleted file mode 100644[m
[1mindex 6565194..0000000[m
[1m--- a/header.php[m
[1m+++ /dev/null[m
[36m@@ -1,15 +0,0 @@[m
[31m-<div class="top-header">[m
[31m-    <div class="top-header-item header-item">👤 Julian Voigt</div>    [m
[31m-    <div class="top-header-item header-item">📧 julian.g.voigt@gmail.com</div>[m
[31m-    <div class="top-header-item header-item">📱 0176 / 7667 9571</div>[m
[31m-    [m
[31m-</div>[m
[31m-<header class="header">[m
[31m-    <a href="index.php"><div id="logo" class="header-logo" style="text-decoration:none;">🎼</div></a>[m
[31m-    <a href="index.php"><div id="hauptseite" class="header-logo">Hauptseite</div></a>[m
[31m-    <a href="howto.php"><div id="benutzeranleitung" class="header-logo">Benutzeranleitung</div></a>[m
[31m-</header>[m
[31m-[m
[31m-[m
[31m-<div class="background"></div>[m
[31m-<hr style="padding-bottom:2vh;">[m
\ No newline at end of file[m
[1mdiff --git a/howto.php b/howto.php[m
[1mdeleted file mode 100644[m
[1mindex b65fe77..0000000[m
[1m--- a/howto.php[m
[1m+++ /dev/null[m
[36m@@ -1,77 +0,0 @@[m
[31m-<?php include "header.php"?>[m
[31m-[m
[31m-<!DOCTYPE html>[m
[31m-<html lang="de">[m
[31m-<head>[m
[31m-    <meta charset="UTF-8">[m
[31m-    <meta name="viewport" content="width=device-width, initial-scale=1.0">[m
[31m-    <title>How-To</title>[m
[31m-    <link rel="stylesheet" href="public/css/style.css">[m
[31m-</head>[m
[31m-<body id="howTo">[m
[31m-<div style="display:inline"><h2 style="border-bottom:1px solid lightblue; text-align:center; font-size:2.5em; padding: 4% 0 2%; color:rgba(4, 0, 46, 1);">Ein kleiner Leitfaden zur Datenbank</h2>[m
[31m-</div>    [m
[31m-[m
[31m-<!-- <svg height="210" width="400" xmlns="http://www.w3.org/2000/svg">[m
[31m-  <path d="M150 5 L75 200 L225 200 Z"[m
[31m-  style="fill:none;stroke:green;stroke-width:3" />[m
[31m-</svg> -->[m
[31m-    [m
[31m-    <div class="howto-container">[m
[31m-        <div class="tutorial-section section-1">[m
[31m-            <div class="text-content">[m
[31m-                <h3>Navigation und Übersicht</h3>[m
[31m-                <p><span style="font-size: large; font-weight:500">Willkommen!</span> Ich führe Sie in drei Teilen durch die Funktionalität meiner Webseite.<br>[m
[31m-                Beginnen wir mit der Übersichtsseite. Auf diese kommen Sie zurück, wenn Sie oben auf [m
[31m-                <b>Hauptseite</b> oder auch auf das Logo 🎼 klicken.<br><br>- Die Übersichtsseite hat oben [m
[31m-                einen großen Button, mittels dessen man neue Songs in die Datenbank eintragen kann. Mehr [m
[31m-                hierzu im nächsten Teil.<br>- Die rot hervorgehobene Zeile am oberen Rand der Tabelle sind [m
[31m-                klickbare Felder, die eine Sortierfunktion beinhalten. Der erste Kick sortiert aufsteigend, [m
[31m-                der zweite absteigend.<br>- Die grün hervorgehobenen Spalten sind ebenfalls klickbar. Diese [m
[31m-                initiieren eine Filter-Funktion. Alle Lieder von diesem Album oder Künstler oder Genre oder [m
[31m-                Mood werden nun angezeigt.<br>- Schauen Sie zuletzt auf die beiden Symbole am rechten Ende [m
[31m-                jeder Zeile: <br>Der Stift ✏️ öffnet ein Modal (ein temporäres Bearbeitungsfenster) zur [m
[31m-                Veränderung von Einträgen in der Datenbank. Es wird die aktuelle Zeile bearbeitet. <br>Das [m
[31m-                Kreuz ❌ dient dem Löschen eines Datensatzes. Auch dieser behandelt die aktuell ausgewählte [m
[31m-                zeile.</p>[m
[31m-            </div>[m
[31m-            <div class="image-content">[m
[31m-            </div>[m
[31m-        </div>[m
[31m-        [m
[31m-        <div class="tutorial-section section-2">[m
[31m-            <div class="text-content">[m
[31m-                <h3>Songs hinzufügen</h3>[m
[31m-                <p>Klickt man auf den Button <b>Neuen Song hinzufügen</b>, öffnet sich ein Modal mit einem Formular. [m
[31m-                Hier lassen sich alle relevanten Metadaten und Tabellenattribute eintragen. Das einzige Pflichtfeld[m
[31m-                ist hierbei der <b>Titel*</b>, mit einem Stern gekennzeichnet. Alle anderen Einträge dürfen leer[m
[31m-            stehen. Diese können sich dann später über die Bearbeitungsfunktion einfügen lassen.<br>Zwei Radio-Buttons[m
[31m-        in der Mitte übertragen ihren Wert direkt an die Datenbank. <b>Album</b> ist vorausgewählt.<br>[m
[31m-    Am unteren Ende des Formulars ist eine Checkbox verfügbar. Per Default herrscht eine Auto-Formatierungsfunktion, [m
[31m-welche den ersten Buchstaben jedes Wortes großschreibt. Mit einem Haken in der Checkbox lässt sich diese Funktion [m
[31m-deaktivieren, um z.B. Song-Titel wie "MiiO" einzutragen. Sobald eine Kategorie mit einer ungewöhnlichen Schreibweise [m
[31m-in der Datenbank vorliegt, werden nachfolgende Einträge ungeachtet der Formatierung dieser Schreibweise angeglichen.</p>[m
[31m-            </div>[m
[31m-            <div class="image-content">[m
[31m-            </div>[m
[31m-        </div>[m
[31m-        [m
[31m-        <div class="tutorial-section section-3">[m
[31m-            <div class="text-content">[m
[31m-                <h3>Songs bearbeiten</h3>[m
[31m-                <p>Ein Klick auf den Stift ✏️ öffnet ein Bearbeitungsfenster. Hier lassen sich vorhandene [m
[31m-                    Einträge in der Datenbank ändern oder anpassen. Löscht man einfach den Inhalt eines [m
[31m-                    Feldes und drückt auf <b>Song aktualisieren</b>, so wird das Feld einfach auf <i>NULL</i> gesetzt. [m
[31m-                    <br><br>Existente Werte des jeweiligen Datensatzes werden in das Bearbeitungsfeld geladen [m
[31m-                    und sind vorausgewählt.[m
[31m-                    <br><br> Viel Erfolg![m
[31m-                </p>[m
[31m-            </div>[m
[31m-            <div class="image-content">[m
[31m-            </div>[m
[31m-        </div>[m
[31m-    </div>[m
[31m-</body>[m
[31m-</html>[m
[31m-[m
[31m-<?php include "footer.php"?>[m
\ No newline at end of file[m
[1mdiff --git a/index.php b/index.php[m
[1mdeleted file mode 100644[m
[1mindex d4f3325..0000000[m
[1m--- a/index.php[m
[1m+++ /dev/null[m
[36m@@ -1,483 +0,0 @@[m
[31m-<?php include "connection.php";?>[m
[31m-<?php include "header.php";?>[m
[31m-[m
[31m-<!DOCTYPE html>[m
[31m-<html lang="de">[m
[31m-<head>[m
[31m-    <meta charset="UTF-8">[m
[31m-    <meta name="viewport" content="width=device-width, initial-scale=1.0">[m
[31m-    <title>Musikdatenbank</title>[m
[31m-    <script defer type="text/javascript" src="private/js/main.js"></script>[m
[31m-    <link rel="stylesheet" href="public/css/style.css">[m
[31m-    <style>[m
[31m-        /* .form-column {[m
[31m-            position: relative;[m
[31m-            z-index: 10;[m
[31m-        } */[m
[31m-        /* .form-column input, [m
[31m-        .form-column textarea, [m
[31m-        .form-column select {[m
[31m-            pointer-events: auto !important;[m
[31m-            position: relative;[m
[31m-        } */[m
[31m-    </style>[m
[31m-</head>[m
[31m-<body>[m
[31m-    <header style="align-items: center; text-align: center; font-size: x-large;">[m
[31m-         <h1>Meine<br>Musikdatenbank</h1>[m
[31m-    </header>[m
[31m-[m
[31m-    <main class="content">[m
[31m-        <section>[m
[31m-            <div id="overview-header">[m
[31m-                <!-- <h2>Übersicht</h2> -->[m
[31m-                <button id="insertBtn" class="btn">Neuen Song hinzufügen</button>[m
[31m-            </div>[m
[31m-            [m
[31m-            <?php[m
[31m-            // Feedback-Nachrichten als temporäre Popups[m
[31m-            if (isset($_GET['success'])) {[m
[31m-                $successType = $_GET['success'];[m
[31m-                echo '<div id="feedbackPopup" style=" position: fixed; [m
[31m-                                                      top: 20px; [m
[31m-                                                      right: 20px; [m
[31m-                                                      background: #cce7ff; [m
[31m-                                                      color: #1a365d;[m
[31m-                                                      padding: 15px 20px;[m
[31m-                                                      border-radius: 8px;[m
[31m-                                                      border: 1px solid #90c9ff;[m
[31m-                                                      box-shadow: 0 4px 8px rgba(0,0,0,0.2);[m
[31m-                                                      z-index: 1000;[m
[31m-                                                      font-weight: bold;">';[m
[31m-                if ($successType === 'insert') {    [m
[31m-                    echo '✔ Song wurde erfolgreich hinzugefügt!';[m
[31m-                } elseif ($successType === 'update') {[m
[31m-                    echo '✏️ Song wurde erfolgreich aktualisiert!';[m
[31m-                } elseif ($successType === 'deleted') {[m
[31m-                    $songname = $_GET['song'] ?? 'Song';[m
[31m-                    echo '❌ "' . htmlspecialchars($songname) . '" wurde erfolgreich gelöscht!';[m
[31m-                }[m
[31m-                echo '</div>';[m
[31m-            }[m
[31m-            [m
[31m-            if (isset($_GET['error'])) {[m
[31m-                echo '<div id="feedbackPopup" style="position: fixed; top: 20px; right: 20px; background: #ffe6e6; color: #8b1538; padding: 15px 20px; border-radius: 8px; border: 1px solid #ff9999; box-shadow: 0 4px 8px rgba(0,0,0,0.2); z-index: 1000; font-weight: bold;">';[m
[31m-                echo '❌ ' . htmlspecialchars($_GET['error']);[m
[31m-                echo '</div>';[m
[31m-            }[m
[31m-            ?>[m
[31m-            [m
[31m-            <?php[m
[31m-            $filterColumn = null;[m
[31m-            $filterValue = null;[m
[31m-            if (!empty($_GET['filter']) && !empty($_GET['value'])) {[m
[31m-                $filterColumn = $_GET['filter'];[m
[31m-                $filterValue = $_GET['value'];[m
[31m-            }[m
[31m-            [m
[31m-            $sortColumn = $_GET['sort'] ?? 'id';[m
[31m-            $sortOrder = $_GET['order'] ?? 'asc';[m
[31m-            [m
[31m-            $validSortColumns = [[m
[31m-                'id' => 's.songID',[m
[31m-                'songname' => 's.songname',[m
[31m-                'type' => 's.isSingle',[m
[31m-                'album' => 'a.albumname',[m
[31m-                'artist' => 'ar.artistname', [m
[31m-                'genre' => 'g.genrename',[m
[31m-                'mood' => 'm.moodname',[m
[31m-                'platform' => 'ep.plattformname',[m
[31m-                'cover' => 'c.link'[m
[31m-            ];[m
[31m-            [m
[31m-            $orderByColumn = $validSortColumns[$sortColumn] ?? 's.songID';[m
[31m-            $orderByDirection = ($sortOrder === 'desc') ? 'DESC' : 'ASC';[m
[31m-            [m
[31m-            $currentParams = [];[m
[31m-            if ($filterColumn && $filterValue) {[m
[31m-                $currentParams[] = 'filter=' . urlencode($filterColumn);[m
[31m-                $currentParams[] = 'value=' . urlencode($filterValue);[m
[31m-            }[m
[31m-            $currentParamsString = implode('&', $currentParams);[m
[31m-            [m
[31m-            function getSortLink($column, $currentSort, $currentOrder, $currentParams) {[m
[31m-                $newOrder = ($currentSort === $column && $currentOrder === 'asc') ? 'desc' : 'asc';[m
[31m-                $params = [];[m
[31m-                if (!empty($currentParams)) $params[] = $currentParams;[m
[31m-                $params[] = 'sort=' . $column;[m
[31m-                $params[] = 'order=' . $newOrder;[m
[31m-                return '?' . implode('&', $params);[m
[31m-            }[m
[31m-            [m
[31m-            function getSortIcon($column, $currentSort, $currentOrder) {[m
[31m-                if ($currentSort !== $column) return '';[m
[31m-                return $currentOrder === 'asc' ? ' ⇡' : ' ⇣';[m
[31m-            }[m
[31m-            [m
[31m-            function isValidImagePath($path) {[m
[31m-                if (empty($path)) return false;[m
[31m-                [m
[31m-                if (filter_var($path, FILTER_VALIDATE_URL)) return true;[m
[31m-                [m
[31m-                $extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'];[m
[31m-                $ext = strtolower(pathinfo($path, PATHINFO_EXTENSION));[m
[31m-                return in_array($ext, $extensions);[m
[31m-            }[m
[31m-            ?>[m
[31m-            [m
[31m-            <?php if ($filterValue): ?>[m
[31m-                <div class="filter-status">[m
[31m-                    <strong>Filter aktiv:</strong> <?= htmlspecialchars(ucfirst($filterColumn)) ?> = "<?= htmlspecialchars($filterValue) ?>" [m
[31m-                    <a href="?" class="filter-reset">✕ Filter zurücksetzen</a>[m
[31m-                </div>[m
[31m-            <?php endif; ?>[m
[31m-            <div class="table-scroll-container">[m
[31m-                <table id="overview">[m
[31m-                <colgroup>[m
[31m-                    <col>  <!-- ID -->[m
[31m-                    <col>  <!-- Titel -->[m
[31m-                    <col>  <!-- Album -->[m
[31m-                    <col>  <!-- Künstler -->[m
[31m-                    <col>  <!-- Genre -->[m
[31m-                    <col>  <!-- Mood -->[m
[31m-                    <col>  <!-- Plattform -->[m
[31m-                    <col>  <!-- Cover -->[m
[31m-                    <col>  <!-- Edit -->[m
[31m-                    <col>  <!-- Delete -->[m
[31m-                </colgroup>[m
[31m-                <thead>[m
[31m-                    <tr>[m
[31m-                        <th><a href="<?= getSortLink('id', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">#<?= getSortIcon('id', $sortColumn, $sortOrder) ?></a></th>[m
[31m-                        <th><a href="<?= getSortLink('songname', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Song<?= getSortIcon('songname', $sortColumn, $sortOrder) ?></a></th>[m
[31m-                        <th><a href="<?= getSortLink('album', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Album<?= getSortIcon('album', $sortColumn, $sortOrder) ?></a></th>[m
[31m-                        <th><a href="<?= getSortLink('artist', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Künstler<?= getSortIcon('artist', $sortColumn, $sortOrder) ?></a></th>[m
[31m-                        <th><a href="<?= getSortLink('genre', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Genre<?= getSortIcon('genre', $sortColumn, $sortOrder) ?></a></th>[m
[31m-                        <th><a href="<?= getSortLink('mood', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Mood<?= getSortIcon('mood', $sortColumn, $sortOrder) ?></a></th>[m
[31m-                        <th><a href="<?= getSortLink('platform', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Plattform<?= getSortIcon('platform', $sortColumn, $sortOrder) ?></a></th>[m
[31m-                        <th><a href="<?= getSortLink('cover', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Cover<?= getSortIcon('cover', $sortColumn, $sortOrder) ?></a></th>[m
[31m-                        <th>Upd.</th>[m
[31m-                        <th>Del.</th>[m
[31m-                    </tr>[m
[31m-                </thead>[m
[31m-                <tbody>[m
[31m-                    <?php[m
[31m-                    try {[m
[31m-                        $song = "SELECT s.songID, s.songname, s.isSingle,[m
[31m-                                        a.albumname, ar.artistname, g.genrename,[m
[31m-                                        m.moodname, ep.plattformname, c.link as coverlink[m
[31m-                                FROM song s[m
[31m-                                LEFT JOIN album a ON s.albumID = a.albumID[m
[31m-                                LEFT JOIN song_artist sa ON s.songID = sa.songID[m
[31m-                                LEFT JOIN artist ar ON sa.artistID = ar.artistID[m
[31m-                                LEFT JOIN genre g ON s.genreID = g.genreID[m
[31m-                                LEFT JOIN mood m ON s.moodID = m.moodID[m
[31m-                                LEFT JOIN erscheinungsplattform ep ON a.plattformID = ep.plattformID[m
[31m-                                LEFT JOIN cover c ON s.coverID = c.coverID";[m
[31m-                        [m
[31m-                        if ($filterColumn && $filterValue) {[m
[31m-                            switch($filterColumn) {[m
[31m-                                case 'album':[m
[31m-                                    $song .= " WHERE a.albumname = " . $pdo->quote($filterValue);[m
[31m-                                    break;[m
[31m-                                case 'artist':[m
[31m-                                    $song .= " WHERE ar.artistname = " . $pdo->quote($filterValue);[m
[31m-                                    break;[m
[31m-                                case 'genre':[m
[31m-                                    $song .= " WHERE g.genrename = " . $pdo->quote($filterValue);[m
[31m-                                    break;[m
[31m-                                case 'mood':[m
[31m-                                    $song .= " WHERE m.moodname = " . $pdo->quote($filterValue);[m
[31m-                                    break;[m
[31m-                            }[m
[31m-                        }[m
[31m-                        [m
[31m-                        $song .= " ORDER BY {$orderByColumn} {$orderByDirection}";[m
[31m-                        [m
[31m-                        $stmt = $pdo->query($song);[m
[31m-                        [m
[31m-                        if ($stmt->rowCount() > 0) {[m
[31m-                            foreach ($stmt as $row) {[m
[31m-                                echo "<tr>[m
[31m-                                    <td>" . htmlspecialchars($row['songID']) . "</td>[m
[31m-                                    <td>" . htmlspecialchars($row['songname']) . "</td>[m
[31m-                                    <td>[m
[31m-                                        " . (!empty($row['albumname']) ? [m
[31m-                                            "<a href='?filter=album&value=" . urlencode($row['albumname']) . "' class='filter-link'>" . [m
[31m-                                            htmlspecialchars($row['albumname']) . "</a>" [m
[31m-                                            : '') . "[m
[31m-                                    </td>[m
[31m-                                    <td>[m
[31m-                                        " . (!empty($row['artistname']) ? [m
[31m-                                            "<a href='?filter=artist&value=" . urlencode($row['artistname']) . "' class='filter-link'>" . [m
[31m-                                            htmlspecialchars($row['artistname']) . "</a>" [m
[31m-                                            : '') . "[m
[31m-                                    </td>[m
[31m-                                    <td>[m
[31m-                                        " . (!empty($row['genrename']) ? [m
[31m-                                            "<a href='?filter=genre&value=" . urlencode($row['genrename']) . "' class='filter-link'>" . [m
[31m-                                            htmlspecialchars($row['genrename']) . "</a>" [m
[31m-                                            : '') . "[m
[31m-                                    </td>[m
[31m-                                    <td>[m
[31m-                                        " . (!empty($row['moodname']) ? [m
[31m-                                            "<a href='?filter=mood&value=" . urlencode($row['moodname']) . "' class='filter-link'>" . [m
[31m-                                            htmlspecialchars($row['moodname']) . "</a>" [m
[31m-                                            : '') . "[m
[31m-                                    </td>[m
[31m-                                    <td>" . htmlspecialchars($row['plattformname'] ?? '') . "</td>[m
[31m-                                    <td>[m
[31m-                                        " . (!empty($row['coverlink']) ? [m
[31m-                                            (isValidImagePath($row['coverlink']) ? [m
[31m-                                                "<img src='" . htmlspecialchars($row['coverlink']) . "' [m
[31m-                                                      alt='Cover' [m
[31m-                                                      class='cover-thumbnail'[m
[31m-                                                      onclick='openCoverModal(\"" . htmlspecialchars($row['coverlink']) . "\")'>" :[m
[31m-                                                "<span class='cover-text'>" . htmlspecialchars(substr($row['coverlink'], 0, 25)) . [m
[31m-                                                (strlen($row['coverlink']) > 25 ? '...' : '') . "</span>"[m
[31m-                                            ) : '') . "[m
[31m-                                    </td>[m
[31m-                                    <td>[m
[31m-                                        <button class='edit-btn' [m
[31m-                                            data-song-id='" . $row['songID'] . "'[m
[31m-                                            data-song-name='" . htmlspecialchars($row['songname']) . "'[m
[31m-                                            data-is-single='" . $row['isSingle'] . "'[m
[31m-                                            data-album-name='" . htmlspecialchars($row['albumname'] ?? '') . "'[m
[31m-                                            data-artist-name='" . htmlspecialchars($row['artistname'] ?? '') . "'[m
[31m-                                            data-genre-name='" . htmlspecialchars($row['genrename'] ?? '') . "'[m
[31m-                                            data-mood-name='" . htmlspecialchars($row['moodname'] ?? '') . "'[m
[31m-                                            data-plattform-name='" . htmlspecialchars($row['plattformname'] ?? '') . "'[m
[31m-                                            data-cover-link='" . htmlspecialchars($row['coverlink'] ?? '') . "'[m
[31m-                                            title='Bearbeiten'>✏️[m
[31m-                                        </button>[m
[31m-                                    </td>    [m
[31m-                                    <td>[m
[31m-                                        <form action='delete.php' method='POST'[m
[31m-                                            onsubmit='return confirm(\"Song ID " . $row['songID'] . " wirklich löschen?\");'>[m
[31m-                                            <input type='hidden' name='songID' value='" . $row['songID'] . "'>[m
[31m-                                            <button class='delete-btn' type='submit' title='Löschen'>❌</button>[m
[31m-                                        </form>[m
[31m-                                    </td>[m
[31m-                                </tr>";[m
[31m-                            }[m
[31m-                        } else {[m
[31m-                            echo "<tr><td colspan='6'>Keine Songs gefunden</td></tr>";[m
[31m-                        }[m
[31m-                        [m
[31m-                    } catch (PDOException $e) {[m
[31m-                        echo "<tr><td colspan='6'>Fehler beim Laden der Songs: " . htmlspecialchars($e->getMessage()) . "</td></tr>";[m
[31m-                    }[m
[31m-                    ?>[m
[31m-                </tbody>[m
[31m-            </table>[m
[31m-            </div>[m
[31m-        </section>[m
[31m-    </main>[m
[31m-[m
[31m-    <!-- Insert Modal -->[m
[31m-       <div id="insertModal" class="modal">[m
[31m-        <div class="modal-content modal-insert">[m
[31m-            <span class="close" data-modal="insertModal">&times;</span>[m
[31m-            <h2>Neuen Song hinzufügen</h2>[m
[31m-            [m
[31m-            <form id="insertForm" action="insert.php" method="POST">[m
[31m-                <span id="explainer">(▼Vorschläge aus der Datenbank)</span>  [m
[31m-                <div class="modalField-small">[m
[31m-                    <label for="song">Titel*:</label>[m
[31m-                    <input id="song" type="text" name="song" autocomplete="off" required>[m
[31m-                </div>[m
[31m-[m
[31m-                <div class="modalField-small">[m
[31m-                    <label for="album">Album:</label>[m
[31m-                    <input id="album" type="text" name="album" list="albumList" autocomplete="off">[m
[31m-                    <datalist id="albumList">[m
[31m-                        <?php[m
[31m-                        try {[m
[31m-                            $albumStmt = $pdo->query("SELECT DISTINCT albumname FROM album WHERE albumname IS NOT NULL ORDER BY albumname");[m
[31m-                            while ($album = $albumStmt->fetch()) {[m
[31m-                                echo '<option value="' . htmlspecialchars($album['albumname']) . '">';[m
[31m-                            }[m
[31m-                        } catch (PDOException $e) {[m
[31m-                            echo '<option value="Fehler beim Laden">';[m
[31m-                        }[m
[31m-                        ?>[m
[31m-                    </datalist>[m
[31m-                </div>[m
[31m-[m
[31m-                <div class="modalField-small">[m
[31m-                    <label for="artist">Artist:</label>[m
[31m-                    <input id="artist" type="text" name="artist" list="artistList" autocomplete="off">[m
[31m-                    <datalist id="artistList">[m
[31m-                        <?php[m
[31m-                        try {[m
[31m-                            $artistStmt = $pdo->query("SELECT DISTINCT artistname FROM artist WHERE artistname IS NOT NULL ORDER BY artistname");[m
[31m-                            while ($artist = $artistStmt->fetch()) {[m
[31m-                                echo '<option value="' . htmlspecialchars($artist['artistname']) . '">';[m
[31m-                            }[m
[31m-                        } catch (PDOException $e) {[m
[31m-                            echo '<option value="Fehler beim Laden">';[m
[31m-                        }[m
[31m-                        ?>[m
[31m-                    </datalist>[m
[31m-                </div>[m
[31m-[m
[31m-                <div class="modalField-small">[m
[31m-                    <label for="genre">Genre:</label>[m
[31m-                    <input id="genre" type="text" name="genre" list="genreList" autocomplete="off">[m
[31m-                    <datalist id="genreList">[m
[31m-                        <?php[m
[31m-                        try {[m
[31m-                            $genreStmt = $pdo->query("SELECT DISTINCT genrename FROM genre WHERE genrename IS NOT NULL ORDER BY genrename");[m
[31m-                            while ($genre = $genreStmt->fetch()) {[m
[31m-                                echo '<option value="' . htmlspecialchars($genre['genrename']) . '">';[m
[31m-                            }[m
[31m-                        } catch (PDOException $e) {[m
[31m-                            echo '<option value="Fehler beim Laden">';[m
[31m-                        }[m
[31m-                        ?>[m
[31m-                    </datalist>[m
[31m-                </div>[m
[31m-[m
[31m-                <div class="modalField-small">[m
[31m-                    <label for="mood">Mood:</label>[m
[31m-                    <input id="mood" type="text" name="mood" list="moodList" autocomplete="off">[m
[31m-                    <datalist id="moodList">[m
[31m-                        <?php[m
[31m-                        try {[m
[31m-                            $moodStmt = $pdo->query("SELECT DISTINCT moodname FROM mood WHERE moodname IS NOT NULL ORDER BY moodname");[m
[31m-                            while ($mood = $moodStmt->fetch()) {[m
[31m-                                echo '<option value="' . htmlspecialchars($mood['moodname']) . '">';[m
[31m-                            }[m
[31m-                        } catch (PDOException $e) {[m
[31m-                            echo '<option value="Fehler beim Laden">';[m
[31m-                        }[m
[31m-                        ?>[m
[31m-                    </datalist>[m
[31m-                </div>[m
[31m-[m
[31m-                <!-- Radio Buttons Album / Single -->[m
[31m-                <div class="modalField-radio">[m
[31m-                    <label>Typ:</label>[m
[31m-                    <input id="radio-album" type="radio" name="isSingle" value="0" checked>    [m
[31m-                    <label for="radio-album">Album</label>[m
[31m-                    <input id="radio-single" type="radio" name="isSingle" value="1">[m
[31m-                    <label for="radio-single">Single</label>[m
[31m-                </div>[m
[31m-                <div class="modalField-large">[m
[31m-                    <label for="plattform">Plattform:</label>[m
[31m-                    <input id="plattform" type="text" name="plattform" list="plattformList" autocomplete="off" placeholder="Unbekannt">[m
[31m-                    <datalist id="plattformList">[m
[31m-                        <?php[m
[31m-                        try {[m
[31m-                            $plattformStmt = $pdo->query("SELECT DISTINCT plattformname FROM erscheinungsplattform WHERE plattformname IS NOT NULL ORDER BY plattformname");[m
[31m-                            while ($plattform = $plattformStmt->fetch()) {[m
[31m-                                echo '<option value="' . htmlspecialchars($plattform['plattformname']) . '">';[m
[31m-                            }[m
[31m-                        } catch (PDOException $e) {[m
[31m-                            echo '<option value="Fehler beim Laden">';[m
[31m-                        }[m
[31m-                        ?>[m
[31m-                    </datalist>[m
[31m-                </div>[m
[31m-                    <br>[m
[31m-                <div class="modalField-large">[m
[31m-                    <label for="cover">Coverbild:</label>[m
[31m-                    <input id="cover" type="text" name="cover" autocomplete="off" placeholder="Link zu einem Bild">[m
[31m-                </div>[m
[31m-[m
[31m-                <div class="modalField-submit">[m
[31m-                    <input type="submit" value="Song hinzufügen">[m
[31m-                    <button type="button" class="cancel-btn" data-modal="insertModal">Abbrechen</button>[m
[31m-                </div>[m
[31m-[m
[31m-                <div class="form-checkbox" style="margin: 10px 0;">[m
[31m-                    <input type="checkbox" name="disable_formatting" id="disableFormatting" value="1">[m
[31m-                    <label for="disableFormatting">Auto-Formatierung deaktivieren — exakt wie eingegeben speichern. <br></label>[m
[31m-                    <span style="font-size: small;">(Unwirksam bei bereits vorhandenen gleichnamigen Einträgen.)</span>[m
[31m-                </div>[m
[31m-            </form>[m
[31m-        </div>[m
[31m-    </div>[m
[31m-[m
[31m-    <!-- Update Modal -->[m
[31m-    <div id="updateModal" class="modal">[m
[31m-                           [m
[31m-    <div class="modal-content modal-update">[m
[31m-        <h2 id="updateModalTitle">Song bearbeiten</h2> [m
[31m-            <span class="close" data-modal="updateModal">&times;</span>[m
[31m-[m
[31m-            [m
[31m-            <div class="modal-layout">[m
[31m-                <div class="form-column">[m
[31m-                    <form id="updateForm" action="update.php" method="POST">[m
[31m-                        <input type="hidden" id="updateSongID" name="songID">[m
[31m-                        <p class="modalField-small">[m
[31m-                            <label for="updateSongname">Song*:</label>[m
[31m-                            <input class="input-text" type="text" id="updateSongname" name="songname" autocomplete="off" required>[m
[31m-                        </p>[m
[31m-                        <p class="modalField-small">[m
[31m-                            <label for="updateAlbum">Album:</label>[m
[31m-                            <input class="input-text" type="text" id="updateAlbum" name="album" list="albumList" autocomplete="off">[m
[31m-                        </p>[m
[31m-                        <p class="modalField-small">[m
[31m-                            <label for="updateArtist">Artist:</label>[m
[31m-                            <input class="input-text" type="text" id="updateArtist" name="artist" list="artistList" autocomplete="off">[m
[31m-                        </p>[m
[31m-                        <p class="modalField-small">[m
[31m-                            <label for="updateGenre">Genre:</label>[m
[31m-                            <input class="input-text" type="text" id="updateGenre" name="genre" list="genreList" autocomplete="off">[m
[31m-                        </p>[m
[31m-                        <p class="modalField-small"> [m
[31m-                            <label for="updateMood">Mood:</label>[m
[31m-                            <input class="input-text" type="text" id="updateMood" name="mood" list="moodList" autocomplete="off">[m
[31m-                        </p>[m
[31m-                        <!-- Radio Buttons für isSingle -->[m
[31m-                        <p>[m
[31m-                            <div class="modalField-radio">[m
[31m-                                <label>Typ:</label>[m
[31m-                                <input id="updateRadioAlbum" type="radio" name="isSingle" value="0" checked>    [m
[31m-                                <label for="updateRadioAlbum">Album</label>[m
[31m-                                <input id="updateRadioSingle" type="radio" name="isSingle" value="1">[m
[31m-                                <label for="updateRadioSingle">Single</label>[m
[31m-                            </div>[m
[31m-                        </p>[m
[31m-                        [m
[31m-                        <p class="modalField-large">[m
[31m-                            <label for="updatePlattform">Plattform:</label>[m
[31m-                            <input class="input-text" type="text" id="updatePlattform" name="plattform" list="plattformList" autocomplete="off" placeholder="Unbekannt">[m
[31m-                        </p>[m
[31m-                        <br>[m
[31m-                        <p class="modalField-large">[m
[31m-                            <label for="updateCover">Coverbild:</label>[m
[31m-                            <input class="input-text" type="text" id="updateCover" name="cover" autocomplete="off" placeholder="Link zu einem Bild">[m
[31m-                        </p>[m
[31m-                        [m
[31m-                        <p class="modalField-submit">[m
[31m-                            <input type="submit" value="Song aktualisieren">[m
[31m-                            <button type="button" class="cancel-btn" data-modal="updateModal">Abbrechen</button>[m
[31m-                        </p>[m
[31m-                        [m
[31m-                        <div id="updateErrorMsg" class="error" style="display:none;"></div>[m
[31m-                    </form>[m
[31m-                </div>[m
[31m-                [m
[31m-                <div class="cover-column">[m
[31m-                    <div class="cover-section">[m
[31m-                        <div class="cover-title">Aktuelles Cover:</div>[m
[31m-                        <div id="currentCoverDisplay" class="cover-display">[m
[31m-                            <em>Wird geladen...</em>[m
[31m-                        </div>[m
[31m-                    </div>[m
[31m-                </div>[m
[31m-            </div>[m
[31m-        </div>[m
[31m-    </div>[m
[31m-[m
[31m-    <!-- Cover Modal -->[m
[31m-    <div id="coverModal" class="cover-modal">[m
[31m-        <span class="cover-modal-close">&times;</span>[m
[31m-        <img class="cover-modal-image" src="" alt="Cover">[m
[31m-    </div>[m
[31m-</body>[m
[31m-</html>[m
[31m-[m
[31m-<?php include "footer.php" ?>[m
\ No newline at end of file[m
[1mdiff --git a/insert.php b/insert.php[m
[1mdeleted file mode 100644[m
[1mindex 59086e6..0000000[m
[1m--- a/insert.php[m
[1m+++ /dev/null[m
[36m@@ -1,194 +0,0 @@[m
[31m-<?php [m
[31m-include "connection.php";[m
[31m-[m
[31m-if ($_SERVER['REQUEST_METHOD'] === 'POST') {[m
[31m-    try {[m
[31m-        $pdo->beginTransaction();[m
[31m-        [m
[31m-        // Song-Name required[m
[31m-        $songname = $_POST['song'] ?? '';[m
[31m-        if (empty($songname)) {[m
[31m-            throw new Exception("Song-Name ist erforderlich");[m
[31m-        }[m
[31m-[m
[31m-        $disableFormatting = isset($_POST['disable_formatting']);[m
[31m-        [m
[31m-        $isSingle = (int)($_POST['isSingle'] ?? 0);[m
[31m-        [m
[31m-        if (!$disableFormatting) {[m
[31m-            $formattedSongname = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {[m
[31m-                return strtoupper($matches[0]);[m
[31m-            }, strtolower(trim($songname)));[m
[31m-        } else {[m
[31m-            $formattedSongname = trim($songname);[m
[31m-        }[m
[31m-        [m
[31m-        $songStmt = $pdo->prepare("INSERT INTO song (songname, isSingle) VALUES (:songname, :isSingle)");[m
[31m-        $songStmt->execute(['songname' => $formattedSongname, 'isSingle' => $isSingle]);[m
[31m-        $songID = $pdo->lastInsertId();[m
[31m-        [m
[31m-        [m
[31m-        // Album verarbeiten (falls angegeben)[m
[31m-        if (!empty($_POST['album'])) {[m
[31m-            if (!$disableFormatting) {[m
[31m-                $formattedAlbum = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {[m
[31m-                    return strtoupper($matches[0]);[m
[31m-                }, strtolower(trim($_POST['album'])));[m
[31m-            } else {[m
[31m-                $formattedAlbum = trim($_POST['album']);[m
[31m-            }[m
[31m-            [m
[31m-            $albumStmt = $pdo->prepare("SELECT albumID FROM album WHERE albumname = :albumname");[m
[31m-            $albumStmt->execute(['albumname' => $formattedAlbum]);[m
[31m-            $albumID = $albumStmt->fetchColumn();[m
[31m-            [m
[31m-            if (!$albumID) {[m
[31m-                $insertAlbum = $pdo->prepare("INSERT INTO album (albumname) VALUES (:albumname)");[m
[31m-                $insertAlbum->execute(['albumname' => $formattedAlbum]);[m
[31m-                $albumID = $pdo->lastInsertId();[m
[31m-            }[m
[31m-            [m
[31m-            $pdo->prepare("UPDATE song SET albumID = :albumID WHERE songID = :songID")[m
[31m-                ->execute(['albumID' => $albumID, 'songID' => $songID]);[m
[31m-        }[m
[31m-        [m
[31m-        // Genre verarbeiten (falls angegeben)[m
[31m-        if (!empty($_POST['genre'])) {[m
[31m-            if (!$disableFormatting) {[m
[31m-                $formattedGenre = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {[m
[31m-                    return strtoupper($matches[0]);[m
[31m-                }, strtolower(trim($_POST['genre'])));[m
[31m-            } else {[m
[31m-                $formattedGenre = trim($_POST['genre']);[m
[31m-            }[m
[31m-            [m
[31m-            $genreStmt = $pdo->prepare("SELECT genreID FROM genre WHERE genrename = :genrename");[m
[31m-            $genreStmt->execute(['genrename' => $formattedGenre]);[m
[31m-            $genreID = $genreStmt->fetchColumn();[m
[31m-            [m
[31m-            if (!$genreID) {[m
[31m-                $insertGenre = $pdo->prepare("INSERT INTO genre(genrename) VALUES (:genrename)");[m
[31m-                $insertGenre->execute(['genrename' => $formattedGenre]);[m
[31m-                $genreID = $pdo->lastInsertId();[m
[31m-            }[m
[31m-            [m
[31m-            $pdo->prepare("UPDATE song SET genreID = :genreID WHERE songID = :songID")[m
[31m-                ->execute(['genreID' => $genreID, 'songID' => $songID]);[m
[31m-        }[m
[31m-        [m
[31m-        // Artist verarbeiten (falls angegeben)[m
[31m-        if (!empty($_POST['artist'])) {[m
[31m-            if (!$disableFormatting) {[m
[31m-                $formattedArtist = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {[m
[31m-                    return strtoupper($matches[0]);[m
[31m-                }, strtolower(trim($_POST['artist'])));[m
[31m-            } else {[m
[31m-                $formattedArtist = trim($_POST['artist']);[m
[31m-            }[m
[31m-            [m
[31m-            $artistStmt = $pdo->prepare("SELECT artistID FROM artist WHERE artistname = :artistname");[m
[31m-            $artistStmt->execute(['artistname' => $formattedArtist]);[m
[31m-            $artistID = $artistStmt->fetchColumn();[m
[31m-            [m
[31m-            if (!$artistID) {[m
[31m-                $insertArtist = $pdo->prepare("INSERT INTO artist (artistname) VALUES (:artistname)");[m
[31m-                $insertArtist->execute(['artistname' => $formattedArtist]);[m
[31m-                $artistID = $pdo->lastInsertId();[m
[31m-            }[m
[31m-            [m
[31m-            $pdo->prepare("INSERT INTO song_artist (songID, artistID) VALUES (:songID, :artistID)")[m
[31m-                ->execute(['songID' => $songID, 'artistID' => $artistID]);[m
[31m-        }[m
[31m-        [m
[31m-        // Mood verarbeiten (falls angegeben)[m
[31m-        if (!empty($_POST['mood'])) {[m
[31m-            if (!$disableFormatting) {[m
[31m-                $formattedMood = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {[m
[31m-                    return strtoupper($matches[0]);[m
[31m-                }, strtolower(trim($_POST['mood'])));[m
[31m-            } else {[m
[31m-                $formattedMood = trim($_POST['mood']);[m
[31m-            }[m
[31m-            [m
[31m-            $moodStmt = $pdo->prepare("SELECT moodID FROM mood WHERE moodname = :moodname");[m
[31m-            $moodStmt->execute(['moodname' => $formattedMood]);[m
[31m-            $moodID = $moodStmt->fetchColumn();[m
[31m-            [m
[31m-            if (!$moodID) {[m
[31m-                $insertMood = $pdo->prepare("INSERT INTO mood (moodname) VALUES (:moodname)");[m
[31m-                $insertMood->execute(['moodname' => $formattedMood]);[m
[31m-                $moodID = $pdo->lastInsertId();[m
[31m-            }[m
[31m-            [m
[31m-            $pdo->prepare("UPDATE song SET moodID = :moodID WHERE songID = :songID")[m
[31m-                ->execute(['songID' => $songID, 'moodID' => $moodID]);[m
[31m-        }[m
[31m-        [m
[31m-        // Plattform verarbeiten (falls angegeben)[m
[31m-        if (!empty($_POST['plattform'])) {[m
[31m-            if (!$disableFormatting) {[m
[31m-                $formattedPlattform = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {[m
[31m-                    return strtoupper($matches[0]);[m
[31m-                }, strtolower(trim($_POST['plattform'])));[m
[31m-            } else {[m
[31m-                $formattedPlattform = trim($_POST['plattform']);[m
[31m-            }[m
[31m-            [m
[31m-            $plattformStmt = $pdo->prepare("SELECT plattformID FROM erscheinungsplattform WHERE plattformname = :plattformname");[m
[31m-            $plattformStmt->execute(['plattformname' => $formattedPlattform]);[m
[31m-            $plattformID = $plattformStmt->fetchColumn();[m
[31m-            [m
[31m-            if (!$plattformID) {[m
[31m-                $insertPlattform = $pdo->prepare("INSERT INTO erscheinungsplattform (plattformname) VALUES (:plattformname)");[m
[31m-                $insertPlattform->execute(['plattformname' => $formattedPlattform]);[m
[31m-                $plattformID = $pdo->lastInsertId();[m
[31m-            }[m
[31m-            [m
[31m-            if (isset($albumID)) {[m
[31m-                $pdo->prepare("UPDATE album SET plattformID = :plattformID WHERE albumID = :albumID")[m
[31m-                    ->execute(['plattformID' => $plattformID, 'albumID' => $albumID]);[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        // Cover verarbeiten (falls angegeben)[m
[31m-    if (!empty($_POST['cover'])) {[m
[31m-    $coverLink = trim($_POST['cover']);[m
[31m-    [m
[31m-    // Cover/Link prüfen[m
[31m-    $existingCoverStmt = $pdo->prepare("SELECT coverID FROM cover WHERE link = :link");[m
[31m-    $existingCoverStmt->execute(['link' => $coverLink]);[m
[31m-    $existingCoverID = $existingCoverStmt->fetchColumn();[m
[31m-    [m
[31m-    if ($existingCoverID) {[m
[31m-        // Bestehendes Cover verwenden[m
[31m-        $coverID = $existingCoverID;[m
[31m-    } else {[m
[31m-        // Neues Cover erstellen[m
[31m-        $insertCover = $pdo->prepare("INSERT INTO cover (link) VALUES (:link)");[m
[31m-        $insertCover->execute(['link' => $coverLink]);[m
[31m-        $coverID = $pdo->lastInsertId();[m
[31m-    }[m
[31m-    [m
[31m-    $pdo->prepare("UPDATE song SET coverID = :coverID WHERE songID = :songID")[m
[31m-        ->execute(['coverID' => $coverID, 'songID' => $songID]);[m
[31m-}[m
[31m-        [m
[31m-        $pdo->commit();[m
[31m-        [m
[31m-        // Erfolgreiche Einfügung - zurück zur Hauptseite[m
[31m-        header("Location: index.php?success=insert");[m
[31m-        exit;[m
[31m-        [m
[31m-    } catch (Exception $e) {[m
[31m-        if ($pdo->inTransaction()) {[m
[31m-            $pdo->rollBack();[m
[31m-        }[m
[31m-        // Fehler - zurück zur Hauptseite mit Fehlermeldung[m
[31m-        header("Location: index.php?error=" . urlencode($e->getMessage()));[m
[31m-        exit;[m
[31m-    }[m
[31m-} else {[m
[31m-    header("Location: index.php");[m
[31m-    exit;[m
[31m-}[m
[31m-?>[m
\ No newline at end of file[m
[1mdiff --git a/other/ERM.jpg b/other/ERM.jpg[m
[1mdeleted file mode 100644[m
[1mindex c61fb84..0000000[m
Binary files a/other/ERM.jpg and /dev/null differ
[1mdiff --git a/other/K_2342_3.pdf b/other/K_2342_3.pdf[m
[1mdeleted file mode 100644[m
[1mindex 2836054..0000000[m
[1m--- a/other/K_2342_3.pdf[m
[1m+++ /dev/null[m
[36m@@ -1,97 +0,0 @@[m
[31m-Mike Mitsch | 2025 | Web |2342| Klausur: Praktisches Projekt[m
[31m-[m
[31m-KLAUSUR: PRAKTISCHES PROJEKT[m
[31m-[m
[31m-Datum: 05.06.2025[m
[31m-Dozent: Hr. Mitsch[m
[31m-Bearbeitungszeit: bis zum 07.09.2025[m
[31m-Max. Punktzahl:[m
[31m-Abgabe: zip über Wetransfer an mike.mitsch@srh.de[m
[31m-[m
[31m-Name: ______________________________________[m
[31m-[m
[31m-Gruppe: 2342[m
[31m-[m
[31m-Punktzahl: ___________[m
[31m-[m
[31m-Note:  ___________[m
[31m-[m
[31m-       DAUMEN HOCH HAT NICHTS MIT[m
[31m-          GLÜCKWÜNSCHEN ZUTUN…[m
[31m-[m
[31m-                                                              Seite 1 von 4[m
[31m-Mike Mitsch | 2025 | Web |2342| Klausur: Praktisches Projekt[m
[31m-[m
[31m-Aufgabenstellung: Webseiten-Projekt mit Datenbank und Backend-Funktionalität[m
[31m-Ziel: Erstellen Sie eine kleine Webanwendungen, die eine eigene Datenbankanbindung hat.[m
[31m-Für jedes Projekt soll ein einfaches Frontend, ein funktionales Backend und die[m
[31m-entsprechenden Datenbankaktionen (Einfügen, Bearbeiten, Löschen, Anzeigen) umgesetzt[m
[31m-werden.[m
[31m-Das Frontend soll aus einem Bild, Überschrift, Text, Liste, Link bestehen (Layout frei[m
[31m-wählbar). Das Backend kann aus einer index.php, overview.php, delete.php, insert.php,[m
[31m-update.php, sql.php bestehen. Nutzen Sie für die Datenbankanbindung die Funktion pdo. In[m
[31m-der Abfrage soll ein JOIN vorkommen. Bewertet wird das Frontend 1/3 und das Backend 2/3.[m
[31m-Nutzen Sie drei verschiedene Form-Arten (Beispiel: Input, Dropdown, Radio, Checkbox, usw.)[m
[31m-in Ihrem Projekt. Sie bekommen für die Bearbeitung Zeit im Unterricht zur Verfügung[m
[31m-gestellt. JS wird nicht von Ihnen erwartet darf aber benutzt werden.[m
[31m-[m
[31m-Projekt 1 – Festival[m
[31m-Teilnehmer: Prediger, Haidari[m
[31m-Datenbank:[m
[31m-Band (Band – Id, Bandname)[m
[31m-Bühne (Bühnen – Id, Bühnennamen)[m
[31m-Zeitslot (Zeitslot – Id, Band – Id, Bühnen – Id, Datum, Uhrzeit)[m
[31m-Ticket (Ticket – Id, Ticketdatum, Preis, Besucher – Id, Bühnen - Id)[m
[31m-Besucher (Besucher – Id, Vorname, Nachname, Geburtsdatum, E-Mail)[m
[31m-Abgabe: Datenbank, HTML, CSS, PHP, JS[m
[31m-[m
[31m-                                                                                                             Seite 2 von 4[m
[31m-Mike Mitsch | 2025 | Web |2342| Klausur: Praktisches Projekt[m
[31m-[m
[31m-Projekt 2 - Universum[m
[31m-Teilnehmer: Roth, Salfelder, Erenoglu[m
[31m-Datenbank:[m
[31m-Galaxie ( GalaxieID, GalaxieName, GalaxieTyp, DurchmesserLJ, EntfernungErdeMioLJ)[m
[31m-Sternbild( SternbildID, DeutscherName, Himmelsbereich, SternID)[m
[31m-Stern ( SternID, SternName, GalaxieID, SternbildID, MasseSonnenmassen )[m
[31m-Planet ( PlanetID, PlanetName, SternID, Planettyp )[m
[31m-Mond ( MondID, MondName, PlanetID , RAdiusKm, Entdeckungsjahr )[m
[31m-Nebel ( NebelID, NebelName, GalaxieID, Nebeltyp )[m
[31m-Abgabe: Datenbank, HTML, CSS, PHP, JS[m
[31m-[m
[31m-Projekt 3 – Tischkicker-Verwaltung[m
[31m-Teilnehmer: Krouna, Neff, Dier[m
[31m-Datenbank:[m
[31m-Spieler (SpielerID, Vorname, Nachname, Geschlecht)[m
[31m-Spiel (SpielID, Spieler1, Spieler2, Tore1, Tore2)[m
[31m-Spiel_Spieler (Spiel_SpielerID, SpielerID, SpielID)[m
[31m-Abgabe: Datenbank, HTML, CSS, PHP, JS[m
[31m-[m
[31m-                                                                                                             Seite 3 von 4[m
[31m-Mike Mitsch | 2025 | Web |2342| Klausur: Praktisches Projekt[m
[31m-[m
[31m-Projekt 4 - Dino[m
[31m-Teilnehmer: Munk, Giese, Weißbrodt, Scheuermann, Huber[m
[31m-Datenbank:[m
[31m-Ernährung (ErnährungsId, Ernährungsbezeichnung)[m
[31m-Gattung (GattungsId, Gattungsbezeichnung)[m
[31m-Dinosaurier (DinoId, Name, Körpergröße, GattungsId, ErnährungsId)[m
[31m-Kontinent (KontinentId, Kontinentbezeichnung)[m
[31m-Periode (PeriodenId, Periodenname, ZeitraumStart, ZeitraumEnde)[m
[31m-Lebensraum (LebensraumId, KontinentId, PeriodenId)[m
[31m-DinoLebensraum (LebensraumId, DinoId)[m
[31m-Abgabe: Datenbank, HTML, CSS, PHP, JS[m
[31m-[m
[31m-Projekt 5 - Musiker[m
[31m-Teilnehmer: Wahl, von Oetinger, Voigt[m
[31m-Datenbank:[m
[31m-Land (LandID, Name)[m
[31m-Genre (GenreID, Bezeichnung)[m
[31m-Plattenfirma (LabelID, Name)[m
[31m-Künstler/Band (KünstlerID, LandID, GenreID, LabelID, Name, Mitgliederanzahl)[m
[31m-Produzenten (ProduzentenID, Name, Mitgliederanzahl)[m
[31m-Zusammenarbeit (KollaboID, KünstlerID, ProduzentenID)[m
[31m-Abgabe: Datenbank, HTML, CSS, PHP, JS[m
[31m-[m
[31m-                                                                                                             Seite 4 von 4[m
[31m-[m
[1mdiff --git a/private/js/main.js b/private/js/main.js[m
[1mdeleted file mode 100644[m
[1mindex ebd610b..0000000[m
[1m--- a/private/js/main.js[m
[1m+++ /dev/null[m
[36m@@ -1,167 +0,0 @@[m
[31m-document.addEventListener('DOMContentLoaded', function() {[m
[31m-    // === FEEDBACK POPUP AUTO-HIDE ===[m
[31m-    const feedbackPopup = document.getElementById('feedbackPopup');[m
[31m-    if (feedbackPopup) {[m
[31m-        // URL-Parameter entfernen nach Popup-Anzeige[m
[31m-        const url = new URL(window.location);[m
[31m-        url.searchParams.delete('success');[m
[31m-        url.searchParams.delete('error');[m
[31m-        url.searchParams.delete('song');[m
[31m-        url.searchParams.delete('msg');[m
[31m-        window.history.replaceState({}, document.title, url);[m
[31m-        [m
[31m-        setTimeout(() => {[m
[31m-            feedbackPopup.style.opacity = '0';[m
[31m-            feedbackPopup.style.transition = 'opacity 0.5s ease';[m
[31m-            setTimeout(() => feedbackPopup.remove(), 500);[m
[31m-        }, 3000);[m
[31m-    }[m
[31m-[m
[31m-    // === MODAL SYSTEM ===[m
[31m-    const modals = {[m
[31m-        insert: document.getElementById("insertModal"),[m
[31m-        update: document.getElementById("updateModal")[m
[31m-    };[m
[31m-    [m
[31m-    // Hilfsfunktionen für modale Fenster[m
[31m-    const modalUtils = {[m
[31m-        open: function(modalId) {[m
[31m-            const modal = modals[modalId];[m
[31m-            if (modal) modal.style.display = "block";[m
[31m-        },[m
[31m-        [m
[31m-        close: function(modalId) {[m
[31m-            const modal = modals[modalId];[m
[31m-            if (modal) modal.style.display = "none";[m
[31m-        },[m
[31m-        [m
[31m-        hideAllErrors: function() {[m
[31m-            document.querySelectorAll('.error').forEach(err => {[m
[31m-                err.style.display = 'none';[m
[31m-            });[m
[31m-        }[m
[31m-    };[m
[31m-    [m
[31m-    // Trigger-Buttons einrichten[m
[31m-    document.getElementById("insertBtn")?.addEventListener('click', function() {[m
[31m-        modalUtils.open('insert');[m
[31m-    });[m
[31m-    [m
[31m-    // Edit-Buttons einrichten[m
[31m-    document.querySelectorAll('.edit-btn').forEach(button => {[m
[31m-        button.addEventListener('click', function() {[m
[31m-            // Daten aus data-Attributen holen[m
[31m-            const attributes = ['song-id', 'song-name', 'album-name', 'artist-name', 'genre-name', [m
[31m-                               'is-single', 'mood-name', 'plattform-name', 'cover-link'];[m
[31m-            const data = {};[m
[31m-            [m
[31m-            // Alle data-Attribute dynamisch extrahieren[m
[31m-            attributes.forEach(attr => {[m
[31m-                const key = attr.replace(/-([a-z])/g, g => g[1].toUpperCase());[m
[31m-                data[key] = this.getAttribute('data-' + attr) || '';[m
[31m-            });[m
[31m-            [m
[31m-            // Modal-Felder füllen[m
[31m-            document.getElementById('updateSongID').value = data.songId;[m
[31m-            document.getElementById('updateSongname').value = data.songName;[m
[31m-            document.getElementById('updateAlbum').value = data.albumName;[m
[31m-            document.getElementById('updateArtist').value = data.artistName;[m
[31m-            document.getElementById('updateGenre').value = data.genreName;[m
[31m-            document.getElementById('updateMood').value = data.moodName;[m
[31m-            document.getElementById('updatePlattform').value = data.plattformName;[m
[31m-            document.getElementById('updateCover').value = data.coverLink;[m
[31m-            [m
[31m-            // Cover-Vorschau anzeigen[m
[31m-            const coverDisplay = document.getElementById('currentCoverDisplay');[m
[31m-            if (data.coverLink && data.coverLink.trim()) {[m
[31m-                const isValidImage = /\.(jpg|jpeg|png|gif|webp|bmp|svg)$/i.test(data.coverLink) || data.coverLink.startsWith('http');[m
[31m-                [m
[31m-                if (isValidImage) {[m
[31m-                    coverDisplay.innerHTML = `<img src="${data.coverLink}" alt="Aktuelles Cover" onclick="openCoverModal('${data.coverLink}')">`;[m
[31m-                } else {[m
[31m-                    const shortLink = data.coverLink.length > 25 ? data.coverLink.substring(0, 25) + '...' : data.coverLink;[m
[31m-                    coverDisplay.innerHTML = `<span class="cover-text">${shortLink}</span>`;[m
[31m-                }[m
[31m-            } else {[m
[31m-                coverDisplay.innerHTML = '<em>Kein Cover vorhanden</em>';[m
[31m-            }[m
[31m-            [m
[31m-            // Radio-Buttons für isSingle setzen[m
[31m-            const isSingle = data.isSingle === '1';[m
[31m-            document.getElementById('updateRadioAlbum').checked = !isSingle;[m
[31m-            document.getElementById('updateRadioSingle').checked = isSingle;[m
[31m-            document.getElementById('updateModalTitle').textContent = [m
[31m-                `Song bearbeiten: ${data.songName || 'Unbekannt'}`;[m
[31m-            [m
[31m-            modalUtils.hideAllErrors();[m
[31m-            modalUtils.open('update');[m
[31m-        });[m
[31m-    });[m
[31m-    [m
[31m-    // === UNIVERSAL MODAL CLOSING ===[m
[31m-    // Alle Close-Buttons (X)[m
[31m-    document.querySelectorAll('.close').forEach(button => {[m
[31m-        button.addEventListener('click', function() {[m
[31m-            const modalId = this.getAttribute('data-modal');[m
[31m-            if (modalId === 'insertModal') modalUtils.close('insert');[m
[31m-            if (modalId === 'updateModal') modalUtils.close('update');[m
[31m-        });[m
[31m-    });[m
[31m-    [m
[31m-    // Alle Cancel-Buttons[m
[31m-    document.querySelectorAll('.cancel-btn').forEach(button => {[m
[31m-        button.addEventListener('click', function() {[m
[31m-            const modalId = this.getAttribute('data-modal');[m
[31m-            if (modalId === 'insertModal') modalUtils.close('insert');[m
[31m-            if (modalId === 'updateModal') modalUtils.close('update');[m
[31m-        });[m
[31m-    });[m
[31m-    [m
[31m-    // Modal schließen bei Klick außerhalb[m
[31m-    window.addEventListener('click', function(event) {[m
[31m-        if (event.target.classList.contains('modal')) {[m
[31m-            event.target.style.display = "none";[m
[31m-        }[m
[31m-    });[m
[31m-});[m
[31m-[m
[31m-// === COVER MODAL FUNKTIONEN ===[m
[31m-function openCoverModal(imageSrc) {[m
[31m-    const modal = document.getElementById('coverModal');[m
[31m-    const modalImage = document.querySelector('.cover-modal-image');[m
[31m-    [m
[31m-    modalImage.src = imageSrc;[m
[31m-    modal.style.display = 'block';[m
[31m-}[m
[31m-[m
[31m-function closeCoverModal() {[m
[31m-    const modal = document.getElementById('coverModal');[m
[31m-    modal.style.display = 'none';[m
[31m-}[m
[31m-[m
[31m-// Cover Modal Event Listeners[m
[31m-document.addEventListener('DOMContentLoaded', function() {[m
[31m-    const modal = document.getElementById('coverModal');[m
[31m-    const closeBtn = document.querySelector('.cover-modal-close');[m
[31m-    [m
[31m-    // Schließen-Button[m
[31m-    if (closeBtn) {[m
[31m-        closeBtn.addEventListener('click', closeCoverModal);[m
[31m-    }[m
[31m-    [m
[31m-    // Klick außerhalb des Bildes[m
[31m-    if (modal) {[m
[31m-        modal.addEventListener('click', function(event) {[m
[31m-            if (event.target === modal) {[m
[31m-                closeCoverModal();[m
[31m-            }[m
[31m-        });[m
[31m-    }[m
[31m-    [m
[31m-    // Escape-Taste[m
[31m-    document.addEventListener('keydown', function(event) {[m
[31m-        if (event.key === 'Escape' && modal && modal.style.display === 'block') {[m
[31m-            closeCoverModal();[m
[31m-        }[m
[31m-    });[m
[31m-});[m
[1mdiff --git a/private/scss/_content.scss b/private/scss/_content.scss[m
[1mdeleted file mode 100644[m
[1mindex 7f2b0fa..0000000[m
[1m--- a/private/scss/_content.scss[m
[1m+++ /dev/null[m
[36m@@ -1,1024 +0,0 @@[m
[31m-.content{[m
[31m-  *{[m
[31m-    [m
[31m-  }[m
[31m-[m
[31m-h2{[m
[31m-    font-size: 30px;[m
[31m-  }[m
[31m-#overview-header{[m
[31m-  text-align: center;[m
[31m-}[m
[31m-[m
[31m-table {[m
[31m-    margin: 0 10%;[m
[31m-    width: 80%;[m
[31m-    border-collapse: collapse;[m
[31m-    table-layout: fixed;[m
[31m-    font-size: 1.7em;[m
[31m-    border:4px groove #333;[m
[31m-    [m
[31m-    colgroup {[m
[31m-      col:nth-child(1) { width: 3%; }   // ID[m
[31m-      col:nth-child(2) { width: 12%; }  // Titel[m
[31m-      col:nth-child(3) { width: 10%; }  // Album[m
[31m-      col:nth-child(4) { width: 10%; }  // Künstler[m
[31m-      col:nth-child(5) { width: 9%; }  // Genre[m
[31m-      col:nth-child(6) { width: 9%; }  // Mood[m
[31m-      col:nth-child(7) { width: 9%; }   // Plattform[m
[31m-      col:nth-child(8) { width: 7%; }   // Cover[m
[31m-      col:nth-child(9) { width: 5%; }  // Edit (Stift)[m
[31m-      col:nth-child(10) { width: 5%; }  // Delete (X)[m
[31m-    }[m
[31m-[m
[31m- [m
[31m-   [m
[31m-  }[m
[31m-[m
[31m-  th {[m
[31m-    border-left:1px solid rgb(114, 188, 209);[m
[31m-    white-space: nowrap;[m
[31m-    .sort-link {[m
[31m-      color: inherit;[m
[31m-      text-decoration: none;[m
[31m-          [m
[31m-      &:hover {[m
[31m-        text-decoration: underline;[m
[31m-        color: #007bff;[m
[31m-      }[m
[31m-      [m
[31m-      &:visited {[m
[31m-        color: inherit;[m
[31m-      }[m
[31m-    }[m
[31m-    [m
[31m-    &:nth-child(9),  // Edit[m
[31m-    &:nth-child(10) { // Delete[m
[31m-      // font-size: x-large;[m
[31m-      // text-align: center;[m
[31m-      font-weight: bold;[m
[31m-    }[m
[31m-  }[m
[31m-[m
[31m-  td {[m
[31m-    .edit-btn .delete-btn{[m
[31m-      font-size: 10px;[m
[31m-    }[m
[31m-    padding: 0.1em 0.2em;[m
[31m-    font-size: .9em;[m
[31m-    border: 1px solid black;[m
[31m-    overflow: hidden;[m
[31m-    word-wrap: break-word;[m
[31m-    max-height: 10vh;[m
[31m-    border-top:2px groove rgb(12, 20, 31);[m
[31m-[m
[31m-[m
[31m-    &:nth-child(1) { text-align: center; }[m
[31m-    [m
[31m-    &:nth-child(8) {[m
[31m-      text-align: center;[m
[31m-      vertical-align: middle;[m
[31m-      padding: 2px !important;[m
[31m-      min-height: 60px;[m
[31m-      max-height: 80px;[m
[31m-    }[m
[31m-    [m
[31m-    a{[m
[31m-      white-space: normal !important;[m
[31m-    }[m
[31m-[m
[31m-    &:nth-child(9),  // Edit[m
[31m-    &:nth-child(10) { // Delete[m
[31m-      padding: 0;[m
[31m-      text-align: center;[m
[31m-      vertical-align: middle;[m
[31m-      width: 2% !important;[m
[31m-    }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-.cover-thumbnail {[m
[31m-  width: 100%;[m
[31m-  max-width: 70px;[m
[31m-  height: auto;[m
[31m-  aspect-ratio: 1 / 1;[m
[31m-  object-fit: cover;[m
[31m-  border-radius: 6px;[m
[31m-  border: 1px solid #ddd;[m
[31m-  cursor: pointer;[m
[31m-  transition: filter 0.2s ease, transform 0.3s ease;[m
[31m-  margin: 4px;[m
[31m-  [m
[31m-  &:hover {[m
[31m-    filter: contrast(1.18) saturate(1.2);[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-.cover-text {[m
[31m-  font-size: 0.7em;[m
[31m-  color: #666;[m
[31m-  font-style: italic;[m
[31m-  font-family: monospace;[m
[31m-  padding: 4px;[m
[31m-  text-align: center;[m
[31m-}[m
[31m-[m
[31m-.current-cover{[m
[31m-  display:inline;[m
[31m-}[m
[31m-#currentCoverDisplay{[m
[31m-  display:inline;[m
[31m-  height: 50%;[m
[31m-  width: 50%;[m
[31m-}[m
[31m-[m
[31m-@keyframes modalFadeIn {[m
[31m-  from {[m
[31m-    opacity: 0;[m
[31m-  }[m
[31m-  to {[m
[31m-    opacity: 1;[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-@keyframes modalImageZoom {[m
[31m-  from {[m
[31m-    transform: translate(-50%, -50%) scale(0.7);[m
[31m-  }[m
[31m-  to {[m
[31m-    transform: translate(-50%, -50%) scale(1);[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-.cover-modal {[m
[31m-  display: none;[m
[31m-  position: fixed;[m
[31m-  z-index: 1000;[m
[31m-  left: 0;[m
[31m-  top: 0;[m
[31m-  width: 100%;[m
[31m-  height: 100%;[m
[31m-  background-color: rgba(73, 77, 88, 0.4);[m
[31m-  animation: modalFadeIn 0.3s ease-in-out;[m
[31m-  [m
[31m-  .cover-modal-close {[m
[31m-    position: absolute;[m
[31m-    top: 15px;[m
[31m-    right: 25px;[m
[31m-    color: white;[m
[31m-    font-size: 40px;[m
[31m-    font-weight: bold;[m
[31m-    cursor: pointer;[m
[31m-    z-index: 1001;[m
[31m-    transition: opacity 0.2s ease;[m
[31m-    [m
[31m-    &:hover {[m
[31m-      opacity: 0.7;[m
[31m-    }[m
[31m-  }[m
[31m-  [m
[31m-  .cover-modal-image {[m
[31m-    position: absolute;[m
[31m-    top: 50%;[m
[31m-    left: 50%;[m
[31m-    transform: translate(-50%, -50%);[m
[31m-    max-width: 50%;[m
[31m-    max-height: 50%;[m
[31m-    border-radius: 8px;[m
[31m-    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);[m
[31m-    animation: modalImageZoom 0.4s ease-out;[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-.cover-error {[m
[31m-  font-size: 0.7em;[m
[31m-  color: #666;[m
[31m-  font-style: italic;[m
[31m-}[m
[31m-[m
[31m-button {[m
[31m-    background: none;[m
[31m-    border: none;[m
[31m-    color: inherit;[m
[31m-    font-size: inherit;[m
[31m-    cursor: pointer;[m
[31m-    padding: 1rem 1rem;[m
[31m-    margin: 2vh 0;[m
[31m-    [m
[31m-    &:hover {[m
[31m-        opacity: 0.7;[m
[31m-        background: none;[m
[31m-    }[m
[31m-    [m
[31m-    &:focus {[m
[31m-        outline: none;[m
[31m-        background: none;[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-.modal {[m
[31m-    .input-text{[m
[31m-        width:18em;[m
[31m-      }[m
[31m-    display: none;[m
[31m-    position: fixed;[m
[31m-    z-index: 1000;[m
[31m-    left: 0;[m
[31m-    top: 0;[m
[31m-    width: 100%;[m
[31m-    height: 100vh;[m
[31m-    background-color: rgba(73, 77, 88, 0.4);[m
[31m-    font-size: 1.5em;[m
[31m-  [m
[31m-    input{[m
[31m-      font-size: inherit;[m
[31m-      [m
[31m-    }[m
[31m-    [m
[31m-}[m
[31m-[m
[31m-.modal-content {[m
[31m-    background-color: #fefefe;[m
[31m-    margin: 5% auto;[m
[31m-    padding: 20px;[m
[31m-    border: 1px solid #888;[m
[31m-    width: 75%;[m
[31m-    max-width: 80%;[m
[31m-    border-radius: 5px;[m
[31m-    height:fit-content;[m
[31m-    #updateModalTitle{[m
[31m-      font-size: 1.5em;[m
[31m-      text-align: center;[m
[31m-      display:block;[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-.close {[m
[31m-    color: #aaa;[m
[31m-    float: right;[m
[31m-    font-size: 28px;[m
[31m-    font-weight: bold;[m
[31m-    cursor: pointer;[m
[31m-    line-height: 1;[m
[31m-}[m
[31m-[m
[31m-.close:hover,[m
[31m-.close:focus {[m
[31m-    color: black;[m
[31m-}[m
[31m-[m
[31m-[m
[31m-#insertForm{[m
[31m-  text-align: center;[m
[31m-[m
[31m-  .insert-label{[m
[31m-    width:fit-content[m
[31m-  }[m
[31m-  .insert-input{[m
[31m-[m
[31m-  }[m
[31m-[m
[31m-}[m
[31m-#insertModal{[m
[31m-  h2{[m
[31m-    text-align: center;[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-@media (min-width:1440px){[m
[31m-   #insertBtn{[m
[31m-    font-size: 1.8em;[m
[31m-    margin:1.5% 0 3%;[m
[31m-  }[m
[31m-.modal-content{[m
[31m-  width:50%;[m
[31m-}[m
[31m-.modal-update{[m
[31m-  width:75%;[m
[31m-}[m
[31m-.form-column{[m
[31m-  margin: 0 0 0 2em;[m
[31m-  position: relative;[m
[31m-  z-index: 10;[m
[31m-  [m
[31m-  input, textarea, select {[m
[31m-    pointer-events: auto !important;[m
[31m-    position: relative;[m
[31m-    z-index: 11;[m
[31m-  }[m
[31m-}[m
[31m-  .modal {[m
[31m-    .input-text{[m
[31m-        margin-top: 0;[m
[31m-        width:16em;[m
[31m-      }[m
[31m-    }[m
[31m-    #updateForm{[m
[31m-      margin-top: 30px;[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-@media (min-width:1000px) and (max-width:1439px){[m
[31m-  #insertBtn{[m
[31m-    font-size: 1.5em;[m
[31m-  }[m
[31m-  .modal {[m
[31m-    .input-text{[m
[31m-        width:14em;[m
[31m-      }[m
[31m-      #updateForm{[m
[31m-      margin-top: 30px;[m
[31m-    }[m
[31m-    }[m
[31m-}[m
[31m-#insertBtn{[m
[31m-      background: linear-gradient(135deg, [m
[31m-        rgb(106, 196, 255) 0%, [m
[31m-        rgba(141, 212, 255, 1) 50%, [m
[31m-        rgba(176, 228, 255, 1) 100%[m
[31m-    );[m
[31m- color: rgb(0, 16, 39);[m
[31m-    border: 2px solid rgba(0, 16, 39, 0.2);[m
[31m-    border-radius: 8px;[m
[31m-    padding: 12px 24px;[m
[31m-    [m
[31m-    font-weight: 600;[m
[31m-    cursor: pointer;[m
[31m-[m
[31m-    transition: all 0.3s ease;[m
[31m-[m
[31m-    &:hover {[m
[31m-        opacity: 1; // Überschreibt das globale 0.7[m
[31m-        background: linear-gradient(135deg, [m
[31m-            rgba(86, 176, 255, 1) 0%, [m
[31m-            rgba(121, 192, 255, 1) 50%, [m
[31m-            rgba(156, 208, 255, 1) 100%[m
[31m-        );[m
[31m-    }[m
[31m-  [m
[31m-}[m
[31m-#explainer{[m
[31m-  font-size: small;[m
[31m-  margin: 0 auto;[m
[31m-  text-align: center;[m
[31m-}[m
[31m-#updateForm {[m
[31m-  .modalField-small{[m
[31m-    display:flex;[m
[31m-    align-items:center;[m
[31m-    label{[m
[31m-      flex: 0 0 3.2em;[m
[31m-      text-align: left;[m
[31m-      // padding-right: .1em;[m
[31m-    }[m
[31m-  }[m
[31m-  .modalField-radio{[m
[31m-    display: flex;[m
[31m-    text-align: center;[m
[31m-    gap: 1em;[m
[31m-    [m
[31m-    label {[m
[31m-      flex: 0 0 3em;[m
[31m-      text-align: left;[m
[31m-      padding-right: .1em;[m
[31m-    }[m
[31m-    [m
[31m-    .radio-group {[m
[31m-      display: flex;[m
[31m-      gap: 1em;[m
[31m-      align-items: center;[m
[31m-    }[m
[31m-  }[m
[31m-  .modalField-large{[m
[31m-    display: inline-flex;[m
[31m-    align-items: center;[m
[31m-    label{[m
[31m-      flex: 0 0 3em;[m
[31m-      text-align: left;[m
[31m-      padding-right: .1em;[m
[31m-    }[m
[31m-    input {[m
[31m-      flex: 1;[m
[31m-    }[m
[31m-  }[m
[31m-  .modalField-submit{[m
[31m-    display: block;[m
[31m-    margin-top: 1em;[m
[31m-  }[m
[31m-  .cover-section{[m
[31m-    text-align: end;[m
[31m-    align-items: end;[m
[31m-    align-content: end;[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-.modal-layout{[m
[31m-  display:flex;[m
[31m-  // justify-content: space-between;[m
[31m-  // gap:2%;[m
[31m-  .cover-column{[m
[31m-   width: 100%;[m
[31m-   align-content: center;[m
[31m-   text-align: center;[m
[31m-   margin: 0 0 5%;[m
[31m-   img{[m
[31m-    width:50%;[m
[31m-   }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-.filter-navigation {[m
[31m-    margin-bottom: 20px;[m
[31m-    border: 1px solid #ddd;[m
[31m-    border-radius: 6px;[m
[31m-    background: #f8f9fa;[m
[31m-}[m
[31m-[m
[31m-.filter-menu {[m
[31m-    list-style: none;[m
[31m-    margin: 0;[m
[31m-    padding: 0;[m
[31m-    display: flex;[m
[31m-    flex-wrap: wrap;[m
[31m-    position: relative;[m
[31m-    align-items: center;[m
[31m-}[m
[31m-[m
[31m-.filter-link {[m
[31m-    // display: block;[m
[31m-    color: #122755; [m
[31m-    text-decoration: none;[m
[31m-    background: transparent;[m
[31m-    transition: all 0.2s ease;[m
[31m-    white-space: nowrap;[m
[31m-        [m
[31m-    &:hover {[m
[31m-        // background: #e9ecef;[m
[31m-        text-decoration: underline dashed;[m
[31m-        color: #007bff !important;[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-.filter-item {[m
[31m-    position: relative;[m
[31m-    [m
[31m-    &:not(:last-child) {[m
[31m-        border-right: 1px solid #ddd;[m
[31m-    }[m
[31m-    [m
[31m-    [m
[31m-    [m
[31m-    &.active .filter-link {[m
[31m-        background: #007bff;[m
[31m-        color: white;[m
[31m-    }[m
[31m-    [m
[31m-    &.has-submenu {[m
[31m-        .filter-link::after {[m
[31m-            content: '';[m
[31m-            margin-left: 5px;[m
[31m-        }[m
[31m-        [m
[31m-        &:hover .submenu {[m
[31m-            display: block;[m
[31m-            animation: submenuFadeIn 0.2s ease-out;[m
[31m-        }[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-.submenu {[m
[31m-    display: none;[m
[31m-    position: absolute;[m
[31m-    top: 100%;[m
[31m-    left: 0;[m
[31m-    min-width: 250px;[m
[31m-    max-width: 350px;[m
[31m-    background: white;[m
[31m-    border: 1px solid #ddd;[m
[31m-    border-radius: 4px;[m
[31m-    box-shadow: 0 4px 12px rgba(0,0,0,0.15);[m
[31m-    z-index: 1000;[m
[31m-    max-height: 300px;[m
[31m-    overflow-y: auto;[m
[31m-    [m
[31m-    li {[m
[31m-        list-style: none;[m
[31m-        border-bottom: 1px solid #f0f0f0;[m
[31m-        [m
[31m-        &:last-child {[m
[31m-            border-bottom: none;[m
[31m-        }[m
[31m-        [m
[31m-        a {[m
[31m-            display: block;[m
[31m-            padding: 10px 15px;[m
[31m-            color: #495057;[m
[31m-            text-decoration: none;[m
[31m-            font-size: 14px;[m
[31m-            transition: background 0.2s ease;[m
[31m-            [m
[31m-            &:hover {[m
[31m-                background: #f8f9fa;[m
[31m-                color: #007bff;[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        &.submenu-loading {[m
[31m-            padding: 15px;[m
[31m-            text-align: center;[m
[31m-            color: #6c757d;[m
[31m-            font-style: italic;[m
[31m-        }[m
[31m-        [m
[31m-        &.no-items {[m
[31m-            padding: 15px;[m
[31m-            text-align: center;[m
[31m-            color: #6c757d;[m
[31m-        }[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-@keyframes submenuFadeIn {[m
[31m-    from {[m
[31m-        opacity: 0;[m
[31m-        transform: translateY(-10px);[m
[31m-    }[m
[31m-    to {[m
[31m-        opacity: 1;[m
[31m-        transform: translateY(0);[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-@media (min-width:1000px){[m
[31m-  .filter-status{[m
[31m-    font-size: 1.5em;[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-.filter-status {[m
[31m-    background: #e3f2fd;[m
[31m-    padding: 10px 15px;[m
[31m-    border-radius: 4px;[m
[31m-    margin:20px auto;[m
[31m-    display: fit-content;[m
[31m-    width: 35%;[m
[31m-text-align: center;[m
[31m-    gap: 3rem;[m
[31m-    border-left: 4px solid #2196f3;[m
[31m-    [m
[31m-    .filter-reset{[m
[31m-      display:block;[m
[31m-      text-align: center;[m
[31m-      font-weight: 525;[m
[31m-      text-decoration: none;[m
[31m-      &:hover{[m
[31m-        text-decoration: underline;[m
[31m-      }[m
[31m-    }[m
[31m-[m
[31m-    .status-text {[m
[31m-        color: #1565c0;[m
[31m-        [m
[31m-    }[m
[31m-    [m
[31m-    .clear-filter-btn {[m
[31m-        background: #ff5722;[m
[31m-        color: white;[m
[31m-        border: none;[m
[31m-        padding: 5px 10px;[m
[31m-        border-radius: 3px;[m
[31m-        cursor: pointer;[m
[31m-        font-size: 12px;[m
[31m-        [m
[31m-        &:hover {[m
[31m-            background: #d84315;[m
[31m-        }[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-.songs-container {[m
[31m-    .no-data {[m
[31m-        text-align: center;[m
[31m-        padding: 3em;[m
[31m-        color: #6c757d;[m
[31m-        font-style: italic;[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-.songs-counter {[m
[31m-    text-align: right;[m
[31m-    margin-top: 10px;[m
[31m-    padding: 10px;[m
[31m-    background: #f8f9fa;[m
[31m-    border-radius: 4px;[m
[31m-    color: #495057;[m
[31m-    font-weight: bold;[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 768px) {[m
[31m-    .filter-menu {[m
[31m-        flex-direction: column;[m
[31m-    }[m
[31m-[m
[31m-      .modal{[m
[31m-    input{[m
[31m-      width:7em;[m
[31m-    }[m
[31m-  }[m
[31m-    [m
[31m-    .filter-item {[m
[31m-        border-right: none !important;[m
[31m-        border-bottom: 1px solid #ddd;[m
[31m-        [m
[31m-        &:last-child {[m
[31m-            border-bottom: none;[m
[31m-        }[m
[31m-    }[m
[31m-    [m
[31m-    .submenu {[m
[31m-        position: static;[m
[31m-        display: none;[m
[31m-        box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);[m
[31m-        max-height: 200px;[m
[31m-    }[m
[31m-    [m
[31m-    .filter-item.has-submenu:hover .submenu {[m
[31m-        display: block;[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-[m
[31m-[m
[31m-@media (max-width: 1439px) {[m
[31m-[m
[31m-.modal-layout{[m
[31m-  display:flex;[m
[31m-  // justify-content: space-between;[m
[31m-  // gap:2%;[m
[31m-  .cover-column{[m
[31m-   width: 100%;[m
[31m-   align-content: center;[m
[31m-   text-align: center;[m
[31m-   margin: 0 0 5%;[m
[31m-   img{[m
[31m-    width:65%;[m
[31m-   }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-  .content {[m
[31m-    width: 100%;[m
[31m-    [m
[31m-    section {  [m
[31m-      width: 100%;[m
[31m-      overflow-x: auto;[m
[31m-      overflow-y: visible;[m
[31m-      margin: 0 auto;[m
[31m-      [m
[31m-      &::-webkit-scrollbar {[m
[31m-        height: 8px;[m
[31m-      }[m
[31m-      [m
[31m-      &::-webkit-scrollbar-track {[m
[31m-        background: #f1f1f1;[m
[31m-        border-radius: 4px;[m
[31m-      }[m
[31m-      [m
[31m-      &::-webkit-scrollbar-thumb {[m
[31m-        background: #c1c1c1;[m
[31m-        border-radius: 4px;[m
[31m-        [m
[31m-        &:hover {[m
[31m-          background: #a8a8a8;[m
[31m-        }[m
[31m-      }[m
[31m-    }[m
[31m-    [m
[31m-    table {[m
[31m-      min-width: 1000px;[m
[31m-      font-size: 1.75em;[m
[31m-      margin: 0 auto;[m
[31m-      width: 750px;[m
[31m-      [m
[31m-      th, td {[m
[31m-        padding: 0.15rem;[m
[31m-        font-size: 0.75em;[m
[31m-      }[m
[31m-      [m
[31m-      colgroup {[m
[31m-        col:nth-child(1) { width: 4%; }   // ID[m
[31m-        col:nth-child(2) { width: 10%; }  // Titel[m
[31m-        col:nth-child(3) { width: 10%; }  // Album [m
[31m-        col:nth-child(4) { width: 8%; }  // Künstler[m
[31m-        col:nth-child(5) { width: 8%; }  // Genre[m
[31m-        col:nth-child(6) { width: 8%; }  // Mood[m
[31m-        col:nth-child(7) { width: 10%; }  // Plattform[m
[31m-        col:nth-child(8) { width: 10%; }   // Cover[m
[31m-        col:nth-child(9) { width: 8%; }   // Edit[m
[31m-        col:nth-child(10) { width: 8%; }  // Delete[m
[31m-      }[m
[31m-    }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 1000px) {[m
[31m-  .modal{[m
[31m-    .input-text{[m
[31m-      width:12em;[m
[31m-    }[m
[31m-    #updateForm{[m
[31m-      margin-top: 15px;[m
[31m-    }[m
[31m-  }[m
[31m-.input-text{[m
[31m-[m
[31m-}[m
[31m-#insertForm{[m
[31m-[m
[31m-}[m
[31m-#insertModal{[m
[31m-[m
[31m-}[m
[31m-.modal-content{[m
[31m-[m
[31m-}[m
[31m-.modalField-radio{[m
[31m-  padding:0;[m
[31m-  display:flex;[m
[31m-  width:50%;[m
[31m-  margin: 0 auto;[m
[31m-}[m
[31m-.form-checkbox{[m
[31m-  margin:0;[m
[31m-  padding:0;[m
[31m-  display:flex;[m
[31m-  flex-direction: row;[m
[31m-  flex-wrap: nowrap;[m
[31m-  font-size:.8em;[m
[31m-}[m
[31m-    .modal{[m
[31m-    input{[m
[31m-      width:12em;[m
[31m-    }[m
[31m-  }[m
[31m-  .modal-content{[m
[31m-      #updateModalTitle{[m
[31m-      font-size: 1em;[m
[31m-    }[m
[31m-  }[m
[31m-  .modal-layout{[m
[31m-  display:flex;[m
[31m-  // justify-content: space-between;[m
[31m-  // gap:2%;[m
[31m-   [m
[31m-  .cover-column{[m
[31m-        width: 45%;[m
[31m-        align-content: end;[m
[31m-        text-align: end;[m
[31m-        margin: 0px 0px 0%;[m
[31m-        position: relative;[m
[31m-        bottom: 0.5em;[m
[31m-        right: .5em;[m
[31m-   img{[m
[31m-    width:50%;[m
[31m-   }[m
[31m-  }[m
[31m-  .form-column{[m
[31m-    width: 45%;[m
[31m-    display:inline;[m
[31m-    form{[m
[31m-      display:inherit;[m
[31m-    }[m
[31m-    #updateForm{[m
[31m-      width:40%;[m
[31m-    }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-  .content {[m
[31m-    width: 100%;[m
[31m-    [m
[31m-    section {  [m
[31m-      width: 100%;[m
[31m-      overflow-x: auto;[m
[31m-      overflow-y: visible;[m
[31m-      margin: 0 auto;[m
[31m-      [m
[31m-      &::-webkit-scrollbar {[m
[31m-        height: 8px;[m
[31m-      }[m
[31m-      [m
[31m-      &::-webkit-scrollbar-track {[m
[31m-        background: #f1f1f1;[m
[31m-        border-radius: 4px;[m
[31m-      }[m
[31m-      [m
[31m-      &::-webkit-scrollbar-thumb {[m
[31m-        background: #c1c1c1;[m
[31m-        border-radius: 4px;[m
[31m-        [m
[31m-        &:hover {[m
[31m-          background: #a8a8a8;[m
[31m-        }[m
[31m-      }[m
[31m-    }[m
[31m-    [m
[31m-    table {[m
[31m-      min-width: 850px;[m
[31m-      font-size: 1.5em;[m
[31m-      margin: 0 0 0 5%;[m
[31m-      width: 750px;[m
[31m-      [m
[31m-      td {[m
[31m-        padding: 0.15rem;[m
[31m-        font-size: 1em;[m
[31m-        &:nth-child(8) &:nth-child(7) {[m
[31m-          display: none;[m
[31m-        }[m
[31m-      }[m
[31m-      th {[m
[31m-        &:nth-child(8) &:nth-child(7) { [m
[31m-          display: none;[m
[31m-        }[m
[31m-        font-size: .8em;[m
[31m-      }[m
[31m-      [m
[31m-      colgroup {[m
[31m-        col:nth-child(1) { width: 4%; }   // ID[m
[31m-        col:nth-child(2) { width: 14%; }  // Titel[m
[31m-        col:nth-child(3) { width: 13%; }  // Album [m
[31m-        col:nth-child(4) { width: 13%; }  // Künstler[m
[31m-        col:nth-child(5) { width: 10%; }  // Genre[m
[31m-        col:nth-child(6) { width: 10%; }  // Mood[m
[31m-        col:nth-child(7) { width: 0%; }  // Plattform[m
[31m-        col:nth-child(8) { width: 0%; }   // Cover[m
[31m-        col:nth-child(9) { width: 8%; }   // Edit [m
[31m-        col:nth-child(10) { width: 8%; }  // Delete [m
[31m-      }[m
[31m-    }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 600px) {[m
[31m-  .modal{[m
[31m-    .input-text{[m
[31m-      width:10em;[m
[31m-    }[m
[31m-  }[m
[31m-  .modal{[m
[31m-    input{[m
[31m-      width:10em;[m
[31m-    }[m
[31m-  }[m
[31m-#insertForm{[m
[31m-    .modalField-submit{[m
[31m-    margin:5px;[m
[31m-    padding:5px;[m
[31m-    display:flex;[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-.modal-layout{[m
[31m-  display:flex;[m
[31m-  // justify-content: space-between;[m
[31m-  // gap:2%;[m
[31m-  .cover-column{[m
[31m-    .cover-title{[m
[31m-      font-size:.7em;[m
[31m-    }[m
[31m-        width: 45%;[m
[31m-        align-content: end;[m
[31m-        text-align: end;[m
[31m-        margin: 0px 0px 0%;[m
[31m-        position: relative;[m
[31m-        bottom: 0.5em;[m
[31m-        right: .5em;[m
[31m-   img{[m
[31m-    width:50%;[m
[31m-   }[m
[31m-  }[m
[31m-  .form-column{[m
[31m-    width: 45%;[m
[31m-    display:inline;[m
[31m-    form{[m
[31m-      display:inherit;[m
[31m-    }[m
[31m-    #updateForm{[m
[31m-      width:40%;[m
[31m-    }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-  .content {[m
[31m-    width: 100%;[m
[31m-    [m
[31m-    font-size: 1em;[m
[31m-    section {  [m
[31m-      width: 100%;[m
[31m-      overflow-x: auto;[m
[31m-      overflow-y: visible;[m
[31m-      margin: 0 0 0 5%;[m
[31m-      [m
[31m-      -webkit-overflow-scrolling: touch;[m
[31m-      [m
[31m-      &::-webkit-scrollbar {[m
[31m-        height: 8px;[m
[31m-      }[m
[31m-      [m
[31m-      &::-webkit-scrollbar-track {[m
[31m-        background: #f1f1f1;[m
[31m-        border-radius: 4px;[m
[31m-      }[m
[31m-      [m
[31m-      &::-webkit-scrollbar-thumb {[m
[31m-        background: #c1c1c1;[m
[31m-        border-radius: 4px;[m
[31m-        [m
[31m-        &:hover {[m
[31m-          background: #a8a8a8;[m
[31m-        }[m
[31m-      }[m
[31m-    }[m
[31m-    [m
[31m-    table {[m
[31m-      min-width: 600px;[m
[31m-      margin: 0 0 0 15%;[m
[31m-      width: 700px;[m
[31m-      font-size: 1.4em;[m
[31m-      [m
[31m-      th, td{[m
[31m-        padding: 0.1rem;[m
[31m-        [m
[31m-        &:nth-child(1),  // ID[m
[31m-        &:nth-child(7),  // Platform  [m
[31m-        &:nth-child(8) { // Cover[m
[31m-          display: none;[m
[31m-        }[m
[31m-      }[m
[31m-      th{[m
[31m-        font-size: .7em;[m
[31m-      }[m
[31m-      td{[m
[31m-        font-size: .8em;[m
[31m-      }[m
[31m-      [m
[31m-      colgroup {[m
[31m-        col:nth-child(1) { width: 0%; }   // ID [m
[31m-        col:nth-child(2) { width: 13%; }  // Titel[m
[31m-        col:nth-child(3) { width: 10%; }  // Album [m
[31m-        col:nth-child(4) { width: 10%; }  // Künstler[m
[31m-        col:nth-child(5) { width: 10%; }  // Genre[m
[31m-        col:nth-child(6) { width: 10%; }  // Mood[m
[31m-        col:nth-child(7) { width: 0%; }   // Plattform[m
[31m-        col:nth-child(8) { width: 0%; }   // Cover[m
[31m-        col:nth-child(9) { width: 9%; }   // Edit [m
[31m-        col:nth-child(10) { width: 9%; }  // Delete [m
[31m-      }[m
[31m-    }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 480px) {[m
[31m-  .modal{[m
[31m-    .input-text{[m
[31m-      width:7em;[m
[31m-    }[m
[31m-  }[m
[31m-[m
[31m-  .modalField-radio{[m
[31m-  padding:0;[m
[31m-  display:flex;[m
[31m-  width:50%;[m
[31m-  margin: 0 0 0 -15px;[m
[31m-}[m
[31m-[m
[31m-  .content {[m
[31m-    section {  [m
[31m-      table {[m
[31m-        min-width: 450px;[m
[31m-        width: 600px;[m
[31m-        margin: 0 0 0 15%;[m
[31m-        [m
[31m-        td {[m
[31m-          font-size: 1em;[m
[31m-        }[m
[31m-        th {[m
[31m-          font-size: 0.8em;[m
[31m-        }[m
[31m-        [m
[31m-        colgroup {[m
[31m-          col:nth-child(1) { width: 0%; } [m
[31m-          col:nth-child(2) { width: 11%; }[m
[31m-          col:nth-child(3) { width: 11%; }[m
[31m-          col:nth-child(4) { width: 11%; }[m
[31m-          col:nth-child(5) { width: 11%; }[m
[31m-          col:nth-child(6) { width: 11%; } [m
[31m-          col:nth-child(7) { width: 0%; } [m
[31m-          col:nth-child(8) { width: 0%; } [m
[31m-          col:nth-child(9) { width: 5%; } [m
[31m-          col:nth-child(10) { width: 5%; }[m
[31m-        }[m
[31m-      }[m
[31m-    }[m
[31m-  }[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/private/scss/_footer.scss b/private/scss/_footer.scss[m
[1mdeleted file mode 100644[m
[1mindex 4d9a0b0..0000000[m
[1m--- a/private/scss/_footer.scss[m
[1m+++ /dev/null[m
[36m@@ -1,177 +0,0 @@[m
[31m-.footer {[m
[31m-    background-color: rgb(106, 196, 255);[m
[31m-    color: rgb(0, 16, 39);[m
[31m-    height: fit-content;[m
[31m-    margin: 5% 0 0;[m
[31m-    padding: 3% 5%;[m
[31m-    width: 100%;[m
[31m-    box-sizing: border-box;[m
[31m-    position: relative;[m
[31m-    [m
[31m-    display: flex;[m
[31m-    justify-content: space-between;[m
[31m-    align-items: flex-start;[m
[31m-    gap: 2rem;[m
[31m-    [m
[31m-    // Top-Link[m
[31m-    .toTopDiv {[m
[31m-        position: absolute;[m
[31m-        top: 15px;[m
[31m-        right: 20px;[m
[31m-        [m
[31m-        .toTop {[m
[31m-            color: rgb(0, 2, 34);[m
[31m-            text-decoration: none;[m
[31m-            font-size: 14px;[m
[31m-            text-align: center;[m
[31m-            display: inline-block;[m
[31m-            line-height: 1.2;[m
[31m-            padding: 8px 12px;[m
[31m-            border-radius: 4px;[m
[31m-            [m
[31m-            &:hover {[m
[31m-                text-decoration: none;[m
[31m-                font-weight: bold;[m
[31m-                font-size: larger;[m
[31m-            }[m
[31m-            [m
[31m-            b {[m
[31m-                font-size: 18px;[m
[31m-            }[m
[31m-        }[m
[31m-    }[m
[31m-    [m
[31m-    // Contact Section (Links)[m
[31m-    .contact {[m
[31m-        flex: 1;[m
[31m-        max-width: 45%;[m
[31m-        [m
[31m-        h3 {[m
[31m-            color: #00021d;[m
[31m-            font-size: 1.3em;[m
[31m-            margin: 0 0 1rem 0;[m
[31m-            font-weight: 600;[m
[31m-            border-bottom: 2px solid rgba(255, 255, 255, 0.3);[m
[31m-            padding-bottom: 0.5rem;[m
[31m-        }[m
[31m-        [m
[31m-        .information-text {[m
[31m-            margin: 0 0 1rem 0;[m
[31m-            line-height: 1.5;[m
[31m-            font-size: 0.95em;[m
[31m-            color: #00021d;[m
[31m-            [m
[31m-[m
[31m-        }[m
[31m-    }[m
[31m-    [m
[31m-    // Location Section (Rechts)[m
[31m-    .location {[m
[31m-        flex: 1;[m
[31m-        max-width: 45%;[m
[31m-        [m
[31m-        h3 {[m
[31m-            color: #00021d;[m
[31m-            font-size: 1.3em;[m
[31m-            margin: 0 0 1rem 0;[m
[31m-            font-weight: 600;[m
[31m-            border-bottom: 2px solid rgba(255, 255, 255, 0.3);[m
[31m-            padding-bottom: 0.5rem;[m
[31m-        }[m
[31m-        [m
[31m-        .location-text {[m
[31m-            margin: 0 0 1.5rem 0;[m
[31m-            line-height: 1.5;[m
[31m-            font-size: 0.95em;[m
[31m-            color: #00021d;[m
[31m-        }[m
[31m-        [m
[31m-        // Bottom Footer Content[m
[31m-        .bottom-footer {[m
[31m-            margin-top: 2rem;[m
[31m-            padding-top: 1rem;[m
[31m-            border-top: 1px solid rgba(255, 255, 255, 0.2);[m
[31m-            [m
[31m-            .copyright {[m
[31m-                .copyright-text {[m
[31m-                    font-size: 0.85em;[m
[31m-                    color: #00021d;[m
[31m-                    margin: 0;[m
[31m-                    text-align: right;[m
[31m-                }[m
[31m-            }[m
[31m-            [m
[31m-            .decoration {[m
[31m-                margin-top: 0.5rem;[m
[31m-                height: 3px;[m
[31m-                background: linear-gradient(90deg, [m
[31m-                    transparent 0%, [m
[31m-                    rgba(255, 255, 255, 0.3) 50%, [m
[31m-                    transparent 100%);[m
[31m-                border-radius: 2px;[m
[31m-            }[m
[31m-        }[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-// Responsive Design[m
[31m-@media (max-width: 768px) {[m
[31m-    .footer {[m
[31m-        flex-direction: column;[m
[31m-        padding: 4% 5%;[m
[31m-        gap: 1.5rem;[m
[31m-        [m
[31m-        .toTopDiv {[m
[31m-            position: static;[m
[31m-            align-self: center;[m
[31m-            order: -1;[m
[31m-            margin-bottom: 1rem;[m
[31m-            [m
[31m-            .toTop {[m
[31m-                font-size: 16px;[m
[31m-                padding: 10px 15px;[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        .contact,[m
[31m-        .location {[m
[31m-            max-width: 100%;[m
[31m-            [m
[31m-            h3 {[m
[31m-                font-size: 1.2em;[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        .location .bottom-footer {[m
[31m-            margin-top: 1.5rem;[m
[31m-            [m
[31m-            .copyright-text {[m
[31m-                text-align: center;[m
[31m-                font-size: 0.8em;[m
[31m-            }[m
[31m-        }[m
[31m-    }[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 480px) {[m
[31m-    .footer {[m
[31m-        padding: 6% 4%;[m
[31m-        [m
[31m-        .contact,[m
[31m-        .location {[m
[31m-            h3 {[m
[31m-                font-size: 1.1em;[m
[31m-            }[m
[31m-            [m
[31m-            .information-text,[m
[31m-            .location-text {[m
[31m-                font-size: 0.9em;[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        .toTopDiv .toTop {[m
[31m-            font-size: 14px;[m
[31m-            padding: 8px 12px;[m
[31m-        }[m
[31m-    }[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/private/scss/_global.scss b/private/scss/_global.scss[m
[1mdeleted file mode 100644[m
[1mindex 141be40..0000000[m
[1m--- a/private/scss/_global.scss[m
[1m+++ /dev/null[m
[36m@@ -1,19 +0,0 @@[m
[31m-*{[m
[31m-margin:0px;[m
[31m-padding:0px;[m
[31m-}[m
[31m-h1{[m
[31m-    // font-size: 1.5rem;[m
[31m-    margin: 1em 0;[m
[31m-    // padding: 1em 0;[m
[31m-}[m
[31m-@media (max-width: 600px) {[m
[31m-h1{[m
[31m-    font-size: 1.5rem;[m
[31m-    margin: 1em 0;[m
[31m-    padding: 1em 0;[m
[31m-}[m
[31m-h2 h3{[m
[31m-    font-size: 1rem;[m
[31m-}[m
[31m-}[m
[1mdiff --git a/private/scss/_header.scss b/private/scss/_header.scss[m
[1mdeleted file mode 100644[m
[1mindex f441f9a..0000000[m
[1m--- a/private/scss/_header.scss[m
[1m+++ /dev/null[m
[36m@@ -1,156 +0,0 @@[m
[31m-.background{[m
[31m-    // background-color: lightcoral;[m
[31m-    height: fit-content;[m
[31m-[m
[31m-      background-image: url(../../public/img/presets/background.png);[m
[31m-    background-size: cover;[m
[31m-    position: fixed;[m
[31m-    z-index: -1;[m
[31m-  background-repeat: no-repeat;[m
[31m-  width: 100%;[m
[31m-  height: 100vh;[m
[31m-  background-position:center;[m
[31m-  opacity:.8;[m
[31m-  top:0;[m
[31m-}[m
[31m-.top-headline{[m
[31m-    font-size: 2rem;[m
[31m-}[m
[31m-.top-header{[m
[31m-    display:flex;[m
[31m-    color: black;[m
[31m-    background-color: lightblue;[m
[31m-    padding: .4vh;[m
[31m-}[m
[31m-#logo{[m
[31m-      margin:0 0;[m
[31m-      padding:0 0;[m
[31m-    }[m
[31m-.top-header-item{[m
[31m-    [m
[31m-}[m
[31m-.header-item{[m
[31m-    display: flex;[m
[31m-    text-align: center;[m
[31m-    margin: 0 1%;[m
[31m-    opacity: 0.75;[m
[31m-    &:hover{[m
[31m-    opacity: 1;[m
[31m-    // background-color: rgb(230, 230, 230);[m
[31m-    // font-weight: bold;[m
[31m-}[m
[31m-}[m
[31m-[m
[31m-[m
[31m-.header{[m
[31m-    display:flex;[m
[31m-    color: black;[m
[31m-    background-color: lightcyan;[m
[31m-    padding:2vh;[m
[31m-    font-size: 2rem;[m
[31m-    box-shadow: 0 -10px 110px rgba(30, 160, 247, 0.5);[m
[31m-    *{[m
[31m-        text-decoration: none;[m
[31m-        color:black;[m
[31m-    }[m
[31m-  [m
[31m-[m
[31m-}[m
[31m-.inner{[m
[31m-width: 50%;[m
[31m-}[m
[31m-.outer{[m
[31m-    [m
[31m-}[m
[31m-[m
[31m-[m
[31m-.header-logo{[m
[31m-  font-size: x-large;[m
[31m-  text-decoration: none;[m
[31m-  margin: 0 4rem;[m
[31m-  padding: 0;[m
[31m-          text-align: center;[m
[31m-      vertical-align: middle;[m
[31m-      display:inline;[m
[31m-[m
[31m-[m
[31m-  &:hover{[m
[31m-    text-decoration: underline;[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-// Responsive Header[m
[31m-@media (max-width: 768px) {[m
[31m-  .top-header {[m
[31m-    flex-direction: column;[m
[31m-    padding: 0.2vh;[m
[31m-    gap: 0.2vh;[m
[31m-    [m
[31m-    .header-item {[m
[31m-      margin: 0;[m
[31m-      font-size: 0.8em;[m
[31m-      justify-content: center;[m
[31m-    }[m
[31m-  }[m
[31m-  [m
[31m-  .header {[m
[31m-    flex-direction: column;[m
[31m-    padding: 2vh 1vh;[m
[31m-    font-size: 1.5rem;[m
[31m-    text-align: center;[m
[31m-    [m
[31m-    .header-logo {[m
[31m-      font-size: large;[m
[31m-      margin: 0.5rem 0;[m
[31m-      [m
[31m-      &:first-child {[m
[31m-        font-size: x-large;[m
[31m-      }[m
[31m-    }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 600px) {[m
[31m-  .top-header {[m
[31m-    .header-item {[m
[31m-      font-size: 0.7em;[m
[31m-      padding: 0.1vh;[m
[31m-    }[m
[31m-  }[m
[31m-  [m
[31m-  .header {[m
[31m-    padding: 1.5vh 0.5vh;[m
[31m-    font-size: 1.2rem;[m
[31m-    [m
[31m-    .header-logo {[m
[31m-      font-size: medium;[m
[31m-      margin: 0.3rem 0;[m
[31m-      [m
[31m-      &:first-child {[m
[31m-        font-size: large;[m
[31m-      }[m
[31m-    }[m
[31m-  }[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 480px) {[m
[31m-  .top-header {[m
[31m-    .header-item {[m
[31m-      font-size: 0.6em;[m
[31m-    }[m
[31m-  }[m
[31m-  [m
[31m-  .header {[m
[31m-    padding: 1vh 0.25vh;[m
[31m-    font-size: 1rem;[m
[31m-    [m
[31m-    .header-logo {[m
[31m-      font-size: small;[m
[31m-      margin: 0.2rem 0;[m
[31m-      [m
[31m-      &:first-child {[m
[31m-        font-size: medium;[m
[31m-      }[m
[31m-    }[m
[31m-  }[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/private/scss/_howto.scss b/private/scss/_howto.scss[m
[1mdeleted file mode 100644[m
[1mindex 26734f8..0000000[m
[1m--- a/private/scss/_howto.scss[m
[1m+++ /dev/null[m
[36m@@ -1,97 +0,0 @@[m
[31m-.howto-container {[m
[31m-    display: flex;[m
[31m-    .text-content h3 {[m
[31m-    color: #333;[m
[31m-    margin-bottom: 1rem;[m
[31m-    border-bottom: 2px solid #007bff;[m
[31m-    padding-bottom: 0.5rem;[m
[31m-    }[m
[31m-[m
[31m-        flex-direction: column;[m
[31m-        gap: 4rem;[m
[31m-        padding: 2rem;[m
[31m-        max-width: 1200px;[m
[31m-        margin: 0 auto;[m
[31m-    }[m
[31m-    [m
[31m-    .tutorial-section {[m
[31m-        display: flex;[m
[31m-        gap: 2rem;[m
[31m-        align-items: flex-start;[m
[31m-    }[m
[31m-    [m
[31m-    .tutorial-section:nth-child(even) {[m
[31m-        flex-direction: row-reverse;[m
[31m-    }[m
[31m-    [m
[31m-    .text-content {[m
[31m-        flex: 1;[m
[31m-        background: #f9f9f9;[m
[31m-        padding: 1.5rem;[m
[31m-        border-radius: 8px;[m
[31m-        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);[m
[31m-        line-height: 1.6;[m
[31m-        border: groove rgb(59, 193, 255) 3px;[m
[31m-        // border: groove rgb(27, 103, 204) 3px;[m
[31m-    }[m
[31m-    [m
[31m-    .image-content {[m
[31m-        flex: 1;[m
[31m-        border-radius: 8px;[m
[31m-        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);[m
[31m-        overflow: hidden;[m
[31m-        background-position: center;[m
[31m-        background-repeat: no-repeat;[m
[31m-        min-height: 300px;[m
[31m-        border: groove rgb(27, 103, 204) 3px;[m
[31m-        // border: groove rgb(59, 193, 255) 3px;[m
[31m-        background-size: contain;[m
[31m-    }[m
[31m-    [m
[31m-    .section-1 .image-content {[m
[31m-        background-image: url('../../public/img/presets/tutorial_table.jpg');[m
[31m-    }[m
[31m-    [m
[31m-    .section-2 .image-content {[m
[31m-        background-image: url('../../public/img/presets/tutorial_insert.jpg');[m
[31m-        [m
[31m-    }[m
[31m-    [m
[31m-    .section-3 .image-content {[m
[31m-        background-image: url('../../public/img/presets/tutorial_update.jpg');[m
[31m-    }[m
[31m-    [m
[31m-    .text-content h3 {[m
[31m-        color: #333;[m
[31m-        margin-bottom: 1rem;[m
[31m-        border-bottom: 3px groove #80b5ee;[m
[31m-        padding-bottom: 0.5rem;[m
[31m-        font-size: x-large;[m
[31m-    }[m
[31m-        [m
[31m-  @media (max-width: 1000px) {[m
[31m-            .tutorial-section,[m
[31m-            .tutorial-section:nth-child(even) {[m
[31m-                flex-direction: column;[m
[31m-            }[m
[31m-            .image-content{[m
[31m-                width:80%;[m
[31m-                order:-1;[m
[31m-                margin:0 auto;[m
[31m-[m
[31m-            }[m
[31m-      [m
[31m-        }  [m
[31m-[m
[31m-        @media (max-width: 768px) {[m
[31m-            .tutorial-section, [m
[31m-            .tutorial-section:nth-child(even) {[m
[31m-                flex-direction: column;[m
[31m-            }[m
[31m-            [m
[31m-            .image-content {[m
[31m-                min-height: 200px;[m
[31m-                order:-1;       [m
[31m-                margin:0 auto;[m
[31m-            }[m
[31m-        }[m
\ No newline at end of file[m
[1mdiff --git a/private/scss/style.scss b/private/scss/style.scss[m
[1mdeleted file mode 100644[m
[1mindex 7504f6d..0000000[m
[1m--- a/private/scss/style.scss[m
[1m+++ /dev/null[m
[36m@@ -1,5 +0,0 @@[m
[31m-@import "global";[m
[31m-@import "header";[m
[31m-@import "content";[m
[31m-@import "footer";[m
[31m-@import "howto";[m
\ No newline at end of file[m
[1mdiff --git a/public/css/style.css b/public/css/style.css[m
[1mdeleted file mode 100644[m
[1mindex b8273b3..0000000[m
[1m--- a/public/css/style.css[m
[1m+++ /dev/null[m
[36m@@ -1,1321 +0,0 @@[m
[31m-* {[m
[31m-  margin: 0px;[m
[31m-  padding: 0px;[m
[31m-}[m
[31m-[m
[31m-h1 {[m
[31m-  margin: 1em 0;[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 600px) {[m
[31m-  h1 {[m
[31m-    font-size: 1.5rem;[m
[31m-    margin: 1em 0;[m
[31m-    padding: 1em 0;[m
[31m-  }[m
[31m-  h2 h3 {[m
[31m-    font-size: 1rem;[m
[31m-  }[m
[31m-}[m
[31m-.background {[m
[31m-  height: -moz-fit-content;[m
[31m-  height: fit-content;[m
[31m-  background-image: url(../../public/img/presets/background.png);[m
[31m-  background-size: cover;[m
[31m-  position: fixed;[m
[31m-  z-index: -1;[m
[31m-  background-repeat: no-repeat;[m
[31m-  width: 100%;[m
[31m-  height: 100vh;[m
[31m-  background-position: center;[m
[31m-  opacity: 0.8;[m
[31m-  top: 0;[m
[31m-}[m
[31m-[m
[31m-.top-headline {[m
[31m-  font-size: 2rem;[m
[31m-}[m
[31m-[m
[31m-.top-header {[m
[31m-  display: flex;[m
[31m-  color: black;[m
[31m-  background-color: lightblue;[m
[31m-  padding: 0.4vh;[m
[31m-}[m
[31m-[m
[31m-#logo {[m
[31m-  margin: 0 0;[m
[31m-  padding: 0 0;[m
[31m-}[m
[31m-[m
[31m-.header-item {[m
[31m-  display: flex;[m
[31m-  text-align: center;[m
[31m-  margin: 0 1%;[m
[31m-  opacity: 0.75;[m
[31m-}[m
[31m-.header-item:hover {[m
[31m-  opacity: 1;[m
[31m-}[m
[31m-[m
[31m-.header {[m
[31m-  display: flex;[m
[31m-  color: black;[m
[31m-  background-color: lightcyan;[m
[31m-  padding: 2vh;[m
[31m-  font-size: 2rem;[m
[31m-  box-shadow: 0 -10px 110px rgba(30, 160, 247, 0.5);[m
[31m-}[m
[31m-.header * {[m
[31m-  text-decoration: none;[m
[31m-  color: black;[m
[31m-}[m
[31m-[m
[31m-.inner {[m
[31m-  width: 50%;[m
[31m-}[m
[31m-[m
[31m-.header-logo {[m
[31m-  font-size: x-large;[m
[31m-  text-decoration: none;[m
[31m-  margin: 0 4rem;[m
[31m-  padding: 0;[m
[31m-  text-align: center;[m
[31m-  vertical-align: middle;[m
[31m-  display: inline;[m
[31m-}[m
[31m-.header-logo:hover {[m
[31m-  text-decoration: underline;[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 768px) {[m
[31m-  .top-header {[m
[31m-    flex-direction: column;[m
[31m-    padding: 0.2vh;[m
[31m-    gap: 0.2vh;[m
[31m-  }[m
[31m-  .top-header .header-item {[m
[31m-    margin: 0;[m
[31m-    font-size: 0.8em;[m
[31m-    justify-content: center;[m
[31m-  }[m
[31m-  .header {[m
[31m-    flex-direction: column;[m
[31m-    padding: 2vh 1vh;[m
[31m-    font-size: 1.5rem;[m
[31m-    text-align: center;[m
[31m-  }[m
[31m-  .header .header-logo {[m
[31m-    font-size: large;[m
[31m-    margin: 0.5rem 0;[m
[31m-  }[m
[31m-  .header .header-logo:first-child {[m
[31m-    font-size: x-large;[m
[31m-  }[m
[31m-}[m
[31m-@media (max-width: 600px) {[m
[31m-  .top-header .header-item {[m
[31m-    font-size: 0.7em;[m
[31m-    padding: 0.1vh;[m
[31m-  }[m
[31m-  .header {[m
[31m-    padding: 1.5vh 0.5vh;[m
[31m-    font-size: 1.2rem;[m
[31m-  }[m
[31m-  .header .header-logo {[m
[31m-    font-size: medium;[m
[31m-    margin: 0.3rem 0;[m
[31m-  }[m
[31m-  .header .header-logo:first-child {[m
[31m-    font-size: large;[m
[31m-  }[m
[31m-}[m
[31m-@media (max-width: 480px) {[m
[31m-  .top-header .header-item {[m
[31m-    font-size: 0.6em;[m
[31m-  }[m
[31m-  .header {[m
[31m-    padding: 1vh 0.25vh;[m
[31m-    font-size: 1rem;[m
[31m-  }[m
[31m-  .header .header-logo {[m
[31m-    font-size: small;[m
[31m-    margin: 0.2rem 0;[m
[31m-  }[m
[31m-  .header .header-logo:first-child {[m
[31m-    font-size: medium;[m
[31m-  }[m
[31m-}[m
[31m-.content h2 {[m
[31m-  font-size: 30px;[m
[31m-}[m
[31m-.content #overview-header {[m
[31m-  text-align: center;[m
[31m-}[m
[31m-.content table {[m
[31m-  margin: 0 10%;[m
[31m-  width: 80%;[m
[31m-  border-collapse: collapse;[m
[31m-  table-layout: fixed;[m
[31m-  font-size: 1.7em;[m
[31m-  border: 4px groove #333;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(1) {[m
[31m-  width: 3%;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(2) {[m
[31m-  width: 12%;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(3) {[m
[31m-  width: 10%;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(4) {[m
[31m-  width: 10%;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(5) {[m
[31m-  width: 9%;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(6) {[m
[31m-  width: 9%;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(7) {[m
[31m-  width: 9%;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(8) {[m
[31m-  width: 7%;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(9) {[m
[31m-  width: 5%;[m
[31m-}[m
[31m-.content table colgroup col:nth-child(10) {[m
[31m-  width: 5%;[m
[31m-}[m
[31m-.content th {[m
[31m-  border-left: 1px solid rgb(114, 188, 209);[m
[31m-  white-space: nowrap;[m
[31m-}[m
[31m-.content th .sort-link {[m
[31m-  color: inherit;[m
[31m-  text-decoration: none;[m
[31m-}[m
[31m-.content th .sort-link:hover {[m
[31m-  text-decoration: underline;[m
[31m-  color: #007bff;[m
[31m-}[m
[31m-.content th .sort-link:visited {[m
[31m-  color: inherit;[m
[31m-}[m
[31m-.content th:nth-child(9), .content th:nth-child(10) {[m
[31m-  font-weight: bold;[m
[31m-}[m
[31m-.content td {[m
[31m-  padding: 0.1em 0.2em;[m
[31m-  font-size: 0.9em;[m
[31m-  border: 1px solid black;[m
[31m-  overflow: hidden;[m
[31m-  word-wrap: break-word;[m
[31m-  max-height: 10vh;[m
[31m-  border-top: 2px groove rgb(12, 20, 31);[m
[31m-}[m
[31m-.content td .edit-btn .delete-btn {[m
[31m-  font-size: 10px;[m
[31m-}[m
[31m-.content td:nth-child(1) {[m
[31m-  text-align: center;[m
[31m-}[m
[31m-.content td:nth-child(8) {[m
[31m-  text-align: center;[m
[31m-  vertical-align: middle;[m
[31m-  padding: 2px !important;[m
[31m-  min-height: 60px;[m
[31m-  max-height: 80px;[m
[31m-}[m
[31m-.content td a {[m
[31m-  white-space: normal !important;[m
[31m-}[m
[31m-.content td:nth-child(9), .content td:nth-child(10) {[m
[31m-  padding: 0;[m
[31m-  text-align: center;[m
[31m-  vertical-align: middle;[m
[31m-  width: 2% !important;[m
[31m-}[m
[31m-[m
[31m-.cover-thumbnail {[m
[31m-  width: 100%;[m
[31m-  max-width: 70px;[m
[31m-  height: auto;[m
[31m-  aspect-ratio: 1/1;[m
[31m-  -o-object-fit: cover;[m
[31m-     object-fit: cover;[m
[31m-  border-radius: 6px;[m
[31m-  border: 1px solid #ddd;[m
[31m-  cursor: pointer;[m
[31m-  transition: filter 0.2s ease, transform 0.3s ease;[m
[31m-  margin: 4px;[m
[31m-}[m
[31m-.cover-thumbnail:hover {[m
[31m-  filter: contrast(1.18) saturate(1.2);[m
[31m-}[m
[31m-[m
[31m-.cover-text {[m
[31m-  font-size: 0.7em;[m
[31m-  color: #666;[m
[31m-  font-style: italic;[m
[31m-  font-family: monospace;[m
[31m-  padding: 4px;[m
[31m-  text-align: center;[m
[31m-}[m
[31m-[m
[31m-.current-cover {[m
[31m-  display: inline;[m
[31m-}[m
[31m-[m
[31m-#currentCoverDisplay {[m
[31m-  display: inline;[m
[31m-  height: 50%;[m
[31m-  width: 50%;[m
[31m-}[m
[31m-[m
[31m-@keyframes modalFadeIn {[m
[31m-  from {[m
[31m-    opacity: 0;[m
[31m-  }[m
[31m-  to {[m
[31m-    opacity: 1;[m
[31m-  }[m
[31m-}[m
[31m-@keyframes modalImageZoom {[m
[31m-  from {[m
[31m-    transform: translate(-50%, -50%) scale(0.7);[m
[31m-  }[m
[31m-  to {[m
[31m-    transform: translate(-50%, -50%) scale(1);[m
[31m-  }[m
[31m-}[m
[31m-.cover-modal {[m
[31m-  display: none;[m
[31m-  position: fixed;[m
[31m-  z-index: 1000;[m
[31m-  left: 0;[m
[31m-  top: 0;[m
[31m-  width: 100%;[m
[31m-  height: 100%;[m
[31m-  background-color: rgba(73, 77, 88, 0.4);[m
[31m-  animation: modalFadeIn 0.3s ease-in-out;[m
[31m-}[m
[31m-.cover-modal .cover-modal-close {[m
[31m-  position: absolute;[m
[31m-  top: 15px;[m
[31m-  right: 25px;[m
[31m-  color: white;[m
[31m-  font-size: 40px;[m
[31m-  font-weight: bold;[m
[31m-  cursor: pointer;[m
[31m-  z-index: 1001;[m
[31m-  transition: opacity 0.2s ease;[m
[31m-}[m
[31m-.cover-modal .cover-modal-close:hover {[m
[31m-  opacity: 0.7;[m
[31m-}[m
[31m-.cover-modal .cover-modal-image {[m
[31m-  position: absolute;[m
[31m-  top: 50%;[m
[31m-  left: 50%;[m
[31m-  transform: translate(-50%, -50%);[m
[31m-  max-width: 50%;[m
[31m-  max-height: 50%;[m
[31m-  border-radius: 8px;[m
[31m-  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);[m
[31m-  animation: modalImageZoom 0.4s ease-out;[m
[31m-}[m
[31m-[m
[31m-.cover-error {[m
[31m-  font-size: 0.7em;[m
[31m-  color: #666;[m
[31m-  font-style: italic;[m
[31m-}[m
[31m-[m
[31m-button {[m
[31m-  background: none;[m
[31m-  border: none;[m
[31m-  color: inherit;[m
[31m-  font-size: inherit;[m
[31m-  cursor: pointer;[m
[31m-  padding: 1rem 1rem;[m
[31m-  margin: 2vh 0;[m
[31m-}[m
[31m-button:hover {[m
[31m-  opacity: 0.7;[m
[31m-  background: none;[m
[31m-}[m
[31m-button:focus {[m
[31m-  outline: none;[m
[31m-  background: none;[m
[31m-}[m
[31m-[m
[31m-.modal {[m
[31m-  display: none;[m
[31m-  position: fixed;[m
[31m-  z-index: 1000;[m
[31m-  left: 0;[m
[31m-  top: 0;[m
[31m-  width: 100%;[m
[31m-  height: 100vh;[m
[31m-  background-color: rgba(73, 77, 88, 0.4);[m
[31m-  font-size: 1.5em;[m
[31m-}[m
[31m-.modal .input-text {[m
[31m-  width: 18em;[m
[31m-}[m
[31m-.modal input {[m
[31m-  font-size: inherit;[m
[31m-}[m
[31m-[m
[31m-.modal-content {[m
[31m-  background-color: #fefefe;[m
[31m-  margin: 5% auto;[m
[31m-  padding: 20px;[m
[31m-  border: 1px solid #888;[m
[31m-  width: 75%;[m
[31m-  max-width: 80%;[m
[31m-  border-radius: 5px;[m
[31m-  height: -moz-fit-content;[m
[31m-  height: fit-content;[m
[31m-}[m
[31m-.modal-content #updateModalTitle {[m
[31m-  font-size: 1.5em;[m
[31m-  text-align: center;[m
[31m-  display: block;[m
[31m-}[m
[31m-[m
[31m-.close {[m
[31m-  color: #aaa;[m
[31m-  float: right;[m
[31m-  font-size: 28px;[m
[31m-  font-weight: bold;[m
[31m-  cursor: pointer;[m
[31m-  line-height: 1;[m
[31m-}[m
[31m-[m
[31m-.close:hover,[m
[31m-.close:focus {[m
[31m-  color: black;[m
[31m-}[m
[31m-[m
[31m-#insertForm {[m
[31m-  text-align: center;[m
[31m-}[m
[31m-#insertForm .insert-label {[m
[31m-  width: -moz-fit-content;[m
[31m-  width: fit-content;[m
[31m-}[m
[31m-#insertModal h2 {[m
[31m-  text-align: center;[m
[31m-}[m
[31m-[m
[31m-@media (min-width: 1440px) {[m
[31m-  #insertBtn {[m
[31m-    font-size: 1.8em;[m
[31m-    margin: 1.5% 0 3%;[m
[31m-  }[m
[31m-  .modal-content {[m
[31m-    width: 50%;[m
[31m-  }[m
[31m-  .modal-update {[m
[31m-    width: 75%;[m
[31m-  }[m
[31m-  .form-column {[m
[31m-    margin: 0 0 0 2em;[m
[31m-    position: relative;[m
[31m-    z-index: 10;[m
[31m-  }[m
[31m-  .form-column input, .form-column textarea, .form-column select {[m
[31m-    pointer-events: auto !important;[m
[31m-    position: relative;[m
[31m-    z-index: 11;[m
[31m-  }[m
[31m-  .modal .input-text {[m
[31m-    margin-top: 0;[m
[31m-    width: 16em;[m
[31m-  }[m
[31m-  #updateForm {[m
[31m-    margin-top: 30px;[m
[31m-  }[m
[31m-}[m
[31m-@media (min-width: 1000px) and (max-width: 1439px) {[m
[31m-  #insertBtn {[m
[31m-    font-size: 1.5em;[m
[31m-  }[m
[31m-  .modal .input-text {[m
[31m-    width: 14em;[m
[31m-  }[m
[31m-  .modal #updateForm {[m
[31m-    margin-top: 30px;[m
[31m-  }[m
[31m-}[m
[31m-#insertBtn {[m
[31m-  background: linear-gradient(135deg, rgb(106, 196, 255) 0%, rgb(141, 212, 255) 50%, rgb(176, 228, 255) 100%);[m
[31m-  color: rgb(0, 16, 39);[m
[31m-  border: 2px solid rgba(0, 16, 39, 0.2);[m
[31m-  border-radius: 8px;[m
[31m-  padding: 12px 24px;[m
[31m-  font-weight: 600;[m
[31m-  cursor: pointer;[m
[31m-  transition: all 0.3s ease;[m
[31m-}[m
[31m-#insertBtn:hover {[m
[31m-  opacity: 1;[m
[31m-  background: linear-gradient(135deg, rgb(86, 176, 255) 0%, rgb(121, 192, 255) 50%, rgb(156, 208, 255) 100%);[m
[31m-}[m
[31m-[m
[31m-#explainer {[m
[31m-  font-size: small;[m
[31m-  margin: 0 auto;[m
[31m-  text-align: center;[m
[31m-}[m
[31m-[m
[31m-#updateForm .modalField-small {[m
[31m-  display: flex;[m
[31m-  align-items: center;[m
[31m-}[m
[31m-#updateForm .modalField-small label {[m
[31m-  flex: 0 0 3.2em;[m
[31m-  text-align: left;[m
[31m-}[m
[31m-#updateForm .modalField-radio {[m
[31m-  display: flex;[m
[31m-  text-align: center;[m
[31m-  gap: 1em;[m
[31m-}[m
[31m-#updateForm .modalField-radio label {[m
[31m-  flex: 0 0 3em;[m
[31m-  text-align: left;[m
[31m-  padding-right: 0.1em;[m
[31m-}[m
[31m-#updateForm .modalField-radio .radio-group {[m
[31m-  display: flex;[m
[31m-  gap: 1em;[m
[31m-  align-items: center;[m
[31m-}[m
[31m-#updateForm .modalField-large {[m
[31m-  display: inline-flex;[m
[31m-  align-items: center;[m
[31m-}[m
[31m-#updateForm .modalField-large label {[m
[31m-  flex: 0 0 3em;[m
[31m-  text-align: left;[m
[31m-  padding-right: 0.1em;[m
[31m-}[m
[31m-#updateForm .modalField-large input {[m
[31m-  flex: 1;[m
[31m-}[m
[31m-#updateForm .modalField-submit {[m
[31m-  display: block;[m
[31m-  margin-top: 1em;[m
[31m-}[m
[31m-#updateForm .cover-section {[m
[31m-  text-align: end;[m
[31m-  align-items: end;[m
[31m-  align-content: end;[m
[31m-}[m
[31m-[m
[31m-.modal-layout {[m
[31m-  display: flex;[m
[31m-}[m
[31m-.modal-layout .cover-column {[m
[31m-  width: 100%;[m
[31m-  align-content: center;[m
[31m-  text-align: center;[m
[31m-  margin: 0 0 5%;[m
[31m-}[m
[31m-.modal-layout .cover-column img {[m
[31m-  width: 50%;[m
[31m-}[m
[31m-[m
[31m-.filter-navigation {[m
[31m-  margin-bottom: 20px;[m
[31m-  border: 1px solid #ddd;[m
[31m-  border-radius: 6px;[m
[31m-  background: #f8f9fa;[m
[31m-}[m
[31m-[m
[31m-.filter-menu {[m
[31m-  list-style: none;[m
[31m-  margin: 0;[m
[31m-  padding: 0;[m
[31m-  display: flex;[m
[31m-  flex-wrap: wrap;[m
[31m-  position: relative;[m
[31m-  align-items: center;[m
[31m-}[m
[31m-[m
[31m-.filter-link {[m
[31m-  color: #122755;[m
[31m-  text-decoration: none;[m
[31m-  background: transparent;[m
[31m-  transition: all 0.2s ease;[m
[31m-  white-space: nowrap;[m
[31m-}[m
[31m-.filter-link:hover {[m
[31m-  -webkit-text-decoration: underline dashed;[m
[31m-          text-decoration: underline dashed;[m
[31m-  color: #007bff !important;[m
[31m-}[m
[31m-[m
[31m-.filter-item {[m
[31m-  position: relative;[m
[31m-}[m
[31m-.filter-item:not(:last-child) {[m
[31m-  border-right: 1px solid #ddd;[m
[31m-}[m
[31m-.filter-item.active .filter-link {[m
[31m-  background: #007bff;[m
[31m-  color: white;[m
[31m-}[m
[31m-.filter-item.has-submenu .filter-link::after {[m
[31m-  content: "";[m
[31m-  margin-left: 5px;[m
[31m-}[m
[31m-.filter-item.has-submenu:hover .submenu {[m
[31m-  display: block;[m
[31m-  animation: submenuFadeIn 0.2s ease-out;[m
[31m-}[m
[31m-[m
[31m-.submenu {[m
[31m-  display: none;[m
[31m-  position: absolute;[m
[31m-  top: 100%;[m
[31m-  left: 0;[m
[31m-  min-width: 250px;[m
[31m-  max-width: 350px;[m
[31m-  background: white;[m
[31m-  border: 1px solid #ddd;[m
[31m-  border-radius: 4px;[m
[31m-  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);[m
[31m-  z-index: 1000;[m
[31m-  max-height: 300px;[m
[31m-  overflow-y: auto;[m
[31m-}[m
[31m-.submenu li {[m
[31m-  list-style: none;[m
[31m-  border-bottom: 1px solid #f0f0f0;[m
[31m-}[m
[31m-.submenu li:last-child {[m
[31m-  border-bottom: none;[m
[31m-}[m
[31m-.submenu li a {[m
[31m-  display: block;[m
[31m-  padding: 10px 15px;[m
[31m-  color: #495057;[m
[31m-  text-decoration: none;[m
[31m-  font-size: 14px;[m
[31m-  transition: background 0.2s ease;[m
[31m-}[m
[31m-.submenu li a:hover {[m
[31m-  background: #f8f9fa;[m
[31m-  color: #007bff;[m
[31m-}[m
[31m-.submenu li.submenu-loading {[m
[31m-  padding: 15px;[m
[31m-  text-align: center;[m
[31m-  color: #6c757d;[m
[31m-  font-style: italic;[m
[31m-}[m
[31m-.submenu li.no-items {[m
[31m-  padding: 15px;[m
[31m-  text-align: center;[m
[31m-  color: #6c757d;[m
[31m-}[m
[31m-[m
[31m-@keyframes submenuFadeIn {[m
[31m-  from {[m
[31m-    opacity: 0;[m
[31m-    transform: translateY(-10px);[m
[31m-  }[m
[31m-  to {[m
[31m-    opacity: 1;[m
[31m-    transform: translateY(0);[m
[31m-  }[m
[31m-}[m
[31m-@media (min-width: 1000px) {[m
[31m-  .filter-status {[m
[31m-    font-size: 1.5em;[m
[31m-  }[m
[31m-}[m
[31m-.filter-status {[m
[31m-  background: #e3f2fd;[m
[31m-  padding: 10px 15px;[m
[31m-  border-radius: 4px;[m
[31m-  margin: 20px auto;[m
[31m-  display: fit-content;[m
[31m-  width: 35%;[m
[31m-  text-align: center;[m
[31m-  gap: 3rem;[m
[31m-  border-left: 4px solid #2196f3;[m
[31m-}[m
[31m-.filter-status .filter-reset {[m
[31m-  display: block;[m
[31m-  text-align: center;[m
[31m-  font-weight: 525;[m
[31m-  text-decoration: none;[m
[31m-}[m
[31m-.filter-status .filter-reset:hover {[m
[31m-  text-decoration: underline;[m
[31m-}[m
[31m-.filter-status .status-text {[m
[31m-  color: #1565c0;[m
[31m-}[m
[31m-.filter-status .clear-filter-btn {[m
[31m-  background: #ff5722;[m
[31m-  color: white;[m
[31m-  border: none;[m
[31m-  padding: 5px 10px;[m
[31m-  border-radius: 3px;[m
[31m-  cursor: pointer;[m
[31m-  font-size: 12px;[m
[31m-}[m
[31m-.filter-status .clear-filter-btn:hover {[m
[31m-  background: #d84315;[m
[31m-}[m
[31m-[m
[31m-.songs-container .no-data {[m
[31m-  text-align: center;[m
[31m-  padding: 3em;[m
[31m-  color: #6c757d;[m
[31m-  font-style: italic;[m
[31m-}[m
[31m-[m
[31m-.songs-counter {[m
[31m-  text-align: right;[m
[31m-  margin-top: 10px;[m
[31m-  padding: 10px;[m
[31m-  background: #f8f9fa;[m
[31m-  border-radius: 4px;[m
[31m-  color: #495057;[m
[31m-  font-weight: bold;[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 768px) {[m
[31m-  .filter-menu {[m
[31m-    flex-direction: column;[m
[31m-  }[m
[31m-  .modal input {[m
[31m-    width: 7em;[m
[31m-  }[m
[31m-  .filter-item {[m
[31m-    border-right: none !important;[m
[31m-    border-bottom: 1px solid #ddd;[m
[31m-  }[m
[31m-  .filter-item:last-child {[m
[31m-    border-bottom: none;[m
[31m-  }[m
[31m-  .submenu {[m
[31m-    position: static;[m
[31m-    display: none;[m
[31m-    box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);[m
[31m-    max-height: 200px;[m
[31m-  }[m
[31m-  .filter-item.has-submenu:hover .submenu {[m
[31m-    display: block;[m
[31m-  }[m
[31m-}[m
[31m-@media (max-width: 1439px) {[m
[31m-  .modal-layout {[m
[31m-    display: flex;[m
[31m-  }[m
[31m-  .modal-layout .cover-column {[m
[31m-    width: 100%;[m
[31m-    align-content: center;[m
[31m-    text-align: center;[m
[31m-    margin: 0 0 5%;[m
[31m-  }[m
[31m-  .modal-layout .cover-column img {[m
[31m-    width: 65%;[m
[31m-  }[m
[31m-  .content {[m
[31m-    width: 100%;[m
[31m-  }[m
[31m-  .content section {[m
[31m-    width: 100%;[m
[31m-    overflow-x: auto;[m
[31m-    overflow-y: visible;[m
[31m-    margin: 0 auto;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar {[m
[31m-    height: 8px;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar-track {[m
[31m-    background: #f1f1f1;[m
[31m-    border-radius: 4px;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar-thumb {[m
[31m-    background: #c1c1c1;[m
[31m-    border-radius: 4px;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar-thumb:hover {[m
[31m-    background: #a8a8a8;[m
[31m-  }[m
[31m-  .content table {[m
[31m-    min-width: 1000px;[m
[31m-    font-size: 1.75em;[m
[31m-    margin: 0 auto;[m
[31m-    width: 750px;[m
[31m-  }[m
[31m-  .content table th, .content table td {[m
[31m-    padding: 0.15rem;[m
[31m-    font-size: 0.75em;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(1) {[m
[31m-    width: 4%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(2) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(3) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(4) {[m
[31m-    width: 8%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(5) {[m
[31m-    width: 8%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(6) {[m
[31m-    width: 8%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(7) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(8) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(9) {[m
[31m-    width: 8%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(10) {[m
[31m-    width: 8%;[m
[31m-  }[m
[31m-}[m
[31m-@media (max-width: 1000px) {[m
[31m-  .modal .input-text {[m
[31m-    width: 12em;[m
[31m-  }[m
[31m-  .modal #updateForm {[m
[31m-    margin-top: 15px;[m
[31m-  }[m
[31m-  .modalField-radio {[m
[31m-    padding: 0;[m
[31m-    display: flex;[m
[31m-    width: 50%;[m
[31m-    margin: 0 auto;[m
[31m-  }[m
[31m-  .form-checkbox {[m
[31m-    margin: 0;[m
[31m-    padding: 0;[m
[31m-    display: flex;[m
[31m-    flex-direction: row;[m
[31m-    flex-wrap: nowrap;[m
[31m-    font-size: 0.8em;[m
[31m-  }[m
[31m-  .modal input {[m
[31m-    width: 12em;[m
[31m-  }[m
[31m-  .modal-content #updateModalTitle {[m
[31m-    font-size: 1em;[m
[31m-  }[m
[31m-  .modal-layout {[m
[31m-    display: flex;[m
[31m-  }[m
[31m-  .modal-layout .cover-column {[m
[31m-    width: 45%;[m
[31m-    align-content: end;[m
[31m-    text-align: end;[m
[31m-    margin: 0px 0px 0%;[m
[31m-    position: relative;[m
[31m-    bottom: 0.5em;[m
[31m-    right: 0.5em;[m
[31m-  }[m
[31m-  .modal-layout .cover-column img {[m
[31m-    width: 50%;[m
[31m-  }[m
[31m-  .modal-layout .form-column {[m
[31m-    width: 45%;[m
[31m-    display: inline;[m
[31m-  }[m
[31m-  .modal-layout .form-column form {[m
[31m-    display: inherit;[m
[31m-  }[m
[31m-  .modal-layout .form-column #updateForm {[m
[31m-    width: 40%;[m
[31m-  }[m
[31m-  .content {[m
[31m-    width: 100%;[m
[31m-  }[m
[31m-  .content section {[m
[31m-    width: 100%;[m
[31m-    overflow-x: auto;[m
[31m-    overflow-y: visible;[m
[31m-    margin: 0 auto;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar {[m
[31m-    height: 8px;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar-track {[m
[31m-    background: #f1f1f1;[m
[31m-    border-radius: 4px;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar-thumb {[m
[31m-    background: #c1c1c1;[m
[31m-    border-radius: 4px;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar-thumb:hover {[m
[31m-    background: #a8a8a8;[m
[31m-  }[m
[31m-  .content table {[m
[31m-    min-width: 850px;[m
[31m-    font-size: 1.5em;[m
[31m-    margin: 0 0 0 5%;[m
[31m-    width: 750px;[m
[31m-  }[m
[31m-  .content table td {[m
[31m-    padding: 0.15rem;[m
[31m-    font-size: 1em;[m
[31m-  }[m
[31m-  .content table td:nth-child(8) .content table td:nth-child(7) {[m
[31m-    display: none;[m
[31m-  }[m
[31m-  .content table th {[m
[31m-    font-size: 0.8em;[m
[31m-  }[m
[31m-  .content table th:nth-child(8) .content table th:nth-child(7) {[m
[31m-    display: none;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(1) {[m
[31m-    width: 4%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(2) {[m
[31m-    width: 14%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(3) {[m
[31m-    width: 13%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(4) {[m
[31m-    width: 13%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(5) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(6) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(7) {[m
[31m-    width: 0%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(8) {[m
[31m-    width: 0%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(9) {[m
[31m-    width: 8%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(10) {[m
[31m-    width: 8%;[m
[31m-  }[m
[31m-}[m
[31m-@media (max-width: 600px) {[m
[31m-  .modal .input-text {[m
[31m-    width: 10em;[m
[31m-  }[m
[31m-  .modal input {[m
[31m-    width: 10em;[m
[31m-  }[m
[31m-  #insertForm .modalField-submit {[m
[31m-    margin: 5px;[m
[31m-    padding: 5px;[m
[31m-    display: flex;[m
[31m-  }[m
[31m-  .modal-layout {[m
[31m-    display: flex;[m
[31m-  }[m
[31m-  .modal-layout .cover-column {[m
[31m-    width: 45%;[m
[31m-    align-content: end;[m
[31m-    text-align: end;[m
[31m-    margin: 0px 0px 0%;[m
[31m-    position: relative;[m
[31m-    bottom: 0.5em;[m
[31m-    right: 0.5em;[m
[31m-  }[m
[31m-  .modal-layout .cover-column .cover-title {[m
[31m-    font-size: 0.7em;[m
[31m-  }[m
[31m-  .modal-layout .cover-column img {[m
[31m-    width: 50%;[m
[31m-  }[m
[31m-  .modal-layout .form-column {[m
[31m-    width: 45%;[m
[31m-    display: inline;[m
[31m-  }[m
[31m-  .modal-layout .form-column form {[m
[31m-    display: inherit;[m
[31m-  }[m
[31m-  .modal-layout .form-column #updateForm {[m
[31m-    width: 40%;[m
[31m-  }[m
[31m-  .content {[m
[31m-    width: 100%;[m
[31m-    font-size: 1em;[m
[31m-  }[m
[31m-  .content section {[m
[31m-    width: 100%;[m
[31m-    overflow-x: auto;[m
[31m-    overflow-y: visible;[m
[31m-    margin: 0 0 0 5%;[m
[31m-    -webkit-overflow-scrolling: touch;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar {[m
[31m-    height: 8px;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar-track {[m
[31m-    background: #f1f1f1;[m
[31m-    border-radius: 4px;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar-thumb {[m
[31m-    background: #c1c1c1;[m
[31m-    border-radius: 4px;[m
[31m-  }[m
[31m-  .content section::-webkit-scrollbar-thumb:hover {[m
[31m-    background: #a8a8a8;[m
[31m-  }[m
[31m-  .content table {[m
[31m-    min-width: 600px;[m
[31m-    margin: 0 0 0 15%;[m
[31m-    width: 700px;[m
[31m-    font-size: 1.4em;[m
[31m-  }[m
[31m-  .content table th, .content table td {[m
[31m-    padding: 0.1rem;[m
[31m-  }[m
[31m-  .content table th:nth-child(1), .content table th:nth-child(7), .content table th:nth-child(8), .content table td:nth-child(1), .content table td:nth-child(7), .content table td:nth-child(8) {[m
[31m-    display: none;[m
[31m-  }[m
[31m-  .content table th {[m
[31m-    font-size: 0.7em;[m
[31m-  }[m
[31m-  .content table td {[m
[31m-    font-size: 0.8em;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(1) {[m
[31m-    width: 0%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(2) {[m
[31m-    width: 13%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(3) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(4) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(5) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(6) {[m
[31m-    width: 10%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(7) {[m
[31m-    width: 0%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(8) {[m
[31m-    width: 0%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(9) {[m
[31m-    width: 9%;[m
[31m-  }[m
[31m-  .content table colgroup col:nth-child(10) {[m
[31m-    width: 9%;[m
[31m-  }[m
[31m-}[m
[31m-@media (max-width: 480px) {[m
[31m-  .modal .input-text {[m
[31m-    width: 7em;[m
[31m-  }[m
[31m-  .modalField-radio {[m
[31m-    padding: 0;[m
[31m-    display: flex;[m
[31m-    width: 50%;[m
[31m-    margin: 0 0 0 -15px;[m
[31m-  }[m
[31m-  .content section table {[m
[31m-    min-width: 450px;[m
[31m-    width: 600px;[m
[31m-    margin: 0 0 0 15%;[m
[31m-  }[m
[31m-  .content section table td {[m
[31m-    font-size: 1em;[m
[31m-  }[m
[31m-  .content section table th {[m
[31m-    font-size: 0.8em;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(1) {[m
[31m-    width: 0%;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(2) {[m
[31m-    width: 11%;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(3) {[m
[31m-    width: 11%;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(4) {[m
[31m-    width: 11%;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(5) {[m
[31m-    width: 11%;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(6) {[m
[31m-    width: 11%;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(7) {[m
[31m-    width: 0%;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(8) {[m
[31m-    width: 0%;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(9) {[m
[31m-    width: 5%;[m
[31m-  }[m
[31m-  .content section table colgroup col:nth-child(10) {[m
[31m-    width: 5%;[m
[31m-  }[m
[31m-}[m
[31m-.footer {[m
[31m-  background-color: rgb(106, 196, 255);[m
[31m-  color: rgb(0, 16, 39);[m
[31m-  height: -moz-fit-content;[m
[31m-  height: fit-content;[m
[31m-  margin: 5% 0 0;[m
[31m-  padding: 3% 5%;[m
[31m-  width: 100%;[m
[31m-  box-sizing: border-box;[m
[31m-  position: relative;[m
[31m-  display: flex;[m
[31m-  justify-content: space-between;[m
[31m-  align-items: flex-start;[m
[31m-  gap: 2rem;[m
[31m-}[m
[31m-.footer .toTopDiv {[m
[31m-  position: absolute;[m
[31m-  top: 15px;[m
[31m-  right: 20px;[m
[31m-}[m
[31m-.footer .toTopDiv .toTop {[m
[31m-  color: rgb(0, 2, 34);[m
[31m-  text-decoration: none;[m
[31m-  font-size: 14px;[m
[31m-  text-align: center;[m
[31m-  display: inline-block;[m
[31m-  line-height: 1.2;[m
[31m-  padding: 8px 12px;[m
[31m-  border-radius: 4px;[m
[31m-}[m
[31m-.footer .toTopDiv .toTop:hover {[m
[31m-  text-decoration: none;[m
[31m-  font-weight: bold;[m
[31m-  font-size: larger;[m
[31m-}[m
[31m-.footer .toTopDiv .toTop b {[m
[31m-  font-size: 18px;[m
[31m-}[m
[31m-.footer .contact {[m
[31m-  flex: 1;[m
[31m-  max-width: 45%;[m
[31m-}[m
[31m-.footer .contact h3 {[m
[31m-  color: #00021d;[m
[31m-  font-size: 1.3em;[m
[31m-  margin: 0 0 1rem 0;[m
[31m-  font-weight: 600;[m
[31m-  border-bottom: 2px solid rgba(255, 255, 255, 0.3);[m
[31m-  padding-bottom: 0.5rem;[m
[31m-}[m
[31m-.footer .contact .information-text {[m
[31m-  margin: 0 0 1rem 0;[m
[31m-  line-height: 1.5;[m
[31m-  font-size: 0.95em;[m
[31m-  color: #00021d;[m
[31m-}[m
[31m-.footer .location {[m
[31m-  flex: 1;[m
[31m-  max-width: 45%;[m
[31m-}[m
[31m-.footer .location h3 {[m
[31m-  color: #00021d;[m
[31m-  font-size: 1.3em;[m
[31m-  margin: 0 0 1rem 0;[m
[31m-  font-weight: 600;[m
[31m-  border-bottom: 2px solid rgba(255, 255, 255, 0.3);[m
[31m-  padding-bottom: 0.5rem;[m
[31m-}[m
[31m-.footer .location .location-text {[m
[31m-  margin: 0 0 1.5rem 0;[m
[31m-  line-height: 1.5;[m
[31m-  font-size: 0.95em;[m
[31m-  color: #00021d;[m
[31m-}[m
[31m-.footer .location .bottom-footer {[m
[31m-  margin-top: 2rem;[m
[31m-  padding-top: 1rem;[m
[31m-  border-top: 1px solid rgba(255, 255, 255, 0.2);[m
[31m-}[m
[31m-.footer .location .bottom-footer .copyright .copyright-text {[m
[31m-  font-size: 0.85em;[m
[31m-  color: #00021d;[m
[31m-  margin: 0;[m
[31m-  text-align: right;[m
[31m-}[m
[31m-.footer .location .bottom-footer .decoration {[m
[31m-  margin-top: 0.5rem;[m
[31m-  height: 3px;[m
[31m-  background: linear-gradient(90deg, transparent 0%, rgba(255, 255, 255, 0.3) 50%, transparent 100%);[m
[31m-  border-radius: 2px;[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 768px) {[m
[31m-  .footer {[m
[31m-    flex-direction: column;[m
[31m-    padding: 4% 5%;[m
[31m-    gap: 1.5rem;[m
[31m-  }[m
[31m-  .footer .toTopDiv {[m
[31m-    position: static;[m
[31m-    align-self: center;[m
[31m-    order: -1;[m
[31m-    margin-bottom: 1rem;[m
[31m-  }[m
[31m-  .footer .toTopDiv .toTop {[m
[31m-    font-size: 16px;[m
[31m-    padding: 10px 15px;[m
[31m-  }[m
[31m-  .footer .contact,[m
[31m-  .footer .location {[m
[31m-    max-width: 100%;[m
[31m-  }[m
[31m-  .footer .contact h3,[m
[31m-  .footer .location h3 {[m
[31m-    font-size: 1.2em;[m
[31m-  }[m
[31m-  .footer .location .bottom-footer {[m
[31m-    margin-top: 1.5rem;[m
[31m-  }[m
[31m-  .footer .location .bottom-footer .copyright-text {[m
[31m-    text-align: center;[m
[31m-    font-size: 0.8em;[m
[31m-  }[m
[31m-}[m
[31m-@media (max-width: 480px) {[m
[31m-  .footer {[m
[31m-    padding: 6% 4%;[m
[31m-  }[m
[31m-  .footer .contact h3,[m
[31m-  .footer .location h3 {[m
[31m-    font-size: 1.1em;[m
[31m-  }[m
[31m-  .footer .contact .information-text,[m
[31m-  .footer .contact .location-text,[m
[31m-  .footer .location .information-text,[m
[31m-  .footer .location .location-text {[m
[31m-    font-size: 0.9em;[m
[31m-  }[m
[31m-  .footer .toTopDiv .toTop {[m
[31m-    font-size: 14px;[m
[31m-    padding: 8px 12px;[m
[31m-  }[m
[31m-}[m
[31m-.howto-container {[m
[31m-  display: flex;[m
[31m-  flex-direction: column;[m
[31m-  gap: 4rem;[m
[31m-  padding: 2rem;[m
[31m-  max-width: 1200px;[m
[31m-  margin: 0 auto;[m
[31m-}[m
[31m-.howto-container .text-content h3 {[m
[31m-  color: #333;[m
[31m-  margin-bottom: 1rem;[m
[31m-  border-bottom: 2px solid #007bff;[m
[31m-  padding-bottom: 0.5rem;[m
[31m-}[m
[31m-[m
[31m-.tutorial-section {[m
[31m-  display: flex;[m
[31m-  gap: 2rem;[m
[31m-  align-items: flex-start;[m
[31m-}[m
[31m-[m
[31m-.tutorial-section:nth-child(even) {[m
[31m-  flex-direction: row-reverse;[m
[31m-}[m
[31m-[m
[31m-.text-content {[m
[31m-  flex: 1;[m
[31m-  background: #f9f9f9;[m
[31m-  padding: 1.5rem;[m
[31m-  border-radius: 8px;[m
[31m-  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);[m
[31m-  line-height: 1.6;[m
[31m-  border: groove rgb(59, 193, 255) 3px;[m
[31m-}[m
[31m-[m
[31m-.image-content {[m
[31m-  flex: 1;[m
[31m-  border-radius: 8px;[m
[31m-  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);[m
[31m-  overflow: hidden;[m
[31m-  background-position: center;[m
[31m-  background-repeat: no-repeat;[m
[31m-  min-height: 300px;[m
[31m-  border: groove rgb(27, 103, 204) 3px;[m
[31m-  background-size: contain;[m
[31m-}[m
[31m-[m
[31m-.section-1 .image-content {[m
[31m-  background-image: url("../../public/img/presets/tutorial_table.jpg");[m
[31m-}[m
[31m-[m
[31m-.section-2 .image-content {[m
[31m-  background-image: url("../../public/img/presets/tutorial_insert.jpg");[m
[31m-}[m
[31m-[m
[31m-.section-3 .image-content {[m
[31m-  background-image: url("../../public/img/presets/tutorial_update.jpg");[m
[31m-}[m
[31m-[m
[31m-.text-content h3 {[m
[31m-  color: #333;[m
[31m-  margin-bottom: 1rem;[m
[31m-  border-bottom: 3px groove #80b5ee;[m
[31m-  padding-bottom: 0.5rem;[m
[31m-  font-size: x-large;[m
[31m-}[m
[31m-[m
[31m-@media (max-width: 1000px) {[m
[31m-  .tutorial-section,[m
[31m-  .tutorial-section:nth-child(even) {[m
[31m-    flex-direction: column;[m
[31m-  }[m
[31m-  .image-content {[m
[31m-    width: 80%;[m
[31m-    order: -1;[m
[31m-    margin: 0 auto;[m
[31m-  }[m
[31m-}[m
[31m-@media (max-width: 768px) {[m
[31m-  .tutorial-section,[m
[31m-  .tutorial-section:nth-child(even) {[m
[31m-    flex-direction: column;[m
[31m-  }[m
[31m-  .image-content {[m
[31m-    min-height: 200px;[m
[31m-    order: -1;[m
[31m-    margin: 0 auto;[m
[31m-  }[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/public/img/presets/Bound_By_Flame.jpg b/public/img/presets/Bound_By_Flame.jpg[m
[1mdeleted file mode 100644[m
[1mindex 64084f7..0000000[m
Binary files a/public/img/presets/Bound_By_Flame.jpg and /dev/null differ
[1mdiff --git a/public/img/presets/Deuter.jpg b/public/img/presets/Deuter.jpg[m
[1mdeleted file mode 100644[m
[1mindex 90b7209..0000000[m
Binary files a/public/img/presets/Deuter.jpg and /dev/null differ
[1mdiff --git a/public/img/presets/One_Piece.jpg b/public/img/presets/One_Piece.jpg[m
[1mdeleted file mode 100644[m
[1mindex b02147c..0000000[m
Binary files a/public/img/presets/One_Piece.jpg and /dev/null differ
[1mdiff --git a/public/img/presets/Silk_Music.jpg b/public/img/presets/Silk_Music.jpg[m
[1mdeleted file mode 100644[m
[1mindex b455ce8..0000000[m
Binary files a/public/img/presets/Silk_Music.jpg and /dev/null differ
[1mdiff --git a/public/img/presets/background.png b/public/img/presets/background.png[m
[1mdeleted file mode 100644[m
[1mindex 2acc568..0000000[m
Binary files a/public/img/presets/background.png and /dev/null differ
[1mdiff --git a/public/img/presets/tutorial_insert.jpg b/public/img/presets/tutorial_insert.jpg[m
[1mdeleted file mode 100644[m
[1mindex a70e535..0000000[m
Binary files a/public/img/presets/tutorial_insert.jpg and /dev/null differ
[1mdiff --git a/public/img/presets/tutorial_table.jpg b/public/img/presets/tutorial_table.jpg[m
[1mdeleted file mode 100644[m
[1mindex f174a33..0000000[m
Binary files a/public/img/presets/tutorial_table.jpg and /dev/null differ
[1mdiff --git a/public/img/presets/tutorial_update.jpg b/public/img/presets/tutorial_update.jpg[m
[1mdeleted file mode 100644[m
[1mindex 890e224..0000000[m
Binary files a/public/img/presets/tutorial_update.jpg and /dev/null differ
[1mdiff --git a/update.php b/update.php[m
[1mdeleted file mode 100644[m
[1mindex 79b280a..0000000[m
[1m--- a/update.php[m
[1m+++ /dev/null[m
[36m@@ -1,237 +0,0 @@[m
[31m-<?php [m
[31m-include "connection.php";[m
[31m-[m
[31m-if ($_SERVER['REQUEST_METHOD'] === 'POST') {[m
[31m-    [m
[31m-    $songID = $_POST['songID'] ?? '';[m
[31m-    [m
[31m-    if (empty($songID)) {[m
[31m-        echo "Keine Song-ID angegeben";[m
[31m-        exit;[m
[31m-    }[m
[31m-    [m
[31m-    try {[m
[31m-        $pdo->beginTransaction();[m
[31m-        [m
[31m-        // 1. Song-Name updaten (falls eingegeben)[m
[31m-        if (isset($_POST['songname']) && !empty($_POST['songname'])) {[m
[31m-            $stmt = $pdo->prepare("UPDATE song SET songname = :songname WHERE songID = :songID");[m
[31m-            $stmt->execute(['songname' => $_POST['songname'], 'songID' => $songID]);[m
[31m-        }[m
[31m-        [m
[31m-        // 2. Album updaten [m
[31m-        if (isset($_POST['album'])) {[m
[31m-            if (!empty(trim($_POST['album']))) {[m
[31m-                // Prüfen, ob Song bereits Album hat[m
[31m-                $currentAlbumStmt = $pdo->prepare("[m
[31m-                    SELECT a.albumname [m
[31m-                    FROM song s [m
[31m-                    LEFT JOIN album a ON s.albumID = a.albumID [m
[31m-                    WHERE s.songID = :songID[m
[31m-                ");[m
[31m-                $currentAlbumStmt->execute(['songID' => $songID]);[m
[31m-                $currentAlbum = $currentAlbumStmt->fetchColumn();[m
[31m-                [m
[31m-                // Nur ändern wenn es sich unterscheidet[m
[31m-                if ($currentAlbum !== $_POST['album']) {[m
[31m-                    // Album finden oder erstellen[m
[31m-                    $albumStmt = $pdo->prepare("SELECT albumID FROM album WHERE albumname = :albumname");[m
[31m-                    $albumStmt->execute(['albumname' => $_POST['album']]);[m
[31m-                    $albumID = $albumStmt->fetchColumn();[m
[31m-                    [m
[31m-                    if (!$albumID) {[m
[31m-                        $insertAlbum = $pdo->prepare("INSERT INTO album (albumname) VALUES (:albumname)");[m
[31m-                        $insertAlbum->execute(['albumname' => $_POST['album']]);[m
[31m-                        $albumID = $pdo->lastInsertId();[m
[31m-                    }[m
[31m-                    [m
[31m-                    $songAlbumStmt = $pdo->prepare("UPDATE song SET albumID = :albumID WHERE songID = :songID");[m
[31m-                    $songAlbumStmt->execute(['albumID' => $albumID, 'songID' => $songID]);[m
[31m-                }[m
[31m-            } else {[m
[31m-                // Leeres Feld = NULL setzen[m
[31m-                $songAlbumStmt = $pdo->prepare("UPDATE song SET albumID = NULL WHERE songID = :songID");[m
[31m-                $songAlbumStmt->execute(['songID' => $songID]);[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        // 3. Genre updaten[m
[31m-        if (isset($_POST['genre'])) {[m
[31m-            if (!empty(trim($_POST['genre']))) {[m
[31m-                // Prüfen ob Song Genre hat[m
[31m-                $currentGenreStmt = $pdo->prepare("[m
[31m-                    SELECT g.genrename [m
[31m-                    FROM song s [m
[31m-                    LEFT JOIN genre g ON s.genreID = g.genreID [m
[31m-                    WHERE s.songID = :songID[m
[31m-                ");[m
[31m-                $currentGenreStmt->execute(['songID' => $songID]);[m
[31m-                $currentGenre = $currentGenreStmt->fetchColumn();[m
[31m-                [m
[31m-                if ($currentGenre !== $_POST['genre']) {[m
[31m-                    $genreStmt = $pdo->prepare("SELECT genreID FROM genre WHERE genrename = :genrename");[m
[31m-                    $genreStmt->execute(['genrename' => $_POST['genre']]);[m
[31m-                    $genreID = $genreStmt->fetchColumn();[m
[31m-                    [m
[31m-                    if (!$genreID) {[m
[31m-                        $insertGenre = $pdo->prepare("INSERT INTO genre (genrename) VALUES (:genrename)");[m
[31m-                        $insertGenre->execute(['genrename' => $_POST['genre']]);[m
[31m-                        $genreID = $pdo->lastInsertId();[m
[31m-                    }[m
[31m-                    [m
[31m-                    $songGenreStmt = $pdo->prepare("UPDATE song SET genreID = :genreID WHERE songID = :songID");[m
[31m-                    $songGenreStmt->execute(['genreID' => $genreID, 'songID' => $songID]);[m
[31m-                }[m
[31m-            } else {[m
[31m-                $songGenreStmt = $pdo->prepare("UPDATE song SET genreID = NULL WHERE songID = :songID");[m
[31m-                $songGenreStmt->execute(['songID' => $songID]);[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        // 4. isSingle updaten [m
[31m-        if (isset($_POST['isSingle'])) {[m
[31m-            $isSingle = (int)$_POST['isSingle'];[m
[31m-            $stmt = $pdo->prepare("UPDATE song SET isSingle = :isSingle WHERE songID = :songID");[m
[31m-            $stmt->execute(['isSingle' => $isSingle, 'songID' => $songID]);[m
[31m-        }[m
[31m-        [m
[31m-        // 5. Mood updaten[m
[31m-        if (isset($_POST['mood'])) {[m
[31m-            if (!empty(trim($_POST['mood']))) {[m
[31m-                // Mood prüfen[m
[31m-                $currentMoodStmt = $pdo->prepare("[m
[31m-                    SELECT m.moodname [m
[31m-                    FROM song s [m
[31m-                    LEFT JOIN mood m ON s.moodID = m.moodID [m
[31m-                    WHERE s.songID = :songID[m
[31m-                ");[m
[31m-                $currentMoodStmt->execute(['songID' => $songID]);[m
[31m-                $currentMood = $currentMoodStmt->fetchColumn();[m
[31m-                [m
[31m-                if ($currentMood !== $_POST['mood']) {[m
[31m-                    $moodStmt = $pdo->prepare("SELECT moodID FROM mood WHERE moodname = :moodname");[m
[31m-                    $moodStmt->execute(['moodname' => $_POST['mood']]);[m
[31m-                    $moodID = $moodStmt->fetchColumn();[m
[31m-                    [m
[31m-                    if (!$moodID) {[m
[31m-                        $insertMood = $pdo->prepare("INSERT INTO mood (moodname) VALUES (:moodname)");[m
[31m-                        $insertMood->execute(['moodname' => $_POST['mood']]);[m
[31m-                        $moodID = $pdo->lastInsertId();[m
[31m-                    }[m
[31m-                    [m
[31m-                    $songMoodStmt = $pdo->prepare("UPDATE song SET moodID = :moodID WHERE songID = :songID");[m
[31m-                    $songMoodStmt->execute(['moodID' => $moodID, 'songID' => $songID]);[m
[31m-                }[m
[31m-            } else {[m
[31m-                $songMoodStmt = $pdo->prepare("UPDATE song SET moodID = NULL WHERE songID = :songID");[m
[31m-                $songMoodStmt->execute(['songID' => $songID]);[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        // 6. Plattform updaten[m
[31m-        if (isset($_POST['plattform'])) {[m
[31m-            if (!empty(trim($_POST['plattform']))) {[m
[31m-                $plattformStmt = $pdo->prepare("SELECT plattformID FROM erscheinungsplattform WHERE plattformname = :plattformname");[m
[31m-                $plattformStmt->execute(['plattformname' => $_POST['plattform']]);[m
[31m-                $plattformID = $plattformStmt->fetchColumn();[m
[31m-                [m
[31m-                if (!$plattformID) {[m
[31m-                    $insertPlattform = $pdo->prepare("INSERT INTO erscheinungsplattform (plattformname) VALUES (:plattformname)");[m
[31m-                    $insertPlattform->execute(['plattformname' => $_POST['plattform']]);[m
[31m-                    $plattformID = $pdo->lastInsertId();[m
[31m-                }[m
[31m-                [m
[31m-                $albumStmt = $pdo->prepare("SELECT albumID FROM song WHERE songID = :songID");[m
[31m-                $albumStmt->execute(['songID' => $songID]);[m
[31m-                $albumID = $albumStmt->fetchColumn();[m
[31m-                [m
[31m-                if ($albumID) {[m
[31m-                    $pdo->prepare("UPDATE album SET plattformID = :plattformID WHERE albumID = :albumID")[m
[31m-                        ->execute(['plattformID' => $plattformID, 'albumID' => $albumID]);[m
[31m-                }[m
[31m-            } else {[m
[31m-                $albumStmt = $pdo->prepare("SELECT albumID FROM song WHERE songID = :songID");[m
[31m-                $albumStmt->execute(['songID' => $songID]);[m
[31m-                $albumID = $albumStmt->fetchColumn();[m
[31m-                [m
[31m-                if ($albumID) {[m
[31m-                    $pdo->prepare("UPDATE album SET plattformID = NULL WHERE albumID = :albumID")[m
[31m-                        ->execute(['albumID' => $albumID]);[m
[31m-                }[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        // 7. Cover updaten[m
[31m-        if (isset($_POST['cover'])) {[m
[31m-            if (!empty(trim($_POST['cover']))) {[m
[31m-                $coverLink = trim($_POST['cover']);[m
[31m-                [m
[31m-                $insertCover = $pdo->prepare("INSERT INTO cover (link) VALUES (:link)");[m
[31m-                $insertCover->execute(['link' => $coverLink]);[m
[31m-                $newCoverID = $pdo->lastInsertId();[m
[31m-                [m
[31m-                $pdo->prepare("UPDATE song SET coverID = :coverID WHERE songID = :songID")[m
[31m-                    ->execute(['coverID' => $newCoverID, 'songID' => $songID]);[m
[31m-            } else {[m
[31m-                $pdo->prepare("UPDATE song SET coverID = NULL WHERE songID = :songID")[m
[31m-                    ->execute(['songID' => $songID]);[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        // Artist updaten[m
[31m-        if (isset($_POST['artist'])) {[m
[31m-            [m
[31m-            $checkStmt = $pdo->prepare("SELECT COUNT(*) FROM song_artist WHERE songID = :songID");[m
[31m-            $checkStmt->execute(['songID' => $songID]);[m
[31m-            [m
[31m-            if ($checkStmt->fetchColumn() > 0) {[m
[31m-                $pdo->prepare("DELETE FROM song_artist WHERE songID = :songID")->execute(['songID' => $songID]);[m
[31m-            }[m
[31m-            [m
[31m-            if (!empty(trim($_POST['artist']))) {[m
[31m-                $currentArtistStmt = $pdo->prepare("[m
[31m-                    SELECT GROUP_CONCAT(a.artistname SEPARATOR ', ') as artists[m
[31m-                    FROM song_artist sa [m
[31m-                    JOIN artist a ON sa.artistID = a.artistID [m
[31m-                    WHERE sa.songID = :songID[m
[31m-                ");[m
[31m-                $currentArtistStmt->execute(['songID' => $songID]);[m
[31m-                $currentArtist = $currentArtistStmt->fetchColumn();[m
[31m-                [m
[31m-                if ($currentArtist !== $_POST['artist']) {[m
[31m-                    $artistStmt = $pdo->prepare("SELECT artistID FROM artist WHERE artistname = :artistname");[m
[31m-                    $artistStmt->execute(['artistname' => $_POST['artist']]);[m
[31m-                    $artistID = $artistStmt->fetchColumn();[m
[31m-                    [m
[31m-                    if (!$artistID) {[m
[31m-                        $insertArtist = $pdo->prepare("INSERT INTO artist (artistname) VALUES (:artistname)");[m
[31m-                        $insertArtist->execute(['artistname' => $_POST['artist']]);[m
[31m-                        $artistID = $pdo->lastInsertId();[m
[31m-                    }[m
[31m-                    [m
[31m-                    $linkArtist = $pdo->prepare("INSERT INTO song_artist (songID, artistID) VALUES (:songID, :artistID)");[m
[31m-                    $linkArtist->execute(['songID' => $songID, 'artistID' => $artistID]);[m
[31m-                }[m
[31m-            }[m
[31m-        }[m
[31m-        [m
[31m-        $pdo->commit();[m
[31m-        [m
[31m-        // Erfolgreiches Update - zurück zur Hauptseite[m
[31m-        header("Location: index.php?success=update");[m
[31m-        exit;[m
[31m-        [m
[31m-    } catch (PDOException $e) {[m
[31m-        if ($pdo->inTransaction()) {[m
[31m-            $pdo->rollBack();[m
[31m-        }[m
[31m-        // Fehler - zurück zur Hauptseite mit Fehlermeldung[m
[31m-        header("Location: index.php?error=" . urlencode("Fehler: " . $e->getMessage()));[m
[31m-        exit;[m
[31m-    }[m
[31m-    [m
[31m-} else {[m
[31m-    header("Location: index.php");[m
[31m-    exit;[m
[31m-}[m
[31m-?>[m
\ No newline at end of file[m
