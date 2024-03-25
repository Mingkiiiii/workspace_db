/*
    �������� TRIM
    ����: LTRIM ������: RTRIM ��������
*/
SELECT LTRIM(' ABC ') as ex1
     , RTRIM(' ABC ') as ex2
     , TRIM(' ABC ') as ex3
FROM dual;
/* LPAD, RPAD ä���
   (���, ����, ǥ��)
*/
SELECT LPAD(123,5,'0') as ex1
     , LPAD(1, 5, '0') as ex2
     , LPAD(11235, 5, '0') as ex3
     , LPAD(112352, 5, '0') as ex4 --����� ������ 2��° �Ű����� ����
     , RPAD(2, 5, '*')      as ex5
FROM dual;

/* REPLACE (�ܾ� ��Ȯ�ϰ� ��Ī), TRANSLATE(�ѱ��ھ� ��Ī) ��ȯ*/
SELECT REPLACE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as ex1
     , TRANSLATE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as ex2
FROM dual;
-- LENGTH ���ڿ�����, LENGTHB ���ڿ� ũ��(byte)
SELECT LENGTH('abc1') as ex1 --����, Ư������, ���� 1byte
     , LENGTHB('abc1') as ex2
     , LENGTH('�ؼ�1') as ex3 --utf-8 ���� �ѱ� 3byte
     , LENGTHB('�ؼ�1') as ex4
FROM dual;

SELECT *
FROM member;

/* ������ �ֺ�,�ڿ�����, ȸ����� ȸ���� ����� ����Ͻÿ�
  2500 ���� silver, 2500�ʰ� 5000���� gold, 5000�ʰ� vip*/
SELECT mem_name
     , mem_mileage
     , CASE 
         WHEN mem_mileage <= 2500 THEN 'silver'
         WHEN mem_mileage > 2500 AND mem_mileage <= 5000 THEN 'gold'
         ELSE 'vip' 
       END as mem_grade
       , mem_job
FROM member
WHERE mem_job IN ('�ֺ�', '�ڿ���', 'ȸ���')
ORDER BY mem_mileage DESC;

-- TABLE ���� ALTER
CREATE TABLE ex5_1(
    nm VARCHAR2(100) NOT NULL
    ,point NUMBER(5)
    ,gender CHAR(1)
);
-- �÷��� ����
ALTER TABLE ex5_1 RENAME COLUMN point To user_point;
-- Ÿ�� ����(Ÿ�� ������ ���̺� �����Ͱ� �ִٸ� ���� �ؾ���)
ALTER TABLE ex5_1 MODIFY gender VARCHAR2(1);
-- �������� �߱�
ALTER TABLE ex5_1 ADD CONSTRAINT pk_ex5 PRIMARY KEY (nm);
-- �÷� �߰�
ALTER TABLE ex5_1 ADD create_dt DATE;
-- �÷� ����
ALTER TABLE ex5_1 DROP COLUMN gender;
SELECT * FROM ex5_1;

ALTER TABLE tb_info ADD MBTI VARCHAR2(4);
SELECT *
FROM tb_info;

/* ���� �Լ� (�Ű����� ������)
    ABS: ���밪, ROUND �ݿø� TRUNC ���� CEIL �ø� SQRT ������
    MOD(n,m) m�� n���� �������� �� ������ ��ȯ
*/
SELECT ABS(-10) as ex1
     , ABS(10)  as ex2
     , ROUND(10.5555) as ex3 --default ����
     , ROUND(10.5555,1) as ex4 -- ������ 2° �ڸ����� �ݿø�
     , TRUNC(10.5555, 1) as ex5
     , MOD(4, 2) as ex6
     , MOD(5, 2) as ex7
FROM dual;

/* ��¥ �Լ� */
SELECT SYSDATE
     , SYSTIMESTAMP
FROM dual;
-- ADD MONTH(��¥, 1) ������
-- LAST_DAY ��������, NEXT_DAY(��¥, '����') ������� �ش����
SELECT ADD_MONTHS(SYSDATE, 1) AS ex1
     , ADD_MONTHS(SYSDATE, -1) AS ex2
     , LAST_DAY(SYSDATE) AS ex3
     , NEXT_DAY(SYSDATE, '������') AS ex4
     , NEXT_DAY(SYSDATE, '�����') AS ex5  -- ������ ������̶�� ������ �����
     , NEXT_DAY(SYSDATE, '�ݿ���') AS ex5
FROM dual;
SELECT SYSDATE -1 --<-- 1day ���갡��
     , ADD_MONTHS(SYSDATE, 1) - ADD_MONTHS(SYSDATE,-1) -- ��¥���갡��
FROM dual;
-- �̹����� ���� ���������?
SELECT 'd-day:' || (LAST_DAY(SYSDATE)- SYSDATE) || '��' AS dday
FROM dual;

-- DECODE ǥ����
SELECT DISTINCT cust_name
     , cust_gender
     --����1, true��, false(�׹ۿ�)
     , DECODE(cust_gender, 'M','����', '����') as gender
     -- ����1, true��, ����2, true��, �׹ۿ�)
     , DECODE(cust_gender, 'M', '����','F','����','?') as gender2
FROM customers;

-- member �� ȸ���� ������ ����Ͻÿ�
-- member �������� ������ ����.
-- ȸ���̸�, ������ ���
-- mem_regno2 �� �ֹι�ȣ ���ڸ�
ALTER TABLE member ADD gender VARCHAR2(4);
SELECT * FROM member;
SELECT DISTINCT SUBSTR(mem_regno2,1,1)
FROM member;

SELECT mem_name,
       mem_regno2,
       DECODE(SUBSTR(mem_regno2, 1, 1), '1', '����', '2', '����') AS gender
FROM member;

