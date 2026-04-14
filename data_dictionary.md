# 📘 Data Dictionary

This document provides a clear and structured overview of all datasets used in the Healthcare Data Analytics project.  
Each table is described with its purpose and column-level details for easy understanding.

---

## 🧾 Patients Table  
Stores demographic and physical details of patients.

### Columns

| Column        | Type     | Description                          |
|---------------|----------|--------------------------------------|
| patient_id    | INT      | Unique patient identifier            |
| first_name    | VARCHAR  | Patient's first name                 |
| last_name     | VARCHAR  | Patient's last name                  |
| gender        | CHAR     | Gender (M/F)                         |
| birth_date    | DATE     | Date of birth                        |
| city          | VARCHAR  | City of residence                    |
| province_id   | VARCHAR  | Links to province_names table        |
| allergies     | VARCHAR  | Known allergies (NULL if none)       |
| height        | INT      | Height in centimeters                |
| weight        | INT      | Weight in kilograms                  |

---

## 🏥 Admissions Table  
Records hospital admissions and medical diagnoses.

### Columns

| Column                | Type     | Description                          |
|-----------------------|----------|--------------------------------------|
| admission_id          | INT      | Unique admission identifier          |
| patient_id            | INT      | Links to patients table              |
| admission_date        | DATE     | Admission date                       |
| discharge_date        | DATE     | Discharge date                       |
| diagnosis             | VARCHAR  | Diagnosed medical condition          |
| attending_doctor_id   | INT      | Links to doctors table               |

---

## 👨‍⚕️ Doctors Table  
Contains information about doctors and their specialties.

### Columns

| Column      | Type     | Description                |
|-------------|----------|----------------------------|
| doctor_id   | INT      | Unique doctor identifier   |
| first_name  | VARCHAR  | Doctor's first name        |
| last_name   | VARCHAR  | Doctor's last name         |
| specialty   | VARCHAR  | Area of specialization     |

---

## 🌍 Province Names Table  
Maps province identifiers to their full names.

### Columns

| Column         | Type     | Description                 |
|----------------|----------|-----------------------------|
| province_id    | VARCHAR  | Unique province identifier  |
| province_name  | VARCHAR  | Full province name          |

---