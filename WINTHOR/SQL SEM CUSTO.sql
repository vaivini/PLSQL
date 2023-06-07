select rowid,
       codprod,
       CUSTOCONT,
       CUSTOFIN,
       CUSTOCONTANT,
       CUSTOREALANT,
       CUSTOFINANT,
       PCMOV.CUSTOREALSEMST,
       PCMOV.CUSTOREALSEMSTANT,
       PCMOV.CUSTOFINEST
  from pcmov
 where numnota = 140537
   and codprod in (18178)