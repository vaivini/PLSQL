SELECT 
       NVL(VENDAS.CODUSUR, DEVOLUCAO.CODUSURDEVOL) CODUSUR, 
       NVL(VENDAS.NOME, DEVOLUCAO.NOME) NOME,
       ((SELECT COUNT(  CODCLI) FROM PCCLIENT WHERE PCCLIENT.CODUSUR1 = VENDAS.CODUSUR   ) + (SELECT COUNT(DISTINCT CODCLI) FROM PCCLIENT WHERE PCCLIENT.CODUSUR2 = VENDAS.CODUSUR AND PCCLIENT.CODUSUR1 <> VENDAS.CODUSUR AND PCCLIENT.CODUSUR1 <> PCCLIENT.CODUSUR2 AND CODUSUR2 <> '1')) AS CARTEIRA,
       MAX ( DISTINCT(NVL(VENDAS.QTCLIPOS,0))) QTCLIPOS,
CASE WHEN
       ROUND((( MAX ( DISTINCT(NVL(VENDAS.QTCLIPOS,0))) / ((SELECT COUNT(CODCLI) FROM PCCLIENT WHERE PCCLIENT.CODUSUR1 = VENDAS.CODUSUR ) + (SELECT COUNT(CODCLI) FROM PCCLIENT WHERE PCCLIENT.CODUSUR2 = VENDAS.CODUSUR AND PCCLIENT.CODUSUR1 <> VENDAS.CODUSUR)) ) * 100),2)  >= 1
THEN
       ROUND((( MAX ( DISTINCT(NVL(VENDAS.QTCLIPOS,0))) / ((SELECT COUNT(CODCLI) FROM PCCLIENT WHERE PCCLIENT.CODUSUR1 = VENDAS.CODUSUR ) + (SELECT COUNT(CODCLI) FROM PCCLIENT WHERE PCCLIENT.CODUSUR2 = VENDAS.CODUSUR AND PCCLIENT.CODUSUR1 <> VENDAS.CODUSUR)) ) * 100),2) || '%'
ELSE '0%' END  AS PORCENTAGEM,                                                                                                                                                                                                                                                                 
       SUM(NVL(VENDAS.QTVENDA,0) - NVL(DEVOLUCAO.QTDEVOLUCAO,0)) QTVENDA,                                                                                                                                                                                                                                                             
       ROUND(SUM(NVL(VENDAS.VLVENDA,0) - NVL(DEVOLUCAO.VLDEVOLUCAO,0)),2) VLVENDA,
       SUM(NVL(DEVOLUCAO.QTDEVOLUCAO, 0)) QTDEVOLUCAO,
       ROUND(SUM(NVL(DEVOLUCAO.VLDEVOLUCAO,0)),2) VLDEVOLUCAO,
       SUM(NVL(VENDAS.TOTPESO,0) - NVL(DEVOLUCAO.TOTPESO,0) )  TOTPESO
