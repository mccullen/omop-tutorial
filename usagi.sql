WITH unmapped AS (
	SELECT 
		'SNOMED' AS vocabulary_id, 
		c.code, 
		c.description, 
		COUNT(*) AS freq,
		'Condition' AS domain_id
	FROM native.conditions AS c
	WHERE NOT EXISTS (
		SELECT 1
		FROM cdm.CONCEPT_RELATIONSHIP AS cr
		INNER JOIN cdm.CONCEPT AS c2 ON c2.concept_id = cr.concept_id_1
		WHERE c.code = c2.concept_code AND 'SNOMED' = c2.vocabulary_id AND cr.relationship_id = 'Maps to'
	)
	GROUP BY c.code, c.description

	UNION

	SELECT 
		'RxNorm' AS vocabulary_id, 
		c.code, 
		c.description, 
		COUNT(*) AS freq,
		'Drug' AS domain_id
	FROM native.medications AS c
	WHERE NOT EXISTS (
		SELECT 1
		FROM cdm.CONCEPT_RELATIONSHIP AS cr
		INNER JOIN cdm.CONCEPT AS c2 ON c2.concept_id = cr.concept_id_1
		WHERE c.code = c2.concept_code AND 'RxNorm' = c2.vocabulary_id AND cr.relationship_id = 'Maps to'
	)
	GROUP BY c.code, c.description

	UNION

	SELECT 
		'SNOMED' AS vocabulary_id, 
		c.code, 
		c.description, 
		COUNT(*) AS freq,
		'Procedure' AS domain_id
	FROM native.procedures AS c
	WHERE NOT EXISTS (
		SELECT 1
		FROM cdm.CONCEPT_RELATIONSHIP AS cr
		INNER JOIN cdm.CONCEPT AS c2 ON c2.concept_id = cr.concept_id_1
		WHERE c.code = c2.concept_code AND 'SNOMED' = c2.vocabulary_id AND cr.relationship_id = 'Maps to'
	)
	GROUP BY c.code, c.description
)
SELECT * FROM unmapped ORDER BY freq DESC;