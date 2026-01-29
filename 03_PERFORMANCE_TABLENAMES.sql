-- Autor: Stefanie Ellersiek
-- Datum: 29.01.2026
-- Version: 1.0

-- Zweck: Alle Tabellennamen im Performance Schema ermitteln und automatisch TRUNCATE-Statements erzeugen, 
-- um die Performance-Daten zu löschen

SELECT CONCAT('TRUNCATE TABLE performance_schema.', table_name, ';')
FROM information_schema.tables
WHERE table_schema = 'performance_schema';
