-- Autor: Stefanie Ellersiek
-- Datum: 29.01.2026
-- Version: 1.0

-- Zweck: Test von Isolationslevel READ COMMITTED

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

INSERT INTO Anwender (PasswortHash, Vorname, Nachname, EMail, Profilfoto, Administrator)
VALUES ('HashPW', 'Minnie', 'Musterfrau', 'minnie@gmail.com', NULL, FALSE);

SET @AID = LAST_INSERT_ID();

INSERT INTO Adresse (Straße, Hausnummer, PLZ, Ort, Land, Breitengrad, Laengengrad, AID)
VALUES ('Salinenstr.', '8a', '4831', 'Rheine', 'DE', 41.0, 71.0, @AID);

-- Anwender ist noch dabei Abholinfos anzugeben, daher keine Commit-Bestätigung

