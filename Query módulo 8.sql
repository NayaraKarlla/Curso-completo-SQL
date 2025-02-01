M�dulo 8

--> tabela f�sica: select * from nome da tbl f�sica
--> tabelas tempor�rias: select * from #tbltemporaria
--> tabelas tempor�rias globais: select * from ##tbltemporaria

create table tbltemporaria -- esse comando � de uma tabela f�sica normal

(
   cod_cliente   int
  ,nome_cliente  varchar(80)
  ,tota_vendido  money
)

create table #tbltemporaria -- ao colocar o # antes do nome da tabela quer dizer que desejo criar uma tabela tempor�ria

(
   cod_cliente   int
  ,nome_cliente  varchar(80)
  ,total_vendido  money
)

select * 
  from #tbltemporaria

-- se colocar dois ## na frente do nome da tabela, ela se tornar uma tabela tempor�ria global

select b.entidade            as cod_cliente
     , b.nome                as nome_cliente
	 , sum (a.venda_liquida) as total_vendido -- as colunas que tem fun��o de agrega��o precisam ter nome, caso contr�rio o sql n�o reconhece
 into #tblclientevendas -- esse comando faz popular dados na tabela tempor�ria que criei, aqui ele analisa os tipos de dados de cada coluna e j� configura de acordo com o que est� definido nessa consulta, sendo assim, n�o � preciso preocupar com isso
 from vendas_analiticas a
 join entidades         b on a.cliente = b.entidade
 group by b.entidade
        , b.nome

select *  -- aqui podemos conferir que a tablela foi criada e que j� possui dados
  from #tblclientevendas

-- Desafio 1) recuperar o total a pagar e o valor pago por ano e m�s de cada entidade
-- Desafio 2) recuperar o total a receber e o valor recebido por ano e m�s de cada entidade
-- Desafio 3) recuperar todas as vendas por ano e m�s de cada entidade

-- 1�

select *
 from titulos_pagar       a 
 join titulos_pagar_saldo b on a.titulo_pagar = b.titulo_pagar

-- 2�

select a.entidade                    as cliente
     , year(a.movimento)             as ano
     , month(a.movimento)            as mes
	 , sum(a.valor)                  as total_pagar
	 , sum(b.saldo)                  as saldo_devedor
	 , sum(a.valor) - sum (b.saldo)  as total_pago
 from titulos_pagar       a 
 join titulos_pagar_saldo b on a.titulo_pagar = b.titulo_pagar
 group by year (a.movimento), month (a.movimento), a.entidade


-- Imagina que voc� est� em uma base de dados e por algum motivo o valor a pagar � 0, mas voc� n�o quer deixar a informa��o zerada porque est� errada, a query abaixo corrige esse problema

-- 3�

select a.entidade                    as cliente
     , year(a.movimento)             as ano
     , month(a.movimento)            as mes
	 , sum(a.valor)                  as total_pagar

     , case when sum (a.valor) = 0
	        then sum(b.saldo) 
			else sum(a.valor)
	   end                           as total_pagar_2

	 , sum(b.saldo)                  as saldo_devedor
	 , sum(a.valor) - sum (b.saldo)  as total_pago
 from titulos_pagar       a 
 join titulos_pagar_saldo b on a.titulo_pagar = b.titulo_pagar
 group by year (a.movimento), month (a.movimento), a.entidade

-- 4� 
 
select a.entidade                    as cliente
     , year(a.movimento)             as ano
     , month(a.movimento)            as mes

     , case when sum (a.valor) = 0
	        then sum(b.saldo) 
			else sum(a.valor)
	   end                           as total_pagar
	 , sum(b.saldo)                  as saldo_devedor

	 , case when sum (a.valor) = 0
	        then sum(b.saldo) 
			else sum(a.valor)
	   end - sum (b.saldo)           as total_pago
 from titulos_pagar       a 
 join titulos_pagar_saldo b on a.titulo_pagar = b.titulo_pagar
 group by year (a.movimento), month (a.movimento), a.entidade

-- 5� 
 --Desafio 1) total a pagar para o cliente

select a.entidade                   as cliente
     , year(a.movimento)            as ano
     , month(a.movimento)           as mes

     , case when sum (a.valor) < sum (b.saldo)
	        then sum(b.saldo) 
			else sum(a.valor)
	   end                           as total_pagar

	 , sum(b.saldo)                  as saldo_devedor

	 , case when sum (a.valor) < sum (b.saldo)
	        then sum(b.saldo) 
			else sum(a.valor)
	   end - sum (b.saldo)  as total_pago
 into #total_pagar_cliente -- essa linha foi colocada por �ltimo, essa query roda a consulta e cria uma tabela tempor�ria populando com essas informa��es
 from titulos_pagar       a 
 join titulos_pagar_saldo b on a.titulo_pagar = b.titulo_pagar
 group by year (a.movimento), month (a.movimento), a.entidade

 -- Desafio 2) total recebido do cliente
