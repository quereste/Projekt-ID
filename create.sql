drop table if exists marki cascade;
CREATE TABLE marki 
(
	id_marka numeric(4) PRIMARY KEY,
	nazwa varchar(50) NOT NULL,
	nazwa_koncernu varchar(100),

	CONSTRAINT marki_uq_nazwa UNIQUE (nazwa)
);

insert into marki (id_marka, nazwa, nazwa_koncernu) values 
(1,'Audi','Volkswagen AG'),
(2,'BMW','Bayerische Motoren Werke AG'),	
(3,'Fiat','Fiat Chrysler Automobiles'),
(4,'Ford','Ford Motor Company'),
(5,'Honda','Honda Motor Co. Ltd.'),
(6,'Jeep','Fiat Chrysler Automobiles'),
(7,'Lexus','Toyota Motor Corporation'),
(8,'Mazda','Mazda Motor Company'),
(9,'Mercedes-Benz','Daimler AG'),
(10,'Opel','Groupe PSA'),
(11,'Porsche','Volkswagen AG'),
(12,'Seat','Volkswagen AG'),
(13,'Skoda','Volkswagen AG'),
(14,'Subaru','Subaru Corporation'),
(15,'Suzuki','Suzuki Motor Corporation'),
(16,'Toyota','Toyota Motor Corporation'),
(17,'Volkswagen','Volkswagen AG')
;

drop table if exists modele cascade;
CREATE TABLE modele
(
	id_model numeric(8) PRIMARY KEY,
	id_marka numeric(4) REFERENCES marki NOT NULL,
	model varchar(50) NOT NULL,
	masa_min numeric(6),
	zbiornik_paliwa numeric(3),
	segment char(1) NOT NULL,
	poczatek_produkcji numeric(4),
	koniec_produkcji numeric(4),

	
	CONSTRAINT modele_poprawnySegment CHECK (segment IN ('A','B','C','D','E','F','S','M','J')),
	CONSTRAINT modele_uq_modelMarka UNIQUE (model, id_marka),
	CONSTRAINT modele_mozliwyRok_poczatekProd CHECK(poczatek_produkcji >= 1908 AND poczatek_produkcji <= date_part('year', CURRENT_DATE)),
	CONSTRAINT modele_mozliwyRok_koniecProd CHECK(koniec_produkcji >= 1908 AND koniec_produkcji <= date_part('year', CURRENT_DATE)),
	CONSTRAINT modele_poczatekProd_przed_koniecProd CHECK (poczatek_produkcji<=koniec_produkcji)
);

insert into modele (id_marka,id_model,model,segment,poczatek_produkcji,
zbiornik_paliwa,masa_min) values 
(2,1,'X1 II','C',2015,51,1470),
(7,10,'IS III','D',2013,66,1550),
(7,11,'GS IV','E',2012,71,1721),
(11,6,'Panamera II','F',2016,75,1945),
(16,13,'Corolla XII','C',2018,50,1295)
;

insert into modele (id_marka,id_model,model,segment,poczatek_produkcji,koniec_produkcji,
zbiornik_paliwa,masa_min) values 
(2,2,'X3 I','D',2003,2010,67,1755),
(2,3,'X4 I','D',2014,2018,67,1815),
(2,4,'X5 II','E',2006,2013,85,2105),
(2,5,'X6 I','E',2007,2014,85,2100),
(12,7,'Toledo III','C',2004,2009,55,1344),
(12,8,'Ibiza I','B',1984,1993,50,840),
(12,9,'Ibiza IV','B',2008,2017,45,974),
(11,12,'Cayman I','C',2005,2012,64,1295)
;

insert into modele (id_marka,id_model,model,segment,poczatek_produkcji,masa_min) values 
(2,14,'i3','B',2013,1320),
(11,15,'Taycan','E',2019,2359)
;

drop table if exists typ cascade;
CREATE TABLE typ
(
	id_typ numeric(2) PRIMARY KEY,
	nazwa varchar(30) UNIQUE,

	CONSTRAINT typ_notNull_nazwa CHECK(nazwa IS NOT NULL)
);

insert into typ(id_typ, nazwa) values
(1,'SUV'),
(2,'crossover'),
(3,'sedan'),
(4,'minivan'),
(5,'fastback'),
(6,'hatchback'),
(7,'kombi'),
(8,'liftback'),
(9,'kabriolet'),
(10,'van'),
(11,'coupe'),
(12,'roadster')
;

drop table if exists modele_typ cascade;
CREATE TABLE modele_typ
(
	id_typ numeric(2) REFERENCES typ,
	id_model numeric(8) REFERENCES modele,

	PRIMARY KEY (id_typ,id_model)
);

insert into modele_typ(id_model,id_typ) values
(1,2),
(2,1),
(3,1),
(4,1),
(5,1),
(6,5),(6,7),
(7,4),
(8,6),
(9,6),(9,7),
(10,3),
(11,3),
(12,11),(12,12),
(13,6),(13,7),(13,3),
(14,6),
(15,3)
;

drop table if exists wyposazenie cascade;
CREATE TABLE wyposazenie
(
	id_wyposazenie numeric(10) PRIMARY KEY,
	id_marka numeric(4) REFERENCES marki,
	nazwa varchar(50) NOT NULL
);

insert into wyposazenie(id_wyposazenie,id_marka,nazwa) values 
(1,2,'Podstawowe'),
(2,2,'Advantage'),
(3,2,'X Line'),
(4,2,'M Sport'),
(5,2,'Sport Line'),
(6,11,'Panamera 4S'),
(7,11,'4S Diesel'),
(8,11,'Turbo'),
(9,12,'Reference'),
(10,12,'Style'),
(11,12,'Chick'),
(12,12,'Sport'),
(13,7,'Elegance'),
(14,7,'Black'),
(15,7,'F Sport'),
(16,7,'Prestige'),
(17,7,'Elite'),
(18,11,'4S'),
(19,11,'Turbo S')
;

drop table if exists modele_wyposazenie cascade;
CREATE TABLE modele_wyposazenie
(
	id_wyposazenie numeric(4) REFERENCES wyposazenie,
	id_model numeric(4) REFERENCES modele,

	PRIMARY KEY (id_wyposazenie,id_model)
);

