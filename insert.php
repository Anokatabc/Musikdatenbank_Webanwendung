<?php 
include "connection.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $pdo->beginTransaction();
        
        // Song-Name required
        $songname = $_POST['song'] ?? '';
        if (empty($songname)) {
            throw new Exception("Song-Name ist erforderlich");
        }

        $disableFormatting = isset($_POST['disable_formatting']);
        
        $isSingle = (int)($_POST['isSingle'] ?? 0);
        
        if (!$disableFormatting) {
            $formattedSongname = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {
                return strtoupper($matches[0]);
            }, strtolower(trim($songname)));
        } else {
            $formattedSongname = trim($songname);
        }
        
        $songStmt = $pdo->prepare("INSERT INTO song (songname, isSingle) VALUES (:songname, :isSingle)");
        $songStmt->execute(['songname' => $formattedSongname, 'isSingle' => $isSingle]);
        $songID = $pdo->lastInsertId();
        
        
        // Album verarbeiten (falls angegeben)
        if (!empty($_POST['album'])) {
            if (!$disableFormatting) {
                $formattedAlbum = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {
                    return strtoupper($matches[0]);
                }, strtolower(trim($_POST['album'])));
            } else {
                $formattedAlbum = trim($_POST['album']);
            }
            
            $albumStmt = $pdo->prepare("SELECT albumID FROM album WHERE albumname = :albumname");
            $albumStmt->execute(['albumname' => $formattedAlbum]);
            $albumID = $albumStmt->fetchColumn();
            
            if (!$albumID) {
                $insertAlbum = $pdo->prepare("INSERT INTO album (albumname) VALUES (:albumname)");
                $insertAlbum->execute(['albumname' => $formattedAlbum]);
                $albumID = $pdo->lastInsertId();
            }
            
            $pdo->prepare("UPDATE song SET albumID = :albumID WHERE songID = :songID")
                ->execute(['albumID' => $albumID, 'songID' => $songID]);
        }
        
        // Genre verarbeiten (falls angegeben)
        if (!empty($_POST['genre'])) {
            if (!$disableFormatting) {
                $formattedGenre = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {
                    return strtoupper($matches[0]);
                }, strtolower(trim($_POST['genre'])));
            } else {
                $formattedGenre = trim($_POST['genre']);
            }
            
            $genreStmt = $pdo->prepare("SELECT genreID FROM genre WHERE genrename = :genrename");
            $genreStmt->execute(['genrename' => $formattedGenre]);
            $genreID = $genreStmt->fetchColumn();
            
            if (!$genreID) {
                $insertGenre = $pdo->prepare("INSERT INTO genre(genrename) VALUES (:genrename)");
                $insertGenre->execute(['genrename' => $formattedGenre]);
                $genreID = $pdo->lastInsertId();
            }
            
            $pdo->prepare("UPDATE song SET genreID = :genreID WHERE songID = :songID")
                ->execute(['genreID' => $genreID, 'songID' => $songID]);
        }
        
        // Artist verarbeiten (falls angegeben)
        if (!empty($_POST['artist'])) {
            if (!$disableFormatting) {
                $formattedArtist = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {
                    return strtoupper($matches[0]);
                }, strtolower(trim($_POST['artist'])));
            } else {
                $formattedArtist = trim($_POST['artist']);
            }
            
            $artistStmt = $pdo->prepare("SELECT artistID FROM artist WHERE artistname = :artistname");
            $artistStmt->execute(['artistname' => $formattedArtist]);
            $artistID = $artistStmt->fetchColumn();
            
            if (!$artistID) {
                $insertArtist = $pdo->prepare("INSERT INTO artist (artistname) VALUES (:artistname)");
                $insertArtist->execute(['artistname' => $formattedArtist]);
                $artistID = $pdo->lastInsertId();
            }
            
            $pdo->prepare("INSERT INTO song_artist (songID, artistID) VALUES (:songID, :artistID)")
                ->execute(['songID' => $songID, 'artistID' => $artistID]);
        }
        
        // Mood verarbeiten (falls angegeben)
        if (!empty($_POST['mood'])) {
            if (!$disableFormatting) {
                $formattedMood = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {
                    return strtoupper($matches[0]);
                }, strtolower(trim($_POST['mood'])));
            } else {
                $formattedMood = trim($_POST['mood']);
            }
            
            $moodStmt = $pdo->prepare("SELECT moodID FROM mood WHERE moodname = :moodname");
            $moodStmt->execute(['moodname' => $formattedMood]);
            $moodID = $moodStmt->fetchColumn();
            
            if (!$moodID) {
                $insertMood = $pdo->prepare("INSERT INTO mood (moodname) VALUES (:moodname)");
                $insertMood->execute(['moodname' => $formattedMood]);
                $moodID = $pdo->lastInsertId();
            }
            
            $pdo->prepare("UPDATE song SET moodID = :moodID WHERE songID = :songID")
                ->execute(['songID' => $songID, 'moodID' => $moodID]);
        }
        
        // Plattform verarbeiten (falls angegeben)
        if (!empty($_POST['plattform'])) {
            if (!$disableFormatting) {
                $formattedPlattform = preg_replace_callback('/\b[\p{L}\p{N}]/u', function($matches) {
                    return strtoupper($matches[0]);
                }, strtolower(trim($_POST['plattform'])));
            } else {
                $formattedPlattform = trim($_POST['plattform']);
            }
            
            $plattformStmt = $pdo->prepare("SELECT plattformID FROM erscheinungsplattform WHERE plattformname = :plattformname");
            $plattformStmt->execute(['plattformname' => $formattedPlattform]);
            $plattformID = $plattformStmt->fetchColumn();
            
            if (!$plattformID) {
                $insertPlattform = $pdo->prepare("INSERT INTO erscheinungsplattform (plattformname) VALUES (:plattformname)");
                $insertPlattform->execute(['plattformname' => $formattedPlattform]);
                $plattformID = $pdo->lastInsertId();
            }
            
            if (isset($albumID)) {
                $pdo->prepare("UPDATE album SET plattformID = :plattformID WHERE albumID = :albumID")
                    ->execute(['plattformID' => $plattformID, 'albumID' => $albumID]);
            }
        }
        
        // Cover verarbeiten (falls angegeben)
    if (!empty($_POST['cover'])) {
    $coverLink = trim($_POST['cover']);
    
    // Cover/Link prüfen
    $existingCoverStmt = $pdo->prepare("SELECT coverID FROM cover WHERE link = :link");
    $existingCoverStmt->execute(['link' => $coverLink]);
    $existingCoverID = $existingCoverStmt->fetchColumn();
    
    if ($existingCoverID) {
        // Bestehendes Cover verwenden
        $coverID = $existingCoverID;
    } else {
        // Neues Cover erstellen
        $insertCover = $pdo->prepare("INSERT INTO cover (link) VALUES (:link)");
        $insertCover->execute(['link' => $coverLink]);
        $coverID = $pdo->lastInsertId();
    }
    
    $pdo->prepare("UPDATE song SET coverID = :coverID WHERE songID = :songID")
        ->execute(['coverID' => $coverID, 'songID' => $songID]);
}
        
        $pdo->commit();
        
        // Erfolgreiche Einfügung - zurück zur Hauptseite
        header("Location: index.php?success=insert");
        exit;
        
    } catch (Exception $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        // Fehler - zurück zur Hauptseite mit Fehlermeldung
        header("Location: index.php?error=" . urlencode($e->getMessage()));
        exit;
    }
} else {
    header("Location: index.php");
    exit;
}
?>