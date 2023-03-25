CREATE TABLE obec(

    o_cislo INTEGER PRIMARY KEY NOT NULL,

    nazev VARCHAR(20) NOT NULL

);

CREATE TABLE letiste(
    l_cislo INTEGER PRIMARY KEY NOT NULL,

    o_cislo INTEGER,
    FOREIGN KEY (o_cislo) REFERENCES obec(o_cislo),

    nazev VARCHAR(20) NOT NULL,
    kod CHAR(3) NOT NULL,
    typ_letiste VARCHAR(20)

);

CREATE TABLE letovy_itinerar(

    lt_cislo INTEGER PRIMARY KEY NOT NULL,

    letiste_odletu INTEGER,
    letiste_priletu INTEGER,
    FOREIGN KEY (letiste_odletu) REFERENCES letiste(l_cislo),
    FOREIGN KEY (letiste_priletu) REFERENCES letiste(l_cislo),

    datum_a_cas_priletu TIMESTAMP,
    datum_a_cas_odletu TIMESTAMP,
    posledni_zmena TIMESTAMP,
    stav VARCHAR(20)

);

CREATE TABLE Osoba (

    Osoba_Cislo INTEGER PRIMARY KEY NOT NULL,

    Jmeno VARCHAR(255) NOT NULL,
    Prijmeni VARCHAR(255) NOT NULL,
    Statni_prislusnost VARCHAR(255) NOT NULL,
    Datum_narozeni DATE NOT NULL,
    Cestovni_pas VARCHAR(20) NOT NULL,
    --Y or N
    Vyskyt_v_cerne_listine CHAR(1) NOT NULL

);

CREATE TABLE Registrovana_osoba (

    Osoba_Cislo INTEGER NOT NULL PRIMARY KEY,

    FOREIGN KEY (Osoba_Cislo) REFERENCES Osoba(Osoba_Cislo),

    Telefon VARCHAR(12) NOT NULL,
    Email VARCHAR(320) NOT NULL,
    Heslo VARCHAR(255) NOT NULL,
    Token VARCHAR(20) NOT NULL,
    Metoda_platby VARCHAR(20) NOT NULL

);

CREATE TABLE Rezervace (

    Rezervace_Cislo INTEGER NOT NULL PRIMARY KEY,

    Osoba_Cislo INTEGER NOT NULL,
    FOREIGN KEY (Osoba_Cislo) REFERENCES Osoba (Osoba_Cislo),

    Stav VARCHAR(25) NOT NULL

);

CREATE TABLE Letenka (

    Letenka_Cislo INTEGER NOT NULL PRIMARY KEY,

    Rezervace_Cislo INTEGER NOT NULL,
    FOREIGN KEY (Rezervace_Cislo) REFERENCES Rezervace (Rezervace_Cislo),

    Cena INTEGER NOT NULL,
    Stav VARCHAR(15) NOT NULL,
    Covid_doklad VARCHAR(255)

);

CREATE TABLE Spolecnost (

    DICH INTEGER NOT NULL PRIMARY KEY,

    Nazev varchar(255) NOT NULL,
    logo VARCHAR(255)

);

CREATE TABLE Letadlo (

    Seriove_cislo INTEGER NOT NULL PRIMARY KEY,

    DICH INTEGER NOT NULL,
    FOREIGN KEY (DICH) REFERENCES Spolecnost (DICH),

    Typ_letadla varchar(30)


);

CREATE TABLE Let (

    Let_cislo INTEGER NOT NULL PRIMARY KEY,

    Seriove_cislo INTEGER NOT NULL,
    lt_cislo INTEGER NOT NULL,
    DICH INTEGER NOT NULL,
    FOREIGN KEY (Seriove_cislo) REFERENCES Letadlo (Seriove_cislo),
    FOREIGN KEY (lt_cislo) REFERENCES letovy_itinerar (lt_cislo),
    FOREIGN KEY (DICH) REFERENCES Spolecnost (DICH)

);

CREATE TABLE Palubni_Listek (

    Palubni_Listek_Cislo INTEGER NOT NULL PRIMARY KEY,

    Letenka_Cislo INTEGER NOT NULL,
    Let_cislo INTEGER NOT NULL,
    FOREIGN KEY (Letenka_Cislo) REFERENCES Letenka (Letenka_Cislo),
    FOREIGN KEY (Let_cislo) REFERENCES Let (Let_cislo),

    Check_in CHAR(1) NOT NULL,
    Gate INTEGER NOT NULL

);

CREATE TABLE Sluzba (

    Sluzba_cislo INTEGER NOT NULL PRIMARY KEY,

    Nazev varchar(255) NOT NULL,
    Cena INTEGER NOT NULL,
    Dostupnost_sluzby CHAR(1) NOT NULL

);

CREATE TABLE Trida (

    ID_tridy INTEGER NOT NULL PRIMARY KEY,

    Nazev varchar(7) NOT NULL,
    Pocet_mist INTEGER NOT NULL

);

