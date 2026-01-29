-- Autor: Stefanie Ellersiek
-- Datum: 28.01.2026
-- Version: 2.0

-- Auswahl der zu verwendenden Datenbank
USE buchange;

-- Die hier angegebene Reihenfolge zur Anlage der Tabellen ist einzuhalten.

/*Tabelle: Anwender
  Zweck: Speicherung aller registrierten Benutzer der App
  Besonderheiten: 
	- Pflichtangaben sind Vorname, Nachname und E-Mail, daher sind Attribute NOT NULL*/
CREATE TABLE Anwender (AID INTEGER PRIMARY KEY AUTO_INCREMENT, 
PasswortHash VARCHAR(255), 
Vorname VARCHAR(100) NOT NULL, 
Nachname VARCHAR(100) NOT NULL, 
EMail VARCHAR(255) NOT NULL, 
Profilfoto BLOB, 
-- Normale Anwender: Administrator = FALSE
Administrator BOOLEAN DEFAULT FALSE
); 

/*Tabelle: Adresse
  Zweck: Speicherung der Anwender-Adressen
  Beziehungen: Jede Adresse ist einem Anwender zugeordnet. Ein Anwender darf nur eine Adresse haben, daher UNIQUE.
  Besonderheiten:
	- Alle Attribute sind Pflicht, daher NOT NULL*/
CREATE TABLE Adresse (
    AdressID INTEGER PRIMARY KEY AUTO_INCREMENT,
    Straße VARCHAR(500) NOT NULL,
    -- VARCHAR für Hausnummern mit Zusatz
    Hausnummer VARCHAR(20) NOT NULL,
    PLZ CHAR(5) NOT NULL,
    Ort VARCHAR(100) NOT NULL,
    Land VARCHAR(100) NOT NULL,
    Breitengrad DECIMAL(9,6) NOT NULL,
    Laengengrad DECIMAL(9,6) NOT NULL,
    AID INTEGER UNIQUE NOT NULL,
    FOREIGN KEY (AID) REFERENCES Anwender(AID)
);

/*Tabelle: Abholinfo
  Zweck: Speicherung der Informationen zur Abholung eines Buches
  Beziehungen: Jede Abholinfo ist einer Adresse zugeordnet
  Besonderheiten:
	- Pflichtangaben sind DGH sowie der Fremdschlüssel AdressID, daher NOT NULL
    - Zu einer Adresse kann es mehrere Abholinformationen aufgrund mehrerer Anwender an einer Adresse geben, daher kein UNIQUE*/
CREATE TABLE Abholinfo (
    AbholID INTEGER PRIMARY KEY AUTO_INCREMENT,
    -- DGH gibt an, ob eine Abholung im Dorfgemeinschaftshaus möglich ist
    DGH BOOLEAN NOT NULL,
    AbholzeitAb TIME,
    AbholzeitBis TIME,
    Wochentage VARCHAR(500),
    AdressID INTEGER NOT NULL,
    FOREIGN KEY (AdressID) REFERENCES Adresse(AdressID),
    -- die Abholzeiten und -tage müssen nur gefüllt werden, wenn DGH = FALSE
    CONSTRAINT check_DGH CHECK (
		DGH = TRUE OR (AbholzeitAb IS NOT NULL AND AbholzeitBis IS NOT NULL AND Wochentage IS NOT NULL)
		)
);

/*Tabelle: Autor
  Zweck: Die Informationen zum Autor werden in eigener Tabelle gespeichert, da Vor- und Nachname nicht direkt von der BuchID abhängen
  Besonderheiten:
  - Pflichtangaben für den Autor sind Vorname und Nachname, daher NOT NULL*/
CREATE TABLE Autor (
    AutorID INTEGER PRIMARY KEY AUTO_INCREMENT,
    Vorname VARCHAR(100) NOT NULL,
    Nachname VARCHAR(100) NOT NULL,
    -- Zur Vermeidung von Dubletten bei gleichzeitiger Anlage gilt ein Unique-Constraint für die Kombination aus Vor- und Nachnamen
    UNIQUE KEY uq_autor (Vorname, Nachname)
);

