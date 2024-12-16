CREATE TYPE SAMOCHOD as object (
    nazwa varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji DATE,
    cena NUMBER(10,2)
);

CREATE TABLE SAMOCHODY OF SAMOCHOD;

SELECT * FROM SAMOCHODY;

INSERT INTO SAMOCHODY VALUES ('OPEL', 'CORSA', 9000, TO_DATE('30-01-2012', 'DD-MM-YYYY'), 10000);
INSERT INTO SAMOCHODY VALUES ('SKODA', 'FABIA', 12000, TO_DATE('03-09-2002', 'DD-MM-YYYY'), 15000);
INSERT INTO SAMOCHODY VALUES ('FIAT', 'PUNTO', 28000, TO_DATE('01-01-1999', 'DD-MM-YYYY'), 8000);
INSERT INTO SAMOCHODY VALUES ('FIAT', 'SEDICI', 7000, TO_DATE('27-08-2018', 'DD-MM-YYYY'), 300000);

DESC SAMOCHOD

SELECT * FROM SAMOCHODY;

CREATE TABLE WLASCICIELE(
    imie varchar2(50),
    nazwisko varchar2(50),
    auto SAMOCHOD
);

INSERT INTO WLASCICIELE VALUES ('Joanna', 'Motyka', SAMOCHOD('OPEL', 'CORSA', 9000, TO_DATE('30-01-2012', 'DD-MM-YYYY'), 10000));
INSERT INTO WLASCICIELE VALUES ('Kacper', 'Kowalski', SAMOCHOD('SKODA', 'FABIA', 12000, TO_DATE('03-09-2002', 'DD-MM-YYYY'), 15000));
INSERT INTO WLASCICIELE VALUES ('Jakub', 'Jakubowski', SAMOCHOD('FIAT', 'PUNTO', 28000, TO_DATE('01-01-1999', 'DD-MM-YYYY'), 8000));
INSERT INTO WLASCICIELE VALUES ('Zuzanna', 'Skwarek', SAMOCHOD('FIAT', 'SEDICI', 7000, TO_DATE('27-08-2018', 'DD-MM-YYYY'), 300000));

DESC WLASCICIELE;

SELECT * FROM WLASCICIELE;

alter TYPE SAMOCHOD replace as object (
    nazwa varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji DATE,
    cena NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER
);

create or replace type body SAMOCHOD as
    MEMBER FUNCTION wartosc RETURN NUMBER is
        BEGIN
            RETURN cena*POWER(0.9,
                EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_podukcji));
        END wartosc;
END;

select s.nazwa, s.cena, s.wartosc() from SAMOCHODY s;

ALTER TYPE samochod ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS

    MEMBER FUNCTION wartosc RETURN NUMBER is
        BEGIN
            RETURN cena*POWER(0.9,
                EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_podukcji));
        END wartosc;
END;

    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
     BEGIN
            RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_podukcji) + (kilomerty/10000);
     END odwzoruj;
END;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

drop table WLASCICIELE;

create TYPE WLASCICIEL as object (
    imie VARCHAR2(50),
    nazwisko VARCHAR2(50)
);

create table WLASCICIELE of WLASCICIEL;

drop table SAMOCHODY;
drop type SAMOCHOD;

create TYPE SAMOCHOD as object (
    nazwa varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji DATE,
    cena NUMBER(10,2),
    sWlasciciel REF WLASCICIEL,
    MEMBER FUNCTION wartosc RETURN NUMBER
);

alter type SAMOCHOD add map member function odwzoruj
return number cascade including table data;

create table SAMOCHODY of SAMOCHOD;

Alter table SAMOCHODY Add scope for ( SWLASCICIEL ) is WLASCICIELE;

INSERT INTO WLASCICIELE VALUES
    (new WLASCICIEL('Pola', 'Dworek'));
INSERT INTO WLASCICIELE VALUES
    (new WLASCICIEL('Janko', 'Muzykant'));
INSERT INTO WLASCICIELE VALUES
    (new WLASCICIEL('Maja', 'Buc'));

select * from WLASCICIELE;

