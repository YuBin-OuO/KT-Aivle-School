/*
제목: 분석을 위한 유익한 기능들
작성: 이장래
내용: 더 나은 분석을 위해 사용할 수 있는 고급 기능 학습
*/


-- 데이터베익스 연결
USE hrdb2024;


/*
1. 문자열 집계(결합) - GROUP_CONCAT()
*/

-- 부서별 급여 합
SELECT dept_id,
       SUM(IFNULL(salary, 0)) AS tot_salary
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;

-- 부서별 직원 이름 합(?)
SELECT dept_id,
       SUM(emp_name) AS emp_list
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;

-- 부서별 직원 이름 합(?)
SELECT dept_id,
       CONCAT(emp_name) AS emp_list
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;

-- 부서별 직원 이름 합(!)
SELECT dept_id,
       GROUP_CONCAT(emp_name) AS emp_list
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;

-- 부서별 직원 사원번호 합(!)
SELECT dept_id,
       GROUP_CONCAT(emp_id) AS emp_list
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;
    
-- 부서별 급여 합: 직원 이름 나열
SELECT dept_id,
       SUM(IFNULL(salary, 0)) AS tot_salary,
       GROUP_CONCAT(emp_name) AS emp_list
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;
    
-- 부서별 급여 합: 구분자 지정
SELECT dept_id,
       SUM(IFNULL(salary, 0)) AS tot_salary,
       GROUP_CONCAT(emp_name SEPARATOR '/') AS emp_list
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;
    
-- 부서별 급여 합: 이름 정렬
SELECT dept_id,
       SUM(IFNULL(salary, 0)) AS tot_salary,
       GROUP_CONCAT(emp_name ORDER BY emp_name ASC SEPARATOR '/') AS emp_list
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;  
    
-- [MSSQL]
/*
SELECT dept_id,
       SUM(IFNULL(salary, 0)) AS tot_salary,
       STRING_AGG(emp_name, ',') WITHIN GROUP (ORDER BY emp_name ASC) AS emp_list
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;  
*/

-- [ORACLE]
/*
SELECT dept_id,
       SUM(IFNULL(salary, 0)) AS tot_salary,
       LISTAGG(emp_name, ',') WITHIN GROUP (ORDER BY emp_name ASC) AS emp_list
    FROM employee
    WHERE retire_date IS NULL
    GROUP BY dept_id;  
*/

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 다음 형태로 직원들의 휴가 횟수, 휴가일 수 합, 각 휴가의 휴가 일수를 조회 
--    단, 휴가 일수는 휴가 시작일을 기준으로 내림차순 정렬, 구분자(Separator)는 콤마(,) 사용
/*
emp_id  cnt_duration    tot_duration    duration
------------------------------------------------------------------------------------
S0001	21	            71	            2,5,2,1,1,2,1,2,4,4,3,1,12,4,15,6,1,1,2,1,1
S0002	13	            35	            2,5,3,1,2,5,1,1,4,1,4,1,5
...생략...
*/

SELECT * FROM vacation;

SELECT emp_id, COUNT(*) AS cnt_duration, SUM(duration) AS tot_duration, GROUP_CONCAT(duration ORDER BY begin_date DESC) AS duration FROM vacation GROUP BY emp_id;
    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

 
/*
2. 누적힙과 이동 평균 - OVER()
*/

-- 직원 정보 조회
SELECT emp_name, dept_id, emp_id, salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;

-- 건수, 합계, 평균 (?)
SELECT emp_name, dept_id, emp_id, salary,
       COUNT(*) AS cnt,
       SUM(salary) AS sum_salary,
       AVG(salary) AS avg_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;

-- 건수, 합계, 평균 (!)    
SELECT emp_name, dept_id, emp_id, salary,
       COUNT(*)    OVER() AS cnt,
       SUM(salary) OVER() AS sum_salary,
       AVG(salary) OVER() AS avg_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- 건수, 합계, 평균 (!!)    
SELECT emp_name, dept_id, emp_id, salary,
       COUNT(*)    OVER(ORDER BY emp_name ASC) AS cnt,
       SUM(salary) OVER(ORDER BY emp_name ASC) AS sum_salary,
       AVG(salary) OVER(ORDER BY emp_name ASC) AS avg_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;

