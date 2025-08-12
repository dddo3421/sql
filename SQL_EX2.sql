-----연습문제 1

--1.도서 테이블에서 가격 순으로 내림차순 정렬하여,  도서명, 저자, 가격 출력 (가격이 같으면 저자 순으로 오름차순 정렬)
SELECT BOOKNAME, BOOKAUTHOR, BOOKPRICE
FROM BOOK
ORDER BY BOOKPRICE DESC, BOOKAUTHOR ASC;

--2.도서 테이블에서 저자에 '길동'이 들어가는 도서의 총 재고 수량 계산하여 출력
SELECT  SUM(BOOKSTOCK) AS 총재고수량
FROM BOOK
WHERE BOOKAUTHOR LIKE '%길동%';

--3.도서 테이블에서 ‘서울 출판사' 도서 중 최고가와 최저가 출력
SELECT MAX(BOOKPRICE) AS 최고가, MIN(BOOKPRICE) AS 최저가
FROM BOOK
WHERE PUBNO = '1';

--4.도서 테이블에서 출판사별로 총 재고수량과 평균 재고 수량 계산하여 출력 (‘총 재고 수량’으로 내림차순 정렬)
--ROUND(대상) ->정수표현(반올림) - ROUND(대상, 소수점 이하 자리수) -> 소수점 이하 자리수를 지정해서 표현
SELECT  PUBNO, SUM(BOOKSTOCK) AS 총재고수량, ROUND(AVG(BOOKSTOCK),1) AS 평균재고수량 
FROM BOOK
GROUP BY PUBNO
ORDER BY 총재고수량 DESC;



--5.도서판매 테이블에서 고객별로 ‘총 주문 수량’과 ‘총 주문 건수’ 출력. 단 주문 건수가 2이상인 고객만 해당
SELECT  CLIENTNO, SUM(BSQTY) AS 총주문수량 ,COUNT(*) AS 총주문건수
FROM BOOKSALE
GROUP BY CLIENTNO
HAVING COUNT(*) >= 2;

-------------------------------------------------------------------------------------------------
--연습문제2-----------


--1.모든 도서에 대하여 도서의 도서번호, 도서명, 출판사명 출력
SELECT BOOKNO, BOOKNAME, PUBNAME
FROM BOOK B
    INNER JOIN PUBLISHER P ON P.PUBNO = B.PUBNO;

SELECT  B.BOOKNO, B.BOOKNAME, P.PUBNAME
FROM BOOK B
    INNER JOIN PUBLISHER P ON P.PUBNO = B.PUBNO;

--2.‘서울 출판사'에서 출간한 도서의 도서명, 저자명, 출판사명 출력 (출판사명 사용)
SELECT B.BOOKNAME, B.BOOKAUTHOR, P.PUBNAME
FROM BOOK B
     INNER JOIN PUBLISHER P ON P.PUBNO = B.PUBNO
     WHERE PUBNAME = '서울 출판사';
     
SELECT B.BOOKNAME, B.BOOKAUTHOR, P.PUBNAME
FROM BOOK B, PUBLISHER P
     WHERE  P.PUBNO = B.PUBNO AND
                    P.PUBNAME = '서울 출판사';
      

--3.＇정보출판사'에서 출간한 도서 중 판매된 도서의 도서명 출력 (중복된 경우 한 번만 출력) (출판사명 사용)
SELECT  UNIQUE B.BOOKNAME
FROM BOOK B
     INNER JOIN PUBLISHER P ON P.PUBNO = B.PUBNO
     INNER JOIN BOOKSALE BS ON BS.BOOKNO = B.BOOKNO
     WHERE P.PUBNAME = '정보출판사';

--4.도서가격이 30,000원 이상인 도서를 주문한 고객의 고객명, 도서명, 도서가격, 주문수량 출력
SELECT  C.CLIENTNAME, B.BOOKNAME, B.BOOKPRICE, BS.BSQTY
FROM BOOKSALE BS
     INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
     INNER JOIN BOOK B ON B.BOOKNO = BS.BOOKNO
     WHERE B.BOOKPRICE >= 30000;

--5.'안드로이드 프로그래밍' 도서를 구매한 고객에 대하여 도서명, 고객명, 성별, 주소 출력 (고객명으로 오름차순 정렬)
SELECT B.BOOKNAME, C.CLIENTNAME, C.CLIENTGENDER, C.CLIENTADDRESS
FROM BOOKSALE BS
     INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
     INNER JOIN BOOK B ON B.BOOKNO = BS.BOOKNO
WHERE B.BOOKNAME = '안드로이드 프로그래밍'
ORDER BY C.CLIENTNAME;

--6.‘도서출판 강남'에서 출간된 도서 중 판매된 도서에 대하여 ‘총 매출액’ 출력
SELECT P.PUBNAME, SUM(BS.BSQTY * B.BOOKPRICE) AS "총 매출액"
FROM BOOK B
    INNER JOIN BOOKSALE BS ON BS.BOOKNO = B.BOOKNO
    INNER JOIN PUBLISHER P ON P.PUBNO = B.PUBNO
WHERE P.PUBNAME = '도서출판 강남'
GROUP BY P.PUBNAME;

--7.‘서울 출판사'에서 출간된 도서에 대하여 판매일, 출판사명, 도서명, 도서가격, 주문수량, 주문액 출력
SELECT  BS.BSDATE,   P.PUBNAME,    B.BOOKNAME,  B.BOOKPRICE,   
                         BS.BSQTY,     (B.BOOKPRICE * BS.BSQTY) AS 주문액
FROM BOOK B
INNER JOIN BOOKSALE BS ON BS.BOOKNO = B.BOOKNO
INNER JOIN PUBLISHER P ON P.PUBNO = B.PUBNO
WHERE P.PUBNAME = '서울 출판사';



--8.판매된 도서에 대하여 도서별로 도서번호, 도서명, 총 주문 수량 출력
SELECT B.BOOKNO, B.BOOKNAME, SUM(BS.BSQTY)
FROM BOOK B
    INNER JOIN BOOKSALE BS ON BS.BOOKNO = B.BOOKNO
GROUP BY B.BOOKNO, B.BOOKNAME;

--9.판매된 도서에 대하여 고객별로 고객명, 총구매액 출력 ( 총구매액이 100,000원 이상인 경우만 해당)
SELECT C.CLIENTNAME, SUM(BS.BSQTY * B.BOOKPRICE) AS 총구매액
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
    INNER JOIN BOOK B ON B.BOOKNO = BS.BOOKNO
GROUP BY C.CLIENTNAME ,C.CLIENTNO
HAVING SUM(BS.BSQTY * B.BOOKPRICE) >= 100000;

--10.판매된 도서 중 ＇도서출판 강남'에서 출간한 도서에 대하여 고객명, 주문일, 도서명, 주문수량, 출판사명 출력 (고객명으로 오름차순 정렬)
SELECT C.CLIENTNAME, BS.BSDATE, B.BOOKNAME, BS.BSQTY, P.PUBNAME
FROM  BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
    INNER JOIN BOOK B  ON BS.BOOKNO = B.BOOKNO
    INNER JOIN PUBLISHER P ON P.PUBNO = B.PUBNO
WHERE P.PUBNAME = '도서출판 강남'
ORDER BY C.CLIENTNAME;

SELECT *
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
    INNER JOIN BOOK B  ON BS.BOOKNO = B.BOOKNO
    INNER JOIN PUBLISHER P ON P.PUBNO = B.PUBNO
----------------------------------------------------------------------------------------------------------------