--NEW BIOSIMILAR START ANALYSTICS--
/* are putting patients on biosimilars when they start therapy?*/

CREATE TEMP TABLE molecule_first_claim AS
SELECT
    c.member_id,
    d.molecule,
    MIN(c.fill_date) AS first_fill_date
FROM claims c
JOIN drug_master d
    ON c.drug_id = d.drug_id
WHERE d.specialty_flag = 1
GROUP BY c.member_id, d.molecule;



--attach the actual drugs used at initiation--

CREATE TEMP TABLE new_starts AS
SELECT
    mfc.member_id,
    mfc.molecule,
    c.drug_id,
    d.biosimilar_flag,
    mfc.first_fill_date
FROM molecule_first_claim mfc
JOIN claims c
    ON c.member_id = mfc.member_id
   AND c.fill_date = mfc.first_fill_date
JOIN drug_master d
    ON c.drug_id = d.drug_id;


--compute % new starts on biosimilars--

SELECT
    COUNT(*) FILTER (WHERE biosimilar_flag = 1) * 100.0
    / COUNT(*) AS pct_new_starts_biosimilar
FROM new_starts;


--break down new start by molecule--

SELECT
    molecule,
    COUNT(*) AS total_new_starts,
    COUNT(*) FILTER (WHERE biosimilar_flag = 1) AS biosimilar_starts,
    ROUND(
        COUNT(*) FILTER (WHERE biosimilar_flag = 1) * 100.0
        / COUNT(*),
        1
    ) AS biosimilar_pct
FROM new_starts
GROUP BY molecule
ORDER BY biosimilar_pct DESC;


--strong--

SELECT
    DATE_TRUNC('month', first_fill_date) AS month,
    ROUND(
        COUNT(*) FILTER (WHERE biosimilar_flag = 1) * 100.0
        / COUNT(*),
        1
    ) AS biosimilar_new_start_pct
FROM new_starts
GROUP BY month
ORDER BY month;

--clinet level variation--

SELECT
    m.client_id,
    ROUND(
        COUNT(*) FILTER (WHERE ns.biosimilar_flag = 1) * 100.0
        / COUNT(*),
        1
    ) AS biosimilar_new_start_pct
FROM new_starts ns
JOIN members m ON ns.member_id = m.member_id
GROUP BY m.client_id
ORDER BY biosimilar_new_start_pct DESC;

