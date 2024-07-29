/*
제목: 기본 함수 익히기
작성: 이장래
내용: 기본 함수 사용 방법 학습

[주의]
- 비슷한 기능의 함수끼리 묶어 정리(이름순이 아님)
- 버전에 따라 차이가 있을 수 있음
- MS SQL Server, ORACLE 역시 버전에 따라 다를 수 있음
- 그러므로 본인이 사용하는 버전에 대한 확인을 권고함
*/


/*
1. 문자열 관련 함수
*/

-- 1) LENGTH() - 문자열 바이트 수 반환

SELECT LENGTH('홍길동'); -- 9

SELECT vacation_id, emp_id, begin_date, reason
    FROM vacation;
    
SELECT vacation_id, emp_id, begin_date, reason, LENGTH(reason) AS reason_len 
    FROM vacation;
    
-- [MSSQL] DATALENGTH('홍길동') --> 6
-- [ORACLE] LENGTHB('홍길동') --> 9


-- 2) CHAR_LENGTH() - 문자열에 포함된 문자 개수 반환
SELECT CHAR_LENGTH('홍길동'); -- 3

SELECT vacation_id, emp_id, begin_date, reason
    FROM vacation;
    
SELECT vacation_id, emp_id, begin_date, reason, CHAR_LENGTH(reason) AS reason_chr_len 
    FROM vacation;
    
-- [MSSQL] LEN('홍길동') --> 3
-- [ORACLE] LENGTH('홍길동') --> 3


-- 3) CONCAT() - 모든 값을 연결한 하나의 문자열 반환

SELECT CONCAT('ABC', 'DEF', 'HIJ', 'KLMN'); -- ABCDEFHIJKLMN

SELECT vacation_id, emp_id, begin_date, reason, duration
    FROM vacation;
    
SELECT vacation_id, emp_id, begin_date, CONCAT(reason, '(', duration, '일간)') AS reason
    FROM vacation;
    
-- [MSSQL] 동일
-- [ORACLE] CONCAT(CONCAT(CONCAT('ABC', 'DEF'), 'HIJ'), 'KLMN') 또는 'ABC' || 'DEF' || 'HIJ' || 'KLMN'


-- 4) CONCAT_WS() - 구분자를 사용해 모든 값을 연결한 하나의 문자열 반환

SELECT CONCAT_WS(',', 'ABC', 'DEF', 'HIJ', 'KLMN'); -- ABC,DEF,HIJ,KLMN

SELECT vacation_id, emp_id, begin_date, end_date, reason, duration
    FROM vacation;
    
SELECT vacation_id, emp_id, CONCAT_WS(', ', begin_date, end_date, reason, duration) AS info
    FROM vacation;
    
-- [MSSQL] 동일
-- [ORACLE] N/A


-- 5) ELT() - 나열된 값 중에서 지정한 위치의 값 반환

SELECT ELT(3, '나', '너', '우리', '우리나라'); -- 우리

SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       NTILE(3) OVER(ORDER BY salary DESC) AS grp
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       ELT(NTILE(3) OVER(ORDER BY salary DESC), '상', '중', '하') AS grp
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- [MSSQL] CHOOSE()
-- [ORACLE] N/A


-- 6) FILED() - 나열된 값 중에서 지정한 값이 있는 위치 반환, 없으면 0 반환

SELECT FIELD('우리', '나', '너', '우리', '우리나라'); -- 3
SELECT FIELD('대한민국', '나', '너', '우리', '우리나라'); -- 0

SELECT emp_name, emp_id, dept_id, hire_date, salary
    FROM employee
    WHERE dept_id IN ('MKT', 'SYS', 'HRD');
    
SELECT emp_name, emp_id, dept_id, hire_date, salary
    FROM employee
    WHERE dept_id IN ('MKT', 'SYS', 'HRD')
    ORDER BY FIELD(dept_id, 'MKT', 'HRD', 'SYS');

-- [MSSQL, ORACLE] CASE 문 사용
/*
SELECT emp_name, emp_id, dept_id, hire_date, salary
    FROM employee
    WHERE dept_id IN ('MKT', 'SYS', 'HRD')
    ORDER BY CASE dept_id WHEN 'MKT' THEN 1
                          WHEN 'HRD' THEN 2
                          ELSE 3 END;
*/


