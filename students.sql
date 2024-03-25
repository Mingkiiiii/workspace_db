CREATE TABLE 강의내역 (
    강의내역번호 NUMBER(3),
    교수번호 NUMBER(3),
    과목번호 NUMBER(3),
    강의실 VARCHAR2(10),
    교시 NUMBER(3),
    수강인원 NUMBER(5),
    년월 DATE
);

CREATE TABLE 과목 (
    과목번호 NUMBER(3),
    과목이름 VARCHAR2(50),
    학점 NUMBER(3)
);

CREATE TABLE 교수 (
    교수번호 NUMBER(3),
    교수이름 VARCHAR2(20),
    전공 VARCHAR2(50),
    학위 VARCHAR2(50),
    주소 VARCHAR2(100)
);

CREATE TABLE 수강내역 (
    수강내역번호 NUMBER(3),
    학번 NUMBER(10),
    과목번호 NUMBER(3),
    강의실 VARCHAR2(10),
    교시 NUMBER(3),
    취득학점 VARCHAR(10),
    년월 DATE 
);

CREATE TABLE 학생 (
    학번 NUMBER(10),
    이름 VARCHAR2(50),
    주소 VARCHAR2(100),
    전공 VARCHAR2(50),
    부전공 VARCHAR2(500),
    생년월일 DATE,
    학기 NUMBER(3),
    평점 NUMBER
);

