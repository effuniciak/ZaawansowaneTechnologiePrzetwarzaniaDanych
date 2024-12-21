--Zad 1 
-- A
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;

-- B
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;
	
-- C
CREATE TABLE MYST_MAJOR_CITIES (
    FIPS_CNTRY VARCHAR2(2),
    CITY_NAME VARCHAR2(40),
    STGEOM ST_POINT
);

-- D
SELECT * FROM MAJOR_CITIES WHERE ROWNUM <= 3;

INSERT INTO MYST_MAJOR_CITIES
SELECT
    FIPS_CNTRY,
    CITY_NAME,
    ST_POINT(GEOM) STGEOM
FROM MAJOR_CITIES;

SELECT * FROM MYST_MAJOR_CITIES WHERE ROWNUM <= 3;


-- Zad 2
-- A
INSERT INTO MYST_MAJOR_CITIES VALUES (
    'PL',
    'SZCZYRK',
    TREAT(ST_POINT.FROM_WKT('POINT (19.036107 49.718655)') AS ST_POINT)
);

SELECT * FROM MYST_MAJOR_CITIES WHERE CITY_NAME = 'SZCZYRK';

-- B
SELECT NAME, TREAT(ST_POINT.FROM_SDO_GEOM(GEOM) AS ST_GEOMETRY).GET_WKT()
FROM RIVERS;

-- C
SELECT SDO_UTIL.TO_GMLGEOMETRY(ST_POINT.GET_SDO_GEOM(STGEOM)) GML
FROM MYST_MAJOR_CITIES 
WHERE CITY_NAME = 'SZCZYRK';

-- Zad 3
-- A
CREATE TABLE MYST_COUNTRY_BOUNDARIES (
    FIPS_CNTRY VARCHAR2(2),
    CNTRY_NAME VARCHAR2(40),
    STGEOM ST_MULTIPOLYGON
);

-- B
INSERT INTO MYST_COUNTRY_BOUNDARIES
SELECT
    FIPS_CNTRY,
    CNTRY_NAME,
    ST_MULTIPOLYGON(GEOM)
FROM COUNTRY_BOUNDARIES;

-- C
SELECT
    B.STGEOM.ST_GEOMETRYTYPE() AS TYP_OBIEKTU,
    COUNT(*) AS ILE
FROM MYST_COUNTRY_BOUNDARIES B
GROUP BY B.STGEOM.ST_GEOMETRYTYPE();

-- D
SELECT B.STGEOM.ST_ISSIMPLE()
FROM MYST_COUNTRY_BOUNDARIES B;

-- Zad 4
-- A
SELECT B.CNTRY_NAME, COUNT(*)
FROM MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
WHERE C.STGEOM.ST_WITHIN(B.STGEOM) = 1
GROUP BY B.CNTRY_NAME;

UPDATE MYST_MAJOR_CITIES B 
SET B.STGEOM = ST_POINT(B.STGEOM.ST_X(), B.STGEOM.ST_Y(), 8307) 
WHERE B.CITY_NAME = 'Szczyrk';

-- B
SELECT A.CNTRY_NAME A_NAME, B.CNTRY_NAME B_NAME
FROM MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
WHERE A.STGEOM.ST_TOUCHES(B.STGEOM) = 1 
AND B.CNTRY_NAME = 'Czech Republic';

-- C
SELECT DISTINCT B.CNTRY_NAME, R.NAME
FROM MYST_COUNTRY_BOUNDARIES B, RIVERS R
WHERE B.STGEOM.ST_CROSSES(ST_LINESTRING(R.GEOM)) = 1
AND B.CNTRY_NAME = 'Czech Republic';

-- D
SELECT ROUND(TREAT(A.STGEOM.ST_UNION(B.STGEOM) AS ST_POLYGON).ST_AREA(), -2) POWIERZCHNIA
FROM MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
WHERE A.CNTRY_NAME = 'Czech Republic' 
AND B.CNTRY_NAME = 'Slovakia';

-- E
SELECT
    B.STGEOM OBIEKT,
    B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)).ST_GEOMETRYTYPE() WEGRY_BEZ
FROM MYST_COUNTRY_BOUNDARIES B, WATER_BODIES W
WHERE  B.CNTRY_NAME = 'Hungary' AND W.NAME = 'Balaton';

-- Zad 5
-- A
EXPLAIN PLAN FOR
SELECT B.CNTRY_NAME A_NAME, COUNT(*)
FROM MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
WHERE SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE'
    AND B.CNTRY_NAME = 'Poland'
GROUP BY B.CNTRY_NAME;

SELECT PLAN_TABLE_OUTPUT 
FROM TABLE(DBMS_XPLAN.DISPLAY);

-- B
INSERT INTO USER_SDO_GEOM_METADATA
SELECT 'MYST_MAJOR_CITIES', 'STGEOM', T.DIMINFO, T.SRID
FROM   ALL_SDO_GEOM_METADATA T
WHERE  T.TABLE_NAME = 'MAJOR_CITIES';

-- C
DROP INDEX MYST_MAJOR_CITIES_IDX;
DROP INDEX MYST_COUNTRY_BOUNDARIES_IDX;

CREATE INDEX MYST_MAJOR_CITIES_IDX
ON MYST_MAJOR_CITIES(STGEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

CREATE INDEX MYST_COUNTRY_BOUNDARIES_IDX
ON MYST_COUNTRY_BOUNDARIES(STGEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

-- D
EXPLAIN PLAN FOR
SELECT B.CNTRY_NAME A_NAME, COUNT(*)
FROM MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
WHERE 
    SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE'
    AND B.CNTRY_NAME = 'Poland'
GROUP BY B.CNTRY_NAME;

SELECT PLAN_TABLE_OUTPUT 
FROM TABLE(DBMS_XPLAN.DISPLAY);