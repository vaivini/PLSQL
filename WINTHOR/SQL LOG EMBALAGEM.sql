SELECT   (SELECT DESCRICAO FROM PCPRODUT WHERE CODPROD = PCLOGROTINA.CODPROD AND ROWNUM = 1) DESCRICAO, 
            datainicio, codrotina, codprod, margem, margemant, 
             qtunit, qtunitant, fatorpreco, fatorprecoant, 
             pervariacaoptabela, pervariacaoptabelaant, margemidealatac, 
             margemidealatacant, qtminimaatacado, qtminimaatacadoant, 
             qtmultipla, qtmultiplaant, aceitaprecoreplicado, 
             aceitaprecoreplicadoant, permitevendaatacado, 
                   (codfunc || ' ' || (SELECT pcempr.nome 
                                         FROM pcempr 
                                        WHERE matricula = pclogrotina.codfunc)) codfunc, 
             permitevendaatacadoant, codauxiliar, codfilial 
 FROM PCLOGROTINA 
WHERE CODROTINA = 292 
and codprod = 18387
AND CODFILIAL ='1'
AND TRUNC(DATAINICIO) BETWEEN '01-05-2021' AND '31-05-2021'
ORDER BY CODFILIAL, CODAUXILIAR 
