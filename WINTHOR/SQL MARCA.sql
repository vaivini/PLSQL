SELECT distinct pcprodut.CODMARCA, pcmarca.marca FROM pcprodut, PCDEPTO, pcmarca WHERE  PCPRODUT.CODEPTO  = PCDEPTO.CODEPTO
and pcprodut.codmarca = pcmarca.codmarca
AND pcprodut.codsec = 128 AND PCPRODUT.OBS2 <> 'FL'