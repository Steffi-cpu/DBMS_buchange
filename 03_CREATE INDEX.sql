-- Autor: Stefanie Ellersiek
-- Datum: 28.01.2026
-- Version: 1.0

/*Index: Indexe für Fremdschlüssel werden erstellt, um Performance-Vorteile zu generieren
Namenskonvention: idx_<tabelle>_<spalte>*/

-- Auswahl der zu verwendenden Datenbank
USE buchange;

-- Tabelle Adresse
CREATE INDEX idx_adresse_aid ON Adresse(AID);

-- Tabelle Abholinfo
CREATE INDEX idx_abholinfo_adressid ON Abholinfo(AdressID);

-- Tabelle Buch
CREATE INDEX idx_buch_autorid ON Buch(AutorID);
CREATE INDEX idx_buch_aid ON Buch(AID);
CREATE INDEX idx_buch_abholid ON Buch(AbholID);

-- Tabelle Anfrage
CREATE INDEX idx_anfrage_sender ON Anfrage(Sender);
CREATE INDEX idx_anfrage_buchid ON Anfrage(BuchID);

-- Tabelle Ausleihe
CREATE INDEX idx_ausleihe_buchid ON Ausleihe(BuchID);
CREATE INDEX idx_ausleihe_verleiher ON Ausleihe(Verleiher);
CREATE INDEX idx_ausleihe_ausleihender ON Ausleihe(Ausleihender);

-- Tabelle Rueckgabe
CREATE INDEX idx_rueckgabe_ausleihid ON Rueckgabe(AusleihID);

-- Tabelle BuchBew
CREATE INDEX idx_buchbew_aid ON BuchBew(AID);
CREATE INDEX idx_buchbew_buchid ON BuchBew(BuchID);

-- Tabelle AnwBew
CREATE INDEX idx_anwbew_ausleihid ON AnwBew(AusleihID);
CREATE INDEX idx_anwbew_erstellerid ON AnwBew(ErstellerID);
CREATE INDEX idx_anwbew_empfaengerid ON AnwBew(EmpfaengerID);
