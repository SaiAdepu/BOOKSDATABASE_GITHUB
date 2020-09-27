--DONE BY *SAI KUMAR*
--DATABASE CREATION
CREATE DATABASE BOOKSDATABASE
USE BOOKSDATABASE
-------------------------------------------------------------------------------------------------------------------------------------
--BOOKS TABLE CREATION
CREATE TABLE BOOKSTABLE(BID INT PRIMARY KEY,BNAME VARCHAR(20) NOT NULL,PRICE SMALLMONEY NOT NULL,PUBLISHDATE DATETIME NOT NULL)
SP_HELP BOOKSTABLE

--CUSTOMERS TABLE CREATION
CREATE TABLE CUSTOMERSTABLE(CID INT PRIMARY KEY,CNAME VARCHAR(20) NOT NULL,BID INT FOREIGN KEY REFERENCES BOOKSTABLE(BID))
SP_HELP CUSTOMERSTABLE

--AUTHORS TABLE CREATION
CREATE TABLE AUTHORSTABLE(BID INT FOREIGN KEY REFERENCES BOOKSTABLE(BID),ANAME VARCHAR(20)NOT NULL,AID INT)
SP_HELP AUTHORSTABLE
-- UNIQUE INDEX FOR AUTHOR ID
CREATE UNIQUE INDEX ANO ON AUTHORSTABLE(AID)

-------------------------------------------------------------------------------------------------------------------------------------
--INSERTION OF RECORDS INTO AUTHORS TABLE, CUSTOMERS TABLE AND BOOKS TABLE
BEGIN TRANSACTION

INSERT INTO BOOKSTABLE VALUES(1,'C',120,'1978-02-22'),(2,'JAVA',350,'1995-08-01')
INSERT INTO CUSTOMERSTABLE VALUES(1001,'CITY',1),(1002,'TOWN',2)
INSERT INTO AUTHORSTABLE VALUES(1,'DENNIS RITCHIE',123),(2,'JAMES GOSLING',456)
COMMIT
INSERT INTO BOOKSTABLE VALUES(3,'MATHS',100,'2019-12-29')
INSERT INTO BOOKSTABLE VALUES(4,'ENGLISH',100,'2020-1-29')
SELECT * FROM BOOKSTABLE
INSERT INTO CUSTOMERSTABLE VALUES(2,'KING',1,'MALE')
INSERT INTO CUSTOMERSTABLE VALUES(3,'QUEEN',1,'FEMALE')
INSERT INTO CUSTOMERSTABLE (CID,CNAME,GENDER)VALUES(4,'KNIGHT','FEMALE')

-------------------------------------------------------------------------------------------------------------------------------------
--1)List the Books details which book have At least one author,one customer exists.
SELECT * FROM BOOKSTABLE WHERE
EXISTS 
(SELECT * FROM AUTHORSTABLE WHERE
EXISTS
(SELECT * FROM CUSTOMERSTABLE))

-------------------------------------------------------------------------------------------------------------------------------------
--2)List the all Books,Authors,Customers details.
SELECT A.*,B.*,C.* FROM AUTHORSTABLE A,BOOKSTABLE B,CUSTOMERSTABLE C

-------------------------------------------------------------------------------------------------------------------------------------
--3))To print the books details which books published date between ’01-dec-2019’ to ’04-apr-20’.
SELECT * FROM BOOKSTABLE WHERE PUBLISHDATE BETWEEN '2019-12-01' AND '2020-04-04'

-------------------------------------------------------------------------------------------------------------------------------------
 --4)List the Books details Which book at least 3 or more customers.
 SELECT BNAME,COUNT(CNAME) FROM BOOKSTABLE,CUSTOMERSTABLE WHERE BOOKSTABLE.BID=CUSTOMERSTABLE.BID GROUP BY BNAME HAVING COUNT(CNAME)>=3


 -------------------------------------------------------------------------------------------------------------------------------------
--5)List the Book details which book price is highest.
SELECT MAX(PRICE) AS HIGHEST_BOOK_PRICE FROM BOOKSTABLE

-------------------------------------------------------------------------------------------------------------------------------------
--6)List the Customer details which customer not taken any books.
SELECT *FROM CUSTOMERSTABLE WHERE NOT EXISTS(SELECT *FROM BOOKSTABLE WHERE CUSTOMERSTABLE.BID=BOOKSTABLE.BID)


-------------------------------------------------------------------------------------------------------------------------------------
--7)List the total number of authors,number of customers based on book id.
SELECT COUNT(A.ANAME),COUNT(C.CNAME) FROM AUTHORSTABLE A,CUSTOMERSTABLE C WHERE A.BID=C.BID