-- 1� bloco

select a.entidade                    as cliente
     , year(a.movimento)             as ano
     , month(a.movimento)            as mes
	 , sum(a.valor)
	 , sum(b.saldo)                  as saldo_devedor
     , sum(a.valor) - sum(b.saldo)   as total_pago
 from titulos_receber       a 
 join titulos_receber_saldo b on a.titulo_receber = b.titulo_receber
 group by year (a.movimento), month (a.movimento), a.entidade 

-- 2� bloco

select a.entidade                    as cliente
     , year(a.movimento)             as ano
     , month(a.movimento)            as mes
	 , sum(a.valor)                  as tota_receber
	 , sum(b.saldo)                  as saldo_receber
     , sum(a.valor) - sum(b.saldo)   as total_recebido
 into #total_receber_cliente -- -- essa linha foi colocada por �ltimo, essa query roda a consulta e cria uma tabela tempor�ria populando com essas informa��es
 from titulos_receber       a 
 join titulos_receber_saldo b on a.titulo_receber = b.titulo_receber
 group by year (a.movimento), month (a.movimento), a.entidade

 -- Desafio 3) total vendido por cliente

select *
 from vendas_analiticas

select a.cliente              as cliente
     , year(a.movimento)      as ano
     , month(a.movimento)     as mes
     , sum(a.venda_liquida)   as total_vendido
 into #total_vendido_cliente -- essa linha foi colocada por �ltimo, essa query roda a consulta e cria uma tabela tempor�ria populando com essas informa��es
 from vendas_analiticas a
 group by a.cliente, year(a.movimento), month(a.movimento)
 
 -- Resultado final da query para n�o acontecer o plano cartesiano
-- 1�

select * bloco -- nessa query estou pedindo para relacionar com a tabela #total_receber_cliente devendo coincidir o mesmo cliente, ano e m�s  
   from #total_vendido_cliente a
   join #total_receber_cliente b on a.cliente = b.cliente
                                 and a.ano    = b.ano
								 and a.mes    = b.mes
-- 2�
select a.*
     , b.total_receber
	 , b.total_recebido
	 , c.total_pagar
	 , c.saldo_devedor
   from #total_vendido_cliente a
   join #total_receber_cliente b on a.cliente = b.cliente
                                 and a.ano    = b.ano
								 and a.mes    = b.mes

left join #total_pagar_cliente c on a.cliente = c.cliente
                                and a.ano     = c.ano
								and a.mes     = c.mes

-- 3�

select a.cliente
     , d.nome
	 , a.ano
	 , a.mes
     , b.total_receber
	 , b.total_recebido
	 , isnull (c.total_pagar, 0) as total_pagar
	 , isnull (c.saldo_devedor, 0) as saldo_devedor
   from #total_vendido_cliente a
   join #total_receber_cliente b on a.cliente = b.cliente
                                 and a.ano    = b.ano
								 and a.mes    = b.mes

left join #total_pagar_cliente c on a.cliente = c.cliente
                                and a.ano     = c.ano
								and a.mes     = c.mes
join entidades                d on a.cliente  = d.entidade

where a.ano = 2020
  and a.mes = 9

-- Recupere o total de vendas e total no estoque de cada produto
--> vendas est� na tabela vendas anal�ticas
--> estoque est� na tabela de estoque_lan�amentos
--> descri��o do produto est� na tabela de produtos
--> crie uma coluna virtural onde divida o estoque em 3 categorias
  -- abaixo de 50 unidades
  -- entre 50 e 1000 unidades
  -- acima de 1000 unidades
--> a consulta dever� retornar os seguintes campos
  -- produto
  -- descri�ao
  -- unidades vendidas
  -- unidades em estoque
  -- situacao do estoque (coluna virtual solicitada)
--> realize a consulta utilizando a subquery e depois realize a mesma consulta utilizando tabelas tempor�rias

-- 1� total do estoque

select produto
     , sum (estoque_entrada) as total_entradas
	 , sum (estoque_saida)   as total_saidas
from estoque_lancamentos
group by produto

-- 2� 

select produto
	 , sum (estoque_entrada) - sum (estoque_saida) as saldo_estoque
from estoque_lancamentos
group by produto

-- total vendido

select produto
     , sum (quantidade) as quantidade_vendida
 from vendas_analiticas
 group by produto

 -- consulta utilizando subquery
 -- 1�

select a.produto			as cod_produto
     , a.descricao			as descricao_produto
	 , b.quantidade_vendida as unidades_vendidas
	 , c.saldo_estoque		as unidades_estoque
 from produtos a
 left join (select produto
				, sum (quantidade) as quantidade_vendida
			 from vendas_analiticas
			 group by produto ) b  on a.produto = b.produto
