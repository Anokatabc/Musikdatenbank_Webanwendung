<?php include "connection.php";?>
<?php include "header.php";?>

<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Musikdatenbank</title>
    <script defer type="text/javascript" src="private/js/main.js"></script>
    <link rel="stylesheet" href="public/css/style.css">
    <style>
        /* .form-column {
            position: relative;
            z-index: 10;
        } */
        /* .form-column input, 
        .form-column textarea, 
        .form-column select {
            pointer-events: auto !important;
            position: relative;
        } */
    </style>
</head>
<body>
    <header style="align-items: center; text-align: center; font-size: x-large;">
         <h1>Meine<br>Musikdatenbank</h1>
    </header>

    <main class="content">
        <section>
            <div id="overview-header">
                <!-- <h2>Übersicht</h2> -->
                <button id="insertBtn" class="btn">Neuen Song hinzufügen</button>
            </div>
            
            <?php
            // Feedback-Nachrichten als temporäre Popups
            if (isset($_GET['success'])) {
                $successType = $_GET['success'];
                echo '<div id="feedbackPopup" style=" position: fixed; 
                                                      top: 20px; 
                                                      right: 20px; 
                                                      background: #cce7ff; 
                                                      color: #1a365d;
                                                      padding: 15px 20px;
                                                      border-radius: 8px;
                                                      border: 1px solid #90c9ff;
                                                      box-shadow: 0 4px 8px rgba(0,0,0,0.2);
                                                      z-index: 1000;
                                                      font-weight: bold;">';
                if ($successType === 'insert') {    
                    echo '✔ Song wurde erfolgreich hinzugefügt!';
                } elseif ($successType === 'update') {
                    echo '✏️ Song wurde erfolgreich aktualisiert!';
                } elseif ($successType === 'deleted') {
                    $songname = $_GET['song'] ?? 'Song';
                    echo '❌ "' . htmlspecialchars($songname) . '" wurde erfolgreich gelöscht!';
                }
                echo '</div>';
            }
            
            if (isset($_GET['error'])) {
                echo '<div id="feedbackPopup" style="position: fixed; top: 20px; right: 20px; background: #ffe6e6; color: #8b1538; padding: 15px 20px; border-radius: 8px; border: 1px solid #ff9999; box-shadow: 0 4px 8px rgba(0,0,0,0.2); z-index: 1000; font-weight: bold;">';
                echo '❌ ' . htmlspecialchars($_GET['error']);
                echo '</div>';
            }
            ?>
            
            <?php
            $filterColumn = null;
            $filterValue = null;
            if (!empty($_GET['filter']) && !empty($_GET['value'])) {
                $filterColumn = $_GET['filter'];
                $filterValue = $_GET['value'];
            }
            
            $sortColumn = $_GET['sort'] ?? 'id';
            $sortOrder = $_GET['order'] ?? 'asc';
            
            $validSortColumns = [
                'id' => 's.songID',
                'songname' => 's.songname',
                'type' => 's.isSingle',
                'album' => 'a.albumname',
                'artist' => 'ar.artistname', 
                'genre' => 'g.genrename',
                'mood' => 'm.moodname',
                'platform' => 'ep.plattformname',
                'cover' => 'c.link'
            ];
            
            $orderByColumn = $validSortColumns[$sortColumn] ?? 's.songID';
            $orderByDirection = ($sortOrder === 'desc') ? 'DESC' : 'ASC';
            
            $currentParams = [];
            if ($filterColumn && $filterValue) {
                $currentParams[] = 'filter=' . urlencode($filterColumn);
                $currentParams[] = 'value=' . urlencode($filterValue);
            }
            $currentParamsString = implode('&', $currentParams);
            
            function getSortLink($column, $currentSort, $currentOrder, $currentParams) {
                $newOrder = ($currentSort === $column && $currentOrder === 'asc') ? 'desc' : 'asc';
                $params = [];
                if (!empty($currentParams)) $params[] = $currentParams;
                $params[] = 'sort=' . $column;
                $params[] = 'order=' . $newOrder;
                return '?' . implode('&', $params);
            }
            
            function getSortIcon($column, $currentSort, $currentOrder) {
                if ($currentSort !== $column) return '';
                return $currentOrder === 'asc' ? ' ⇡' : ' ⇣';
            }
            
            function isValidImagePath($path) {
                if (empty($path)) return false;
                
                if (filter_var($path, FILTER_VALIDATE_URL)) return true;
                
                $extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'];
                $ext = strtolower(pathinfo($path, PATHINFO_EXTENSION));
                return in_array($ext, $extensions);
            }
            ?>
            
            <?php if ($filterValue): ?>
                <div class="filter-status">
                    <strong>Filter aktiv:</strong> <?= htmlspecialchars(ucfirst($filterColumn)) ?> = "<?= htmlspecialchars($filterValue) ?>" 
                    <a href="?" class="filter-reset">✕ Filter zurücksetzen</a>
                </div>
            <?php endif; ?>
            <div class="table-scroll-container">
                <table id="overview">
                <colgroup>
                    <col>  <!-- 1. ID -->
                    <col>  <!-- 2. Titel -->
                    <col>  <!-- 3. Album -->
                    <col>  <!-- 4. Künstler -->
                    <col>  <!-- 5. Genre -->
                    <col>  <!-- 6. Mood -->
                    <col>  <!-- 7. Plattform -->
                    <col>  <!-- 8. Cover -->
                    <col>  <!-- 9. Edit -->
                    <col>  <!-- 10. Delete -->
                </colgroup>
                <thead>
                    <tr>
                        <th><a href="<?= getSortLink('id', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">#<?= getSortIcon('id', $sortColumn, $sortOrder) ?></a></th>
                        <th><a href="<?= getSortLink('songname', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Song<?= getSortIcon('songname', $sortColumn, $sortOrder) ?></a></th>
                        <th><a href="<?= getSortLink('album', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Album<?= getSortIcon('album', $sortColumn, $sortOrder) ?></a></th>
                        <th><a href="<?= getSortLink('artist', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Künstler<?= getSortIcon('artist', $sortColumn, $sortOrder) ?></a></th>
                        <th><a href="<?= getSortLink('genre', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Genre<?= getSortIcon('genre', $sortColumn, $sortOrder) ?></a></th>
                        <th><a href="<?= getSortLink('mood', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Mood<?= getSortIcon('mood', $sortColumn, $sortOrder) ?></a></th>
                        <th><a href="<?= getSortLink('platform', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Plattform<?= getSortIcon('platform', $sortColumn, $sortOrder) ?></a></th>
                        <th><a href="<?= getSortLink('cover', $sortColumn, $sortOrder, $currentParamsString) ?>" class="sort-link">Cover<?= getSortIcon('cover', $sortColumn, $sortOrder) ?></a></th>
                        <th>Upd.</th>
                        <th>Del.</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    try {
                        $song = "SELECT s.songID, s.songname, s.isSingle,
                                        a.albumname, ar.artistname, g.genrename,
                                        m.moodname, ep.plattformname, c.link as coverlink
                                FROM song s
                                LEFT JOIN album a ON s.albumID = a.albumID
                                LEFT JOIN song_artist sa ON s.songID = sa.songID
                                LEFT JOIN artist ar ON sa.artistID = ar.artistID
                                LEFT JOIN genre g ON s.genreID = g.genreID
                                LEFT JOIN mood m ON s.moodID = m.moodID
                                LEFT JOIN erscheinungsplattform ep ON a.plattformID = ep.plattformID
                                LEFT JOIN cover c ON s.coverID = c.coverID";
                        
                        if ($filterColumn && $filterValue) {
                            switch($filterColumn) {
                                case 'album':
                                    $song .= " WHERE a.albumname = " . $pdo->quote($filterValue);
                                    break;
                                case 'artist':
                                    $song .= " WHERE ar.artistname = " . $pdo->quote($filterValue);
                                    break;
                                case 'genre':
                                    $song .= " WHERE g.genrename = " . $pdo->quote($filterValue);
                                    break;
                                case 'mood':
                                    $song .= " WHERE m.moodname = " . $pdo->quote($filterValue);
                                    break;
                            }
                        }
                        
                        $song .= " ORDER BY {$orderByColumn} {$orderByDirection}";
                        
                        $stmt = $pdo->query($song);
                        
                        if ($stmt->rowCount() > 0) {
                            foreach ($stmt as $row) {
                                echo "<tr>
                                    <td>" . htmlspecialchars($row['songID']) . "</td>
                                    <td>" . htmlspecialchars($row['songname']) . "</td>
                                    <td>
                                        " . (!empty($row['albumname']) ? 
                                            "<a href='?filter=album&value=" . urlencode($row['albumname']) . "' class='filter-link'>" . 
                                            htmlspecialchars($row['albumname']) . "</a>" 
                                            : '') . "
                                    </td>
                                    <td>
                                        " . (!empty($row['artistname']) ? 
                                            "<a href='?filter=artist&value=" . urlencode($row['artistname']) . "' class='filter-link'>" . 
                                            htmlspecialchars($row['artistname']) . "</a>" 
                                            : '') . "
                                    </td>
                                    <td>
                                        " . (!empty($row['genrename']) ? 
                                            "<a href='?filter=genre&value=" . urlencode($row['genrename']) . "' class='filter-link'>" . 
                                            htmlspecialchars($row['genrename']) . "</a>" 
                                            : '') . "
                                    </td>
                                    <td>
                                        " . (!empty($row['moodname']) ? 
                                            "<a href='?filter=mood&value=" . urlencode($row['moodname']) . "' class='filter-link'>" . 
                                            htmlspecialchars($row['moodname']) . "</a>" 
                                            : '') . "
                                    </td>
                                    <td>" . htmlspecialchars($row['plattformname'] ?? '') . "</td>
                                    <td>
                                        " . (!empty($row['coverlink']) ? 
                                            (isValidImagePath($row['coverlink']) ? 
                                                "<img src='" . htmlspecialchars($row['coverlink']) . "' 
                                                      alt='Cover' 
                                                      class='cover-thumbnail'
                                                      onclick='openCoverModal(\"" . htmlspecialchars($row['coverlink']) . "\")'>" :
                                                "<span class='cover-text'>" . htmlspecialchars(substr($row['coverlink'], 0, 25)) . 
                                                (strlen($row['coverlink']) > 25 ? '...' : '') . "</span>"
                                            ) : '') . "
                                    </td>
                                    <td>
                                        <button class='edit-btn' 
                                            data-song-id='" . $row['songID'] . "'
                                            data-song-name='" . htmlspecialchars($row['songname']) . "'
                                            data-is-single='" . $row['isSingle'] . "'
                                            data-album-name='" . htmlspecialchars($row['albumname'] ?? '') . "'
                                            data-artist-name='" . htmlspecialchars($row['artistname'] ?? '') . "'
                                            data-genre-name='" . htmlspecialchars($row['genrename'] ?? '') . "'
                                            data-mood-name='" . htmlspecialchars($row['moodname'] ?? '') . "'
                                            data-plattform-name='" . htmlspecialchars($row['plattformname'] ?? '') . "'
                                            data-cover-link='" . htmlspecialchars($row['coverlink'] ?? '') . "'
                                            title='Bearbeiten'>✏️
                                        </button>
                                    </td>    
                                    <td>
                                        <form action='delete.php' method='POST'
                                            onsubmit='return confirm(\"Song ID " . $row['songID'] . " wirklich löschen?\");'>
                                            <input type='hidden' name='songID' value='" . $row['songID'] . "'>
                                            <button class='delete-btn' type='submit' title='Löschen'>❌</button>
                                        </form>
                                    </td>
                                </tr>";
                            }
                        } else {
                            echo "<tr><td colspan='6'>Keine Songs gefunden</td></tr>";
                        }
                        
                    } catch (PDOException $e) {
                        echo "<tr><td colspan='6'>Fehler beim Laden der Songs: " . htmlspecialchars($e->getMessage()) . "</td></tr>";
                    }
                    ?>
                </tbody>
            </table>
            </div>
        </section>
    </main>

    <!-- Insert Modal -->
       <div id="insertModal" class="modal">
        <div class="modal-content modal-insert">
            <span class="close" data-modal="insertModal">&times;</span>
            <h2>Neuen Song hinzufügen</h2>
            
            <form id="insertForm" action="insert.php" method="POST">
                <span id="explainer">(▼Vorschläge aus der Datenbank)</span>  
                <div class="modalField-small">
                    <label for="song">Titel*:</label>
                    <input id="song" type="text" name="song" autocomplete="off" required>
                </div>

                <div class="modalField-small">
                    <label for="album">Album:</label>
                    <input id="album" type="text" name="album" list="albumList" autocomplete="off">
                    <datalist id="albumList">
                        <?php
                        try {
                            $albumStmt = $pdo->query("SELECT DISTINCT albumname FROM album WHERE albumname IS NOT NULL ORDER BY albumname");
                            while ($album = $albumStmt->fetch()) {
                                echo '<option value="' . htmlspecialchars($album['albumname']) . '">';
                            }
                        } catch (PDOException $e) {
                            echo '<option value="Fehler beim Laden">';
                        }
                        ?>
                    </datalist>
                </div>

                <div class="modalField-small">
                    <label for="artist">Artist:</label>
                    <input id="artist" type="text" name="artist" list="artistList" autocomplete="off">
                    <datalist id="artistList">
                        <?php
                        try {
                            $artistStmt = $pdo->query("SELECT DISTINCT artistname FROM artist WHERE artistname IS NOT NULL ORDER BY artistname");
                            while ($artist = $artistStmt->fetch()) {
                                echo '<option value="' . htmlspecialchars($artist['artistname']) . '">';
                            }
                        } catch (PDOException $e) {
                            echo '<option value="Fehler beim Laden">';
                        }
                        ?>
                    </datalist>
                </div>

                <div class="modalField-small">
                    <label for="genre">Genre:</label>
                    <input id="genre" type="text" name="genre" list="genreList" autocomplete="off">
                    <datalist id="genreList">
                        <?php
                        try {
                            $genreStmt = $pdo->query("SELECT DISTINCT genrename FROM genre WHERE genrename IS NOT NULL ORDER BY genrename");
                            while ($genre = $genreStmt->fetch()) {
                                echo '<option value="' . htmlspecialchars($genre['genrename']) . '">';
                            }
                        } catch (PDOException $e) {
                            echo '<option value="Fehler beim Laden">';
                        }
                        ?>
                    </datalist>
                </div>

                <div class="modalField-small">
                    <label for="mood">Mood:</label>
                    <input id="mood" type="text" name="mood" list="moodList" autocomplete="off">
                    <datalist id="moodList">
                        <?php
                        try {
                            $moodStmt = $pdo->query("SELECT DISTINCT moodname FROM mood WHERE moodname IS NOT NULL ORDER BY moodname");
                            while ($mood = $moodStmt->fetch()) {
                                echo '<option value="' . htmlspecialchars($mood['moodname']) . '">';
                            }
                        } catch (PDOException $e) {
                            echo '<option value="Fehler beim Laden">';
                        }
                        ?>
                    </datalist>
                </div>

                <!-- Radio Buttons Album / Single -->
                <div class="modalField-radio">
                    <label>Typ:</label>
                    <input id="radio-album" type="radio" name="isSingle" value="0" checked>    
                    <label for="radio-album">Album</label>
                    <input id="radio-single" type="radio" name="isSingle" value="1">
                    <label for="radio-single">Single</label>
                </div>
                <div class="modalField-large">
                    <label for="plattform">Plattform:</label>
                    <input id="plattform" type="text" name="plattform" list="plattformList" autocomplete="off" placeholder="Unbekannt">
                    <datalist id="plattformList">
                        <?php
                        try {
                            $plattformStmt = $pdo->query("SELECT DISTINCT plattformname FROM erscheinungsplattform WHERE plattformname IS NOT NULL ORDER BY plattformname");
                            while ($plattform = $plattformStmt->fetch()) {
                                echo '<option value="' . htmlspecialchars($plattform['plattformname']) . '">';
                            }
                        } catch (PDOException $e) {
                            echo '<option value="Fehler beim Laden">';
                        }
                        ?>
                    </datalist>
                </div>
                    <br>
                <div class="modalField-large">
                    <label for="cover">Coverbild:</label>
                    <input id="cover" type="text" name="cover" autocomplete="off" placeholder="Link zu einem Bild">
                </div>

                <div class="modalField-submit">
                    <input type="submit" value="Song hinzufügen">
                    <button type="button" class="cancel-btn" data-modal="insertModal">Abbrechen</button>
                </div>

                <div class="form-checkbox" style="margin: 10px 0;">
                    <input type="checkbox" name="disable_formatting" id="disableFormatting" value="1">
                    <label for="disableFormatting">Auto-Formatierung deaktivieren — exakt wie eingegeben speichern. <br></label>
                    <span style="font-size: small;">(Unwirksam bei bereits vorhandenen gleichnamigen Einträgen.)</span>
                </div>
            </form>
        </div>
    </div>

    <!-- Update Modal -->
    <div id="updateModal" class="modal">
                           
    <div class="modal-content modal-update">
        <h2 id="updateModalTitle">Song bearbeiten</h2> 
            <span class="close" data-modal="updateModal">&times;</span>

            
            <div class="modal-layout">
                <div class="form-column">
                    <form id="updateForm" action="update.php" method="POST">
                        <input type="hidden" id="updateSongID" name="songID">
                        <p class="modalField-small">
                            <label for="updateSongname">Song*:</label>
                            <input class="input-text" type="text" id="updateSongname" name="songname" autocomplete="off" required>
                        </p>
                        <p class="modalField-small">
                            <label for="updateAlbum">Album:</label>
                            <input class="input-text" type="text" id="updateAlbum" name="album" list="albumList" autocomplete="off">
                        </p>
                        <p class="modalField-small">
                            <label for="updateArtist">Artist:</label>
                            <input class="input-text" type="text" id="updateArtist" name="artist" list="artistList" autocomplete="off">
                        </p>
                        <p class="modalField-small">
                            <label for="updateGenre">Genre:</label>
                            <input class="input-text" type="text" id="updateGenre" name="genre" list="genreList" autocomplete="off">
                        </p>
                        <p class="modalField-small"> 
                            <label for="updateMood">Mood:</label>
                            <input class="input-text" type="text" id="updateMood" name="mood" list="moodList" autocomplete="off">
                        </p>
                        <!-- Radio Buttons für isSingle -->
                        <p>
                            <div class="modalField-radio">
                                <label>Typ:</label>
                                <input id="updateRadioAlbum" type="radio" name="isSingle" value="0" checked>    
                                <label for="updateRadioAlbum">Album</label>
                                <input id="updateRadioSingle" type="radio" name="isSingle" value="1">
                                <label for="updateRadioSingle">Single</label>
                            </div>
                        </p>
                        
                        <p class="modalField-large">
                            <label for="updatePlattform">Plattform:</label>
                            <input class="input-text" type="text" id="updatePlattform" name="plattform" list="plattformList" autocomplete="off" placeholder="Unbekannt">
                        </p>
                        <br>
                        <p class="modalField-large">
                            <label for="updateCover">Coverbild:</label>
                            <input class="input-text" type="text" id="updateCover" name="cover" autocomplete="off" placeholder="Link zu einem Bild">
                        </p>
                        
                        <p class="modalField-submit">
                            <input type="submit" value="Song aktualisieren">
                            <button type="button" class="cancel-btn" data-modal="updateModal">Abbrechen</button>
                        </p>
                        
                        <div id="updateErrorMsg" class="error" style="display:none;"></div>
                    </form>
                </div>
                
                <div class="cover-column">
                    <div class="cover-section">
                        <div class="cover-title">Aktuelles Cover:</div>
                        <div id="currentCoverDisplay" class="cover-display">
                            <em>Wird geladen...</em>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Cover Modal -->
    <div id="coverModal" class="cover-modal">
        <span class="cover-modal-close">&times;</span>
        <img class="cover-modal-image" src="" alt="Cover">
    </div>
</body>
</html>

<?php include "footer.php" ?>