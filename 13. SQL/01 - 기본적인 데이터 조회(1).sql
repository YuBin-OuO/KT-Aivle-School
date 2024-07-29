/*
제목: 데이터 기본 조회(1)
작성: 이장래
내용: 기본적인 데이터 조회 방법 학습
*/


/* 
1. 단순 조회
*/

-- 문자열 출력
SELECT 'Hello SQL World' FROM dual;

-- 별칭 사용
SELECT 'Hello SQL World' AS Start;

-- 숫자 연산 결과 출력
SELECT 10 + 20 AS Result;

-- 함수 결과 출력
SELECT CURDATE() AS Today;

-- 변수 값 출력
SET @Today = CURDATE();
SELECT @Today;

/*
2. 조회 대상 열 지정
*/

-- 데이터베이스 연결
USE hrdb2024;

-- 현재 데이터베이스 확인
SELECT DATABASE();


-- 1) 모든 열 모든 행 조회

-- 직원 정보 조회
SELECT * FROM employee;

-- 부서 정보 조회
SELECT * FROM department;


-- 2) 일부 열 모든 행 조회

-- 원하는 열을 원하는 순서로 나열
SELECT emp_id, emp_name	
    FROM employee;
    
SELECT emp_name, gender, emp_id, dept_id
	FROM employee;
    
SELECT emp_name, emp_id, gender, dept_id, phone, salary
	FROM employee;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- 

-- Q) vacation 테이블 모든 데이터 조회employeeemployee

SELECT * FROM vacation;

-- Q) unit 테이블 모든 데이터 조회

SELECT * FROM unit;


-- Q) employee 테이블의 emp_name, hire_date, email 열만 조회

SELECT emp_name, hire_date, email FROM employee;

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --
 
 
/*
3. 조회 대상 조건 지정
*/

-- 1) 일부 행 모든 열 조회

-- S0001 직원 정보 조회
SELECT *
	FROM employee
	WHERE emp_id = 'S0001';

-- S0001 직원 휴가 정보 조회
SELECT *
	FROM vacation
	WHERE emp_id = 'S0001';
    
-- MKT 부서 직원 정보 조회
SELECT *
	FROM employee
	WHERE dept_id = 'MKT';

-- S0002 휴가 정보 조회
SELECT *
	FROM vacation
	WHERE emp_id = 'S0002';


-- 2) 일부 행 일부 열 조회

-- S0001 직원 정보 조회
SELECT emp_id, emp_name
	FROM employee
	WHERE emp_id = 'S0001';

SELECT emp_id, emp_name, dept_id, gender, hire_date
	FROM employee
	WHERE emp_id = 'S0001';
    
-- SYS 부서 정보 조회
SELECT dept_id, dept_name
	FROM department
	WHERE dept_id = 'SYS';


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- 

-- Q) 남자 직원의 사번, 이름, 입사일 정보 조회
SELECT emp_id, emp_name, hire_date FROM employee;

-- Q) 2020년 6월 1일 입사자의 이름, 부서코드, 성별, 입사일, 이메일 정보 조회
SELECT emp_name, dept_id, gender, hire_date, email
FROM employee
WHERE hire_date = '2020-06-01';

SELECT * FROM club_join;

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --
 

/*
4. 비교 연산자: >, >=, <, <=, =, !=, <>
*/

-- SYS 부서 직원 정보 조회
SELECT emp_name, emp_id, dept_id, gender, hire_date, phone
	FROM employee
	WHERE dept_id = 'SYS';

-- 연봉이 7,000을 초과하는 직원 정보 조회
SELECT emp_name, emp_id, dept_id, gender, hire_date, salary
	FROM employee
	WHERE salary > 7000;

-- 2019년 3월 이전에 입사한 직원 정보 조회
SELECT emp_name, emp_id, dept_id, gender, hire_date, phone
	FROM employee
	WHERE hire_date < '2019-03-01';

-- SYS 부서가 아닌 직원 정보 조회
SELECT emp_name, emp_id, dept_id, gender, hire_date, phone, salary
	FROM employee
	WHERE dept_id != 'SYS';


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --
 
-- Q) 2020년 6월 이전 입사자의 이름, 부서코드, 성별, 입사일, 이메일 정보 조회
SELECT * FROM employee WHERE hire_date < '20200601';
    
-- Q) 휴가 기간이 5일 이상인 사번, 휴가시작일, 휴가사유, 휴가기간 정보 조회
SELECT * FROM vacation WHERE duration >= 5;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
5. 문자열 조건 지정
*/

-- 김씨 성을 갖는 직원
SELECT emp_id, emp_name, dept_id, hire_date, email, phone
	FROM employee
	WHERE emp_name LIKE '김%';

-- 이름에 '국'이 들어간 직원
SELECT emp_id, emp_name, dept_id, hire_date, email, phone
	FROM employee
	WHERE emp_name LIKE '%국%';

-- 이름이 '국'으로 끝나는 직원
SELECT emp_id, emp_name, dept_id, hire_date, email, phone
	FROM employee
	WHERE emp_name LIKE '%국';

-- 이메일 아이디가 4글자인 직원
SELECT emp_id, emp_name, dept_id, hire_date, email, phone
	FROM employee
	WHERE email LIKE '____@%';
    
    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --
 
-- Q) 전화번호가 017로 시작하는 직원 정보 조회
SELECT * FROM employee WHERE phone LIKE '017%';


-- Q) 전화번호가 010으로 시작하지 않는 직원 정보 조회
SELECT * FROM employee WHERE phone NOT LIKE '010%';


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --
 
 
/*
6. 논리 연산자
*/

-- 2020년에 입사인 직원 정보 조회
SELECT emp_name, emp_id, dept_id, hire_date, phone
	FROM employee
	WHERE hire_date >= '2020-01-01' AND hire_date <= '2020-12-31';

SELECT emp_name, emp_id, dept_id, hire_date, phone
	FROM employee
	WHERE YEAR(hire_date) = 2020; 
    
-- SYS 부서 남자 직원 정보 조회
SELECT emp_name, emp_id, gender, dept_id, hire_date, phone
	FROM employee
	WHERE gender = 'M' AND dept_id = 'SYS';

-- SYS, MKT, GEN 부서 직원 정보 조회
SELECT emp_name, emp_id, dept_id, hire_date, phone
	FROM employee
	WHERE dept_id = 'SYS' OR dept_id = 'MKT' OR dept_id = 'GEN';
 
 
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 2022년부터 입사한 SYS 부서 직원 정보 조회
SELECT * FROM employee WHERE hire_date >= '20220101' AND hire_date <='20221231';


-- Q) SYS 부서 직원 중에서 급여를 6,000 이상 받는 직원 정보 조회
SELECT * FROM employee WHERE dept_id = 'SYS' AND salary >= 6000;

    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --