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

CREATE TABLE Osoba (

    Osoba_Cislo INTEGER NOT NULL,
    Jmeno VARCHAR(255) NOT NULL,
    Prijmeni VARCHAR(255) NOT NULL,
    Statni_prislusnost VARCHAR(255) NOT NULL,
    Datum_narozeni DATE NOT NULL,
    Cestovni_pas VARCHAR(20) NOT NULL,
    --Y or N
    Vyskyt_v_cerne_listine CHAR(1) NOT NULL

);

CREATE TABLE Registrovana_osoba (
    
    Osoba_Cislo INTEGER NOT NULL,
    Telefon VARCHAR(12) NOT NULL,
    Email VARCHAR(320) NOT NULL,
    Heslo VARCHAR(255) NOT NULL,
    Token VARCHAR(20) NOT NULL,
    Metoda_platby VARCHAR(20) NOT NULL
);

CREATE TABLE Rezervace (

    Rezervace_Cislo INTEGER NOT NULL,
    Stav VARCHAR(25) NOT NULL,
    Osoba_Cislo INTEGER NOT NULL

);

CREATE TABLE Letenka (

    Letenka_Cislo INTEGER NOT NULL,
    Cena INTEGER NOT NULL,
    Stav VARCHAR(15) NOT NULL,
    Covid_doklad VARCHAR(255),
    Rezervace_Cislo INTEGER NOT NULL,
    Osoba_Cislo INTEGER NOT NULL

);

CREATE TABLE Palubni_Listek (

    Palubni_Listek_Cislo INTEGER NOT NULL,
    Letenka_Cislo INTEGER NOT NULL,
    Check_in CHAR(1) NOT NULL,
    Gate INTEGER NOT NULL,
    Letenka_Cislo INTEGER NOT NULL,
    Let_cislo INTEGER NOT NULL

);

CREATE TABLE Sluzba (

    Sluzba_cislo INTEGER NOT NULL,
    Nazev varchar(255) NOT NULL,
    Cena INTEGER NOT NULL,
    Dostupnost_sluzby CHAR(1) NOT NULL

);

CREATE TABLE Sedadlo (

    Sedadlo_cislo INTEGER NOT NULL,
    Radek INTEGER NOT NULL,
    Misto CHAR(1) NOT NULL,
    ID_tridy INTEGER NOT NULL

);

CREATE TABLE Trida (

    ID_tridy INTEGER NOT NULL,
    Nazev varchar(7) NOT NULL,
    Pocet_mist INTEGER NOT NULL

);

CREATE TABLE Letadlo (

    Seriove_cislo INTEGER NOT NULL,
    Typ_letadla varchar(30),
    DICH INTEGER NOT NULL
);

CREATE TABLE Spolecnost (

    DICH INTEGER NOT NULL,
    Nazev varchar(255) NOT NULL,
    logo VARCHAR(255)

);

CREATE TABLE Let (

    Let_cislo INTEGER NOT NULL,
    lt_cislo INTEGER NOT NULL,
    DICH INTEGER NOT NULL,
    Seriove_cislo_letadla NOT NULL

);

--N to N Tables

CREATE TABLE Pridana_Sluzba (

    Sluzba_cislo INTEGER NOT NULL,
    Letenka_Cislo INTEGER NOT NULL,
    Uspesnost varchar(3) NOT NULL,
    Zahrnuto_v_cene varchar(3) NOT NULL,
    Pocet INTEGER NOT NULL
);

CREATE TABLE Osoba_Letenka (
    Osoba_Cislo INTEGER NOT NULL,
    Letenka_Cislo INTEGER NOT NULL
);

CREATE TABLE Sedadlo_Palubli_listek (
    Sedadlo_Cislo INTEGER NOT NULL,
    Palubni_Listek_Cislo INTEGER NOT NULL
);

CREATE TABLE Trida_Letadlo (
    ID_tridy INTEGER NOT NULL,
    Seriove_cislo INTEGER NOT NULL
);

CREATE TABLE Spolecnost_Letiste(
    DICH INTEGER NOT NULL,
    l_cislo INTEGER NOT NULL
)



ALTER TABLE Osoba ADD CONSTRAINT PK_Osoba PRIMARY KEY (Osoba_Cislo);
--ALTER TABLE Registrovana_osoba ADD CONSTRAINT PK_Osoba PRIMARY KEY (Osoba_Cislo);
ALTER TABLE Registrovana_osoba ADD CONSTRAINT PK_Osoba PRIMARY KEY (Osoba_Cislo) REFERENCES Osoba (Osoba_Cislo);

ALTER TABLE Rezervace ADD CONSTRAINT PK_Rezervace PRIMARY KEY (Rezervace_Cislo);
ALTER TABLE Rezervace ADD CONSTRAINT FK_Osoba FOREIGN KEY (Osoba_Cislo) REFERENCES Registrovana_osoba (Osoba_Cislo);

ALTER TABLE Letenka ADD CONSTRAINT PK_Letenka PRIMARY KEY (Letenka_Cislo);
ALTER TABLE Letenka ADD CONSTRAINT FK_Rezervace FOREIGN KEY (Rezervace_Cislo) REFERENCES Rezervace (Rezervace_Cislo);

ALTER TABLE Palubni_Listek ADD CONSTRAINT PK_Palubni_Listek PRIMARY KEY (Palubni_Listek_Cislo);
ALTER TABLE Palubni_Listek ADD CONSTRAINT FK_Palubni_Listek FOREIGN KEY (Letenka_Cislo) REFERENCES Letenka (Letenka_Cislo);

