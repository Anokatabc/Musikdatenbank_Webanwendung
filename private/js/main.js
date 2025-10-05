document.addEventListener('DOMContentLoaded', function() {
    // -- Feedback Popup abfragen und verstecken --
    const feedbackPopup = document.getElementById('feedbackPopup');
    if (feedbackPopup) {
        // URL-Parameter entfernen nach Popup-Anzeige
        const url = new URL(window.location);
        url.searchParams.delete('success');
        url.searchParams.delete('error');
        url.searchParams.delete('song');
        url.searchParams.delete('msg');
        window.history.replaceState({}, document.title, url);
        
        setTimeout(() => {
            feedbackPopup.style.opacity = '0';
            feedbackPopup.style.transition = 'opacity 0.5s ease';
            setTimeout(() => feedbackPopup.remove(), 500);
        }, 3000);
    }

    // -- Modale --
    const modals = {
        insert: document.getElementById("insertModal"),
        update: document.getElementById("updateModal")
    };
    
    // Hilfsfunktionen für modale Fenster
    const modalUtils = {
        open: function(modalId) {
            const modal = modals[modalId];
            if (modal) modal.style.display = "block";
        },
        
        close: function(modalId) {
            const modal = modals[modalId];
            if (modal) modal.style.display = "none";
        },
        
        hideAllErrors: function() {
            document.querySelectorAll('.error').forEach(err => {
                err.style.display = 'none';
            });
        }
    };
    
    // Trigger-Buttons einrichten
    document.getElementById("insertBtn")?.addEventListener('click', function() {
        modalUtils.open('insert');
    });
    
    // Edit-Buttons einrichten
    document.querySelectorAll('.edit-btn').forEach(button => {
        button.addEventListener('click', function() {
            // Daten aus data-Attributen holen
            const attributes = ['song-id', 'song-name', 'album-name', 'artist-name', 'genre-name', 
                               'is-single', 'mood-name', 'plattform-name', 'cover-link'];
            const data = {};
            
            // Alle data-Attribute dynamisch extrahieren
            attributes.forEach(attr => {
                const key = attr.replace(/-([a-z])/g, g => g[1].toUpperCase());
                data[key] = this.getAttribute('data-' + attr) || '';
            });
            
            // Modal-Felder füllen
            document.getElementById('updateSongID').value = data.songId;
            document.getElementById('updateSongname').value = data.songName;
            document.getElementById('updateAlbum').value = data.albumName;
            document.getElementById('updateArtist').value = data.artistName;
            document.getElementById('updateGenre').value = data.genreName;
            document.getElementById('updateMood').value = data.moodName;
            document.getElementById('updatePlattform').value = data.plattformName;
            document.getElementById('updateCover').value = data.coverLink;
            
            // Cover-Vorschau anzeigen
            const coverDisplay = document.getElementById('currentCoverDisplay');
            if (data.coverLink && data.coverLink.trim()) {
                const isValidImage = /\.(jpg|jpeg|png|gif|webp|bmp|svg)$/i.test(data.coverLink) || data.coverLink.startsWith('http');
                
                if (isValidImage) {
                    coverDisplay.innerHTML = `<img src="${data.coverLink}" alt="Aktuelles Cover" onclick="openCoverModal('${data.coverLink}')">`;
                } else {
                    const shortLink = data.coverLink.length > 25 ? data.coverLink.substring(0, 25) + '...' : data.coverLink;
                    coverDisplay.innerHTML = `<span class="cover-text">${shortLink}</span>`;
                }
            } else {
                coverDisplay.innerHTML = '<em>Kein Cover vorhanden</em>';
            }
            
            // Radio-Buttons für isSingle setzen
            const isSingle = data.isSingle === '1';
            document.getElementById('updateRadioAlbum').checked = !isSingle;
            document.getElementById('updateRadioSingle').checked = isSingle;
            document.getElementById('updateModalTitle').textContent = 
                `Song bearbeiten: ${data.songName || 'Unbekannt'}`;
            
            modalUtils.hideAllErrors();
            modalUtils.open('update');
        });
    });
    
    // -- Alle Modale schließen --
    // Alle Close-Buttons (X)
    document.querySelectorAll('.close').forEach(button => {
        button.addEventListener('click', function() {
            const modalId = this.getAttribute('data-modal');
            if (modalId === 'insertModal') modalUtils.close('insert');
            if (modalId === 'updateModal') modalUtils.close('update');
        });
    });
    
    // Alle Cancel-Buttons
    document.querySelectorAll('.cancel-btn').forEach(button => {
        button.addEventListener('click', function() {
            const modalId = this.getAttribute('data-modal');
            if (modalId === 'insertModal') modalUtils.close('insert');
            if (modalId === 'updateModal') modalUtils.close('update');
        });
    });
    
    // Modal schließen bei Klick außerhalb
    window.addEventListener('click', function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = "none";
        }
    });
});

// -- Modale Coverbilder --
function openCoverModal(imageSrc) {
    const modal = document.getElementById('coverModal');
    const modalImage = document.querySelector('.cover-modal-image');
    
    modalImage.src = imageSrc;
    modal.style.display = 'block';
}

function closeCoverModal() {
    const modal = document.getElementById('coverModal');
    modal.style.display = 'none';
}

// Cover Event-Listener
document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('coverModal');
    const closeBtn = document.querySelector('.cover-modal-close');
    
    // Schließen-Button
    if (closeBtn) {
        closeBtn.addEventListener('click', closeCoverModal);
    }
    
    // Klick außerhalb des Bildes
    if (modal) {
        modal.addEventListener('click', function(event) {
            if (event.target === modal) {
                closeCoverModal();
            }
        });
    }
    
    // Escape-Taste
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && modal && modal.style.display === 'block') {
            closeCoverModal();
        }
    });
});
