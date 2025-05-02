-- Exercici 1. Crea la taula historial_preu_productes i, utilitzant la taula productes, defineix un procediment actualitzar_preu_productes(escalar DECIMAL(10,2), client VARCHAR(20)) que actualitzi els preus dels productes de la BD i que insereixi un registre a historial_preu_productes un registre informant la instrucció:

CREATE TABLE historial_preu_productes (
	id INT AUTO_INCREMENT,
	id_producte INT,
	preu_antic DECIMAL(10, 2),
	preu_actualitzat DECIMAL(10, 2),
	data_hora DATETIME,
	PRIMARY KEY (id),
	FOREIGN KEY (id_producte) REFERENCES productes(id)
);

-- a) El cursor consulta els productes de la cistella per un client específic.
DECLARE cur CURSOR FOR 
	SELECT productes.nom, productes.preu, productes.id FROM productes 
	JOIN cistella ON productes.id=cistella.producte_id
	WHERE client='Anna';

-- b) Per cada producte, es calcula el nou preu (nou_preu = preu * escalar) i s’actualitza a la taula productes.
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
	
	------ (INSERT apartat c) )
	-- Dins del bucle, després de l'UPDATE:
	INSERT INTO historial_preu_productes (id_producte,preu_antic,preu_actualitzat,data_hora)
		VALUES (var_id_producte,var_preu_producte,var_nou_preu);
	
END LOOP;

-- c) Per cada producte, s’insereix un registre a historial_preu_productes amb l’id del producte, el preu antic, el preu actualitzat, i la data actual (NOW()).
