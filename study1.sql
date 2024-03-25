CREATE TABLE stock (
           code VARCHAR2(10) PRIMARY KEY
         , name VARCHAR2(100)
         , market VARCHAR2(10)
         , marcap NUMBER
         , stocks NUMBER
         , use_yn VARCHAR2(1) DEFAULT 'N'
 );
CREATE TABLE stock_price (
       code VARCHAR2(10)
     , seq NUMBER
     , price NUMBER
     , create_dt DATE DEFAULT SYSDATE
);
CREATE SEQUENCE stock_seq
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 9999999999;
SELECT * FROM stock;
SELECT *
FROM stock
WHERE use_yn = 'Y';

UPDATE stock
SET use_yn = 'Y'
WHERE name LIKE '%한화%';

INSERT INTO stock_price (code, seq, price)
VALUES (:1, NEXTVAL.stock_seq, :2);

SELECT * FROM stock_price;

SELECT a.name, b.price, TO_CHAR(b.create_dt, 'YYYYMMDD HH24:MI:SS') as dt
FROM stock a
    ,stock_price b
WHERE a.code =  b.code
AND a.name = '한화'
ORDER BY b.create_dt DESC;
drop table stock_bbs;
CREATE TABLE stock_bbs (
           code VARCHAR2(10)
         , discussion_id VARCHAR2(20) 
         , title VARCHAR2(200)
         , contents VARCHAR2(4000)
         , read_count NUMBER
         , good_count NUMBER
         , bad_count NUMBER
         , comment_count NUMBER
         , create_dt DATE
         , update_dt DATE DEFAULT SYSDATE
         , constraint stock_bbs_PK primary key(code, discussion_id)
 );
 
INSERT INTO test1 (code, discussion_id, title, contents, read_count, good_count, bad_count, comment_count, create_dt, update_dt)
VALUES ('1','1','제목1','내용1',0,0,0,0,SYSDATE, SYSDATE);
INSERT INTO test2 (code, discussion_id, title, contents, read_count, good_count, bad_count, comment_count, create_dt, update_dt)
VALUES ('1','1','제목1','내용1',10,0,0,0,SYSDATE, SYSDATE);

select * from test2;



MERGE INTO test1 a
USING (SELECT * FROM test2) b
ON (a.code = b.code AND a.discussion_id = b.discussion_id)
WHEN MATCHED THEN
    UPDATE SET a.read_count = b.read_count,
               a.good_count = b.good_count,
               a.bad_count = b.bad_count,
               a.comment_count = b.comment_count
WHEN NOT MATCHED THEN
    INSERT (code, discussion_id, title, contents, read_count, good_count, bad_count, comment_count, create_dt, update_dt)
    VALUES (b.code, b.discussion_id, b.title, b.contents, b.read_count, b.good_count, b.bad_count, b.comment_count, b.create_dt, b.update_dt);


select * from test1;


// 찐
MERGE INTO stock_bbs a
USING dual
ON (a.code =:1 AND a.discussion_id =: 12)
WHEN MATCHED THEN
    UPDATE SET a.read_count = :3,
               a.good_count = :4,
               a.bad_count = :5,
               a.comment_count = :6
WHEN NOT MATCHED THEN
    INSERT (a.code, a.discussion_id, a.read_count, a.good_count, a.bad_count, a.comment_count, a.title, a.contents, a.create_dt)
    VALUES (:1,:2,:3,:4,:5,:6,:7,:8, to_date(:9, 'YYYY-MM-DD HH24:MI:SS'));

select * from stock_bbs;