------------------------------------------------------------------------
--연습 문제

--INSERT 연습문제

--속성과 값을 모두 나열하는 방법
INSERT INTO STUDENT (STDNO, STDNAME, STDYEAR, DPTNO, STDBIRTHDAY)
VALUES('2016005','홍길동',4,'1','1997-01-01')


--값만 나열하는 방법

INSERT into STUDENT
VALUES('2015002','성춘향',3,'3','1996-12-10');

--전체를 한번에 저장하는 방법
INSERT all
    INTO STUDENT VALUES ('2014004','이몽룡',2,'2','1996-03-03')
    INTO STUDENT VALUES ('2016002','변학도',4,'1','1995-05-07')
    INTO STUDENT VALUES ('2015003','손흥민',3,'2','1997-11-11')
SELECT *
FROM DUAL;



--------------------------------------------------------------
--연습문제2

--BOOK 테이블에 행 삽입
--BOOK의 5번째 열은 PUBLISHER에서 PUBNO 문자열 외래키 참조
--기존 BOOK 테이블이 연습문제와 달라서 수정
INSERT into BOOK
VALUES('8','JAVA 프로그래밍',30000,'2021-03-10','1');
INSERT into BOOK
VALUES('9','파이썬 데이터 과학',24000,'2018-02-5','2');

UPDATE BOOK SET BOOKPRICE=22000 WHERE BOOKNAME='데이터베이스';

DELETE FROM BOOK
WHERE BOOKDATE BETWEEN TO_DATE('2021-01-01')
                   AND TO_DATE('2021-12-31');
               
               
------------------------------------------------------------------                   
--종합 연습문제

--고객테이블 생성
--DROP TABLE CUSTOMER;
CREATE TABLE CUSTOMER (
    CUSTNO NUMBER(4) NOT NULL PRIMARY KEY,
    CUSTNAME VARCHAR2(20) NOT NULL,
    CUSTPHONE VARCHAR2(20),
    CUSTADDRESS VARCHAR2(30)
    --CUSTGENDER VARCHAR2(4),
    --CUSTAGE  NUMBER(3)
);

--주문 테이블 생성
CREATE TABLE ORDERPRODUCT (
    ORDERNO NUMBER(3) NOT NULL PRIMARY KEY,
    ORDERDATE VARCHAR2(10), 
    ORDERQTY NUMBER(2), 
    CUSTNO NUMBER(4) NOT NULL, 
    PRDNO VARCHAR2(3) NOT NULL,
    CONSTRAINT FK_ORDER_PUBLISHER FOREIGN KEY (CUSTNO)
    REFERENCES CUSTOMER (CUSTNO),
    CONSTRAINT FK_ORDER_PUBLISHER2 FOREIGN KEY (PRDNO)
    REFERENCES PRODUCT (PRDNO)
);

--고객 테이블 전화번호 열 NOT NULL 추가
ALTER TABLE CUSTOMER
MODIFY CUSTADDRESS VARCHAR2(30) NOT NULL;

--고객 테이블에 성별, 나이 열 추가
ALTER TABLE CUSTOMER
ADD CUSTGENDER VARCHAR2(4);

ALTER TABLE CUSTOMER
ADD CUSTAGE  NUMBER(3);

--고객, 주문 테이블에 데이터 삽입(3개씩)
INSERT all
    INTO CUSTOMER VALUES (1001,'홍길동','010-1111-1111','강원도 평창','남',22)
    INTO CUSTOMER VALUES (1002,'이몽룡','010-2222-2222','서울 종로구','남',23)
    INTO CUSTOMER VALUES (1003,'성춘향','010-3333-3333','서울시 강남구','여',22)
SELECT *
FROM DUAL;

INSERT all
    INTO ORDERPRODUCT VALUES (1,'2018-01-10',3,1001,'3')
    INTO ORDERPRODUCT VALUES (2,'2018-03-03',1,1001,'7')
    INTO ORDERPRODUCT VALUES (3,'2018-04-5',3,1002,'2')
SELECT *
FROM DUAL;

--주문 테이블에서 상품번호가 2인 행의 주문수량을 7으로 수정
UPDATE ORDERPRODUCT SET ORDERQTY=7 WHERE PRDNO='2';


----------------------------------------------------------------------
--SELECT 연습문제


//1.고객 테이블에서 고객명, 생년월일, 성별 출력
--select * from 테이블명 where 조건절
SELECT CLIENTNAME, CLIENTBIRTH, CLIENTGENDER 
FROM CLIENT;

//2.고객 테이블에서 주소만 검색하여 출력 (중복되는 튜플은 한번만 출력)
SELECT DISTINCT CLIENTADDRESS  FROM CLIENT

//3.고객 테이블에서 취미가 '축구'이거나 '등산'인 고객의 고객명, 취미 출력
SELECT CLIENTNAME, CLIENTHOBBY  FROM CLIENT
WHERE CLIENTHOBBY = '축구' OR CLIENTHOBBY = '등산';

//4.도서 테이블에서 저자의 두 번째 위치에 '길'이 들어 있는 저자명 출력 (중복되는 튜플은 한번만 출력)
SELECT DISTINCT BOOKAUTHOR FROM BOOK
WHERE BOOKAUTHOR LIKE '_길%'; -- 길 앞에 한 글자는 반드시 존재해야 함

//5.도서 테이블에서 발행일이 2018년인 도서의 도서명, 저자, 발행일 출력
SELECT BOOKNAME, BOOKAUTHOR, BOOKDATE FROM BOOK
WHERE BOOKDATE LIKE '2018%';

//6.도서판매 테이블에서 고객번호1, 2를 제외한 모든 튜플 출력
SELECT * FROM BOOKSALE
WHERE CLIENTNO NOT IN ('1', '2');

//7.고객 테이블에서 취미가 NULL이 아니면서 주소가 '서울'인 고객의 고객명, 주소, 취미 출력
SELECT CLIENTNAME, CLIENTADDRESS, CLIENTHOBBY FROM CLIENT
WHERE  CLIENTHOBBY IS NOT NULL AND CLIENTADDRESS like '%서울%';

//8.도서 테이블에서 가격이 25000 이상이면서 저자 이름에 '길동'이 들어가는 도서의 도서명, 저자, 가격, 재고 출력
SELECT BOOKNAME, BOOKAUTHOR, BOOKPRICE, BOOKSTOCK FROM BOOK
WHERE BOOKPRICE >= 25000 AND BOOKAUTHOR LIKE '%길동%';

//9.도서 테이블에서 가격이 20,000 ~25,000원인 모든 튜플 출력
SELECT * FROM BOOK
WHERE BOOKPRICE BETWEEN 20000 AND 25000; -- between은 이상과 이하 표현 

//10.도서 테이블에서 저자명에 '길동'이 들어 있지 않는 도서의 도서명, 저자 출력
SELECT BOOKNAME, BOOKAUTHOR FROM BOOK
WHERE BOOKAUTHOR NOT LIKE '%길동%'
--ORDER BY BOOKAUTHOR DESC;

--ORDER BY 절은 정렬시 기준필드의 값이 동일한 경우 2번째 기준을 추가할 수 있음
--도서 테이블에서 저자명에 '길동'이 들어 있지 않는 도서의 도서명, 저자 출력
--도서가격 기준으로 오름차순 정렬, 가
SELECT BOOKNAME, BOOKAUTHOR FROM BOOK
WHERE BOOKAUTHOR NOT LIKE '%길동%'
ORDER  BY BOOKPRICE ASC , BOOKAUTHOR DESC;



