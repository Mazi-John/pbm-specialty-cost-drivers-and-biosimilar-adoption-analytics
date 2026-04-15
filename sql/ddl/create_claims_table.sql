--CREATE CLAIMS TABLE--


CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,
    member_id INT,
    drug_id INT,
    fill_date DATE,
    allowed_cost NUMERIC,
    rebate_amount NUMERIC,
    net_cost NUMERIC,
    days_supply INT
);




--GENERATE SPECIALTY CLAIMS--

INSERT INTO claims
(member_id, drug_id, fill_date, allowed_cost, rebate_amount, net_cost, days_supply)

SELECT
    msd.member_id,
    msd.drug_id,
    (DATE '2024-01-01' + (INTERVAL '1 month' * gs.month_num))::date,
    dm.annual_cost / 12,
    (dm.annual_cost / 12) * dm.rebate_pct,
    (dm.annual_cost / 12) * (1 - dm.rebate_pct),
    30

FROM member_specialty_drug msd
JOIN drug_master dm
    ON msd.drug_id = dm.drug_id
JOIN generate_series(0,11) gs(month_num)
    ON TRUE;




--GENERATE NON-SPECIALTY CLAIMS--

INSERT INTO claims
(member_id, drug_id, fill_date, allowed_cost, rebate_amount, net_cost, days_supply)

SELECT
    m.member_id,

    CASE
        WHEN r < 0.30 THEN 9   -- atorvastatin (high volume)
        WHEN r < 0.55 THEN 10  -- metformin
        WHEN r < 0.75 THEN 11  -- sertraline
        WHEN r < 0.90 THEN 12  -- amlodipine
        ELSE 13                -- amoxicillin
    END AS drug_id,

    (DATE '2024-01-01'
      + (INTERVAL '1 month' * FLOOR(RANDOM()*12)))::date,

    dm.annual_cost / 6,
    0,
    dm.annual_cost / 6,
    30

FROM (
    SELECT
        m.member_id,
        RANDOM() AS r
    FROM members m
    JOIN generate_series(1,6) gs(n) ON TRUE
) m

JOIN drug_master dm
  ON dm.drug_id =
    CASE
        WHEN r < 0.30 THEN 9
        WHEN r < 0.55 THEN 10
        WHEN r < 0.75 THEN 11
        WHEN r < 0.90 THEN 12
        ELSE 13
    END;

