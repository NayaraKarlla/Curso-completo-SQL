Módulo 9

-- Para trabalhabar com variáveis é necessário declarar e usar o @ para nomear, coloque nome sugestivos e fáceis de usar, escolha um tipo de dado na declaração

declare @movimento date -- aqui declarei uma variável tipo date

set @movimento = '01/01/2021'-- setou a variável para 01/01/2021

select @movimento -- rodou o comando e viu o valor da variável

set @movimento = cast ( getdate () as date) -- aqui mudou o valor da variável

select @movimento -- rodou o comando e viu a alteração do valor da variável

select titulo_receber
	 , titulo
	 , entidade
	 , valor
 from titulos_receber a
 where a.movimento >= '01/01/2019'
   and a.movimento <= '31/12/2019'

-- A orientação é que as variáveis fiquem no início do código

declare @movimento_ini  date
declare @movimento_fim  date

set @movimento_ini = '01/01/2019'
set @movimento_fim = '31/12/2019'

select titulo_receber
	  , titulo
	  , entidade
	  , valor
 from titulos_receber a
 where a.movimento >= @movimento_ini
   and a.movimento <= @movimento_fim

-- Se precisar mudar os valores na váriável é só mudar os valores que foram setados

declare @movimento_ini  date
declare @movimento_fim  date

set @movimento_ini = '01/01/2020'
set @movimento_fim = '31/12/2020'

select titulo_receber
	  , titulo
	  , entidade
	  , valor
 from titulos_receber a
 where a.movimento >= @movimento_ini
   and a.movimento <= @movimento_fim

-- As variáveis também pode ser colunas nas tabelas

declare @movimento_ini  date
declare @movimento_fim  date

set @movimento_ini = '01/01/2020'
set @movimento_fim = '31/12/2020'

select  @movimento_ini as movimento_ini
      , @movimento_fim as movimento_fim
      , titulo_receber
	  , titulo
	  , entidade
	  , valor
 from titulos_receber a
 where a.movimento >= @movimento_ini
   and a.movimento <= @movimento_fim

--

declare @movimento_ini  date
declare @movimento_fim  date
declare @percentual_acrescimento numeric (15,2) 

set @movimento_ini = '01/01/2020'
set @movimento_fim = '31/12/2020'
set @percentual_acrescimento = 10.00

select  @movimento_ini as movimento_ini
      , @movimento_fim as movimento_fim
      , titulo_receber
	  , titulo
	  , entidade
	  , valor
	  , @percentual_acrescimento as percentual_juros
	  , valor * (1 + (@percentual_acrescimento / 100) ) as valor_com_juros
 from titulos_receber a
 where a.movimento >= @movimento_ini
   and a.movimento <= @movimento_fim

-- Também é possível declarar variável colocando os valores na frente do tipo de dados conforme abaixo:

declare @movimento_ini           date           ='01/01/2020' -- forma resumida de declarar variável
      , @movimento_fim           date           ='31/12/2020' -- também é possível colocar , no lugar do 'declare' sem precisar ficar repetindo a palavra, isso mostra que você conhece da linguagem
      , @percentual_acrescimento numeric (15,2) = 15.00

select  @movimento_ini as movimento_ini
      , @movimento_fim as movimento_fim
      , titulo_receber
	  , titulo
	  , entidade
	  , valor
	  , @percentual_acrescimento as percentual_juros
	  , valor * ( 1 + (@percentual_acrescimento / 100) ) as valor_com_juros
 from titulos_receber a
 where a.movimento >= @movimento_ini
   and a.movimento <= @movimento_fim
------------

-- 1° Forma de declarar variável

declare @data_atual_1 date

set @data_atual_1 = '02/11/2021'

select @data_atual_1

-- 2° Forma de declarar variável -- retorna data e hora atual

declare @data_atual_02 date = getdate ()

select @data_atual_02, getdate ()

-- 3° Forma de declarar variável -- baseada no resultado de um comando select

-- 1°

select *
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade

-- 2°

select b.estado
     , sum (a.venda_liquida) as valor_vendido
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) asc

-- 3°

select top 1 b.estado
     , sum (a.venda_liquida) as valor_vendido
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) asc

-- 4° Agora o estado será salvo em uma variável

declare @uf_menor_venda char (2)

set @uf_menor_venda =   -- ao definir uma informação váriavel dinâmica é preciso colocar as condições em () para conseguir usar o comando set e passar a instrução select para a variável

(
select top 1 b.estado -- ao rodar toda essa instrução dará o erro 'Somente uma expressão pode ser especificada na lista de seleção', isso se dá porque é preciso tirar um campo do select e deixar apenas um 
     , sum (a.venda_liquida) as valor_vendido
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) asc
 )

