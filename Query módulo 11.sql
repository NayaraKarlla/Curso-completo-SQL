Módulo 11

declare @v1 varchar (10) = 'italo'
declare @v2 varchar (10) = 'maria'

select isnull (@v1, @v2) -- retornar italo

-----------

declare @v1 varchar (10) = null
declare @v2 varchar (10) = 'maria'

select isnull (@v1, @v2) -- retorna maria, pois o primeiro valor não nulo que encontrou foi esse

-----------

declare @v1 varchar (10) = ' '
declare @v2 varchar (10) = 'maria'

select isnull (@v1, @v2) -- retorna vazio

select  -- isso é exatamente o que a função isnull faz por trás desse simples código isnull acima, onde foram passadas dois valores
 case when @v1 is null 
      then @v2 
      else @v1 
 end

-----------

create table tblnomes --criou a tabela
(
   nome    varchar (50)
 , apelido varchar (30)
)

select *    -- rodou a consulta
 from tblnomes

insert into tblnomes (nome, apelido) -- inseriu os dados na tabela
values ('maria das gracas','maria')

insert into tblnomes (nome, apelido)
values ('francisco jose','jose')

insert into tblnomes (nome, apelido)
values ('italo','')

insert into tblnomes (nome, apelido)
values ('francisca joaquina','francisca')

select *    -- rodou a consulta
 from tblnomes

update tblnomes -- correção para atualização dos dados da tabela
set apelido = null
where nome = 'francisca joaquina'

select *    -- rodou a consulta
 from tblnomes

select * -- no campo Italo retorna informações vazias, a função isnull já não atende o que precisamos, pois na relatoria viria faltando dados, aqui existe a necessidade de criar uma função que atenda a necessidade
  , isnull (apelido, nome) 
 from tblnomes

select * --  nessa query italo e francisco irão retornar null, para tratar isso iremos construir a próxima query
  , isnull (apelido, nome) 
  , nullif (trim (apelido), '' ) -- a função trim tira todos os espaços em branco a direita e esquerda. Nulliff, significa fique nulo se algo acontecer, essa função recebe dois parâmetros, o primeiro é a informação e na sequência como quero que retorne a informação
 from tblnomes

select * 
  , isnull (apelido, nome) 
  , case when nullif (trim (apelido), '' ) is null -- quando essa condição for nula, irá buscar o nome, se não, irá buscar o apelido
         then nome 
         else apelido 
    end
 from tblnomes -- se for executar essa query várias vezes em diferentes relatórios, a produtividade será afetada, então será criada uma função, pois basta chamá-la e ela já faz o tratamento
---------------------
-- Critérios para avaliar antes de criar uma função:

-- 1) Tenha em mente que primeiro deve-se tratar a informação do jeito que fez agora, você irá enxergar o que precisa na função, o mais difícil para criar uma função é exergar o que ela vai fazer e como vai funcionar, quando a consulta é feita antes, ajuda a ter uma noção do que é preciso ser criado
-- 2) Apelido e nome são variávéis, pois as informações contidas nelas podem mudar, sendo assim temos 2 variavéis
-- 3) Faz devagar, testa e se funcionar, implementa a função

declare @v1 varchar (50) = 'italo ' -- aqui tem um espaço que será tratado depois
declare @v2 varchar (50) = 'francisca joaquina'

set @v1= nullif (trim (@v1), '')
set @v2= nullif (trim (@v2), '')

select @v1, @v2

-------------------

create function fn_isnull (@v1 varchar (50), @v2 varchar (50)) -- coloque o nome sugestivo, para que outras pessoas quando acessarem essa base, indentifique rapidamente o que essa função faz. Os parênteses () são so parâmetros que a função vai receber

returns varchar (50) -- é preciso dizer para função o que irá retornar, não existe relação do que ela vai receber e do que ela vai retornar, posso declarar um varchar mas irá retornar um inteiro , isso eu que vou dizer de acordo com o que preciso                                                           
                     -- returns é diferente de return, o returns é para dizer o tipo de dado que irá retornar, já o return é exatamente a informação, o dado que a função vai retornar 

