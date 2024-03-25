/*
    ���� ǥ���� (Regular Expression)
    oracle 10g ���� ��밡�� REGEXP_ <- �� ����ϴ� �Լ�
    .(dot) or [] �� ��� ���� 1���ڸ� �ǹ���
    ^ ���� $�� [^] <-- ���ȣ �ȿ��� not �ǹ�
    
    �ݺ������� * : 0�� �̻�, + : 1���̻� ?:0,1��
            [n]: n��, [n,] : n���̻�, [n,m]: n���̻� m������
    REGEXP_LIKE: ���Խ� ���ϰ˻�

*/
SELECT *
FROM member
WHERE REGEXP_LIKE(mem_comtel, '^..-'); --like �Լ��� ���Խ��ε� ^�� ���� ..�� �α���- �̴ϱ� ����2��-�� ���Ե� �ڷḦ ��Ÿ��(mem_comtel) ^�� �Ⱥ��̸�042�� ����
-- MEM_MAIL �� �������� �����ڷ� �����ϰ� 3~5�ڸ� �̸��� �ּ���������
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE(mem_mail, '^[a-zA-Z]{3,5}@');
-- MEM_ADD2 �ּҿ��� ���� ���⹮�� ������ �����ϼ���
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '. .');
-- �ѱ� ������� ��������
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[��-��] [0-9]');
-- �ѱ۷� ������ ���� ����
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[��-��]$');
-- �ѱ۸� �ִ� �ּҰ˻�
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[��-��]+$');
-- �ѱ��� ���� �ּҰ˻�
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[^��-��]+$');

SELECT mem_add2
FROM member
WHERE NOT REGEXP_LIKE(mem_add2, '[��-��]');
-- | : �Ǵ�, () :���ϱ׷�
--J�� �����ϸ�, ����°���ڰ� m or n�� ������ �̸���ȸ
SELECT emp_name
FROM employees
WHERE REGEXP_LIKE(emp_name, '^J.(n|m)');
-- REGEXP_SUBSTR ����ǥ���� ���ϰ� ��ġ�ϴ� ���ڿ��� ��ȯ
-- �̸��� @�� �������� �հ� �ڸ� ����Ͻÿ�
SELECT mem_mail
     , REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 1) as ���̵�
     , REGEXP_SUBSTR(mem_mail, '[^@]+', 1, 2) as ������
FROM member;

SELECT REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 1) as ex1
     , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 2) as ex2
     , REGEXP_SUBSTR('A-B-C', '[^-]+', 1, 3) as ex3
FROM dual;
-- ������ �������� ù��° �ܾ� ���
SELECT mem_add1
     , REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 1)   -- �Ű����� 3,4 ����Ʈ 1
FROM member;
-- �߰��ܾ� ��� (������ ������ null)
SELECT mem_add1
     , REGEXP_SUBSTR(mem_add1, '[^ ]+', 1, 2)   -- �Ű����� 3,4 ����Ʈ 1
FROM member;
-- REGEXP_REPLACE ��� ���ڿ����� ���� ǥ���� ������ �����Ͽ� �ٸ� �������� ��ü
-- Ellen Hildi Smith -> Smith, Ellen Hildi
SELECT REGEXP_REPLACE('Ellen Hildi Smith', '(.*) (.*) (.*)','\3,\1\2') as smith
FROM dual;
-- ���� 2�ڸ� �̻��� ã�Ƽ� 1�ڸ��� ��ü
SELECT REGEXP_REPLACE('Joe       Smith    Hi', '( ){2,}', ' ')
FROM dual;

-- ������ �ּҵ��� ��� ������ ����Ͻÿ�
SELECT mem_add1
     , REGEXP_REPLACE(mem_add1, '(������|����������) (,*)', '���� \2') as �ּ�
FROM member
WHERE mem_add1 LIKE '%����%'
AND mem_id != 'p001';

-- ��ȭ��ȣ ���ڸ����� ������ ��ȣ�� �ݺ��Ǵ� ����� ��ȸ
-- �� ǥ��� \w = [a-zA-z0-9], \d = [0-9]
SELECT emp_name, phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number, '(\d\d)\1$'); -- \1�� ù��° ĸó �׷��� �ٽ�����
                                              -- �� ������ ��Ī�� ���ڸ� ���ڿ� ��Ȯ��
                                              -- ��ġ�� ���ڸ� ���ڸ� �ǹ���
                                              



