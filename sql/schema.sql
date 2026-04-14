-- =========================================================
-- HEALTHCARE DATA ANALYTICS - DATABASE SCHEMA
-- =========================================================

-- Drop tables if they already exist (to avoid conflicts)
DROP TABLE IF EXISTS admissions;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS province_names;


-- =========================================================
-- TABLE: province_names
-- =========================================================
CREATE TABLE province_names (
    province_id VARCHAR(10) PRIMARY KEY,
    province_name VARCHAR(100) NOT NULL
);


-- =========================================================
-- TABLE: doctors
-- =========================================================
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100)
);


-- =========================================================
-- TABLE: patients
-- =========================================================
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1),
    birth_date DATE,
    city VARCHAR(50),
    province_id VARCHAR(10),
    allergies VARCHAR(100),
    height INT,
    weight INT,

    CONSTRAINT fk_patient_province
        FOREIGN KEY (province_id)
        REFERENCES province_names(province_id)
);


-- =========================================================
-- TABLE: admissions
-- =========================================================
CREATE TABLE admissions (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    admission_date DATE,
    discharge_date DATE,
    diagnosis VARCHAR(255),
    attending_doctor_id INT,

    CONSTRAINT fk_admission_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_admission_doctor
        FOREIGN KEY (attending_doctor_id)
        REFERENCES doctors(doctor_id)
);