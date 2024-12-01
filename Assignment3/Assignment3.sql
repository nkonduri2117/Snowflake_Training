

create database clone_db;

create schema hospital;

-- Task 1

create or replace table patientrecords (
patientid number,
name varchar,
diagnosis varchar,
admissiondate date
);

INSERT INTO PatientRecords VALUES
(1, 'Alice', 'Flu', '2024-11-01'),
(2, 'Bob', 'Cold', '2024-11-02'),
(3, 'Charlie', 'Asthma', '2024-11-03');

alter table PatientRecords add region varchar;

update PatientRecords set region = 'North' where PATIENTID = 1;

CREATE OR REPLACE ROW ACCESS POLICY region_policy AS
(user_region STRING, data_region STRING) RETURNS BOOLEAN ->
user_region = data_region;

alter table PatientRecords add row access policy region_policy on (region,region);

SELECT * FROM PatientRecords;

-- Task 2

create or replace table patientrecords (
patientid number,
name varchar,
diagnosis varchar,
admissiondate date
);

INSERT INTO PatientRecords VALUES
(1, 'Alice', 'Flu', '2024-11-01'),
(2, 'Bob', 'Cold', '2024-11-02'),
(3, 'Charlie', 'Asthma', '2024-11-03');


UPDATE PatientRecords SET Diagnosis = 'Pneumonia' WHERE PatientID = 1;

create or replace table PatientRecordsClone clone PatientRecords at(offset=>-50);

select * from PatientRecords;

select * from PatientRecordsClone;

