BEGIN
  FOR cur_tab IN (SELECT table_name FROM user_tables) LOOP
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE ' || cur_tab.table_name || ' CASCADE CONSTRAINTS';
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE != -942 THEN
                RAISE;
            END IF;
    END;
  END LOOP;
END;

-- DROP TABLE LET cascade constraints;
-- DROP TABLE LETADLO cascade constraints;
-- DROP TABLE letenka cascade constraints;
-- DROP TABLE letiste cascade constraints;
-- DROP TABLE letovy_itinerar;
-- DROP TABLE obec;
-- DROP TABLE osoba cascade constraints ;
-- DROP TABLE OSOBA_LETENKA;
-- DROP TABLE PALUBNI_LISTEK cascade constraints;
-- DROP TABLE PRIDANA_SLUZBA;
-- DROP TABLE registrovana_osoba;
-- DROP TABLE rezervace;
-- DROP TABLE SEDADLO cascade constraints;
-- DROP TABLE SEDADLO_PALUBNI_LISTEK;
-- DROP TABLE SLUZBA;
-- DROP TABLE SPOLECNOST cascade constraints;
-- DROP TABLE SPOLECNOST_LETISTE;
-- DROP TABLE TRIDA cascade constraints;
-- DROP TABLE TRIDA_LETADLO;

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

 /*
 Pro reprezentaci generalizace jsme si vybrali 1. moznost.
 Vytvorili jsme tabulku nadtypu a tabulku podtypu.
 Podtyp obsahuje primarni klic nadtypu.
*/

CREATE TABLE Registrovana_osoba (

    Osoba_Cislo INTEGER NOT NULL PRIMARY KEY,

    FOREIGN KEY (Osoba_Cislo) REFERENCES Osoba(Osoba_Cislo),

    Telefon VARCHAR(12) NOT NULL,
    Email VARCHAR(320) NOT NULL, --nejdelsi mozny email
    Heslo VARCHAR(255) NOT NULL,
    Token VARCHAR(255) NOT NULL,
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

    DICH CHAR (10) NOT NULL PRIMARY KEY,
    CHECK (upper(substr(DICH,1,2)) = 'CZ'),

    Nazev varchar(255) NOT NULL,
    logo VARCHAR(255)

);

CREATE TABLE Letadlo (

    Seriove_cislo INTEGER NOT NULL PRIMARY KEY,

    DICH CHAR (10) NOT NULL,
    FOREIGN KEY (DICH) REFERENCES Spolecnost (DICH),

    Typ_letadla varchar(30)


);

CREATE TABLE Let (

    Let_cislo INTEGER NOT NULL PRIMARY KEY,

    Seriove_cislo INTEGER NOT NULL,
    lt_cislo INTEGER NOT NULL,
    DICH CHAR(10) NOT NULL,
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
    CONSTRAINT PK_Pridana_Sluzba PRIMARY KEY (Sluzba_cislo, Letenka_Cislo),

    Uspesnost varchar(3) NOT NULL,
    Zahrnuto_v_cene varchar(3) NOT NULL,
    Pocet INTEGER NOT NULL

);

CREATE TABLE Osoba_Letenka (

    Osoba_Cislo INTEGER NOT NULL,
    Letenka_Cislo INTEGER NOT NULL,

    FOREIGN KEY (Osoba_Cislo) REFERENCES Osoba(Osoba_Cislo),
    FOREIGN KEY (Letenka_Cislo) REFERENCES Letenka (Letenka_Cislo),
    CONSTRAINT PK_Osoba_Letenka PRIMARY KEY (Osoba_Cislo, Letenka_Cislo)

);

CREATE TABLE Sedadlo_Palubni_listek (

    Sedadlo_Cislo INTEGER NOT NULL,
    Palubni_Listek_Cislo INTEGER NOT NULL,

    FOREIGN KEY (Sedadlo_Cislo) REFERENCES Sedadlo(Sedadlo_cislo),
    FOREIGN KEY (Palubni_Listek_Cislo) REFERENCES Palubni_Listek (Palubni_Listek_Cislo),
    CONSTRAINT PK_Sedadlo_Palubni_Listek PRIMARY KEY (Sedadlo_Cislo, Palubni_Listek_Cislo)

);

