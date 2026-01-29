-- Autor: Stefanie Ellersiek
-- Datum: 28.01.2026
-- Version: 2.0

/*Transaktionen: Transaktionen werden erstellt, wenn eine Anwenderaktivität mehrere Tabellen beeinflusst und
somit die Datenkonsistenz zu sichern.
Für Fremdschlüssel werden zur Sicherung der Datenqualität Variablen definiert, 
um die IDs zwischen mehreren Tabellen konsistent zu verwenden.
Als Isolationslevel wird für alle Transaktionen READ COMMITTED definiert, 
da die Performance gegenüber jederzeitiger Datenkonsistenz bevorzugt wird. 
Das Risiko für Inkonsistenzen ist aufgrund der vorliegenden Datenbankstruktur gering.*/

-- 1. Registrierung eines neuen Anwenders führt zu Eintrag in Tabellen Anwender, Adresse und Abholinfo
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
-- Persönliche Daten anlegen
INSERT INTO Anwender (PasswortHash, Vorname, Nachname, EMail, Profilfoto, Administrator)
VALUES (?, ?, ?, ?, NULL, FALSE);
SET @AID = LAST_INSERT_ID();
-- Adresse anlegen
INSERT INTO Adresse (Straße, Hausnummer, PLZ, Ort, Land, Breitengrad, Laengengrad, AID)
VALUES (?, ?, ?, ?, ?, ?, ?, @AID);
SET @AdresseID = LAST_INSERT_ID();
-- Abholinfo für Bücher anlegen
INSERT INTO Abholinfo (DGH, AbholzeitAb, AbholzeitBis, Wochentage, AdressID)
VALUES (TRUE, ?, ?, ?, @AdresseID);
COMMIT;

-- 2. Erfassung eines neuen Buches führt zu Eintrag in Tabelle Buch und ggf. Autor
SET @AID = ?;          
SET @AbholID = ?; 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;     
START TRANSACTION;
-- Autor einfügen, falls noch nicht vorhanden.
-- ON DUPLICATE KEY UPDATE zur Dublettenvermeidung
INSERT INTO Autor (Vorname, Nachname)
VALUES (?, ?)
ON DUPLICATE KEY UPDATE AutorID = AutorID; 
-- AutorID ermitteln anhand von Vor- und Nachname zur Verwendung beim Einfügen des Buches
SELECT AutorID INTO @AutorID
FROM Autor
WHERE Vorname = ? AND Nachname = ?;
-- Buch erfassen mit Referenzen auf Autor, Anwender und Abholinfo
INSERT INTO Buch (Titel, Genre, Jahr, Verlag, Zustand, Sprache, Leihdauer, AutorID, AID, AbholID)
VALUES (?, ?, ?, ?, ?, ?, ?, @AutorID, @AID, @AbholID);
COMMIT;


-- 3. Bestätigung einer Anfrage führt zu Aktualisierung der Tabelle Anfrage und Eintrag in Tabelle Ausleihe
SET @AnfrageID = ?;  
SET @BuchID = ?;
SET @Verleiher = ?;
SET @Ausleihender = ?;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
-- Anfrage genehmigen
UPDATE Anfrage
SET AnfrageBestaetigt = TRUE
WHERE AnfrageID = @AnfrageID;
-- Ausleihe eintragen, nachdem Anfrage bestätigt
INSERT INTO Ausleihe (Startdatum, Enddatum, AusleiheAktiv, BuchID, Verleiher, Ausleihender)
VALUES (?, ?, TRUE, @BuchID, @Verleiher, @Ausleihender);
COMMIT;

-- 4. Bestätigung einer Buchrückgabe führt zu Aktualisierung der Tabellen Rückgabe und Ausleihe
SET @RueckgabeID = ?;  
SET @AusleihID = ?;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
-- Rückgabe aktualisieren: Status und Datum der Bestätigung setzen
UPDATE Rueckgabe
SET CheckVerl = TRUE,
    TimestampVerl = CURRENT_DATE
WHERE RueckgabeID = @RueckgabeID
  AND AusleihID = @AusleihID;
-- Ausleihe aktualisieren: Status der Ausleihe beenden, wenn Ausleiher und Verleiher in der Tabelle Rückgabe Bestägigung CheckAusl/Verl = TRUE
UPDATE Ausleihe
SET AusleiheAktiv = FALSE
WHERE AusleihID = @AusleihID
  AND EXISTS (
      SELECT 1
      FROM Rueckgabe
      WHERE AusleihID = @AusleihID
        AND CheckAusl = TRUE
        AND CheckVerl = TRUE
  );
COMMIT;

