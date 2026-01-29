-- Autor: Stefanie Ellersiek
-- Datum: 28.01.2026
-- Version: 1.0

-- Auswahl der zu verwendenden Datenbank
USE buchange;

/* Die folgenden INSERT INTO Statements enthalten Beispieldaten für die Tabellen der Datenbank. 
Damit die Beziehungen zwischen den Tabellen korrekt abgebildet werden, wird für die technischen IDs nicht auf AUTO_INCREMENT
zurückgegriffen, sondern die IDs manuell definiert.*/

INSERT INTO Anwender (AID, PasswortHash, Vorname, Nachname, EMail, Profilfoto, Administrator)
VALUES
(1, 'hashed_pass_1', 'Anna', 'Altenschulte', 'anna.altenschulte@web.de', NULL, FALSE),
(2, 'hashed_pass_2', 'Ben', 'Becker', 'ben.becker@web.de', NULL, FALSE),
(3, 'hashed_pass_3', 'Clara', 'Schmidt', 'clara.schmidt@web.de', NULL, FALSE),
(4, 'hashed_pass_4', 'David', 'Meyer', 'david.meyer@web.de', NULL, FALSE),
(5, 'hashed_pass_5', 'Eva', 'Wagner', 'eva.wagner@web.de', NULL, FALSE),
(6, 'hashed_pass_6', 'Felix', 'Hoffmann', 'felix.hoffmann@web.de', NULL, FALSE),
(7, 'hashed_pass_7', 'Greta', 'Klein', 'greta.klein@web.de', NULL,  TRUE),
(8, 'hashed_pass_8', 'Hannes', 'Fischer', 'hannes.fischer@web.de', NULL, FALSE),
(9, 'hashed_pass_9', 'Isabel', 'Krüger', 'isabel.krueger@web.de', NULL, FALSE),
(10, 'hashed_pass_10', 'Jonas', 'Vogel', 'jonas.vogel@web.de', NULL, FALSE);
;

INSERT INTO Autor (AutorID, Vorname, Nachname)
VALUES
(1, 'Jane', 'Austen'), 
(2, 'Ernest', 'Hemingway'), 
(3, 'Jacques', 'Berndorf'), 
(4, 'Joachim', 'Gauck'), 
(5, 'Caroline', 'Wahl'), 
(6, 'John', 'Irving'), 
(7, 'Chloe', 'Dalton'), 
(8, 'Jochen', 'Gutsch'), 
(9, 'Maxim', 'Leo'), 
(10, 'Henning', 'Mankell'), 
(11, 'Martin','Suter')
;

INSERT INTO Adresse (AdressID, Straße, Hausnummer, PLZ, Ort, Land, Breitengrad, Laengengrad, AID) 
VALUES 
(1, 'Dorfstraße', 23, '48488', 'Listrup', 'Deutschland', 52.3667, 7.5167, 1), 
(2, 'Alter Mühlenweg', 5, '48488', 'Listrup', 'Deutschland', 52.3670, 7.5170, 2), 
(3, 'Am Emstal', 12, '48488', 'Listrup', 'Deutschland', 52.3672, 7.5165, 3), 
(4, 'Am Haferkamp', 8, '48488', 'Listrup', 'Deutschland', 52.3665, 7.5175, 4), 
(5, 'Listruper Straße', 15, '48488', 'Listrup', 'Deutschland', 52.3675, 7.5160, 5), 
(6, 'Dorfstraße', 83, '48488', 'Listrup', 'Deutschland', 52.3668, 7.5172, 6), 
(7, 'Mühlenweg', 7, '48488', 'Listrup', 'Deutschland', 52.3671, 7.5168, 7), 
(8, 'Kirchstraße', 4, '48488', 'Listrup', 'Deutschland', 52.3669, 7.5171, 8), 
(9, 'Emsbürener Landstraße', 22, '48488', 'Listrup', 'Deutschland', 52.3673, 7.5163, 9), 
(10, 'Listruper Feldweg', 10, '48488', 'Listrup', 'Deutschland', 52.3666, 7.5173, 10)
;

