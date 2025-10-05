<?php 
include "connection.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    $songID = $_POST['songID'] ?? '';
    
    if (empty($songID)) {
        echo "Keine Song-ID angegeben";
        exit;
    }
    
    try {
        $pdo->beginTransaction();
        
        // 1. Song-Name updaten (falls eingegeben)
        if (isset($_POST['songname']) && !empty($_POST['songname'])) {
            $stmt = $pdo->prepare("UPDATE song SET songname = :songname WHERE songID = :songID");
            $stmt->execute(['songname' => $_POST['songname'], 'songID' => $songID]);
        }
        
        // 2. Album updaten 
        if (isset($_POST['album'])) {
            if (!empty(trim($_POST['album']))) {
                // Prüfen, ob Song bereits Album hat
                $currentAlbumStmt = $pdo->prepare("
                    SELECT a.albumname 
                    FROM song s 
                    LEFT JOIN album a ON s.albumID = a.albumID 
                    WHERE s.songID = :songID
                ");
                $currentAlbumStmt->execute(['songID' => $songID]);
                $currentAlbum = $currentAlbumStmt->fetchColumn();
                
                // Nur ändern wenn es sich unterscheidet
                if ($currentAlbum !== $_POST['album']) {
                    // Album finden oder erstellen
                    $albumStmt = $pdo->prepare("SELECT albumID FROM album WHERE albumname = :albumname");
                    $albumStmt->execute(['albumname' => $_POST['album']]);
                    $albumID = $albumStmt->fetchColumn();
                    
                    if (!$albumID) {
                        $insertAlbum = $pdo->prepare("INSERT INTO album (albumname) VALUES (:albumname)");
                        $insertAlbum->execute(['albumname' => $_POST['album']]);
                        $albumID = $pdo->lastInsertId();
                    }
                    
                    $songAlbumStmt = $pdo->prepare("UPDATE song SET albumID = :albumID WHERE songID = :songID");
                    $songAlbumStmt->execute(['albumID' => $albumID, 'songID' => $songID]);
                }
            } else {
                // Leeres Feld = NULL setzen
                $songAlbumStmt = $pdo->prepare("UPDATE song SET albumID = NULL WHERE songID = :songID");
                $songAlbumStmt->execute(['songID' => $songID]);
            }
        }
        
        // 3. Genre updaten
        if (isset($_POST['genre'])) {
            if (!empty(trim($_POST['genre']))) {
                // Prüfen ob Song Genre hat
                $currentGenreStmt = $pdo->prepare("
                    SELECT g.genrename 
                    FROM song s 
                    LEFT JOIN genre g ON s.genreID = g.genreID 
                    WHERE s.songID = :songID
                ");
                $currentGenreStmt->execute(['songID' => $songID]);
                $currentGenre = $currentGenreStmt->fetchColumn();
                
                if ($currentGenre !== $_POST['genre']) {
                    $genreStmt = $pdo->prepare("SELECT genreID FROM genre WHERE genrename = :genrename");
                    $genreStmt->execute(['genrename' => $_POST['genre']]);
                    $genreID = $genreStmt->fetchColumn();
                    
                    if (!$genreID) {
                        $insertGenre = $pdo->prepare("INSERT INTO genre (genrename) VALUES (:genrename)");
                        $insertGenre->execute(['genrename' => $_POST['genre']]);
                        $genreID = $pdo->lastInsertId();
                    }
                    
                    $songGenreStmt = $pdo->prepare("UPDATE song SET genreID = :genreID WHERE songID = :songID");
                    $songGenreStmt->execute(['genreID' => $genreID, 'songID' => $songID]);
                }
            } else {
                $songGenreStmt = $pdo->prepare("UPDATE song SET genreID = NULL WHERE songID = :songID");
                $songGenreStmt->execute(['songID' => $songID]);
            }
        }
        
        // 4. isSingle updaten 
        if (isset($_POST['isSingle'])) {
            $isSingle = (int)$_POST['isSingle'];
            $stmt = $pdo->prepare("UPDATE song SET isSingle = :isSingle WHERE songID = :songID");
            $stmt->execute(['isSingle' => $isSingle, 'songID' => $songID]);
        }
        
        // 5. Mood updaten
        if (isset($_POST['mood'])) {
            if (!empty(trim($_POST['mood']))) {
                // Mood prüfen
                $currentMoodStmt = $pdo->prepare("
                    SELECT m.moodname 
                    FROM song s 
                    LEFT JOIN mood m ON s.moodID = m.moodID 
                    WHERE s.songID = :songID
                ");
                $currentMoodStmt->execute(['songID' => $songID]);
                $currentMood = $currentMoodStmt->fetchColumn();
                
                if ($currentMood !== $_POST['mood']) {
                    $moodStmt = $pdo->prepare("SELECT moodID FROM mood WHERE moodname = :moodname");
                    $moodStmt->execute(['moodname' => $_POST['mood']]);
                    $moodID = $moodStmt->fetchColumn();
                    
                    if (!$moodID) {
                        $insertMood = $pdo->prepare("INSERT INTO mood (moodname) VALUES (:moodname)");
                        $insertMood->execute(['moodname' => $_POST['mood']]);
                        $moodID = $pdo->lastInsertId();
                    }
                    
                    $songMoodStmt = $pdo->prepare("UPDATE song SET moodID = :moodID WHERE songID = :songID");
                    $songMoodStmt->execute(['moodID' => $moodID, 'songID' => $songID]);
                }
            } else {
                $songMoodStmt = $pdo->prepare("UPDATE song SET moodID = NULL WHERE songID = :songID");
                $songMoodStmt->execute(['songID' => $songID]);
            }
        }
        
        // 6. Plattform updaten
        if (isset($_POST['plattform'])) {
            if (!empty(trim($_POST['plattform']))) {
                $plattformStmt = $pdo->prepare("SELECT plattformID FROM erscheinungsplattform WHERE plattformname = :plattformname");
                $plattformStmt->execute(['plattformname' => $_POST['plattform']]);
                $plattformID = $plattformStmt->fetchColumn();
                
                if (!$plattformID) {
                    $insertPlattform = $pdo->prepare("INSERT INTO erscheinungsplattform (plattformname) VALUES (:plattformname)");
                    $insertPlattform->execute(['plattformname' => $_POST['plattform']]);
                    $plattformID = $pdo->lastInsertId();
                }
                
                $albumStmt = $pdo->prepare("SELECT albumID FROM song WHERE songID = :songID");
                $albumStmt->execute(['songID' => $songID]);
                $albumID = $albumStmt->fetchColumn();
                
                if ($albumID) {
                    $pdo->prepare("UPDATE album SET plattformID = :plattformID WHERE albumID = :albumID")
                        ->execute(['plattformID' => $plattformID, 'albumID' => $albumID]);
                }
            } else {
                $albumStmt = $pdo->prepare("SELECT albumID FROM song WHERE songID = :songID");
                $albumStmt->execute(['songID' => $songID]);
                $albumID = $albumStmt->fetchColumn();
                
                if ($albumID) {
                    $pdo->prepare("UPDATE album SET plattformID = NULL WHERE albumID = :albumID")
                        ->execute(['albumID' => $albumID]);
                }
            }
        }
        
        // 7. Cover updaten
        if (isset($_POST['cover'])) {
            if (!empty(trim($_POST['cover']))) {
                $coverLink = trim($_POST['cover']);
                
                $insertCover = $pdo->prepare("INSERT INTO cover (link) VALUES (:link)");
                $insertCover->execute(['link' => $coverLink]);
                $newCoverID = $pdo->lastInsertId();
                
                $pdo->prepare("UPDATE song SET coverID = :coverID WHERE songID = :songID")
                    ->execute(['coverID' => $newCoverID, 'songID' => $songID]);
            } else {
                $pdo->prepare("UPDATE song SET coverID = NULL WHERE songID = :songID")
                    ->execute(['songID' => $songID]);
            }
        }
        
        // Artist updaten
        if (isset($_POST['artist'])) {
            
            $checkStmt = $pdo->prepare("SELECT COUNT(*) FROM song_artist WHERE songID = :songID");
            $checkStmt->execute(['songID' => $songID]);
            
            if ($checkStmt->fetchColumn() > 0) {
                $pdo->prepare("DELETE FROM song_artist WHERE songID = :songID")->execute(['songID' => $songID]);
            }
            
            if (!empty(trim($_POST['artist']))) {
                $currentArtistStmt = $pdo->prepare("
                    SELECT GROUP_CONCAT(a.artistname SEPARATOR ', ') as artists
                    FROM song_artist sa 
                    JOIN artist a ON sa.artistID = a.artistID 
                    WHERE sa.songID = :songID
                ");
                $currentArtistStmt->execute(['songID' => $songID]);
                $currentArtist = $currentArtistStmt->fetchColumn();
                
                if ($currentArtist !== $_POST['artist']) {
                    $artistStmt = $pdo->prepare("SELECT artistID FROM artist WHERE artistname = :artistname");
                    $artistStmt->execute(['artistname' => $_POST['artist']]);
                    $artistID = $artistStmt->fetchColumn();
                    
                    if (!$artistID) {
                        $insertArtist = $pdo->prepare("INSERT INTO artist (artistname) VALUES (:artistname)");
                        $insertArtist->execute(['artistname' => $_POST['artist']]);
                        $artistID = $pdo->lastInsertId();
                    }
                    
                    $linkArtist = $pdo->prepare("INSERT INTO song_artist (songID, artistID) VALUES (:songID, :artistID)");
                    $linkArtist->execute(['songID' => $songID, 'artistID' => $artistID]);
                }
            }
        }
        
        $pdo->commit();
        
        // Erfolgreiches Update - zurück zur Hauptseite
        header("Location: index.php?success=update");
        exit;
        
    } catch (PDOException $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        // Fehler - zurück zur Hauptseite mit Fehlermeldung
        header("Location: index.php?error=" . urlencode("Fehler: " . $e->getMessage()));
        exit;
    }
    
} else {
    header("Location: index.php");
    exit;
}
?>