drop table if exists rodzaj_napedu cascade;
CREATE TABLE rodzaj_napedu
(
	id_naped numeric(2) PRIMARY KEY,
	nazwa varchar(20) UNIQUE,

	CONSTRAINT rodzaj_napedu_notNull_nazwa CHECK(nazwa IS NOT NULL)
);

insert into rodzaj_napedu (id_naped,nazwa) values 
(1,'AWD'),
(2,'przedni'),
(3,'tylny')
	;

drop table if exists modele_naped cascade;
CREATE TABLE modele_naped
(
	id_naped numeric(2) REFERENCES rodzaj_napedu,
	id_model numeric(8) REFERENCES modele,

	PRIMARY KEY (id_naped,id_model)
);

insert into modele_naped (id_model,id_naped) values 
(1,1),(1,2),
(2,1),
(3,1),
(4,1),
(5,1),
(6,3),(6,1),
(7,2),
(8,2),
(9,2),
(10,3),
(11,1),(11,3),
(12,3),
(13,2),
(15,1)
;


drop table if exists kraje cascade;
CREATE TABLE kraje
(
	id_kraju numeric(3) PRIMARY KEY,
	nazwa varchar(50) UNIQUE,

	CONSTRAINT kraje_notNull_nazwa CHECK(nazwa IS NOT NULL)
);

insert into kraje(id_kraju,nazwa) values 
(1,'Chiny'),
(2,'Niemcy'),
(3,'Holandia'),
(4,'Egipt'),
(5,'Indonezja'),
(6,'Malaje'),
(7,'Rosja'),
(8,'USA'),
(9,'Meksyk'),
(10,'Austria'),
(11,'Hiszpania'),
(12,'Japonia'),
(13,'Finlandia'),
(14,'Anglia'),
(15,'Turcja')
;

drop table if exists modele_kraje cascade;
CREATE TABLE modele_kraje
(
	id_model numeric(8) REFERENCES modele,
	id_kraju numeric(3) REFERENCES kraje,
	
	PRIMARY KEY (id_model,id_kraju)
);

insert into modele_kraje(id_model,id_kraju) values 
(1,2),(1,3),(1,1),(1,4),(1,5),(1,6),
(2,10),
(3,8),(3,7),(3,4),
(4,8),(4,7),(4,9),
(5,7),(5,8),
(6,2),
(7,11),
(8,11),(8,1),
(9,11),
(10,12),
(11,12),
(12,13),(12,2),
(13,12),(13,14),(13,15),
(14,2),
(15,2)
;

drop table if exists kierownicy cascade;
CREATE TABLE kierownicy(
	id_kierownika numeric(4) PRIMARY KEY,
	imie varchar (20) NOT NULL,
	nazwisko varchar (30) NOT NULL,
	telefon varchar (25) NOT NULL
);

drop table if exists salon cascade;
CREATE TABLE salon
(
	id_salon numeric(4) PRIMARY KEY,
	miasto varchar(50) NOT NULL,
	kod_pocztowy char(6),
	adres varchar(50),
	telefon varchar(25),
	id_kierownika numeric(2) REFERENCES kierownicy NOT NULL,
	tylko_nowe char(3) NOT NULL, 
	otwarcie_pon time,
	zamkniecie_pon time,
	otwarcie_wt time,
	zamkniecie_wt time,
	otwarcie_sro time,
	zamkniecie_sro time,
	otwarcie_czw time,
	zamkniecie_czw time,
	otwarcie_pt time,
	zamkniecie_pt time,
	otwarcie_sb time,
	zamkniecie_sb time,
	
	CONSTRAINT salon_godzinyPon CHECK ((otwarcie_pon IS NULL AND zamkniecie_pon IS NULL) 
	OR (otwarcie_pon IS NOT NULL AND zamkniecie_pon IS NOT NULL AND otwarcie_pon < zamkniecie_pon)),
	CONSTRAINT salon_godzinyWt CHECK ((otwarcie_wt IS NULL AND zamkniecie_wt IS NULL) 
	OR (otwarcie_wt IS NOT NULL AND zamkniecie_wt IS NOT NULL AND otwarcie_wt < zamkniecie_wt)),
	CONSTRAINT salon_godzinySro CHECK ((otwarcie_sro IS NULL AND zamkniecie_sro IS NULL) 
	OR (otwarcie_sro IS NOT NULL AND zamkniecie_sro IS NOT NULL AND otwarcie_sro < zamkniecie_sro)),
	CONSTRAINT salon_godzinyCzw CHECK ((otwarcie_czw IS NULL AND zamkniecie_czw IS NULL) 
	OR (otwarcie_czw IS NOT NULL AND zamkniecie_czw IS NOT NULL AND otwarcie_czw < zamkniecie_czw)),
	CONSTRAINT salon_godzinyPt CHECK ((otwarcie_pt IS NULL AND zamkniecie_pt IS NULL) 
	OR (otwarcie_pt IS NOT NULL AND zamkniecie_pt IS NOT NULL AND otwarcie_pt < zamkniecie_pt)),
	CONSTRAINT salon_godzinySb CHECK ((otwarcie_sb IS NULL AND zamkniecie_sb IS NULL) 
	OR (otwarcie_sb IS NOT NULL AND zamkniecie_sb IS NOT NULL AND otwarcie_sb < zamkniecie_sb)),
	CONSTRAINT salon_bool_tylkoNowe CHECK(tylko_nowe='TAK' OR tylko_nowe='NIE')
);

drop table if exists doradcy cascade;
CREATE TABLE doradcy
(
	id_doradcy numeric(6) PRIMARY KEY,
	id_salon numeric(4) REFERENCES salon NOT NULL,
	imie varchar(20) NOT NULL,
	nazwisko varchar(30) NOT NULL,
	telefon varchar(25) NOT NULL,
	email varchar(50) NOT NULL
);

