CREATE TABLE historial_preu_productes (
	id INT AUTO_INCREMENT,
	id_producte INT,
	preu_antic DECIMAL(10, 2),
	preu_actualitzat DECIMAL(10, 2),
	data_hora DATETIME,
	PRIMARY KEY (id),
	FOREIGN KEY (id_producte) REFERENCES productes(id)
);

-- // PROCEDIMENT // actualitzar_preu_productes(escalar DECIMAL(10,2), client VARCHAR(20))
DELIMITER //
CREATE PROCEDURE actualitzar_preu_productes(
	IN escalar DECIMAL(10,2),
	IN client VARCHAR(20)
)
BEGIN
	-- 1. Declaració de variables
	DECLARE done INT DEFAULT 0;
	DECLARE var_nom_producte VARCHAR(20);
	DECLARE var_preu_producte DECIMAL(10, 2);
	DECLARE var_id_producte INT;
	DECLARE var_nou_preu DECIMAL(10, 2);

	-- 2. Declaració del cursor
	DECLARE cur CURSOR FOR 
		SELECT productes.nom, productes.preu, productes.id FROM productes 
		JOIN cistella ON productes.id=cistella.producte_id
		WHERE client='Anna';
	-- 3. Gestor per detectar el final del cursor
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	-- 4. Obrir el cursor
	OPEN cur;
	
	-- 5. Bucle per processar els registres
	historial_loop: LOOP
		-- Llegim els 2 valors del següent registre 
		FETCH cur INTO var_nom_producte,var_preu_producte,var_id_producte;
		
		IF done = 1 THEN
			LEAVE historial_loop;
		END IF;
		
		-- Calculem el nou preu
		SET var_nou_preu = var_preu_producte * escalar;
		-- Actualitzem el preu a la taula productes
		UPDATE productes SET preu=var_nou_preu WHERE var_id_producte=productes.id;
		
		-- ---- (INSERT apartat c) )
		-- Dins del bucle, després de l'UPDATE:
		INSERT INTO historial_preu_productes (id_producte,preu_antic,preu_actualitzat,data_hora)
			VALUES (var_id_producte,var_preu_producte,var_nou_preu,NOW());

	END LOOP;
	-- 6. Tancar el cursor
	CLOSE cur;
END //
DELIMITER ;
