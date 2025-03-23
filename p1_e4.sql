-- Exercici4: Llegeix la documentació per veure com fer un WHILE a MySQL i escriu el codi retornar el factorial de un número enter.
DELIMITER //
CREATE FUNCTION factorial(n INT)
RETURNS INT DETERMINISTIC
BEGIN
	-- #1 Declarem les variables necessàries
	DECLARE resultat INT DEFAULT 1;

	-- #2 Controlem els "Early returns" o "Guard clauses"
	-- Articles interessants sobre aquesta pràcita:
	--  https://artansoft.com/2017/01/guard-clauses-definicion-beneficios/
	--  https://medium.com/swlh/return-early-pattern-3d18a41bba8
	IF n < 0 THEN
		RETURN -1;
	END IF;

	IF n = 0 THEN
		RETURN 1;
	END IF;
	
	-- #3 Calculem el factorial del paràmetre n
	WHILE n > 0 DO
		SET resultat = resultat * n;
		SET n = n -1;
	END WHILE;
	
	RETURN resultat;
	
END //
DELIMITER ;
