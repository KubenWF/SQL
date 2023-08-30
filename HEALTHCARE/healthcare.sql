SELECT * FROM healthcare.insurance;

-- 1. What is the distribution of patients based on age and gender?

SELECT age, sex, COUNT(*) AS patient_count
FROM healthcare.insurance
GROUP BY age, sex
ORDER BY age, sex;
-- 2. What is the average, minimum, and maximum medical charges?

SELECT AVG(charges), MAX(charges), MIN(charges) 
FROM healthcare.insurance;
-- 3.Are there any regional variations in medical charges 

SELECT region, AVG(charges) AS average_charges
FROM healthcare.insurance
GROUP BY region;
-- 4. Do males and females have significantly different medical charges?

SELECT
sex,
AVG(charges) AS average_charges,
COUNT(*) AS sample_size,
FROM
    healthcare.insurance
GROUP BY 
    sex;
-- 5.Is there a pattern in medical charges among smokers based on their age?

SELECT
    FLOOR(age / 10) * 10 AS age_group,
    AVG(charges) AS average_charges
FROM
    healthcare.insurance
WHERE
    smoker = 'yes'
GROUP BY
    age_group
ORDER BY
    age_group;