left join (select produto
				 , sum (estoque_entrada) - sum (estoque_saida) as saldo_estoque
			from estoque_lancamentos
			group by produto) c on a.produto = c.produto

-- 2� 

select a.produto			as cod_produto
     , a.descricao			as descricao_produto
	 , b.quantidade_vendida as unidades_vendidas
	 , c.saldo_estoque		as unidades_estoque
	 , case when c.saldo_estoque < 50
	        then 'abaixo de 50 unidades'
			when c.saldo_estoque between 50 and 1000 -- tamb�m pode ser escrito da seguinte forma -- when c.saldo_estoque >= 50 and c.saldo_estoque <=1000
			then 'entre 50 e 1000'
		    when c.saldo_estoque > 1000
			then 'acima de 1000 unidades'
		end 
 from produtos a
 left join (select produto
				, sum (quantidade) as quantidade_vendida
			 from vendas_analiticas
			 group by produto ) b  on a.produto = b.produto
left join (select produto
				 , sum (estoque_entrada) - sum (estoque_saida) as saldo_estoque
			from estoque_lancamentos
			group by produto) c on a.produto = c.produto

-- Query ajustada para tratar os nulos

select a.produto							as cod_produto
     , a.descricao							as descricao_produto
	 , isnull (b.quantidade_vendida, 0)		as unidades_vendidas

	 , isnull (c.saldo_estoque, 0)			as unidades_estoque

	 , case when isnull (c.saldo_estoque, 0) < 50
	        then 'abaixo de 50 unidades'
			when isnull (c.saldo_estoque, 0) between 50 and 1000 -- tamb�m pode ser escrito da seguinte forma -- when c.saldo_estoque >= 50 and c.saldo_estoque <=1000
			then 'entre 50 e 1000 unidades'
		    when isnull (c.saldo_estoque, 0) > 1000
			then 'acima de 1000 unidades'
		end                        as situacao_estoque
 from produtos a
 left join (select produto
				, sum (quantidade) as quantidade_vendida
			 from vendas_analiticas
			 group by produto ) b  on a.produto = b.produto
left join (select produto
				 , sum (estoque_entrada) - sum (estoque_saida) as saldo_estoque
			from estoque_lancamentos
			group by produto) c on a.produto = c.produto

-- Query ajustada para trazer como retorno 'sem entrada na empresa' quando a informa��o da entrada for nula, foi acrescentado o else

select a.produto							as cod_produto
     , a.descricao							as descricao_produto
	 , isnull (b.quantidade_vendida, 0)		as unidades_vendidas

	 , c.saldo_estoque

	 , case when c.saldo_estoque < 50
	        then 'abaixo de 50 unidades'
			when c.saldo_estoque between 50 and 1000 -- tamb�m pode ser escrito da seguinte forma -- when c.saldo_estoque >= 50 and c.saldo_estoque <=1000
			then 'entre 50 e 1000 unidades'
		    when c.saldo_estoque > 1000
			then 'acima de 1000 unidades'
			else 'sem entrada na empresa' -- tamb�m pode ser escrita assim: 'when c.saldo_estoque is null'then 'sem entrada na empresa'
		end                        as situacao_estoque
 from produtos a
 left join (select produto
				, sum (quantidade) as quantidade_vendida
			 from vendas_analiticas
			 group by produto ) b  on a.produto = b.produto
left join (select produto
				 , sum (estoque_entrada) - sum (estoque_saida) as saldo_estoque
			from estoque_lancamentos
			group by produto) c on a.produto = c.produto

-- Tabelas tempor�rias

-- Total do estoque

select produto
	 , sum (estoque_entrada) - sum (estoque_saida) as saldo_estoque
into #produtos_estoque -- quando roda essa query de cria��o da tabela pela segunda vez, o SQL mostra um erro falando que ela j� existe, a solu��o � apagar a tabela para criar novamente ou deixar de usar mesmo
from estoque_lancamentos
group by produto

-- Total vendido

select produto
     , sum (quantidade) as quantidade_vendida
into #produtos_vendidos
 from vendas_analiticas
 group by produto

-- Consulta dados tabela tempor�ria

select *
  from produtos           a
  join #produtos_vendidos b on a.produto = b.produto -- sempre que estiver usando tabelas tempor�rias � necess�rio colocar o # para que o SQL localize os dados

