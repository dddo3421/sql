--조인
--여러 개의 테이블을 결합하여 조건에 맞는 행 검색
--EX. 홍길동학생의 소속과명
--조인종류
-- INNER JOIN / OUTER JOIN
--1. INNER JOIN : 두 테이블에 공통되는 열이 있을 때
--2. OUTER JOIN : 두 테이블에 공통되는 열이 없을 때도 표현

--고객 / 주문 테이블
--상품을 주문한 고객을 조회 : INNER JOIN
--상품을 주문한 고객과 주문하지 않은 고객도 주문내역과 같이 조회 : OUTER JOIN

--형식
/* SELECT 열리스트
    FROM 테이블명 1
        INNER JOIN 테이블명 2
        ON 조인조건(기본키 = 외래키); */

/* SELECT 열리스트
FROM 테이블명 1, 테이블명 2
WHERE 조인조건 (기본키 = 외래키); */

/* SELECT 테이블명.속성명, 테이블명.속성명
FROM 테이블명 1, 테이블명 2
WHERE 조인조건 (기본키 = 외래키); */

  
        
--주문한 적이 있는 고객의 번호 이름
--고객테이블에서 고객 번호와 이름이 있지만 주문여부는 확인 불가능
--주문테이블에서는 주문여부 확인이 가능하지만 고객번호외 고객이름은 확인 불가능

--주문한 적이 있는 고객의 모든 정보
--가장 많이 사용되는 방법
SELECT CLIENTNAME.CLIENTNO, CLIENTNAME
FROM CLIENT
            INNER JOIN BOOKSALE
            ON CLIENT.CLIENTNO = BOOKSALE.CLIENTNO;

SELECT CLIENTNAME
FROM CLIENT
            INNER JOIN BOOKSALE
            ON CLIENT.CLIENTNO = BOOKSALE.CLIENTNO;
            
-- 결과는 CLIENTNO를 제외하고는 테이블명 포함시키지 않아도 동일함
-- 오라클 서버 입장에서는 속성의 소속을 명확히 하게 됨으로 위치를 정확히 알려주므로 성능이 향상
SELECT CLIENT.CLIENTNO, CLIENT.CLIENTNAME, BOOKSALE.BSQTY
FROM CLIENT, BOOKSALE --결합하고자 하는 테이블 나열
WHERE CLIENT.CLIENTNO = BOOKSALE.CLIENTNO;

--테이블에 별칭 사용
SELECT A.CLIENTNO, A.CLIENTNAME, B.BSQTY
FROM CLIENT A, BOOKSALE B
WHERE A.CLIENTNO = B.CLIENTNO

--주문한 적이 있는 고객의 모든 정보 - JOIN(INNER JOIN의 약어)
SELECT CLIENT.CLIENTNO, CLIENTNAME
FROM CLIENT
JOIN BOOKSALE
ON CLIENT.CLIENTNO = BOOKSALE.CLIENTNO;

--주문한 적이 있는 고객의 정보
--중복을 제거해서 조회

SELECT UNIQUE C.CLIENTNO, C.CLIENTNAME
    FROM CLIENT C
    INNER JOIN BOOKSALE BS
    ON C.CLIENTNO = BS.CLIENTNO
   ORDER BY C.CLIENTNO;
   
--소장 도서에 대한  도서명과 출판사명
SELECT BOOKNAME, PUBNAME
FROM BOOK B
    INNER JOIN PUBLISHER P
    ON B.PUBNO = P.PUBNO;
    
 ---------------------------------------------------
 --주문된 도서의 도서번호와 고객번호
 SELECT BOOKNO, CLIENTNO
 FROM BOOKSALE;
 
--주문(BOOKSALE)된 도서의 도서명(BOOK)과 고객명(CLIENT)을 확인
--3개 테이블 조인 진행: SELECT ~ FROM ~ INNER JOIN ~ ON ~ INNER JOIN ~ ON ~
SELECT CLIENTNAME , BOOKNAME
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
    INNER JOIN BOOK B  ON B.BOOKNO = BS.BOOKNO;
 
 --도서를 주문한 고객의 고객 정보, 주문정보, 도서정보 조회
SELECT C.CLIENTNAME , B.BOOKNAME, BS.BSDATE, BS.BSQTY
--SELECT *
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
    INNER JOIN BOOK B  ON B.BOOKNO = BS.BOOKNO;
    
--고객별로 총 주문 수량 계산
--주문 수량기준 내림차순 정렬

SELECT CLIENTNO, SUM(BSQTY) AS "총 주문수량"
FROM BOOKSALE
GROUP BY CLIENTNO
ORDER BY "총 주문수량" DESC;

--고객별로 총 주문수량 계산
--주문수량 기준 내림차순 정렬
--고객명을 표현할 것

