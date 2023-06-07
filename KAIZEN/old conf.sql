- conferente antigo : 
SELECT M
.codigo_conferente AS codigo, u.nome,
COUNT ( DISTINCT M.numeroom ) AS qt_oms,
COUNT ( M.produto_id ) AS qt_sku,
SUM ( M.qtconferida ) AS quantidade 
FROM
	movimentacao
	M INNER JOIN produto P ON M.produto_id = P.
	ID LEFT OUTER JOIN endereco ee ON M.endereco_id = ee.
	ID LEFT OUTER JOIN usuario u ON u.ID = M.codigo_conferente 
WHERE
	( M.estornado = 'N' ) 
	AND ( M.conferido = 'S' ) 
	AND ( M.tipo IN ( 13, 16 ) ) 
	AND ( M.codigo_separador <> M.codigo_conferente ) 
	AND ( date_trunc( 'day', M.data_inicio_conferencia ) >= to_date( @DATA, 'dd/mm/yyyy' ) ) 
	AND ( date_trunc( 'day', M.data_fim_conferencia ) <= to_date( @DATA, 'dd/mm/yyyy' ) ) 
GROUP BY
	M.codigo_conferente,
	u.nome 
ORDER BY
	quantidade DESC,
	qt_sku DESC,
	qt_oms DESC