-- 7) INSTR() - 문자열에서 지정한 문자열이 나타나는 위치 반환, 없으면 0 반환

SELECT INSTR('우리나라 좋은 나라 대한민국', '나라'); -- 3
SELECT INSTR('우리나라 좋은 나라 대한민국', '좋은'); -- 6
SELECT INSTR('우리나라 좋은 나라 대한민국', '국가'); -- 0

SELECT vacation_id, emp_id, begin_date, reason
    FROM vacation;
    
SELECT vacation_id, emp_id, begin_date, reason, INSTR(reason, '이') AS cnt
    FROM vacation
    WHERE INSTR(reason, '이') > 0;
    
-- [MSSQL]
/*
SELECT CHARINDEX('나라', '우리나라 좋은 나라 대한민국'); -- 3
SELECT CHARINDEX('국가', '우리나라 좋은 나라 대한민국'); -- 0
*/

-- [ORACLE] 
/*
SELECT INSTR('우리나라 좋은 나라 대한민국', '나라') FROM DUAL; -- 3
SELECT INSTR('우리나라 좋은 나라 대한민국', '국가') FROM DUAL; -- 0

-- 5번 째 글자부터 찾기
SELECT INSTR('우리나라 좋은 나라 대한민국', '나라', 5) FROM DUAL; -- 9

-- 같은 값이 여럿이면 두 번째 값 가져오기
SELECT INSTR('우리나라 좋은 나라 대한민국', '나라', 1, 2) FROM DUAL; -- 9
*/

-- 8) LOCATE() - 문자열에서 지정한 문자열이 나타나는 위치 반환, 없으면 0 반환

SELECT LOCATE('나라', '우리나라 대한민국'); -- 3
SELECT LOCATE('너', '우리나라 대한민국'); -- 0

SELECT vacation_id, emp_id, begin_date, reason
    FROM vacation;
    
SELECT vacation_id, emp_id, begin_date, reason, LOCATE('이', reason) AS cnt
    FROM vacation
    WHERE LOCATE('이', reason) > 0;
    
-- [MSSQL] CHARINDEX()
-- [ORACLE] INSTR()


/*
- INSTR(str, substr)는 인수 순서가 str 먼저, substr 나중
- LOCATE(substr, str, [start])는 인수 순서가 substr 먼저, str 나중
	또한 start 매개변수를 사용하여 검색 시작 위치를 지정할 수 있습니다.
*/


-- 9) LEFT() - 왼쪽부터 지정한 길이 만큼의 문자열 반환

SELECT LEFT('가나다라마바사아', 5); -- 가나다라마

SELECT emp_name, emp_id, dept_id, gender, email
    FROM employee
    WHERE retire_date IS NULL;
    
SELECT emp_name, emp_id, dept_id, gender, CONCAT(LEFT(email, 2), 'xx@xxxx.xxx') AS email
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL] 동일
-- [ORACLE] SUBSTR('가나다라마바사아', 1, 5)


-- 10) RIGHT() - 오른쪽부터 지정한 길이 만큼의 문자열 반환

SELECT RIGHT('가나다라마바사아', 5); -- 라마바사아

SELECT emp_name, emp_id, dept_id, gender, phone
    FROM employee
    WHERE retire_date IS NULL;
    
SELECT emp_name, emp_id, dept_id, gender, CONCAT('xxx-xxxx-', RIGHT(phone, 4)) AS phone
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL] 동일
-- [ORACLE] SUBSTR('가나다라마바사아', -5, 5) 


-- 11) SUBSTR() - 지정한 위치에서 지정한 길이 만큼의 문자열 반환 

SELECT SUBSTR('아름다운 대한민국', 6, 2); -- 대한
SELECT SUBSTRING('아름다운 대한민국', 6, 2); -- 대한
SELECT MID('아름다운 대한민국', 6, 2); -- 대한

SELECT emp_name, emp_id, dept_id, gender, phone
    FROM employee
    WHERE retire_date IS NULL;
    
