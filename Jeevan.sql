﻿USE BOOKSDATABASE
SELECT A.*,B.*,C.* FROM BOOKSTABLE B,AUTHORSTABLE A,CUSTOMERSTABLE C
select * from bookstable
INSERT INTO BOOKSTABLE VALUES(3,'SQL',250,'1988-02-22'),(4,'PYTHON',400,'1994-08-01'),(5,'ASP.NET',200,'1990-08-01')
INSERT INTO AUTHORSTABLE VALUES(1,'brian',234),(3,'BEN FORTA',567),(4,'GUDIO VAN',678)
INSERT INTO CUSTOMERSTABLE VALUES(1003,'VILLAGE',1),(1004,'COUNTRY',3),(1005,'STATE',1)

--1)
SELECT *FROM BOOKSTABLE WHERE EXISTS(select BOOKSTABLE.* from AUTHORSTABLE,CUSTOMERSTABLE 
where AUTHORSTABLE.bid=BOOKSTABLE.bid or CUSTOMERSTABLE.bid=BOOKSTABLE.bid)

--2)
SELECT * FROM BOOKSTABLE FULL JOIN AUTHORSTABLE ON BOOKSTABLE.BID=AUTHORSTABLE.BID FULL JOIN CUSTOMERSTABLE ON BOOKSTABLE.BID=CUSTOMERSTABLE.BID

--3)
SELECT *FROM BOOKSTABLE WHERE PUBLISHDATE BETWEEN '2019-12-01' AND '2020-04-04'
--5)
select * from bookstable where price=(select max(price) from BOOKSTABLE)

--6)
SELECT *FROM CUSTOMERSTB WHERE NOT EXISTS(SELECT *FROM BOOKR WHERE CUSTOMERSTB.BID=BOOKR.BID)
