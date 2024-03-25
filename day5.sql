/*��ȯ�Լ�(Ÿ��)
    TO_CHAR ����������
    TO_DATE ��¥������
    TO_NUMBER ����������
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
     , TO_CHAR(SYSDATE, 'd') as ex10 -- ���ϰ��� �Ͽ��Ϻ��� ���� �Ͽ�ȭ���� (5)
FROM dual;
SELECT TO_DATE('231229', 'YYMMDD') as ex1
     , TO_DATE('2023 12 29 09:10:00', 'YYYY MM DD HH24:MI:SS') as ex2
     , TO_DATE('25', 'YY') as ex3
     , TO_DATE('45', 'YY') as ex4
     -- RR�� ���⸦ �ڵ����� ����
     -- 50 ->1950
     -- 49->2049 (Y2K 2000�� ����)�� ���� ����å���� ���Ե�
     , TO_DATE('50', 'RR') as ex5
FROM dual;
CREATE TABLE ex5_2(
    title VARCHAR2(100)
    ,d_day DATE
);
INSERT INTO ex5_2 VALUES ('������', '20240614');
INSERT INTO ex5_2 VALUES ('������', '2024.06.14');
INSERT INTO ex5_2 VALUES ('������', '2024/06/14');
INSERT INTO ex5_2 VALUES ('������', '2024 06 14');
INSERT INTO ex5_2 VALUES ('������', TO_DATE('2024 06 14 09', 'YYYY MM DD HH24'));
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
-- member ȸ���� ��������� �̿��Ͽ� ���̸� ����Ͻÿ�
-- ���س⵵�� �̿��Ͽ� (ex 2021 - 2000 = 21��)
SELECT *
FROM member;

SELECT mem_name,mem_bir,
       TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(TO_CHAR(mem_bir, 'YYYY'))||'��' AS age
FROM member
ORDER BY age DESC;

/*
�� ���̺�(CUSTOMERS)����
���� ����⵵(cust_year_of_birth) �÷��� �ִ�.
������ �������� �� �÷��� Ȱ���� 30��,40��,50�븦 ������ ����ϰ�,
������ ���ɴ�� '��Ÿ'�� ����ϴ� ������ �ۼ��غ���.
*/
SELECT DISTINCT
    cust_name, 
    cust_year_of_birth,
    (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) AS age,
    CASE
        WHEN (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) BETWEEN 30 AND 39 THEN '30��'
        WHEN (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) BETWEEN 40 AND 49 THEN '40��'
        WHEN (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) BETWEEN 50 AND 59 THEN '50��'
        ELSE '��Ÿ'
    END AS age_group
FROM 
customers;


