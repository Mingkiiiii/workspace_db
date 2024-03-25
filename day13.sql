/*
    계층형 쿼리
    오라클에서 지원하고 있는 기능
    관계형 데이터베이스의 데이터는 수평적인 데이터로 구성되어 있는데
    계층형쿼리로 수직적 구조로 표현할 수 있음
    메뉴, 부서, 권한 등을 계층형 쿼리로 만들 수 있음.
*/
SELECT department_id
     , LPAD(' ',3*(LEVEL-1))  || department_name as 부서명
     , LEVEL -- (계층)트리 내에서 어떤 단계에 있는지 나타내는 정수값
     , parent_id
FROM departments
START WITH parent_id IS NULL    -- 시작조건
CONNECT BY PRIOR department_id = parent_id; --구조가 어떻게 연결되는지

SELECT a.employee_id
     , LPAD(' ',3 * (LEVEL-1)) || a.emp_name
     , b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id=a.manager_id;

-- departments 테이블에 데이터를 삽입하시오
-- IT 헬프데스크 하위 부서로
-- department_id: 280
-- department_name : CHATBOT팀 헬프디스크의 레벨은 4 레벨이 5가되게
SELECT department_idINSERT INTO departments (department_id, department_name, parent_id)
VALUES (280, 'CHATBOT팀', 230);
FROM departments;

-- 30부서를 조회
SELECT a.employee_id
     , LPAD(' ',3 * (LEVEL-1)) || a.emp_name
     , b.department_name
     , a.department_id
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id=a.manager_id
AND a.department_id = 30;

SELECT a.employee_id
     , LPAD(' ',3 * (LEVEL-1)) || a.emp_name
     , b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id=a.manager_id
--ORDER BY b.department_name; -- 계층형 트리가 깨짐
ORDER SIBLINGS BY b.department_name; -- 트리를 유지하고 동일 level에서만


SELECT department_id
     , LPAD(' ',3*(LEVEL-1))  || department_name as 부서명
     , parent_id
     , CONNECT_BY_ROOT department_name as rootNm    -- root row에 접근
     , SYS_CONNECT_BY_PATH(department_name, '|') as pathNm
     ,CONNECT_BY_ISLEAF as leafNm-- 마지막노드1, 자식이 있으면 0
FROM departments
START WITH parent_id IS NULL    -- 시작조건
CONNECT BY PRIOR department_id = parent_id;

drop table exco;
CREATE TABLE exco(
    아이디 number
   ,이름 VARCHAR2(10)
    ,직책 VARCHAR2(10)
  , parent_id number
);
SELECT * FROM exco;
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (1,'이사장', '사장', null);
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (2, '김부장', '부장', 1);
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (3, '서차장', '차장', 2);
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (4,'장과장', '과장', 3);
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (6,'이대리', '대리', 4);
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (8,'최사원', '사원', 6);
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (9,'강사원', '사원', 6);
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (5, '박과장', '과장', 3);
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (7,'김대리', '대리', 5);
INSERT INTO exco (아이디,이름, 직책, parent_id)
VALUES (10,'주사원', '사원', 7);

SELECT 아이디
     , LPAD(' ',3*(LEVEL-1))  || 직책 
     , LEVEL -- (계층)트리 내에서 어떤 단계에 있는지 나타내는 정수값
     , parent_id
FROM exco
START WITH parent_id IS NULL    -- 시작조건
CONNECT BY PRIOR 아이디 = parent_id;

/*
    계층형쿼리 응용 (샘플 데이터 생성)
    LEVEL은 가상-열로써 (CONNECT BY 절과 함께 사용)
*/
SELECT '2013'|| LPAD(LEVEL,2,'0') as 년월
FROM dual
CONNECT BY LEVEL <=12;

SELECT period as 년월
     , SUM(loan_jan_amt) as 대출합계
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period;

SELECT a.년월
     , NVL(b.대출합계,0) as 대출합계
FROM (SELECT '2013'|| LPAD(LEVEL,2,'0') as 년월
        FROM dual
        CONNECT BY LEVEL <=12) a
            ,(SELECT period as 년월
             , SUM(loan_jan_amt) as 대출합계
                 FROM kor_loan_status
                    WHERE period LIKE '2013%'
                    GROUP BY period) b
WHERE a.년월 = b.년월(+);

-- 202401 - 202412 SYSDATE를 이용하여 출력하시오
-- connect by level 사용
SELECT TO_CHAR(SYSDATE, 'YYYY') || LPAD(LEVEL,2,'0') AS mm
FROM dual
CONNECT BY LEVEL <=12;
-- 이번달 1일부터 ~ 마지막날까지 출력하시오
SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') || LPAD(LEVEL,2,'0') AS mm
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE), 'DD');

SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE), 'DD');

-- member 회ㅣ원의 생일(mem_bir)를 이용하여 월별 회원수를 출력하시오(모든월이 나오도록)
SELECT TO_CHAR(mem_bir, 'MM') AS birth_month, COUNT(*) AS member_count
FROM member
GROUP BY TO_CHAR(mem_bir, 'MM')
ORDER BY birth_month;

SELECT LPAD(TO_CHAR(months.month, 'FM00'), 2, '0') AS birth_month, 
       NVL(COUNT(member.mem_bir), 0) AS member_count
FROM (
  SELECT LEVEL AS month
  FROM dual
  CONNECT BY LEVEL <= 12
) months
LEFT JOIN member
ON TO_CHAR(member.mem_bir, 'MM') = LPAD(TO_CHAR(months.month, 'FM00'), 2, '0')
GROUP BY ROLLUP(months.month)
ORDER BY birth_month;