drop table if exists klienci_salonu cascade;
CREATE TABLE klienci_salonu
(
	id_klienta numeric(8) PRIMARY KEY,
	id_doradcy numeric(6) REFERENCES doradcy,
	imie varchar(20),
	nazwisko varchar(30),
	nazwa varchar(100),
	telefon varchar(25),
	email varchar(50),
	newsletter char(3) NOT NULL,

	CONSTRAINT klienci_salonu_notNull_tel_OR_mail CHECK (telefon IS NOT NULL OR email IS NOT NULL),
	CONSTRAINT klienci_salonu_notNull_imieNazwisko_OR_nazwa CHECK((imie IS NOT NULL AND nazwisko IS NOT NULL) OR nazwa IS NOT NULL),
	CONSTRAINT klienci_salonu_bool_newsletter CHECK((newsletter='TAK' AND email IS NOT NULL) OR newsletter='NIE')
);

drop table if exists samochody cascade;
CREATE TABLE samochody
(
	vin char(17) PRIMARY KEY,
	id_model numeric(8) REFERENCES modele NOT NULL,
	id_klienta numeric(8) REFERENCES klienci_salonu, 
	id_wyposazenie numeric(10) REFERENCES wyposazenie,
	id_salon numeric(4) REFERENCES salon NOT NULL,
	rok_produkcji numeric(4) NOT NULL,
	cena numeric(10,2) NOT NULL,
	nowy char(3) NOT NULL,
	liczba_miejsc numeric(2),
	liczba_drzwi numeric(2),
	id_naped numeric(2) REFERENCES rodzaj_napedu NOT NULL,
	silnik varchar(20) NOT NULL,
	przebieg numeric(10),
	silnik_moc_KM numeric(3),
	silnik_moc_kW numeric(3),
	pojemnosc_silnika numeric(4),
	kolor varchar(20) NOT NULL,
	skrzynia_biegow varchar(50),
	spalanie numeric(3,1),
	bezwypadkowy char(3),
	predkosc_max numeric(3),
	liczba_biegow numeric(2),
	id_typ numeric(2) REFERENCES typ NOT NULL,
	przyspieszenie numeric(3,1),
	
	CONSTRAINT samochody_legalVin CHECK(vin ~ '[A-HJ-NPR-Z0-9]{17}'),
	CONSTRAINT samochody_nowyBezPrzebiegu_OR_uzywanyZPrzebiegiem CHECK((nowy='TAK' AND przebieg is null) OR (nowy='NIE' AND przebieg is distinct from NULL)),
	CONSTRAINT samochody_bool_bezwypadkowy CHECK(bezwypadkowy='TAK' OR bezwypadkowy='NIE'),
	CONSTRAINT samochody_poprawnySilnik CHECK(silnik IN('benzyna','diesel','hybryda','gaz','elektryczny')),
	CONSTRAINT samochody_poprawnaSkrzynia CHECK(skrzynia_biegow='automatyczna' OR skrzynia_biegow='manualna' OR skrzynia_biegow='CVT' OR skrzynia_biegow='polautomatyczna'),
	CONSTRAINT samochody_nowyBezwypadkowyFabryczny_OR_uzywany CHECK((nowy='TAK' AND id_klienta is NULL AND bezwypadkowy is NULL) OR (nowy='NIE' AND id_klienta is distinct from NULL AND bezwypadkowy is distinct from NULL)),
	CONSTRAINT samochody_mocSilnika CHECK((silnik_moc_KM is distinct from NULL AND silnik_moc_kW is distinct from NULL AND silnik_moc_kW<silnik_moc_KM) OR (silnik_moc_KM is distinct from NULL OR silnik_moc_kW is distinct from NULL)),
	CONSTRAINT samochody_poprawnyRok CHECK(rok_produkcji >= 1908 AND rok_produkcji <= date_part('year', CURRENT_DATE))
);

drop table if exists historia_transakcji cascade;
CREATE TABLE historia_transakcji
(
        id_transakcji numeric(10) PRIMARY KEY,
	id_salon numeric(4) REFERENCES salon,
        id_modelu numeric(4) REFERENCES modele,
        data_transakcji date NOT NULL,
        wartosc_transakcji numeric(10) NOT NULL,
        sprzedaz char(3) NOT NULL,
        id_klienta numeric(6) REFERENCES klienci_salonu,
        komentarz varchar(1000),

	CONSTRAINT historia_transakcji_notNull_id_klienta CHECK(id_klienta IS NOT NULL),
	CONSTRAINT historia_transakcji_bool_sprzedaz CHECK (sprzedaz='TAK' OR sprzedaz='NIE')
);

--jedna adres email moze zostac tylko raz podany
CREATE OR REPLACE FUNCTION email_uni() RETURNS trigger AS $email_uni$
BEGIN
    IF New.email<>Old.email THEN
        IF (Select count(*) from klienci_salonu where email=NEW.email)>0 then
            RAISE exception 'Tego adresu email uzywa juz ktos inny';
        END IF;

        IF (Select count(*) from doradcy where email=NEW.email)>0 then
            RAISE exception 'Tego adresu email uzywa juz ktos inny';
        END IF;
    END IF;

  RETURN NEW;
END;
$email_uni$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION email_ins() RETURNS trigger AS $email_ins$
BEGIN
        IF (Select count(*) from klienci_salonu where email=NEW.email)>0 then
            RAISE exception 'Tego adresu email uzywa juz ktos inny';
        END IF;

        IF (Select count(*) from doradcy where email=NEW.email)>0 then
            RAISE exception 'Tego adresu email uzywa juz ktos inny';
        END IF;

  RETURN NEW;
END;
$email_ins$ LANGUAGE plpgsql;

--jeden numer telefonu moze zostac tylko raz podany
CREATE OR REPLACE FUNCTION telefon_uni() RETURNS trigger AS $telefon_uni$
BEGIN
    IF New.telefon<>Old.telefon THEN

        IF (Select count(*) from klienci_salonu where telefon=NEW.telefon)>0 then
            RAISE exception 'Tego numeru telefonu uzywa juz ktos inny';
        END IF;

        IF (Select count(*) from doradcy where telefon=NEW.telefon)>0 then
            RAISE exception 'Tego numeru telefonu uzywa juz ktos inny';
        END IF;

        IF (Select count(*) from salon where telefon=NEW.telefon)>0 then
            RAISE exception 'Tego numeru telefonu uzywa juz ktos inny';
        END IF;

        IF (Select count(*) from kierownicy where telefon=NEW.telefon)>0 then
            RAISE exception 'Tego numeru telefonu uzywa juz ktos inny';
        END IF;

    END IF;

  RETURN NEW;
