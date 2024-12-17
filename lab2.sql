CREATE TABLE movies AS SELECT * FROM ztpd.movies;

CREATE TABLE MOVIES
(
    ID NUMBER(12) PRIMARY KEY,
    TITLE VARCHAR2(400) NOT NULL,
    CATEGORY VARCHAR2(50),
    YEAR CHAR(4),
    CAST VARCHAR2(4000),
    DIRECTOR VARCHAR2(4000),
    STORY VARCHAR2(4000),
    PRICE NUMBER(5,2),
    COVER BLOB,
    MIME_TYPE VARCHAR2(50)
);

INSERT INTO MOVIES SELECT * FROM ztpd.movies;

SELECT id, title FROM MOVIES
WHERE cover IS NULL;

SELECT id, title, length(cover) as FILESIZE 
FROM movies
WHERE cover IS NOT NULL;

SELECT id, title, length(cover) as FILESIZE 
FROM movies
WHERE cover IS NULL;

SELECT * FROM ALL_DIRECTORIES;

UPDATE movies
    SET
    cover = EMPTY_BLOB(),
    mime_type = 'image/jpeg'
WHERE id = 66;

SELECT id, title, length(cover) as FILESIZE 
FROM movies
WHERE id IN (65, 66);

DECLARE
     lobd blob;
     fils BFILE := BFILENAME('ZSBD_DIR','escape.jpg');
BEGIN
     SELECT cover into lobd from movies
     where id = 66
     FOR UPDATE;
     DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
     DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
     DBMS_LOB.FILECLOSE(fils);
     COMMIT;
END;

CREATE TABLE TEMP_COVERS(
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

INSERT INTO temp_covers 
VALUES(65, BFILENAME('ZSBD_DIR','eagles.jpg'),'image/jpeg');
COMMIT;

SELECT movie_id, DBMS_LOB.GETLENGTH(image)
FROM temp_covers;

DECLARE
     mime VARCHAR2(50);
     image BFILE;
     lobd blob;
BEGIN
    
    SELECT mime_type into mime from temp_covers;
    SELECT image into image from temp_covers;
    
    dbms_lob.createtemporary(lobd, TRUE);
    
    DBMS_LOB.fileopen(image, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd, image, DBMS_LOB.GETLENGTH(image));
    DBMS_LOB.FILECLOSE(image);
    
    update movies
    set cover = lobd,
    mime_type = mime
    where id = 65;
    
    dbms_lob.freetemporary(lobd);
    COMMIT;
END;

SELECT id, title, length(cover) as FILESIZE 
FROM movies
WHERE id IN (65, 66);

drop table MOVIES;
drop table TEMP_COVERS;