as 
begin -- entre o begin e o end irá colocar o texto da função ou a ação que ela vai fazer

set @v1= nullif (trim (@v1), '') -- aqui é tratamento para tirar os espaços das variáveis e disse que será nulo se elas vierem vazias
set @v2= nullif (trim (@v2), '') -- aqui é tratamento para tirar os espaços das variáveis e disse que será nulo se elas vierem vazias

return (select case when @v1 is null -- aqui retorna o primeiro valor que não é nulo após o tratamento que foi realizado anteriormente
                    then @v2
		            else @v1 end)
               end

select * 
  , isnull (apelido, nome) 
  , case when nullif (trim (apelido), '' ) is null -- quando essa condição for nula irá buscar o nome, se não, irá buscar o apelido
         then nome 
         else apelido 
    end
  , dbo.fn_isnull (apelido, nome) -- "seleção da função + alt + f1" abre a janela com as informações da função e quais dados ela recebe. Quando criamos uma função escalar não podemos passar apenas o nome dela, pois dará um erro de função não reconhecida por não ser nativa. Sempre antes da função, coloque o nome do esquema da tabela, que nesse caso é dbo que é o esquema padrão do SQL. Se a função tem parâmetros, passa a informação separada por vírgula e entre parênteses
                                  -- toda query que eu quiser tratar o valor vazio e considerar ele como nulo e simular o isnull, posso usar essa função, a vantagem de criar a função é ganhar em tempo
 from tblnomes

---------------------

-- Tratamento de dados

-- Retirando ( ., -, /) da coluna, execelente a função replace, como aqui é cpf e cnpj, as informações possuem mascará que são os caracteres para dar formato nos números

select entidade
     , inscricao_federal
     , replace (inscricao_federal, '.', '') -- replace é uma função nativa do SQL, o primeiro campo é o que quero tratar, o segundo é o caracter que quero substituir e o terceiro é por quem eu quero substituir
 from entidades
where inscricao_federal is not null

select entidade
     , inscricao_federal
     , replace (replace (inscricao_federal, '.', '') , '-', '') -- função aninhada que é uma dentro da outra
 from entidades
where inscricao_federal is not null

select entidade
     , inscricao_federal
     , replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '') -- função aninhada que é uma dentro da outra
 from entidades
where inscricao_federal is not null

select entidade
     , inscricao_federal
     , len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) -- função aninhada que é uma dentro da outra
 from entidades
where inscricao_federal is not null

select entidade
     , inscricao_federal
	 , replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')
     , len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) -- função aninhada que é uma dentro da outra
     , case when len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) = 14
	      then 'pj'
		  when len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) = 11
		  then 'pf'
		  else 'nd'
	   end
 from entidades

-- A query anterior também pode ser escrita de forma mais resumida quando no case when tiver apenas uma condição

select entidade
     , inscricao_federal
	 , replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')
     , len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) -- função aninhada que é uma dentro da outra
     , case len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', ''))
	      when 14
	      then 'pj'
		  when 11
		  then 'pf'
		  else 'nd'
	   end
 from entidades

create function fn_tipo_inscricao (@inscricao_federal varchar (50)) -- esse campo recebe até 50 caracteres

returns char (2) -- tipo de dado que a função irá retornar, não tem outra possibilidade de retornar mais do que 2 caracteres, por isso foi declarado dessa forma

as 
begin

declare @tipo_inscricao char(2)

set @inscricao_federal = (replace (replace (replace (@inscricao_federal, '.', '') , '-', '') , '/', ''))

set @tipo_inscricao = case len(@inscricao_federal) 
						   when 14 
						   then 'pj'
						   when 11
						   then 'pf'
						   else 'nd'
				      end

return @tipo_inscricao
end