END;
$telefon_uni$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION samochod_data() RETURNS trigger AS $samochod_data$
BEGIN        	
	IF (new.rok_produkcji < (SELECT a.poczatek_produkcji from modele a where a.id_model = new.id_model)) then
	    	RAISE exception 'Ten samochod nie byl produkowany w podanym roku';
	END IF;
        IF (new.rok_produkcji > (SELECT a.koniec_produkcji from modele a where a.id_model = new.id_model)) then
	    	RAISE exception 'Ten samochod nie byl produkowany w podanym roku';
	END IF;
  RETURN NEW;
END;
$samochod_data$ LANGUAGE plpgsql;
				 
CREATE OR REPLACE FUNCTION samochod_naped() RETURNS trigger AS $samochod_naped$
BEGIN        	
	IF (new.id_naped IN (SELECT id_naped from modele_naped a join modele b on a.id_model = b.id_model where a.id_model = new.id_model)) then
  		RETURN NEW;
	END IF;	
	RAISE exception 'Naped niestosowany we wskazanym modelu';
END;
$samochod_naped$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION samochod_typ() RETURNS trigger AS $samochod_typ$
BEGIN        	
	IF (new.id_typ IN (SELECT id_typ from modele_typ a join modele b on a.id_model = b.id_model where a.id_model = new.id_model)) then
  		RETURN NEW;
	END IF;	
	RAISE exception 'Typ nieistniejacy we wskazanym modelu';
END;
$samochod_typ$ LANGUAGE plpgsql;
			   
CREATE OR REPLACE FUNCTION samochod_wyposazenie() RETURNS trigger AS $samochod_wyposazenie$
BEGIN   
	IF new.id_wyposazenie IS NULL then return new; end if;
	IF ((SELECT a.id_marka from modele a where a.id_model = new.id_model) = (select a.id_marka from wyposazenie  a where a.id_wyposazenie = new.id_wyposazenie)) then
		IF (new.id_wyposazenie IN (SELECT id_wyposazenie from modele_wyposazenie a where a.id_model = new.id_model)) then
  		RETURN NEW;
	END IF;	
	END if;
	raise exception 'wyposazenie innej marki';								 
										 
END;
$samochod_wyposazenie$ LANGUAGE plpgsql;
			     
CREATE OR REPLACE FUNCTION telefon_ins() RETURNS trigger AS $telefon_ins$
BEGIN
        IF (Select count(*) from klienci_salonu where telefon=NEW.telefon)>0 then
            RAISE exception 'Tego numeru telefonu uzywa juz ktos inny';
        END IF;

        IF (Select count(*) from doradcy where telefon=NEW.telefon)>0 then
            RAISE exception 'Tego numeru telefonu uzywa juz ktos inny';
        END IF;

        IF (Select count(*) from salon where telefon=NEW.telefon)>0 then
            RAISE exception 'Tego numeru telefonu uzywa juz ktos inny';
        END IF;

        IF (Select count(*) from kierownicy where telefon=NEW.telefon)>0 then
            RAISE exception 'Tego numeru telefonu uzywa juz ktos inny';
        END IF;
  RETURN NEW;
END;
$telefon_ins$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION model_wyposazenie() RETURNS trigger AS $model_wyposazenie$
BEGIN 
	IF (select count(*) from modele left outer join modele_wyposazenie
	using(id_model) where id_model=NEW.id_model AND id_marka NOT IN(
		SELECT w.id_marka
		FROM wyposazenie w
		WHERE w.id_marka IS NOT NULL AND w.id_wyposazenie=NEW.id_wyposazenie
		)
	)>0 then
		raise exception 'wyposazenie innej marki';
	ELSE return new;	
	END IF;
END;
$model_wyposazenie$ LANGUAGE plpgsql;

CREATE TRIGGER telefon_uni BEFORE UPDATE ON kierownicy
FOR EACH ROW EXECUTE PROCEDURE telefon_uni();
CREATE TRIGGER telefon_ins BEFORE INSERT ON kierownicy
FOR EACH ROW EXECUTE PROCEDURE telefon_ins();
			   
CREATE TRIGGER samochod_data BEFORE INSERT ON samochody
FOR EACH ROW EXECUTE PROCEDURE samochod_data();
CREATE TRIGGER samochod_datu BEFORE UPDATE ON samochody
FOR EACH ROW EXECUTE PROCEDURE samochod_data();
			   
CREATE TRIGGER samochod_naped BEFORE INSERT ON samochody
FOR EACH ROW EXECUTE PROCEDURE samochod_naped();
CREATE TRIGGER samochod_napeu BEFORE UPDATE ON samochody
FOR EACH ROW EXECUTE PROCEDURE samochod_naped();

CREATE TRIGGER samochod_typ BEFORE INSERT ON samochody
FOR EACH ROW EXECUTE PROCEDURE samochod_typ();
CREATE TRIGGER samochod_tyu BEFORE UPDATE ON samochody
FOR EACH ROW EXECUTE PROCEDURE samochod_typ();

CREATE TRIGGER samochod_wyposazenie BEFORE INSERT ON samochody
FOR EACH ROW EXECUTE PROCEDURE samochod_wyposazenie();
CREATE TRIGGER samochod_wyposazeniu BEFORE UPDATE ON samochody
FOR EACH ROW EXECUTE PROCEDURE samochod_wyposazenie();

CREATE TRIGGER model_wyposazenie BEFORE INSERT ON modele_wyposazenie
FOR EACH ROW EXECUTE PROCEDURE model_wyposazenie();
CREATE TRIGGER model_wyposazeni BEFORE UPDATE ON modele_wyposazenie
FOR EACH ROW EXECUTE PROCEDURE model_wyposazenie();
	