FROM  
(SELECT  CODUSUR,
                    NOME,
                    SUM(NVL(QTVENDA,0)) QTVENDA,
                    SUM(NVL(VLVENDA,0) + NVL(VALORST,0) + NVL(VALORIPI,0)) VLVENDA,
                    SUM(NVL(TOTPESO,0)) TOTPESO,
                    COUNT(DISTINCT(QTCLIPOS)) QTCLIPOS
FROM
(SELECT-- PCNFSAID.NUMTRANSVENDA, 
                   PCNFSAID.CODUSUR  CODUSUR, 
                   PCUSUARI.NOME, 
                   ROUND((NVL(PCMOV.QT, 0) * DECODE(PCNFSAID.CONDVENDA,5,0,6,0,11,0,12,0,DECODE(PCMOV.CODOPER,'SB',0,nvl(pcmov.VLIPI,0)))),2) VALORIPI,
                   ROUND(NVL(PCMOV.QT, 0) *  DECODE(PCNFSAID.CONDVENDA,5,0,6,0,11,0,12,0,DECODE(PCMOV.CODOPER,'SB',0,(nvl(pcmov.ST,0)+NVL(PCMOVCOMPLE.VLSTTRANSFCD,0)))),2) VALORST,

                  (DECODE(PCMOV.CODOPER,'S',(NVL(DECODE(PCNFSAID.CONDVENDA,7,PCMOV.QTCONT,PCMOV.QT),0)),'SM', 
                   (NVL(DECODE(PCNFSAID.CONDVENDA,7,PCMOV.QTCONT,PCMOV.QT),0)),'ST', 
                   (NVL(DECODE(PCNFSAID.CONDVENDA,7,PCMOV.QTCONT,PCMOV.QT),0)),'SB',
                   (NVL(DECODE(PCNFSAID.CONDVENDA,7,PCMOV.QTCONT,PCMOV.QT),0)),0)) QTVENDA,
             -- INICIO VLVENDA       
             CASE WHEN NVL(PCMOVCOMPLE.VLSUBTOTITEM,0) <> 0 THEN  
                   DECODE(NVL(PCMOV.TIPOITEM,'N'),'I',0,NVL(PCMOVCOMPLE.VLSUBTOTITEM,0) + (DECODE(NVL(PCMOV.TIPOITEM,'N'),'I', 
                   NVL(PCMOV.QTCONT, 0), 0) * NVL(PCMOV.VLFRETE, 0))) - (ROUND((NVL(PCMOV.QT, 0)*DECODE(PCNFSAID.CONDVENDA,5,0,6,0,11,0,12,0,
                   DECODE(PCMOV.CODOPER,'SB',0,nvl(pcmov.VLIPI,0)))),2)) - (ROUND(NVL(PCMOV.QT, 0)*DECODE(PCNFSAID.CONDVENDA,5,0,6,0,11,0,12,0,DECODE(PCMOV.CODOPER,'SB',0,nvl(pcmov.ST,0))),2)) 
             ELSE                                                
                   ROUND((((DECODE(PCMOV.CODOPER,'S',(NVL(DECODE(PCNFSAID.CONDVENDA,7,PCMOV.QTCONT,PCMOV.QT),0)),'ST',                                                  
                   (NVL(DECODE(PCNFSAID.CONDVENDA,7,PCMOV.QTCONT,PCMOV.QT),0)),'SM',   
                   (NVL(DECODE(PCNFSAID.CONDVENDA,7,PCMOV.QTCONT,PCMOV.QT),0)),0)) * (NVL(DECODE(PCNFSAID.CONDVENDA,7,
                   (NVL(PUNITCONT, 0) - NVL(PCMOV.VLIPI, 0) - (NVL(PCMOV.ST,0)+NVL(PCMOVCOMPLE.VLSTTRANSFCD,0))) + NVL(PCMOV.VLFRETE,0) + 
                    NVL(PCMOV.VLOUTRASDESP, 0)+NVL(PCMOV.VLFRETE_RATEIO, 0)+DECODE(PCMOV.TIPOITEM,'C','I',NVL(PCMOV.VLOUTROS, 0),
                    DECODE(NVL(PCNFSAID.SOMAREPASSEOUTRASDESPNF,'N'),'N',NVL((PCMOV.VLOUTROS), 0),'S',NVL((NVL(PCMOV.VLOUTROS,0)-NVL(PCMOV.VLREPASSE,0)), 0))),
                   (NVL(PCMOV.PUNIT, 0) - NVL(PCMOV.VLIPI, 0) - (nvl(pcmov.ST,0)+NVL(PCMOVCOMPLE.VLSTTRANSFCD,0))) + NVL(PCMOV.VLFRETE,0) +          
                    NVL(PCMOV.VLOUTRASDESP, 0)+NVL(PCMOV.VLFRETE_RATEIO, 0)+DECODE(PCMOV.TIPOITEM,'C',                                        
            (SELECT NVL((SUM(M.QTCONT*NVL(M.VLOUTROS, 0)) / PCMOV.QT), 0) VLOUTROS                
                 FROM PCMOV M                               
                      WHERE M.NUMTRANSVENDA=PCMOV.NUMTRANSVENDA                   
                         AND M.TIPOITEM = 'I'                    
                         AND CODPRODPRINC = PCMOV.CODPROD),
                       'I',NVL(PCMOV.VLOUTROS, 0), DECODE(NVL(PCNFSAID.SOMAREPASSEOUTRASDESPNF,'N'),'N',
                      NVL((PCMOV.VLOUTROS), 0),'S',NVL((NVL(PCMOV.VLOUTROS,0)-NVL(PCMOV.VLREPASSE,0)), 0)))),0)))),2) END AS VLVENDA,   
             -- FIM VLVENDA 
                  ROUND( (NVL(PCPRODUT.PESOBRUTO,PCMOV.PESOBRUTO) * NVL(PCMOV.QT, 0)),2) AS TOTPESO,
                   PCMOV.CODCLI QTCLIPOS
FROM PCNFSAID,
             PCPRODUT,
             PCMOV,
             PCUSUARI,
             PCPEDC,
             PCMOVCOMPLE
WHERE PCMOV.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA
   AND PCMOV.CODFILIAL = PCNFSAID.CODFILIAL 
   AND PCMOV.CODPROD = PCPRODUT.CODPROD
   AND  PCNFSAID.CODUSUR   = PCUSUARI.CODUSUR 
   AND PCMOV.NUMTRANSITEM = PCMOVCOMPLE.NUMTRANSITEM(+)
   AND PCMOV.CODOPER <> 'SR' 
   AND NVL(PCNFSAID.TIPOVENDA,'X') NOT IN ('SR', 'DF')
   AND PCMOV.CODOPER <> 'SO' 
   AND PCNFSAID.NUMPED = PCPEDC.NUMPED(+)
   AND PCNFSAID.CODFISCAL NOT IN (522, 622, 722, 532, 632, 732)
   AND PCNFSAID.CONDVENDA NOT IN (4, 8, 10, 13, 20, 98, 99)
   AND (PCNFSAID.DTCANCEL IS NULL)
   AND PCMOV.DTMOV BETWEEN  TO_DATE('01/09/2022', 'DD/MM/YYYY') AND TO_DATE('30/09/2022', 'DD/MM/YYYY')   -- PARAMETRO DE DATA
   AND PCNFSAID.DTSAIDA BETWEEN  TO_DATE('01/09/2022', 'DD/MM/YYYY') AND TO_DATE('30/09/2022', 'DD/MM/YYYY')   -- PARAMETRO DE DATA
   AND PCMOV.CODFILIAL IN('1')
   AND PCNFSAID.CODFILIAL IN('1'))
GROUP BY CODUSUR,NOME) VENDAS, 
(SELECT CODUSURDEVOL, NOME,
     SUM(QTDEVOLUCAO) QTDEVOLUCAO,
     SUM(VLDEVOLUCAO) VLDEVOLUCAO,
     SUM(TOTPESO) TOTPESO,
     SUM(NVL(VLBONIFIC,0)) VLBONIFIC
FROM  (SELECT PCUSUARI.NOME,                               
      ROUND(DECODE(PCNFSAID.CONDVENDA,5,NVL(PCMOV.QT, 0),DECODE(NVL(PCMOVCOMPLE.BONIFIC, 'N'),'N',0,
      NVL(PCMOV.QT, 0),0)) * NVL(PCMOV.VLREPASSE, 0),2) VLREPASSEBNF,0 VLVENDA,0 QTBONIFIC,
     (NVL(PCMOV.QT,0)) QTDEVOLUCAO,
-- INICIO VLDEVOLU��O      
CASE WHEN NVL(PCMOVCOMPLE.VLSUBTOTITEM,0) <> 0 THEN  
     NVL(PCMOVCOMPLE.VLSUBTOTITEM,0) - (ROUND((NVL(PCMOV.QT, 0) *  DECODE(PCNFSAID.CONDVENDA,5,0,6,0,11,0,12,0,DECODE(PCMOV.CODOPER,'SB',0,
     nvl(pcmov.VLIPI,0)))),2)) - (ROUND(NVL(PCMOV.QT, 0) * DECODE(PCNFSAID.CONDVENDA,5,0,6,0,11,0,12,0,DECODE(PCMOV.CODOPER,'SB',0,nvl(pcmov.ST,0))),2)) 
ELSE                                                
   (DECODE(PCNFSAID.CONDVENDA, 5, 0, DECODE(NVL(PCMOVCOMPLE.BONIFIC, 'N'), 'N', 
   NVL(PCMOV.QT, 0), 0)) * DECODE(PCNFSAID.CONDVENDA,5,0,6,0,11,0, 
   (DECODE(PCMOV.PUNIT,0, PCMOV.PUNITCONT,NULL, PCMOV.PUNITCONT,PCMOV.PUNIT) + NVL(PCMOV.VLFRETE, 0) +                        
   NVL(PCMOV.VLOUTRASDESP, 0) + NVL(PCMOV.VLFRETE_RATEIO, 0) - (decode(NVL(PCNFSAID.SOMAREPASSEOUTRASDESPNF,'N'),'N',
  (DECODE(NVL(PCMOV.VLOUTROS,0),0,NVL(PCMOV.VLREPASSE,0),0)),'S',(NVL(PCMOV.VLREPASSE,0)))) + NVL(PCMOV.VLOUTROS, 0)))) END AS VLDEVOLUCAO, 
-- FIM VLDEVOLU��O                                                                                                                                                                                               
  (NVL(PCPRODUT.PESOBRUTO,PCMOV.PESOBRUTO) * NVL(PCMOV.QT, 0)) AS TOTPESO,      
  ROUND((NVL(PCMOV.QT, 0) * DECODE(PCNFSAID.CONDVENDA, 5,                                                              
  DECODE(PCMOV.PBONIFIC,NULL,PCMOV.PTABELA,PCMOV.PBONIFIC)  +                
  NVL(PCMOV.VLOUTRASDESP, 0) + NVL(PCMOV.VLFRETE_RATEIO, 0) + NVL(PCMOV.VLOUTROS, 0),6,                                                             
  DECODE(PCMOV.PBONIFIC,NULL,PCMOV.PTABELA,PCMOV.PBONIFIC),1,14,NVL(PCMOV.PBONIFIC,0),11,                                                             
  DECODE(PCMOV.PBONIFIC,NULL,PCMOV.PTABELA,PCMOV.PBONIFIC),12,                                                             
  DECODE(PCMOV.PBONIFIC,NULL,PCMOV.PTABELA,PCMOV.PBONIFIC),0)),2) VLBONIFIC,                                              
  PCNFENT.CODUSURDEVOL  CODUSUR, 
  PCNFENT.CODUSURDEVOL  CODUSURDEVOL
FROM PCNFENT,PCESTCOM, PCNFSAID, PCMOV, PCPRODUT, PCUSUARI, PCMOVCOMPLE
WHERE  PCNFENT.NUMTRANSENT = PCESTCOM.NUMTRANSENT
                 AND PCESTCOM.NUMTRANSENT = PCMOV.NUMTRANSENT
                 AND PCNFENT.CODUSURDEVOL = PCUSUARI.CODUSUR(+)
                 AND PCESTCOM.NUMTRANSVENDA = PCNFSAID.NUMTRANSVENDA(+)
                 AND PCMOV.NUMTRANSITEM = PCMOVCOMPLE.NUMTRANSITEM(+)
                 AND PCESTCOM.NUMTRANSVENDA <> 0
                 AND PCMOV.CODPROD = PCPRODUT.CODPROD
                 AND PCNFENT.TIPODESCARGA IN ('6', '7', 'T')
                 AND NVL(PCNFENT.CODFISCAL,0) IN (131, 132, 231, 232, 199, 299)
                 AND PCMOV.DTCANCEL IS NULL
                 AND PCMOV.CODOPER = 'ED' 
                 AND NVL(PCNFENT.TIPOMOVGARANTIA, -1) = -1
                 AND NVL(PCNFENT.OBS, 'X') <> 'NF CANCELADA'  
                 AND NVL(PCNFSAID.CONDVENDA, 0) NOT IN (4, 8, 10, 13, 20, 98, 99)
                 AND PCMOV.CODFILIAL IN('1')
                 AND PCNFENT.CODFILIAL IN('1')
                 AND PCNFENT.DTENT BETWEEN  TO_DATE('01/09/2022', 'DD/MM/YYYY') AND TO_DATE('30/09/2022', 'DD/MM/YYYY')  -- PARAMETRO DE DATA
                 AND PCMOV.DTMOV BETWEEN  TO_DATE('01/09/2022', 'DD/MM/YYYY') AND TO_DATE('30/09/2022', 'DD/MM/YYYY') )  -- PARAMETRO DE DATA
GROUP BY CODUSURDEVOL, NOME) DEVOLUCAO, PCUSUARI
WHERE PCUSUARI.CODUSUR = VENDAS.CODUSUR(+)
   AND PCUSUARI.CODUSUR = DEVOLUCAO.CODUSURDEVOL(+)
   AND ((NVL(VENDAS.QTVENDA,0) <> 0) or  (NVL(DEVOLUCAO.QTDEVOLUCAO,0) <> 0) or  (NVL(DEVOLUCAO.VLDEVOLUCAO,0) <> 0) OR 
   (NVL(VENDAS.TOTPESO,0) <> 0) OR (NVL(VENDAS.VLVENDA,0) <> 0) OR  (NVL(VENDAS.CODUSUR,0) <> 0)   OR (NVL(vendas.QTCLIPOS,0) <> 0)) 
GROUP BY VENDAS.CODUSUR,
                       VENDAS.NOME,
                       DEVOLUCAO.CODUSURDEVOL,
                       DEVOLUCAO.NOME
ORDER BY VLVENDA DESC 
