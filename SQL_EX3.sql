--연습문제1---


--1.호날두(고객명)가 주문한 도서의 총 구매량 출력
SELECT SUM(BSQTY)
FROM BOOKSALE
WHERE CLIENTNO IN (SELECT CLIENTNO
                                     FROM CLIENT
                                     WHERE CLIENTNAME = '호날두');

--2.‘정보출판사’에서 출간한 도서를 구매한 적이 있는 고객명 출력

--JOIN 사용
SELECT CLIENTNAME
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
    INNER JOIN BOOK B  ON BS.BOOKNO = B.BOOKNO
    INNER JOIN PUBLISHER P ON P.PUBNO = B.PUBNO
WHERE P.PUBNAME = '정보출판사';

--서브쿼리 사용
SELECT CLIENTNAME
FROM CLIENT
WHERE CLIENTNO IN ( SELECT CLIENTNO
                                    FROM BOOKSALE
                                    WHERE BOOKNO IN ( SELECT BOOKNO
                                                                    FROM BOOK
                                                                    WHERE PUBNO IN (SELECT PUBNO
                                                                                                    FROM PUBLISHER
                                                                                                    WHERE PUBNAME = '정보출판사')));

--3.베컴이 주문한 도서의 최고 주문수량 보다 더 많은 도서를 구매한 고객명 출력
SELECT C.CLIENTNAME
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
WHERE BS.BSQTY > 
                            (SELECT MAX(BSQTY)
                            FROM BOOKSALE
                            WHERE CLIENTNO IN ( SELECT CLIENTNO
                                                            FROM CLIENT
                                                            WHERE CLIENTNAME = '베컴'  ));

--서브쿼리에서 JOIN 사용
SELECT C.CLIENTNAME
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
WHERE BS.BSQTY > 
                            (SELECT MAX(BS2.BSQTY)
                            FROM BOOKSALE BS2
                                 JOIN CLIENT C2 ON C2.CLIENTNO = BS2.CLIENTNO
                            WHERE C2.CLIENTNAME = '베컴');

--4.천안에 거주하는 고객에게 판매한 도서의 총 판매량 출력
SELECT SUM(BSQTY)
FROM BOOKSALE
WHERE CLIENTNO IN ( SELECT CLIENTNO
                                    FROM CLIENT
                                    WHERE CLIENTADDRESS = '천안');
                                    
-----------------------------------------------------------------------------------
--연습문제2-- 함수

--저자 중 성이 '손'인 모든 저자 출력
SELECT BOOKAUTHOR
FROM BOOK
WHERE SUBSTR(BOOKAUTHOR,1,1) = '손';

--저자 중에서 같은 성을 가진 사람이 몇 명이나 되는지 알아보기 위해 성별로 그룹지어 인숸수 출력
SELECT SUBSTR(BOOKAUTHOR, 1, 1) AS 성, COUNT(*) AS 인원수
FROM BOOK
GROUP BY SUBSTR(BOOKAUTHOR, 1, 1);






--테이블 생성 및 CUBE ROLLUP GROUPING SETS 설명
CREATE TABLE SALES (
PRDNAME VARCHAR2(20),
SALESDATE VARCHAR2(10),
PRDCOMPANY VARCHAR2(10),
SALESAMOUNT NUMBER(8));

INSERT INTO SALES VALUES ('노트북', '2021.01', '삼성', 10000);
INSERT INTO SALES VALUES ('노트북', '2021.03', '삼성', 20000);
INSERT INTO SALES VALUES ('냉장고', '2021.01', '삼성', 12000);
INSERT INTO SALES VALUES ('냉장고', '2021.03', '삼성', 20000);
INSERT INTO SALES VALUES ('프린터', '2021.01', '삼성', 3000);
INSERT INTO SALES VALUES ('프린터', '2021.03', '삼성', 1000);

SELECT * FROM SALES;        

-- CUBE 함수
SELECT PRDNAME, PRDCOMPANY, SALESDATE, SUM(SALESAMOUNT) AS 총판매액
FROM SALES
GROUP BY CUBE(PRDNAME, PRDCOMPANY, SALESDATE)
ORDER BY PRDNAME;
-- 모든 경우의 수의 총 판매액 소계,총계를 나타내고 PRDNAME 오름차순 정렬

-- ROLLUP 함수
SELECT PRDNAME, PRDCOMPANY, SALESDATE, SUM(SALESAMOUNT) AS 총판매액
FROM SALES
GROUP BY ROLLUP(PRDNAME, PRDCOMPANY, SALESDATE) 
ORDER BY PRDNAME;
-- PRDNAME → PRDCOMPANY → SALESDATE 지정한 컬럼을 순서대로 소계와 총계 보여줌 (모든 경우의 수 아님)

-- GROUPING SETS : 항목별 소계만 출력
SELECT PRDNAME,  SUM(SALESAMOUNT) AS 총판매액
FROM SALES
GROUP BY GROUPING SETS(PRDNAME );
--  PRDNAME의 각 총계만 보여줌 



--주문일에 7일을 더한 날을 배송일로 계산하여 출력
SELECT BOOKNO AS 주문번호, BSDATE AS 주문일 ,BSDATE +7 AS 배송일 FROM BOOKSALE; 

-- 도서 테이블에서 도서명과 출판연도 출력
-- EXTRACT() 함수 사용
SELECT BOOKNAME 도서명,  EXTRACT(YEAR FROM BOOKDATE) 출판연도
FROM BOOK;




