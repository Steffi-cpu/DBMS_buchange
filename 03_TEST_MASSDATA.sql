-- Autor: Stefanie Ellersiek
-- Datum: 29.01.2026
-- Version: 1.0

-- Massendaten-Test
-- Zweck: Autmatische Erzeugung von vielen neuen Anwender-Datensätzen für Performance-Tests
-- Zur Durchführung muss das Rekursionslimit erhöht werden
-- Dies ist zwar speicherintensiv, wird jedoch nur einmalig für Performance-Tests benötigt

SET SESSION cte_max_recursion_depth = 100000;

INSERT INTO Anwender (PasswortHash, Vorname, Nachname, EMail)
-- Erzeugung einer Sequenz von Zahlen für die automatische Nummerierung
WITH RECURSIVE sequenz AS (
    -- Startwert n = entweder nächster Wert bei gefüllter Tabelle oder 1 bei leerer Tabelle
    SELECT IFNULL(MAX(AID),0) + 1 AS n, IFNULL(MAX(AID),0) + 100000 AS max_n
    FROM Anwender
    UNION ALL
    -- Solange n < max_n Erzeugung neuer Werte
    SELECT n + 1, max_n FROM sequenz
    WHERE n < max_n
)
-- Nutzung von n zur Erzeugung neuer Werte mit Konkatinierung
SELECT
    CONCAT('PWHash', n),       
    CONCAT('Vorname', n),      
    CONCAT('Nachname', n),     
    CONCAT('user', n, '@mail.com') 
FROM sequenz;