INSERT INTO Abholinfo (AbholID, DGH, AbholzeitAb, AbholzeitBis, Wochentage, AdressID) 
VALUES 
(1, TRUE, '16:00:00', '19:00:00', 'Mo,Mi,Fr', 1), 
(2, FALSE, '10:00:00', '14:00:00', 'Sa', 2), 
(3, TRUE, '17:00:00', '20:00:00', 'Di,Do', 3), 
(4, TRUE, '15:00:00', '18:00:00', 'Mo-Fr', 4), 
(5, FALSE, '09:00:00', '12:00:00', 'So', 5), 
(6, TRUE, '18:00:00', '21:00:00', 'Mo,Do', 6), 
(7, TRUE, '14:00:00', '17:00:00', 'Mi,Fr', 7), 
(8, FALSE, '11:00:00', '15:00:00', 'Sa,So', 8), 
(9, TRUE, '16:30:00', '19:30:00', 'Mo-Do', 9), 
(10, TRUE, '15:00:00', '18:00:00', 'Fr', 10)
;

INSERT INTO Buch (BuchID, Titel, Genre, Jahr, Verlag, Zustand, Sprache, 
Leihdauer, AutorID, AID, AbholID) 
VALUES
(1, 'Stolz und Vorurteil', 'Klassiker', 1913, 'Reclam', 'wie neu', 'Deutsch', 30, 1, 1, 1), 
(2, 'Der alte Mann und das Meer', 'Klassiker', 1952, 'Rowohlt', 'leichte Gebrauchsspuren', 'Deutsch', 21, 2, 2, 2), 
(3, 'Eifel-Blues', 'Krimi', 1989, 'Grafit', 'leichte Gebrauchsspuren', 'Deutsch', 21, 3, 3, 3), 
(4, 'Erschütterungen', 'Sachbuch', 2023, 'Penguin', 'wie neu', 'Deutsch', 14, 4, 4, 4),
(5, 'Die Assistentin', 'Roman', 2022, 'Rowohlt', 'wie neu', 'Deutsch', 28, 5, 5, 5),
(6, 'Straße der Wunder', 'Roman', 1978, 'Diogenes', 'starke Gebrauchsspuren', 'Deutsch', 30, 6, 6, 6), 
(7, 'Hase und Ich', 'Sachbuch', 2023, 'Klett-Cotta', 'wie neu', 'Deutsch', 14, 7, 7, 7), 
(8, 'Frankie', 'Roman', 2023, 'Penguin', 'wie neu', 'Deutsch', 21, 8, 8, 8), 
(9, 'Mörder ohne Gesicht', 'Krimi', 1991, 'dtv', 'starke Gebrauchsspuren', 'Deutsch', 21, 9, 9, 9), 
(10, 'Gott des Waldes', 'Krimi', 2025, 'C.H.Beck', 'beschädigt', 'Deutsch', 30, 10, 1, 1),
(11, 'Melody', 'Roman', 2023, 'Diagones', 'wie neu', 'Deutsch', 20, 11, 10, 10)
;

INSERT INTO Anfrage (AnfrageID, DGH, Nachricht, AnfrageBestaetigt, Sender, BuchID) 
VALUES 
(1, TRUE, 'Ich würde das Buch gerne ausleihen.', FALSE, 10, 1), 
(2, FALSE, 'Ist das Buch noch verfügbar?', FALSE, 7, 2), 
(3, TRUE, NULL, FALSE, 6, 3), 
(4, TRUE, 'Großes Interesse an dem Buch', TRUE, 5, 1), 
(5, FALSE, NULL, TRUE, 4, 2), 
(6, TRUE, NULL, TRUE, 2, 3), 
(7, TRUE, 'Bin sehr vorsichtig mit Büchern', TRUE, 8, 4), 
(8, TRUE, NULL, TRUE, 3, 5), 
(9, FALSE, NULL, TRUE, 2, 6), 
(10, FALSE, 'Grüß Dich!', TRUE, 1, 7), 
(11, TRUE, NULL, TRUE, 7, 1), 
(12, TRUE, NULL, TRUE, 6, 9), 
(13, FALSE, 'Moin!', TRUE, 9, 8), 
(14, FALSE, NULL, TRUE, 10, 6), 
(15, TRUE, 'Tolles Buch!', TRUE, 7, 2), 
(16, TRUE, NULL, TRUE, 5, 7), 
(17, TRUE, NULL, TRUE, 8, 4), 
(18, TRUE, NULL, TRUE, 3, 5), 
(19, TRUE, NULL, TRUE, 9, 1);