insert into SAMOCHODY values ('FIAT', 'BRAVA', 60000, TO_DATE('30-11-1999', 'DD-MM-YYYY'), 25000, null);
insert into SAMOCHODY values ('FORD', 'MONDEO', 80000, TO_DATE('10-05-1997', 'DD-MM-YYYY'), 45000, null);
insert into SAMOCHODY values ('MAZDA', '323', 12000, TO_DATE('22-09-2000', 'DD-MM-YYYY'), 52000, null);

update SAMOCHODY s set s.SWLASCICIEL = (
    SELECT REF(w) from WLASCICIELE w
    where w.imie = 'Maja'
    );
    
select * from SAMOCHODY;

-- kolekcje

DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
     moje_przedmioty(1) := 'MATEMATYKA';
     moje_przedmioty.EXTEND(9);
     FOR i IN 2..10 LOOP
     moje_przedmioty(i) := 'PRZEDMIOT_' || i;
     END LOOP;
     FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
     DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
     END LOOP;
     moje_przedmioty.TRIM(2);
     FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
     DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
     END LOOP;
     DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
     DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
     moje_przedmioty.EXTEND();
     moje_przedmioty(9) := 9;
     DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
     DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
     moje_przedmioty.DELETE();
     DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
     DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 END;

declare
    type t_ksiazki is varray(5) of varchar2(50);
    moje_ksiazki t_ksiazki := t_ksiazki('title');
begin
    for i in moje_ksiazki.first()..moje_ksiazki.last() loop
        dbms_output.put_line(moje_ksiazki(i));
    end loop;
    dbms_output.put_line('Limit: ' || moje_ksiazki.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_ksiazki.count());
    
    moje_ksiazki.extend(4);
    moje_ksiazki(2) := 'Król Szczurów';
    for i in 3..5 loop
        moje_ksiazki(i) := 'Book_' || i;
    end loop;
    
    for i in moje_ksiazki.first()..moje_ksiazki.last() loop
        dbms_output.put_line(moje_ksiazki(i));
    end loop;
    dbms_output.put_line('Limit: ' || moje_ksiazki.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_ksiazki.count());
    
    moje_ksiazki.trim(1);
    for i in moje_ksiazki.first()..moje_ksiazki.last() loop
        dbms_output.put_line(moje_ksiazki(i));
    end loop;
    dbms_output.put_line('Limit: ' || moje_ksiazki.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_ksiazki.count());

end;

DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

declare
    type t_miesiace is table of varchar2(20);
    moje_miesiace t_miesiace := t_miesiace();

begin
    moje_miesiace.extend(12);
    moje_miesiace(1) := 'styczen';
    moje_miesiace(2) := 'luty';
    moje_miesiace(3) := 'marzec';
    moje_miesiace(4) := 'kwiecien';
    moje_miesiace(5) := 'maj';
    moje_miesiace(6) := 'czerwiec';
    
    for i in 7..12 loop
        moje_miesiace(i) := 'Miesiac_' || i;
    end loop;
    
    for i in moje_miesiace.first()..moje_miesiace.last() loop
        if moje_miesiace.exists(i) then
            DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
        end if;
    end loop;
    
    moje_miesiace.delete(7, 12);
    moje_miesiace(7) := 'lipiec';
    
    for i in moje_miesiace.first()..moje_miesiace.last() loop
        if moje_miesiace.exists(i) then
            DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
        end if;
    end loop;

end;

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

create type koszyk_produktow as table of varchar2(20);
/

create type zakup as object (
    osoba varchar2(50),
    produkty koszyk_produktow
);
/

create table zakupy of zakup
nested table produkty store as tab_produkty;
/
insert into zakupy values
(zakup('Anna Antczak', koszyk_produktow('maka', 'jaja', 'banan')));
insert into zakupy values
(zakup('Patryk Fifny', koszyk_produktow('jaja', 'mleko', 'chleb')));
insert into zakupy values
(zakup('Kaja Slon', koszyk_produktow('maslo')));

select * from zakupy;

delete from zakupy 
where osoba in (
    select osoba
    from zakupy z, table(z.produkty) p
    where p.column_value = 'jaja'
);

-- polimorfizm

CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
 /
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
 /
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
 /
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;
/

CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
 /
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
 /
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
/
DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

DECLARE
 tamburyn instrument; 
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

CREATE TABLE instrumenty OF instrument;
/
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES (instrument_dety('trabka', 'tra-ta-ta', 'metalowa'));

);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;