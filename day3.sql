/*DML INSERT 데이터 삽입*/
-- 1. 기본형태컬럼명 기출
drop table ex3_1;
CREATE TABLE ex3_1 (
     col1 VARCHAR2(100)
    ,col2 NUMBER
    ,col3 DATE
);
INSERT INTO ex3_1 (col1, col2, col3)
VALUES ('nick', 10, SYSDATE);
-- 문자열타입은 '' 숫자는 그냥 숫자로 하지만 '10'도 받아줌
INSERT INTO ex3_1(col1,col2) --틀정컬럼만 삽입할때는 무조건 컬럼명 작성
VALUES('judy', 9);
INSERT INTO ex3_1(col1,col2) --틀정컬럼만 삽입할때는 무조건 컬럼명 작성
VALUES('jack', '20');
-- 2. 테이블에 있는 전체 컬럼에 대해서 삽입할때는 안써도됨
INSERT INTO ex3_1 VALUES ('팽수', 10, SYSDATE);
--3. select ~ insert 조회결과를 삽입
INSERT INTO ex3_1 (col1, col2)
SELECT emp_name, employee_id
FROM employees;
SELECT * FROM ex3_1;
-- 아래 조회결과를
SELECT * 
FROM tb_info;
-- DML :DEKETE 데이터 삭제
DELETE ex3_1; --전체삭제
DELETE ex3_1;
WHERE col1 = 'nick'; --특정 데이터 삭제
Delete dep
WHERE deptno = 3; -- emp에서 참조하고 있어서 삭제가 안됨

SELECT *
FROM emp;
DELETE emp
WHERE empno = 200; -- dep 참조하고 있는 emp데이터 부터 삭제 후 삭제가능

DROP TABLE dep;
-- 제약조건도 삭제 후 테이블 삭제( 참조하는 테이블이 있어서 삭제가 안될 때)
DROP TABLE dep CASCADE CONSTRAINTS;

-- 의사컬럼(테이블에는 없지만 있는것처럼 사용)
SELECT ROWNUM as rnum
    ,pc_no
    ,nm,
     hobby
FROM tb_info
WHERE ROWNUM <= 10;
-- 중복 제거 (DISTINCT)
SELECT DISTINCT cust_gender
FROM customers;
-- 표현식 (테이블에 특정 데이터의 표현을 바꾸고 싶을때 사용)
SELECT DISTINCT cust_name
      ,CASE WHEN cust_gender ='M' THEN '남자'
            WHEN cust_gender ='F' THEN '여자'
        ELSE '?'
        END as gender
FROM customers;
-- salary 10000 이상 고액연봉, 나머지는 연봉
SELECT *
FROM employees;

SELECT DISTINCT emp_name
    , salary
    , CASE WHEN salary >= 10000 THEN '고액연봉'
        ELSE '연봉'
        END as salary
FROM employees;

-- NULL조건식과 논리조건식(AND, OR, NOT)
SELECT *
FROM departments
WHERE parent_id IS NULL; --컬럼에 값이 null인
-- NULL이 아닌것은 IS NOT NULL
SELECT *
FROM departments
WHERE parent_id IS NOT NULL; --컬럼에 값이 NULL이 아닌
-- IN 조건식 (여러개 or가 필요할때)
-- ex) 30번, 60번, 80번 부서 조회
SELECT emp_name, department_id
FROM employees
WHERE department_id IN (30, 60, 80);
-- LIKE 검색 분자열 패턴검색
SELECT *
FROM tb_info
WHERE nm LIKE '김%'; -- 김으로 시작하는 모든
--WHERE nm LIKE '%길'; 길로 끝나는 모든
--WHERE nm LIKE '%앞%' 앞이 포함된 모든
-- tb_info에서 email에 94 포함된 학생을 조회하시오

--WHERE email LIKE '%naver%;
SELECT *
FROM tb_info
WHERE email LIKE '%94%';

-- || 문자열 더하기
SELECT pc_no || '[' || nm || ']' as info
FROM tb_info;

/*
    oracle 단일행 함수(내장함수)
    오라클 함수의 특징은 select문에 사용되어야 하기 때문에
    무조건 반환값이 있음
    내장함수는 각 타입별 사용할 수 있는 함수가 있음.
*/
-- 문자열 함수
-- LOWER, UPPER
SELECT LOWER('I LIKE MAC') as lowers
    ,  UPPer('i like mac') as uppers
FROM dual; --테스트용 임시 테이블(sql 문법을 맞추기 위함)
SELECT emp_name
FROM employees
WHERE LOWER(emp_name) = LOWER('WILLIAM SMITH');

-- select문 실행순서
-- (1) FROM -> (2) WHERE -> (3) GROUP BY -> (4) HAVING -> (5) SELECT-> (6)ORDERBY
SELECT 'hi'
FROM employees; --테이블 건수만큼 조회됨.

-- employees 에서 이름 -> william 포합된 직원을 모두 조회하시오
SELECT  emp_name
FROM employees
WHERE UPPER(emp_name) LIKE '%' || UPPER('william')|| '%';

-- '%WILLIAM%';
-- SUBSTR(char, pos, len) 대상문자열 char의 pos번째부터 len 길이만큼 자름
-- pos에 0 오면 1러 (디폴트 1)
-- pos에 음수가 오면 문자열의 맨 끝에서 시작한 상대적 위치
-- len이 생략되면 pos번째부터 나머지 모든 문자를 반환
SELECT SUBSTR('ABCD EFG', 1, 4) as ex1
    ,  SUBSTR('ABCD EFG', 4) as ex2
    ,  SUBSTR('ABCD EFG', -3, 3) as ex3
FROM dual;


-- INSTR 대상 문자열의 위치 찾기
-- 매개변수 총 4개 2개는 필수 뒤에는 디폴트 1,1
-- (p1,p2,p3,p4) p1 대상문자열, p2 찾을문자, p3 찾기시작위치, p4찾을문자의 몇번째 출현
SELECT INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면', '만약') as ex1
    ,  INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면', '만약',5) as ex2
    ,  INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면', '만약',1,2) as ex3
    ,  INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면', '나') as ex4 -- 없으면0
FROM dual;

-- tb_info 학생의 이름과 이메일 주소를 출력하시오
-- 단: 이메일 주소를 아이디와 도메인을 분리하여 출력하시오
--      audrl3692@naver.com ->> 아이디:audrl3692 도메인: naver.com
SELECT nm, email,
  SUBSTR(email, 1, INSTR(email, '@')-1) AS 아이디,
  SUBSTR(email, INSTR(email, '@')+1) AS 도메인
FROM 
  tb_info;