insert into modele_wyposazenie(id_model,id_wyposazenie) values 
(1,1),(1,2),(1,3),(1,4),(1,5),
(2,1),(2,2),(2,3),(2,4),
(3,1),(3,2),(3,3),(3,4),
(4,1),
(5,1),
(6,6),(6,7),(6,8),
(9,9),(9,10),(9,11),(9,12),
(10,14),(10,15),(10,16),(10,13),
(11,17),(11,16),(11,15),(11,13),
(14,1),
(15,19),(15,8),(15,18)
;
		   
insert into kierownicy(id_kierownika, imie, nazwisko, telefon) values
(10, 'Marcel', 'Buda', '293819292'),
(11, 'Mira', 'Len', '218398293'),
(14, 'Janina', 'Krucien', '129389382'),
(23, 'Leon', 'Modrzejski', '943939203'),
(25, 'Nikodem', 'Pyksa', '723939029'),
(15, 'Kamil', 'Berko', '839290291')
;

CREATE TRIGGER telefon_uni BEFORE UPDATE ON salon
FOR EACH ROW EXECUTE PROCEDURE telefon_uni();
CREATE TRIGGER telefon_ins BEFORE INSERT ON salon
FOR EACH ROW EXECUTE PROCEDURE telefon_ins();

insert into salon (id_salon, miasto, kod_pocztowy, adres, telefon, id_kierownika, tylko_nowe,
		otwarcie_pon, zamkniecie_pon,
		otwarcie_wt, zamkniecie_wt,
		otwarcie_sro, zamkniecie_sro,
		otwarcie_czw, zamkniecie_czw,
		otwarcie_pt, zamkniecie_pt,
		otwarcie_sb, zamkniecie_sb) values 
(1,'Krakow', '30-749', 'ul. Bieszczadzka 23', '124560323', 10, 'NIE','09:00:00', '17:00:00',
	'10:00:00', '16:00:00', NULL, NULL,'08:00:00', '18:00:00',NULL, NULL,
	'08:00:00', '13:00:00'),
(2,'Poznan', '60-104', 'ul. Zacisze 2', '617292031', 11, 'NIE', NULL, NULL, '09:00:00', 	'17:00:00','09:00:00', '19:00:00','08:30:00', '17:30:00', NULL, NULL, NULL, NULL),	
(3,'Warszawa', '00-008', 'ul. Krasna 124', '220192031', 14, 'TAK','12:00:00', '18:00:00',
	'09:00:00', '16:00:00', '09:00:00', '19:00:00','13:00:00', '19:30:00',NULL,NULL, NULL,NULL),
(4,'Opole', '45-001', 'ul. Zarzecze 9', '771231231', 23, 'NIE', NULL, NULL,NULL, NULL,
	'08:00:00', '16:30:00','10:00:00', '19:00:00','11:00:00', '19:00:00', NULL, NULL),
(5,'Kielce', '25-241', 'ul. Rzemieslnicza 191', '419210291', 25, 'NIE','09:00:00', '17:00:00', NULL, NULL,
	'07:30:00', '13:00:00','09:00:00', '17:00:00',NULL, NULL,'09:00:00', '18:30:00'),
(6, 'Debica', '39-122', 'ul. 23 Lipca', '142349102', 15, 'NIE','08:30:00', '17:30:00','12:00:00', '19:00:00',
	'08:00:00', '18:30:00','07:30:00', '17:45:00','08:00:00', '09:30:00', '09:00:00', '13:30:00')
;

CREATE TRIGGER email_uni BEFORE UPDATE ON doradcy
FOR EACH ROW EXECUTE PROCEDURE email_uni();
CREATE TRIGGER email_ins BEFORE INSERT ON doradcy
FOR EACH ROW EXECUTE PROCEDURE email_ins();

CREATE TRIGGER telefon_uni BEFORE UPDATE ON doradcy
FOR EACH ROW EXECUTE PROCEDURE telefon_uni();
CREATE TRIGGER telefon_ins BEFORE INSERT ON doradcy
FOR EACH ROW EXECUTE PROCEDURE telefon_ins();

insert into doradcy(id_doradcy, id_salon, imie, nazwisko, telefon, email) values
(1, 1, 'Michal', 'Radowicz', '815921910', 'rad_dla_porad@salon.com'),
(2, 1, 'Wojciech', 'Praskiniuk', '603495392', 'wpraskiniuk_salon@salon.com'),
(3, 1, 'Elzbieta', 'lorzycz', '507891345', 'elorzycz@salon.com'),
(4, 2, 'Piotr', 'Las', '473920100', 'laspiotrr@salon.com'),
(5, 2, 'Andrzej', 'Narlik', '603019029', 'anarlik@salon.com'),
(6, 2, 'Rafal', 'Plotek', '920929182', 'rplotek@salon.com'),
(7, 3, 'Aleksandra', 'Willinowicz', '540291029', 'a.willinowicz@salon.com'),
(8, 3, 'Karolina', 'Steczko', '755039291', 'karsteczko@salon.com'),
(9, 4, 'Urszula', 'Kaj', '382918283', 'ukaj@salon.com'),
(10, 4, 'Hanna', 'Lubecka', '503920192', 'hanna.lubecka@salon.com'),
(11, 4, 'Wladyslaw', 'Nikiliszyn', '740392810', 'wniki@salon.com'),
(12, 5, 'Pawel', 'Obrotny', '649201928', 'pawel.obrotny@salon.com'),
(13, 6, 'Pola', 'Wurcel', '682920192', 'powur@mi.pl'),
(14, 6, 'Konstanty', 'Brodziszewski', '739201928', 'kbrodziszewski@salon.com'),
(15, 6, 'Mikolaj', 'Zasiecki', '273817388', 'mzasiek@salon.com')
;

CREATE TRIGGER email_uni BEFORE UPDATE ON klienci_salonu
FOR EACH ROW EXECUTE PROCEDURE email_uni();
CREATE TRIGGER email_ins BEFORE INSERT ON klienci_salonu
FOR EACH ROW EXECUTE PROCEDURE email_ins();

CREATE TRIGGER telefon_uni BEFORE UPDATE ON klienci_salonu
FOR EACH ROW EXECUTE PROCEDURE telefon_uni();
CREATE TRIGGER telefon_ins BEFORE INSERT ON klienci_salonu
FOR EACH ROW EXECUTE PROCEDURE telefon_ins();

