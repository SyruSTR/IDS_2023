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

CREATE DATABASE Letenky;



CREATE TABLE Osoba (

    Osoba_Cislo int NOT NULL,
    Jmeno varchar(255) NOT NULL,
    Prijmeni varchar(255) NOT NULL,
    Statni_prislusnost varchar(255) NOT NULL,
    Datum_narozeni DATE NOT NULL,
    Cestovni_pas varchar(255) NOT NULL,
    Vyskyt_v_cerne_listine varchar(3) NOT NULL

);

CREATE TABLE Registrovana_osoba (
    
    RO_Cislo int NOT NULL,
    Telefon varchar(12) NOT NULL,
    Email varchar(320) NOT NULL,
    Heslo varchar(255) NOT NULL,
    Token varchar(20) NOT NULL,
    Metoda_platby varchar(20) NOT NULL,
    Jmeno varchar(255) NOT NULL,
    Prijmeni varchar(255) NOT NULL,
    Statni_prislusnost varchar(255) NOT NULL,
    Datum_narozeni DATE NOT NULL,
    Cestovni_pas varchar(255) NOT NULL,
    Vyskyt_v_cerne_listine varchar(3) NOT NULL

);

CREATE TABLE Rezervace (

    Rezervace_Cislo int NOT NULL PRIMARY KEY,
    Stav varchar(25) NOT NULL

);

CREATE TABLE Letenka (

    Letenka_Cislo int NOT NULL,
    Cena int NOT NULL,
    Stav varchar(15) NOT NULL,
    Covid_doklad varchar(3)

);

CREATE TABLE Palubni_Listek (

    Palubni_Listek_Cislo int NOT NULL,
    Letenka_Cislo int NOT NULL,
    Check_in varchar(3) NOT NULL,
    Gate int NOT NULL

);

CREATE TABLE Sluzba (

    Sluzba_cislo int NOT NULL,
    Nazev varchar(255) NOT NULL,
    Cena int NOT NULL,
    Dostupnost_sluzby varchar(10) NOT NULL

);

CREATE TABLE Sedadlo (

    Sedadlo_cislo int NOT NULL,
    Radek int NOT NULL,
    Misto varchar(1) NOT NULL

);

CREATE TABLE Trida (

    ID_tridy int NOT NULL,
    Nazev varchar(7) NOT NULL,
    Pocet_mist int NOT NULL

);

CREATE TABLE Letadlo (

    Seriove_cislo int NOT NULL,
    Typ_letadla varchar(30)

);

CREATE TABLE Spolecnost (

    DICH int NOT NULL,
    Nazev varchar(255) NOT NULL
    --logo???

);

CREATE TABLE Let (

    Let_cislo int NOT NULL

);

CREATE TABLE Pridana_Sluzba (

    Pridana_Sluzba_cislo int NOT NULL,
    Uspesnost varchar(3) NOT NULL,
    Zahrnuto_v_cene varchar(3) NOT NULL,
    Pocet int NOT NULL

);


ALTER TABLE Osoba ADD CONSTRAINT PK_Osoba PRIMARY KEY (Osoba_Cislo);
ALTER TABLE Registrovana_osoba ADD CONSTRAINT PK_Registrovana_osoba PRIMARY KEY (RO_Cislo);
ALTER TABLE Letenka ADD CONSTRAINT PK_Letenka PRIMARY KEY (Letenka_Cislo);
ALTER TABLE Palubni_Listek ADD CONSTRAINT PK_Palubni_Listek PRIMARY KEY (Palubni_Listek_Cislo, Letenka_Cislo);
ALTER TABLE Palubni_Listek ADD CONSTRAINT FK_Palubni_Listek FOREIGN KEY (Letenka_Cislo) REFERENCES Letenka (Letenka_Cislo);
ALTER TABLE Sedadlo ADD CONSTRAINT PK_Sedadlo PRIMARY KEY (Sedadlo_Cislo);
ALTER TABLE Trida ADD CONSTRAINT PK_Trida PRIMARY KEY (ID_tridy);
ALTER TABLE Letadlo ADD CONSTRAINT PK_Letadlo PRIMARY KEY (Seriove_cislo);
ALTER TABLE Spolecnost ADD CONSTRAINT PK_Spolecnost PRIMARY KEY (DICH);
ALTER TABLE Let ADD CONSTRAINT PK_Let PRIMARY KEY (Let_cislo);
ALTER TABLE Sluzba ADD CONSTRAINT PK_Sluzba PRIMARY KEY (Sluzba_cislo);
ALTER TABLE Registrovana_osoba ADD CONSTRAINT FK_Registrovana_osoba FOREIGN KEY (RO_Cislo) REFERENCES Osoba (Osoba_Cislo);
ALTER TABLE Pridana_Sluzba ADD CONSTRAINT FK_Pridana_Sluzba FOREIGN KEY (Pridana_Sluzba_cislo) REFERENCES Sluzba (Sluzba_cislo);




ALTER TABLE obec ADD CONSTRAINT PK_obec PRIMARY KEY (o_cilso);
ALTER TABLE letiste ADD CONSTRAINT PK_letiste PRIMARY KEY (l_cislo);
ALTER TABLE letovy_itinerar ADD CONSTRAINT PK_letovy_itinerar PRIMARY KEY (lt_cislo);
ALTER TABLE letiste ADD CONSTRAINT FK_letiste_obec FOREIGN KEY (o_cilso) REFERENCES obec;
ALTER TABLE letovy_itinerar ADD CONSTRAINT FK_lt_letiste_odletu FOREIGN KEY (letiste_odletu) REFERENCES letiste;
ALTER TABLE letovy_itinerar ADD CONSTRAINT FK_lt_letiste_priletu FOREIGN KEY (letiste_priletu) REFERENCES letiste;