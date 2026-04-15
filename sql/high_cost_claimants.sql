--HIGH COST CLAIMANT ANALYSIS--

--top 1%--
--STEP 1: ANNUAL SPEND PER MEMBER-
CREATE TEMP TABLE member_annual_spend AS
SELECT member_id, SUM (net_cost) AS annual_spend
FROM claims
GROUP BY member_id;

--STEP 2: IDENTIFY TOP 1% THRESHHOLD--
SELECT
    PERCENTILE_CONT(0.99) 
    WITHIN GROUP (ORDER BY annual_spend) AS p99_threshold
FROM member_annual_spend;

--STEP 3: EXTRACT TOP 1% CLAIMANTS--
SELECT *
FROM member_annual_spend
WHERE annual_spend >= (
    SELECT PERCENTILE_CONT(0.99)
    WITHIN GROUP (ORDER BY annual_spend)
    FROM member_annual_spend
);

--STEP 4: COUNT & % OF TOTAL--
SELECT
    COUNT(*) AS top_1pct_members,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM member_annual_spend) AS pct_members,
    ROUND (SUM(annual_spend),2) AS top_1pct_spend,
    ROUND(SUM(annual_spend) * 100.0 /
        (SELECT SUM(annual_spend) FROM member_annual_spend),1) AS pct_total_spend
FROM member_annual_spend
WHERE annual_spend >= (
    SELECT PERCENTILE_CONT(0.99)
    WITHIN GROUP (ORDER BY annual_spend)
    FROM member_annual_spend
);

--STEP 5: HOW MUCH DOLLAR DO THEY DRIVE--
SELECT
    ROUND (SUM(annual_spend),2) AS top_1pct_spend,
    ROUND(SUM(annual_spend) * 100.0 /
        (SELECT SUM(annual_spend) FROM member_annual_spend),1) AS pct_total_spend
FROM member_annual_spend
WHERE annual_spend >= (
    SELECT PERCENTILE_CONT(0.99)
    WITHIN GROUP (ORDER BY annual_spend)
    FROM member_annual_spend --top 1% of claimants drive 53.7% of total claim payments--
);

--TOP 1% BY DRUG TYPE--
SELECT
    d.molecule,
    ROUND(SUM(c.net_cost), 2) AS annual_spend,
    (annual_spend *100 / annual_spend) AS molecule_pct_spend
FROM claims c
JOIN drug_master d ON c.drug_id = d.drug_id
WHERE c.member_id IN (
    SELECT member_id
    FROM member_annual_spend
    WHERE annual_spend >= (
        SELECT PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY annual_spend)
        FROM member_annual_spend
    )
)
GROUP BY d.molecule
ORDER BY annual_spend DESC;