SELECT emp_name, emp_id, dept_id, gender, CONCAT('xxx-', REPLACE(SUBSTR(phone, INSTR(phone, '-') + 1, 4), '-', ''), '-xxxx') AS phone
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL] SUBSTRING()
-- [ORACLE] SUBSTR()


-- 12) UPPER() - 모든 문자를 대문자로 바꾼 문자열 반환

SELECT UPPER('I have a Dream.'); -- I HAVE A DREAM.

SELECT emp_name, emp_id, dept_id, gender, email, UPPER(email) AS new_email
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL, ORACLE] 동일
-- [ORACLE] INITCAP() - 첫 글자만 대문자, 나머지는 모두 소문자로 변경


-- 13) LOWER() - 모든 문자를 소문자로 바꾼 문자열 반환

SELECT LOWER('I have a Dream.'); -- i have a dream.

SELECT emp_name, emp_id, LOWER(dept_id) AS dept_id, LOWER(gender) AS gender, email
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL, ORACLE] 동일


-- 14) LPAD() - 지정한 길이의 문자열이 되도록 왼쪽에 지정한 문자를 채워 반환

SELECT LPAD('대한민국', 10, '*'); -- ******대한민국
SELECT LPAD(123, 10, '_'); -- _______123

SELECT emp_name, emp_id, dept_id, gender, email
    FROM employee
    WHERE retire_date IS NULL;
    
SELECT emp_name, emp_id, dept_id, gender, LPAD(email, 30, '_') AS chk_email
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL] RIGHT('**********' + '대한민국', 10) --> ******대한민국
-- [ORACLE] LPAD('대한민국', 10, '*') --> **대한민국


-- 15) RPAD() - 지정한 길이의 문자열이 되도록 오른쪽에 지정한 문자를 채워 반환

SELECT RPAD('대한민국', 10, '*'); -- 대한민국******

SELECT emp_name, emp_id, dept_id, gender, email
    FROM employee
    WHERE retire_date IS NULL;
    
SELECT emp_name, emp_id, dept_id, gender, RPAD(email, 30, '_') AS chk_email
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL] LEFT('대한민국' + '**********', 10) --> 대한민국******
-- [ORACLE] RPAD('대한민국', 10, '*') --> 대한민국**


-- 16) LTRIM() - 왼쪽에 있는 공백을 없앤 문자열 반환

SELECT CONCAT('[', LTRIM('   대한민국   '), ']'); -- [대한민국   ]

SELECT * FROM employee;

ALTER TABLE employee
    MODIFY COLUMN eng_name varchar(20) NULL;
    
UPDATE employee
    SET eng_name = CONCAT(' ', eng_name, '  ');

SELECT emp_id, CONCAT(emp_name, '(', eng_name, ')') AS emp_name, dept_id, gender, hire_date
    FROM employee
    WHERE eng_name IS NOT NULL;

SELECT emp_id, CONCAT(emp_name, '(', LTRIM(eng_name), ')') AS emp_name, dept_id, gender, hire_date
    FROM employee
    WHERE eng_name IS NOT NULL;
    
    
-- [MSSQL, ORACLE] 동일


-- 17) RTRIM() - 오른쪽에 있는 공백을 없앤 문자열 반환

SELECT CONCAT('[', RTRIM('   대한민국   '), ']'); -- [   대한민국]

SELECT emp_id, CONCAT(emp_name, '(', RTRIM(eng_name), ')') AS emp_name, dept_id, gender, hire_date
    FROM employee
    WHERE eng_name IS NOT NULL;
    
-- [MSSQL, ORACLE] 동일


-- 18) TRIM() - 양쪽에 있는 공백을 없앤 문자열 반환

SELECT CONCAT('[', TRIM('   대한민국   '), ']'); -- [대한민국]

SELECT emp_id, CONCAT(emp_name, '(', TRIM(eng_name), ')') AS emp_name, dept_id, gender, hire_date
    FROM employee
    WHERE eng_name IS NOT NULL;
    
-- [MSSQL, ORACLE] 동일


-- 19) REPLACE() - 문자열의 특정 문자열을 다른 문자열로 바꾼 문자열 반환

