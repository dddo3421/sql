-- 오라클 내장함수

--수학함수
--ROUND(값, 자리수) : 자리수 아래에서 반올림 

SELECT ROUND(3.862, 1) FROM DUAL;
SELECT ROUND(3.862, 2) FROM DUAL;

--고객별 평균 주문액을 계산해서 조회(백원단위에서 반올림한 계산결과 조회)
SELECT CLIENTNO, ROUND(AVG(BOOKPRICE*BSQTY)) AS 평균주문액
                          , ROUND(AVG(BOOKPRICE*BSQTY),0) AS 평균주문액
                          , ROUND(AVG(BOOKPRICE*BSQTY),-1) AS "10자리까지출력"
                          , ROUND(AVG(BOOKPRICE*BSQTY),-2) AS "100자리까지출력"
                          , ROUND(AVG(BOOKPRICE*BSQTY),-3) AS "1000자리까지출력"
FROM BOOK, BOOKSALE
WHERE BOOK.BOOKNO = BOOKSALE.BOOKNO
GROUP BY CLIENTNO
ORDER BY CLIENTNO;

--------------------------------------------------------------------------------------------------

/* 문자함수
REPLACE() : 문자열 치환
LENGTH() : 글자의 수
LENGTHB() : 바이트 수
SUBSTR() : 지정한 길이만큼 문자열 반환 */

--REPLACE(원본문자열, 검색문자열, 치환문자열)
SELECT REPLACE('자바프로그래밍', '자바','파이썬') FROM DUAL;

SELECT REPLACE('APPLE AIRPLANE APART', 'AP', '*^') FROM DUAL;

--도서명에 '안드로이드'가 포함된 도서 데이터
--ANDROID로 변경해서 조회
--SELECT된 결과에 함수 적용
SELECT BOOKNO, REPLACE(BOOKNAME, '안드로이드', 'ANDROID'), BOOKAUTHOR, BOOKPRICE
FROM BOOK
WHERE BOOKNAME LIKE '%안드로이드%';


-- 각 도서의 도서명에 대한 크기를 확인
-- 도서명은 문자열 크기(갯수, 바이트수)
SELECT BOOKNAME AS 도서명, LENGTH(BOOKNAME) AS "문자수", LENGTHB(BOOKNAME) AS "바이트"
FROM BOOK;

-- SUBSTR(문자열, 시작위치, 길이)
SELECT SUBSTR(BOOKAUTHOR,1,1)
FROM BOOK;

SELECT SUBSTR(BOOKAUTHOR,2,2)
FROM BOOK;

-- CONCAT 혹은 || :  문자열 연결
-- 데이터베이스에 저장은 리터럴로 저장됨 -> 저자 : 도서명 : 가격 형식의 데이터가 개발시 필요
SELECT CONCAT('문자열', ':'), '문자열' || ' ' || '연결방법2' AS 연결2
FROM DUAL;

SELECT BOOKAUTHOR ||  ' : ' ||  BOOKNAME || ' : ' ||BOOKPRICE AS 도서정보 -- 단 값에 NULL이 있으면 행 전체가 NULL로 나옴
FROM BOOK;

-- 순위 출력 함수
-- RANK()
-- DENSE_RANK()
-- ROW_NUMBER()

-- 순위함수() OVER (ORDER BY 열) 형식으로 사용

SELECT BOOKPRICE,   
            RANK() OVER(ORDER BY BOOKPRICE DESC) "RANK",
            --동점자에게 같은 순위 부여, 다음 순위는 동점 수 만큼 건너뜀
            DENSE_RANK() OVER(ORDER BY BOOKPRICE DESC) "DENSE_RANK",
            --동점자에게 같은 순위 부여, 다음 순위는 1씩 증가 (건너뛰지 않음)
            ROW_NUMBER() OVER(ORDER BY BOOKPRICE DESC) "ROW_NUMBER"
            --순위가 무조건 1씩 증가, 동점자도 순서대로 번호 부여
FROM BOOK;

-- TOP N 조회 : ROWNUM
SELECT ROWNUM, BOOKPRICE
FROM BOOK
WHERE ROWNUM BETWEEN 1 AND 5; -- 데이터의 일부만 확인할 때 사용 

-- ROLLUP()
-- 그룹의 소계와 총계 산출
-- 순서가 중요, 맨 앞에 놓인 것에 대해 소계 산출

