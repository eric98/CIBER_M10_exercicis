-- Exercici1. Amb l’ajuda de la documentació, recrea la base de dades 
-- biblioteca de MySQL a PostgreSQL.

-- a) Crea la taula desenvolupadors a PostgreSQL. Veuràs que poden haver-hi 
-- algunes diferències respecte a MySQL.

CREATE TABLE desenvolupadors (
	id INT CHECK (id >= 0),
	nom VARCHAR(20),
	PRIMARY KEY (id)
);

-- b) Crea la taula videojocs a PostgreSQL. És possible que hagis de recòrrer a 
-- un CHECK CONSTRAINT per a representar l’ENUM.

CREATE TABLE videojocs (
	id INT CHECK (id >= 0),
	nom VARCHAR(45),
	data_sortida DATE,
	genere VARCHAR(20) CHECK (genere IN ('SURVIVAL', 'RPG','METROIDVANIA','ACTION ADVENTURE')),
	preu NUMERIC(6,2),
	img_portada BYTEA,
	id_desenvolupador INT,
	PRIMARY KEY (id),
	FOREIGN KEY (id_desenvolupador) REFERENCES desenvolupadors (id)
);

