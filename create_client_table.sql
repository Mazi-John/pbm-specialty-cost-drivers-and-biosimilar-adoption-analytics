
--CREATE CLIENT TABLE--

CREATE TABLE clients (
    client_id INT PRIMARY KEY,
    client_name TEXT,
    industry TEXT,
    province TEXT,
    lives INT,
    funding_type TEXT
);



--INSERT INTO CLIENT TABLE--

INSERT INTO clients
SELECT
    gs.client_id,
    'Client_' || gs.client_id AS client_name,
    CASE
        WHEN r < 0.18 THEN 'Manufacturing'
        WHEN r < 0.32 THEN 'Retail'
        WHEN r < 0.45 THEN 'Healthcare'
        WHEN r < 0.58 THEN 'Technology'
        WHEN r < 0.68 THEN 'Finance'
        WHEN r < 0.78 THEN 'Education'
        WHEN r < 0.86 THEN 'Construction'
        WHEN r < 0.92 THEN 'Transportation'
        WHEN r < 0.97 THEN 'Hospitality'
        ELSE 'Energy'
    END AS industry,
    CASE
        WHEN RANDOM() < 0.80 THEN 'Ontario'
        ELSE 'Other'
    END AS province,
    CAST(200 + (POWER(RANDOM(), 2) * 4800) AS INT) AS lives,
    CASE
        WHEN RANDOM() < 0.6 THEN 'Fully Insured'
        ELSE 'Self-Insured'
    END AS funding_type
FROM (
    SELECT
        generate_series(1, 30) AS client_id,
        RANDOM() AS r
) gs;
