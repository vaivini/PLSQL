select distinct i.numped,
                i.codst,
                i.data,
                i.rowid,
                i.data,
                i.codcli,
                c.estent,
                c.tipofj,
                i.posicao,
                i.aliqicms1,
                i.aliqicms2,
                i.codfiscal,
                i.codprod,
                i.sittribut
  from pcpedi i, pcclient c
 where i.codcli = c.codcli
   and i.posicao not in ('F', 'C')
   AND i.codprod = 17866
 order by i.data desc
 
 