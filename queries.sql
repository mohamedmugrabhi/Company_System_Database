SELECT 
    s.full_name,
    p.pname,
    w.hours
FROM Works_On w
JOIN Staff s
ON w.eid = s.eid
JOIN Project p
ON w.pid = p.pid;

SELECT 
    department_id,
    AVG(salary) AS avg_salary
FROM Staff
GROUP BY department_id;
