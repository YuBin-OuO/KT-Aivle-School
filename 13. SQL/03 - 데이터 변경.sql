/*
제목: 데이터 변경
작성: 이장래
내용: 기본적인 데이터 변경 방법 학습
*/

-- 데이터베이스 연결
USE hrdb2024;


/*
1. INSERT
*/

-- PRD 부서 추가
INSERT INTO department(dept_id, dept_name, unit_id, start_date)
    VALUES('PRD', '상품', 'A', '2022-10-01');

-- 열 이름 생략
INSERT INTO department
    VALUES('DBA', 'DB관리', 'A', '2022-10-01');

/*
INSERT INTO department(dept_id, dept_name, unit_id, start_date)
    VALUES('PRD', '상품', 'A', '2022-10-01'),
          ('DBA', 'DB관리', 'A', '2022-10-01');
*/

-- 확인   
SELECT * FROM department;
    
-- 퇴사자 테이블 만들기
DROP TABLE IF EXISTS retired_employee;
CREATE TABLE retired_employee (
	emp_id char(5) NOT NULL, -- 길이가 5
	emp_name varchar(8) NOT NULL, -- 최대 길이가 8
	gender char(1) NOT NULL,
	hire_date date NOT NULL,
	retire_date date NOT NULL,
	phone char(13) NOT NULL,
	email varchar(50) NOT NULL
);

SELECT * FROM retired_employee;

-- 퇴사자 정보 추가
INSERT INTO retired_employee    
    SELECT emp_id, emp_name, gender, hire_date, retire_date, phone, email
        FROM employee WHERE retire_date IS NOT NULL;

-- 확인
SELECT * FROM retired_employee;


/*
2. UPDATE
*/

-- 특정 조건의 행 UPDATE
UPDATE employee
	SET phone = '010-1239-1239'
	WHERE emp_id = 'S0001';
            
            
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 홍길동(S0001)의 이름을 '홍길명'으로 변경
UPDATE employee SET emp_name = '홍길명' WHERE emp_id='S0001';
SELECT * FROM employee;

-- Q) 정보시스템(SYS) 직원의 급여를 일괄적으로 1,000만원 인상
UPDATE employee SET salary = salary + 1000 WHERE dept_id='SYS';
SELECT * FROM employee;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
3. DELETE
*/

-- 특정 조건에 맞는 행 지우기
DELETE FROM vacation
   WHERE end_date <= '2017-12-31';

-- 모든 행 지우기
/*
DELETE FROM vacation;
*/

-- 모든 행 지우기 (더 빠름)
/*
TRUNCATE TABLE vacation;
*/