/*Tabelle: Buch
  Zweck: Speicherung aller Bücher
  Beziehungen: Jedes Buch ist einem Autor, einem Anwender und einer Abholinfo zugeordnet
  Besonderheiten:
	- Alle Attribute sind verpflichtend, daher NOT NULL
    - Für die Fremdschlüssel gilt, dass sowohl Autor als auch Anwender mehrere Bücher zugeordnet werden können, daher kein UNIQUE*/
CREATE TABLE Buch (BuchID INTEGER PRIMARY KEY AUTO_INCREMENT,
Titel VARCHAR(500) NOT NULL,
Genre VARCHAR(50) NOT NULL,
Jahr YEAR NOT NULL,
Verlag VARCHAR(100) NOT NULL,
Zustand ENUM('wie neu', 'leichte Gebrauchsspuren', 'starke Gebrauchsspuren', 'beschädigt') NOT NULL,
Sprache VARCHAR(50) NOT NULL,
Leihdauer INT NOT NULL,
AutorID INTEGER NOT NULL,
AID INTEGER NOT NULL,
AbholID INTEGER NOT NULL,
FOREIGN KEY (AutorID) REFERENCES Autor(AutorID),
FOREIGN KEY (AID) REFERENCES Anwender(AID),
FOREIGN KEY (AbholID) REFERENCES Abholinfo(AbholID)
);

/*Tabelle: Anfrage
  Zweck: Speicherung von Ausleihanfragen für Bücher
  Beziehungen: Jede Anfrage wird von einem Anwender (Sender) für ein bestimmtes Buch gestellt und kann bestätigt oder abgelehnt werden
  Besonderheiten:
	- Pflicht sind die Info zur Abholung im Dorfgemeinschaftshaus, das Füllen der Anfragebestätigung sowie Sender und BuchID*/
CREATE TABLE Anfrage (
    AnfrageID INTEGER PRIMARY KEY AUTO_INCREMENT,
    DGH BOOLEAN NOT NULL,
    Nachricht TEXT,
    /*Initial ist AnfrageBestaetigt = FALSE. Siehe UPDATE Anfrage, wenn der Empfänger der Anfrage diese in der App bestätigt.*/
    AnfrageBestaetigt BOOLEAN NOT NULL DEFAULT FALSE,
    Sender INTEGER NOT NULL,
    BuchID INTEGER NOT NULL,
    FOREIGN KEY (Sender) REFERENCES Anwender(AID),
    FOREIGN KEY (BuchID) REFERENCES Buch(BuchID)
);

/*Tabelle: Ausleihe
  Zweck: Verwaltung aller Ausleihvorgänge zwischen Anwendern
  Beziehungen: Eine Ausleihe verbindet ein Buch mit einem Anwender (Verleiher) und einem weiteren Anwender (Ausleihender) über einen bestimmten Zeitraum
  Besonderheiten:
  - Alle Attribute der Tabelle sind verpflichtend
  - Bei den Fremdschlüsselbeziehungen kein UNIQUE erforderlich, da alle Fremdschlüssel mehrfach vorkommen können*/
CREATE TABLE Ausleihe (
    AusleihID INTEGER PRIMARY KEY AUTO_INCREMENT,
    Startdatum DATE NOT NULL,
    Enddatum DATE NOT NULL,
    /*AusleiheAktiv startet parallel mit dem Startdatum der Ausleihe automatisch mit Bestätigung der Anfrage, daher DEFAULT TRUE
    und endet in Abhängigkeit der Attribute in der Tabelle Rückgabe. Siehe dazu Update Ausleihe.*/
    AusleiheAktiv BOOLEAN NOT NULL DEFAULT TRUE,
    BuchID INTEGER NOT NULL,
    Verleiher INTEGER NOT NULL,
    Ausleihender INTEGER NOT NULL,
    FOREIGN KEY (BuchID) REFERENCES Buch(BuchID),
    FOREIGN KEY (Verleiher) REFERENCES Anwender(AID),
    FOREIGN KEY (Ausleihender) REFERENCES Anwender(AID)
);

