
ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_수강내역_수강내역번호 PRIMARY KEY (수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT PK_과목내역_과목번호 PRIMARY KEY (과목번호);
ALTER TABLE 교수 ADD CONSTRAINT PK_교수_교수번호 PRIMARY KEY (교수번호);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
REFERENCES 학생(학번);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_과목_과목번호 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_교수_교수번호 FOREIGN KEY(교수번호)
REFERENCES 교수(교수번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_과목_과목번호2 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);



COMMIT;


/* INNER JOIN 내부조인 (동등조인) */
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
AND   수강내역.과목번호 = 과목.과목번호 
AND 학생.이름 = '양지운';

--학생의 수강내역 건수를 조회하시오(평점 소수점 2째자리 까지 표현,이름정렬)




SELECT 학생.이름
     , ROUND(학생.평점,2) as 평점
     , 학생.학번 
     , COUNT(수강내역.수강내역번호) as 수강건수
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번
GROUP BY 학생.이름, 학생.평점, 학생.학번
ORDER BY 1 ;


/* outer join 외부조인 null값을 포함시키고 싶을때*/
SELECT 학생.이름
     , ROUND(학생.평점,2) as 평점
     , 학생.학번 
     , COUNT(수강내역.수강내역번호) as 수강건수
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번(+) -- null값을포함시킬 쪽에 (+)
GROUP BY 학생.이름, 학생.평점, 학생.학번
ORDER BY 1 ;
SELECT 학생.이름
     , ROUND(학생.평점,2) as 평점
     , 학생.학번 
     , 수강내역.수강내역번호 as 수강건수
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번(+) -- null값을포함시킬 쪽에 (+)
ORDER BY 1 ;
-- 학생의 수강내역수와 총 수강학점을 출력하시오 
SELECT 학생.이름
     , ROUND(학생.평점,2) as 평점
     , 학생.학번 
     , COUNT(수강내역.수강내역번호) as 수강건수
     ,SUM(NVL(과목.학점,0)) as 총수강학점
FROM 학생, 수강내역, 과목
WHERE 학생.학번 = 수강내역.학번(+) 
AND   수강내역.과목번호 = 과목.과목번호(+)
GROUP BY 학생.이름, ROUND(학생.평점,2), 학생.학번 
ORDER BY 1 ;

SELECT count(*)
FROM 학생, 수강내역; -- cross join (주의해야함) 
                   -- 9 * 17 = 153
SELECT count(*)
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번;

SELECT *
FROM member;

SELECT *
FROM cart;

 --김은대씨의 '카트사용횟수, 구매상품 품목 수, 총구매상품수
 --'총구매금액'을 출력하시오 
SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no)   as 카트사용횟수
     , COUNT(DISTINCT b.cart_prod) as 구매상품품목수
     , SUM(NVL(b.cart_qty,0))    as 총구매수량
FROM member a
    ,cart b
WHERE a.mem_id = b.cart_member(+)
AND a.mem_name = '김은대'
GROUP BY a.mem_id
       , a.mem_name;
 
--김은대씨의 '카트사용횟수, 구매상품 품목 수, 총구매상품수
--'총구매금액'을 출력하시오 (상품 금액은 prod_sale사용)



 SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT b.cart_no)   as 카트사용횟수
     , COUNT(DISTINCT b.cart_prod) as 구매상품품목수
     , SUM(NVL(b.cart_qty ,0))    as 총구매수량
     , SUM(NVL(b.cart_qty * c.prod_sale ,0))    as 총구매금액
FROM member a
    ,cart b
    ,prod c
WHERE a.mem_id = b.cart_member(+)
AND   b.cart_prod = c.prod_id(+)
AND a.mem_name = '김은대'
GROUP BY a.mem_id
       , a.mem_name;
       
-- employees, jobs 테이블을 활용하여 
-- salary가 15000 이상인 직원의 사번, 이름, salary, 직업명을 출력하시오   
SELECT employee_id
      ,emp_name
      ,salary
      ,job_id
FROM employees;
       
SELECT job_id
     , job_title
FROM jobs;

SELECT a.employee_id
      ,a.emp_name
      ,a.salary
      ,b.job_title
FROM employees a
   , jobs b 
WHERE a.job_id = b.job_id
AND a.salary >= 15000;       


       
SELECT a.employee_id   /*사번*/
     , a.emp_name      /*이름*/
     , a.salary        /*봉급*/
     , b.job_title     /*직업명*/
FROM employees a       --직원테이블
   , jobs b            --직업테이블