-------------------------------------------------------------------------------------------------------------------------------------
--8)To display the book names for given book id using UDF[userdefined function].
CREATE FUNCTION BOOK_NAMES3(@BOOKID INT)
RETURNS VARCHAR(20)
AS
BEGIN
DECLARE @BOOKNAME VARCHAR(40)
SELECT @BOOKNAME=BNAME FROM BOOKSTABLE WHERE BID=@BOOKID
RETURN @BOOKNAME
END

SELECT DBO.BOOK_NAMES3(5) AS BOOK_NAME


-------------------------------------------------------------------------------------------------------------------------------------
--9)To insert record into books table using procedure.
CREATE PROC INSERT_TO_BOOK3(@BOOKSID INT,@BOOKNAME VARCHAR(20),@BOOKPRICE SMALLMONEY)
AS
BEGIN
DECLARE @DATE DATETIME
SET @DATE=GETDATE()
INSERT INTO BOOKSTABLE VALUES(@BOOKSID,@BOOKNAME,@BOOKPRICE,@DATE)
END

		EXEC INSERT_TO_BOOK3 6,'SCIENCE',240

SELECT * FROM BOOKSTABLE


-------------------------------------------------------------------------------------------------------------------------------------
--10)To restrict insertion or deletion only to allow Monday to Saturday on Books table.
CREATE TRIGGER RESTRICT_MONDAY_TO_SATURDAY
ON BOOKSTABLE
FOR INSERT,DELETE
AS
BEGIN
	DECLARE @DAY VARCHAR(20)
	SET @DAY=DATENAME(DW,GETDATE())
	IF(@DAY='SATURDAY' OR @DAY='SUNDAY')
	BEGIN
		ROLLBACK
		PRINT 'CANNOT INSERT OR DELETE ON SATURDAY AND SUNDAY'
	END
END
--EXECUTION
INSERT INTO BOOKSTABLE VALUES(3,'.NET',200,GETDATE())

SP_STORED_PROCEDURES


-------------------------------------------------------------------------------------------------------------------------------------
--11)Using Dynamic query procedure to add ‘Gender’ column in customer table.
CREATE PROC ADD_GENDER_TO_CUSTOMER_TABLE1(@TABLENAME VARCHAR(20))
AS
BEGIN
--EXECUTING THE ALTER QUERY WITH VARIABLE NAME
EXEC ('ALTER TABLE '+ @TABLENAME +' ADD GENDER VARCHAR(20)')
END
--EXECUTION
		EXEC ADD_GENDER_TO_CUSTOMER_TABLE1 CUSTOMERSTABLE


-------------------------------------------------------------------------------------------------------------------------------------
--12)To display All records of Books,Customer details which book id is Common using ‘cursor’
DECLARE BOOKSANDCUSTOMERDETAILS CURSOR FOR SELECT B.BID,B.BNAME,B.PRICE,B.PUBLISHDATE,C.CID,C.CNAME FROM BOOKSTABLE B,CUSTOMERSTABLE C WHERE B.BID=C.BID
--VARIABLE DECLARATION FOR RETRIVING AND STORING DATA INTO THEM
DECLARE @BOOKID INT,@BOOKNAME VARCHAR(20),@BOOKPRICE SMALLMONEY,@PUBLISHDATE DATETIME,@CUSRTOMERID INT,@CUSTOMERNAME VARCHAR(20)
OPEN BOOKSANDCUSTOMERDETAILS
--INITIALIZING THE STARTING POINT OF THE CURSOR
FETCH NEXT FROM BOOKSANDCUSTOMERDETAILS INTO @BOOKID,@BOOKNAME,@BOOKPRICE,@PUBLISHDATE,@CUSRTOMERID,@CUSTOMERNAME
PRINT 'BOOKID'+'	'+'BOOKNAME'+'	'+'PRICE'+'		'+'PUBLISHDATE'+'	'+'CUSRTOMERID'+'	'+'CUSTOMERNAME'
--LOOP WILL BE REPEATED UNTIL CURSOR POINTS TO LAST RECORD
WHILE @@FETCH_STATUS=0
BEGIN
--PRINTING THE CURSOR VALUES
PRINT CAST(@BOOKID AS VARCHAR)+'	'+@BOOKNAME+'	'+CAST(@BOOKPRICE AS VARCHAR)+'		'+CAST(@PUBLISHDATE AS VARCHAR)+'	'+CAST(@CUSRTOMERID AS VARCHAR)+'	'+@CUSTOMERNAME
FETCH NEXT FROM BOOKSANDCUSTOMERDETAILS INTO @BOOKID,@BOOKNAME,@BOOKPRICE,@PUBLISHDATE,@CUSRTOMERID,@CUSTOMERNAME
END
--CLOSING THE CURSOR
CLOSE BOOKSANDCUSTOMERDETAILS
--DEALLOCATING THE CURSOR
DEALLOCATE BOOKSANDCUSTOMERDETAILS
