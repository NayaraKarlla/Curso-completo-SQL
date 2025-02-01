Módulo 7

-- Etapas de desenvolvimento para entendimento da explicação

-- 1° Etapa

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
 -- 2° Etapa
 -- A query entre parênteses passou as ser uma fonte de dados única, como se fosse uma tabela.
 
 select *
  from ( -- tudo que está dentro do parenteses é uma fonte de dados única
 
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

 ) a --- é preciso dar um nome para tabela

  order by entidade --- o order by precisa ficar fora da subquery

---------------
-- 3° Etapa - esse código vai unificar em uma linha as informações de entidade, valor_receber e valor_pagar

select a.entidade  -- no select só consegue colocar campos que já estão dentro da subquery, caso contrário dará erro. Mesmo que na tabela títulos a receber tiver outras colunas, não pode ser incluída aqui.
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

 ) a --- é preciso dar um nome para tabela

 group by entidade -- da mesma forma que é preciso colocar no group by as funções que não tem agregação, para a subquery é a mesma coisa
 order by entidade -- precisa ficar fora da subquery
  
---------
-- 4° Etapa - relacionar subqueries 

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

-- Aqui são duas consultas separadas, rodei as duas ao mesmo tempo

-- 1° Etapa

select entidade
     , sum (valor) as valor_receber
 from titulos_receber
 group by entidade
 

select entidade
	 , sum (valor) as valor_pagar
 from titulos_pagar 
 group by entidade

 order by entidade

-- 2° Etapa

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

select cliente, year (movimento) -- aqui é uma forma de validar se vai retornar todos os clientes que compraram em 2019 ou não, aqui também tem clientes de 2020.
 from vendas_analiticas

select cliente --através do filtro retorna todos os clientes que compraram em 2019
 from vendas_analiticas
where year (movimento) = 2019
-------

-- Criando subselect dentro do select in 

select a.entidade
     , a.nome
	 , b.estado
from entidades a
join enderecos b on a.entidade = b.entidade
where a.entidade in( -- 1) "where a.entidade" e "select cliente" devem ter os mesmos dados, ou seja, ser equivalentes para o SQL reconhecer a correspondências, caso contrário dará erro. 2) Nesse subselect retorna todos os clientes, uma lista que não compraram em 2019. 3) Tudo que aprendemos no curso como relacionamentos, tratamento de informações, filtros, funções de agregação também são aplicadas nesse tipo de subselect.  
                     select cliente
                      from vendas_analiticas
                     where year (movimento) = 2019
)

select a.entidade
     , a.nome
	 , b.estado
from entidades a
join enderecos b on a.entidade = b.entidade
where a.entidade not in( -- 1) "where a.entidade" e "select cliente" devem ter os mesmos dados, ou seja, ser equivalentes para o SQL reconhecer a correspondências, caso contrário dará erro. 2) Nesse subselect retorna todos os clientes, uma lista que não compraram em 2019. 3) Tudo que aprendemos no curso como relacionamentos, tratamento de informações, filtros, funções de agregação também são aplicadas nesse tipo de subselect.
                     select cliente
                      from vendas_analiticas
                     where year (movimento) = 2019
)

----------
select cliente -- esse consulta trás a lista dos clientes que mais compraram
     , sum (venda_liquida) as venda_liquida
	from vendas_analiticas
group by cliente
order by venda_liquida desc

select a.entidade -- retorna o cliente que mais comprou, porém o que mais comprou muda ao longo do tempo
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

-- Não vamos trabalhar com a lista dos clientes e sim, com a informação do que mais comprou que é o 1876, que é a primeira linha de retorno

select top 1 cliente -- coloca top 1 que trará o cliente que mais comprou
 from vendas_analiticas
 group by cliente
 order by sum(venda_liquida) desc

 -- Agora vamos juntar as consultas para trazer o cliente que mais comprou
 
select a.entidade 
     , a.nome
	 , b.estado
 from entidades a
join enderecos b on a.entidade = b.entidade
where a.entidade = ( -- pode se usar vários operadores aritméticos de comparação, porém com uma única condição que retorne apenas um resultado em uma única coluna.
           select top 1 cliente 
          from vendas_analiticas
          group by cliente
          order by sum(venda_liquida) desc -- não se usa order by em subselect, porém aqui ele tem a função de organizar a informação para o select trazer a primeira linha.
)

---

select a.entidade 
     , a.nome
	 , b.estado
 from entidades a
join enderecos b on a.entidade = b.entidade
where a.entidade <> ( -- essa consulta trará o que é diferente do 1876 
           select top 1 cliente 
          from vendas_analiticas
          group by cliente
          order by sum(venda_liquida) desc 
)

-------

-- Para a cláusula inner join também é possível usar a "," para consultas simples apenas, alguns programadores usam e por isso estou aprendendo

-- 1°
select *
 from entidades a
 join enderecos  b on a.entidade = b.entidade

-- 2°
select *
 from entidades a
    , enderecos  b
where a.entidade = b.entidade

-- O 1° e 2° select são a mesma coisa, fazem a mesma consulta inner join.

-- Exists e Not Exists

-- A 1° e a 2° forma trazem o mesmo resultado porém fora escritos de forma diferente

-- 1° Foma 

select a.entidade
     , a.nome
 from entidades a
 left join titulos_pagar b on a.entidade = b.entidade
where b.titulo_pagar is null

-----
-- 2° Forma

select a.entidade
     , a.nome
 from entidades a
 where a.entidade not in ( 
                       select distinct
					          entidade
					      from titulos_pagar
						  )
-----
-- 3° Forma 
-- Achei difícil essa aula, assistir novamente daqui um tempo.
-- Quando eu não quiser usar o left join ou not in posso usar o not exists.
-- Quando queremos relacionar qualquer outra fonte de dados, e que está no nosso comando where com as fontes de dados da query principal, seja tabela ou subquery, não conseguimos usar relacionando usando o on, sendo preciso relacionar usando o where conforme query abaixo.

-- Essa query vai pegar todas as entidades que não tem título a pagar

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


