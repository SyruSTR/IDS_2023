DROP obec CASCADE CONSTRAINTS;
DROP letiste CASCADE CONSTRAINTS;
DROP letovy_itinerar CASCADE CONSTRAINTS;

CREATE TABLE obec(
    o_cislo INTEGER,
    nazev VARCHAR(20) NOT NULL
);

CREATE TABLE letiste(
    l_cislo INTEGER,
    nazev VARCHAR(20) NOT NULL,
    kod CHAR(3) NOT NULL,
    typ_letiste VARCHAR(10)
    o_cislo INTEGER
);

CREATE TABLE letovy_itinerar(
    lt_cislo INTEGER,
    datum_a_cas_priletu TIMESTAMP,
    datum_a_cas_odletu TIMESTAMP,
    posledni_zmena TIMESTAMP,
    stav VARCHAR(10),
    letiste_odletu INTEGER,
    letiste_priletu INTEGER
);

ALTER TABLE obec ADD CONSTRAINT PK_obec PRIMARY KEY (o_cilso);
ALTER TABLE letiste ADD CONSTRAINT PK_letiste PRIMARY KEY (l_cislo);
ALTER TABLE letovy_itinerar ADD CONSTRAINT PK_letovy_itinerar PRIMARY KEY (lt_cislo);
ALTER TABLE letiste ADD CONSTRAINT FK_letiste_obec FOREIGN KEY (o_cilso) REFERENCES obec;
ALTER TABLE letovy_itinerar ADD CONSTRAINT FK_lt_letiste_odletu FOREIGN KEY (letiste_odletu) REFERENCES letiste;
ALTER TABLE letovy_itinerar ADD CONSTRAINT FK_lt_letiste_priletu FOREIGN KEY (letiste_priletu) REFERENCES letiste;