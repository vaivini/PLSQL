SELECT PCPRODUT.CODPROD,                                                                                                                                           
        PCPRODUT.DESCRICAO,                                                                                                                                         
                                                                                                                                         
        PCPRODUT.EMBALAGEM,                                                                                                                                         
        PCPRODUT.UNIDADE,                                                                                                                                           
        PCPRODUT.CODFAB,                                                                                                                                            
                                                                                                                                          
        PCPRODUT.CODAUXILIAR,                                                                                                                                       
        PCEST.QTESTGER,                                                                                                                                             
        PCEST.QTRESERV,                                                                                                                                             
        CASE WHEN ((NVL(PCPRODUT.OBS2,'N') <> 'FL')                                                                                                             
              AND  (NVL(PCPRODFILIAL.FORALINHA,'N') <> 'S'))                                                                                                    
             THEN 'N' ELSE 'S' END OBS2,                                                                                                                        
        PCPRODUT.CODEPTO,                                                                                                                                           
                                                                                                                                    
                                                                                 
        PCDEPTO.DESCRICAO DEPARTAMENTO,                                                                                                                             
        DECODE(NVL(PCPRODFILIAL.CODCOMPRADOR, PCFORNEC.CODCOMPRADOR), 0 ,PCFORNEC.CODCOMPRADOR, NVL(PCPRODFILIAL.CODCOMPRADOR,PCFORNEC.CODCOMPRADOR)) CODCOMPRADOR, 
        PCEMPR.NOME,                                                                                                                                                
        (PKG_ESTOQUE.ESTOQUE_DISPONIVEL(PCEST.CODPROD, PCEST.CODFILIAL, 'V')) QTDISP,                                                                           
        NVL(PCEST.QTVENDMES, 0) QTVENDMES,                                                                                                                          
        NVL(PCPRODUT.QTUNITCX, 0) QTUNITCX,                                                                                                                         
        NVL(PCEST.QTINDENIZ, 0) QTINDENIZ,                                                                                                                          
        NVL(PCEST.CUSTOREAL, 0) CUSTOREAL,                                                                                                                          
        NVL(PCEST.CUSTOFIN, 0) CUSTOFIN,                                                                                                                            
        NVL(PCEST.CUSTOREP, 0) CUSTOREP,                                                                                                                            
        NVL(PCEST.CUSTOCONT, 0) CUSTOCONT,                                                                                                                          
        NVL(PCEST.CUSTOULTENT, 0) CUSTOULTENT,                                                                                                                      
        NVL(PCEST.VALORULTENT, 0) VALORULTENT,                                                                                                                      
        NVL(PCEST.CUSTOREP, 0) CUSTOREP,                                                                                                                            
        NVL(PCEST.QTVENDMES1, 0) QTVENDMES1,                                                                                                                        
        NVL(PCEST.QTVENDMES2, 0) QTVENDMES2,                                                                                                                        
        NVL(PCEST.QTVENDMES3, 0) QTVENDMES3,                                                                                                                        
        NVL(PCEST.QTGIRODIA, 0) GIRODIA,                                                                                                                            
        PCPRODUT.CODFORNEC,                                                                                                                                         
        PCPRODUT.CODCATEGORIA,                                                                                                                                      
        PCPRODUT.CODSUBCATEGORIA,                                                                                                                                   
        NVL(PCPRODUT.CLASSE,'C') CLASSE,                                                                                                                          
                                                                                                                                       
        NVL(PCEST.QTPEDIDA, 0) QTPEDIDA,                                                                                                                            
        NVL(PCEST.QTBLOQUEADA, 0) - NVL(PCEST.QTINDENIZ, 0) QTBLOQUEADA,                                                                                            
        NVL(PCPRODUT.TIPOMERC, 'XX') TIPOMERC,                                                                                                                    
        PCPRODUT.CODPRODPRINC,                                                                                                                                      
        PCPRODUT.CODFAB,                                                                                                                                            
        PCPRODUT.CODAUXILIAR,                                                                                                                                       
        PCPRODUT.CODPRODMASTER,                                                                                                                                     
        CASE                                                                                                                                                        
        WHEN NVL(PCPRODUT.TIPOMERC, '') = 'FR' THEN                                                                                                             
        (PKG_ESTOQUE.ESTOQUE_DISPONIVEL(PCEST.CODPROD, PCEST.CODFILIAL, 'C') /                                                                                    
        GET_PRODUTO_PESO(PCPRODUT.CODPROD, PCEST.CODFILIAL))                                                                                                        
        ELSE                                                                                                                                                        
        (PKG_ESTOQUE.ESTOQUE_DISPONIVEL(PCEST.CODPROD, PCEST.CODFILIAL, 'C') /                                                                                    
        DECODE(NVL(PCPRODUT.QTUNITCX, 0), 0, 1, PCPRODUT.QTUNITCX))                                                                                                 
        END QTMASTER,                                                                                                                                               
        NVL(PCPRODUT.UNIDADEMASTER, 'KG') UNIDADEMASTER,                                                                                                          
        PCPRODUT.CLASSIFICFISCAL,                                                                                                                                   
        CASE WHEN ((NVL(PCPRODUT.OBS2, 'X') <> 'FL') AND (NVL(PCPRODFILIAL.FORALINHA, 'N') = 'N')) THEN 'N' ELSE 'S' END FORALINHA                      
     , PCMARCA.CODMARCA                                                                                                                                             
     , PCMARCA.MARCA                                                                                                                                                
     , NVL(PCEST.QTPENDENTE, 0) QTPENDENTE                                                                                                                          
     , NVL(PCPRODUT.CLASSEVENDA,'C') CLASSEVENDA                                                                                                                  
  FROM PCPRODUT                                                                                                                                                     
     , PCEST                                                                                                                                                        
     , PCFORNEC                                                                                                                                                     
     , PCCONSUM                                                                                                                                                     
     , PCEMPR                                                                                                                                                       
     , PCDEPTO                                                                                                                                                      
     , PCFILIAL                                                                                                                                                     
     , PCPRODFILIAL                                                                                                                                                 
     , PCMARCA                                                                                                                                                      
  WHERE PCEST.CODPROD = PCPRODUT.CODPROD(+)                                                                                                                         
  AND PCPRODUT.CODPROD = PCPRODFILIAL.CODPROD(+)                                                                                                                    
  AND PCPRODUT.CODMARCA = PCMARCA.CODMARCA(+)                                                                                                                       
  AND PCEST.CODFILIAL = PCPRODFILIAL.CODFILIAL                                                                                                                      
  AND PCPRODUT.CODFORNEC = PCFORNEC.CODFORNEC                                                                                                                       
  AND PCEST.CODFILIAL = PCFILIAL.CODIGO                                                                                                                             
  AND DECODE(NVL(PCPRODFILIAL.CODCOMPRADOR,PCFORNEC.CODCOMPRADOR),0,PCFORNEC.CODCOMPRADOR,NVL(PCPRODFILIAL.CODCOMPRADOR,PCFORNEC.CODCOMPRADOR)) = PCEMPR.MATRICULA  
  AND PCDEPTO.CODEPTO(+)   = PCPRODUT.CODEPTO                                                                                                                       
   AND ((PCPRODUT.CODFILIAL = PCEST.CODFILIAL ) OR (PCPRODUT.CODFILIAL = '99') OR (PCPRODUT.CODFILIAL IS NULL))
   AND PCEST.CODFILIAL IN('1')
   AND PCPRODUT.DTCADASTRO BETWEEN '20-12-2020' AND '31-12-2020' 
     AND ((PCPRODUT.OBS2 NOT IN ('FL')) OR (PCPRODUT.OBS2 IS NULL))
ORDER BY PCPRODUT.DESCRICAO
