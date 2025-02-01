M�dulo 7

-- Etapas de desenvolvimento para entendimento da explica��o

-- 1� Etapa

select entidade
     , sum (valor) as valor_receber
	 , 0.00 as valor_pagar
 from titulos_receber
 group by entidade

union all
 
select entidade
     , 0.00 as valor_receber
	 , sum (valor) as valor_pagar
 from titulos_pagar 
 group by entidade

 order by entidade
 
 ------------------
 -- 2� Etapa
 -- A query entre par�nteses passou as ser uma fonte de dados �nica, como se fosse uma tabela.
 
 select *
  from ( -- tudo que est� dentro do parenteses � uma fonte de dados �nica
 
 select entidade
     , sum (valor) as valor_receber
	 , 0.00 as valor_pagar
 from titulos_receber
 group by entidade

union all
 
select entidade
     , 0.00 as valor_receber
	 , sum (valor) as valor_pagar
 from titulos_pagar 
 group by entidade

 ) a --- � preciso dar um nome para tabela

  order by entidade --- o order by precisa ficar fora da subquery

---------------
-- 3� Etapa - esse c�digo vai unificar em uma linha as informa��es de entidade, valor_receber e valor_pagar

select a.entidade  -- no select s� consegue colocar campos que j� est�o dentro da subquery, caso contr�rio dar� erro. Mesmo que na tabela t�tulos a receber tiver outras colunas, n�o pode ser inclu�da aqui.
	 , sum (valor_receber) as valor_receber
	 , sum (valor_pagar)   as valor_pagar
	 , sum (a.valor_receber) - sum (a.valor_pagar) as saldo
 from (
 
 select entidade
     , sum (valor) as valor_receber
	 , 0.00 as valor_pagar
 from titulos_receber
 group by entidade

union all
 
select entidade
     , 0.00 as valor_receber
	 , sum (valor) as valor_pagar
 from titulos_pagar 
 group by entidade

 ) a --- � preciso dar um nome para tabela

 group by entidade -- da mesma forma que � preciso colocar no group by as fun��es que n�o tem agrega��o, para a subquery � a mesma coisa
 order by entidade -- precisa ficar fora da subquery
  
---------
-- 4� Etapa - relacionar subqueries 

select a.entidade 
     , b.nome
	 , sum (valor_receber) as valor_receber
	 , sum (valor_pagar)   as valor_pagar
	 , sum (a.valor_receber) - sum (a.valor_pagar) as saldo
 from (
 
 select entidade
     , sum (valor) as valor_receber
	 , 0.00 as valor_pagar
 from titulos_receber
 group by entidade

union all
 
select entidade
     , 0.00 as valor_receber
	 , sum (valor) as valor_pagar
 from titulos_pagar 
 group by entidade

 ) a

 join entidades b on a.entidade = b.entidade
 group by a.entidade, b.nome 
 order by a.entidade 

---------

-- Aqui s�o duas consultas separadas, rodei as duas ao mesmo tempo

-- 1� Etapa

select entidade
     , sum (valor) as valor_receber
 from titulos_receber
 group by entidade
 

select entidade
	 , sum (valor) as valor_pagar
 from titulos_pagar 
 group by entidade

 order by entidade

-- 2� Etapa

select a.entidade
     , a.nome
	 , isnull (b.valor_receber, 0)                             as valor_receber
	 , isnull (c.valor_pagar  , 0)                             as valor_pagar
	 , isnull (b.valor_receber, 0) - isnull (c.valor_pagar, 0) as saldo
 from entidades a
 left join (
      select entidade
           , sum (valor) as valor_receber
        from titulos_receber
        group by entidade ) b on a.entidade = b.entidade

left join (
      select entidade
	      , sum (valor) as valor_pagar
       from titulos_pagar 
       group by entidade ) c on a.entidade = c.entidade
 
 where b.valor_receber is not null
    or c.valor_pagar   is not null

--------------
-- Subquery usando in e not in

-- Pegar todos os clientes que compraram somente no ano de 2019

select a.entidade
     , a.nome
	 , estado
 from entidades a
 join enderecos b on a.entidade = b.entidade

select cliente, year (movimento) -- aqui � uma forma de validar se vai retornar todos os clientes que compraram em 2019 ou n�o, aqui tamb�m tem clientes de 2020.
 from vendas_analiticas

select cliente --atrav�s do filtro retorna todos os clientes que compraram em 2019
 from vendas_analiticas
where year (movimento) = 2019
-------

-- Criando subselect dentro do select in 

select a.entidade
     , a.nome
	 , b.estado