-- 건수, 합계, 평균 (!!!)  
SELECT emp_name, dept_id, emp_id, salary,
       COUNT(*)    OVER(PARTITION BY dept_id ORDER BY emp_name ASC) AS cnt,
       SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_name ASC) AS sum_salary,
       AVG(salary) OVER(PARTITION BY dept_id ORDER BY emp_name ASC) AS avg_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;

-- 건수, 합계, 평균 (!!!!)
SELECT emp_name, dept_id, emp_id, salary,
       COUNT(*)    OVER win AS cnt,
       SUM(salary) OVER win AS sum_salary,
       AVG(salary) OVER win AS avg_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL
    WINDOW win AS (PARTITION BY dept_id ORDER BY emp_name ASC);
    
-- [MSSQL, ORACLE] 동일

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 다음 형태로 직원들의 휴가 현황을 조회 

/*
emp_id  emp_name  dept_id  begin_date  duration cum_duration
-------------------------------------------------------------
S0001	홍길동	  SYS	   2013-01-12  1	     1
S0001	홍길동	  SYS	   2013-03-21  1	     2
...생략...
S0002	일지매	  GEN	   2013-07-21  5	     5
S0002	일지매	  GEN	   2013-11-17  1	     6
...생략...
*/

SELECT v.emp_id, e.emp_name, e.dept_id, v.begin_date, v.duration,
       SUM(duration) OVER (PARTITION BY emp_id ORDER BY begin_date) AS cum_duration
    FROM vacation AS v
    INNER JOIN employee AS e ON v.emp_id = e.emp_id;
    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
3. 결과 집합 내 맨 처음, 맨 마지막 값 - FIRST_VALUE(), LAST_VALUE()
*/

-- 직원 정보 조회
SELECT emp_name, dept_id, emp_id, salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;

-- FIRST_VALUE, LAST_VALUE(?)
SELECT emp_name, dept_id, emp_id, salary,
       FIRST_VALUE(salary) OVER(ORDER BY emp_name) AS first_salary,
       LAST_VALUE(salary)  OVER(ORDER BY emp_name) AS last_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- 다음과 같은 의미를 가짐
