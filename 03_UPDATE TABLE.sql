-- Autor: Stefanie Ellersiek
-- Datum: 28.01.2026
-- Version: 2.0

/*Zur korrekten Einbindung der UPDATE-Statements siehe Dokumentation in CREATE Table.
Das Fragezeichen symbolisiert Platzhalter, in denen je Anwendungsfall
die relevanten IDs einzutragen sind.*/

-- Wenn der Verleiher eine Anfrage zur Ausleihe eines Buches bestätigt, wird in der Tabelle der Anfragestatus TRUE gesetzt
UPDATE Anfrage
SET AnfrageBestaetigt = TRUE
WHERE AnfrageID = ?
;
 
-- Wenn der Verleiher den Erhalt des Buches bestätitgt, wird Status TRUE und Datum der Bestätigung in der Tabelle Rückgabe gesetzt
UPDATE Rueckgabe
SET CheckVerl = TRUE,
    TimestampVerl = CURRENT_DATE
WHERE RueckgabeID = ?
  AND AusleihID = ?;

-- Status der Ausleihe in der Tabelle Ausleihe wird beendet, wenn für Ausleiher und Verleiher in der Tabelle Rückgabe Bestägigung CheckAusl/Verl = TRUE
UPDATE Ausleihe
SET AusleiheAktiv = FALSE
WHERE AusleihID = ?
  AND EXISTS (
    SELECT 1
    FROM Rueckgabe
    WHERE Rueckgabe.AusleihID = Ausleihe.AusleihID
      AND Rueckgabe.CheckAusl = TRUE
      AND Rueckgabe.CheckVerl = TRUE
  );