CREATE TABLE Sedadlo (

    Sedadlo_cislo INTEGER NOT NULL PRIMARY KEY ,

    ID_tridy INTEGER NOT NULL,
    FOREIGN KEY (ID_tridy) REFERENCES Trida (ID_tridy),

    Radek INTEGER NOT NULL,
    Misto CHAR(1) NOT NULL

);


--N to N Tables

CREATE TABLE Pridana_Sluzba (

    Sluzba_cislo INTEGER NOT NULL,
    Letenka_Cislo INTEGER NOT NULL,

    FOREIGN KEY (Sluzba_cislo) REFERENCES Sluzba(Sluzba_cislo),
    FOREIGN KEY (Letenka_Cislo) REFERENCES Letenka(Letenka_Cislo),

    Uspesnost varchar(3) NOT NULL,
    Zahrnuto_v_cene varchar(3) NOT NULL,
    Pocet INTEGER NOT NULL

);

CREATE TABLE Osoba_Letenka (

    Osoba_Cislo INTEGER NOT NULL,
    Letenka_Cislo INTEGER NOT NULL,

    FOREIGN KEY (Osoba_Cislo) REFERENCES Osoba(Osoba_Cislo),
    FOREIGN KEY (Letenka_Cislo) REFERENCES Letenka (Letenka_Cislo)

);

CREATE TABLE Sedadlo_Palubni_listek (

    Sedadlo_Cislo INTEGER NOT NULL,
    Palubni_Listek_Cislo INTEGER NOT NULL,

    FOREIGN KEY (Sedadlo_Cislo) REFERENCES Sedadlo(Sedadlo_cislo),
    FOREIGN KEY (Palubni_Listek_Cislo) REFERENCES Palubni_Listek (Palubni_Listek_Cislo)

);

CREATE TABLE Trida_Letadlo (

    ID_tridy INTEGER NOT NULL,
    Seriove_cislo INTEGER NOT NULL,
    FOREIGN KEY (ID_tridy) REFERENCES Trida(ID_tridy),
    FOREIGN KEY (Seriove_cislo) REFERENCES Letadlo (Seriove_cislo)

);

CREATE TABLE Spolecnost_Letiste(

    DICH INTEGER NOT NULL,
    l_cislo INTEGER NOT NULL,
    FOREIGN KEY (DICH) REFERENCES Spolecnost (DICH) ,
    FOREIGN KEY (l_cislo) REFERENCES Letiste (l_cislo)

);


INSERT INTO Osoba
VALUES ('1', 'Beren', 'Erhamion', 'Dortonion', TO_DATE('2000-06-10', 'YYYY-MM-DD'), 'Dorton', 'N');

INSERT INTO Registrovana_osoba
VALUES ('1', '+3246578912', 'berenlutien@gmail.com', 'Silmaril', 'Something', 'VISA');

INSERT INTO Rezervace
VALUES ('1', '1', 'Reserved');

INSERT INTO Letenka
VALUES ('1', '1', '5000', 'Printed', 'Attached');

INSERT INTO obec
VALUES ('15', 'Doriat');

INSERT INTO letiste
VALUES ('3', '15', 'Melian', 'TBD', 'International');
INSERT INTO letiste
VALUES ('4', '15', 'Grot', 'TBD', 'International');

INSERT INTO letovy_itinerar
VALUES ('12', '3', '4', TO_TIMESTAMP('2022-11-23 8:45:16', 'YYYY-MM-DD HH:MI:SS'), TO_TIMESTAMP('2022-11-23 3:34:23', 'YYYY-MM-DD HH:MI:SS'), TO_TIMESTAMP('2022-11-23 1:48:35', 'YYYY-MM-DD HH:MI:SS'), 'Registration');

INSERT INTO Spolecnost
VALUES ('764532891', 'MiddleEarthAirlines', 'Torondor_the_Great');

INSERT INTO Letadlo
VALUES ('264', '764532891', 'Passenger');

INSERT INTO Let
VALUES ('50', '264', '12', '764532891');

INSERT INTO Palubni_Listek
VALUES ('1', '1', '50', 'Y', '25');

INSERT INTO Sluzba
VALUES ('2', 'A song from flight attendant', '500', 'Y');

INSERT INTO Trida
VALUES ('2', 'ECONOM', '58');

INSERT INTO Sedadlo
VALUES ('1', '2', '25', 'F');

INSERT INTO Pridana_Sluzba
VALUES ('2', '1', 'YES', 'YES', '1');

INSERT INTO Osoba_Letenka
VALUES ('1', '1');

INSERT INTO Sedadlo_Palubni_listek
VALUES ('1', '1');

INSERT INTO Trida_Letadlo
VALUES ('2', '264');

INSERT INTO Spolecnost_Letiste
VALUES ('764532891', '3');