CREATE TABLE Trida_Letadlo (

    ID_tridy INTEGER NOT NULL,
    Seriove_cislo INTEGER NOT NULL,
    FOREIGN KEY (ID_tridy) REFERENCES Trida(ID_tridy),
    FOREIGN KEY (Seriove_cislo) REFERENCES Letadlo (Seriove_cislo),
    CONSTRAINT PK_Trida_Letadlo PRIMARY KEY (ID_tridy, Seriove_cislo)

);

CREATE TABLE Spolecnost_Letiste(

    DICH CHAR (10) NOT NULL,
    l_cislo INTEGER NOT NULL,
    FOREIGN KEY (DICH) REFERENCES Spolecnost (DICH) ,
    FOREIGN KEY (l_cislo) REFERENCES Letiste (l_cislo),
    CONSTRAINT PK_Spolecnost_Letiste PRIMARY KEY (DICH, l_cislo)

);


INSERT ALL
    INTO Osoba VALUES ('1', 'Beren', 'Erhamion', 'Dortonion', TO_DATE('2000-06-10', 'YYYY-MM-DD'), 'Dorton', 'N')
    INTO Osoba VALUES ('2', 'Earendil', 'Mariner', 'Gondolin', TO_DATE('2010-05-15', 'YYYY-MM-DD'), 'Gon', 'N')
SELECT * FROM dual;