select entidade
     , inscricao_federal
	 , replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')
     , len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) -- função aninhada que é uma dentro da outra
     , case len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', ''))
	      when 14
	      then 'pj'
		  when 11
		  then 'pf'
		  else 'nd'
	   end
	 , dbo.fn_tipo_inscricao (inscricao_federal) -- ao incluir a função personalizada e rodar a query, teremos o retorno das mesmas informações do código e da função criada, sempre que precisar da inscrição federal é só passar a função que já irá funcionar de forma rápida e prática
 from entidades
 
select entidade
    , inscricao_federal
    , dbo.fn_tipo_inscricao (inscricao_federal)
 from entidades

-- Dentro de uma função é possível usar o select pegando os dados das tabelas mesmo, pode não ser o mais indicado mas em alguns cenários talvez você precise usar
-- Rever a aula 'Fixando a sintaxe das funções'

create function fn_tipo_inscricao_ii (@cliente numeric (15)) 

returns char (2) -- tipo de dado que a função irá retornar, não tem outra possibilidade de retornar mais do que 2 caracteres, por isso foi declarado dessa forma

as 
begin

declare @tipo_inscricao char(2)
declare @inscricao_federal varchar(50)

select @inscricao_federal = inscricao_federal
 from entidades
where entidade = @cliente

set @inscricao_federal = (replace (replace (replace (@inscricao_federal, '.', '') , '-', '') , '/', ''))

set @tipo_inscricao = case len(@inscricao_federal) 
						   when 14 
						   then 'pj'
						   when 11
						   then 'pf'
						   else 'nd'
				      end

return @tipo_inscricao
end

select entidade
    , inscricao_federal
    , dbo.fn_tipo_inscricao (inscricao_federal) -- a coluna dbo.fn_tipo_inscricao e a coluna dbo.fn_tipo_inscricao_ii possuem a mesma informação porém foram criadas de maneira diferentes 
	, dbo.fn_tipo_inscricao_ii (entidade)
 from entidades

 ---------------------

 -- Procedure: armazena uma dimensão na tabela clientes, pode ou não receber parâmetros, a procedure abaixo retorna informações de acordo com o código descrito

create procedure usp_retorna_clientes -- após criar a procedura todo o código abaixo não precisa ser digitado, é só chamar através da procedure

as

begin -- esse termo begin é obrigatório nas funções mas não é obrigatório nas procedures, foi clocado apenas por costume e informação

select  a.entidade              as entidade
       ,a.nome                  as nome
	   ,a.nome_fantasia         as nome_fantasia
	   ,a.inscricao_federal     as inscricao_federal
	   ,b.descricao             as classif_cliente
	   ,c.cidade                as cidade
	   ,c.estado                as uf
 from entidades                    a
 left join classificacoes_clientes b on a.classificacao_cliente = b.classificacao_cliente
 left join enderecos               c on a.entidade              = c.entidade
 left join estados                 d on c.estado                = d.estado

 end -- esse termo end é obrigatório nas funções mas não é obrigatório nas procedures, foi clocado apenas por costume e informação

execute usp_retorna_clientes -- essa é a forma de chamar uma procedure

create procedure usp_retorna_clientes_parametros (@uf char (2))

as

begin 

select  a.entidade              as entidade
       ,a.nome                  as nome
	   ,a.nome_fantasia         as nome_fantasia
	   ,a.inscricao_federal     as inscricao_federal
	   ,b.descricao             as classif_cliente
	   ,c.cidade                as cidade
	   ,c.estado                as uf
   from entidades                  a
 left join classificacoes_clientes b on a.classificacao_cliente = b.classificacao_cliente
 left join enderecos               c on a.entidade              = c.entidade
 left join estados                 d on c.estado                = d.estado
  where c.estado = @uf
 end

 execute usp_retorna_clientes_parametros 'al' -- irá retorna só os dados do estado de Alagoas

---------------------
-- Procedures sem retorno

-- Vamos pegar os dados de uma tabela existente e levar automáticamente para uma nova tabela que será criada, o objetivo é ter uma tabela consolidadora se informações
-- 1° Identifique os campos dessa nova tabela;
-- 2° Crie a tabela;
-- 3° Coloque o tipo de dado que cada coluna irá receber, ou seja, faça a tipagem
-- 4° Popule a tabela

