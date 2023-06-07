select 
 pcprodut.codprod,
   pcprodut.descricao,
 sum(pcpedi.qt),
       round(sum(pcpedi.pvenda * pcpedi.qt), 2),

     
      
       pcpedi.codcombo
  from pcpedi, pcpedc, pcusuari, pcprodut
 where pcpedc.numped = pcpedi.numped
   and pcpedc.codusur = pcusuari.codusur
   and pcpedi.codprod = pcprodut.codprod
    and pcpedi.codcombo is not null
    and pcpedc.dtcancel is null
  -- and pcpedi.codprod = 18186
   and pcpedi.codcombo = 232
  and pcpedi.data between '01-03-2022'  and '18-03-2022'
 group by pcprodut.codprod,  pcpedi.codcombo,    pcprodut.descricao  

 
