-- Autor: Stefanie Ellersiek
-- Datum: 29.01.2026
-- Version: 1.0

-- Zweck: Test von Isolationslevel READ COMMITTED

Use buchange;

SELECT *
FROM Anwender
WHERE EMail = 'minnie@gmail.com';
