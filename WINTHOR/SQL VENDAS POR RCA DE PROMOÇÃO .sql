 select sum(pcpedi.qt), round(sum(pcpedi.pvenda*pcpedi.qt),2), pcpedc.codusur, pcusuari.nome--, pcpedi.codcombo
 from pcpedi , pcpedc, pcusuari
 where pcpedc.numped = pcpedi.numped
 and pcpedc.codusur = pcusuari.codusur
and pcpedi.codcombo = 231
  and pcpedi.data between  '01-01-2022' and '31-03-2022'
group by pcpedc.codusur, pcusuari.nome--, pcpedi.codcombo
