-- Autor: Stefanie Ellersiek
-- Datum: 28.01.2026
-- Version: 2.0

/*Select-Statements für die Anzeige von Anwender-Statistiken.
  Zweck: Jeder Anwender kann seine persönliche Nutzungshistorie in der App auswerten.*/

-- Welches Genre bevorzugt der Anwender auf Basis seiner bisherigen Ausleihen?
-- Von welchem Genre hat er die meisten Bücher ausgeliehen?
-- ACHTUNG: Für Ausleihender wird hier statt eines Platzhalters eine Beispiel AID eingesetzt
SELECT
    b.Genre,
    COUNT(*) AS Anzahl
FROM Ausleihe au
JOIN Buch b ON b.BuchID = au.BuchID
WHERE au.Ausleihender = 5
GROUP BY b.Genre;

-- Bücher welches Autors bevorzugt der Anwender auf Basis seiner bisherigen Ausleihen?
-- Von welchem Autor hat er die meisten Bücher ausgeliehen?
-- ACHTUNG: Für Ausleihender wird hier statt eines Platzhalters eine Beispiel AID eingesetzt
SELECT
	aut.AutorID AS ID,
    aut.Vorname AS Autor_Vorname,
    aut.Nachname AS Autor_Nachname,
    COUNT(*) AS Anzahl
FROM Ausleihe au
JOIN Buch b ON b.BuchID = au.BuchID
JOIN Autor aut ON aut.AutorID = b.AutorID 
WHERE au.Ausleihender = 5
GROUP BY aut.AutorID, aut.Vorname, aut.Nachname
ORDER BY Anzahl DESC;

-- Bücher welches Anwenders bevorzugt der Anwender auf Basis seiner bisherigen Ausleihen?
-- Von welchem Anwender hat er bisher die meisten Bücher ausgeliehen?
-- ACHTUNG: Für Ausleihender wird hier statt eines Platzhalters eine Beispiel AID eingesetzt
SELECT
    besitzer.AID AS ID,
    besitzer.Vorname AS Vorname,
    besitzer.Nachname AS Nachname,
    COUNT(au.AusleihID) AS Anzahl
FROM Ausleihe au
INNER JOIN Buch b ON b.BuchID = au.BuchID
INNER JOIN Anwender ausleiher ON ausleiher.AID = au.Ausleihender
INNER JOIN Anwender besitzer ON besitzer.AID = b.AID          
WHERE au.Ausleihender = 5
GROUP BY besitzer.AID, besitzer.Vorname, besitzer.Nachname
ORDER BY Anzahl DESC;
;

-- Statement für Performance-Messung
SELECT a.Vorname
FROM Anwender a
LEFT JOIN Buch b ON b.AID = a.AID
WHERE a.AID = 98746;