-- 서브쿼리
-- 하위 질의 / 부속 질의
-- 하나의 sql문 안에 다른 sql문이 중첩
-- 하위 질의 수행 후 반환 릴레이션에 대해 다른 질의 릴레이션으로 포함시킴
-- 다른 테이블에서 가져온 데이터로 현재 테이블에 있는 정보 찾거나 가공할 때 사용

-- 조인 vs 서브쿼리
-- 1. 조인은 : 여러 데이터를 모두 합쳐서 연산
--              : BOOK JOIN PUBLISHER -> 15 * 3 => 54행 반환 후 조건에 맞는 튜플 검색
--              : 카티전 곱 연산 + SELECT 연산

-- 2. 서브쿼리 : 필요한 데이터만 찾아서 제공
--                   경우에 따라 조인보다 성능이 더 좋을 수도 있지만 대용량 데이터에서 서브쿼리 수행 성능이 나쁠 수도 있음

-- 구성 : 메인쿼리 (서브쿼리) -> 서브쿼리 먼저 진행 후 메인쿼리 진행

-- 메시(CLIENT) 고객이 주문한 도서의 총 수량(BOOKSALE) -> BOOKSALE에는 CLIENTNO만 있음
--메인 쿼리
SELECT SUM(BSQTY) 
FROM BOOKSALE 
WHERE CLIENTNO=( --서브쿼리
                            SELECT CLIENTNO
                            FROM CLIENT
                            WHERE CLIENTNAME='메시'
                            );

-- 서브쿼리 WHERE 절에서 사용할 경우
-- 서브쿼리 질의 결과값이 단일행인 경우 : 단일행 서브쿼리 (= 연산자 사용해서 조건 확인 )
-- 비교 연산자 사용 : > < >= <= = !=


-- 서브쿼리 질의 결과값이 다중행인 경우 : 다중해 서브쿼리 (IN, ANY, ALL, EXISTS 연산자 사용)
-- IN, NOT IN (집합에 값이 있는지 / 없는지)
-- EXITS, NOT EXISTS ( 존재의 의미)
-- ALL(모두), ANY(최소 하나라도) : 한정

-- 고객 호날두의 주문수량 및 주문 날짜 조회
-- 1. CLIENT 테이블에서 '호날두'의 CLIENTNO를 찾아서
-- 2. BOOKSALE 테이블에서 1에서 찾은 CLIENTNO에 해당되는 주문의 주문일/ 주문 수량 조회
SELECT BSDATE, BSQTY
FROM BOOKSALE
WHERE CLIENTNO = ( --단일행 반환
                                SELECT CLIENTNO
                                FROM CLIENT
                                WHERE CLIENTNAME='호날두');
                                
--고객 호날두가 주문한 총 주문수량
SELECT SUM(BSQTY) AS 총주문수량
FROM BOOKSALE
WHERE CLIENTNO = ( --단일행 반환
                                SELECT CLIENTNO
                                FROM CLIENT
                                WHERE CLIENTNAME='호날두');
                                
--가장비싼 도서의 도서명과 가격 출력
SELECT BOOKNAME, BOOKPRICE
FROM BOOK
WHERE BOOKPRICE = (
                                 SELECT MAX(BOOKPRICE)
                                 FROM BOOK
                                 );

--서점 도서의 평균가격을 초과하는 도서의 이름과 도서 가격을 조회
SELECT BOOKNAME, BOOKPRICE
FROM BOOK
WHERE BOOKPRICE > (
                                    SELECT AVG(BOOKPRICE)
                                    FROM BOOK
                                    );


--------------------------------------------------------------------------------------------------------------
--도서를 구매한 적이 있는 고객의 고객명과 지역을 조회
-- 서브쿼리에서 다중행이 반환되는 예제
SELECT CLIENTNAME, CLIENTADDRESS
FROM CLIENT 
WHERE CLIENTNO = (
                                SELECT CLIENTNO
                                FROM BOOKSALE           
                                ); --ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.
-- 비교연산자는 한개의 값만 비교할 수 있음
-- 주문한 고객의 고객번호는 여러 값이 반환이 됨(여러 행이 반환) -> 비교연산자 사용 불가

--SELECT CLIENTNAME, CLIENTADDRESS
--FROM CLIENT 
--WHERE CLIENTNO = '3' OR CLIENTNO = '7' 

--SELECT CLIENTNAME, CLIENTADDRESS
--FROM CLIENT 
--WHERE CLIENTNO IN ('3', '7', '2',...)

SELECT CLIENTNAME, CLIENTADDRESS
FROM CLIENT 
WHERE CLIENTNO IN (
                                SELECT CLIENTNO
                                FROM BOOKSALE           
                                );