- conferetne novo : 
SELECT M
.codigo_conferente AS codigo,
u.nome,
COUNT ( DISTINCT M.numeroom ) AS qt_oms,
COUNT ( M.produto_id ) AS qt_sku,
SUM ( M.qtconferida ) AS quantidade 
FROM
	(
		(
			( movimentacao M JOIN produto P ON ( ( M.produto_id = P.ID ) ) )
			LEFT JOIN endereco ee ON ( ( M.endereco_id = ee.ID ) ) 
		)
		LEFT JOIN usuario u ON ( ( u.ID = M.codigo_conferente ) ) 
	) 
WHERE
	(
		( M.estornado = 'N' :: bpchar ) 
		AND ( M.tipo = ANY ( ARRAY [ ( 13 ) :: BIGINT, ( 16 ) :: BIGINT ] ) ) 
		AND ( M.codigo_conferente IS NOT NULL ) 
		AND ( date_trunc( 'day', M.data_inicio_conferencia ) >= to_date( @DATA, 'dd/mm/yyyy' ) ) 
	) 
GROUP BY
	M.codigo_conferente,
	u.nome 
ORDER BY
	( SUM ( M.qtconferida ) ) DESC,
	( COUNT ( M.produto_id ) ) DESC,
	( COUNT ( DISTINCT M.numeroom ) ) DESC