-- 5° 

declare @uf_menor_venda char (2)

set @uf_menor_venda =   

(
select top 1 b.estado  -- agora dará sucesso no comando, o erro não aparecerá mais
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) asc
 )

 select @uf_menor_venda

-- 6° -- retornará os 7 clientes que são do MS

declare @uf_menor_venda char (2)

set @uf_menor_venda =   

(
select top 1 b.estado  
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) asc
 )

 select a.entidade
      , a.nome
 from entidades a
 join enderecos b on a.entidade = b.entidade
 where b.estado = @uf_menor_venda

-- 4° Forma de declarar variável -- baseado no resultado de um comando select, posso atribuir a váriavel direto no select
-- Para mim essa é a forma mais prática e direta, usaria essa sem dúvida

-- 1°

declare @uf_maior_venda    char (2)
declare @valor_total_venda numeric (15,2)

select top 1 
           @uf_maior_venda    = b.estado  -- sempre que for atribuir mais de uma váriavel na query, jamais pode gerar mais de uma linha de resultado, ou seja, atribui apenas um valor e não um conjunto de valores
		  ,@valor_total_venda = sum (a.venda_liquida)
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) desc

 select @uf_maior_venda, @valor_total_venda

-- 2° Consulta retorna todos os clientes que são do Ceará

declare @uf_maior_venda    char (2)
declare @valor_total_venda numeric (15,2)

select top 1 
           @uf_maior_venda    = b.estado  -- sempre que for atribuir mais de uma váriavel na query, jamais pode gerar mais de uma linha de resultado, ou seja, atribui apenas um valor e não um conjunto de valores
		  ,@valor_total_venda = sum (a.venda_liquida)
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) desc

 select a.entidade
      , a.nome
 from entidades a
 join enderecos b on a.entidade = b.entidade
 where b.estado = @uf_maior_venda

 ----------------
-- Mais um tipo de variável tipo tabela para armazenar informações em uma variável e não em subqueries e ou tabelas temporária
-- Só funciona no contexto de execução, não fica armazenada dentro do banco de dados ex: tempodb
-- Cuidado ao usar variável do tipo table, pois o computador tira da sua memória coisas importante para colocar a sua variável do tipo table lá 
 
-- 1°

 declare @clientes_ativos table
 ( -- especificar cada campo e quais tipos de dados cada campo correspondente
  cod_cliente numeric(15)
 ,nome_cliente varchar(20)
 ,total_vendido money
 )
 select *  -- se rodar apenas essa consulta, não irá trazer informações, pois está fora de contexto usá-la sozinha, só rodar quando for dentro do contexto de declarar e dar um select na variável
  from @clientes_ativos

-- 2°

declare @clientes_ativos table
 ( -- especificar cada campo e quais tipos de dados cada campo correspondente
  cod_cliente numeric(15)
 ,nome_cliente varchar(20)
 ,total_vendido money
 )

insert into @clientes_ativos (cod_cliente, nome_cliente, total_vendido) -- o comando insert você passa o nome dos campos que deseja inserir e essas iformações que irão para os campos podem estar em um resultado select ou podem estar definidas de maneira manual usando outra cláusula    

select a.entidade
     , a.nome
	 , sum(b.venda_liquida) as total_vendido
   from entidades         a
   join vendas_analiticas b on a.entidade = b.cliente
   where a.ativo = 's'
   group by a.entidade, nome

select *
  from @clientes_ativos

-- 3° usando a variável tipo table

declare @clientes_ativos table
 ( -- especificar cada campo e quais tipos de dados cada campo correspondente
  cod_cliente numeric(15)
 ,nome_cliente varchar(20)
 ,total_vendido money
 )

insert into @clientes_ativos (cod_cliente, nome_cliente, total_vendido) -- no comando insert, você passa o nome dos campos que deseja inserir, e essas iformações que vão para os campos, podem estar em um resultado select ou podem estar definidas de maneira manual usando outra cláusula    

select a.entidade
     , a.nome
	 , sum(b.venda_liquida) as total_vendido
   from entidades         a
   join vendas_analiticas b on a.entidade = b.cliente
   where a.ativo = 's'
   group by a.entidade, nome

select a.*    -- para essa consulta rodar é necessário rodar as anteriores que declara o insert, essa consulta não pode rodar sozinha, pois os dados não são armazenados e só funciona em execução junto com as demais informações
     , b.cidade
	 , estado
 from @clientes_ativos   a
 join enderecos          b on a.cod_cliente = b.entidade
