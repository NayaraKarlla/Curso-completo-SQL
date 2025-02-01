M�dulo 9

-- Para trabalhabar com vari�veis � necess�rio declarar e usar o @ para nomear, coloque nome sugestivos e f�ceis de usar, escolha um tipo de dado na declara��o

declare @movimento date -- aqui declarei uma vari�vel tipo date

set @movimento = '01/01/2021'-- setou a vari�vel para 01/01/2021

select @movimento -- rodou o comando e viu o valor da vari�vel

set @movimento = cast ( getdate () as date) -- aqui mudou o valor da vari�vel

select @movimento -- rodou o comando e viu a altera��o do valor da vari�vel

select titulo_receber
	 , titulo
	 , entidade
	 , valor
 from titulos_receber a
 where a.movimento >= '01/01/2019'
   and a.movimento <= '31/12/2019'

-- A orienta��o � que as vari�veis fiquem no in�cio do c�digo

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

-- Se precisar mudar os valores na v�ri�vel � s� mudar os valores que foram setados

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

-- As vari�veis tamb�m pode ser colunas nas tabelas

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

-- Tamb�m � poss�vel declarar vari�vel colocando os valores na frente do tipo de dados conforme abaixo:

declare @movimento_ini           date           ='01/01/2020' -- forma resumida de declarar vari�vel
      , @movimento_fim           date           ='31/12/2020' -- tamb�m � poss�vel colocar , no lugar do 'declare' sem precisar ficar repetindo a palavra, isso mostra que voc� conhece da linguagem
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

-- 1� Forma de declarar vari�vel

declare @data_atual_1 date

set @data_atual_1 = '02/11/2021'

select @data_atual_1

-- 2� Forma de declarar vari�vel -- retorna data e hora atual

declare @data_atual_02 date = getdate ()

select @data_atual_02, getdate ()

-- 3� Forma de declarar vari�vel -- baseada no resultado de um comando select

-- 1�

select *
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade

-- 2�

select b.estado
     , sum (a.venda_liquida) as valor_vendido
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) asc

-- 3�

select top 1 b.estado
     , sum (a.venda_liquida) as valor_vendido
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) asc

-- 4� Agora o estado ser� salvo em uma vari�vel

declare @uf_menor_venda char (2)

set @uf_menor_venda =   -- ao definir uma informa��o v�riavel din�mica � preciso colocar as condi��es em () para conseguir usar o comando set e passar a instru��o select para a vari�vel

(
select top 1 b.estado -- ao rodar toda essa instru��o dar� o erro 'Somente uma express�o pode ser especificada na lista de sele��o', isso se d� porque � preciso tirar um campo do select e deixar apenas um 
     , sum (a.venda_liquida) as valor_vendido
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) asc
 )

-- 5� 

declare @uf_menor_venda char (2)

set @uf_menor_venda =   

(
select top 1 b.estado  -- agora dar� sucesso no comando, o erro n�o aparecer� mais
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) asc
 )

 select @uf_menor_venda

-- 6� -- retornar� os 7 clientes que s�o do MS

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

-- 4� Forma de declarar vari�vel -- baseado no resultado de um comando select, posso atribuir a v�riavel direto no select
-- Para mim essa � a forma mais pr�tica e direta, usaria essa sem d�vida

-- 1�

declare @uf_maior_venda    char (2)
declare @valor_total_venda numeric (15,2)

select top 1 
           @uf_maior_venda    = b.estado  -- sempre que for atribuir mais de uma v�riavel na query, jamais pode gerar mais de uma linha de resultado, ou seja, atribui apenas um valor e n�o um conjunto de valores
		  ,@valor_total_venda = sum (a.venda_liquida)
 from vendas_analiticas a
 join enderecos         b on a.cliente = b.entidade
 group by b.estado 
 order by sum (a.venda_liquida) desc

 select @uf_maior_venda, @valor_total_venda

-- 2� Consulta retorna todos os clientes que s�o do Cear�

declare @uf_maior_venda    char (2)
declare @valor_total_venda numeric (15,2)

select top 1 
           @uf_maior_venda    = b.estado  -- sempre que for atribuir mais de uma v�riavel na query, jamais pode gerar mais de uma linha de resultado, ou seja, atribui apenas um valor e n�o um conjunto de valores
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
-- Mais um tipo de vari�vel tipo tabela para armazenar informa��es em uma vari�vel e n�o em subqueries e ou tabelas tempor�ria
-- S� funciona no contexto de execu��o, n�o fica armazenada dentro do banco de dados ex: tempodb
-- Cuidado ao usar vari�vel do tipo table, pois o computador tira da sua mem�ria coisas importante para colocar a sua vari�vel do tipo table l� 
 
-- 1�

 declare @clientes_ativos table
 ( -- especificar cada campo e quais tipos de dados cada campo correspondente
  cod_cliente numeric(15)
 ,nome_cliente varchar(20)
 ,total_vendido money
 )
 select *  -- se rodar apenas essa consulta, n�o ir� trazer informa��es, pois est� fora de contexto us�-la sozinha, s� rodar quando for dentro do contexto de declarar e dar um select na vari�vel
  from @clientes_ativos

-- 2�

declare @clientes_ativos table
 ( -- especificar cada campo e quais tipos de dados cada campo correspondente
  cod_cliente numeric(15)
 ,nome_cliente varchar(20)
 ,total_vendido money
 )

insert into @clientes_ativos (cod_cliente, nome_cliente, total_vendido) -- o comando insert voc� passa o nome dos campos que deseja inserir e essas iforma��es que ir�o para os campos podem estar em um resultado select ou podem estar definidas de maneira manual usando outra cl�usula    

select a.entidade
     , a.nome
	 , sum(b.venda_liquida) as total_vendido
   from entidades         a
   join vendas_analiticas b on a.entidade = b.cliente
   where a.ativo = 's'
   group by a.entidade, nome

select *
  from @clientes_ativos

-- 3� usando a vari�vel tipo table

declare @clientes_ativos table
 ( -- especificar cada campo e quais tipos de dados cada campo correspondente
  cod_cliente numeric(15)
 ,nome_cliente varchar(20)
 ,total_vendido money
 )

insert into @clientes_ativos (cod_cliente, nome_cliente, total_vendido) -- no comando insert, voc� passa o nome dos campos que deseja inserir, e essas iforma��es que v�o para os campos, podem estar em um resultado select ou podem estar definidas de maneira manual usando outra cl�usula    

select a.entidade
     , a.nome
	 , sum(b.venda_liquida) as total_vendido
   from entidades         a
   join vendas_analiticas b on a.entidade = b.cliente
   where a.ativo = 's'
   group by a.entidade, nome

select a.*    -- para essa consulta rodar � necess�rio rodar as anteriores que declara o insert, essa consulta n�o pode rodar sozinha, pois os dados n�o s�o armazenados e s� funciona em execu��o junto com as demais informa��es
     , b.cidade
	 , estado
 from @clientes_ativos   a
 join enderecos          b on a.cod_cliente = b.entidade