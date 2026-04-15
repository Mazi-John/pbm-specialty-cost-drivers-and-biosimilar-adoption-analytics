--CREATE MEMBER SPECIALTY DRUG TABLE--


CREATE TABLE member_specialty_drug (
    member_id INT,
    drug_id INT
);



INSERT INTO member_specialty_drug (member_id, drug_id)

SELECT
    m.member_id,

    CASE
        WHEN r < 0.25 THEN 1
        WHEN r < 0.40 THEN 2
        WHEN r < 0.55 THEN 3
        WHEN r < 0.65 THEN 4
        WHEN r < 0.75 THEN 5
        WHEN r < 0.85 THEN 6
        WHEN r < 0.95 THEN 7
        ELSE 8
    END AS drug_id

FROM (
    SELECT
        member_id,
        RANDOM() AS r
    FROM members
    WHERE autoimmune_flag = 1
) m;

