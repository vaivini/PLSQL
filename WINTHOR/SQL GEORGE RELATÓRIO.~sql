SELECT 
      DISTINCT N.NUMNOTA,
      N.SITUACAONFE,
      M.CODFISCAL,
      N.DTFAT,
      NVL(N.CODCLINF,N.CODCLI) CODCLI,
     -- N.CLIENTE,
      N.CGC,
      N.IEENT,            
      M.CODPROD,
      C.NITEMXML, 
      M.DESCRICAO,
      M.NBM,
      M.SITTRIBUT,
      M.QT,
      M.UNIDADE,
      round(round(M.qtcont * (nvl(M.punitcont,0) - nvl(M.st,0) - nvl(M.vlipi,0)),2) + round((nvl(M.qtcont,0) * nvl(M.st,0)),2) + round((nvl(M.qtcont,0) * nvl(M.vlipi,0)),2) +
      round((nvl(M.qtcont,0) * nvl(M.vloutros,0)),2) + decode(N.chavenfe, null, nvl(M.qtcont,0) * NVL(M.VLACRESCIMOPF, 0), 0) +  round((nvl(M.qtcont,0) * nvl(M.vlfrete,0)),2),2) VLITEM,
      NVL(C.VLSUBTOTDESCONTO, M.VLDESCONTO) AS VLDESCONTO,
      round(round(M.qtcont * (nvl(M.punitcont,0) - nvl(M.st,0) - nvl(M.vlipi,0)),2) + round((nvl(M.qtcont,0) * nvl(M.st,0)),2) + round((nvl(M.qtcont,0) * nvl(M.vlipi,0)),2) +
      round((nvl(M.qtcont,0) * nvl(M.vloutros,0)),2) + decode(N.chavenfe, null, nvl(M.qtcont,0) * NVL(M.VLACRESCIMOPF, 0), 0) +  round((nvl(M.qtcont,0) * nvl(M.vlfrete,0)),2),2)  -NVL(C.VLSUBTOTDESCONTO, M.VLDESCONTO) AS VLLIQUIDO,
     41.176 as BASE,
      round(round(M.qtcont * (nvl(M.punitcont,0) - nvl(M.st,0) - nvl(M.vlipi,0)),2) + round((nvl(M.qtcont,0) * nvl(M.st,0)),2) + round((nvl(M.qtcont,0) * nvl(M.vlipi,0)),2) +
      round((nvl(M.qtcont,0) * nvl(M.vloutros,0)),2) + decode(N.chavenfe, null, nvl(M.qtcont,0) * NVL(M.VLACRESCIMOPF, 0), 0) +  round((nvl(M.qtcont,0) * nvl(M.vlfrete,0)),2),2)  -   C.VLICMS*M.QT AS REDU ,
      ROUND(M.BASEICMS*M.QT ,2)BASEICMS,
      M.PERCICM,
      ROUND(C.VLICMS*QT,2) VLICMS,
      M.ST,
      M.BASEICST
      
     
 
FROM PCNFSAID N,
             PCMOV M,
             PCTRIBUT T,
             PCMOVCOMPLE C
WHERE  N.NUMTRANSVENDA = M.NUMTRANSVENDA
AND M.NUMTRANSITEM = C.NUMTRANSITEM
AND    N.NUMNOTA = M.NUMNOTA
AND    T.CODST = M.CODST
AND    M.DTMOV BETWEEN SYSDATE-30  AND SYSDATE
AND    NVL(N.CODFILIALNF, N.CODFILIAL) = '1'
AND    (M.TRIBFEDERAL IS NOT NULL OR 'N' = 'N')
AND    N.ESPECIE = 'NF'
AND    M.QTCONT > 0
AND    M.DTCANCEL IS NULL
and M.numnota = 179228
AND    M.STATUS IN ('A', 'AB')
--AND M.CODPROD = 18590
ORDER BY M.CODPROD
;

SELECT  M.VLDESCONTO,M.vl  M.PERCICM,  M.PERCBASERED,  M.PERCOFINS, M.VLCOFINS,  M.PERPIS, M.VLPIS, M.VLIPI, M.PERCIPI, M.* FROM PCMOV M WHERE M.numnota = 178409 AND CODPROD = 2144
