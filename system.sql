--���� �ּ�
/*
�ּ�����
*/
--��������� 11g���� ���� ������ Ư�� ��Ÿ����
--��Ģ�� ���Ѿ��ϴµ� ���� ��Ÿ�Ϸ� ������� �Ʒ� ��ɾ �����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
--�������� ������:java ��й�ȣ oracle
CREATE USER java IDENTIFIED BY oracle;
--���� ���� �� �⺻ ������ �ο�
GRANT CONNECT, RESOURCE TO java;
--���̺� �����̽� ���� ����
GRANT UNLIMITED TABLESPACE TO java;