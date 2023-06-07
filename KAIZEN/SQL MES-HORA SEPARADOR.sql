SELECT 'Separação'tipo, 
  M.codigo_separador AS codigo,
	u.nome AS nome,
	COUNT(DISTINCT M.numeroom) AS qt_oms,
	round(COUNT(DISTINCT M.numeroom) / 8.00,3) AS oms_hora,
	--INICIO SQL CALCULO POR MÊS OMS
(SELECT 
	COUNT(DISTINCT t.numeroom) AS qt_oms_mes
FROM
	movimentacao	t 
	INNER JOIN produto P ON (t.produto_id = P.ID)
	LEFT JOIN endereco ee ON (t.endereco_id = ee.ID)
	LEFT JOIN usuario u ON (u.ID = t.codigo_separador) 
WHERE
	t.estornado = 'N' 
	AND t.tipo IN (13,16) 
	AND t.CODIGO_SEPARADOR IS NOT NULL 
	AND m.codigo_separador = t.codigo_separador
	AND date_trunc('day', t.data_inicio_separacao) >= (select date_trunc('month',CURRENT_DATE)::date)
	AND date_trunc('day', t.data_inicio_separacao) <= (SELECT(date_trunc('month',CURRENT_DATE)+interval '1 month'-interval '1 day')::date)
GROUP BY
	t.codigo_separador,
	u.nome),
	-- FIM SQL CALCULO POR MÊS
	COUNT(M.produto_id) AS qt_sku,
	round(COUNT(M.produto_id) / 8.00,3) AS sku_hora,
	--INICIO SQL CALCULO POR MÊS SKU
(SELECT 
	COUNT(t.produto_id) as qt_sku_mes
FROM
	movimentacao t 
	INNER JOIN produto P ON (t.produto_id = P.ID)
	LEFT JOIN endereco ee ON (t.endereco_id = ee.ID)
	LEFT JOIN usuario u ON (u.ID = t.codigo_separador) 
WHERE
	t.estornado = 'N' 
	AND t.tipo IN (13,16) 
	AND m.codigo_separador = t.codigo_separador
	AND t.CODIGO_SEPARADOR IS NOT NULL 
	AND date_trunc('day', t.data_inicio_separacao) >= (select date_trunc('month',CURRENT_DATE)::date)
	AND date_trunc('day', t.data_inicio_separacao) <= (SELECT(date_trunc('month',CURRENT_DATE)+interval '1 month'-interval '1 day')::date)
GROUP BY
	M.codigo_separador,
	u.nome),
	-- FIM SQL CALCULO POR MÊS
	SUM(M.qtseparada) AS quantidade,
	round(cast(SUM(M.qtseparada) as integer) / 8.00, 3) as qt_hora,
	---INICIO SQL CALCULO POR MÊS ITENS
(SELECT 
	SUM(t.qtseparada) AS qt_mes
FROM
	movimentacao
	t INNER JOIN produto P ON (t.produto_id = P.ID)
	LEFT JOIN endereco ee ON (t.endereco_id = ee.ID)
	LEFT JOIN usuario u ON (u.ID = t.codigo_separador) 
WHERE
	t.estornado = 'N' 
	AND t.tipo IN (13,16) 
	AND t.CODIGO_SEPARADOR IS NOT NULL 
	AND m.codigo_separador = t.codigo_separador
	AND date_trunc('day', t.data_inicio_separacao) >= (select date_trunc('month',CURRENT_DATE)::date)
	AND date_trunc('day', t.data_inicio_separacao) <= (SELECT(date_trunc('month',CURRENT_DATE)+interval '1 month'-interval '1 day')::date)
GROUP BY
	t.codigo_separador,
	u.nome)
	-- FIM SQL CALCULO POR MÊS
FROM
	movimentacao M 
	INNER JOIN produto P ON (M.produto_id = P.ID)
	LEFT JOIN endereco ee ON (M.endereco_id = ee.ID)
	LEFT JOIN usuario u ON (u.ID = M.codigo_separador) 
WHERE
	M.estornado = 'N' 
	AND  M.tipo IN (13,16) 
	AND  M.CODIGO_SEPARADOR IS NOT NULL 
	AND  date_trunc('day', M.data_inicio_separacao) >= to_date( ''||'24-01-2023', 'dd/mm/yyyy' )
GROUP BY
	M.codigo_separador,
	u.nome
ORDER BY 
	qt_sku DESC,
	quantidade DESC,
	qt_oms DESC