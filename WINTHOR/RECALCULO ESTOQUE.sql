DECLARE                                          
  vREC_QTDE PKG_ANALISAR_ESTOQUE.TP_ENTRADA;     
                                                 
BEGIN   
  FOR DADOS IN (SELECT DISTINCT PCHISTEST.CODFILIAL, PCHISTEST.CODPROD, PCHISTEST.DATA
                FROM PCHISTEST
                WHERE PCHISTEST.CODFILIAL = '1'
                AND PCHISTEST.DATA = '10-JUL-2019'
                AND PCHISTEST.CODPROD in (11303)
                ) LOOP
                
       
                                         
  vREC_QTDE.CODPROD         := DADOS.Codprod;       
  vREC_QTDE.CODFILIAL       := DADOS.CODFILIAL;     
  vREC_QTDE.DTINICIAL       := DADOS.DATA; 
 -- vREC_QTDE.DTFINAL         := '14-JUL-2019';   -- USADO SOMENTE PARA A PROCEDURE PRC_CORRIGIR_PCHISTEST      
  vREC_QTDE.TIPOCHAMADA     := '';   
  vREC_QTDE.GERAR_LOG       := 'N';            
  vREC_QTDE.USA_FUNCAO_1070 := 'S';            
                                                 
  -- recalcula somente a pchistest
-- PKG_ANALISAR_ESTOQUE.PRC_CORRIGIR_PCHISTEST(vREC_QTDE);
 COMMIT;
  
  -- recalcula a pchistest e pcest
PKG_ANALISAR_ESTOQUE.PRC_RECALCULO(vREC_QTDE);
 
  
  END LOOP;
END; 