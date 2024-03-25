/*변환함수(타입)
    TO_CHAR 문자형으로
    TO_DATE 날짜형으로
    TO_NUMBER 숫자형으로
*/
SELECT TO_CHAR(123456, '999,999,999') as ex1
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD') as ex2
     , TO_CHAR(SYSDATE, 'YYYYMMDD') as ex3
     , TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') as ex4
     , TO_CHAR(SYSDATE, 'YYYY/MM/DD HH12:MI:SS') as ex5
     , TO_CHAR(SYSDATE, 'day') as ex6
     , TO_CHAR(SYSDATE, 'YYYY') as ex7
     , TO_CHAR(SYSDATE, 'YY') as ex8
     , TO_CHAR(SYSDATE, 'dd') as ex9
     , TO_CHAR(SYSDATE, 'd') as ex10 -- 요일개념 일요일부터 시작 일월화수목 (5)
FROM dual;
SELECT TO_DATE('231229', 'YYMMDD') as ex1
     , TO_DATE('2023 12 29 09:10:00', 'YYYY MM DD HH24:MI:SS') as ex2
     , TO_DATE('25', 'YY') as ex3
     , TO_DATE('45', 'YY') as ex4
     -- RR은 세기를 자동으로 추적
     -- 50 ->1950
     -- 49->2049 (Y2K 2000년 문제)에 대한 대응책으로 도입됨
     , TO_DATE('50', 'RR') as ex5
FROM dual;
CREATE TABLE ex5_2(
    title VARCHAR2(100)
    ,d_day DATE
);
INSERT INTO ex5_2 VALUES ('종료일', '20240614');
INSERT INTO ex5_2 VALUES ('종료일', '2024.06.14');
INSERT INTO ex5_2 VALUES ('종료일', '2024/06/14');
INSERT INTO ex5_2 VALUES ('종료일', '2024 06 14');
INSERT INTO ex5_2 VALUES ('종료일', TO_DATE('2024 06 14 09', 'YYYY MM DD HH24'));
SELECT *
FROM ex5_2;

CREATE TABLE ex5_3(
    seq1 VARCHAR2(100)
    ,seq2 NUMBER
);
INSERT INTO ex5_3 VALUES('1234', '1234');
INSERT INTO ex5_3 VALUES('99', '99');
INSERT INTO ex5_3 VALUES('123456', '123456');
SELECT * FROM ex5_3
ORDER BY TO_NUMBER(seq1) DESC;
-- member 회원의 생년월일을 이용하여 나이를 계산하시오
-- 올해년도를 이용하여 (ex 2021 - 2000 = 21세)
SELECT *
FROM member;

SELECT mem_name,mem_bir,
       TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(TO_CHAR(mem_bir, 'YYYY'))||'세' AS age
FROM member
ORDER BY age DESC;

/*
고객 테이블(CUSTOMERS)에는
고객의 출생년도(cust_year_of_birth) 컬럼이 있다.
현재일 기준으로 이 컬럼을 활용해 30대,40대,50대를 구분해 출력하고,
나머지 연령대는 '기타'로 출력하는 쿼리를 작성해보자.
*/
SELECT DISTINCT
    cust_name, 
    cust_year_of_birth,
    (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) AS age,
    CASE
        WHEN (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) BETWEEN 30 AND 39 THEN '30대'
        WHEN (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) BETWEEN 40 AND 49 THEN '40대'
        WHEN (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) BETWEEN 50 AND 59 THEN '50대'
        ELSE '기타'
    END AS age_group
FROM 
customers;


