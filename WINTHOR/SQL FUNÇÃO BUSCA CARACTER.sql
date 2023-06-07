

SELECT CODCLI, cliente FROM pcclient WHERE REGEXP_COUNT (cliente, '[0-9]+') <> 0;
SELECT    CODCLI, cliente  
from pcclient
 where cliente LIKE '%1%' 
 or cliente LIKE '%2%' 
 or cliente LIKE '%3%' 
 or cliente LIKE '%4%' 
 or cliente LIKE '%5%' 
 or cliente LIKE '%6%'
 or cliente LIKE '%7%'
 or cliente LIKE '%8%'
 or cliente LIKE '%9%'
 or cliente LIKE '%0%'

