
CREATE VIEW healthcare_performance_analytics AS
SELECT
e.ENCOUNTERCLASS AS encounter_type,
e.DESCRIPTION AS procedure_name,
p.name AS insurance_payer,
SUM(e.BASE_ENCOUNTER_COST) AS HOSPITAL_BASE_COST,
SUM(e.TOTAL_CLAIM_COST) AS total_billed_amount,
SUM(e.PAYER_COVERAGE) AS insurance_coverage_amount,
SUM(e.PAYER_COVERAGE) - SUM(e.BASE_ENCOUNTER_COST) AS net_financial_result
FROM encounters e
JOIN payers p ON e.PAYER= p.id
GROUP BY 1,2,3;