select a.produto            as cod_produto
     , a.descricao          as descricao_produto
	 , b.quantidade_vendida as unidades_vendidas 
	 , c.saldo_estoque      as unidades_estoque

	  , case when c.saldo_estoque < 50
	        then 'abaixo de 50 unidades'
			when c.saldo_estoque between 50 and 1000 -- tamb�m pode ser escrito da seguinte forma -- when c.saldo_estoque >= 50 and c.saldo_estoque <=1000
			then 'entre 50 e 1000 unidades'
		    when c.saldo_estoque > 1000
			then 'acima de 1000 unidades'
			else 'sem entrada na empresa' -- tamb�m pode ser escrita assim: 'when c.saldo_estoque is null'then 'sem entrada na empresa'
		end                        as situacao_estoque
 from produtos                a
 left join #produtos_vendidos b on a.produto = b.produto
 left join #produtos_estoque  c on a.produto = c.produto

 -- O �talo gosta de usar tabelas tempor�rias para fazer esse tipo de consulta, quando a query � menor ele usa as subquerys

 -- Para apagar tabelas tempor�rias, todos os dados da tabela, use o comando abaixo e jamais use o drop table em uma tabela f�sica, certifique-se que est� usando a tabela tempor�ria antes de dar o comando drop table

 drop table #produtos_estoque
 drop table #produtos_vendidos


-- Para cria��o de tabela tem duas formas, atrav�s do comando create table e into #nome da tabela
-- Quando estamos criando uma tabela no banco de dados, ao colocar o drop no final da query d� um erro dizendo que j� existe a tabela tempor�ria, e para resolver esse problema foi criado outra solu��o

create table #temp_01 (id int, nome varchar (80)) -- 1

insert into #temp_01 (id, nome) -- 2

select entidade, nome_fantasia -- 3 -- quando rodo o comando 2 e 3 juntos, o SQL popula a tabela #temp_01 com os dados do comando 3, quando rodamos os comandos 1,2 e 3 juntos o SQL cria a tabela e popula os dados nos campos correspondentes
  from entidades

select *
   from #temp_01

drop table #temp_01

--------
select object_id ('entidades')        -- fun��o object_id () retorna o c�digo de qualquer tabela dentro do banco de dados
select object_id ('curso_sql')        -- � uma tabela que n�o existe, ou seja, ir� retorna null
select object_id ('tempdb..#temp_01') -- o que est� dizendo aqui () �: quero consultar essa tabela #temp_01 no banco tempdb e n�o mais no banco que est� informando em cima que � o PBS_PROCFIT_DADOS

-- essa � a outra solu��o

if object_id ('tempdb..#temp_01') is not null drop table #temp_01 -- o comando est� dizendo que se existir objeto dentro do 'tempdb..#temp_01', ou seja, n�o retornar nulo, vai apagar a #temp_01 e os seguintes comandos s�o executados na sequ�ncia

create table #temp_01 (id int, nome varchar (80))

insert into #temp_01 (id, nome) 

select entidade, nome_fantasia
  from entidades

select *
   from #temp_01

----------------------
-- Nas CTE's os dados n�o ficam armazenados, pois s�o usados em tempo de execu��o e tem uma ordem, estrutura para serem criadas: 1� cria a cte's e 2� utiliza a cte's, o select, ou seja, um �nico comando
-- Pode haver v�rias ctes separadas por v�rgula, o importante � serem criadas em sequ�ncia e depois consulta a ctes e nesse caso s� pode ter um comando de instru��o select.
-- As ctes sempre come�am a ser criadas com "with"

with cte_produtos_estoque as (

select produto
	 , sum (estoque_entrada) - sum (estoque_saida) as saldo_estoque
from estoque_lancamentos
group by produto

), cte_produtos_vendidos as (

select produto
	 , sum (quantidade) as quantidade_vendida
from vendas_analiticas
group by produto

) 

select a.produto            as cod_produto
     , a.descricao          as descricao_produto
	 , b.quantidade_vendida as unidades_vendidas 
	 , c.saldo_estoque      as unidades_estoque

	  , case when c.saldo_estoque < 50
	        then 'abaixo de 50 unidades'
			when c.saldo_estoque between 50 and 1000 
			then 'entre 50 e 1000 unidades'
		    when c.saldo_estoque > 1000
			then 'acima de 1000 unidades'
			else 'sem entrada na empresa' 
		end                        as situacao_estoque
 from produtos                   a
 left join cte_produtos_vendidos b on a.produto = b.produto
 left join cte_produtos_estoque  c on a.produto = c.produto

 -- Conclus�o: as tabelas tempor�rias rodam mais r�pido, s�o mais perform�ticas, pode ser criado �ndices para elas. Existem limita��es para tabelas tempor�rias, se quer usar em uma view n�o conseguir�, elas n�o s�o permitidas em views e fun��es, isso � um ponto muito negativo. 
 -- J� as CTEs e as subqueries tamb�m podem ser usadas em views, em qualquer objeto dentro do seu banco de dados.
