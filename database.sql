-- =============================================================================
-- PATIENT RECORD MANAGEMENT SYSTEM - DATABASE INITIALIZATION SCRIPT
-- Database Name: patient_record_db
-- Target: MySQL 5.7+ / MySQL 8.0+ / MariaDB 10.3+
-- College Web Technology Assignment-II
-- =============================================================================

-- Step 1: Create Database if not exists
CREATE DATABASE IF NOT EXISTS `patient_record_db`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE `patient_record_db`;

-- Disable foreign key checks during schema creation
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================================
-- Step 2: Table `users` (System Staff & Administrator Accounts)
-- =============================================================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `password` VARCHAR(255) NOT NULL COMMENT 'BCrypt hashed password',
  `full_name` VARCHAR(100) NOT NULL,
  `role` VARCHAR(20) NOT NULL DEFAULT 'ADMIN' COMMENT 'ADMIN, DOCTOR, STAFF',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- Step 3: Table `patients` (Demographic and Clinical Health Records)
-- =============================================================================
DROP TABLE IF EXISTS `patients`;
CREATE TABLE `patients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` VARCHAR(20) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `dob` DATE NOT NULL,
  `gender` VARCHAR(10) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `email` VARCHAR(100) DEFAULT NULL,
  `address` VARCHAR(255) DEFAULT NULL,
  `blood_group` VARCHAR(5) DEFAULT NULL,
  `medical_history` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_patients_patient_id` (`patient_id`),
  KEY `idx_patients_phone` (`phone`),
  KEY `idx_patients_full_name` (`full_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- Step 4: Table `doctors` (Physicians Roster & Department Rosters)
-- =============================================================================
DROP TABLE IF EXISTS `doctors`;
CREATE TABLE `doctors` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `doctor_id` VARCHAR(20) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `specialization` VARCHAR(100) NOT NULL,
  `department` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `email` VARCHAR(100) DEFAULT NULL,
  `availability` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_doctors_doctor_id` (`doctor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- Step 5: Table `appointments` (Scheduled Patient Consultations)
-- =============================================================================
DROP TABLE IF EXISTS `appointments`;
CREATE TABLE `appointments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `appointment_id` VARCHAR(20) NOT NULL,
  `patient_id` VARCHAR(20) NOT NULL,
  `doctor_id` VARCHAR(20) NOT NULL,
  `appointment_date` DATE NOT NULL,
  `appointment_time` TIME NOT NULL,
  `reason` VARCHAR(255) NOT NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED' COMMENT 'SCHEDULED, COMPLETED, CANCELLED',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_appointments_appointment_id` (`appointment_id`),
  KEY `idx_appointments_patient` (`patient_id`),
  KEY `idx_appointments_doctor` (`doctor_id`),
  KEY `idx_appointments_date` (`appointment_date`),
  CONSTRAINT `fk_appointments_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_appointments_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- Step 6: Seed Initial Demo Data
-- =============================================================================

-- Default Administrator User: username = admin, password = admin123
-- BCrypt hash for 'admin123' (Cost 10)
-- Note: The application also verifies and seeds this account automatically if the table is empty!
INSERT INTO `users` (`username`, `password`, `full_name`, `role`) VALUES
('admin', '$2a$10$7R9jK6j4vWJgE2Y4k8eQeOZv3hYyF0R5sB8o0X8sOq4u.pL2yQ.0m', 'System Administrator', 'ADMIN'),
('nurse_sarah', '$2a$10$7R9jK6j4vWJgE2Y4k8eQeOZv3hYyF0R5sB8o0X8sOq4u.pL2yQ.0m', 'Sarah Davis, RN', 'STAFF');

-- Sample Medical Doctors
INSERT INTO `doctors` (`doctor_id`, `name`, `specialization`, `department`, `phone`, `email`, `availability`) VALUES
('DOC-101', 'Dr. Arthur Miller', 'Cardiology', 'Cardiology & Vascular', '9876500111', 'arthur.miller@hospital.org', 'Mon-Fri 09:00 AM - 01:00 PM'),
('DOC-102', 'Dr. Elena Rostova', 'Neurology', 'Neurosciences', '9876500112', 'elena.rostova@hospital.org', 'Tue-Thu 10:00 AM - 03:00 PM'),
('DOC-103', 'Dr. Rajesh Sharma', 'Pediatrics', 'Child Health Care', '9876500113', 'rajesh.sharma@hospital.org', 'Mon-Sat 08:30 AM - 12:30 PM'),
('DOC-104', 'Dr. Chloe Bennett', 'Orthopedics', 'Bone & Joint Surgery', '9876500114', 'chloe.bennett@hospital.org', 'Wed-Fri 01:00 PM - 05:00 PM'),
('DOC-105', 'Dr. Marcus Vance', 'General Medicine', 'Internal Medicine', '9876500115', 'marcus.vance@hospital.org', 'Mon-Fri 08:00 AM - 04:00 PM');

-- Sample Patient Records (Fictional Demo Patients)
INSERT INTO `patients` (`patient_id`, `full_name`, `dob`, `gender`, `phone`, `email`, `address`, `blood_group`, `medical_history`) VALUES
('PAT-1001', 'John Doe', '1985-04-12', 'Male', '9876543210', 'john.doe@example.com', '124 Park Avenue, City Center', 'O+', 'Mild hypertension, no known drug allergies'),
('PAT-1002', 'Sarah Jenkins', '1992-09-24', 'Female', '9811223344', 'sarah.j@example.com', '45 Highland Blvd, Westside', 'A+', 'Asthma since childhood, carries emergency inhaler'),
('PAT-1003', 'Robert Smith', '1978-11-03', 'Male', '9823456789', 'robert.smith@example.com', '88 Elm Street, Apt 4B', 'B+', 'Type 2 diabetes managed with Metformin'),
('PAT-1004', 'Emily Watson', '2000-01-15', 'Female', '9833445566', 'emily.w@example.com', '12 River View Road', 'AB+', 'Seasonal pollen allergies, regular annual checkups'),
('PAT-1005', 'Michael Chang', '1965-06-30', 'Male', '9844556677', 'michael.chang@example.com', '74 Sunset Boulevard', 'O-', 'Post-coronary angioplasty (2022), on daily statins');

-- Sample Appointments
INSERT INTO `appointments` (`appointment_id`, `patient_id`, `doctor_id`, `appointment_date`, `appointment_time`, `reason`, `status`) VALUES
('APT-5001', 'PAT-1001', 'DOC-101', '2026-11-02', '10:00:00', 'Routine cardiac blood pressure evaluation', 'SCHEDULED'),
('APT-5002', 'PAT-1002', 'DOC-103', '2026-11-03', '11:30:00', 'Respiratory follow-up consultation', 'SCHEDULED'),
('APT-5003', 'PAT-1003', 'DOC-105', '2026-11-04', '09:15:00', 'HbA1c diabetes blood sugar review', 'SCHEDULED'),
('APT-5004', 'PAT-1004', 'DOC-104', '2026-10-20', '14:00:00', 'Ankle sprain follow-up examination', 'COMPLETED'),
('APT-5005', 'PAT-1005', 'DOC-101', '2026-10-18', '10:30:00', 'Post-angioplasty 6-month checkup', 'COMPLETED');
