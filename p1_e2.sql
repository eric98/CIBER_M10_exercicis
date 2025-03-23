-- a) Crea la vista 'vehicles_alemanya' que mostri els vehicles de marca 'Mercedes'.
CREATE VIEW vehicles_alemanya AS
	SELECT * FROM taller.vehicles WHERE marca = 'Mercedes';
	
-- Extra: Consultem la vista
SELECT * FROM vehicles_alemanya;

-- Extra: Creem l'usuari sofia i li atorguem el permís de SELECT a vehicles_alemanya. Sofia hauria de poder veure les dades de la vista però no de la taula vehicles.
-- (amb usuari sofia: )
SELECT * FROM taller.vehicles_alemanya;
SELECT * FROM taller.vehicles;

-- b) Modifica la vista 'vehicles_alemanya' per a que també mostri els vehicles de la marca 'BMW'.
ALTER VIEW vehicles_alemanya AS
	SELECT * FROM taller.vehicles 
	WHERE marca IN ('Mercedes', 'BMW');
	
ALTER VIEW vehicles_alemanya AS
	SELECT * FROM taller.vehicles 
	WHERE marca = 'Mercedes'
		OR marca = 'BMW';
		
-- Extra: Comprovem l'actualització de la vista a temps real amb l'usuari sofia.
SELECT * FROM taller.vehicles_alemanya;

-- c) Crea la vista 'mecanic_vehicles_reparats' que mostri el nom dels mecànics i les matrícules dels vehicles reparats per cada mecànic.
CREATE VIEW mecanic_vehicles_reparats
	AS SELECT mecanics.nom AS 'Mecànic', vehicles.matricula AS 'Vehicle reparat' FROM mecanics
	JOIN vehicles ON mecanics.dni = vehicles.reparat_per;
	
-- d) Consulta la definició de les vistes creades al SGBD a partir de la taula views de la base de dades information_schema.
SELECT * FROM information_schema.views;
SELECT table_name,view_definition FROM information_schema.views WHERE table_schema='taller'\G
