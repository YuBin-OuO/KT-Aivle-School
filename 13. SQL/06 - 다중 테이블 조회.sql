/*
제목: 다중 테이블 조회
작성: 이장래
내용: JOIN문과 하위 쿼리 작성 방법 학습
*/


-- 데이터베이스 연결
USE hrdb2024;


/*
1. 조인 작성 과정
*/

-- 직원 정보 조회
SELECT emp_id, emp_name, dept_id, phone, email
	FROM employee 
	WHERE retire_date IS NULL;

-- 조인 1단계
SELECT emp_id, emp_name, employee.dept_id, dept_name, phone, email
	FROM employee 
    INNER JOIN department ON employee.dept_id = department.dept_id
	WHERE retire_date IS NULL;


-- 조인 2단계
SELECT emp_id, emp_name, e.dept_id, dept_name, phone, email
	FROM employee AS e
    INNER JOIN department AS d ON e.dept_id = d.dept_id
	WHERE retire_date IS NULL;


-- 조인 3단계
SELECT e.emp_id, e.emp_name, e.dept_id, d.dept_name, e.phone, e.email
	FROM employee AS e
    INNER JOIN department AS d ON e.dept_id = d.dept_id
	WHERE e.retire_date IS NULL;


/*
2. INNER JOIN
*/

-- 직원 정보 조회
SELECT e.emp_id, e.emp_name, e.dept_id, d.dept_name, e.phone
	FROM employee AS e
	INNER JOIN department AS d ON e.dept_id = d.dept_id
	WHERE e.retire_date IS NULL;

-- 휴가 정보 조회
SELECT e.emp_id, e.emp_name, v.begin_date, v.end_date, v.reason, v.duration
	FROM employee AS e
	INNER JOIN vacation AS v ON e.emp_id = v.emp_id
	WHERE retire_date IS NULL
	ORDER BY e.emp_id ASC;

-- 부서 정보 조회
SELECT d.dept_id, d.dept_name, d.unit_id, u.unit_name, d.start_date
	FROM department AS d
	INNER JOIN unit AS u ON d.unit_id = u.unit_id;

-- 휴가 정보 조회
SELECT v.emp_id, e.emp_name, e.dept_id, e.phone, SUM(v.duration) AS Tot_duration
	FROM vacation AS v
	INNER JOIN employee AS e ON v.emp_id = e.emp_id
	WHERE v.begin_date BETWEEN '2020-01-01' AND '2020-06-30'
	GROUP BY v.emp_id, e.emp_name, e.dept_id, e.phone
	ORDER BY Tot_duration DESC;

SELECT d.dept_id, d.dept_name, u.unit_name
	FROM department AS d
    JOIN unit AS u ON d.unit_id = u.unit_id;

/*
3. OUTER JOIN
*/
    
-- 휴가 정보 조회
SELECT e.emp_id, e.emp_name, v.begin_date, v.end_date, v.reason, v.duration
	FROM employee AS e 
	LEFT OUTER JOIN vacation AS v ON e.emp_id = v.emp_id
	WHERE retire_date IS NULL
	ORDER BY e.emp_id ASC;

-- 부서 정보 조회
SELECT d.dept_id, d.dept_name, d.unit_id, u.unit_name
   FROM department AS d
   LEFT OUTER JOIN unit AS u ON d.unit_id = u.unit_id;

-- 마지막 조인
SELECT e.emp_id, e.emp_name, e.dept_id, e.hire_date, v.begin_date, v.reason, v.duration
	FROM employee AS e
    LEFT OUTER JOIN vacation AS v on e.emp_id = v.emp_id
    -- WHERE e.retire_date IS NULL
    ORDER BY 1, 2;

/*
4. CROSS JOIN
*/

-- 직원과 부서간 CROSS JOIN
SELECT emp_name, dept_name
    FROM employee AS e
    CROSS JOIN department AS d;


-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 부서 이름 다음에 본부 이름을 표시하도록 다음 쿼리문 수정

SELECT e.emp_id, e.emp_name, e.dept_id, d.dept_name, u.unit_name, e.phone, e.email
	FROM employee AS e
	INNER JOIN department AS d ON e.dept_id = d.dept_id
    INNER JOIN unit AS u ON d.unit_id = u.unit_id
	WHERE e.hire_date BETWEEN '2020-01-01' AND '2020-12-31' 
		AND e.retire_date IS NULL;

SELECT * FROM department;


-- Q) 직원 이름 다음에 부서 이름을 표시하도록 다음 쿼리문 수정

SELECT e.emp_id, e.emp_name, d.dept_name, v.begin_date, v.end_date, v.reason, v.duration
	FROM employee AS e
	INNER JOIN vacation AS v ON e.emp_id = v.emp_id
    INNER JOIN department AS d ON d.dept_id = e.dept_id
	WHERE e.hire_date BETWEEN '2020-01-01' AND '2020-12-31' 
		AND e.retire_date IS NULL
	ORDER BY e.emp_id ASC;

-- Q) 직원 이름 다음에 본부 이름을 표시하도록 다음 쿼리문 수정

SELECT e.emp_id, e.emp_name, u.unit_name, v.begin_date, v.end_date, v.reason, v.duration
	FROM employee AS e
	INNER JOIN vacation AS v ON e.emp_id = v.emp_id
    INNER JOIN department AS d ON d.dept_id = e.dept_id
    INNER JOIN unit AS u ON d.unit_id = u.unit_id
	WHERE e.hire_date BETWEEN '20120-01-01' AND '2020-12-31' 
		AND e.retire_date IS NULL
	ORDER BY e.emp_id ASC;

