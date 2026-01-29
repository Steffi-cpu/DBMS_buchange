-- Autor: Stefanie Ellersiek
-- Datum: 28.01.2026
-- Version: 2.0

/*View zur Prüfung der Fristüberschreitung
  Zweck: Dynamische Ermittlung der Anzahl und aktuellen Fristüberschreitungen
  auf Basis der aktuell in der Datenbank gespeicherten Informationen.*/
CREATE OR REPLACE VIEW ViewFristueber AS  
SELECT
    a.AID,
     -- Prüfung aktuelle Fristüberschreitung
         -- Für Testfallsimulation wird 20.12.2025 als Datum genutzt, im Betrieb ist CURDATE() zu nutzen
    MAX((ausl.AusleiheAktiv = TRUE AND r.TimestampAusl > ausl.Enddatum)
        OR (ausl.AusleiheAktiv = TRUE AND DATE('2025-12-20') > ausl.Enddatum)) 
	AS AktFristueber,
    -- Anzahl der Fristüberschreitungen inkl. der aktuellen Fristüberschreitung
    -- Für Testfallsimulation wird 20.12.2025 als Datum genutzt, im Betrieb ist CURDATE() zu nutzen
    SUM((r.TimestampAusl > ausl.Enddatum) OR 
    (ausl.AusleiheAktiv = TRUE AND DATE('2025-12-20') > ausl.Enddatum)) 
    AS AnzFristueber
FROM Anwender a
LEFT JOIN Ausleihe ausl ON ausl.Ausleihender = a.AID
LEFT JOIN Rueckgabe r ON r.AusleihID = ausl.AusleihID
GROUP BY a.AID;

/*View zu Sperren
  Zweck: Dynamische Ermittlung der Sperren auf Basis der Fristüberschreitungen*/
CREATE OR REPLACE VIEW ViewSperre AS
SELECT
    AID,
    -- Sperre, wenn max. Firstüberschreitung
    (AnzFristueber > 10) AS MaxSperre,
    -- Sperre, wenn aktuelle Firstüberschreitung
    (AktFristueber = 1) AS AktSperre,
    -- Prüfung, ob entweder Max oder Akt. Sperre gesetzt ist
    ((AnzFristueber > 10) OR (AktFristueber = 1)) AS Sperre
FROM ViewFristueber;

/*View zur Anzeige von verfügbaren Büchern
  Zweck: Es handelt sich um eine wiederkehrende Abfrage, um die verfügbaren Bücher mit allen für die Ausleihe relevanten Informationen 
  auf einer Karte abbilden zu können. Als verfügbar gelten nur Bücher,
     - deren Verleiher nicht gesperrt ist
     - die aktuell nicht aktiv ausgeliehen sind
   Ausleihe relevante Zusatzinformationen:
     - Aus Tabelle Buch: Titel, Genre, Zustand, Sprache, Leihdauer
     - Aus Tabelle Autor: zusammengefasster Vor- und Nachname
     - Aus Tabelle Anwender der Verleiher: zusammengefasster Vor- und Nachname
     - Aus der Tabelle Adresse die Geokoordinaten der Adresse des Verleihers
     - Aus der Tabelle Abholdinfo, ob die Abholung im Dorfgemeinschaftshaus (DGH) möglich ist
*/
CREATE OR REPLACE VIEW ViewVerfuegbareBuecher AS
SELECT
	b.BuchID,
	b.Titel,
	b.Genre,
	b.Jahr,
	b.Verlag,
	b.Zustand,
	b.Sprache,
	b.Leihdauer,
	CONCAT(aut.Vorname, ' ', aut.Nachname) AS AutorName,
	adr.Breitengrad,
	adr.Laengengrad,
	CONCAT(a.Vorname, ' ', a.Nachname) AS Verleiher,
    ab.DGH
FROM Buch b
-- Verknüpfung der Tabellen Buch, Autor, Anwender, Adresse und Abholinfo
INNER JOIN Autor aut ON b.AutorID = aut.AutorID
INNER JOIN Anwender a ON b.AID = a.AID
INNER JOIN Adresse adr ON b.AID = adr.AID
INNER JOIN Abholinfo ab ON b.AbholID = ab.AbholID
INNER JOIN ViewSperre vs ON b.AID = vs.AID
-- LEFT JOIN auf Ausleihe zur Ermittlung aktiver Ausleihen
LEFT JOIN Ausleihe ausl ON b.BuchID = ausl.BuchID AND ausl.AusleiheAktiv=TRUE
-- und anschließend Auswahl von BuchIDs, die keine aktive Ausleihe haben (ausl.BuchID IS NULL) und keine Anwender Sperre vorliegt
WHERE (vs.Sperre = FALSE AND
ausl.BuchID IS NULL
) 
;