ALTER TABLE Sedadlo ADD CONSTRAINT PK_Sedadlo PRIMARY KEY (Sedadlo_Cislo);
ALTER TABLE Sedadlo ADD CONSTRAINT FK_Trida FOREIGN KEY (ID_tridy) REFERENCES Trida (ID_tridy);

ALTER TABLE Trida ADD CONSTRAINT PK_Trida PRIMARY KEY (ID_tridy);

ALTER TABLE Letadlo ADD CONSTRAINT PK_Letadlo PRIMARY KEY (Seriove_cislo);
ALTER TABLE Letadlo ADD CONSTRAINT FK_Spolecnost FOREIGN KEY (DICH) REFERENCES Spolecnost (DICH);

ALTER TABLE Spolecnost ADD CONSTRAINT PK_Spolecnost PRIMARY KEY (DICH);

ALTER TABLE Let ADD CONSTRAINT PK_Let PRIMARY KEY (Let_cislo);
ALTER TABLE Let ADD CONSTRAINT FK_Spolecnost FOREIGN KEY (DICH) REFERENCES Spolecnost (DICH);
ALTER TABLE Let ADD CONSTRAINT FK_Letovy_itinerar FOREIGN KEY (lt_cislo) REFERENCES letovy_itinerar (lt_cislo);
ALTER TABLE Let ADD CONSTRAINT FK_Letadlo FOREIGN KEY (Seriove_cislo_letadla) REFERENCES Letadlo (Seriove_cislo);

ALTER TABLE Sluzba ADD CONSTRAINT PK_Sluzba PRIMARY KEY (Sluzba_cislo);

ALTER TABLE obec ADD CONSTRAINT PK_obec PRIMARY KEY (o_cilso);

ALTER TABLE letiste ADD CONSTRAINT PK_letiste PRIMARY KEY (l_cislo);
ALTER TABLE letiste ADD CONSTRAINT FK_letiste_obec FOREIGN KEY (o_cilso) REFERENCES obec;

ALTER TABLE letovy_itinerar ADD CONSTRAINT PK_letovy_itinerar PRIMARY KEY (lt_cislo);
ALTER TABLE letovy_itinerar ADD CONSTRAINT FK_lt_letiste_odletu FOREIGN KEY (letiste_odletu) REFERENCES letiste;
ALTER TABLE letovy_itinerar ADD CONSTRAINT FK_lt_letiste_priletu FOREIGN KEY (letiste_priletu) REFERENCES letiste;

-- N to N
ALTER TABLE Osoba_Letenka ADD CONSTRAINT PK_Osoba_Letenka PRIMARY KEY (Osoba_Cislo, Letenka_Cislo);
ALTER TABLE Osoba_Letenka ADD CONSTRAINT FK_Osoba FOREIGN KEY (Osoba_Cislo) REFERENCES Osoba (Osoba_Cislo);
ALTER TABLE Osoba_Letenka ADD CONSTRAINT FK_Letenka FOREIGN KEY (Letenka_Cislo) REFERENCES Letenka (Letenka_Cislo);

ALTER TABLE Pridana_Sluzba ADD CONSTRAINT PK_Pridana_SLuzba PRIMARY KEY (Sluzba_cislo, Letenka_Cislo);
ALTER TABLE Pridana_Sluzba ADD CONSTRAINT FK_Sluzba FOREIGN KEY (Sluzba_cislo) REFERENCES Sluzba (Sluzba_cislo);
ALTER TABLE Pridana_Sluzba ADD CONSTRAINT FK_Letenka FOREIGN KEY (Letenka_Cislo) REFERENCES Letenka (Letenka_Cislo);

ALTER TABLE Sedadlo_Palubli_listek ADD CONSTRAINT PK_Sedadlo_Palubli_listek PRIMARY KEY (Palubni_Listek_Cislo, Sedadlo_Cislo);
ALTER TABLE Sedadlo_Palubli_listek ADD CONSTRAINT FK_Sedadlo FOREIGN KEY (Sedadlo_Cislo) REFERENCES Sedadlo (Sedadlo_Cislo);
ALTER TABLE Sedadlo_Palubli_listek ADD CONSTRAINT FK_Palubni_Listek FOREIGN KEY (Palubni_Listek_Cislo) REFERENCES Palubni_Listek_Cislo (Palubni_Listek_Cislo);

ALTER TABLE Trida_Letadlo ADD CONSTRAINT PK_Trida_Letadlo PRIMARY KEY (ID_tridy, Seriove_cislo);
ALTER TABLE Trida_Letadlo ADD CONSTRAINT FK_Trida FOREIGN KEY (ID_tridy) REFERENCES Trida (ID_tridy);
ALTER TABLE Trida_Letadlo ADD CONSTRAINT FK_Letadlo FOREIGN KEY (Seriove_cislo) REFERENCES Letadlo (Seriove_cislo);

ALTER TABLE Spolecnost_Letiste ADD CONSTRAINT PK_Spolecnost_Letiste PRIMARY KEY (DICH, l_cislo);
ALTER TABLE Spolecnost_Letiste ADD CONSTRAINT FK_Spolecnost FOREIGN KEY (DICH) REFERENCES Spolecnost (DICH);
ALTER TABLE Spolecnost_Letiste ADD CONSTRAINT FK_ FOREIGN KEY (Seriove_cislo) REFERENCES Letadlo (Seriove_cislo);