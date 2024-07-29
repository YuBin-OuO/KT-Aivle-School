/*
제목: 데이터 집계
작성: 이장래
내용: 기본적인 데이터 집계 방법 학습
*/

/*
hrdb2024 원복 후 진행
*/

-- 데이터베이스 연결
USE hrdb2024;

/*
1. 집계 함수: SUM, AVG, MAX, MIN, COUNT
*/

-- 근무 중 직원 급여 총액 조회
SELECT SUM(salary) AS tot_salary
	FROM employee
	WHERE retire_date IS NULL;

-- 근무 중 직원 수
SELECT COUNT(*) AS emp_count
	FROM employee
	WHERE retire_date IS NULL;

-- 최대 급여, 최소 급여, 최대 최소 급여 차이 조회
SELECT MAX(salary) AS max_salary, 
       MIN(salary) AS min_salary,
	   MAX(salary) - MIN(salary) AS diff_salary
	FROM employee
	WHERE retire_date IS NULL;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 홍길동의 2019~2020년 휴가 일수 합계 조회  
SELECT SUM(duration) AS vacation_days FROM vacation WHERE begin_date BETWEEN '2019-01-01' AND '2020-12-31' AND emp_id = 'S0001';

-- Q) 가장 최근에 직원이 입사한 날짜 조회
SELECT MAX(hire_date) FROM employee;

-- Q) 맨 처음으로 직원이 퇴사한 날짜 조회
SELECT MIN(retire_date) FROM employee;

    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- 

/*
2. 집계 함수와 NULL 값
*/

-- 근무중인 직원의 급여 평균 조회
SELECT AVG(salary) AS avg_salary
	FROM employee
	WHERE retire_date IS NULL; -- 6460

-- 급여 합을 직원 수로 나눠서 급여 평균 조회
SELECT SUM(salary) / COUNT(*) AS avg_salary
	FROM employee
	WHERE retire_date IS NULL; -- 6056.25

-- 급여가 NULL이면 0으로 대체해서 급여 평균 조회
SELECT AVG(IFNULL(salary, 0)) AS avg_salary
	FROM employee
	WHERE retire_date IS NULL; -- 6056.25


/*
3. 그룹별 집계
*/

-- 부서별 직원수 조회
SELECT dept_id, COUNT(*) AS emp_count
	FROM employee
	WHERE retire_date IS NULL
	GROUP BY dept_id;

-- 남녀별 직원수 조회
SELECT gender, COUNT(*) AS emp_count
	FROM employee
	WHERE retire_date IS NULL
	GROUP BY gender
	ORDER BY gender DESC;

-- 집계 결과 정렬
SELECT gender, COUNT(*) AS emp_count -- 4
	FROM employee -- 1
	WHERE retire_date IS NULL -- 2
	GROUP BY gender -- 3 
	ORDER BY emp_count ASC; -- 5 따라서 여기에 별칭인 emp_count 사용 가능!

-- 부서별 급여합 조회
SELECT dept_id, SUM(IFNULL(salary, 0)) AS tot_salary
	FROM employee
	WHERE retire_date IS NULL
	GROUP BY dept_id;

-- 부서별 최대 급여, 최소 급여, 최대 급여 최소 급여 차이 조회
SELECT dept_id, 
       MAX(salary) AS max_salary, 
       MIN(salary) AS min_salary,
       MAX(salary) - MIN(salary) AS diff_salary
	FROM employee
	WHERE retire_date IS NULL
	GROUP BY dept_id;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- 

-- Q) 근무 중인 직원의 부서별 급여 합 조회
SELECT dept_id, SUM(salary) FROM employee WHERE retire_date IS NULL GROUP BY dept_id;

-- Q) 부서별로 급여가 5,000보다 많은 근무중인 직원 수 조회
SELECT dept_id, COUNT(*) FROM employee WHERE salary>=5000 AND retire_date IS NULL GROUP BY dept_id;

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- 


/*
4. 집계 결과에 대한 조건
*/

-- 근무중인 직원이 3명 이상인 부서별 근무중인 직원 수 조회
SELECT dept_id, COUNT(*) AS emp_count -- 5
	FROM employee -- 1
	WHERE retire_date IS NULL -- 2
	GROUP BY dept_id -- 3
	HAVING COUNT(*) >= 3 -- 4
	ORDER BY emp_count DESC; -- 6

-- HAVING 절에 열 별칭 사용 가능(권고하지 않음)
SELECT dept_id, COUNT(*) AS emp_count
	FROM employee
	WHERE retire_date IS NULL
	GROUP BY dept_id
	HAVING emp_count >= 3
	ORDER BY emp_count DESC;

    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- 

-- Q) 2020년 휴가일수 합이 5가 넘는 직원의 사번과 휴가일수 합 조회
SELECT emp_id, SUM(duration) AS d
	FROM vacation
	WHERE begin_date >= '2020-01-01' AND end_date <= '2020-12-31'
	GROUP BY emp_id
	HAVING d>5;

SELECT * FROM vacation;

-- Q) 2020년에 3회 이상 휴가를 간 직원의 사번과 휴가 횟수 조회
SELECT emp_id, COUNT(*) AS t
	FROM vacation
	WHERE begin_date >= '2020-01-01' AND end_date <= '2020-12-31'
	GROUP BY emp_id
	HAVING t>=3;

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- 