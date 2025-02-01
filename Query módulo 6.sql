M�dulo 6

-- Union all: uni todos os resultados de duas ou mais consultas

-- Pontos principais:
-- 1) Todas as consultas devem ter o mesmo n�mero de colunas
-- 2) Todos os tipos de dados devem ser compat�veis, exemplo: coluna data compat�vel com outra coluna de data
-- 3) Os alias das colunas ficam no primeiro comando select ou primeira consulta
-- 4) Sempre o order by fica no �ltimo comando select
-- 5) Esse comando junta todos os resultados das tabelas inclusive os repetidos

select entidade as cod_cliente, nome, inscricao_federal
from pessoas_fisicas

union all

select entidade, nome, inscricao_federal
from pessoas_juridicas

-- Pode organizar dessa forma tamb�m caso perceba que � melhor

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
-- Pode incluir uma coluna de identifica��o para saber de qual consulta corresponde o dado


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
	  , data_cadastro     -- aqui foi incluida por �ltimo essa coluna, mesma que nas demais consultas n�o tenha a mesma, � importante colocar null para ter correspond�ncia e trazer os dados
from pessoas_fisicas

union all

select 'pj' 
      , entidade
      , nome
	  , inscricao_federal
	  , null -- inclu�do esse valor fixo para ter correspond�ncia e trazer os dados cadastrado da coluna, que ser� unida nessa consulta 
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

-- Union: uni o resultado distinto de duas consultas ou mais, tira os valores duplicados, � como se fizesse um select e depois um distinct. Essa � a �nica diferen�a, remove as linhas duplicadas. � a mesma fun��o do excel de remover dados duplicados.

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

-- Except: serve para buscar registros que aparecem na consulta A mas n�o aparecem na consulta B, se a informa��o existe na consulta A e B, ele vai remover as duas informa��es por completo, s� trar� o que � diferente nas consultas, ou seja, informa��es que n�o se repetem em ambas consultas.
-- Exemplo: existe a informa��o 1 na consulta A e 1 na consulta B, ele vai remover as duas informa��es.

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

-- Intersect: Pega as informa��es em comum entre duas consultas ou mais. Esse comando � como se fosse o Inner Join, por�m aqui ele se aplica as consultas e n�o de tabelas.

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

-- Os comandos abaixo s�o para validar se de fato a consulta anterior est� retornando apenas o que tem intercec��o, ou seja, informa��es em comum. 

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
