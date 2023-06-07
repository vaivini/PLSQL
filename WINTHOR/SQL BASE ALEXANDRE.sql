select c.codcli CODIGO, c.cliente , c.enderent ENDEREÇO,    REPLACE(REPLACE( c.cepent, '.'),'-') cep , pr.praca MUNICIPIO,
c.bairroent BAIRRO,  p.numitens, p.obs,  p.numped, p.dtlibera DATA_LIBERAÇÃO, p.totpeso, p.totvolume
 from pcclient c, pcpedc p ,pcpraca pr
  where c.codcli = p.codcli
  and c.codpraca = p.codpraca
  and c.codpraca  = pr.codpraca
  and p.codpraca = pr.codpraca
   and p.numcar in  ( 10995 );