from entidades a
join enderecos b on a.entidade = b.entidade
where a.entidade in( -- 1) "where a.entidade" e "select cliente" devem ter os mesmos dados, ou seja, ser equivalentes para o SQL reconhecer a correspond�ncias, caso contr�rio dar� erro. 2) Nesse subselect retorna todos os clientes, uma lista que n�o compraram em 2019. 3) Tudo que aprendemos no curso como relacionamentos, tratamento de informa��es, filtros, fun��es de agrega��o tamb�m s�o aplicadas nesse tipo de subselect.  
                     select cliente
                      from vendas_analiticas
                     where year (movimento) = 2019
)

select a.entidade
     , a.nome
	 , b.estado
from entidades a
join enderecos b on a.entidade = b.entidade
where a.entidade not in( -- 1) "where a.entidade" e "select cliente" devem ter os mesmos dados, ou seja, ser equivalentes para o SQL reconhecer a correspond�ncias, caso contr�rio dar� erro. 2) Nesse subselect retorna todos os clientes, uma lista que n�o compraram em 2019. 3) Tudo que aprendemos no curso como relacionamentos, tratamento de informa��es, filtros, fun��es de agrega��o tamb�m s�o aplicadas nesse tipo de subselect.
                     select cliente
                      from vendas_analiticas
                     where year (movimento) = 2019
)

----------
select cliente -- esse consulta tr�s a lista dos clientes que mais compraram
     , sum (venda_liquida) as venda_liquida
	from vendas_analiticas
group by cliente
order by venda_liquida desc

select a.entidade -- retorna o cliente que mais comprou, por�m o que mais comprou muda ao longo do tempo
    , a.nome
	, b.estado
from entidades a
join enderecos b on a.entidade = b.entidade
where a.entidade = (1876)

-- Agora essa consulta vai retornar a lista dos clientes que mais compraram 
select cliente
from vendas_analiticas
group by cliente
order by sum(venda_liquida) desc

-- N�o vamos trabalhar com a lista dos clientes e sim, com a informa��o do que mais comprou que � o 1876, que � a primeira linha de retorno

select top 1 cliente -- coloca top 1 que trar� o cliente que mais comprou
 from vendas_analiticas
 group by cliente
 order by sum(venda_liquida) desc

 -- Agora vamos juntar as consultas para trazer o cliente que mais comprou
 
select a.entidade 
     , a.nome
	 , b.estado
 from entidades a
join enderecos b on a.entidade = b.entidade
where a.entidade = ( -- pode se usar v�rios operadores aritm�ticos de compara��o, por�m com uma �nica condi��o que retorne apenas um resultado em uma �nica coluna.
           select top 1 cliente 
          from vendas_analiticas
          group by cliente
          order by sum(venda_liquida) desc -- n�o se usa order by em subselect, por�m aqui ele tem a fun��o de organizar a informa��o para o select trazer a primeira linha.
)

---

select a.entidade 
     , a.nome
	 , b.estado
 from entidades a
join enderecos b on a.entidade = b.entidade
where a.entidade <> ( -- essa consulta trar� o que � diferente do 1876 
           select top 1 cliente 
          from vendas_analiticas
          group by cliente
          order by sum(venda_liquida) desc 
)

-------

-- Para a cl�usula inner join tamb�m � poss�vel usar a "," para consultas simples apenas, alguns programadores usam e por isso estou aprendendo

-- 1�
select *
 from entidades a
 join enderecos  b on a.entidade = b.entidade

-- 2�
select *
 from entidades a
    , enderecos  b
where a.entidade = b.entidade

-- O 1� e 2� select s�o a mesma coisa, fazem a mesma consulta inner join.

-- Exists e Not Exists

-- A 1� e a 2� forma trazem o mesmo resultado por�m fora escritos de forma diferente

-- 1� Foma 

select a.entidade
     , a.nome
 from entidades a
 left join titulos_pagar b on a.entidade = b.entidade
where b.titulo_pagar is null

-----
-- 2� Forma

select a.entidade
     , a.nome
 from entidades a
 where a.entidade not in ( 
                       select distinct
					          entidade
					      from titulos_pagar
						  )
-----
-- 3� Forma 
-- Achei dif�cil essa aula, assistir novamente daqui um tempo.
-- Quando eu n�o quiser usar o left join ou not in posso usar o not exists.
-- Quando queremos relacionar qualquer outra fonte de dados, e que est� no nosso comando where com as fontes de dados da query principal, seja tabela ou subquery, n�o conseguimos usar relacionando usando o on, sendo preciso relacionar usando o where conforme query abaixo.

-- Essa query vai pegar todas as entidades que n�o tem t�tulo a pagar

select a.entidade
     , a.nome
	 , b.estado
 from entidades a 
 join enderecos b on a.entidade = b.entidade
 where not exists (
                     select *
					  from titulos_pagar x
					  where a.entidade = x.entidade
				   )


