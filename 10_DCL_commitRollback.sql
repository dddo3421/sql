--COMMIT / ROLLBACK

--COMMIT
--트랜젝션 처리가 정상적으로 종료되는 상황
--트랜젝션이 수행한 변경 내용을 데이터베이스에서 반영하는 연산
--트랜젝션이 COMMIT에 의해 완료되면 DB는 완전 변경되어서 시스템 오류가 발생해도 취소되지 않음

--ROLLBACK
--트랜젝션 처리가 비정상적으로 종료된 경우
--데이터베이스의 일관성이 깨졌을 때 트랜젝션이 진행한 변경작업을 취소하는 연산 - 이전 상태로 되돌림

--간단한 예제
--INSERT : DB TABLE에 변경을 가함(ROLLBACK)
INSERT INTO BOOK VALUES('12345678', 'BOOKTEST', 'TEST', 33000, '2020-01-01',5,'1');

SELECT * FROM BOOK;

ROLLBACK;

SELECT * FROM BOOK;

INSERT INTO BOOK VALUES('12345678', 'BOOKTEST', 'TEST', 33000, '2020-01-01',5,'1');

SELECT * FROM BOOK;

COMMIT; -- COMMIT 이전에 진행한 작업들의 취소는 불가능함

INSERT INTO BOOK VALUES('123456789', 'BOOKTEST1', 'TEST1', 33000, '2020-01-01',5,'1');

ROLLBACK; --ROLLBACK되는 범위는 이전 COMMIT 이후까지 ROLLBACK

SELECT * FROM BOOK;

DELETE FROM BOOK WHERE BOOKNO = '12345678';
ROLLBACK;
SELECT * FROM BOOK;

--COMMIT은 세션종료(접속해제)하면 COMMIT하는지 물어볼 수 있음

