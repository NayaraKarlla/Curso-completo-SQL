Módulo 6

-- Union all: uni todos os resultados de duas ou mais consultas

-- Pontos principais:
-- 1) Todas as consultas devem ter o mesmo número de colunas
-- 2) Todos os tipos de dados devem ser compatíveis, exemplo: coluna data compatível com outra coluna de data
-- 3) Os alias das colunas ficam no primeiro comando select ou primeira consulta
-- 4) Sempre o order by fica no último comando select
-- 5) Esse comando junta todos os resultados das tabelas inclusive os repetidos

select entidade as cod_cliente, nome, inscricao_federal
from pessoas_fisicas

union all

select entidade, nome, inscricao_federal
from pessoas_juridicas

-- Pode organizar dessa forma também caso perceba que é melhor

select entidade          as cod_cliente
     , nome              as nome_cliente
	 , inscricao_federal as inscricao_federal
from pessoas_fisicas

union all

select entidade
     , nome
	 , inscricao_federal
from pessoas_juridicas

--------------
-- Pode incluir uma coluna de identificação para saber de qual consulta corresponde o dado


select 'pf'               as tipo_cliente
      , entidade          as cod_cliente
      , nome              as nome_cliente
	  , inscricao_federal as inscricao_federal
from pessoas_fisicas

union all

select 'pj' 
      , entidade
      , nome
	  , inscricao_federal
from pessoas_juridicas

---------------------

select 'pf'               as tipo_cliente
      , entidade          as cod_cliente
      , nome              as nome_cliente
	  , inscricao_federal as inscricao_federal
	  , data_cadastro     -- aqui foi incluida por último essa coluna, mesma que nas demais consultas não tenha a mesma, é importante colocar null para ter correspondência e trazer os dados
from pessoas_fisicas

union all

select 'pj' 
      , entidade
      , nome
	  , inscricao_federal
	  , null -- incluído esse valor fixo para ter correspondência e trazer os dados cadastrado da coluna, que será unida nessa consulta 
from pessoas_juridicas

-------------------------

select b.entidade
     , b.nome
	 , b.inscricao_federal
	 , sum (a.valor) as valor_receber
	 , 0.00 as valor_pagar
 from titulos_receber a
 join entidades       b on a.entidade = b.entidade
 group by b.entidade, b.nome, b.inscricao_federal

union all
 
select b.entidade
     , b.nome
	 , b.inscricao_federal
	 , 0.00 as valor_receber
	 , sum (a.valor) as valor_pagar
 from titulos_pagar   a
 join entidades       b on a.entidade = b.entidade
 group by b.entidade, b.nome, b.inscricao_federal

order by entidade

-----------------

-- Union: uni o resultado distinto de duas consultas ou mais, tira os valores duplicados, é como se fizesse um select e depois um distinct. Essa é a única diferença, remove as linhas duplicadas. É a mesma função do excel de remover dados duplicados.

select entidade           as cod_cliente
      , nome              as nome_cliente
	  , inscricao_federal as inscricao_federal
	  , data_cadastro     
from pessoas_fisicas

union

select entidade
      , nome
	  , inscricao_federal
	  , null  
from pessoas_juridicas

--------------------

-- Except: serve para buscar registros que aparecem na consulta A mas não aparecem na consulta B, se a informação existe na consulta A e B, ele vai remover as duas informações por completo, só trará o que é diferente nas consultas, ou seja, informações que não se repetem em ambas consultas.
-- Exemplo: existe a informação 1 na consulta A e 1 na consulta B, ele vai remover as duas informações.

select b.entidade
     , b.nome 
	 , b.inscricao_federal
from titulos_pagar a
join entidades     b on a.entidade = b.entidade
group by b.entidade, b.nome, b.inscricao_federal

except

select b.entidade
     , b.nome 
	 , b.inscricao_federal
from titulos_receber a
join entidades       b on a.entidade = b.entidade
group by b.entidade, b.nome, b.inscricao_federal

order by entidade
------------------

-- Intersect: Pega as informações em comum entre duas consultas ou mais. Esse comando é como se fosse o Inner Join, porém aqui ele se aplica as consultas e não de tabelas.

select b.entidade
     , b.nome 
	 , b.inscricao_federal
from titulos_pagar a
join entidades     b on a.entidade = b.entidade
group by b.entidade, b.nome, b.inscricao_federal

intersect

select b.entidade
     , b.nome 
	 , b.inscricao_federal
from titulos_receber a
join entidades       b on a.entidade = b.entidade
group by b.entidade, b.nome, b.inscricao_federal

order by entidade

-- Os comandos abaixo são para validar se de fato a consulta anterior está retornando apenas o que tem intercecção, ou seja, informações em comum. 

select distinct entidade
from titulos_pagar
where entidade in(
1
,1002
,1014
,1018
,1049
,1059
,1084
,1096
,1113
,1115
)

select distinct entidade
from titulos_receber
where entidade in(
1
,1002
,1014
,1018
,1049
,1059
,1084
,1096
,1113
,1115
)
