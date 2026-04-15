
--CREATE SPECIALTY ASSIGNMENT TABLE--


CREATE TABLE specialty_assignment AS
SELECT
    m.member_id,
    m.client_id,
    m.province,

    -- 60% treated
    CASE WHEN RANDOM() < 0.60 THEN 1 ELSE 0 END AS treated_flag

FROM members m
WHERE m.autoimmune_flag = 1;