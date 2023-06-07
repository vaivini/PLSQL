-- QUERY RENTABILDIADE               

SELECT       
     (2.83/100) * FATBRUTO  IMP_FEDERAL,
     (14.24/100) * FATBRUTO  AS IMP_ESTADUAL, 
      FATBRUTO  , 
      CMV, 
      DEVOL, 
      ((CMV)-VLDEVCMV) AS CMV_DEVOL,
      (((CMV)-VLDEVCMV)- ((2.83/100) * FATBRUTO)-((14.24/100) * FATBRUTO))  CUSTOS,
      FATBRUTO - (((CMV)-VLDEVCMV)- ((2.83/100) * FATBRUTO)-((14.24/100) * FATBRUTO)) AS RENTABILIDADE,
      ROUND(((FATBRUTO - (((CMV)-VLDEVCMV)- ((2.83/100) * FATBRUTO)-((14.24/100) * FATBRUTO))) / FATBRUTO * 100),2) || '%' AS PORCENTAGEM                                                                                                                                                                                                                     
          FROM(                                                
SELECT FATURAMENTO -DEVOLUCAO.VLDEVOLBONIFIC FATBRUTO  ,                                                                     
        (TOTAL.VLCUSTOFIN * (-1))  CMV,                                                                                                                                                                                     
        DEVOLUCAO.VLDEVOLBONIFIC DEVOL,
        DEVOLUCAO.VLDEVCMV VLDEVCMV FROM                                                      
(SELECT  
   SUM(VENDAS.VLVENDA )  FATURAMENTO,       
    SUM(VENDAS.VLCUSTOFINB)*(-1) VLCUSTOFIN ,                          
     SUM(VENDAS.COMISSAO) COMISSAO                                                   
        FROM VIEW_VENDAS_RESUMO_FATURAMENTO VENDAS           
          WHERE 1 = 1 
       AND NVL (VENDAS.CONDVENDA, -1) IN (-1, 1, 5, 7, 9, 11, 14)
  AND NVL(VENDAS.CODFISCAL,0) NOT IN (522, 622, 722, 532, 632, 732)
  AND VENDAS.DTCANCEL IS NULL 
  AND VENDAS.ESPECIE NOT IN ('NS', 'CO') 
  AND VENDAS.CODFILIAL IN ('1')  
  AND (VENDAS.DTSAIDA BETWEEN '01-09-2022' and '30-09-2022')) TOTAL -- FILTRO DE DATA
,
(SELECT  VLDEVOLBONIFIC, VLDEVCMV FROM (
  SELECT  SUM((DEVOL.VLCMVDEVOLBONIF + DEVOL.VLCMVDEVOL)) VLDEVCMV , 
    SUM(DEVOL.VLDEVOLUCAO)  VLDEVOLBONIFIC    
       FROM VIEW_DEVOL_RESUMO_FATURAMENTO DEVOL
          WHERE 1 = 1
  AND DEVOL.CODFILIAL IN ('1')  
  AND DEVOL.DTENT BETWEEN '01-09-2022' and '30-09-2022' -- FILTRO DE DATA
  AND DEVOL.CONDVENDA NOT IN (4, 8, 13, 20, 98, 99,10)
-------------------------------------------------------------------------------------------------------- 
 UNION ALL 
   SELECT  0 VLDEVOLBONIFIC,  0 VLDEVCMV
     FROM VIEW_DEVOL_RESUMO_FATURAVULSA AVULSA
        WHERE 1 = 1
  AND AVULSA.CODFILIAL IN ('1')  
  AND AVULSA.DTENT BETWEEN '01-09-2022' and '30-09-2022' -- FILTRO DE DATA
  )) DEVOLUCAO)
--------------------------------------------------------------------------------------------------------
