--CREATE drug_master TABLE--

CREATE TABLE drug_master (
    drug_id INT PRIMARY KEY,
    drug_name TEXT,
    molecule TEXT,
    therapeutic_class TEXT,
    specialty_flag INT,
    biosimilar_flag INT,
    annual_cost NUMERIC,
    rebate_pct NUMERIC
);



--INSERT INTO drug_master TABLE--

INSERT INTO drug_master VALUES
-- Adalimumab
(1,'Humira','adalimumab','TNF Inhibitor',1,0,28000,0.20),
(2,'Amgevita','adalimumab','TNF Inhibitor',1,1,21000,0.10),

-- Etanercept
(3,'Enbrel','etanercept','TNF Inhibitor',1,0,24000,0.18),
(4,'Erelzi','etanercept','TNF Inhibitor',1,1,18000,0.08),

-- Infliximab
(5,'Remicade','infliximab','TNF Inhibitor',1,0,26000,0.22),
(6,'Inflectra','infliximab','TNF Inhibitor',1,1,19500,0.10),

-- IL inhibitor
(7,'Stelara','ustekinumab','IL Inhibitor',1,0,32000,0.18),

-- Oncology biologic
(8,'Keytruda','pembrolizumab','Oncology',1,0,55000,0.12);



--INSERT non-specialty drug--

INSERT INTO drug_master VALUES
(9,'Atorvastatin','atorvastatin','Statin',0,0,120,0.00),
(10,'Metformin','metformin','Diabetes Oral',0,0,100,0.00),
(11,'Sertraline','sertraline','Antidepressant',0,0,180,0.00),
(12,'Amlodipine','amlodipine','Hypertension',0,0,150,0.00),
(13,'Amoxicillin','amoxicillin','Antibiotic',0,0,40,0.00);