--고객별로 그룹 생성 시 동일한 이름의 서로 다른 고객이 있을 수 있으므로 고객명이 필요하다고 해서 고객 이름만으로 그룹을 진행하면 안됨
SELECT C.CLIENTNO, C.CLIENTNAME, SUM(BS.BSQTY) AS "총 주문수량"
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
GROUP BY C.CLIENTNO, C.CLIENTNAME
ORDER BY "총 주문수량" DESC;

--GROUP BY 다음에 없는 열 이름이 SELECT 절에 올 수 없음

--쿼리를 통한 연산 진행 - 가공필드 생성 가능
--주문된 도서의 주문일, 고객명, 도서명, 도서가격, 주문수량, 주문액(계산 가능 : 주문 수량 * 단가)을 조회
SELECT  BS.BSDATE, C.CLIENTNAME, B.BOOKNAME, B.BOOKPRICE, BS.BSQTY,
                BS.BSQTY * B.BOOKPRICE  AS "주문액"
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
    INNER JOIN BOOK B ON B.BOOKNO = BS.BOOKNO
ORDER BY "주문액" DESC;

--조인된 결과를 활용한 가공필드 생성
SELECT  BS.BSDATE, C.CLIENTNAME, B.BOOKNAME, B.BOOKPRICE, BS.BSQTY,
                BS.BSQTY * B.BOOKPRICE  AS "주문액"
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
    INNER JOIN BOOK B ON B.BOOKNO = BS.BOOKNO
WHERE    (BS.BSQTY * B.BOOKPRICE) >=100000 -- 별칭 사용 불가능(별칭 구성 전에 진행됨)
ORDER BY "주문액" DESC; -- 별칭 사용 가능 (가장 마지막 단계여서 별칭 사용 가능)

-- 2018년 부터 현재까지 판매된 도서의 주문일, 고객명, 도서명, 도서가격, 주문수량, 주문액 계산해서 조회
SELECT  BS.BSDATE, C.CLIENTNAME, B.BOOKNAME, B.BOOKPRICE, BS.BSQTY,
                BS.BSQTY * B.BOOKPRICE  AS "주문액"
FROM BOOKSALE BS
    INNER JOIN CLIENT C ON C.CLIENTNO = BS.CLIENTNO
    INNER JOIN BOOK B ON B.BOOKNO = BS.BOOKNO
WHERE  BS.BSDATE >= '2018-01-01'
ORDER BY BS.BSDATE;


----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENT 테이블과 BOOKSALE 테이블 활용 OUTER JOIN 예시
-- 왼쪽(LEFT) 기준
-- 고객의 주문정보 확인(단, 주문한 적이 없는 고객에 대한 정보 조회)
SELECT *
FROM CLIENT C
    LEFT OUTER JOIN BOOKSALE BS 
    ON C.CLIENTNO = BS.CLIENTNO
ORDER BY C.CLIENTNO;

--조회결과 CLIENT_1 컬럼에 NULL이라고 표현되는 튜플은 주문한 적이 없는 고객에 대한 정보를 주문정보 없이 표현

--오른쪽(RIGHT) 기준 - INNER JOIN과 동일한 결과
--서점의 고객 중 주문하지 않은 고객은 존재 가능, 단 주문한 고객 중에 서점의 회원이 아닌 고객은 없음
SELECT *
FROM CLIENT C
    RIGHT OUTER JOIN BOOKSALE BS 
    ON C.CLIENTNO = BS.CLIENTNO
ORDER BY C.CLIENTNO;

-- 완전(FULL) OUTER JOIN
--CLIENT가 아니면 주문 불가능 제약조건이 있음 : LEFT OUTER JOIN과 동일
SELECT *
FROM CLIENT C
    FULL OUTER JOIN BOOKSALE BS 
    ON C.CLIENTNO = BS.CLIENTNO
ORDER BY C.CLIENTNO;

-- 오라클 OUTER 조인
-- (+)연산자로 조인시킬 값이 없는 조인측에 위치
-- 고객의 주문정보 확인하되 주문이 없는 고객의 정보 확인
SELECT * 
FROM CLIENT C, BOOKSALE BS
WHERE C.CLIENTNO = BS.CLIENTNO (+)
ORDER BY C.CLIENTNO ;

-- 주문한 고객만 출력됨
SELECT * 
FROM CLIENT C, BOOKSALE BS
WHERE C.CLIENTNO(+) = BS.CLIENTNO
ORDER BY C.CLIENTNO ;

--SELECT * 
--FROM CLIENT C, BOOKSALE BS
--WHERE C.CLIENTNO(+) = BS.CLIENTNO(+) -- ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다
--ORDER BY C.CLIENTNO ;
