select MATRICULA, NOME, USUARIOBD,
 DECODE(SITUACAO,'I','INATIVO','ATIVO') SITUACAO
  from PCEMPR
WHERE MATRICULA IS NOT NULL
AND NVL(SITUACAO,'A')='A'
 AND NOME LIKE Null || '%' ORDER BY NOME 
