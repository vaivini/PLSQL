SELECT 'Conferencia' tipo,
	m.codigo_conferente AS codigo,
	u.nome AS nome,
	COUNT (DISTINCT M.numeroom) AS qt_oms,
	round(COUNT (DISTINCT M.numeroom)/ 8.00,3) AS qt_oms_hora,	
(SELECT 
	COUNT(DISTINCT T.numeroom) qt_oms_mes
FROM
	movimentacao	t 
	INNER JOIN produto P ON (t.produto_id = P.ID)
	LEFT JOIN endereco ee ON (t.endereco_id = ee.ID)
	LEFT JOIN usuario u ON (u.ID = t.codigo_conferente) 
WHERE
	t.estornado = 'N' 	
	AND t.tipo IN (13,16)
	AND t.codigo_conferente = m.codigo_conferente
	AND  t.CODIGO_CONFERENTE IS NOT NULL 	
	AND date_trunc('day', t.data_inicio_conferencia) >= (select date_trunc('month',CURRENT_DATE)::date)
	AND date_trunc('day', t.data_inicio_conferencia) <= (SELECT(date_trunc('month',CURRENT_DATE)+interval '1 month'-interval '1 day')::date)
GROUP BY
	t.codigo_conferente,
	u.nome),	
	COUNT (M.produto_id) AS qt_sku,
	round(COUNT (M.produto_id) / 8.00,3) AS qt_sku_hora,
(SELECT 
	COUNT(T.produto_id) AS qt_sku_mes
FROM
	movimentacao	t
	INNER JOIN produto P ON (t.produto_id = P.ID)
	LEFT JOIN endereco ee ON (t.endereco_id = ee.ID)
	LEFT JOIN usuario u ON (u.ID = t.codigo_conferente) 
WHERE
	t.estornado = 'N' 	
	AND t.tipo IN (13,16)
	AND t.codigo_conferente = m.codigo_conferente
	AND t.CODIGO_CONFERENTE IS NOT NULL 	
	AND date_trunc('day', t.data_inicio_conferencia) >= (select date_trunc('month',CURRENT_DATE)::date)
	AND date_trunc('day', t.data_inicio_conferencia) <= (SELECT(date_trunc('month',CURRENT_DATE)+interval '1 month'-interval '1 day')::date)
GROUP BY
	t.codigo_conferente,
	u.nome
),
	SUM (M.qtconferida) AS quantidade,
	round(cast(SUM (M.qtconferida) as integer )/ 8.00,3)AS quantidade_hora,
(SELECT 
	SUM(t.qtconferida) AS quantidade_mes
FROM
	movimentacao	t 
	INNER JOIN produto P ON (t.produto_id = P.ID)
	LEFT JOIN endereco ee ON (t.endereco_id = ee.ID)
	LEFT JOIN usuario u ON (u.ID = t.codigo_conferente) 
WHERE
	t.estornado = 'N' 	
	AND t.tipo IN (13,16)
	AND t.codigo_conferente = m.codigo_conferente
	--AND M.codigo_separador <> M.codigo_conferente
	AND  t.CODIGO_CONFERENTE IS NOT NULL 	
	AND date_trunc('day', t.data_inicio_conferencia) >= (select date_trunc('month',CURRENT_DATE)::date)
	AND date_trunc('day', t.data_inicio_conferencia) <= (SELECT(date_trunc('month',CURRENT_DATE)+interval '1 month'-interval '1 day')::date)
GROUP BY
	t.codigo_conferente,
	u.nome)
FROM
	movimentacao M 
	INNER JOIN produto P ON (M.produto_id = P.ID)
	LEFT JOIN endereco ee ON (M.endereco_id = ee.ID)
	LEFT JOIN usuario u ON (u.ID = M.codigo_conferente) 
WHERE
	M.estornado = 'N' 	
	AND M.tipo IN (13,16)
	AND  M.CODIGO_CONFERENTE IS NOT NULL 	
	AND date_trunc( 'day', M.data_inicio_conferencia ) >= to_date( ''||'26-01-2023', 'dd/mm/yyyy' )
GROUP BY
	M.codigo_conferente,
	u.nome
ORDER BY
	quantidade DESC,
	qt_sku DESC,
	qt_oms DESC