if object_id ('pbs_procfit_dados..tbl_clientes') -- aqui está informando que a tabela está dentro do banco de dados pbs_procfit_dados e que irá procurar a tabela dentro dessa base

select object_id ('tbl_clientes') -- object_id retorna o código da tabela, esse código representa a tabela dentro do database

drop table tbl_clientes -- comando para apagar a tabela, aqui ela deixará de existir

create table tbl_clientes -- se alguém apagar a sua tabela, a rotina que foi criada não será executada, por isso é importante sempre deixar a create table dentro da rotina, para que verifique antes se essa tabela existe ou não 
(
   entidade           numeric (15)
 , nome               varchar (80)
 , nome_fantasia      varchar (60)
 , inscricao_federal   varchar (19)
 , classificacao      varchar (80) -- quando criamos um varchar, a informação não necessáriamente irá ocupar todos os campos da memória, só vai ocupar o espaço que realmente é necessário, se eu tenho um valor que ocupará 10 posições então será ocupado apenas as 10 posições
 , cidade             varchar (80) -- se tem um char de 80 posições, independente do tamanho da informação, será ocupada às 80 posições, sendo assim, sempre coloque a quantidade de posições que realmente será usada, ou seja, quando você sabe exatamente qual informação armazenar na tipagem
 , estado             varchar (80)
 , uf                 char    (2)
)

----

if object_id ('pbs_procfit_dados..tbl_clientes') is null -- se os dados retornarem nulos, é porque a tabela não existe e é necessário criar, sendo assim, sem alguém excluir a tabela, aqui será verificado se ela existe, se não existir será recriada

begin

create table tbl_clientes -- criando a tabela de clientes consolidado, apenas se ela não existir, se alguém apagar a sua tabela, a rotina que foi criada não será executada, por isso é importante sempre deixar a create table dentro da rotina, para que verifique antes se essa tabela existe ou não 
(
   entidade           numeric (15)
 , nome               varchar (80)
 , nome_fantasia      varchar (60)
 , inscricao_federal  varchar (19)
 , classificacao      varchar (80) -- quando criamos um varchar, a informação não necessáriamente irá ocupar todos os campos da memória, só vai ocupar o espaço que realmente é necessário, se eu tenho um valor que ocupará 10 posições então será ocupado as 10 posições
 , cidade             varchar (80) -- se tem um char de 80 posições, independente do tamanho da informação, será ocupada às 80 posições, sendo assim, sempre coloque a quantidade de posições que realmente será usada, ou seja, quando você sabe exatamente qual informação armazenar na tipagem
 , estado             varchar (80)
 , uf                 char    (2)
)

end

select *
 from tbl_clientes

insert into tbl_clientes -- populando a tabela de clientes consolidada
(
   entidade            
 , nome               
 , nome_fantasia      
 , inscricao_federal   
 , classificacao      
 , estado             
 , uf               
)

select  a.entidade              as entidade
       ,a.nome                  as nome
	   ,a.nome_fantasia         as nome_fantasia
	   ,a.inscricao_federal     as inscricao_federal
	   ,b.descricao             as classif_cliente
	   ,c.cidade                as cidade
	   ,c.estado                as uf
   from entidades                  a
 left join classificacoes_clientes b on a.classificacao_cliente = b.classificacao_cliente
 left join enderecos               c on a.entidade              = c.entidade
 left join estados                 d on c.estado                = d.estado

 select *
 from tbl_clientes -- aqui a query está duplicando as informações porque não estamos tratando as informações da tabela

 drop table tbl_clientes

----
-- Agora será feito um insert mais inteligente na tabela, vamos usar a cláusula merge
-- As procedures aceitam tabelas temporárias

create procedure usp_atualiza_clientes_consolidado -- comando para criar a procedure é executado no final

alter procedure usp_atualiza_clientes_consolidado -- comando para alterar/atualizar a procedure

as

if object_id ('pbs_procfit_dados..tbl_clientes') is null -- se os dados retornarem nulos é porque a tabela não existe e é necessário criar, sendo assim, sem alguém excluir a tabela, aqui será verificado se ela existe, se não existir será recriada

