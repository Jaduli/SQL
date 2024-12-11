-- Verkkokaupan luontilauseet
-- Jade Pitkänen

create table Asiakas(
asiakas_id INT PRIMARY KEY,
nimi VARCHAR(128) NOT NULL,
osoite VARCHAR(128) NOT NULL
);
create table Tuote(
tuote_id INT PRIMARY KEY,
nimi VARCHAR(128) NOT NULL,
valmistaja VARCHAR(128) NOT NULL,
hinta NUMERIC(10,2) NOT NULL
);
create table Tilaus(
tilaus_id INT PRIMARY KEY,
asiakas_id INT NOT NULL,
tila INT NOT NULL DEFAULT 0,
FOREIGN KEY (asiakas_id) REFERENCES Asiakas(asiakas_id)
);
create table Tilaustuote(
tilaus_id INT NOT NULL,
tuote_id INT NOT NULL,
lkm INT NOT NULL,
PRIMARY KEY(tilaus_id, tuote_id),
FOREIGN KEY (tilaus_id) REFERENCES Tilaus(tilaus_id),
FOREIGN KEY (tuote_id) REFERENCES Tuote(tuote_id)
);

-- Esimerkkisyötteitä

INSERT INTO Asiakas VALUES (1, 'Matti Mainio', 'jokin 1');
INSERT INTO Asiakas VALUES (2, 'Tellu', 'jokin 2');
INSERT INTO Asiakas VALUES (3, 'Jaska Jokunen', 'jokin 3');
INSERT INTO Asiakas VALUES (4, 'Essi Esimerkki', 'jokin 4');

INSERT INTO Tuote VALUES (1, 'rihveli', 'Roina ja kilke', 20);
INSERT INTO Tuote VALUES (2, 'tunkki', 'Kummeli ry', 39.95);
INSERT INTO Tuote VALUES (3, 'iPhone 7 laturi', 'Apple', 39.95);
INSERT INTO Tuote VALUES (4, 'iPhone 7', 'Apple', 1000);

INSERT INTO Tilaus VALUES (1, 1, 0);
INSERT INTO Tilaus VALUES (2, 2, 0);
INSERT INTO Tilaus VALUES (3, 3, 0);
INSERT INTO Tilaus VALUES (4, 3, 1);

INSERT INTO Tilaustuote VALUES (1, 1, 1000);
INSERT INTO Tilaustuote VALUES (1, 4, 1);
INSERT INTO Tilaustuote VALUES (2, 2, 2);
INSERT INTO Tilaustuote VALUES (3, 1, 4);
INSERT INTO Tilaustuote VALUES (3, 2, 6);
INSERT INTO Tilaustuote VALUES (4, 2, 500);


-- Satunnaisia SELECT lauseita

SELECT DISTINCT asiakas_id, nimi, osoite
FROM Asiakas 
ORDER BY nimi, asiakas_id;

SELECT DISTINCT valmistaja
FROM tuote 
ORDER BY valmistaja;

SELECT t.tilaus_id, a.asiakas_id, a.nimi
FROM tilaus t
JOIN asiakas a ON a.asiakas_id = t.asiakas_id
ORDER BY tilaus_id;

SELECT t.tilaus_id
FROM tilaus t
JOIN asiakas a ON a.asiakas_id = t.asiakas_id
WHERE a.nimi = 'Jaska Jokunen'
ORDER BY tilaus_id;

SELECT tu.tuote_id, tu.nimi
FROM tilaus t
JOIN asiakas a ON a.asiakas_id = t.asiakas_id
JOIN tilaustuote tt ON t.tilaus_id = tt.tilaus_id
JOIN tuote tu ON tu.tuote_id = tt.tuote_id
WHERE a.nimi = 'Jaska Jokunen'
AND t.tila = 1
ORDER BY t.tilaus_id;

SELECT tu.tuote_id, tu.nimi, t.tilaus_id
FROM tilaus t
FULL OUTER JOIN tilaustuote tt ON t.tilaus_id = tt.tilaus_id
FULL OUTER JOIN tuote tu ON tu.tuote_id = tt.tuote_id
WHERE tu.valmistaja = 'Apple'
ORDER BY tu.tuote_id, t.tilaus_id;

SELECT DISTINCT a.asiakas_id, a.nimi
FROM tilaus t
INNER JOIN asiakas a ON a.asiakas_id = t.asiakas_id
ORDER BY a.asiakas_id, a.nimi;

SELECT tu.tuote_id, tu.nimi, tu.valmistaja, tu.hinta
FROM tuote tu
EXCEPT
SELECT tt.tuote_id, tu2.nimi, tu2.valmistaja, tu2.hinta
FROM tilaustuote tt
JOIN tuote tu2 ON tt.tuote_id = tu2.tuote_id
ORDER BY tu.tuote_id;

SELECT a.asiakas_id, a.nimi, COUNT(t.tilaus_id) AS tilaus_lkm
FROM tilaus t
FULL OUTER JOIN asiakas a ON a.asiakas_id = t.asiakas_id
GROUP BY a.asiakas_id
ORDER BY a.asiakas_id;

SELECT a.asiakas_id, COUNT(t.tilaus_id) AS tilaus_lkm
FROM tilaus t
FULL OUTER JOIN asiakas a ON a.asiakas_id = t.asiakas_id
GROUP BY a.asiakas_id
HAVING COUNT(t.tilaus_id) > 1
ORDER BY a.asiakas_id;

SELECT a.asiakas_id, a.nimi
FROM tilaus t
FULL OUTER JOIN asiakas a ON a.asiakas_id = t.asiakas_id
JOIN tilaustuote tt ON t.tilaus_id = tt.tilaus_id
JOIN tuote tu ON tu.tuote_id = tt.tuote_id
WHERE tu.nimi = 'rihveli'
INTERSECT
SELECT a.asiakas_id, a.nimi
FROM tilaus t
FULL OUTER JOIN asiakas a ON a.asiakas_id = t.asiakas_id
JOIN tilaustuote tt ON t.tilaus_id = tt.tilaus_id
JOIN tuote tu ON tu.tuote_id = tt.tuote_id
WHERE tu.nimi = 'tunkki'
ORDER BY a.asiakas_id;