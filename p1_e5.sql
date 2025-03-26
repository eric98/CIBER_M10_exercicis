-- Exercici5: Defineix els següents procediments emmagatzemats i escriu la instrucció per a executar-los. Finalment, consulta al catàleg de metadades la informació de tots els procediments creats.

-- a) Crea el procediment mostrar_mecanics() que mostri tots els mecànics de la taula mecanics.
-- => Definició
DELIMITER //

CREATE PROCEDURE mostrar_mecanics() 
BEGIN
	
	SELECT * FROM mecanics;

END //

DELIMITER ;

-- => Execució
CALL mostrar_mecanics();

-- b) Crea el procediment vehicles_per_marca(...) que mostri tots els vehicles d’una marca específica.
-- => Definició
DELIMITER //
CREATE PROCEDURE vehicles_per_marca(
	IN marca_vehicle VARCHAR(20)
	)
BEGIN
	SELECT COUNT(*) AS 'Total de vehicles'
	FROM vehicles WHERE marca=marca_vehicle;
END //

DELIMITER ;

-- => Execució
CALL vehicles_per_marca('Mercedes');

-- c) Crea el procediment comptar_vehicles_reparats(...) que retorni el resultat a través d’un paràmetre.
-- => Definició
DELIMITER //
CREATE PROCEDURE comptar_vehicles_reparats(OUT resultat INT)
BEGIN
	SELECT COUNT(reparat_per) AS 'Total de vehicles reparats' INTO resultat
	FROM vehicles;

END //

DELIMITER ;

-- => Execució
CALL comptar_vehicles_reparats(@num_vehicles_reparats);
SELECT @num_vehicles_reparats;

-- d) Crea el procediment afegir_mecanic_si_no_existeix(...) que rebi totes les dades per a afegir un mecànic i que l’insereixi a la BD només si no existeix.
-- => Definició
DELIMITER //
CREATE PROCEDURE afegir_mecanic_si_no_existeix(
	IN _dni CHAR(9),
	IN _nom VARCHAR(9),
	IN _edat TINYINT UNSIGNED,
	IN _poblacio VARCHAR(20)
	)
BEGIN
	-- 1. Declarar la variable que ens diu si el mecànic existeix
	DECLARE existeix INT;
	
	-- 2. Comprovem si existeix un mecànic amb dni = '_dni'
	SELECT COUNT(*) INTO existeix
	FROM mecanics WHERE dni = _dni;
	-- => Si existeix, COUNT(*) retorna 1
	-- => Si no existeix, COUNT(*) retorna 0

	-- 3. Inserim el mecànic si no existeix a la BD
	IF existeix = 0 THEN
		INSERT INTO mecanics VALUES
			(_dni, _nom, _edat, _poblacio);
			
		-- 4.1 Mostrar missatge de si s'ha inserit o no
		SELECT '[INFO] Mecànic inserit correctament!' AS 'Message';
	ELSE
		-- 4.2 Mostrar missatge de si s'ha inserit o no
		SELECT '[INFO] Aquest mecànic ja existeix' AS 'Message';
	END IF

END //

DELIMITER ;

-- => Execució
CALL afegir_mecanic_si_no_existeix('444555666', 'Adri', 23, 'Hospitalet');

-- e) Consulta a information_schema.routines informació sobre els procediments creats.
SELECT routine_name, routine_definition FROM information_schema.routines 
WHERE routine_type='PROCEDURE' AND routine_schema='taller'\G
