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

--4)
select BOOKSTABLE.BID,BOOKSTABLE.bname,BOOKSTABLE.PRICE,BOOKSTABLE.PUBLISHDATE from BOOKSTABLE right join CUSTOMERSTABLE on BOOKSTABLE.bid=CUSTOMERSTABLE.BID group by BOOKSTABLE.BID,BOOKSTABLE.BNAME,BOOKSTABLE.PRICE,BOOKSTABLE.PUBLISHDATE having count(CUSTOMERSTABLE.bid)=3

--5)
select * from bookstable where price=(select max(price) from BOOKSTABLE)

--6)
SELECT *FROM CUSTOMERSTB WHERE NOT EXISTS(SELECT *FROM BOOKR WHERE CUSTOMERSTB.BID=BOOKR.BID)

7)
 SELECT ANAME,CNAME,COUNT(ANAME) AS ANAMECOUNT,COUNT(CNAME) AS BNAMECOUNT FROM AUTHORSTABLE,CUSTOMERSTABLE,BOOKSTABLE 
 WHERE AUTHORSTABLE.BID=BOOKSTABLE.BID AND 
 CUSTOMERSTABLE.BID=BOOKSTABLE.BID GROUP BY ANAME,CNAME WITH ROLLUP

--8)
create function fun(@bid int)
returns varchar(10)
as begin 
declare @bn varchar(10)
select @bn=bname from BOOKSTABLE where BID=@bid
return @bn
end
select dbo.fun(1)


--9)

CREATE PROC BOOKstab(@BNO INT,@BNA VARCHAR(20),@PR SMALLINT,@PBD DATETIME)
   AS
   BEGIN
   SET NOCOUNT ON
	 INSERT INTO BOOKSTABLE(BID,BNAME,PRICE,PUBLISHDATE)VALUES(@BNO,@BNA,@PR,@PBD)
	END


EXEC BOOKstab 6,'.NET',800,'2020-04-01'


--10)
create trigger trg
on bookstable
for insert,delete
as begin
if datename(dw,getdate()) not in('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY')
BEGIN 
ROLLBACK
RAISERROR('INVALID INSERTION',1,1)
END
END



--11)
CREATE PROC addcolm(@TN VARCHAR(20),@COLNAME VARCHAR(20),@DATATYPE VARCHAR(20))
AS
BEGIN
EXEC('ALTER TABLE ' + @TN +' ADD'+' ' + @COLNAME + ' '+@DATATYPE)
END

EXEC DYQ 'CUSTOMERSTABLE','GENDER','VARCHAR(12)'


--12)
DECLARE C1 CURSOR FOR SELECT *FROM BOOKSTABLE,CUSTOMERSTABLE WHERE BOOKSTABLE.BID=CUSTOMERSTABLE.BID
  DECLARE @BID INT,@BNA VARCHAR(20),@P INT,@PD DATETIME,@CID INT,@CNA VARCHAR(20),@BI INT
  OPEN C1
  FETCH NEXT FROM C1 INTO @BID,@BNA,@P,@PD,@CID,@CNA,@BI
  WHILE @@FETCH_STATUS=0
  BEGIN
  PRINT CAST(@BID AS VARCHAR)+' '+@BNA+'  '+CAST(@P AS VARCHAR)+'   '+CAST(@PD AS VARCHAR)+' '+CAST(@CID AS VARCHAR)+'   '+@CNA+' '+CAST(@BI AS VARCHAR)
  FETCH NEXT FROM C1 INTO @BID,@BNA,@P,@PD,@CID,@CNA,@BI
  END
  CLOSE C1
  DEALLOCATE C1