SELECT TRUNC(SYSDATE, 'YYYY') - 1 + ROWNUM AS "Data",
       TO_NUMBER(TO_CHAR(TRUNC(SYSDATE, 'YYYY') - 1 + ROWNUM, 'DD')) AS "Dia",
       TO_NUMBER(TO_CHAR(TRUNC(SYSDATE, 'YYYY') - 1 + ROWNUM, 'MM')) AS "Mês",
       TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) AS "Ano",
       TO_CHAR(TRUNC(SYSDATE, 'YYYY') - 1 + ROWNUM, 'day') AS "Descr.Dia",
       TO_CHAR(TRUNC(SYSDATE, 'YYYY') - 1 + ROWNUM, 'dy') AS "Descr.Dia abrev.",
       TO_CHAR(TRUNC(SYSDATE, 'YYYY') - 1 + ROWNUM, 'Month') AS "Descr.Mês",
       TO_CHAR(TRUNC(SYSDATE, 'YYYY') - 1 + ROWNUM, 'Mon') AS "Descr.Mês abrev",
       TO_CHAR(TRUNC(SYSDATE, 'YYYY') - 1 + ROWNUM, 'dd month yyyy') AS "Data texto"
  FROM all_tables
 WHERE ROWNUM <= (LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 11)) -
       TRUNC(SYSDATE, 'YYYY')) + 1;
