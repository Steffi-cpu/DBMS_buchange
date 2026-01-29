-- Autor: Stefanie Ellersiek
-- Datum: 29.01.2026
-- Version: 1.0

-- Anzahl der Tabellen
SELECT COUNT(*) AS Tabellenanzahl
FROM information_schema.tables
WHERE table_schema = 'buchange'
  AND table_type = 'BASE TABLE';

-- Anzahl der Views
SELECT COUNT(*) AS Viewanzahl
FROM information_schema.views
WHERE table_schema = 'buchange';

-- Anzahl der Einträge pro Tabelle
USE buchange;
SELECT 'Anwender' AS tabelle, 
COUNT(*) AS zeilen FROM Anwender
UNION ALL
SELECT 'Adresse', COUNT(*) FROM Adresse
UNION ALL
SELECT 'Abholinfo', COUNT(*) FROM Abholinfo
UNION ALL
SELECT 'Autor', COUNT(*) FROM Autor
UNION ALL
SELECT 'Buch', COUNT(*) FROM Buch
UNION ALL
SELECT 'Anfrage', COUNT(*) FROM Anfrage
UNION ALL
SELECT 'Ausleihe', COUNT(*) FROM Ausleihe
UNION ALL
SELECT 'Rueckgabe', COUNT(*) FROM Rueckgabe
UNION ALL
SELECT 'BuchBew', COUNT(*) FROM BuchBew
UNION ALL
SELECT 'AnwBew', COUNT(*) FROM AnwBew;

-- Größe der Datenbank
SELECT 
  table_schema AS Datenbank,
  ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS Groesse_DB
FROM information_schema.tables
WHERE table_schema = 'buchange';

-- Attribute je Tabelle
SELECT 
    table_name AS Tabelle,
    column_name AS Spalte,
    column_type AS Datentyp,
    is_nullable AS Null_erlaubt,
    column_default AS Default_gesetzt
FROM information_schema.columns
WHERE table_schema = 'buchange'
ORDER BY table_name;