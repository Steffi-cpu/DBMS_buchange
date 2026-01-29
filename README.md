# DBMS_buchange
Datenbank-Projekt für Buchaustausch-App

## Ziel
Das Projekt implementiert eine relationale Datenbank in MySQL zur Verwaltung von Buchausleihen innerhalb einer lokalen Gemeinschaft.
Die Datenbank bildet die Daten aller Prozesse von der Registrierung eines Anwenders über Anfrage, Ausleihe und Rückgabe eines Buches bis zur Bewertung ab.

## Umsetzung
- Anforderungsspezifikation und konzeptionelle Modellierung der Datenbankstruktur unter Berücksichtigung folgender Aspekte
	- Trennung von Stamm- und Bewegungsdaten
	- Nutzung von Primär- und Fremdschlüsseln zur Sicherstellung der referenziellen Integrität
	- Vermeidung redundanter Daten und Normalisierung der Tabellen bis zur 3. Normalform
	- Die Performance wird gegenüber maximaler Datenkonsistenz priorisiert
- Technische Realisierung der Datenbank in MySQL unter Berücksichtigung folgender Aspekte
	- Absicherung der Datenqualität durch Constraints und Trigger
	- Verwendung von Views zur dynamischen Berechnung abgeleiteter Zustände (z. B. Sperren, Fristüberschreitungen)
	- Einsatz von Transaktionen und Isolationslevel READ COMMITTED zur Sicherstellung der Datenkonsistenz
	- Indexierung zur Performanceoptimierung
- Implementierung von Testdaten zur Validierung der gewählten Entwicklungen

## Struktur
- Anforderungsspezifikation
- SQL-Skripte zur Erstellung der Datenbankstrukturen sowie Durchführung von Tests und Analysen
- Dokumentation mit Beschreibung der Skripte
- Beschreibung der Datenbankfunktionalität
- Abstract
- Link zum Github Repository
- README.md zur Projektübersicht


## Autorin
Stefanie Ellersiek  
29.01.2026
