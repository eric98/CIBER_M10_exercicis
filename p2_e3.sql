-- Exercici 3. Escriu el codi per generar els següents disparadors. Comprova que 
-- es produeixen els canvis esperats després de definir els disparadors.

-- a) Crea el disparador check_esborrar_mecanic que comprova el mecànic que 
-- s’intenta esborrar i llança un error si aquest té vehicles associats. *Mostra 
-- aquest error fent ús de SIGNAL SQLSTATE '45000'.
DELIMITER //
CREATE TRIGGER check_esborrar_mecanic
BEFORE DELETE ON mecanics
FOR EACH ROW
BEGIN
	DECLARE vehicles_associats INT;

	SELECT COUNT(*) INTO vehicles_associats
		FROM vehicles WHERE reparat_per=OLD.dni;

	IF vehicles_associats > 0 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'No es pot esborrar aquest mecànic perquè té vehicles associats';
	END IF;

END //
DELIMITER ;

-- Comprovació
-- DELETE FROM mecanics WHERE nom='Maria'; -> Error
-- DELETE FROM mecanics WHERE nom='Adri'; -> Query OK

-- b) Crea la següent taula i crea el disparador registrar_esborrar_mecanic que 
-- insereix un registre cada vegada que s’esborra un mecànic.
CREATE TABLE log_mecanics_esborrats (
 log_id INT AUTO_INCREMENT PRIMARY KEY,
 dni CHAR(9),
 nom VARCHAR(9),
 edat TINYINT UNSIGNED,
 poblacio VARCHAR(20),
 data_esborrat DATETIME
);


DELIMITER //
CREATE TRIGGER registre_esborrar_mecanic
AFTER DELETE ON mecanics
FOR EACH ROW
BEGIN
	INSERT INTO log_mecanics_esborrats (dni,nom,edat,poblacio,data_esborrat)
		VALUES (OLD.dni, OLD.nom, OLD.edat, OLD.poblacio, NOW());
END //
DELIMITER ;

-- Comprovació
-- DELETE FROM mecanics WHERE nom='Adri';
-- SELECT * FROM log_mecanics_esborrats WHERE nom='Adri';
