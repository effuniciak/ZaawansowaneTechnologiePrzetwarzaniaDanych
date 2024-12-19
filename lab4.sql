--A
CREATE TABLE FIGURY(
    ID NUMBER(1) PRIMARY KEY,
    KSZTALT MDSYS.SDO_GEOMETRY
);

--B
INSERT INTO figury VALUES (
 1, SDO_GEOMETRY(2007, NULL, NULL,
                 SDO_ELEM_INFO_ARRAY(1, 1003, 4),
                 SDO_ORDINATE_ARRAY(5,7, 3,5, 5,3))
);

INSERT INTO figury 
VALUES (2, SDO_GEOMETRY(2007, NULL, NULL,
                 SDO_ELEM_INFO_ARRAY(1, 1003, 1),
                 SDO_ORDINATE_ARRAY(1,1, 5,1, 5,5, 1,5, 1,1))
);

INSERT INTO figury VALUES(
 3, SDO_GEOMETRY(2002, NULL, NULL,
                 SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1, 5,2,2),
                 SDO_ORDINATE_ARRAY(3,2, 6,2, 7,3, 8,2, 7,1))
);

SELECT * FROM figury;

--C
INSERT INTO FIGURY (ID, KSZTALT)
VALUES (4, SDO_GEOMETRY(2007, null, null,
                        SDO_ELEM_INFO_ARRAY(1, 1003, 4),
                        SDO_ORDINATE_ARRAY(5,7, 5,8, 5,9))
);

SELECT * FROM figury;

--D
SELECT id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.005) from FIGURY;

--E
DELETE FROM figury WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.005) != 'TRUE';

--F
COMMIT;
