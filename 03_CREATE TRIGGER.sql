-- Autor: Stefanie Ellersiek
-- Datum: 28.01.2026
-- Version: 2.0

/*Trigger: CheckAusleihe
  Zweck: Bevor eine Anwender-Bewertung erfasst wird, muss sichergestellt sein, dass der Status der Ausleihe abgeschlossen ist (AusleiheAktiv = FALSE)
  Zeitpunkt: BEFORE INSERT
  Tabelle: AnwBew
*/
DELIMITER //
CREATE TRIGGER CheckAusleihe
BEFORE INSERT ON AnwBew
FOR EACH ROW
BEGIN
  DECLARE v_auslaktiv BOOLEAN;
  -- Ermitteln des Status andhand des Attributes AusleiheAktiv anhand der übergebenen AusleihID in der Tabelle Ausleihe
  SELECT AusleiheAktiv
    INTO v_auslaktiv
  FROM Ausleihe
  WHERE AusleihID = NEW.AusleihID;
  -- Falls die Ausleihe noch aktiv ist, Fehler beim Einfügen und Ausgabe einer Nachricht
  IF v_auslaktiv = TRUE THEN
    SIGNAL SQLSTATE 'P0001'
      SET MESSAGE_TEXT = 'Anwender-Bewertungen sind erst nach Abschluss der Ausleihe möglich';
  END IF;
END //
DELIMITER ;


/* Trigger: CheckSperre
   Zweck: Verhindert das Erstellen einer Anfrage durch einen Anwender, der aktuell gesperrt ist. Gesperrte Anwender dürfen kein Buch ausleihen.
   Zeitpunkt: BEFORE INSERT
   Tabelle: Anfrage
*/
DELIMITER //
CREATE TRIGGER CheckSperre
BEFORE INSERT ON Anfrage
FOR EACH ROW
BEGIN
    DECLARE v_sperre BOOLEAN;
    -- Ermitteln des Attributes Sperre anhand der AID des Senders der Anfrage in der View ViewSperre
    SELECT Sperre
      INTO v_sperre
    FROM ViewSperre
    WHERE AID = NEW.Sender;
    -- Falls der Anwender gesperrt ist, Fehler beim Einfügen und Ausgabe einer Nachricht
    IF v_sperre = TRUE THEN
        SIGNAL SQLSTATE 'P0002' 
           SET MESSAGE_TEXT = 'Sie sind gesperrt. Bitte wenden Sie sich an den Administrator.';
    END IF;
END//
DELIMITER ;
