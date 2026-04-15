--CREATE client_annual_trend TABLE--


CREATE TABLE client_annual_trend (
    client_id INT,
    year INT,
    total_members INT,
    total_spend NUMERIC,
    total_pmpm NUMERIC,
    specialty_spend NUMERIC,
    specialty_pmpm NUMERIC,
    specialty_spend_pct NUMERIC
);




--GENERATE MULTI-YEAR DATA--

INSERT INTO client_annual_trend

SELECT
    s.client_id,
    y.year,

    s.total_members,

    -- Total spend trend
    s.total_spend *
        CASE
            WHEN y.year = 2022 THEN 1.00
            WHEN y.year = 2023 THEN 1.06
            WHEN y.year = 2024 THEN 1.15
        END AS total_spend,

    -- PMPM trend
    (s.total_spend *
        CASE
            WHEN y.year = 2022 THEN 1.00
            WHEN y.year = 2023 THEN 1.06
            WHEN y.year = 2024 THEN 1.15
        END) / s.total_members / 12 AS total_pmpm,

    -- Specialty grows faster
    s.specialty_spend *
        CASE
            WHEN y.year = 2022 THEN 1.00
            WHEN y.year = 2023 THEN 1.12
            WHEN y.year = 2024 THEN 1.28
        END AS specialty_spend,

    -- Specialty PMPM
    (s.specialty_spend *
        CASE
            WHEN y.year = 2022 THEN 1.00
            WHEN y.year = 2023 THEN 1.12
            WHEN y.year = 2024 THEN 1.28
        END) / s.total_members / 12 AS specialty_pmpm,

    -- Specialty share increases over time
    (s.specialty_spend *
        CASE
            WHEN y.year = 2022 THEN 1.00
            WHEN y.year = 2023 THEN 1.12
            WHEN y.year = 2024 THEN 1.28
        END)
    /
    (s.total_spend *
        CASE
            WHEN y.year = 2022 THEN 1.00
            WHEN y.year = 2023 THEN 1.06
            WHEN y.year = 2024 THEN 1.15
        END)
    * 100 AS specialty_spend_pct

FROM client_annual_summary s
CROSS JOIN (
    SELECT 2022 AS year
    UNION ALL
    SELECT 2023
    UNION ALL
    SELECT 2024
) y;
