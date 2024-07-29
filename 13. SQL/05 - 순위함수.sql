/*
제목: 순위함수
작성: 이장래
내용: 순위함수 사용 방법 학습
*/

-- 데이터베이스 연결
USE hrdb2024;

/*
1. RANK 함수
*/

-- 직원정보 조회
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL
    ORDER BY salary DESC;

-- 급여 순위 구하기
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       RANK() OVER(ORDER BY salary DESC) AS rnk
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- 남녀별 급여 순위 구하기
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rnk
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;

-- 정렬 기준 변경
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rnk
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL
    ORDER BY emp_name ASC;
    
    
-- 전체 & 남녀별 급여 순위 구하기
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       RANK() OVER(ORDER BY salary DESC) AS company_rnk,
       RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS gender_rnk
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL
    ORDER BY emp_name ASC;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 근무 중인 직원을 입사한 순으로 순위 표시해 조회
SELECT emp_name, hire_date, RANK() OVER(ORDER BY hire_date DESC) as rnk
FROM employee
WHERE retire_date IS NULL;

-- Q) 근무 중인 직원을 입사한 순으로 남녀별 순위 표시해 조회(남자가 먼저 표시 되게)
SELECT emp_name, hire_date, gender, RANK() OVER(PARTITION BY gender ORDER BY hire_date DESC) as rnk
FROM employee
WHERE retire_date IS NULL
ORDER BY gender DESC;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
2. DENSE_RANK 함수
*/

-- 급여 순위 구하기
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       DENSE_RANK() OVER(ORDER BY salary DESC) AS rnk
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;


/*
3. ROW_NUMBER 함수
*/

-- 번호 붙이기
SELECT ROW_NUMBER() OVER(ORDER BY emp_name ASC) AS num,
       emp_name, emp_id, gender, dept_id, hire_date, salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;


/*
4. NTILE 함수
*/

-- 급여를 기준으로 3 그룹으로 분류
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       NTILE(3) OVER(ORDER BY salary DESC) AS grp
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
 
-- 1, 2, 3 --> 상, 중, 하
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       ELT(NTILE(3) OVER(ORDER BY salary DESC), '상', '중', '하') AS grp
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- [MSSQL]
/*
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       CHOOSE(NTILE(3) OVER(ORDER BY salary DESC), '상', '중', '하') AS grp
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
*/

-- [ORACLE]
/*
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       DECODE(NTILE(3) OVER(ORDER BY salary DESC), 
             1, '상', 2, '중', 3, '하') AS grp
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
*/

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 입사일 기준으로 번호를 붙여 근무 중인 직원 조회
SELECT emp_id, emp_name, hire_date,
ROW_NUMBER() OVER(ORDER BY hire_date ASC) as num
FROM employee WHERE retire_date IS NULL;

SELECT * FROM employee;
-- Q) 부서별로 입사일 기준으로 번호를 붙여 근무 중인 직원 조회
SELECT emp_id, emp_name, hire_date, dept_id,
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY hire_date ASC) as num
FROM employee WHERE retire_date IS NULL;
    
-- Q) 근무 중인 직원 급여 순위 조회
--    단, 급여가 NULL인 경우 5000으로 표시하고 이 값으로 순위 결정
SELECT emp_name, salary,
RANK() OVER(ORDER BY IFNULL(salary, 5000) DESC) as rnk
FROM employee WHERE retire_date IS NULL;
    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --
