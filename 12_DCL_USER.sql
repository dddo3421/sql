-- 계정에 할당된 QUOTA 확인
SELECT * FROM USER_TS_QUOTAS; -- 할당량 MAX_BYTES 값이 -1이면 무제한의미

-- 계정 조회
SELECT * FROM DBA_USERS; -- DBA권한으로만 조회 가능
SELECT * FROM ALL_USERS; -- DBA권한보다 낮은 모든 사용자 권한으로 조회가 가능
SELECT * FROM USER_USERS; -- 현재 계정에 대한 정보 조회

-- DBA_XXX : DBA 권한으로 확인가능 
SELECT * FROM DBA_TABLES;

-- ALL_XXX : DBA 권한보다 낮으면서 부여된 권한으로 조회할 수 있는 객체 확인
SELECT * FROM ALL_TABLES;

-- USER_XXX : 자신이 생성한 모든 객체에 대한 정보
SELECT * FROM USER_TABLES;

--관리자가 아닌 경우 계정, 객체 정보 확인
SELECT * FROM ALL_USERS;
SELECT * FROM USER_TABLES; -- 현재 계정 DB
SELECT * FROM TAB; -- 현재 계정 DB

--현재 계정에 부여된 권한 조회
SELECT * FROM USER_ROLE_PRIVS;

------------------------------------------------------------------------------------
-- 다른 계정(C##USER_SELECT)의 객체(BOOK)에 접근
-- 소유주의 허가가 있어야 접근 가능
GRANT SELECT ON BOOK TO NEWUSER11;
GRANT INSERT ON BOOK TO NEWUSER11;
GRANT UPDATE ON BOOK TO NEWUSER11;
GRANT DELETE ON BOOK TO NEWUSER11;

-- 현재 계정에서 
SELECT  * 
FROM C##USER_SELECT.BOOK;

-- DML에 질의어에 대해서 각각 권한을 부여 받아야 함
UPDATE  C##USER_SELECT.BOOK SET BOOKNAME = 'TESTBOOK'  WHERE BOOKNO = '12345678';

-- 소유주 계정에서 권한 회수
REVOKE SELECT ON BOOK FROM NEWUSER11;

-- 현재 계정에서 진행 - 권한 회수 후라 오류 발생
SELECT  * 
FROM C##USER_SELECT.BOOK;

alter table publisher
    add constraint pk_publisher_pubno
    primary key (pubno);
   
alter table book
    add constraint pk_book_bookno
    primary key (bookno);
   
alter table book
    add constraint fk_book_publisher
    foreign key (pubno) references publisher (pubno);
    
-- 백업
-- 주기적으로 DB를 백업해둬야 함
-- 다른 서버로 이관할 때 백업 필요함
-- 1. SQL 파일로 구성 (DEVELOPER 사용시)
-- 2. DMP 파일로 구성 (CONSOLE에서 사용시)

-- 백업 단위
-- 전체 단위
-- 계정 단위
-- 테이블 단위

