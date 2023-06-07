SELECT PCMOV.CODPROD,
       PCMOV.DTMOV,
       PCPRODUT.DESCRICAO,
       (DECODE(PCMOV.STATUS, 'A', NVL(PCMOV.QTCONT, 0), NVL(PCMOV.QT, 0))) QTENTRAD,
       PCMOV.NUMNOTA,
       NVL(PCMOV.PERCFRETE, 0) PERCFRETECIF,
       NVL(PCMOV.VLFRETE, 0) VLFRETECIF,
       NVL(PCMOV.PERCIPI, 0) PERCIPI,
       NVL(PCMOV.VLIPI, 0) VLIPI,
       NVL(PCMOV.PERCOUTRASDESP, 0) PERCOUTRASDESP,
       NVL(PCMOV.VLOUTRASDESP, 0) VLOUTRASDESP,
       NVL(PCMOV.PERCST, 0) PERCST,
       NVL(PCMOV.ST, 0) VLST,
       NVL(PCNFENT.VLTOTAL, 0) VLTOTAL,
       PCNFENT.CODFORNEC,
       PCFORNEC.FORNECEDOR,
       PCMOV.CODOPER,
       PCMOV.NUMPED,
       PCNFENT.CODFUNCLANC,
       PCEMPR.NOME           NOMEFUNCIONARIO,
       PCPRODUT.CODAUXILIAR,
       PCPRODUT.CODAUXILIAR2,
       PCPRODUT.CODFAB,
       PCPRODUT.EMBALAGEM,
       DECODE(NVL(PCMOV.PUNIT, 0), 0, NVL(PCMOV.PUNITCONT, 0), PCMOV.PUNIT) PUNIT,
       PCMOV.CUSTOFINANT,
       PCMOV.CUSTOFIN,
       ((DECODE(PCMOV.STATUS, 'A', NVL(PCMOV.QTCONT, 0), NVL(PCMOV.QT, 0))) *
       DECODE(NVL(PCMOV.PUNIT, 0), 0, NVL(PCMOV.PUNITCONT, 0), PCMOV.PUNIT)) VLENTRADB,
       ((DECODE(PCMOV.STATUS, 'A', NVL(PCMOV.QTCONT, 0), NVL(PCMOV.QT, 0))) *
       Nvl(PCMOV.CUSTOFIN, 0)) VLCUSTOFIN,
       ((DECODE(PCMOV.STATUS, 'A', NVL(PCMOV.QTCONT, 0), NVL(PCMOV.QT, 0))) *
       DECODE(NVL(PCMOV.PUNIT, 0), 0, NVL(PCMOV.PUNITCONT, 0), PCMOV.PUNIT)) VLENTRAD,
       (NVL(PCPRODUT.PESOBRUTO, 0) *
       (DECODE(PCMOV.STATUS, 'A', NVL(PCMOV.QTCONT, 0), NVL(PCMOV.QT, 0)))) TOTPESO,
       (NVL(PCPRODUT.VOLUME, 0) *
       (DECODE(PCMOV.STATUS, 'A', NVL(PCMOV.QTCONT, 0), NVL(PCMOV.QT, 0)))) TOTVOLUME

  FROM PCMOV,
       PCPRODUT,
       PCFORNEC,
       PCDEPTO,
       PCSECAO,
       PCNFENT,
       PCEMPR,
       PCCONSUM,
       PCPRODFILIAL,
       PCPEDIDO,
       PCFILIAL,
       PCBONUSC
 WHERE PCEMPR.MATRICULA(+) = PCNFENT.CODFUNCLANC
   AND (PCMOV.CODPROD = PCPRODUT.CODPROD)
   AND PCMOV.NUMTRANSENT = PCNFENT.NUMTRANSENT
   AND PCNFENT.CODFILIAL = PCFILIAL.CODIGO
   AND PCMOV.CODOPER NOT IN ('ED', 'EA')
   AND PCMOV.DTCANCEL IS NULL
   AND PCPRODUT.CODEPTO = PCDEPTO.CODEPTO
   AND PCPRODUT.CODSEC = PCSECAO.CODSEC(+)
   AND PCMOV.CODPROD = PCPRODFILIAL.CODPROD
   AND PCMOV.CODFILIAL = PCPRODFILIAL.CODFILIAL
   AND PCMOV.NUMPED = PCPEDIDO.NUMPED(+)
   AND (PCMOV.QT > 0 OR (PCMOV.QTCONT > 0 AND PCNFENT.TIPODESCARGA = '4'))
   AND PCNFENT.CODFORNEC = PCFORNEC.CODFORNEC
   AND PCNFENT.TIPODESCARGA NOT IN ('6', '7', '8', 'N', 'F')
   AND PCNFENT.NUMBONUS = PCBONUSC.NUMBONUS(+)
   AND ((PCNFENT.CODCONT = NVL(PCNFENT.CODCONTFOR, PCCONSUM.CODCONTFOR)) OR
        (PCNFENT.CODCONT = PCCONSUM.CODCONTAJUSTEEST AND
        PCNFENT.TIPODESCARGA = '4') OR
        (PCNFENT.TIPODESCARGA = 'S' AND
        ((PCNFENT.ESPECIE = 'NF') OR (PCNFENT.ESPECIE = 'NE'))))
   AND (PCMOV.DTMOV BETWEEN '11-08-2021' AND '12-08-2021') --data de entrada
   AND PCNFENT.CODFILIAL IN ('1')
   AND PCMOV.CODOPER LIKE 'E%'
 ORDER BY PCPRODUT.CODEPTO,
          PCFORNEC.FORNECEDOR,
          PCMOV.NUMNOTA,
          PCMOV.DTMOV,
          PCPRODUT.DESCRICAO