INSERT INTO Ausleihe (AusleihID, Startdatum, Enddatum, AusleiheAktiv, BuchID, Verleiher, Ausleihender)
VALUES
(1, '2025-10-05', '2025-10-21', FALSE, 1, 1, 5),
(2, '2025-10-07', '2025-11-06', FALSE, 2, 2, 4),
(3, '2025-10-12', '2025-11-09', FALSE, 3, 3, 2),
(4, '2025-10-15', '2025-11-12', FALSE, 4, 4, 8),
(5, '2025-10-18', '2025-11-15', TRUE, 5, 5, 3),
(6, '2025-10-18', '2025-11-14', FALSE, 6, 6, 2),
(7, '2025-10-20', '2025-11-03', TRUE, 7, 7, 1),
(8, '2025-10-22', '2025-11-21', FALSE, 1, 1, 7),
(9, '2025-11-10', '2025-12-01', FALSE, 9, 9, 6),
(10, '2025-11-11', '2025-12-02', FALSE, 8, 8, 9),
(11, '2025-11-27', '2025-12-27', FALSE, 6, 6, 10),
(12, '2025-12-10', '2025-12-31', FALSE, 2, 2, 7),
(13, '2025-12-11', '2025-12-25', TRUE, 7, 7, 5),
(14, '2025-12-18', '2026-01-01', TRUE, 4, 4, 8),
(15, '2025-12-19', '2026-01-16', TRUE, 5, 5, 3),
(16, '2025-12-19', '2026-01-18', TRUE, 1, 1, 9)
;

INSERT INTO Rueckgabe (RueckgabeID, CheckAusl, TimestampAusl, CheckVerl, TimestampVerl, AusleihID)
VALUES
(1, TRUE, '2025-10-21', TRUE, '2025-10-22', 1),
(2, TRUE, '2025-11-06', TRUE, '2025-11-07', 2),
(3, TRUE, '2025-11-09', TRUE, '2025-11-11', 3),
(4, TRUE, '2025-11-12', TRUE, '2025-11-13', 4),
(5, TRUE, '2025-11-08', FALSE, NULL, 5),
(6, TRUE, '2025-11-15', TRUE, '2025-11-15', 8),
(7, TRUE, '2025-11-14', TRUE, '2025-11-15', 6),
(8, TRUE, '2025-12-02', TRUE, '2025-12-03', 9),
(9, TRUE, '2025-12-11', TRUE, '2025-12-12', 10),
(10, TRUE, '2025-12-18', TRUE, '2025-12-18', 11),
(11, TRUE, '2025-12-18', TRUE, '2025-12-18', 12);
;

INSERT INTO BuchBew (BuchBewID, Sterne, Kommentar, Timestamp, AID, BuchID)
VALUES
(1, '5', NULL, '2025-10-21 14:30:00', 5, 10),
(2, '4', NULL, '2025-11-06 16:45:00', 4, 9),
(3, '5', 'Hervorragend', '2025-11-09 11:20:00', 2, 8),
(4, '2', NULL, '2025-11-12 17:10:00', 8, 6),
(5, '5', NULL, '2025-11-08 15:25:00', 3, 2),
(6, '5', NULL, '2025-11-14 12:35:00', 2, 7),
(7, '2', 'Enttäschend', '2025-11-15 18:50:00', 7, 6),
(8, '2', NULL, '2025-12-11 16:15:00', 9, 1),
(9, '4', 'Erwartungen getroffen', '2025-12-18 13:30:00', 1, 2),
(10, '4', NULL, '2025-12-18 17:55:00', 7, 3)
;

INSERT INTO AnwBew (AnwBewID, Sterne, Kommentar, Timestamp, AusleihID, ErstellerID, EmpfaengerID)
VALUES
(1, '5', 'Einwandfrei', '2025-10-21 14:30:00', 1, 5, 5),
(2, '5', NULL, '2025-11-06 16:45:00', 2, 4, 4),
(3, '5', 'Super nett', '2025-11-09 11:20:00', 3, 2, 2),
(4, '5', NULL, '2025-11-12 17:10:00', 4, 8, 8),
(5, '5', NULL, '2025-11-05 18:50:00', 8, 7, 7),
(6, '5', 'Unkompliziert', '2025-11-14 12:35:00', 6, 2, 2),
(7, '5', NULL, '2025-12-10 16:15:00', 9, 6, 6),
(8, '5', NULL, '2025-12-02 17:55:00', 10, 9, 9),
(9, '5', NULL, '2025-12-27 13:30:00', 11, 1, 1),
(10, '5', NULL, '2025-12-24 14:30:00', 12, 7, 7)
;



