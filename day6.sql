/*  집계함수 대상 데이터를 특정 그룹으로 묶은 다음 
    그룹에 대한 총합, 평균, 최댓값, 최솟값 등을 구하는 함수.
*/
SELECT COUNT(*)    --null포함
     , COUNT(department_id) --default ALL
     , COUNT(ALL department_id) -- 중복포함, null X
     , COUNT(DISTINCT department_id) -- 중복제거
     , COUNT(employee_id)
FROM employees;

SELECT COUNT(mem_id)
     , COUNT(*)
FROM member;
SELECT SUM(salary) as 합계
     , ROUND(AVG(salary)) as 평균
     , MAX(salary) as 최대
     , MIN(salary) as 최소
     , COUNT(employee_id) as 직원수
--     employee_id 집계함수 빼고는 사용불가능(오류)
FROM employees;
--부서별 집계 <-- 그룹의 대상 부서
SELECT department_id
     , SUM(salary) as 합계
     , ROUND(AVG(salary)) as 평균
     , MAX(salary) as 최대
     , MIN(salary) as 최소
     , COUNT(employee_id) as 직원수
FROM employees
GROUP BY department_id
ORDER BY 1;
-- 30,60,90 부서의 집계
SELECT department_id
     , SUM(salary) as 합계
     , ROUND(AVG(salary)) as 평균
     , MAX(salary) as 최대
     , MIN(salary) as 최소
     , COUNT(employee_id) as 직원수
FROM employees
WHERE department_id IN(30, 60, 90)
GROUP BY department_id
ORDER BY 1;


-- member 회원의 직업별 마일리지의 합계, 평균, 최대, 최소 값과 회원수를 출력하시오
SELECT mem_job
    , SUM(mem_mileage) as 마일리지합계
    , ROUND(AVG(mem_mileage)) as 평균
    , MAX(mem_mileage) as 최대
    , MIN(mem_mileage) as 최소
    , COUNT(mem_mileage) as 회원수
FROM member
GROUP BY mem_job
ORDER BY 4 DESC;

-- kor_loan_status 테이블에 loan_jan_amt 컬럼을 활용하여
-- 2013년도 기간별 총 대출 잔액을 출력하시오
SELECT *
FROM kor_loan_status;

SELECT period
     , SUM(loan_jan_amt) AS 총잔액
FROM kor_loan_status
WHERE PERIOD BETWEEN '20130101' AND '20131231'
GROUP BY period
ORDER BY 1;

-- 기간별, 지역별, 대출 총합계를 출력하시오
SELECT period
     , region
     , SUM(loan_jan_amt) as 합계
FROM kor_loan_status
GROUP BY period, region
ORDER BY 1;
-- 년도별, 지역별 대출합계
SELECT SUBSTR(period, 1, 4) as 년도
     , region
     , SUM(loan_jan_amt) as 합계
FROM kor_loan_status
GROUP BY SUBSTR(period, 1, 4), region
ORDER BY 1;


-- employees 직원들의  입사년도(hire_date)별 직원수를 출력하시오
SELECT TO_CHAR(hire_date, 'YYYY') as 년도
     , COUNT(*) as 직원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY 년도;

-- 집계 데이터에 대해서 검색조건을 사용하려면 HAVING 사용
-- 입사직원이 10명 이상인 년도에 직원수 출력
SELECT TO_CHAR(hire_date, 'YYYY') as 년도
     , COUNT(*) as 직원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
HAVING COUNT(*) >= 10
ORDER BY 년도;

/* member 테이블을 활용하여 직업별 마일리지 평균금액을 구하시오
   (소수점 2째 자리까지 반올림하여 출력)
   (1) 정렬 평균마일리지 내림차순
   (2) 평균 마일리지가 3000이상인 데이터만 출력
*/


SELECT mem_job, ROUND(AVG(mem_mileage), 2) AS 평균마일리지
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000
ORDER BY AVG(mem_mileage) DESC;


-- customers 회원의 전체 회원수, 남자 회원수, 여자 회원수를 출력하시오
SELECT 
    COUNT(*) AS 전체회원수,
    SUM(CASE WHEN cust_gender = 'M' THEN 1 ELSE 0 END) AS 남자회원수,
    SUM(CASE WHEN cust_gender = 'F' THEN 1 ELSE 0 END) AS 여자회원수
FROM 
customers;



