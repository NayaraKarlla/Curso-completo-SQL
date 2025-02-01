M�dulo 5

select produto
      ,sum(venda_liquida ) as total_venda
from vendas_analiticas
group 
	by produto
order
	by sum(venda_liquida ) desc

---------------

select b.marca
     , c.descricao            as descricao_marca
      ,sum( a.venda_liquida ) as total_venda
from vendas_analiticas a 
join produtos          b on a.produto = b.produto
join marcas            c on b.marca = c.marca
group 
	by b.marca
	,  c.descricao
order
	by b.marca

---------------

select a.produto
      ,a.descricao
	  ,a.familia_produto
	  ,b.descricao
from produtos          a
join familias_produtos b on a.familia_produto = b.familia_produto

------------------------
select a.produto
     , b.descricao
	 , a.quantidade
from vendas_analiticas a
join produtos          b on a.produto = b.produto
join familias_produtos c on b.familia_produto = c.familia_produto

------------------

select c.descricao as familia
     , sum (a.quantidade)
from vendas_analiticas a
join produtos          b on a.produto = b.produto
join familias_produtos c on b.familia_produto = c.familia_produto
group by c.descricao

--------------------

select a.vendedor
     , b.nome
     , sum (a.quantidade) as quantidade
from vendas_analiticas a
join vendedores        b on a.vendedor = b.vendedor
where a.vendedor in (1,2,3,20)
group by a.vendedor, b.nome
having sum (a.quantidade) > 35840.00
order 
    by a.vendedor

-----------------
-- Desafio aula 9

-- 1� Etapa

select a.venda_liquida
 from vendas_analiticas a 

 -- 2� Etapa: avaliar a tabela e se tem os dados

 select fabricante
	from produtos
	where fabricante is not null -- descobri que tem 45 fabricantes e as demais linhas s�o null

-- 3� Etapa: avaliar quais colunas as tabelas tem em comum, uma dica, olhe as chaves prim�rias das tabelas que vai realizar o relacionamento, geralmente o relacionamento se d� pela chave prim�ria e chave estrangeira, por�m, aqui o relacimento aconteceu pela chave prim�ria e est� tudo certo, ele vai acontecer.
-- Avaliar nas informa��es da tabela se na coluna "Nullable" para o campo produto, se est� nulo, se sim, sempre que for registrar uma informa��o na coluna ser� obrigat�rio informar o c�digo do produto, ou seja, nunca hav�ra registro de nulo nesse campo. Por esse campo ser assim, vamos usar join no lugar de left join por quest�o de performance.

-- Para validar alguma informa��o � importante fazer um select simples e direto para que pegue os dados fidedignos na consulta, pois aqui n�o haver� nenhum filtro ou agrega��o.

select count (*)
 from produtos
 where fabricante is null --- o resultado foi 5390
 
-- 

select a.fabricante 
     , coalesce (c.nome, 'n�o identificado') as nome_fabricante
     , count (distinct a.produto) as quantidade_produtos
     , avg (b.venda_liquida)      as media_vendas
from produtos               a             
left join vendas_analiticas b on a.produto = b.produto
left join pessoas_juridicas c on a.fabricante = c.entidade
Group by a.fabricante, c.nome
Order by media_vendas desc

---------------------

-- Desafio aula 11

select b.fabricante 
     , coalesce (c.nome, 'n�o identificado') as nome_fabricante
     , count (distinct b.produto) as quantidade_produtos
     , avg (a.venda_liquida)      as media_vendas
from vendas_analiticas               a             
right join produtos                  b on a.produto = b.produto
left join pessoas_juridicas          c on b.fabricante = c.entidade
Group by b.fabricante, c.nome
Order by media_vendas desc

-----------

select coalesce (a.vendedor, b.vendedor) as vendedor
     , isnull (sum (a.quantidade), 0 ) as qtd
from vendas_analiticas a
full
join vendedores        b on a.vendedor = b.vendedor
group
   by coalesce (a.vendedor, b.vendedor)
order by coalesce (a.vendedor, b.vendedor)

------
-- Desafio aula 14

-- 1� Etapa -- aqui ser� poss�vel ver as duas colunas que possuem a mesma informa��o se est�o totalmente preenchidas ou se tem null, e quer dizer que o cliente n�o tem venda

select distinct
       a.cliente
	 , b.entidade
from vendas_analiticas a
full join entidades    b on a.cliente = b.entidade

--2� Etapa -- aqui a fun��o coalesce fez com que todas as linhas fosse preechidas e n�o tem null 

select coalesce ( a.cliente, b.entidade) as cod_cliente
from vendas_analiticas a
full join entidades    b on a.cliente = b.entidade

-- 3� Etapa -- resultado correto ap�s aula

select coalesce ( a.cliente, b.entidade) as cod_cliente
     , b.nome
     , isnull (sum (a.venda_liquida), 0) as total_vendido -- se a soma do resultado for null retornar� 0 
from vendas_analiticas a
full join entidades    b on a.cliente = b.entidade
group by coalesce ( a.cliente, b.entidade )
        ,b.nome
order by total_vendido desc
