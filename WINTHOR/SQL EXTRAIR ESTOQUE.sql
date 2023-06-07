SELECT
	pcest.codprod,
  --pcest.custocont,
  --pcest.custoreal,
  --pcest.custofin,
  --pcest.custorep,

  --pcest.custoultentfin,
  --pcest.custonfsemst,
	pcprodut.descricao,
	pcest.qtestger,
  pcest.custoultent,
  ROUND(pcest.qtestger *   pcest.custoultent,2) AS TOTAL
FROM
	pcest,
	pcprodut
WHERE
	pcest.codfilial = 1
	AND pcprodut.codprod = pcest.codprod

ORDER BY
	codprod ASC
