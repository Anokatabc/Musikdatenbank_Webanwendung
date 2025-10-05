<?php 
include "connection.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    $songID = $_POST['songID'] ?? '';
    
    if (empty($songID)) {
        header("Location: index.php?error=no_song_id");
        exit;
    }
    
    try {
        // Song-Name für Erfolgsmeldung holen
        $nameStmt = $pdo->prepare("SELECT songname FROM song WHERE songID = :songID");
        $nameStmt->execute(['songID' => $songID]);
        $songname = $nameStmt->fetchColumn();
        
        if (!$songname) {
            throw new Exception("Song nicht gefunden");
        }
        
        // Transaktion starten
        $pdo->beginTransaction();
        
        // Song löschen (CASCADE löscht automatisch song_artist)
        $stmt = $pdo->prepare("DELETE FROM song WHERE songID = :songID");
        $stmt->execute(['songID' => $songID]);
        
        // AUTO_INCREMENT zurücksetzen
        $pdo->exec("ALTER TABLE song AUTO_INCREMENT = 1");
        
        if ($pdo->inTransaction()) {
            $pdo->commit();
        }
        header("Location: index.php?success=deleted&song=" . urlencode($songname));
        exit;
        
    } catch (Exception $e) {
        // rollback wenn Transaktion aktiv
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        header("Location: index.php?error=delete_failed&msg=" . urlencode($e->getMessage()));
        exit;
    }
    
} else {
    header("Location: index.php?error=invalid_request");
    exit;
}
?>