insert into klienci_salonu(id_klienta, id_doradcy, imie, nazwisko, telefon, email,newsletter) values
(1, 3, 'Marek', 'Wozidlo', '859382712', NULL,'NIE'),
(2, 8, 'Patryk', 'Tretz', '543291823', 'trectryk@domena.com', 'TAK'),
(3, 11, 'Paulina', 'Zdrojna', '928172947', 'paula_z_d@qi.pl', 'TAK'),
(4, 15, 'Leon', 'Borsuk', '127482712', NULL,'NIE'),
(5, 7, 'Piotr', 'Bucki', '281928172', 'pb_ucki@tk.pl','NIE'),
(6, 10, 'Kamila', 'Niedrzecka', '129482019', 'kama_nieka@wi.com', 'TAK'),
(7, 2, 'Ludomir', 'Kostrzynko', '274719287', 'lokostrzynko@qw.un', 'TAK'),
(8, 5, 'Andrzej', 'Durkiewicz', NULL, 'adurkiewicz@domena.com', 'TAK'),
(9, 11, 'Adrianna', 'Arkiuk', '291823812', 'aakk_191@mi.pl', 'TAK'),
(10, 4, 'Walerian', 'Koska', '291029381', 'wkos_ka@domena.com', 'TAK'),
(11, 6, 'Porfiry', 'Genecki', '492810391', 'pgeneta@domena.com', 'TAK'),
(12, 8, 'Alojzy', 'Mostrzycki', '291820192', 'a.mostrzycki@lk.kl', 'TAK'),
(13, 9, 'Konstantyn', 'Afinicz', '928102938', NULL,'NIE'),
(14, 1, 'Lidia', 'Andrzejewna', NULL, 'landrzejewna@domena.com', 'TAK'),
(15, 13, 'Filip', 'Steff', NULL, 'fsteff@dk.kl', 'TAK'),
(16, 4, 'Kamil', 'Drzazga', NULL, 'kdrzazga@domena.com', 'TAK'),
(17, 3, 'Witold', 'Urbanowicz', '281928173', 'fi_mail_3@mi.pl','NIE'),
(18, 9, 'Artur', 'Mic', '128374382', 'amicki@domena.com', 'TAK'),
(19, 10, 'Nikodem', 'Potocki', '827102918', 'nipotocki@lk.kl', 'TAK'),
(20, 2, 'Maria', 'Olisz', '283918291', 'marysolisz@domena.com', 'TAK'),
(21, 7, 'Eleonora', 'Wirzko', '827102812', 'e.wirzko@domena.com', 'TAK'),
(22, 13, 'Lech', 'Strumien', '283918203', 'tr.dk_291@lwi.com','NIE'),
(23, 8, 'Nadia', 'Kusnierz', '748293812', 'nkusnierz1906@mi.com', 'TAK'),
(24, 5, 'Pawel', 'Zadrzek', '1283729382', 'pzadrzek@domena.com', 'TAK'),
(25, 1, 'Magdalena', 'Nikolajewna', '563829172', 'mniki_kk@lk.kl','NIE'),
(26, 7, 'Euzebiusz', 'Nil', '827203918', 'enilck_23@domena.com', 'TAK'),
(27, 4, 'Malgorzata', 'Koszmir', '921092919', 'mkoszmir@domena.com', 'TAK'),
(28, 9, 'Kacper', 'Wojcik', '473928372', 'bacper_w@mi.pl', 'TAK'),
(29, 12, 'Boguslaw', 'Iwanowski', '729382102', 'mkibogus@mi.pl','NIE'),
(30, 6, 'Justyna', 'Larssen', '291273819', 'justi_lar_291@domena.com','NIE')
;

insert into klienci_salonu(id_klienta, id_doradcy, nazwa, telefon, email,newsletter) values
(31, 2, 'Zarzad Zieleni Miejskiej Niepolomice sp. z o.o', '124938372', 'niepolomice.zielen@domena.com','NIE'),
(32, 3, 'Anielski Orszak - Zaklad Uslug Pogrzebowo - Grabarskich Lipinki', '129392929', 'lipinki.anielskiorszak@kl.lk','NIE'),
(33, 1, 'Okamgnienie - Pozyczki', '123459382', 'okamgnienie@mi.pl', 'TAK'),
(34, 1, 'Hubert Stolarz - Remonty', '472819283', 'hstolarz@remont.pl','NIE'),
(35, 3, 'Gorlice i Okolice - Wycieczki w plenerze', '739304938', 'poznajgorlice@domena.com', 'TAK'),
(36, 5, 'Rusalka - kajaki, lodzie - wypozyczalnia', '749382019', 'rusalka@kajak.com','NIE'),
(37, 6, 'Jezykowy Poznan - Szkola Jezykow Obcych', '728392817', 'pjezyki@sjo.com', 'TAK'),
(38, 5, 'Wedliny Zbojnik', '372829382', 'zbojnikwedliny@domena.com','NIE'),
(39, 6, 'Marcel Mich - Kursy Pszczelarskie', '728293019', 'pszczelarz.kobylnica@lk.lk','NIE'),
(40, 6, 'NordicWalking nad Prosna', '283928382', 'prosna.wycieczki@domena.com', 'TAK'),
(41, 4, 'Drzwi i Okna Poznan - Winogrady', '738298371', 'winogrady.firma@domena.com','NIE'),
(42, 8, 'Mokotow - Przeprowadzka dla Ciebie' , '746294029', 'moko_przepro@domena.com', 'TAK'),
(43, 8, 'Piekarnia WP - Wypieki Pawla', '758392823', 'wppiekarnia@domena.com','NIE'),
(44, 9, 'O Polu i Dworze - Wycieczki w Przeszlosc', '485938493', 'opole.historia@mi.pl', 'TAK'),
(45, 9, 'UKS Opolanka Opole', '849302938', 'opolankaopole.pilka@gh.com', 'TAK'),
(46, 11, 'Parafia Opole', '389230299', 'parafia_opole@domena.com', 'TAK'),
(47, 10, 'Wojciech Mirko - Zdun', '189930298', 'zdun.opole@lk.kl','NIE'),
(48, 12, 'Elektryka dla Bzika - Kolo Mlodych Fizykow', '849283928', 'kmf.edb@mi.pl','NIE'),
(49, 12, 'Milosz Mila - Fotografia', '827391029', 'mmfoto@kielce.pl','NIE'),
(50, 12, 'Tanie Kieleckie Taksowki', '382910392', 'tkt@domena.com', 'TAK'),
(51, 12, 'Robert - Przewoz Osob', '829102938', 'rpo@lk.kl', 'TAK'),
(52, 12, 'Szyk i Styl - Fryzjer Kielce', '829019283', 'sisfk@mi.pl','NIE'),
(53, 14, 'Korepetycje - Debica', '823749039', 'debica.korepetycje.pl', 'TAK'),
(54, 14, 'Szewc Dratewka', '798345789', 'dratwa.szewc12@domena.com', 'TAK'),
(55, 15, 'Ludwisarz - Szybko, Tanio, z Humorem', NULL, 'ludwisarz.debica@domena.com','NIE')
;

