<?php
// Alle Daten, die gebraucht werden: "Du verbindest dich mit Datenbank c unter IP-Adresse a, mit Port b. Nutzer 'root' und kein Passwort"
$host = '127.0.0.1'; //Host angeben: Hier Localhost
$port = 3306; //Standard-Port XAMPPP - WSL = 3324. VM 3307 oder 3308
$dbname ='test-dump'; //Datenbankname gemäß "CREATE DATABASE xyz"
$username = 'root';
$password = ''; //Wenn kein Passwort gesetzt, wie bei XAMPP

try {
    $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8mb4"; //alle Verbindungsparameter
    $pdo = new PDO($dsn, $username, $password); //alle restlichen Parameter, die PDO benötigt (erkennbar wenn man "PDO()" schreibt)
} catch (PDOException $e) {
    echo "Verbindung fehlgeschlagen: " . $e->getMessage(); //Punkt . ist Konkatenationszeichen, wie + in Java
}
?>
<!-- Potenzielle Verbesserung: in Funktion verpacken -->