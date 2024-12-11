-- SQL Tilit luontilauseet
-- Jade Pitkänen

CREATE TABLE tilit (
tilinumero INT NOT NULL,
omistaja VARCHAR(50),
summa INT,
PRIMARY KEY (tilinumero)
);

INSERT INTO tilit VALUES (1, 'Pekka Puu', 500);
INSERT INTO tilit VALUES (2, 'Kalle Kivi', 200);
INSERT INTO tilit VALUES (3, 'Minna Maa', 700);