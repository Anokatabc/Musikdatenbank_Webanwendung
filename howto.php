<?php include "header.php"?>

<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>How-To</title>
    <link rel="stylesheet" href="public/css/style.css">
</head>
<body id="howTo">
<div style="display:inline"><h2 style="border-bottom:1px solid lightblue; text-align:center; font-size:2.5em; padding: 4% 0 2%; color:rgba(4, 0, 46, 1);">Ein kleiner Leitfaden zur Datenbank</h2>
</div>    

<!-- <svg height="210" width="400" xmlns="http://www.w3.org/2000/svg">
  <path d="M150 5 L75 200 L225 200 Z"
  style="fill:none;stroke:green;stroke-width:3" />
</svg> -->
    
    <div class="howto-container">
        <div class="tutorial-section section-1">
            <div class="text-content">
                <h3>Navigation und Übersicht</h3>
                <p><span style="font-size: large; font-weight:500">Willkommen!</span> Ich führe Sie in drei Teilen durch die Funktionalität meiner Webseite.
                <br>
                Beginnen wir mit der Übersichtsseite. Auf diese kommen Sie zurück, wenn Sie oben auf 
                <b>Hauptseite</b> oder auch auf das Logo 🎼 klicken. <br>
                <br>- Die Übersichtsseite hat oben einen großen Button, mittels dessen man neue Songs in die Datenbank eintragen kann. Mehr hierzu im nächsten Teil.
                <br>- Die rot hervorgehobene Zeile am oberen Rand der Tabelle sind klickbare Felder, die eine Sortierfunktion beinhalten. Der erste Kick sortiert 
                aufsteigend, der zweite absteigend.
                <br>- Die grün hervorgehobenen Spalten sind ebenfalls klickbar. Diese initiieren eine Filter-Funktion. Alle Lieder von diesem Album oder Künstler oder 
                Genre oder Mood werden nun angezeigt.
                <br>- Schauen Sie zuletzt auf die beiden Symbole am rechten Ende jeder Zeile: 
                <br>Der Stift ✏️ öffnet ein Modal (ein temporäres Bearbeitungsfenster) zur Veränderung von Einträgen in der Datenbank. Es wird die aktuelle Zeile 
                bearbeitet. 
                <br>Das 
                Kreuz ❌ dient dem Löschen eines Datensatzes. Auch dieser behandelt die aktuell ausgewählte zeile.</p>
            </div>
            <div class="image-content">
            </div>
        </div>
        
        <div class="tutorial-section section-2">
            <div class="text-content">
                <h3>Songs hinzufügen</h3>
                <p>Klickt man auf den Button <b>Neuen Song hinzufügen</b>, öffnet sich ein Modal mit einem Formular. 
                Hier lassen sich alle relevanten Metadaten und Tabellenattribute eintragen. Das einzige Pflichtfeld
                ist hierbei der <b>Titel*</b>, mit einem Stern gekennzeichnet. Alle anderen Einträge dürfen leer
            stehen. Diese können sich dann später über die Bearbeitungsfunktion einfügen lassen.
            <br>
            Zwei Radio-Buttons
        in der Mitte übertragen ihren Wert direkt an die Datenbank. <b>Album</b> ist vorausgewählt.
        <br>
    Am unteren Ende des Formulars ist eine Checkbox verfügbar. Per Default herrscht eine Auto-Formatierungsfunktion, 
welche den ersten Buchstaben jedes Wortes großschreibt. Mit einem Haken in der Checkbox lässt sich diese Funktion 
deaktivieren, um z.B. Song-Titel wie "MiiO" einzutragen. Sobald eine Kategorie mit einer ungewöhnlichen Schreibweise 
in der Datenbank vorliegt, werden nachfolgende Einträge ungeachtet der Formatierung dieser Schreibweise angeglichen.</p>
            </div>
            <div class="image-content">
            </div>
        </div>
        
        <div class="tutorial-section section-3">
            <div class="text-content">
                <h3>Songs bearbeiten</h3>
                <p>Ein Klick auf den Stift ✏️ öffnet ein Bearbeitungsfenster. Hier lassen sich vorhandene 
                    Einträge in der Datenbank ändern oder anpassen. Löscht man einfach den Inhalt eines 
                    Feldes und drückt auf <b>Song aktualisieren</b>, so wird das Feld einfach auf <i>NULL</i> gesetzt. 
                    
                    <br>
                    <br>
                    Existente Werte des jeweiligen Datensatzes werden in das Bearbeitungsfeld geladen 
                    und sind vorausgewählt.
                    
                    <br>
                    <br> 
                    Viel Erfolg!
                </p>
            </div>
            <div class="image-content">
            </div>
        </div>
    </div>
</body>
</html>

<?php include "footer.php"?>