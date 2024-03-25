/*
    공백제거 TRIM
    왼쪽: LTRIM 오른쪽: RTRIM 공백제거
*/
SELECT LTRIM(' ABC ') as ex1
     , RTRIM(' ABC ') as ex2
     , TRIM(' ABC ') as ex3
FROM dual;
/* LPAD, RPAD 채우는
   (대상, 길이, 표현)
*/
SELECT LPAD(123,5,'0') as ex1
     , LPAD(1, 5, '0') as ex2
     , LPAD(11235, 5, '0') as ex3
     , LPAD(112352, 5, '0') as ex4 --출력이 무조건 2번째 매개변수 길이
     , RPAD(2, 5, '*')      as ex5
FROM dual;

/* REPLACE (단어 정확하게 매칭), TRANSLATE(한글자씩 매칭) 변환*/
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') as ex1
     , TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') as ex2
FROM dual;
-- LENGTH 문자열길이, LENGTHB 문자열 크기(byte)
SELECT LENGTH('abc1') as ex1 --숫자, 특수문자, 영어 1byte
     , LENGTHB('abc1') as ex2
     , LENGTH('팽수1') as ex3 --utf-8 기준 한글 3byte
     , LENGTHB('팽수1') as ex4
FROM dual;

SELECT *
FROM member;

/* 직업이 주부,자영업자, 회사원인 회원의 등급을 출력하시오
  2500 이하 silver, 2500초과 5000이하 gold, 5000초과 vip*/
SELECT mem_name
     , mem_mileage
     , CASE 
         WHEN mem_mileage <= 2500 THEN 'silver'
         WHEN mem_mileage > 2500 AND mem_mileage <= 5000 THEN 'gold'
         ELSE 'vip' 
       END as mem_grade
       , mem_job
FROM member
WHERE mem_job IN ('주부', '자영업', '회사원')
ORDER BY mem_mileage DESC;

-- TABLE 수정 ALTER
CREATE TABLE ex5_1(
    nm VARCHAR2(100) NOT NULL
    ,point NUMBER(5)
    ,gender CHAR(1)
);
-- 컬럼명 수정
ALTER TABLE ex5_1 RENAME COLUMN point To user_point;
-- 타입 수정(타입 수정시 테이블에 데이터가 있다면 주의 해야함)
ALTER TABLE ex5_1 MODIFY gender VARCHAR2(1);
-- 제약조건 추기
ALTER TABLE ex5_1 ADD CONSTRAINT pk_ex5 PRIMARY KEY (nm);
-- 컬럼 추가
ALTER TABLE ex5_1 ADD create_dt DATE;
-- 컬럼 삭제
ALTER TABLE ex5_1 DROP COLUMN gender;
SELECT * FROM ex5_1;

ALTER TABLE tb_info ADD MBTI VARCHAR2(4);
SELECT *
FROM tb_info;

/* 숫자 함수 (매개변수 숫자형)
    ABS: 절대값, ROUND 반올림 TRUNC 버림 CEIL 올림 SQRT 제곱근
    MOD(n,m) m을 n으로 나누었을 때 나머지 반환
*/
SELECT ABS(-10) as ex1
     , ABS(10)  as ex2
     , ROUND(10.5555) as ex3 --default 정수
     , ROUND(10.5555,1) as ex4 -- 소주점 2째 자리에서 반올림
     , TRUNC(10.5555, 1) as ex5
     , MOD(4, 2) as ex6
     , MOD(5, 2) as ex7
FROM dual;

/* 날짜 함수 */
SELECT SYSDATE
     , SYSTIMESTAMP
FROM dual;
-- ADD MONTH(날짜, 1) 다음달
-- LAST_DAY 마지막날, NEXT_DAY(날짜, '요일') 가장빠른 해당요일
SELECT ADD_MONTHS(SYSDATE, 1) AS ex1
     , ADD_MONTHS(SYSDATE, -1) AS ex2
     , LAST_DAY(SYSDATE) AS ex3
     , NEXT_DAY(SYSDATE, '수요일') AS ex4
     , NEXT_DAY(SYSDATE, '목요일') AS ex5  -- 오늘이 목요일이라면 다음주 목요일
     , NEXT_DAY(SYSDATE, '금요일') AS ex5
FROM dual;
SELECT SYSDATE -1 --<-- 1day 연산가능
     , ADD_MONTHS(SYSDATE, 1) - ADD_MONTHS(SYSDATE,-1) -- 날짜연산가능
FROM dual;
-- 이번달은 몇일 남았을까요?
SELECT 'd-day:' || (LAST_DAY(SYSDATE)- SYSDATE) || '일' AS dday
FROM dual;

-- DECODE 표현식
SELECT DISTINCT cust_name
     , cust_gender
     --조건1, true값, false(그밖에)
     , DECODE(cust_gender, 'M','남자', '여자') as gender
     -- 조건1, true값, 조건2, true값, 그밖에)
     , DECODE(cust_gender, 'M', '남자','F','여자','?') as gender2
FROM customers;

-- member 의 회원의 성별을 출력하시오
-- member 정보에는 성별이 없음.
-- 회원이름, 성별을 출력
-- mem_regno2 는 주민번호 뒷자리
ALTER TABLE member ADD gender VARCHAR2(4);
SELECT * FROM member;
SELECT DISTINCT SUBSTR(mem_regno2,1,1)
FROM member;

SELECT mem_name,
       mem_regno2,
       DECODE(SUBSTR(mem_regno2, 1, 1), '1', '남자', '2', '여자') AS gender
FROM member;