--automatycznie uzupelnia moc silnika wyrazona w innych jednostkach
CREATE OR REPLACE FUNCTION KM_kW() RETURNS trigger AS $KM_kW$
BEGIN
  IF NEW.silnik_moc_KM is null then
  	NEW.silnik_moc_KM=ROUND((1.36*NEW.silnik_moc_kW),0);
  ELSE
	IF NEW.silnik_moc_kW is null then
  	  NEW.silnik_moc_kW=ROUND((0.7355*NEW.silnik_moc_KM),0);
	END IF;
  END IF;

  RETURN NEW;
END;
$KM_kW$ LANGUAGE plpgsql;

CREATE TRIGGER KM_kW BEFORE INSERT OR UPDATE ON samochody
FOR EACH ROW EXECUTE PROCEDURE KM_kW();

--uzywany samochod nie moze byc przypisany do salonu ktory ma tylko samochody nowe
CREATE OR REPLACE FUNCTION uzywany() RETURNS trigger AS $uzywany$
BEGIN
    IF (New.nowy='NIE' AND (Select tylko_nowe from salon where id_salon=NEW.id_salon)='TAK') then
        RAISE exception 'Samochod jest uzywany, a salon sprzedaje tylko samochody nowe';
    END IF;

  RETURN NEW;
END;
$uzywany$ LANGUAGE plpgsql;

CREATE TRIGGER uzywany BEFORE INSERT OR UPDATE ON samochody
FOR EACH ROW EXECUTE PROCEDURE uzywany();

insert into samochody(id_salon, id_model,vin,cena,nowy,liczba_drzwi,kolor,id_wyposazenie,
rok_produkcji,liczba_miejsc,id_naped,silnik,spalanie,skrzynia_biegow,liczba_biegow,
silnik_moc_KM,predkosc_max,id_typ,przyspieszenie, id_klienta, przebieg, bezwypadkowy) values
(1, 10, 'WBADE6322VBW51982', 34000, 'NIE',  5, 'zielony', 14, 2016, 5, 3,  'hybryda',  6.6, 'manualna', 6, 223, 210, 3, 8.3, 4, 67000, 'NIE'),
(6, 10, '1HD1GPM15CC339172', 19200, 'NIE', 5, 'bialy', 16, 2015, 5, 3, 'benzyna', 7.0, 'manualna', 6, 245, 210, 3, 8.3, 27, 84000, 'TAK'),
(4, 10, '1FMYU92ZX5KD13670', 49000, 'NIE', 5, 'zolty', 15, 2017, 5, 3, 'diesel', 6.0, 'automatyczna', 6, 169, 190, 3, 9.3, 7, 59000, 'TAK'),
(5, 3, '5J6RE4H48BL023237', 35900, 'NIE', 5, 'bordowy', 2, 2017, 5, 1, 'benzyna', 7.2, 'manualna', 6, 184, 212, 1, 8.1, 24, 57000, 'TAK'),
(2, 3, '1FUJA6CV74DM34063', 27000, 'NIE', 5, 'czarny', 3, 2017, 5, 1, 'diesel', 5.4, 'automatyczna', 8, 190, 212, 1, 8.0, 7, 70000, 'NIE'),
(1, 3, '5N3ZA0NE6AN906847', 45300, 'NIE', 5, 'pomaranczowy', 4, 2018, 5, 1,'benzyna', 8.6, 'manualna', 6, 360, 250, 1, 4.9, 9, 39000, 'TAK'),
(5, 4, '4A3AB76T68E011282', 22900, 'NIE', 5, 'srebrny', 1, 2006, 5, 1, 'benzyna', 9.0, 'automatyczna', 5, 231, 202, 1, 8.5, 27, 98000, 'TAK'),
(5, 4, '1N4BA41E74C829102', 17800, 'NIE', 5, 'blekitny', 1, 2007, 5, 1, 'diesel', 6.6, 'manualna', 6, 184, 200, 1, 10.1, 26, 112000, 'TAK'),
(2, 5, '1GMDX03E8VD266902', 23000, 'NIE', 5, 'szary', 1, 2008, 5, 1, 'benzyna', 11.0, 'manualna', 6, 306, 240, 1, 6.7, 36, 97000, 'TAK'),
(2, 5, '1GBJ7D1B4BV132373', 17000, 'NIE', 5, 'szary', 1, 2008, 5, 1, 'benzyna', 11.0, 'manualna', 6, 306, 240, 1, 6.7, 36, 94300, 'NIE'),
(2, 5, 'YV1672MK9D2304784', 18500, 'NIE', 5, 'szary', 1, 2008, 5, 1, 'benzyna', 11.0, 'manualna', 6, 306, 240, 1, 6.7, 36, 102500, 'TAK'),
(2, 5, 'JH4KA4630LC007479', 16900, 'NIE', 5, 'szary', 1, 2008, 5, 1, 'benzyna', 11.0, 'manualna', 6, 306, 240, 1, 6.7, 36, 82300, 'NIE'),
(6, 7, '1FV3GFBC0YHA74039', 4300, 'NIE', 5, 'granatowy', NULL, 2005, 5,  2, 'benzyna', 8.1, 'automatyczna', 4,  75, 170, 4, 13.2, 29,  143900, 'TAK'),
(1, 7, 'SCBLC37F85CX10207', 3900, 'NIE', 5, 'karmazynowy', NULL, 2005, 5, 2, 'benzyna', 8.1, 'manualna', 5, 71, 170, 4, 13.3, 28, 162000, 'TAK'),
(2, 7, 'JHMFA16586S014014', 2300, 'NIE', 5, 'czarny', NULL, 2006, 5, 2, 'diesel', 5.4, 'automatyczna', 4,  68, 165, 4, 16.5, 7, 173000, 'NIE')
;

