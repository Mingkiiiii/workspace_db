/*
    WITH절 : 별칭으로 사용한 SELECT 문을 다른 SELECT 문에서 별칭으로 참조가능
            - 반복되는 서브쿼리가 있다면 변수처럼 한번 불러와서 사용
            - 복잡한 통계쿼리나 테이블을 탑색할 때 많이 사용
        temp라는 임시 테이블을 사용해서 장시간 걸리는 쿼리의 결과를 저장해놓고
        저장해놓은 데이터를 엑세스하기 때문에 성능이 좋을 수 있음
*/
WITH A AS(  --별칭
        SELECT *
        FROM employees
)
SELECT *
FROM A;

--- 8~14자리, 대문자1, 소문자1, 특수문자1 포함 테스트
WITH test_data AS(
    SELECT 'abcd' AS pw FROM dual UNION ALL
    SELECT 'abcd!A' AS pw FROM dual UNION ALL
    SELECT 'abcdasdfas' AS pw FROM dual UNION ALL
    SELECT 'abcd!1Ad' AS pw FROM dual
)
SELECT pw
FROM test_data
WHERE LENGTH(pw) BETWEEN 8 AND 14
AND REGEXP_LIKE(pw, '[A-Z]')
AND REGEXP_LIKE(pw, '[a-z]')
AND REGEXP_LIKE(pw, '[a-zA-Z0-9가-힣]');
-- 고객중 카트 사용횟수가 가장 많은 고객과 가장적은 고객의 정보를 출력하시오
-- (구매이력이 있는 고객중)
SELECT MAX(cnt) as max_cnt
     , MIN(cnt) as min_cnt
FROM(
SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
FROM member a
    , cart b
WHERE a.mem_id = b.cart_member
GROUP BY a.mem_id, a.mem_name);


SELECT *
FROM ( SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
            FROM member a
                , cart b
            WHERE a.mem_id = b.cart_member
            GROUP BY a.mem_id, a.mem_name)
            WHERE cnt = (SELECT MAX(cnt) as max_cnt
FROM(
        SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
        FROM member a
            , cart b
        WHERE a.mem_id = b.cart_member
        GROUP BY a.mem_id, a.mem_name))
        OR cnt = (SELECT MIN(cnt) as min_cnt
FROM(
        SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
        FROM member a
            , cart b
        WHERE a.mem_id = b.cart_member
        GROUP BY a.mem_id, a.mem_name));



-- 위랑 같음 (WITH절)
WITH T1 AS (SELECT a.mem_id, a.mem_name, count(DISTINCT b.cart_no) cnt
        FROM member a , cart b
        WHERE a.mem_id = b.cart_member
        GROUP BY a.mem_id, a.mem_name
), T2 AS ( SELECT MAX(T1.cnt) as max_cnt, MIN(t1.cnt) as min_cnt
        FROM T1
)
SELECT t1.mem_id, t1.mem_name FROM t1, t2
WHERE t1.cnt = t2.max_cnt
OR t1.cnt = t2.min_cnt;

/*  2000년도 이탈리아의 '연평균 매출액' 보다 큰 '월의 평균 매출액'
    이었던 '년월', '매출액'을 출력하시오  (소수점 반올림)
*/
SELECT cust_id, sales_month, amount_sold
FROM sales;
SELECT cust_id, country_id
FROM customers;
SELECT country_id, country_name
FROM countries;
-- 연평균
SELECT ROUND(AVG(a.amount_sold)) as year_avg
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND a.sales_month LIKE '2000%'
AND c.country_name = 'Italy';
-- 월평균
SELECT a.sales_month,ROUND(AVG(a.amount_sold)) as month_avg
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND a.sales_month LIKE '2000%'
AND c.country_name = 'Italy'
GROUP BY a.sales_month;

SELECT *
    FROM (SELECT a.sales_month,ROUND(AVG(a.amount_sold)) as month_avg
            FROM sales a, customers b, countries c
            WHERE a.cust_id = b.cust_id
            AND b.country_id = c.country_id
            AND a.sales_month LIKE '2000%'
            AND c.country_name = 'Italy'
            GROUP BY a.sales_month
)
WHERE month_avg > (SELECT ROUND(AVG(a.amount_sold)) as year_avg
                        FROM sales a, customers b, countries c
                        WHERE a.cust_id = b.cust_id
                        AND b.country_id = c.country_id
                        AND a.sales_month LIKE '2000%'
                        AND c.country_name = 'Italy');

-----------------------
WITH T1 as (SELECT a.sales_month,a.amount_sold
            FROM sales a, customers b, countries c
            WHERE a.cust_id = b.cust_id
            AND b.country_id = c.country_id
            AND a.sales_month LIKE '2000%'
            AND c.country_name = 'Italy'
)
, T2 as ( SELECT AVG(t1.amount_sold) as year_avg
            FROM t1
)
, T3 as (SELECT t1.sales_month
                ,ROUND(AVG(t1.amount_sold)) as month_avg
                FROM t1
                GROUP BY t1.sales_month
)
SELECT t3.sales_month, t3.month_avg
FROM t2, t3 WHERE t3.month_avg > t2.year_avg;