SELECT REPLACE('우리나라 대한민국', ' ', ''); -- 우리나라대한민국

SELECT emp_id, emp_name, dept_id, gender, hire_date, email
    FROM employee
    WHERE retire_date IS NULL;
    
SELECT emp_id, emp_name, dept_id, gender, hire_date, REPLACE(email, '@d-friends.co.kr', '') AS email_id
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL, ORACLE] 동일


-- 20) REPEAT() - 문자열을 지정한 횟수 만큼 반복한 문자열 반환

SELECT REPEAT('만세!', 3); -- 만세!만세!만세!

SELECT emp_id, emp_name, dept_id, gender, salary
    FROM employee
    WHERE retire_date IS NULL;
    
SELECT emp_id, emp_name, dept_id, gender, REPEAT('▒', salary / 250) AS salary
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL] REPLICATE()
-- [ORACLE] N/A


-- 21) REVERSE() - 문자열을 앞뒤로 뒤집은 문자열 반환

SELECT REVERSE('쓰레기통'); -- 통기레쓰

SELECT emp_id, emp_name, dept_id, gender, hire_date, phone
    FROM employee
    WHERE retire_date IS NULL;
    
SELECT emp_id, emp_name, dept_id, gender, hire_date, phone, REVERSE(REPLACE(SUBSTR(phone, 3, 100), '-', '')) AS phone
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL] 동일
-- [ORACLE] N/A


-- 22) SPACE() - 지정한 길이 만큼을 공백으로 채운 문자열 반환★

SELECT CONCAT('너', SPACE(10), '나'); -- 너          나

SELECT CONCAT(emp_name, '  ', '님') AS emp_name, emp_id, dept_id, gender, hire_date, phone
    FROM employee
    WHERE retire_date IS NULL;

SELECT CONCAT(emp_name, SPACE(2), '님') AS emp_name, emp_id, dept_id, gender, hire_date, phone
    FROM employee
    WHERE retire_date IS NULL;
    
-- [MSSQL] 동일
-- [ORACLE] RPAD(' ', 10)



/*
2. 날짜/시간 관련 함수
*/

-- 23) ADDTIME() - 지정한 시간 만큼 더해진 날짜와 시간 반환

SELECT ADDTIME('2023-12-25 09:00:00', '35:30:40'); -- 2023-12-26 20:30:40

-- [MSSQL] DATEADD(HOUR, 1, '2023-12-25 09:00:00')
-- [ORACLE] TO_CHAR(TO_DATE('2023-12-25 09:00:00', 'YYYY-MM-DD HH:MI:SS') + 1/24, 'YYYY-MM-DD HH:MI:SS')


-- 24) SUBTIME() - 지정한 시간 만큼 빼진 날짜와 시간 반환

SELECT SUBTIME('2023-12-25 09:00:00', '01:30:40'); -- 2023-12-25 07:29:20
SELECT SUBTIME('2023-12-25 09:00:00', '35:30:40'); -- 2023-12-23 21:29:20

-- [MSSQL] DATEADD(HOUR, -1, '2022-12-25 09:00:00')
-- [ORACLE] TO_CHAR(TO_DATE('2022-12-25 09:00:00', 'YYYY-MM-DD HH:MI:SS') + -1/24, 'YYYY-MM-DD HH:MI:SS')


-- 25) ADDDATE() -- 지정한 수 만큼 날이 더해진 날짜와 시간 반환

SELECT ADDDATE('2023-12-25 09:00:00', INTERVAL 15 DAY); -- 2024-01-09 09:00:00

-- [MSSQL] DATEADD(DAY, 1, '2023-12-25 09:00:00')
-- [ORACLE] TO_CHAR(TO_DATE('2023-12-25 09:00:00', 'YYYY-MM-DD HH:MI:SS') + 1, 'YYYY-MM-DD HH:MI:SS')


-- 26) SUBDATE() -  지정한 수 만큼 날이 빼진 날짜와 시간 반환

SELECT SUBDATE('2023-12-25 09:00:00', INTERVAL 15 DAY); -- 2022-12-10 09:00:00