begin

create table tbl_clientes -- criando a tabela de clientes consolidada, apenas se ela não existir, se alguém apagar a sua tabela, a rotina que foi criada não será executada, por isso é importante sempre deixar a create table dentro da rotina, para que verifique antes se essa tabela existe ou não 
(
   entidade           numeric (15) primary key
 , nome               varchar (80)
 , nome_fantasia      varchar (60)
 , inscricao_federal  varchar (19)
 , classificacao      varchar (80) -- quando criamos um varchar, a informação não necessáriamente irá ocupar todos os campos da memória, só vai ocupar o espaço que realmente é necessário, se eu tenho um valor que ocupará 10 posições então será ocupado apenas as 10 posições
 , cidade             varchar (80) -- se tem um char de 80 posições, independente do tamanho da informação, será ocupada às 80 posições, sendo assim, sempre coloque a quantidade de posições que realmente será usada, ou seja, quando você sabe exatamente qual informação armazenar na tipagem
 , estado             varchar (80)
 , uf                 char    (2)
)

end

if object_id ('tempdb..#dados_integracao') is not null drop table #dados_integracao -- aqui está apagando caso os dados existam, por isso do is not null

select  a.entidade              as entidade
       ,a.nome                  as nome
	   ,a.nome_fantasia         as nome_fantasia
	   ,a.inscricao_federal     as inscricao_federal
	   ,b.descricao             as classif_cliente
	   ,c.cidade                as cidade
	   ,d.nome                  as estado
	   ,c.estado                as uf
   into #dados_integracao
   from entidades                  a
 left join classificacoes_clientes b on a.classificacao_cliente = b.classificacao_cliente
 left join enderecos               c on a.entidade              = c.entidade
 left join estados                 d on c.estado                = d.estado


-- Populando tabela de clientes consolidado
 
merge tbl_clientes       d   -- será feito um merge na tbl_clientes usando os dados da fonte que será a tabela temporária #dados_integracao
using #dados_integracao  o on d.entidade = o.entidade
when matched then update
set nome                  = o.nome
  , nome_fantasia         = o.nome_fantasia
  , inscricao_federal     = o.inscricao_federal
  , classificacao         = o.classif_cliente
  , cidade                = o.cidade
  , estado                = o.estado
  , uf                    = o.uf

when not matched by target then insert
 (
   entidade            
 , nome               
 , nome_fantasia      
 , inscricao_federal   
 , classificacao    
 , cidade
 , estado             
 , uf
)

values 
 (
   o.entidade            
 , o.nome               
 , o.nome_fantasia      
 , o.inscricao_federal   
 , o.classif_cliente  
 , o.cidade
 , o.estado             
 , o.uf
);

select 'tabela atualizada com sucesso!' -- essa mensagem pode ser armazenada em uma tabela de log

exec usp_atualiza_clientes_consolidado -- comando para executar e chamar a procedure, aqui ela só informa quantas linhas foram afetadas mas não trás nenhum retorno de dados

drop table tbl_clientes -- mesmo após apagar, a procedure irá criar novamente a tabela com a população dos dados

select * from tbl_clientes

-- Observação: o retorno de uma procedure pode popular os dados de uma nova tabela, os códigos extensos são salvos em procedures para não serem escritos novamente

---------------------
-- Criando View

create view vw_clientes_consolidado

as

select  a.entidade              as entidade
       ,a.nome                  as nome
	   ,a.nome_fantasia         as nome_fantasia
	   ,a.inscricao_federal     as inscricao_federal
	   ,b.descricao             as classif_cliente
	   ,c.cidade                as cidade
	   ,d.nome                  as estado
	   ,c.estado                as uf
   from entidades                  a
 left join classificacoes_clientes b on a.classificacao_cliente = b.classificacao_cliente
 left join enderecos               c on a.entidade              = c.entidade
 left join estados                 d on c.estado                = d.estado

-- Consultando a view

 select *
  from vw_clientes_consolidado