/*Tabelle: Rueckgabe
  Zweck: Dokumentation der Rückgabe eines ausgeliehenen Buches. Sowohl Ausleiher als auch Verleiher bestätigen die Rückgabe.
  Beziehungen: Jede Rückgabe bezieht sich auf eine Ausleihe.
  Besonderheiten:
  - Alle Attribute sind Pflicht mit Ausnahme TimestampVerl für den Check des Verleihers. Dieser wird erst mit CheckVerl = TRUE gesetzt.
  - Jede AusleihID kann nur einmal vorkommen, daher UNIQUE*/
CREATE TABLE Rueckgabe (
    RueckgabeID INTEGER PRIMARY KEY AUTO_INCREMENT,
    -- Die Rückgabe wird angelegt, wenn der Ausleiher die Rückgabe bestätigt. Daher initial ChcekAusl = TRUE.
    CheckAusl BOOLEAN NOT NULL DEFAULT TRUE,
    TimestampAusl DATE NOT NULL, 
    -- Die Rückgabe wird angelegt, wenn der Ausleiher die Rückgabe bestätigt. Daher initial ChcekVerl = FALSE.
    -- Sobald der Verleiher die Rückgabe bestätigt, siehe UPDATE Rueckgabe.
    CheckVerl BOOLEAN NOT NULL DEFAULT FALSE,
    TimestampVerl DATE,
    AusleihID INTEGER UNIQUE NOT NULL,
    FOREIGN KEY (AusleihID) REFERENCES Ausleihe(AusleihID)
);

/*Tabelle: BuchBew
  Zweck: Speicherung von Bewertungen für Bücher nach einer Ausleihe. 
  Beziehungen: Jeder Anwender kann einem Buch eine Sternebewertung geben. Ein Anwender kann mehrere Bücher bewerten. 
  Ein Buch kann mehrere Bewertungen erhalten.
  Besonderheiten:
  - Alle Attribute sind Pflicht mit Ausnahme des Kommentars
  - Alle Fremdschlüssel dürfen mehrfach vorkommen, daher kein UNIQUE*/
CREATE TABLE BuchBew (
    BuchBewID INTEGER PRIMARY KEY AUTO_INCREMENT,
    Sterne CHAR(1) NOT NULL CHECK (Sterne BETWEEN 1 AND 5),
    Kommentar TEXT,
    Timestamp TIMESTAMP NOT NULL,
    AID INTEGER NOT NULL,
    BuchID INTEGER NOT NULL,
    FOREIGN KEY (AID) REFERENCES Anwender(AID),
    FOREIGN KEY (BuchID) REFERENCES Buch(BuchID)
);

/*Tabelle: AnwBew
  Zweck: Speicherung von Anwenderbewertungen nach abgeschlossenen Ausleihen.
  Beziehungen: Ein Anwender kann einen anderen Anwender nach einer Ausleihe bewerten. Zu einer Ausleihe kann es mehrere Bewertungen geben.
  Anwender können mehrere Bewertungen erhalten und schreiben.
  Besonderheiten:
  - Alle Attribute der Tabelle sind Pflicht mit Ausnahme des Kommentars
  - Alle Fremdschlüssel dürfen mehrfach in der Tabelle vorkommen, daher kein UNIQUE*/
CREATE TABLE AnwBew (
    AnwBewID INTEGER PRIMARY KEY AUTO_INCREMENT,
    Sterne CHAR(1) NOT NULL CHECK (Sterne BETWEEN 1 AND 5),
    Kommentar TEXT,
    Timestamp TIMESTAMP NOT NULL,
    AusleihID INTEGER NOT NULL,
    ErstellerID INTEGER NOT NULL,
    EmpfaengerID INTEGER NOT NULL,
    FOREIGN KEY (AusleihID) REFERENCES Ausleihe(AusleihID),
    FOREIGN KEY (ErstellerID) REFERENCES Anwender(AID),
    FOREIGN KEY (EmpfaengerID) REFERENCES Anwender(AID)
);