/* 분석함수 로우손실 없이 집게값을 산출 할 수 있음
   논리적 기준 or 로우순서기준으로 부분집계를 할 수 있음
   (ex 월별 누적합계)
   분석함수 :AVG, SUM, MAX, MIN, COUNT, DENSE_RANK, RANK, LAG...
   PARTITION BY : 그룹
   ORDER BY : 정렬 조건
   WINDOW : 그룹안에 상세한 그룹으로 분할 할 때
*/
-- ROW_NUMBER 그룹별 로우에 대한 순번변환
SELECT department_id, emp_name
     ,ROW_NUMBER() OVER(PARTITION BY department_id
                        ORDER BY emp_name) dep_rownum
FROM employees;

-- 부서별 이름순으로 가장 첫번째 직원을 출력하시오
SELECT *
FROM(
SELECT department_id, emp_name
     ,ROW_NUMBER() OVER(PARTITION BY department_id
                        ORDER BY emp_name) dep_rownum
FROM employees)
WHERE dep_rownum = 1;

-- rank 동일 순위 있을시 건너뜀
-- dense_rank 건너뛰지않음
SELECT department_id, emp_name, salary
     , RANK() OVER(PARTITION BY department_id
                    ORDER BY salary DESC) as rnk
     , DENSE_RANK() OVER(PARTITION BY department_id
                    ORDER BY salary DESC) as dense_rnk
FROM employees;

-- 학생들의 전공별 평점을 기준(내림차순)으로 순위를 출력하시오
SELECT 이름, 전공, 평점
     , RANK() OVER(PARTITION BY 전공
                    ORDER BY 평점 DESC) as 순위
     , RANK() OVER(
                    ORDER BY 평점 DESC) as 전체순위
FROM 학생;


--------------------------------------------------------------------
SELECT emp_name, salary, department_id
     , SUM(salary) OVER (PARTITION BY department_id) as 부서합계
     , SUM(salary) OVER () as 전체합계
FROM employees;

-- 전공별 학생수를 기준으로 순위를 구하시오(학생수 내림차순기준)
SELECT 전공, COUNT(*) as 학생수,
       RANK() OVER (ORDER BY COUNT(*) DESC) as 순위
FROM 학생
GROUP BY 전공;

-- 상품별 총판매금액합계와 순위를 출력하시오
-- 상위 10개 상품명, 합계, 순위 출력 (cart, prod) 테이블 활용
SELECT *
FROM(SELECT 
    a.prod_id, 
    a.prod_name, 
    SUM(a.prod_sale * b.cart_qty) AS 합계,
    RANK() OVER (ORDER BY SUM(a.prod_sale * b.cart_qty) DESC) AS rank
FROM 
    prod a
JOIN 
    cart b ON a.prod_id = b.cart_prod
GROUP BY 
    a.prod_id, a.prod_name
ORDER BY 
    합계 DESC)
WHERE rank<=10;

-- NTILE(expr) 파티션별로 expr에 명시된 값만큼 분할
-- NTILE(3) 1 ~ 3 사이 수를 변환 분할하는 수를 버킷 수라고 함
-- 로우의 건수보다 큰 수를 명시하면 반환되는 수는 무시됨.
SELECT emp_name, department_id
     , NTILE(3) OVER(PARTITION BY department_id
                        ORDER BY salary) as nt
FROM employees
WHERE department_id IN (30, 60);
/*  LAG선행 로우의 값을 가져와서 반환
    LEAD 후행 로우의 값을 가져와서 반환
    주어진 그룹과 순서에 따라 로우에 있는 특정 컬럼의 값을 참조할 때 사용
*/
SELECT emp_name, department_id, salary
     , LAG(emp_name, 1, '가장높음') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) as lag
     , LEAD(emp_name, 1, '가장낮음') OVER(PARTITION BY department_id
                                        ORDER BY salary DESC) as leads
FROM employees
WHERE department_id IN (30, 60);

-- 전공별로 각 학생의 평점보다 한단계 바로 높은 학생과의 평점차이를 출력하시오
SELECT 이름, 전공, 평점
     , LAG(이름, 1, '1등') OVER(PARTITION BY 전공
                                        ORDER BY 평점 DESC) as lag
     , LAG(평점, 1, 평점) OVER(PARTITION BY 전공 ORDER BY 평점 DESC)- 평점 as 평점차이
FROM 학생
GROUP BY 이름,전공, 평점;

/* kor_loan_status 테이블에 있는 데이터를 이용하여
    '연도별' '최종월' 기준 가장 대출이 많이 도시와 잔액을 구하시오
    (1) 년도별로 최종월의 데이터가 다름, 2011은 12월,2012년은 12월, 2013은 11월 ..
        - 연도별 가장큰 월을 구함
    (2) 연도별 최종월을 대상으로 대출 잔액이 가장 큰 금액을 추출
        - 1번과 조인하여 가장 큰 잔액 구함.
    (3) 월별, 지역별 대출잔액과 (2) 결과를 비교해 금액이 같은건을 출력
        - 2와 조인해서 두 금액이 같은 건의 도시와 잔액 출력
*/
SELECT * FROM kor_loan_status;

WITH max_loan AS (
    SELECT period, region, loan_jan_amt,
           RANK() OVER(PARTITION BY period ORDER BY period DESC, loan_jan_amt DESC) as rank
    FROM kor_loan_status
)
SELECT period, region, loan_jan_amt
FROM max_loan
WHERE rank = 1;


