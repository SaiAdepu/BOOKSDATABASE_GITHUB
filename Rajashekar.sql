﻿USE BOOKSDATABASE
SELECT A.*,B.*,C.* FROM BOOKSTABLE B,AUTHORSTABLE A,CUSTOMERSTABLE C

SELECT *FROM BOOKSTABLE WHERE EXISTS(SELECT ANAME,CNAME FROM AUTHORSTABLE,CUSTOMERSTABLE WHERE 
AUTHORSTABLE.BID=BOOKSTABLE.BID OR CUSTOMERSTABLE.BID=BOOKSTABLE.BID)


--2)
SELECT * FROM BOOKSTABLE FULL JOIN AUTHORSTABLE ON BOOKSTABLE.BID=AUTHORSTABLE.BID FULL JOIN CUSTOMERSTABLE ON BOOKSTABLE.BID=CUSTOMERSTABLE.BID

--7)

 SELECT ANAME,CNAME,COUNT(ANAME),COUNT(CNAME) FROM AUTHORSTABLE,CUSTOMERSTABLE,BOOKSTABLE 
 WHERE AUTHORSTABLE.BID=BOOKSTABLE.BID AND 
 CUSTOMERSTABLE.BID=BOOKSTABLE.BID GROUP BY ANAME,CNAME WITH ROLLUP

 SELECT COUNT(A.ANAME),COUNT(C.CNAME) FROM AUTHORSTABLE A ,CUSTOMERSTABLE C  WHERE A.BID=C.BID   
 
 --3)
 SELECT *FROM BOOKSTABLE WHERE PUBLISHDATE BETWEEN '2019-12-01' AND '2020-04-04'

 --4)
 SELECT *FROM BOOKSTABLE WHERE EXISTS (SELECT 3 FROM CUSTOMERSTABLE WHERE BOOKSTABLE.BID=CUSTOMERSTABLE.BID)

 --5)
 SELECT *FROM BOOKSTABLE WHERE PRICE=(SELECT MAX(PRICE) FROM BOOKSTABLE)

--6)
SELECT *FROM CUSTOMERSTABLE WHERE NOT EXISTS(SELECT *FROM BOOKSTABLE WHERE CUSTOMERSTABLE.BID=BOOKSTABLE.BID)

--8)
CREATE FUNCTION F8(@BID INT)
RETURNS VARCHAR(20)
AS
BEGIN
DECLARE @BN VARCHAR(20)
SELECT @BN=BNAME FROM BOOKSTABLE WHERE BID=@BID
RETURN @BN
END
    SELECT DBO.F8(1)


--9) 
   CREATE PROC BOOKP(@BNO INT,@BNA VARCHAR(20),@PR SMALLINT,@PBD DATETIME)
   AS
   BEGIN
   SET NOCOUNT ON
   DECLARE @B INT
   SELECT @B=COUNT(*) FROM BOOKSTABLE WHERE BID=@BNO
   IF @B IS NULL
   PRINT 'NULL VALUES CANT INSERT'
   ELSE
   IF @B>0
   PRINT 'BOOK ALREADY EXISTS'
   ELSE
   IF @PR<100
   PRINT 'PRICE IS NOT VALID'
   ELSE
   BEGIN 
     BEGIN TRAN
	 INSERT INTO BOOKSTABLE(BID,BNAME,PRICE,PUBLISHDATE)VALUES(@BNO,@BNA,@PR,@PBD)
	 PRINT 'RECORD INSERTED SUCCESSFULLY'
	 COMMIT
	 END
	 END
	   EXEC BOOKP 3,'DS',500,'2019-03-01'
	   EXEC BOOKP 4,'.NET',800,'2020-04-01'

 