SELECT emp_name, dept_id, emp_id, salary,
       FIRST_VALUE(salary) OVER(ORDER BY emp_name
                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_salary,
       LAST_VALUE(salary)  OVER(ORDER BY emp_name
                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS last_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- 전체 영역을 범위로 지정
SELECT emp_name, dept_id, emp_id, salary,
       FIRST_VALUE(salary) OVER(ORDER BY emp_name
                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_salary,
       LAST_VALUE(salary)  OVER(ORDER BY emp_name
                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- 필요한 범위만 지정    
SELECT emp_name, dept_id, emp_id, salary,
       FIRST_VALUE(salary) OVER(ORDER BY emp_name
                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_salary,
       LAST_VALUE(salary)  OVER(ORDER BY emp_name
                                ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS last_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;

-- 또는
SELECT emp_name, dept_id, emp_id, salary,
       FIRST_VALUE(salary) OVER(ORDER BY emp_name
                                ROWS UNBOUNDED PRECEDING) AS first_salary,
       LAST_VALUE(salary)  OVER(ORDER BY emp_name
                                ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS last_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- [MSSQL, ORACLE] 동일

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 다음 형태로 직원들의 휴가 현황을 조회 

/*
emp_id  emp_name  dept_id  begin_date  duration first_begin_date  last_begin_date
---------------------------------------------------------------------------------
S0001	홍길동	  SYS	   2013-01-12  1	    2013-01-12	      2018-05-05
S0001	홍길동	  SYS	   2013-03-21  1	    2013-01-12	      2018-05-05
...생략...
S0002	일지매	  GEN	   2013-07-21  5	    2013-07-21	      2018-05-05
S0002	일지매	  GEN	   2013-11-17  1	    2013-07-21	      2018-05-05
...생략...
*/

SELECT v.emp_id, e.emp_name, e.dept_id, v.begin_date, v.duration,
       FIRST_VALUE(v.begin_date) OVER(PARTITION BY v.emp_id 
                                      ORDER BY v.begin_date
                                      ROWS UNBOUNDED PRECEDING) AS first_begin_date,
       LAST_VALUE(v.begin_date)  OVER(PARTITION BY v.emp_id 
                                      ORDER BY v.begin_date
                                      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_begin_date
    FROM vacation AS v
    INNER JOIN employee AS e ON v.emp_id = e.emp_id;
    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
4. 특정 위치의 앞/뒤 값 - LAG(), LEAD()
*/

-- 직원 급여 조회
SELECT emp_name, dept_id, emp_id, salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;
    
-- 하나 전/후 급여 비교
SELECT emp_name, dept_id, emp_id, salary,
       LAG(salary, 1)  OVER(ORDER BY emp_name) AS prev_1_salary,
       LEAD(salary, 1) OVER(ORDER BY emp_name) AS next_1_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;

-- 대상 값이 없는 경우 기본값 지정
SELECT emp_name, dept_id, emp_id, salary,
       LAG(salary, 1, 0)  OVER(ORDER BY emp_name) AS prev_1_salary,
       LEAD(salary, 1, 0) OVER(ORDER BY emp_name) AS next_1_salary
    FROM employee
    WHERE retire_date IS NULL AND salary IS NOT NULL;

-- [MSSQL, ORACLE] 동일

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 다음 형태로 직원들의 휴가 현황을 조회 

/*
emp_id  emp_name  dept_id  begin_date  duration prev_begin_date  date_diff
---------------------------------------------------------------------------------
S0001	홍길동	  SYS	   2013-01-12  1	    NULL	         NULL
S0001	홍길동	  SYS	   2013-03-21  1	    2013-01-12	     68
...생략...
S0002	일지매	  GEN	   2013-07-21  5	    NULL   	         NULL
S0002	일지매	  GEN	   2013-11-17  1	    2013-07-21	     119
...생략...
*/

SELECT v.emp_id, e.emp_name, e.dept_id, v.begin_date, v.duration,
       LAG(v.begin_date, 1) OVER (PARTITION BY v.emp_id ORDER BY v.emp_id) AS prev_begin_date,
       DATEDIFF(begin_date, LAG(v.begin_date, 1) OVER (PARTITION BY v.emp_id ORDER BY v.emp_id)) AS date_diff
    FROM vacation AS v
    INNER JOIN employee AS e ON v.emp_id = e.emp_id;
    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --


/*
5. 지정한 범위의 행 만 조회 - LIMIT, OFFSET
*/

-- 직원 정보 조회
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC;

-- 5개 행 표시
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC
    LIMIT 5;

-- 3개 행 제외하고 5개 행 표시    
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC
    LIMIT 5 OFFSET 3;

-- 또는
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC
    LIMIT 3, 5;

-- [MSSQL]
/*
-- 5개 행 표시
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC
    OFFSET 0 ROWS
    FETCH NEXT 5 ROWS ONLY;
    
-- 3개 행 제외하고 5개 행 표시    
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC
    OFFSET 3 ROWS
    FETCH NEXT 5 ROWS ONLY;
*/

-- [ORACLE]
/*
-- 5개 행 표시
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC
    FETCH NEXT 5 ROWS ONLY;

-- 3개 행 제외하고 5개 행 표시
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC
    OFFSET 3 ROWS
    FETCH NEXT 5 ROWS ONLY;

-- WITH TIES 지정
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC
    OFFSET 3 ROWS
    FETCH NEXT 5 ROWS WITH TIES;


-- 퍼센트 지정
SELECT emp_name, emp_id, dept_id, gender, phone, salary
    FROM employee
    ORDER BY emp_name ASC
    OFFSET 3 ROWS
    FETCH NEXT 5 PERCENT ROWS ONLY;
*/

-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --

-- Q) 다음 쿼리문을 기초로 하여 요구되는 쿼리문을 작성하세요.

SELECT v.begin_date, v.emp_id, e.emp_name, e.dept_id, v.reason, v.duration
    FROM vacation AS v
    INNER JOIN employee AS e ON v.emp_id = e.emp_id
    ORDER BY v.begin_date DESC;

-- 맨 앞 5개 행 조회    
 SELECT v.begin_date, v.emp_id, e.emp_name, e.dept_id, v.reason, v.duration
    FROM vacation AS v
    INNER JOIN employee AS e ON v.emp_id = e.emp_id
    ORDER BY v.begin_date DESC
    LIMIT 5;

    
-- 그 다음 5개 행 조회    
SELECT v.begin_date, v.emp_id, e.emp_name, e.dept_id, v.reason, v.duration
	FROM vacation AS v
	INNER JOIN employee AS e ON v.emp_id = e.emp_id
	ORDER BY v.begin_date DESC
	LIMIT 5, 5;
  
    
-- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * -- * --