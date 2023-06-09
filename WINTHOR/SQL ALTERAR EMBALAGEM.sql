select codcli, rowid, codprod, codauxiliar, data, posicao
  from pcpedi
 where codprod = 6412
   and pcpedi.data between '01-01-2021' and '21-01-2021'
   and posicao NOT IN ('F', 'C');
---------------- SELECIONA OS PEDIDOS COM C�DIGO DE BARRA
-------------------------------------------------------------------------------------
SELECT rowid, codauxiliar, codprod, embalagem, unidade, qtunit
  FROM PCEMBALAGEM
 WHERE CODPROD = 6412;
---------------------- SELECIONA AS EMBALAGENS DO PRODUTO
-------------------------------------------------------------------------------------
select ROWID, DESCRICAO, QTUNITCX, UNIDADEMASTER, DTCADASTRO, QTUNIT, UNIDADE
  from pcprodut
 where codprod = 20142;
------SELECIONA O PRODUTO E A EMBALAGEM MASTER DO PRODUTO 
-------------------------------------------------------------------------------------

select rowid, codprod, descricao, nbm from pcprodut where nbm = 39233000;
-------------------------------SELECIONA O NCM DO PRODUTO 
-------------------------------------------------------------------------------------
