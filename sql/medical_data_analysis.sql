/* =========================================================
   HEALTHCARE DATA ANALYTICS PROJECT
   Description: Patient & Hospital Data Analysis using SQL
   ========================================================= */


/* =========================================================
   1. DATABASE EXPLORATION
   ========================================================= */

-- Preview Patients Dataset
SELECT *
FROM patients;

-- Preview Admissions Dataset
SELECT *
FROM admissions;

-- Preview Doctors Dataset
SELECT *
FROM doctors;

-- Preview Province Reference Data
SELECT *
FROM province_names;

-- Record Count Summary
SELECT COUNT(*) AS total_patients FROM patients;
SELECT COUNT(*) AS total_admissions FROM admissions;
SELECT COUNT(*) AS total_doctors FROM doctors;
SELECT COUNT(*) AS total_provinces FROM province_names;



/* =========================================================
   2. DATA CLEANING & PREPARATION
   ========================================================= */

-- Handling Missing Allergy Information (Replace NULL with 'NKA')
SELECT 
    first_name,
    last_name,
    IFNULL(allergies, 'NKA') AS allergies
FROM patients;

-- Standardized Full Name Creation
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;

-- Formatted Name for Reporting (LASTNAME,firstname)
SELECT 
    CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS formatted_name
FROM patients
ORDER BY first_name DESC;



/* =========================================================
   3. BUSINESS ANALYSIS QUERIES
   ========================================================= */

-- Male Patient Demographics
SELECT 
    first_name,
    last_name,
    gender
FROM patients
WHERE gender = 'M';

-- Patients Without Recorded Allergies
SELECT 
    first_name,
    last_name
FROM patients
WHERE allergies IS NULL;

-- Patients with Names Starting with 'C'
SELECT 
    first_name
FROM patients
WHERE first_name LIKE 'C%';

-- Patients Within Target Weight Range (100–120 kg)
SELECT 
    first_name,
    last_name
FROM patients
WHERE weight BETWEEN 100 AND 120;

-- Patient-Province Mapping Analysis
SELECT 
    p.first_name,
    p.last_name,
    pr.province_name
FROM patients AS p
INNER JOIN province_names AS pr
    ON p.province_id = pr.province_id;

-- Patient Birth Year Analysis (2010 Cohort)
SELECT 
    COUNT(*) AS total_2010_births
FROM patients
WHERE YEAR(birth_date) = 2010;

-- Tallest Patient Identification
SELECT 
    first_name,
    last_name,
    height
FROM patients
WHERE height = (
    SELECT MAX(height)
    FROM patients
);

-- Targeted Patient Record Extraction
SELECT *
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000);

-- Total Hospital Admissions Overview
SELECT 
    COUNT(*) AS total_admissions
FROM admissions;

-- Same-Day Admission and Discharge Cases
SELECT *
FROM admissions
WHERE admission_date = discharge_date;

-- Patient-Specific Admission Frequency (ID: 579)
SELECT 
    COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;

-- Regional Patient Distribution (Province NS)
SELECT DISTINCT 
    city
FROM patients
WHERE province_id = 'NS';

-- High-Risk Patient Identification (Height & Weight Criteria)
SELECT 
    first_name,
    last_name,
    birth_date
FROM patients
WHERE height > 160 
  AND weight > 70;

-- Patient Birth Year Distribution
SELECT DISTINCT 
    YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year ASC;

-- Unique Patient Name Identification
SELECT 
    first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1;

-- Pattern-Based Patient Name Analysis
SELECT 
    patient_id,
    first_name
FROM patients
WHERE first_name LIKE 's%s'
  AND LENGTH(first_name) >= 6;

-- Dementia Diagnosis Patient Analysis
SELECT DISTINCT
    p.patient_id,
    p.first_name,
    p.last_name
FROM patients AS p
INNER JOIN admissions AS a
    ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';

-- Patient Name Sorting by Length and Alphabet
SELECT 
    first_name
FROM patients
ORDER BY LENGTH(first_name), first_name;

-- Gender Distribution Summary
SELECT 
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM patients;

-- Repeated Diagnosis Admission Analysis
SELECT 
    patient_id,
    diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;

-- City-wise Patient Distribution Analysis
SELECT 
    city,
    COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC, city ASC;

-- Unified Healthcare Personnel View (Patients & Doctors)
SELECT 
    first_name,
    last_name,
    'Patient' AS role
FROM patients

UNION

SELECT 
    first_name,
    last_name,
    'Doctor' AS role
FROM doctors;

-- Allergy Prevalence Analysis
SELECT 
    allergies,
    COUNT(*) AS total_occurrences
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_occurrences DESC;

-- 1970s Patient Cohort Analysis
SELECT 
    first_name,
    last_name,
    birth_date
FROM patients
WHERE birth_date BETWEEN '1970-01-01' AND '1979-12-31'
ORDER BY birth_date ASC;

-- Regional Height Aggregation Analysis
SELECT 
    province_id,
    SUM(height) AS total_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;

-- Weight Variability Analysis (Maroni Patients)
SELECT 
    MAX(weight) - MIN(weight) AS weight_difference
FROM patients
WHERE last_name = 'Maroni';

-- Daily Admission Trend Analysis
SELECT 
    DAY(admission_date) AS day_of_month,
    COUNT(*) AS total_admissions
FROM admissions
GROUP BY day_of_month
ORDER BY total_admissions DESC;

-- Patient Weight Segmentation Analysis
SELECT 
    FLOOR(weight / 10) * 10 AS weight_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

-- Obesity Classification using BMI Logic
SELECT 
    patient_id,
    weight,
    height,
    CASE 
        WHEN weight / POWER(height / 100, 2) >= 30 THEN 1
        ELSE 0
    END AS is_obese
FROM patients;

-- Epilepsy Case Analysis with Doctor Specialization
SELECT 
    p.patient_id,
    p.first_name,
    p.last_name,
    d.specialty
FROM patients AS p
INNER JOIN admissions AS a
    ON p.patient_id = a.patient_id
INNER JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy'
  AND d.first_name = 'Lisa';

-- Top 5 Cities by Patient Count
SELECT *
FROM (
    SELECT city, COUNT(*) AS total_patients
    FROM patients
    GROUP BY city
) AS city_counts
ORDER BY total_patients DESC
LIMIT 5;


-- Patient Visit Sequence Based on Admission Date
SELECT 
    a1.patient_id,
    a1.diagnosis,
    a1.admission_date,
    COUNT(*) AS visit_rank
FROM admissions a1
JOIN admissions a2 
    ON a1.patient_id = a2.patient_id
    AND a2.admission_date <= a1.admission_date
GROUP BY 
    a1.patient_id, 
    a1.diagnosis, 
    a1.admission_date
ORDER BY 
    a1.patient_id, 
    a1.admission_date;