-- [MSSQL] DATEADD(DAY, -1, '2023-12-25 09:00:00')
-- [ORACLE] TO_CHAR(TO_DATE('2023-12-25 09:00:00', 'YYYY-MM-DD HH:MI:SS') - 1, 'YYYY-MM-DD HH:MI:SS')


-- 27) CURDATE() - 현재 날짜 반환

SELECT CURDATE();

-- [MSSQL] CONVERT(date, GETDATE())
-- [ORACLE] TO_CHAR(SYSDATE, 'YYYY-MM-DD')


-- 28) CURTIME() - 현재 시간 반환

SELECT CURTIME();

-- [MSSQL] CONVART(time, GETDATE())
-- [ORACLE] TO_CHAR(SYSDATE, 'HH24:MI:SS')


-- 29) NOW() - 현재 날짜와 시간 반환

SELECT NOW();

-- [MSSQL] GETDATE()
-- [ORACLE] SYSDATE, CURRENT_TIMESTAMP. LOCALTIMESTAMP


-- 30) SYSDATE() - 현재 날짜와 시간 반환

SELECT SYSDATE(); 

-- [MSSQL] GETDATE()
-- [ORACLE] SYSDATE

-- NOW()는 서버의 현재 날짜와 시간을 반환하는 반면에 SYSDATE()는 클라이언트의 현재 날짜와 시간을 반환


-- 31) YEAR() - 지정한 날짜의 년 반환

SELECT YEAR(NOW()); 

-- [MSSQL] 동일
-- [ORACLE] EXTRACT(YEAR FROM SYSDATE), TO_CHAR(SYSDATE, 'YYYY')


-- 32) QUARTER() - 지정한 날짜의 분기 반환

SELECT QUARTER(NOW()); 

-- [MSSQL] DATEPART(QUARTER, GETDATE()), DATENAME(QUARTER, GETDATE())
-- [ORACLE} TO_CHAR(SYSDATE, 'Q')


-- 33) MONTH() - 지정한 날짜의 월 반환

SELECT MONTH(NOW());

-- [MSSQL] 동일
-- [ORACLE] EXTRACT(MONTH FROM SYSDATE), TO_CHAR(SYSDATE, 'MM')


-- 34) DAY() - 지정한 날짜의 일 반환

SELECT DAY(NOW()); 

-- [MSSQL] 동일
-- [ORACLE] EXTRACT(DAY FROM SYSDATE), TO_CHAR(SYSDATE, 'DD')


-- 35) DATE() - 지정한 날짜와 시간에서 날짜만 반환

SELECT DATE(NOW()); 

-- [MSSQL] CONVERT(date, GETDATE())
-- [ORACLE] TO_CHAR(SYSDATE, 'YYYY-MM-DD')


-- 36) TIME() -- 지정한 날짜와 시간에서 시간만 반환

SELECT TIME(NOW()); 

-- [MSSQL] CONVERT(time, GETDATE())
-- [ORACLE] TO_CHAR(SYSDATE, 'HH24:MI:SS')


-- 37) DATEDIFF() - 두 날짜와 시간의 일수 차이 반환

SELECT DATEDIFF('2024-12-25 00:00:00', NOW()); -- 165


-- [MSSQL]  DATEDIFF(DAY, GETDATE(), '2023-12-25 00:00:00')
-- [ORACLE] TO_DATE('2024-12-25', 'YYYY-MM-DD') - SYSDATE


-- 38) DAYOFWEEK() - 지정한 날짜의 요일 반환

SELECT DAYOFWEEK(NOW()); -- 일요일: 1 ~ 토요일: 7

-- [MSSQL] DATEPART(WEEKDAY, GETDATE()), DATENAME(WEEKDAY, GETDATE()) -- 5, Friday
-- [ORACLE] TO_CHAR(SYSDATE, 'd'), TO_CHAR(SYSDATE, 'day') -- 5, Friday


-- 39) DATE_FORMAT() - 날짜를 지정한 형태의 문자열로 반환