INSERT ALL
        INTO Registrovana_osoba VALUES ('1', '+3246578912', 'berenlutien@gmail.com', 'Silmaril', 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NSIsIm5hbWUiOiJKb2huIEdvbGQiLCJhZG1pbiI6dHJ1ZX0K.LIHjWCBORSWMEibq-tnT8ue_deUqZx1K0XxCOXZRrBI', 'VISA')
        INTO Registrovana_osoba VALUES ('2', '+4946789723', 'earendilsea@gmail.com', 'Vingilote', 'eyJhbGciOiJIUzUxMiIsInR7cCI6IkpXVCJ9.ioJzdWIiOiIxMjM0NSIsIm5hbWUiOiJKb2huIEdgtGQiLCJhZG1pbiI6dHJ1ZX0K.LIHjWCBORSWMEibq-tnT8ue_deUqZx1K0XxCOXZRrBI', 'PayPal')
SELECT * FROM dual;

INSERT ALL
    INTO Rezervace VALUES ('1', '1', 'Reserved')
    INTO Rezervace VALUES ('2', '2', 'Reserved')
SELECT * FROM dual;

INSERT ALL
    INTO Letenka VALUES ('1', '1', '5000', 'Printed', 'Attached')
    INTO LETENKA VALUES ('2', '2', '7635', 'Unprinted', 'Attached')
SELECT  * FROM  dual;

INSERT ALL
    INTO obec VALUES ('15', 'Doriat')
    INTO obec VALUES ('6', 'Beleriand')
SELECT * FROM dual;

INSERT ALL
    INTO letiste VALUES ('3', '15', 'Melian', 'TBD', 'International')
    INTO letiste VALUES ('4', '6', 'Valinor', 'OUI', 'International')
select * from dual;

INSERT ALL
    INTO letovy_itinerar VALUES ('12', '3', '4', TO_TIMESTAMP('2022-11-23 8:45:16', 'YYYY-MM-DD HH:MI:SS'), TO_TIMESTAMP('2022-11-23 3:34:23', 'YYYY-MM-DD HH:MI:SS'), TO_TIMESTAMP('2022-11-23 1:48:35', 'YYYY-MM-DD HH:MI:SS'), 'Registration')
    --INTO letovy_itinerar VALUES ('28', '18', '5', TO_TIMESTAMP('2023-04-15 5:31:12', 'YYYY-MM-DD HH:MI:SS'), TO_TIMESTAMP('2023-04-15 2:25:28', 'YYYY-MM-DD HH:MI:SS'), TO_TIMESTAMP('2022-04-15 1:12:43', 'YYYY-MM-DD HH:MI:SS'), 'Take off')
SELECT * FROM dual;

INSERT ALL
    INTO Spolecnost VALUES ('CZ64532891', 'MiddleEarthAirlines', 'Torondor the Great')
    INTO Spolecnost VALUES ('CZ78465632', 'IluvatarFlights', 'Views of Valinor')
SELECT * FROM dual;

INSERT ALL
    INTO Letadlo VALUES ('264', 'CZ64532891', 'Passenger')
    INTO Letadlo VALUES ('592', 'CZ78465632', 'Personal')
SELECT * FROM dual;

INSERT ALL
    INTO Let VALUES ('50', '264', '12', 'CZ64532891')
    --INTO LET VALUES ('294', '592', '28', 'CZ78465632')
SELECT * FROM dual;

INSERT ALL
    INTO Palubni_Listek VALUES ('1', '1', '50', 'Y', '25')
    --INTO Palubni_Listek VALUES ('2', '2', '294', 'Y', '9')
SELECT * FROM dual;

INSERT ALL
    INTO Sluzba VALUES ('2', 'A song from flight attendant', '500', 'Y')
    INTO Sluzba VALUES ('5', 'Surprise on board', '0', 'Y')
SELECT * FROM dual;

INSERT ALL
    INTO Trida VALUES ('2', 'ECONOM', '57')
    INTO Trida VALUES ('1', 'BUSINES', '12')
SELECT * FROM dual;

INSERT ALL
    INTO Sedadlo VALUES ('1', '2', '25', 'F')
    INTO Sedadlo VALUES ('2', '1', '5', 'A')
SELECT * FROM dual;

INSERT ALL
    INTO Pridana_Sluzba VALUES ('2', '1', 'YES', 'YES', '1')
    INTO Pridana_Sluzba VALUES ('5', '2', 'YES', 'YES', '1')
SELECT * FROM dual;

INSERT ALL
    INTO Osoba_Letenka VALUES ('1', '1')
    INTO Osoba_Letenka VALUES ('2', '2')
SELECT * FROM dual;

INSERT ALL
    INTO Sedadlo_Palubni_listek VALUES ('1', '1')
    --INTO Sedadlo_Palubni_listek VALUES ('2', '2')
SELECT * FROM dual;

INSERT ALL
    INTO Trida_Letadlo VALUES ('2', '264')
    INTO Trida_Letadlo VALUES ('1', '592')
SELECT * FROM dual;

INSERT ALL
    INTO Spolecnost_Letiste VALUES ('CZ64532891', '3')
    INTO Spolecnost_Letiste VALUES ('CZ78465632', '4')
SELECT * FROM dual;

-- 3 cast

-- Vybirame letiste odletu a ukazujeme jeho kód a název obce ve kterém se nachází
select lt.LETISTE_ODLETU, letiste.KOD, obec.NAZEV
FROM LETOVY_ITINERAR lt
INNER JOIN LETISTE letiste ON lt.LETISTE_ODLETU = letiste.L_CISLO
INNER JOIN OBEC obec on letiste.O_CISLO = OBEC.O_CISLO;

-- Vybirame jestli nejake letadlo patri do jiz zminene spolecnosti
SELECT Letadlo.DICH
FROM Letadlo
INNER JOIN Spolecnost
ON Letadlo.DICH = Spolecnost.DICH;

-- Vybirame rezervaci a letenku s cenou mensi nez 6000
SELECT Rezervace.Rezervace_Cislo, Letenka.Letenka_Cislo, Letenka.Cena
FROM REZERVACE INNER JOIN LETENKA
ON Rezervace.Rezervace_Cislo = Letenka.Rezervace_Cislo
WHERE Cena < 6000;

-- Vybirame cenu listku podle jeji vyski
SELECT MAX(Cena)
FROM Letenka
GROUP BY Cena;

-- Vybirame osoby se zadanou statni prislusnosti
SELECT  COUNT (Osoba_Cislo) as pocet_osob
FROM Osoba
WHERE Statni_prislusnost = 'Gondolin'
GROUP BY Osoba_Cislo;

-- Overujeme jestli zadane letadlo provadi specifikovany let
SELECT Let_cislo
FROM Let
WHERE EXISTS (SELECT Seriove_cislo FROM Letadlo WHERE Letadlo.Seriove_cislo = '264');

-- Vybirame veskerou informaci o letenkach, ci cena je vyssi nez prumerna cena
SELECT *
FROM Letenka
WHERE Cena > (SELECT AVG(Cena) FROM Letenka)
