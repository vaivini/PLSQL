 select codprod, descricao, embalagem, codfab, codepto, codsec, codsubcategoria, codcategoria 
  from pcprodut                                                   
 where not exists (select codprod                                 
                     from pcembalagem                             
                    where pcembalagem.codprod = pcprodut.codprod  
                   )
                   and pcprodut.codmarca = 96
