--CREATE A MEMBERS TABLE--



CREATE TABLE members (
    member_id INT PRIMARY KEY,
    client_id INT,
    age INT,
    gender TEXT,
    province TEXT,
    autoimmune_flag INT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);




--INSERT INTO members--

INSERT INTO members
SELECT
    ROW_NUMBER() OVER () AS member_id,
    c.client_id,

    -- Age 18–65 with mild middle-age concentration
    CAST(
        18 + (POWER(RANDOM(), 1.2) * 47)
    AS INT) AS age,

    CASE
        WHEN RANDOM() < 0.52 THEN 'F'
        ELSE 'M'
    END AS gender,

    c.province,

    CASE
        WHEN RANDOM() < 0.015 THEN 1
        ELSE 0
    END AS autoimmune_flag

FROM clients c
JOIN LATERAL generate_series(1, c.lives) gs(n) ON TRUE;