WHERE a.job_id = b.job_id
AND   a.salary >= 15000;

/* subquery (쿼리안에 쿼리)
    1.스칼라 서브쿼리(select 절)
    2.인라인 뷰 (from절)
    3.중첩쿼리(where절)
*/
-- 스칼라 서브쿼리는 단일행 반환
-- 주의할 점은 메인 쿼리테이블의 행 건수 만큼 조회하기때문에(무거운 테이블을 사용하면 오래걸림)
-- 위와같은 상황에는 조인을 이용하는게 더 좋음.
SELECT a.emp_name
--      ,a.department_id  -- 부서 아이디 대신 부서명이 필요할때 
                        -- 부서아이디는 부서테이블의 pk (유니크함 단일행 반환)
      ,(SELECT department_name 
        FROM departments
        WHERE department_id = a.department_id) as dep_nm
--      , a.job_id   -- 스칼라서브쿼리로 job_title을 출력하시오.
      , (SELECT job_title
         FROM jobs
         WHERE job_id = a.job_id) as job_nm
FROM employees a;

-- 중첩서브쿼리(where절)
-- 직원중 salary 전체평균 보다 높은 직원을 출력하시오 
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees) --6461.831775700934579439252336448598130841
ORDER BY 2 ;

SELECT emp_name, salary
FROM employees
WHERE salary >= 6461.831775700934579439252336448598130841
ORDER BY 2 ;


-- 학생중 '전체평균 평점' 이상인 학생정보만 출력하시오 
SELECT 학번, 이름, 전공, 평점
FROM 학생
WHERE 평점 >= ( SELECT AVG(평점)
                FROM 학생 )
;
-- 평점이 가장 높은 학생의 정보를 출력하시오 
SELECT 학번, 이름, 전공, 평점
FROM 학생
WHERE 평점 = ( SELECT MAX(평점)
                FROM 학생 )
;
-- 수강 이력이 없는 학생의 이름을 출력하시오 
SELECT 이름
FROM 학생
WHERE 학번 NOT IN(SELECT 학번
                  FROM 수강내역)
;
SELECT 이름
FROM 학생
WHERE 학번 NOT IN(2002110110,1997131542,1998131205,2001211121,1999232102,2001110131);

-- 동시에 2개이상의 컬럼 값이 같은 껀 조회
SELECT employee_id
     , emp_name
     , job_id
FROM employees
WHERE (employee_id, job_id ) IN (SELECT employee_id, job_id
                                 FROM job_history);
                                 
                                 
--지역과 각 년도별 대출총잔액을 구하는 쿼리를 작성해 보자.(kor_loan_status)




   SELECT REGION,
       SUM(CASE WHEN PERIOD LIKE '2011%' THEN LOAN_JAN_AMT ELSE 0 END)  AMT_2011,
       SUM(CASE WHEN PERIOD LIKE '2012%'  THEN LOAN_JAN_AMT ELSE 0 END) AMT_2012, 
       SUM(CASE WHEN PERIOD LIKE '2013%'  THEN LOAN_JAN_AMT ELSE 0 END) AMT_2013 
 FROM KOR_LOAN_STATUS
GROUP BY ROLLUP(REGION)
ORDER BY 1;




SELECT 이름
FROM 학생 
WHERE 학번 NOT IN (SELECT 학번
                   FROM 수강내역);
                   
-- EXISTS 존재하는지 체크
-- EXISTS 서브쿼리에 테이블에 검색조건의 데이터가 존재하면
-- 존재하는 데이터에 대해서 메인쿼리에서 조회
SELECT a.department_id
     , a.department_name
FROM departments a
WHERE EXISTS (SELECT 1
                FROM job_history b
                WHERE b.department_id = a.department_id);
                
                
                
SELECT a.department_id
     , a.department_name
FROM departments a
WHERE NOT EXISTS (SELECT 1  -- NOT EXISTS 존재하지 않는
                FROM job_history b
                WHERE b.department_id = a.department_id);

-- 수강이력이 없는 학생을 조회하시오
SELECT *
FROM 학생 a
WHERE NOT EXISTS (SELECT *
                    FROM 수강내역
                    WHERE 학번 = a.학번);
                    
-- 테이블 복사
CREATE TABLE emp_temp AS
SELECT *
FROM employees;

-- UPDATE 문 중첩쿼리 사용
-- 전 사원의 급여를 평균 금액으로 갱신
UPDATE emp_temp
SET salary = (SELECT AVG(salary)
                FROM emp_temp);
