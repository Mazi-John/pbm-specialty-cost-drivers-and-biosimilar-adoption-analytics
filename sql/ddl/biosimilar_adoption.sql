--BIOSIMILAR PENETRATION ANALYTICS--


--Biosimilar penetration by molecule (claims based)--

SELECT
    d.molecule,

    COUNT(*) FILTER (WHERE d.biosimilar_flag = 1) AS biosimilar_claims,
    COUNT(*) AS total_specialty_claims,

    ROUND(
        COUNT(*) FILTER (WHERE d.biosimilar_flag = 1) * 100.0
        / COUNT(*), 1
    ) AS biosimilar_penetration_pct

FROM claims c
JOIN drug_master d
    ON c.drug_id = d.drug_id

WHERE d.specialty_flag = 1

GROUP BY d.molecule
ORDER BY biosimilar_penetration_pct DESC;



--Biosimilar penetration by molecule (spend based)--

SELECT
    d.molecule,

    ROUND(
        SUM(CASE WHEN d.biosimilar_flag = 1 THEN c.net_cost ELSE 0 END), 2) AS biosimilar_spend,
    ROUND(
        SUM(c.net_cost), 2) AS total_specialty_spend,

    ROUND(
        SUM(CASE WHEN d.biosimilar_flag = 1 THEN c.net_cost ELSE 0 END) * 100.0
        / SUM(c.net_cost), 1
    ) AS biosimilar_spend_pct
 

FROM claims c
JOIN drug_master d
    ON c.drug_id = d.drug_id

WHERE d.specialty_flag = 1

GROUP BY d.molecule
ORDER BY biosimilar_spend_pct DESC;


--Overall biosimilar penetration--

SELECT
    ROUND(
        SUM(CASE WHEN d.biosimilar_flag = 1 THEN c.net_cost ELSE 0 END) * 100.0
        / SUM(c.net_cost), 1
    ) AS overall_biosimilar_spend_pct
FROM claims c
JOIN drug_master d
    ON c.drug_id = d.drug_id
WHERE d.specialty_flag = 1;