-- CUBE()
-- 각 그룹의 모든 경우의 수에 대한 소계와 총계 산출
-- 각 항목들간의 다차원적인 소계를 계산
-- 그룹핑시 순서 상관 없음

--GROUPING SETS()
--특정 항목에 대한 소계 산출

CREATE TABLE CUBETBL(
    PRDNAME VARCHAR2(10),
    COLOR VARCHAR2(6),
    AMOUNT NUMBER(2)
    );
    
INSERT INTO CUBETBL VALUES('컴퓨터','검정',11);
INSERT INTO CUBETBL VALUES('컴퓨터','파랑',22);
INSERT INTO CUBETBL VALUES('모니터','검정',33);
INSERT INTO CUBETBL VALUES('모니터','파랑',44);
INSERT INTO CUBETBL VALUES('마우스','검정',55);
INSERT INTO CUBETBL VALUES('마우스','파랑',66);

SELECT *
FROM CUBETBL;

-- CUBE 함수
SELECT PRDNAME, COLOR, SUM(AMOUNT) AS 수량합계
FROM CUBETBL
GROUP BY CUBE(COLOR, PRDNAME)
ORDER BY PRDNAME, COLOR;

-- ROLLUP 함수
SELECT PRDNAME, COLOR, SUM(AMOUNT) AS 수량합계
FROM CUBETBL
GROUP BY ROLLUP(COLOR, PRDNAME) -- 앞에 표현된 컬럼에 대해 그룹의 소계 출력
ORDER BY PRDNAME, COLOR;


SELECT PRDNAME, COLOR, SUM(AMOUNT) AS 수량합계
FROM CUBETBL
GROUP BY ROLLUP(PRDNAME, COLOR) -- 앞에 표현된 컬럼에 대해 그룹의 소계 출력
ORDER BY PRDNAME, COLOR;

-- GROUPING SETS : 항목별 소계만 출력
SELECT PRDNAME, SUM(AMOUNT) AS 수량합계
FROM CUBETBL
GROUP BY GROUPING SETS(PRDNAME );


-- PIVOT() 함수
-- ROW 단위를 COLUMN 단위로 변경(행 데이터를 열 형태로 변환)
-- 요약 정리 가능

create table pivotTest(
  singer varchar2(10),
  season varchar2(10),
  amount number(3)
);
insert into pivotTest values('김범수','겨울',10);
insert into pivotTest values('윤종신','여름',15);
insert into pivotTest values('김범수','가을',25);
insert into pivotTest values('김범수','봄',3);
insert into pivotTest values('김범수','봄',37);
insert into pivotTest values('윤종신','가을',40);
insert into pivotTest values('김범수','여름',14);
insert into pivotTest values('김범수','겨울',22);
insert into pivotTest values('윤종신','여름',64);

SELECT *  FROM PIVOTTEST;

SELECT * FROM PIVOTTEST
        PIVOT(SUM(AMOUNT)
                    FOR SEASON
                    IN('봄','여름','가을','겨울'));
                    
---------------------------------------------------------------------------------------------------------
-- 날짜 반환 함수
-- SYSDATE, CURRENT_DATE

SELECT SYSDATE FROM DUAL; -- 현재일자(오늘)
SELECT CURRENT_DATE FROM DUAL;

SELECT SYSDATE +1 FROM DUAL; -- 1일 후
SELECT SYSDATE -1 FROM DUAL; -- 1일 전

SELECT ADD_MONTHS(SYSDATE, 1) FROM DUAL; -- 1달 후
SELECT ADD_MONTHS(SYSDATE, -1) FROM DUAL; -- 1달 전

SELECT ADD_MONTHS(SYSDATE, 12) FROM DUAL; -- 1년 후
SELECT ADD_MONTHS(SYSDATE, -12) FROM DUAL; -- 1년 전


-- 날짜 데이터에서 년, 월, 일 추출 
-- EXTRACT()

SELECT      EXTRACT(YEAR FROM SYSDATE) -1 년,
                  EXTRACT(MONTH FROM SYSDATE) 월,
                   EXTRACT(DAY FROM SYSDATE) 일
FROM  DUAL;

--현재 시간
SELECT CURRENT_TIMESTAMP FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'MI') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'SS') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MM') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DD') FROM DUAL;



