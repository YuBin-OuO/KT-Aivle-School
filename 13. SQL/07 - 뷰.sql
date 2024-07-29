/*
제목: 뷰(View)
작성: 이장래
내용: 기본적인 뷰 방법 학습
*/


-- 데이터베이스 연결
USE hrdb2024;
SELECT DATABASE();


/*
1. 뷰 만들기 
*/


-- 1) 대상 쿼리문 작성

SELECT e.emp_name, e.emp_id, e.gender, e.dept_id, d.dept_name, e.hire_date,
       (SELECT IFNULL(SUM(duration), 0) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_duration,
       (SELECT COUNT(*) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_cnt
    FROM employee AS e 
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL;
    
    
-- 2) 뷰 만들기
    
CREATE VIEW employee_info
AS
SELECT e.emp_name, e.emp_id, e.gender, e.dept_id, d.dept_name, e.hire_date,
       (SELECT IFNULL(SUM(duration), 0) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_duration,
       (SELECT COUNT(*) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_cnt
    FROM employee AS e 
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL;


-- 3) 뷰 사용

SELECT *
    FROM employee_info;
    


/*
2. 뷰 변경과 제거 
*/

-- 1) ALTER VIEW 문으로 변경 

ALTER VIEW employee_info
AS
SELECT e.emp_name, e.emp_id, 
       IF(e.gender = 'F', '여', '남') AS gender, 
       CONCAT(d.dept_name, '(', e.dept_id , ')') AS dept_name, e.hire_date,
       (SELECT IFNULL(SUM(duration), 0) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_duration,
       (SELECT COUNT(*) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_cnt
    FROM employee AS e 
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL;

-- 확인
SELECT *
    FROM employee_info;


-- 2) CREATE OR REPLACE VIEW 문으로 변경

CREATE OR REPLACE VIEW employee_info
AS
SELECT e.emp_name, e.emp_id, 
       IF(e.gender = 'F', '여자', '남자') AS gender, 
       CONCAT(d.dept_name, '(', e.dept_id , ')') AS dept_name, e.hire_date,
       (SELECT IFNULL(SUM(duration), 0) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_duration,
       (SELECT COUNT(*) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_cnt
    FROM employee AS e 
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL;

-- 확인
SELECT *
    FROM employee_info;


-- 3) 뷰 삭제 

DROP VIEW employee_info;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 다음 쿼리문을 수행하여 결과 확인

SELECT e.emp_name, e.emp_id, e.gender, e.dept_id, d.dept_name, e.hire_date
    FROM employee AS e 
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL;


-- Q) 위 쿼리문을 수정하여 다음 정보 조회
--    emp_name, emp_id, gender, dept_id, dept_name, hire_year, hire_month, work_year
--    단, work_year는 현재 연도에서 입사 연도를 뺀 값으로 정의
SELECT e.emp_name, e.emp_id, e.gender, d.dept_id, d.dept_name,
	YEAR(e.hire_date) AS hire_year,
	MONTH(e.hire_date) AS hire_month,
	YEAR(CURDATE()) - YEAR(e.hire_date) AS work_year
FROM employee AS e
INNER JOIN department AS d ON e.dept_id = d.dept_id;

 
-- Q) 위 결과를 갖는 뷰 vw_employee 만들기
CREATE VIEW vm_employee
AS
SELECT e.emp_name, e.emp_id, e.gender, d.dept_id, d.dept_name,
	YEAR(e.hire_date) AS hire_year,
	MONTH(e.hire_date) AS hire_month,
	YEAR(CURDATE()) - YEAR(e.hire_date) AS work_year
FROM employee AS e
INNER JOIN department AS d ON e.dept_id = d.dept_id;


-- Q) vw_employee 뷰를 조회해 결과 확인
SELECT * FROM vm_employee;

    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
3. 열 별칭 지정
*/

-- 1) AS 사용

CREATE OR REPLACE VIEW employee_info
AS
SELECT e.emp_name AS 이름, e.emp_id AS 사번, 
       IF(e.gender = 'F', '여자', '남자') AS 성별, 
       CONCAT(d.dept_name, '(', e.dept_id , ')') AS 부서, e.hire_date AS 입사일,
       (SELECT IFNULL(SUM(duration), 0) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS 총휴가일수,
       (SELECT COUNT(*) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS 총휴가횟수
    FROM employee AS e 
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL;

-- 확인
SELECT *
    FROM employee_info;


-- 2) 또 다른 방법

CREATE OR REPLACE VIEW employee_info(이름, 사번, 성별, 부서, 입사일, 총휴가일수, 총휴가횟수)
AS
SELECT e.emp_name, e.emp_id, 
       IF(e.gender = 'F', '여자', '남자') AS gender, 
       CONCAT(d.dept_name, '(', e.dept_id , ')') AS dept_name, e.hire_date,
       (SELECT IFNULL(SUM(duration), 0) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_duration,
       (SELECT COUNT(*) 
            FROM vacation 
            WHERE emp_id = e.emp_id) AS tot_vac_cnt
    FROM employee AS e 
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL;

-- 확인
SELECT *
    FROM employee_info;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 뷰를 만드는 다음 구문에 별칭을 지정하는 구문 추가
--    별칭: 이름, 사번, 성별, 부서코드, 부서이름, 입사년, 입사월, 근속년수

CREATE OR REPLACE VIEW vw_employee(이름, 사번, 성별, 부서코드, 부서이름, 입사년, 입사월, 근속년수) 
AS
SELECT e.emp_name, e.emp_id, e.gender, e.dept_id, d.dept_name, 
       YEAR(e.hire_date) AS hire_year,
       MONTH(e.hire_date) AS hire_month,
       YEAR(CURDATE()) - YEAR(e.hire_date) AS work_year
    FROM employee AS e 
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL;


-- Q) vw_employee 뷰를 조회해 결과 확인
SELECT * FROM vw_employee;

    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
4. WITH CHECH OPTION 사용 
*/

-- 1) 뷰 만들기 

