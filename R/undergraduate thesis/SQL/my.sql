SET SQL_SAFE_UPDATES = 0;
DROP PROCEDURE IF EXISTS ROWPERROW;
DELIMITER //
CREATE PROCEDURE ROWPERROW()
BEGIN
DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 0;
declare a date;
declare b date;
declare sm float;
declare nm char(7);
SELECT COUNT(1) FROM newrt INTO n;
SET i=0;
WHILE i<n DO 
select comcd1 from newrt limit i, 1 into nm;
select returndt from newrt limit i,1 into a;
select DATE_SUB(a, INTERVAL 1 year) into b;
select sum(wreturn) from newrt where returndt<a and returndt>b and comcd1=nm into sm;
update newrt set sum=sm where comcd1=nm and returndt=a;
SET i = i + 1;
END WHILE;
End//
DELIMITER ;
CALL ROWPERROW();