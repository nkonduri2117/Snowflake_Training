
USE DATABASE TEST_DB;

USE SCHEMA HOSPITAL;

CREATE OR REPLACE FILE FORMAT MY_PATIENT_FILE TYPE = CSV 
FIELD_OPTIONALLY_ENCLOSED_BY='"'
SKIP_HEADER = 1;


CREATE or replace STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::905418295534:role/snowflake_role'
  STORAGE_ALLOWED_LOCATIONS = ('*');


DESC INTEGRATION s3_int;

CREATE OR REPLACE STAGE my_patient_stage
  STORAGE_INTEGRATION = s3_int
  URL = 's3://healthrecords29112024/patientrecords'
  FILE_FORMAT = MY_PATIENT_FILE;

  CREATE OR REPLACE TABLE PATIENT(
  ID NUMBER, 
  FIRST_NAME VARCHAR, 
  LAST_NAME VARCHAR, 
  DIAGNOSIS VARCHAR, 
  AdmissionDate date,
  DischargeDate date);

  COPY INTO PATIENT FROM @my_patient_stage file_format = MY_PATIENT_FILE;

  SELECT * FROM PATIENT;

  CREATE MATERIALIZED VIEW AvgStayByDiangnosis AS 
  SELECT DIAGNOSIS, AVG(DATEDIFF(DAY,ADMISSIONDATE,DISCHARGEDATE)) AS AvgStay 
  FROM PATIENT 
  GROUP BY DIAGNOSIS;

  SELECT * FROM AvgStayByDiangnosis;