SELECT DATE_FORMAT(NOW(), '%Y-%m-%d'); 
SELECT DATE_FORMAT(NOW(), '%Y.%m.%d'); 
SELECT DATE_FORMAT(NOW(), '%Y/%m/%d'); 
SELECT DATE_FORMAT(NOW(), '%Y%m%d');
SELECT DATE_FORMAT(NOW(), '%Y년%m월%d일'); 

-- [MSSQL] CONVERT(varchar(10), GETDATE(), 옵션), FORMAT(GETDATE(), 'yyyy-MM-dd')
-- [ORACLE] TO_CHAR(SYSDATE, 'YYYY/MM/DD')



/*
3. 숫자 관련 함수 
*/

-- 40) FORMAT() - 천 단위 콤마를 갖는 문자열 반환

SELECT FORMAT(112345.7890, 2); -- 112,345.79 소수점 이하 2자리까지 표시하고 쉼표로 천 단위를 구분하여 반환

-- [MSSQL] FORMAT(112345.7890, '#,0.00')
-- [ORACLE] TO_CHAR(112345.7890,'FM999G999G999G999D00')

SELECT emp_name, emp_id, dept_id, gender, hire_date, FORMAT(salary, 0) AS salary
    FROM employee
    WHERE retire_date IS NULL;
    
    
-- 41) ABS() - 절대값 반환

SELECT ABS(-30); -- 30

-- [MSSQL, ORACLE] 동일


-- 42) CEILING() - 지정한 수 보다 큰 가장 작은 정수 반환

SELECT CEILING(15.4); -- 16

-- [MSSQL] 동일
-- [ORACLE] CEIL()


-- 43) FLOOR() - 지정한 수 보다 작은 가장 큰 정수 반환

SELECT FLOOR(15.7); -- 15

-- [MSSQL, ORACLE] 동일


-- 44) ROUND() - 지정한 위치에서 반올림한 수 반환

SELECT ROUND(15.649); -- 16
SELECT ROUND(15.649, 2); -- 15.65

-- [MSSQL, ORACLE] 동일


-- 45) MOD() - 나눈 나머지 반환

SELECT MOD(5, 2); -- 1

-- [MSSQL, ORACLE] 동일


-- 46) POW() - 제곱한 수 반환

SELECT POW(4, 3);  -- 64

-- [MSSQL, ORACLE] POWER(4, 3);  


-- 47) SQRT() - 제곱근 반환

SELECT SQRT(4); -- 2

-- [MSSQL, ORACLE] 동일


-- 48) TRUNCATE() - 지정한 위치 까지의 수만 반환

SELECT TRUNCATE(1234.567, 2); -- 1234.56
SELECT TRUNCATE(1234.567, 1); -- 1234.5
SELECT TRUNCATE(1234.567, 0); -- 1234
SELECT TRUNCATE(1234.567, -1); -- 1230
SELECT TRUNCATE(1234.567, -2); -- 1200

-- [MSSQL] N/A
-- [ORACLE] TRUNC()


-- 49) GREATEST() - 나열된 값 중에서 가장 큰 값 반환

SELECT GREATEST(10, 12, 11, 34, 21); -- 34

-- [MSSQL, ORACLE] 동일


-- 50) LEAST() - 나열된 값 중에서 가장 작은 값 반환

SELECT LEAST(10, 12, 11, 34, 21); -- 10

-- [MSSQL, ORACLE] 동일


/*
4. 기타 함수
*/


-- 51) IFNULL() - 지정한 값이 NULL 이면 지정한 다른 값으로 바꾼 결과 반환

SELECT IFNULL(NULL, 10); -- 10

-- [MSSQL] ISNULL()
-- [ORACLE] NVL(), NVL2()


-- 52) NULLIF() - 두 값이 같으면 NULL 반환

SELECT NULLIF(10, 10); -- NULL

-- [MSSQL, ORACLE] 동일


-- 53) COALESCE() - 나열된 값 중에서 NULL이 아닌 첫 번째 값 반환

SELECT COALESCE(NULL, NULL, 10, 20); -- 10

-- [MSSQL, ORACLE] 동일


-- 54) IF() - 조건의 참/거짓에 따른 값 반환

SELECT IF(10 > 1, '참', '거짓'); -- 참

-- [MSSQL] IIF()
-- [ORACLE] N/A