insert into samochody(id_salon, id_model, vin ,cena,nowy,liczba_drzwi,kolor,id_wyposazenie,
rok_produkcji,liczba_miejsc,id_naped,silnik,spalanie,skrzynia_biegow,liczba_biegow,
silnik_moc_KM,predkosc_max,id_typ,przyspieszenie) values 
(1,1,'WDCGG8HB0AF462890',159100,'TAK',5,'niebieski',1,2018,5,2,'benzyna',5.9,'manualna',6,192,225,2,7.7),
(1, 1, 'WP1AB29P99LA40680', 143900, 'TAK', 5, 'srebrny', 2, 2016, 5, 1, 'benzyna', 7.2, 'automatyczna', 8, 245,240, 2, 6.4),
(1, 1, '2C3CCAET4CH256062', 162100, 'TAK', 5, 'czarny', 5, 2016, 5, 2, 'diesel', 5.2, 'automatyczna', 8, 116, 189, 2, 11.3),
(1, 6,'1J4GZ58S9VC710649',543540,'TAK',5,'niebieski',7,2019,4,3,'diesel',6.8,'automatyczna',8,422,285,5,4.5)
;

insert into samochody (id_salon, id_model,vin,cena,nowy,liczba_drzwi,kolor,
rok_produkcji,liczba_miejsc,id_naped,silnik,spalanie,skrzynia_biegow,liczba_biegow,
silnik_moc_KM,predkosc_max,id_typ) values 
(1, 13,'KM8JT3AC2DU583865',59600,'TAK',5,'srebrny',2020,5,2,'diesel',3.5,'manualna',6,90,175,7)
;

insert into samochody (id_salon, id_model,vin,cena,nowy,liczba_drzwi,kolor,id_wyposazenie,
rok_produkcji,liczba_miejsc,id_naped,silnik,spalanie,skrzynia_biegow,
silnik_moc_KM,predkosc_max,id_typ) values 
(1, 10,'1C4GJWAG0DL544058',199000,'TAK',4,'czarny',14,2018,5,3,'hybryda',4.2,'CVT',223,200,3),
(1, 11,'JF1GV7F67DG002982',291900,'TAK',4,'srebrny',13,2019,5,1,'hybryda',5.9,'CVT',345,250,3)
;

insert into samochody (id_salon, id_model,vin,cena,nowy,liczba_drzwi,kolor,id_wyposazenie,
rok_produkcji,liczba_miejsc,id_naped,silnik,spalanie,silnik_moc_kW,
silnik_moc_KM,predkosc_max,id_typ,przyspieszenie) values 
(1, 15,'WBAHD5313MBF95736',159000,'TAK',4,'niebieski',19,2020,4,1,'elektryczny',0,125,170,150,3,7.3),
(1, 15,'JH4DA3360JS015375',617136,'TAK',4,'bialy',8,2020,4,1,'elektryczny',0,460,625,260,3,3.2)
;

insert into historia_transakcji(id_transakcji, id_salon, id_modelu, data_transakcji, wartosc_transakcji, sprzedaz, id_klienta, komentarz) values
(1, 1, 1, '2019-05-31', 34000, 'TAK', 1, 'pierwsza sprzedaz'),
(2, 1, 1, '2019-06-03', 27000, 'TAK', 7, NULL),
(3, 1, 5, '2019-06-04', 91000, 'TAK', 14, NULL),
(4, 1, 7, '2019-06-23', 3490, 'TAK', 7, NULL),
(5, 1, 13, '2019-07-01', 14300, 'TAK', 17, 'reklamacja produktu'),
(6, 1, 10, '2019-07-03', 27000, 'NIE', 4, 'man, hybryda'),
(7, 1, 3, '2019-07-10', 38900, 'NIE',  9, NULL),
(8, 1, 7, '2019-07-13', 3400, 'NIE', 28, NULL),
(9, 2, 3, '2019-07-14', 24900, 'NIE',  7, 'otwarcie drugiej filii'),
(10, 2, 5, '2019-07-23', 19000, 'NIE', 36, 'pierwszy z czterech BMW - transakcja Rusalka - Kajaki'),
(11, 2, 5, '2019-07-23', 17500, 'NIE', 36, NULL),
(12, 2, 5, '2019-07-23', 16000, 'NIE', 36, NULL),
(13, 2, 5, '2019-07-24', 15000, 'NIE', 36, NULL),
(14, 1, 9, '2019-08-01', 17900, 'TAK',  31, NULL),
(15, 2, 15, '2019-08-02', 23000, 'TAK', 40, 'nawiazanie wspolpracy z NW Nad Prosna'),
(16, 2, 7, '2019-08-09', 1900, 'NIE', 7, NULL),
(17, 3, 8, '2019-08-24', 52900, 'TAK', 42, 'Warszawa - pierwsza sprzedaz'),
(18, 4, 10, '2019-08-31', 36000, 'NIE', 7, NULL),
(19, 1, 11, '2019-08-31', 39300, 'TAK', 7, NULL),
(20, 5, 4, '2019-09-11', 20000, 'NIE', 27, NULL),
(21, 5, 4, '2019-09-12', 16300, 'NIE', 26, NULL),
(22, 5, 3, '2019-09-21', 29000, 'NIE', 24, NULL),
(23, 2, 3, '2019-09-27', 41000, 'TAK', 11, NULL),
(24, 6, 10, '2019-10-01', 17200, 'NIE', 27, NULL),
(25, 6, 7, '2019-10-03', 3500, 'NIE', 29, NULL)
;