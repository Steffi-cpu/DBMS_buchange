-- Autor: Stefanie Ellersiek
-- Datum: 28.01.2026
-- Version: 2.0

-- Für die Erklärung der SQL Statements siehe die Beschreibungen zum Testfall in der PowerPoint-Präsentation.

INSERT INTO Anwender (AID,PasswortHash, Vorname, Nachname, EMail, Profilfoto, Administrator)
VALUES (11,'gehashtesPasswort', 'Alina', 'Nordmann', 'alina.nordmann@gmail.com', NULL, FALSE);

INSERT INTO Adresse (AdressID,Straße, Hausnummer, PLZ, Ort, Land, Breitengrad, Laengengrad, AID)
VALUES (11,'Ebendiekstraße', 8, '48488', 'Listrup', 'Deutschland', 52.531400, 7.487800, 11);

INSERT INTO Abholinfo (AbholID, DGH, AbholzeitAb, AbholzeitBis, Wochentage, AdressID) 
VALUES (11, TRUE, '18:00:00', '19:00:00', 'Do', 11);

INSERT INTO Autor (AutorID, Vorname, Nachname)
VALUES (12,'J.R.R', 'Tolkien');

INSERT INTO Buch (BuchID, Titel, Genre, Jahr, Verlag, Zustand, Sprache, 
Leihdauer, AutorID, AID, AbholID) 
VALUES (12, 'Der Herr der Ringe', 'Klassiker', 1958, 'Klett-Cotta Verlag', 'wie neu', 'Deutsch', 30, 12, 11, 11);

INSERT INTO Anfrage (AnfrageID, DGH, Nachricht, AnfrageBestaetigt, Sender, BuchID) 
VALUES (20, TRUE, 'Ich 	habe das Buch empfohlen bekommen.', FALSE, 11, 4); 

UPDATE Anfrage
SET AnfrageBestaetigt = TRUE
WHERE AnfrageID = 20
;

INSERT INTO Ausleihe (AusleihID, Startdatum, Enddatum, AusleiheAktiv, BuchID, Verleiher, Ausleihender)
VALUES (17, '2025-11-10', '2025-10-31', TRUE, 4, 4, 11);

INSERT INTO Rueckgabe (RueckgabeID, CheckAusl, TimestampAusl, CheckVerl, TimestampVerl, AusleihID)
VALUES (12, TRUE, '2025-10-25', FALSE, NULL, 17);

UPDATE Rueckgabe SET CheckVerl = TRUE, TimestampVerl = '2025-10-25' 
WHERE RueckgabeID = 12 AND AusleihID = 17;

UPDATE Ausleihe SET AusleiheAktiv = FALSE
WHERE AusleihID = 17 AND EXISTS (SELECT 1 FROM Rueckgabe
	WHERE Rueckgabe.AusleihID = Ausleihe.AusleihID 
    AND Rueckgabe.CheckAusl = TRUE
    AND Rueckgabe.CheckVerl = TRUE);

INSERT INTO BuchBew (BuchBewID, Sterne, Kommentar, Timestamp, AID, BuchID) 
VALUES (11, '5', 'Super spannend!','2025-10-28 22:02:14', 11, 4);

INSERT INTO AnwBew (AnwBewID, Sterne, Kommentar, Timestamp, AusleihID, ErstellerID, EmpfaengerID)
VALUES (11, '5', 'Sehr nett', '2025-10-28 23:00:05', 17, 4, 11);

-- Test des Triggers CheckAusleihe
INSERT INTO AnwBew (AnwBewID, Sterne, Kommentar, Timestamp, AusleihID, ErstellerID, EmpfaengerID)
VALUES (12, '5', 'Sehr nett', '2025-12-28 16:08:45', 14, 8, 4);

-- Test des Triggers CheckSperre
INSERT INTO Anfrage (AnfrageID, DGH, Nachricht, AnfrageBestaetigt, Sender, BuchID) 
VALUES (21, FALSE, NULL, FALSE, 3, 2); 

-- Test mit NULL-Werten: Vor- und Nachname sind NOT NULL definiert
INSERT INTO Anwender (AID,PasswortHash, Vorname, Nachname, EMail, Profilfoto, Administrator)
VALUES (12,'PWHash', NULL , NULL, 'test@gmail.com', NULL, FALSE);

-- Verletzung des Constraints check_DGH: Abholzeiten müssen gefüllt sein, wenn DGH FALSE
INSERT INTO Abholinfo (AbholID, DGH, AbholzeitAb, AbholzeitBis, Wochentage, AdressID) 
VALUES (13, FALSE, NULL, NULL, NULL, 11);

-- Test gegen UNIQUE-Bedinungen: Ein Anwender darf nicht 2 Adressen haben
INSERT INTO Adresse (AdressID,Straße, Hausnummer, PLZ, Ort, Land, Breitengrad, Laengengrad, AID)
VALUES (13,'Pumuckelstr.', 8, '48431', 'Rheine', 'Deutschland', 52.531400, 7.487800, 11);

-- Test gegen UNIQUE-Bedinungen: Es dürfen keine Dubletten bei Autor bestehen
INSERT INTO Autor (AutorID, Vorname, Nachname)
VALUES (13,'Joachim', 'Gauck');

-- Datentyp-Verletzungen: Sterne sind Char(1)
INSERT INTO BuchBew (BuchBewID, Sterne, Kommentar, Timestamp, AID, BuchID) 
VALUES (12, '10', 123,'2025-10-28', 11, 4);