-- Q) 본부에 포함되지 않은 부서 정보를 조회하도록 다음 쿼리문 수정

SELECT d.dept_id, d.dept_name, d.unit_id, u.unit_name
   FROM department AS d
   LEFT OUTER JOIN unit AS u ON d.unit_id = u.unit_id
   WHERE d.unit_id IS NULL;
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
5. 하위 쿼리
*/

-- 가장 급여를 많이 받는 직원
SELECT emp_id, emp_name, dept_id, phone, email, salary
	FROM employee
	WHERE salary = (SELECT MAX(salary) FROM employee);

-- 가장 먼저 입사한 직원
SELECT emp_id, emp_name, dept_id, phone, email, salary
	FROM employee
	WHERE hire_date = (SELECT MIN(hire_date) FROM employee);

-- 휴가를 간 적이 있는 정보시스템 직원 #1
SELECT emp_id, emp_name, dept_id, phone, email
	FROM employee
	WHERE dept_id = 'SYS'
	AND emp_id IN (SELECT emp_id FROM vacation);

-- 휴가를 간 적이 있는 정보시스템 직원 #2
SELECT emp_id, emp_name, dept_id, phone, email
	FROM employee AS e
	WHERE dept_id = 'SYS'
	AND EXISTS (SELECT * 
                    FROM vacation
                    WHERE emp_id = e.emp_id);
    
-- 휴가를 간 적이 없는 정보시스템 직원 #1
SELECT emp_id, emp_name, dept_id, phone, email
	FROM employee
	WHERE dept_id = 'SYS'
	AND emp_id NOT IN (SELECT DISTINCT emp_id FROM vacation);

-- 휴가를 간 적이 없는 정보시스템 직원 #2
SELECT emp_id, emp_name, dept_id, phone, email
	FROM employee AS e
	WHERE dept_id = 'SYS'
	AND NOT EXISTS (SELECT * 
                        FROM vacation
                        WHERE emp_id = e.emp_id); -- EXISTS 안의 데이터가 있는지 없는지만 보고 데이터를 가져오진 않음
                        
SELECT emp_id, emp_name,
	(SELECT dept_name FROM department WHERE dept_id = e.dept_id) AS dept_name,
	hire_date,
	(SELECT SUM(duration) FROM vacation WHERE emp_id = e.emp_id) AS tot_duration
	FROM employee AS e
    WHERE retire_date IS NULL;
    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 가장 최근에 퇴사한 직원 정보 조회

SELECT * FROM employee WHERE retire_date = (SELECT MAX(retire_date) FROM employee);
    
-- Q) 강우동(S0003)보다 급여를 많이 받는 직원 정보 조회
SELECT * FROM employee WHERE salary >= (SELECT salary FROM employee WHERE emp_name = '강우동');

    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
6. 하위 쿼리 활용
*/
-- ★↓

-- 1) 활용 #1

-- 남녀별 근무 중인 직원 급여 정보
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- 1단계: 남녀별 근무 중인 직원 급여 순위
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
       RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rnk
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- 2단계: 남녀별 급여를 가장 많이 받는 근무 중인 직원 조회
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary
	FROM (
		SELECT emp_name, emp_id, gender, dept_id, hire_date, salary,
			RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rnk
			FROM employee
			WHERE retire_date IS NULL AND salary IS NOT NULL
	) AS emp
    WHERE rnk = 1;


-- 2) 활용 #2

-- 근무 중인 직원
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary
    FROM employee
    WHERE retire_date IS NULL;
    
-- 1딘계: 남녀별 근무 중인 직원 번호 붙이기
SELECT ROW_NUMBER() OVER(PARTITION BY gender ORDER BY emp_name ASC) AS num,
	   emp_name, emp_id, gender, dept_id, hire_date, salary
    FROM employee
    WHERE retire_date IS NULL;
    
-- 2단계: 남녀별 3명씩 조회
SELECT emp_name, emp_id, gender, dept_id, hire_date, salary
	FROM (
		SELECT ROW_NUMBER() OVER(PARTITION BY gender ORDER BY emp_name ASC) AS num,
			   emp_name, emp_id, gender, dept_id, hire_date, salary
			FROM employee
			WHERE retire_date IS NULL
	) AS emp
    WHERE num BETWEEN 1 AND 3;

    
-- 3) 활용 #3

-- 남녀별 근무 중인 직원
SELECT d.dept_name, e.emp_name, e.emp_id, e.dept_id, e.gender, e.hire_date, e.salary
    FROM employee AS e
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL
    ORDER BY d.dept_name ASC;

-- 1단계: 부서별 번호 부여
SELECT ROW_NUMBER() OVER(PARTITION BY e.dept_id ORDER BY e.emp_name ASC) AS num,
	   d.dept_name, e.emp_name, e.emp_id, e.dept_id, e.gender, e.hire_date, e.salary
    FROM employee AS e
    INNER JOIN department AS d ON e.dept_id = d.dept_id
    WHERE e.retire_date IS NULL
    ORDER BY dept_name ASC;
    
-- 2딘계: 부서 이름 처음에 한 번만 표시
SELECT IF(num = 1, dept_name, '') AS dept_name, emp_name, emp_id, dept_id, gender, hire_date, salary
	FROM (
		SELECT ROW_NUMBER() OVER(PARTITION BY e.dept_id ORDER BY e.emp_name) AS num,
			   d.dept_name, e.emp_name, e.emp_id, e.dept_id, e.gender, e.hire_date, e.salary
			FROM employee AS e
			INNER JOIN department AS d ON e.dept_id = d.dept_id
			WHERE e.retire_date IS NULL
	) AS emp
    ORDER BY emp.dept_name ASC;