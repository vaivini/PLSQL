select em.codigoerp "Filial",
		to_char(m.data_geracao,'DD/MM/YYYY') "Dta geração",
		p.codigo,
		p.descricao,
		p.controla_lote,
		p.induz_lote,
	  	to_char(m.data_validade,'DD/MM/YYYY')"Dta validade",
		(select nome
		from usuario u
		where u.id = coalesce (m.id_usuario_geracao, m.codigo_conferente,0 ))"Gerado por:",
		m.tipo "Tipo",
		case
			when m.tipo in (97, 98) then 'Armazenagem'
			when m.tipo = 58 then 'Transferência'
			when m.tipo = 50 then 'Estorno expedição/armazenagem'
			when m.tipo = 61 then 'Abastecimento preventivo'
			when m.tipo = 62 then 'Abastecimento corretivo'
			when m.tipo = 99 then 'Ajuste manual'
			when m.tipo in (13, 14, 20, 16, 17, 18,22) then 'Expedição'
			else ' '
		end as "Tipo OM",
		m.tipo_operacao "Operação",
		m.numeroom "OM",
		m.tipo "Tipo OM",		
		m.numero_carga::varchar "Carga",
		m.numero_pedido::varchar "Pedido",
		m.conferencia_id "Conferência",
		m.etiqueta_ual_id "UAL",
		case when m.situacao in ('P','A') then 'Pendente' else 'Concluido' end as "Situação" ,
		m.qt,
		coalesce(m.lote,ml.lote)"Lote",
		e.tipo_endereco "Tipo End",
		e.deposito,
		e.rua,
		e.predio,
		e.nivel,
		e.apto,
		e.tipo_estoque,
		(select nome from usuario u where u.id = case when tipo in (58,99) then m.id_usuario_geracao else m.codigo_separador end)"Executado por:",
		orig.tipo_endereco "Tipo End",
		orig.deposito "Dep Orig",
		orig.rua "Rua Orig",
		orig.predio "Predio Orig",
		orig.nivel "Nivel Orig",
		orig.apto "Apto Orig"
from  movimentacao m
inner join produto p on m.produto_id = p.id
inner join endereco e on m.endereco_id = e.id
left join endereco orig on m.endereco_origem_id = orig.id
left JOIN movimentacao_lote ml on m.id = ml.movimentacao_id	
inner join empresa em on m.empresa_id = em.id
where m.estornado = 'N'
and   m.data_estorno is null
and   m.qt > 0
and   m.data_geracao::date >=to_timestamp(''||:periodo_inicial, 'DD/MM/YYYY')
and   m.data_geracao::date <=to_timestamp(''||:periodo_final, 'DD/MM/YYYY')
and   (p.codigo = :produto OR -1 = :produto)
and   (em.codigoerp in (:filial) or -1 = :filial)      	
order by m.data_geracao asc