CREATE OR REPLACE VIEW high_salary
AS
SELECT emp_name, emp_id, d.dept_id, gender, hire_date, salary
    FROM employee AS e
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE salary >= 8000;

SELECT *
    FROM high_salary;


-- 2) 데이터 변경 

UPDATE high_salary
    SET salary = 7000
    WHERE emp_id = 'S0002';

-- 확인
SELECT *
    FROM high_salary;

-- 다시 변경
UPDATE employee
    SET salary = 8200
    WHERE emp_id = 'S0002';

-- 확인
SELECT *
    FROM high_salary;


-- 3) WITH CHECK OPTION  사용  

CREATE OR REPLACE VIEW high_salary
AS
SELECT emp_name, emp_id, d.dept_id, gender, hire_date, salary
    FROM employee AS e
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE salary >= 8000
    WITH CHECK OPTION;

-- 실패하는 쿼리 
UPDATE high_salary
    SET salary = 7000
    WHERE emp_id = 'S0002';
/*
Error Code: 1369. CHECK OPTION failed 'hrdb2019.high_salary'	0.016 sec
*/

-- 성공하는 쿼리
UPDATE high_salary
    SET salary = 8000
    WHERE emp_id = 'S0002';
    
-- 확인
SELECT *
    FROM high_salary;
    
    
/*
5. 뷰 활용 - 집합 연산자
*/


-- 1) 데이터 준비

-- 기존 테이블 있으면 제거
DROP TABLE IF EXISTS vac_2017, vac_2018, vac_2019, vac_2020;

-- 2017년 데이터(duration 열 없음)
CREATE TABLE vac_2017 
    SELECT emp_id, begin_date, end_date, reason
        FROM vacation
        WHERE begin_date BETWEEN '2017-01-01' AND '2017-12-31';

-- 2018년 데이터(2019년 데이터 일부 중복)
CREATE TABLE vac_2018
    SELECT emp_id, begin_date, end_date, reason, duration
        FROM vacation
        WHERE begin_date BETWEEN '2018-01-01' AND '2019-04-30';

-- 2019년 데이터
CREATE TABLE vac_2019 
    SELECT emp_id, begin_date, end_date, reason, duration
        FROM vacation
        WHERE begin_date BETWEEN '2019-01-01' AND '2019-12-31';
 
-- 2020년 데이터
CREATE TABLE vac_2020   
    SELECT emp_id, begin_date, end_date, reason, duration
        FROM vacation
        WHERE begin_date BETWEEN '2020-01-01' AND '2020-12-31';

-- 데이터 확인
SELECT * FROM vac_2017;
SELECT * FROM vac_2018;
SELECT * FROM vac_2019;
SELECT * FROM vac_2020;


-- 2) UNION ALL: 단순 병합

-- 개별 쿼리
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2018;
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2019;
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2020;
    
-- UNION ALL 사용
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2018
UNION ALL
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2019
UNION ALL
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2020;
    
    
-- 3) UNION 사용: 중복된 행 제거

SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2018
UNION  
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2019
UNION 
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2020;


-- 4) 뷰로 만들기 #1

CREATE VIEW vac_2018_20
AS
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2018
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2019
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2020;

-- 확인
SELECT * FROM vac_2018_20;


-- 5) 뷰로 만들기 #2

-- 오류 발생
CREATE VIEW vac_2017_20
AS
SELECT emp_id, begin_date, end_date, reason
    FROM vac_2017
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2018
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2019
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2020;

-- 열 개수 맞추기 #1
CREATE VIEW vac_2017_20
AS
SELECT emp_id, begin_date, end_date, reason, NULL AS duration
    FROM vac_2017
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2018
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2019
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2020;
    
-- 열 개수 맞추기 #2
ALTER VIEW vac_2017_20
AS
SELECT emp_id, begin_date, end_date, reason, DATEDIFF(end_date, begin_date) + 1 AS duration
    FROM vac_2017
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2018
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2019
UNION
SELECT emp_id, begin_date, end_date, reason, duration
    FROM vac_2020;
    
-- 확인
SELECT * FROM vac_2017_20;

    
-- 6) INTERSECT 구현

SELECT DISTINCT v1.emp_id, v1.begin_date, v1.end_date, v1.reason, v1.duration
    FROM vac_2018 AS v1
    INNER JOIN vac_2019 AS v2 
        ON v1.emp_id = v2.emp_id AND v1.begin_date = v2.begin_date 
            AND v1.end_date = v2.end_date AND v1.reason = v2.reason 
            AND v1.duration = v2.duration;
   
-- 7) MINUS 구현

SELECT DISTINCT v1.emp_id, v1.begin_date, v1.end_date, v1.reason, v1.duration
    FROM vac_2018 AS v1
    LEFT OUTER JOIN vac_2019 AS v2 
        ON v1.emp_id = v2.emp_id AND v1.begin_date = v2.begin_date 
            AND v1.end_date = v2.end_date AND v1.reason = v2.reason 
            AND v1.duration = v2.duration 
    WHERE v2.emp_id IS NULL;
    
SELECT * FROM vac_2018;
SELECT * FROM vac_2019;