-- 테이블에 PK 설정
ALTER TABLE 학생 ADD CONSTRAINT PK_학생 PRIMARY KEY (학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_수강내역 PRIMARY KEY (수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT PK_과목 PRIMARY KEY (과목번호);
ALTER TABLE 교수 ADD CONSTRAINT PK_교수 PRIMARY KEY (교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT PK_강의내역 PRIMARY KEY (강의내역번호);

-- 테이블에 FK 설정
ALTER TABLE 수강내역 ADD CONSTRAINT FK_수강내역_학번 FOREIGN KEY (학번) REFERENCES 학생 (학번);
ALTER TABLE 수강내역 ADD CONSTRAINT FK_수강내역_과목번호 FOREIGN KEY (과목번호) REFERENCES 과목 (과목번호);
ALTER TABLE 강의내역 ADD CONSTRAINT FK_강의내역_교수번호 FOREIGN KEY (교수번호) REFERENCES 교수 (교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT FK_강의내역_과목번호 FOREIGN KEY (과목번호) REFERENCES 과목 (과목번호);

COMMIT;
select *
FROM 학생;

SELECT * FROM 교수;
SELECT * FROM 과목;
SELECT * FROM 강의내역;
SELECT * FROM 수강내역;

/* INNER JOIN 내부조인 (동등조건)*/
SELECT *
FROM 학생;

SELECT *
FROM 수강내역;

SELECT 학생.이름
     , 학생.평점
     , 학생.학번
     , 수강내역.수강내역번호
     , 수강내역.과목번호
     , 과목.과목이름
FROM 학생, 수강내역, 과목
WHERE 학생.학번 = 수강내역.학번
AND 수강내역.과목번호=과목.과목번호
AND 학생.이름 = '최숙경';


-- 학생의 수강내역 건수를 조회하시오
SELECT 학생.이름
     , ROUND(학생.평점, 2) as 평점
     , 학생.학번
     , COUNT(수강내역.수강내역번호) as 수강건수
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번
GROUP BY 학생.이름, 학생.평점, 학생.학번
ORDER BY 1;
/* OUTER JOIN 외부조인 NULL값을 포함시키고 싶을 때*/
SELECT 학생.이름
     , ROUND(학생.평점, 2) as 평점
     , 학생.학번
     , COUNT(수강내역.수강내역번호) as 수강건수
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번(+) --null값을 포함시키고 싶을 때 (+)
GROUP BY 학생.이름, 학생.평점, 학생.학번
ORDER BY 1;

SELECT COUNT(*)
FROM 학생, 수강내역;  -- cross join(주의해야함)
                    -- 9 * 17 = 153

SELECT COUNT(*)
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번;

--학생의 수강내역과 총 수강학점을 출력하시오
SELECT 학생.이름
     , ROUND(학생.평점, 2) as 평점
     , 학생.학번
     , COUNT(수강내역.수강내역번호) as 수강건수
     , SUM(NVL(과목.학점,0)) as 총수강학점
FROM 학생, 수강내역, 과목
WHERE 학생.학번 = 수강내역.학번(+) --null값을 포함시키고 싶을 때 (+)
AND 수강내역.과목번호 = 과목.과목번호(+)
GROUP BY 학생.이름, ROUND(학생.평점, 2), 학생.학번
ORDER BY 1;

SELECT *
FROM member;

SELECT *
FROM cart;

SELECT *
FROM prod;

SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no) as 카트사용횟수
     , COUNT(DISTINCT b.cart_prod) as 구매상품품목수
     , SUM(b.cart_qty) as 총구매상품수      -- 카트사용횟수, 구매상품 품목수, 총구매상품수를 출력하시오 -- 총 구매금액을 출력하시오(상품금액은 prod_sale사용)
     , SUM(c.prod_sale * b.cart_qty) as 총구매금액
FROM member a
    ,cart b
    , prod c
WHERE a.mem_id = b.cart_member
AND b.cart_prod= c.prod_id
AND a.mem_name='김은대'
GROUP BY a.mem_id, a.mem_name;

-- 외부조인
SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no) as 카트사용횟수
     , COUNT(DISTINCT b.cart_prod) as 구매상품품목수
     , SUM(NVL(b.cart_qty,0)) as 총구매상품수      -- 카트사용횟수, 구매상품 품목수, 총구매상품수를 출력하시오
FROM member a
    ,cart b
WHERE a.mem_id = b.cart_member(+)
AND a.mem_name='탁원재'
GROUP BY a.mem_id, a.mem_name;

-- employees, jobs 테이블을 활용하여 salary가 15000 이상인 직원의 사번, 이름, salary, 직업명을 출력하시오.
SELECT *
FROM employees;
SELECT *
FROM jobs;
SELECT a.employee_id
     , a.emp_name
     , a.salary
     , b.job_title
FROM employees a,
    jobs b
WHERE a.job_id = b.job_id
AND salary>15000;










/* subquery (쿼리안에 쿼리)
    1. 스칼라 서브쿼리(select 절)
    2. 인라인 뷰 (from절)
    3. 중첩쿼리(where 절)
*/
-- 스칼라 서브쿼리는 단일행 변환
-- 주의 할 점은 메인 쿼리테이블의 행 건수만큼 조회하기 때문에(무거운 테이블을 사용하면 오래걸림)
-- 위와같은 상황에는 조언을 이용하는게 더 좋음
SELECT a.emp_name
     , a.department_id  --부서 아이디 대신 부서명이 필요할때 부서아이디는 부서 테이블의 pk( 유니크함 단일행 반환)
     
     ,(SELECT department_name
       FROM departments
       WHERE department_id = a.department_id) as dep_nm
        -- 스칼라서브쿼리로 job_title을 출력하시오
       ,(SELECT job_title
         FROM jobs
         WHERE job_id = a.job_id) as job_title
FROM employees a;

-- 중첩서브쿼리(where절)
-- 직원중 salary 전체평균 보다 높은 직원을 출력하시오
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees) --6461.83--------------
ORDER BY 2;
-- 위 아래가 결과는 같지만 데이터가 변할 수 있기 때문에 위에 쿼리를 쓰는게 나음
SELECT emp_name, salary
FROM employees
WHERE salary >= 6461.46556566556
ORDER BY 2;
-- 학생중 전체평균 평점 이상인 학생정보만 출력하시오
SELECT 학번, 이름, 전공, 평점
FROM 학생
WHERE 평점 >= (SELECT AVG(평점)
              FROM 학생)
ORDER BY 1;

-- 평점이 가장 높은 학생의 정보를 출력하시오
SELECT 학번, 이름, 전공, 평점
FROM 학생
WHERE 평점 = (SELECT MAX(평점)
              FROM 학생);
              
-- 수강 이력이 없는 학생의 이름을 출력하시오
SELECT 이름
FROM 학생
WHERE 학번 NOT IN (SELECT 학번
              FROM 수강내역);

-- 동시에 2개이상의 컬럼값이 같은 건 조회
SELECT employee_id
     , emp_name
     , job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id, job_id FROM job_history);

SELECT * FROM kor_loan_status;
-- 지역과 각 년도별 대출총잔액을 구하는 쿼리를 작성해 보자(kor_loan_status)
-- 2011년합계, 2012년합계, 2013년합계를 구하시오

SELECT region, SUM(loan_jan_amt)
FROM kor_loan_status
WHERE period >= (SELECT AVG(period)
                 FROM employees)
GROUP BY region;

SELECT region, period, SUM(loan_jan_amt)
FROM kor_loan_status
WHERE period >= (SELECT AVG(period)
                 FROM kor_loan_status)
GROUP BY region, period;












