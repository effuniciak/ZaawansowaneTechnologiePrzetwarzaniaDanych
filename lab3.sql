CREATE TABLE DOKUMENTY (
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
);

DECLARE 
    text CLOB;
BEGIN
    FOR i in 1..1000
    LOOP
        text := CONCAT(text, 'Oto tekst ');
    END LOOP;
    
    INSERT INTO DOKUMENTY 
    VALUES(1, text);
END;

SELECT * FROM dokumenty;

SELECT ID, UPPER(dokument) 
FROM dokumenty; 

SELECT ID, LENGTH(dokument)
FROM dokumenty; 

SELECT DBMS_LOB.GETLENGTH(dokument) 
FROM dokumenty; 

SELECT SUBSTR(dokument, 5, 1000)
FROM dokumenty; 

SELECT DBMS_LOB.SUBSTR(dokument, 5, 1000)
FROM dokumenty; 

INSERT INTO dokumenty
VALUES(2, EMPTY_CLOB());

INSERT INTO dokumenty
VALUES(3, NULL);
COMMIT;

SELECT * FROM dokumenty;

SELECT ID, UPPER(dokument) 
FROM dokumenty; 

SELECT ID, LENGTH(dokument)
FROM dokumenty; 

SELECT DBMS_LOB.GETLENGTH(dokument) 
FROM dokumenty; 

SELECT SUBSTR(dokument, 5, 1000)
FROM dokumenty; 

SELECT DBMS_LOB.SUBSTR(dokument, 5, 1000)
FROM dokumenty; 

SELECT directory_name, directory_path from ALL_DIRECTORIES;

DECLARE
     lobd CLOB;
     fils BFILE := BFILENAME('TPD_DIR','dokument.txt');
     doffset INTEGER := 1;
     soffset INTEGER := 1;
     langctx INTEGER := 0;
     warn INTEGER := null;
BEGIN
     SELECT dokument into lobd 
     from dokumenty
     where id=2
     FOR UPDATE;
     
     DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
     DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE, doffset, soffset, 0, langctx, warn);
     DBMS_LOB.FILECLOSE(fils);
     COMMIT;
     dbms_output.put_line('Status: ' || warn);
END;

UPDATE dokumenty
SET dokument = TO_CLOB(BFILENAME('TPD_DIR','dokument.txt'))
WHERE id = 3;

SELECT * FROM dokumenty;

SELECT ID, LENGTH(dokument)
FROM dokumenty; 

DROP TABLE dokumenty;

CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    lobd IN OUT CLOB,
    pattern VARCHAR2
)
IS
    position INTEGER;
    replace_with VARCHAR2(50);
    counter INTEGER;
BEGIN
    FOR counter IN 1..length(pattern) LOOP
        replace_with := replace_with || '.';
    END LOOP;

    LOOP
        position := dbms_lob.instr(lobd, pattern, 1, 1);
        EXIT WHEN position = 0;
        dbms_lob.write(lobd, LENGTH(pattern), position, replace_with);
    END LOOP;
END CLOB_CENSOR;

CREATE TABLE biographies AS SELECT * FROM ZTPD.biographies;

DECLARE
    lobd CLOB;
    
BEGIN
    SELECT bio INTO lobd FROM biographies
    WHERE id = 1 FOR UPDATE;  
    
    CLOB_CENSOR(lobd, 'Cimrman');  
    
    COMMIT;
END;

SELECT bio FROM BIOGRAPHIES;

DROP TABLE biographies;