ROLLBACK;
SELECT *
FROM emp_temp;
-- 평균 급여보다 많이 받는 사원 삭제
DELETE emp_temp
WHERE salary>=(SELECT AVG(salary)
            FROM emp_temp);
            
--// 미국국립표준협회 ANSI, American National Standards Institute
--FROM 절에 조인조건이 들어감
--inner join을 표준 ANSI JOIN방법으로
SELECT a.학번
     , a.이름
     , b.수강내역번호
FROM 학생 a
INNER JOIN 수강내역 b
ON(a.학번=b.학번);
--과목테이블추가 INNER JOIN
SELECT a.학번
     , a.이름
     , b.수강내역번호
     , c.과목이름
FROM 학생 a
INNER JOIN 수강내역 b
ON(a.학번=b.학번)
INNER JOIN 과목 c
ON(b.과목번호 = c.과목번호);

-- ANSI OUTER JOIN
-- LEFT OUTER JOIN or RIGHT OUTER JOIN
SELECT *
FROM 학생 a
    ,수강내역 b
WHERE a.학번=b.학번(+); -- 일반 outer join

SELECT *
FROM 학생 a
LEFT OUTER JOIN
수강내역 b
ON (a.학번 = b.학번);

-- 매년 국가지역(Americas, Asia)의 총판매금액을 출력하시오
-- sales, customers, countries 테이블 사용
-- 국가는 country_region, 판매금액은 amount_sold
--일반 join 사용 or ANSI join사용
SELECT to_char(a.sales_date, 'YYYY') as years
     , c.country_region
     , SUM(a.amount_sold) 판매금액
FROM SALES a
     ,CUSTOMERS b
     ,COUNTRIES c
WHERE a.cust_id=b.cust_id
AND b.country_id = c.country_id
AND c.country_region IN ('Americas', 'Asia')
GROUP BY to_char(a.sales_date, 'YYYY')
                ,c.country_region_id, c.country_region
ORDER BY 2;

/* MERGE (병합)
    특정 조건에 따라 대상테이블에 대해 INSERT or UPDATE or DELETE를 해야할 때 1개의 SQL로 처리가능*/
-- 과목테이블에 머신러닝 과목이 없으면 INSERT 학점2로 있다면 UPDATE 학점3으로
SELECT MAX(NVL(과목번호, 0)) + 1 FROM 과목;
-- merge 1.대상테이블이 비교 테이블인 경우
MERGE INTO 과목 a
USING DUAL --비교테이블 dual은 대상테이블이 비교테이블일때
ON (a.과목이름 = '머신러닝') -- MATCH조건
WHEN MATCHED THEN
 UPDATE SET a.학점 = 3 -- merge문 insert와 update는 테이블 기입 안함
WHEN NOT MATCHED THEN
INSERT(a.과목번호, a.과목이름, a.학점)
VALUES( (SELECT MAX(NVL(과목번호, 0)) + 1 FROM 과목) ,'머신러닝', 2);

SELECT * from 과목;

-- merge 2.다른 테이블에 ㄷmatch조건이 들어갈 경우
-- (1) 사원테이블에서 관리자 사번 146인 사원번호가 일치하는 직원의 보너스금액을 급여의 1%로 업데이트
-- 사번과 일치하는게 없다면 급여가 8000 미만인 사원만 0.1%로 인서트
CREATE TABLE emp_info(
    emp_id NUMBER
    ,bonus NUMBER default 0
);
INSERT INTO emp_info(emp_id)
SELECT a.employee_id
FROM employees a
WHERE a.emp_name LIKE 'L%';
SELECT * FROM emp_info;

-- 매니저 사번이 146 업데이트 대상건
SELECT a.employee_id, a.salary * 0.01, a.manager_id
FROM employees a
WHERE manager_id = 146
AND a.employee_id IN (SELECT emp_id
                    FROM emp_info);
                    
-- INSERT 대상건
SELECT a.employee_id, a.salary * 0.001, a.manager_id
FROM employees a
WHERE manager_id = 146
AND a.employee_id IN (SELECT emp_id
                    FROM emp_info);
                    
MERGE INTO emp_info a
USING (SELECT employee_id, salary, manager_id
        FROM employees
        WHERE manager_id = 146) b
    ON(a.emp_id = b.employee_id) -- match조건
WHEN MATCHED THEN
    UPDATE SET a.bonus = a.bonus + b.salary * 0.01
WHEN NOT MATCHED THEN
    INSERT (a.emp_id, a.bonus) VALUES (b.employee_id, b.salary * 0.001)
    WHERE (b.salary <8000);
    



