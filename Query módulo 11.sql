M�dulo 11

declare @v1 varchar (10) = 'italo'
declare @v2 varchar (10) = 'maria'

select isnull (@v1, @v2) -- retornar italo

-----------

declare @v1 varchar (10) = null
declare @v2 varchar (10) = 'maria'

select isnull (@v1, @v2) -- retorna maria, pois o primeiro valor n�o nulo que encontrou foi esse

-----------

declare @v1 varchar (10) = ' '
declare @v2 varchar (10) = 'maria'

select isnull (@v1, @v2) -- retorna vazio

select  -- isso � exatamente o que a fun��o isnull faz por tr�s desse simples c�digo isnull acima, onde foram passadas dois valores
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

update tblnomes -- corre��o para atualiza��o dos dados da tabela
set apelido = null
where nome = 'francisca joaquina'

select *    -- rodou a consulta
 from tblnomes

select * -- no campo Italo retorna informa��es vazias, a fun��o isnull j� n�o atende o que precisamos, pois na relatoria viria faltando dados, aqui existe a necessidade de criar uma fun��o que atenda a necessidade
  , isnull (apelido, nome) 
 from tblnomes

select * --  nessa query italo e francisco ir�o retornar null, para tratar isso iremos construir a pr�xima query
  , isnull (apelido, nome) 
  , nullif (trim (apelido), '' ) -- a fun��o trim tira todos os espa�os em branco a direita e esquerda. Nulliff, significa fique nulo se algo acontecer, essa fun��o recebe dois par�metros, o primeiro � a informa��o e na sequ�ncia como quero que retorne a informa��o
 from tblnomes

select * 
  , isnull (apelido, nome) 
  , case when nullif (trim (apelido), '' ) is null -- quando essa condi��o for nula, ir� buscar o nome, se n�o, ir� buscar o apelido
         then nome 
         else apelido 
    end
 from tblnomes -- se for executar essa query v�rias vezes em diferentes relat�rios, a produtividade ser� afetada, ent�o ser� criada uma fun��o, pois basta cham�-la e ela j� faz o tratamento
---------------------
-- Crit�rios para avaliar antes de criar uma fun��o:

-- 1) Tenha em mente que primeiro deve-se tratar a informa��o do jeito que fez agora, voc� ir� enxergar o que precisa na fun��o, o mais dif�cil para criar uma fun��o � exergar o que ela vai fazer e como vai funcionar, quando a consulta � feita antes, ajuda a ter uma no��o do que � preciso ser criado
-- 2) Apelido e nome s�o vari�v�is, pois as informa��es contidas nelas podem mudar, sendo assim temos 2 variav�is
-- 3) Faz devagar, testa e se funcionar, implementa a fun��o

declare @v1 varchar (50) = 'italo ' -- aqui tem um espa�o que ser� tratado depois
declare @v2 varchar (50) = 'francisca joaquina'

set @v1= nullif (trim (@v1), '')
set @v2= nullif (trim (@v2), '')

select @v1, @v2

-------------------

create function fn_isnull (@v1 varchar (50), @v2 varchar (50)) -- coloque o nome sugestivo, para que outras pessoas quando acessarem essa base, indentifique rapidamente o que essa fun��o faz. Os par�nteses () s�o so par�metros que a fun��o vai receber

returns varchar (50) -- � preciso dizer para fun��o o que ir� retornar, n�o existe rela��o do que ela vai receber e do que ela vai retornar, posso declarar um varchar mas ir� retornar um inteiro , isso eu que vou dizer de acordo com o que preciso                                                           
                     -- returns � diferente de return, o returns � para dizer o tipo de dado que ir� retornar, j� o return � exatamente a informa��o, o dado que a fun��o vai retornar 

as 
begin -- entre o begin e o end ir� colocar o texto da fun��o ou a a��o que ela vai fazer

set @v1= nullif (trim (@v1), '') -- aqui � tratamento para tirar os espa�os das vari�veis e disse que ser� nulo se elas vierem vazias
set @v2= nullif (trim (@v2), '') -- aqui � tratamento para tirar os espa�os das vari�veis e disse que ser� nulo se elas vierem vazias

return (select case when @v1 is null -- aqui retorna o primeiro valor que n�o � nulo ap�s o tratamento que foi realizado anteriormente
                    then @v2
		            else @v1 end)
               end

select * 
  , isnull (apelido, nome) 
  , case when nullif (trim (apelido), '' ) is null -- quando essa condi��o for nula ir� buscar o nome, se n�o, ir� buscar o apelido
         then nome 
         else apelido 
    end
  , dbo.fn_isnull (apelido, nome) -- "sele��o da fun��o + alt + f1" abre a janela com as informa��es da fun��o e quais dados ela recebe. Quando criamos uma fun��o escalar n�o podemos passar apenas o nome dela, pois dar� um erro de fun��o n�o reconhecida por n�o ser nativa. Sempre antes da fun��o, coloque o nome do esquema da tabela, que nesse caso � dbo que � o esquema padr�o do SQL. Se a fun��o tem par�metros, passa a informa��o separada por v�rgula e entre par�nteses
                                  -- toda query que eu quiser tratar o valor vazio e considerar ele como nulo e simular o isnull, posso usar essa fun��o, a vantagem de criar a fun��o � ganhar em tempo
 from tblnomes

---------------------

-- Tratamento de dados

-- Retirando ( ., -, /) da coluna, execelente a fun��o replace, como aqui � cpf e cnpj, as informa��es possuem mascar� que s�o os caracteres para dar formato nos n�meros

select entidade
     , inscricao_federal
     , replace (inscricao_federal, '.', '') -- replace � uma fun��o nativa do SQL, o primeiro campo � o que quero tratar, o segundo � o caracter que quero substituir e o terceiro � por quem eu quero substituir
 from entidades
where inscricao_federal is not null

select entidade
     , inscricao_federal
     , replace (replace (inscricao_federal, '.', '') , '-', '') -- fun��o aninhada que � uma dentro da outra
 from entidades
where inscricao_federal is not null

select entidade
     , inscricao_federal
     , replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '') -- fun��o aninhada que � uma dentro da outra
 from entidades
where inscricao_federal is not null

select entidade
     , inscricao_federal
     , len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) -- fun��o aninhada que � uma dentro da outra
 from entidades
where inscricao_federal is not null

select entidade
     , inscricao_federal
	 , replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')
     , len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) -- fun��o aninhada que � uma dentro da outra
     , case when len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) = 14
	      then 'pj'
		  when len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) = 11
		  then 'pf'
		  else 'nd'
	   end
 from entidades

-- A query anterior tamb�m pode ser escrita de forma mais resumida quando no case when tiver apenas uma condi��o

select entidade
     , inscricao_federal
	 , replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')
     , len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) -- fun��o aninhada que � uma dentro da outra
     , case len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', ''))
	      when 14
	      then 'pj'
		  when 11
		  then 'pf'
		  else 'nd'
	   end
 from entidades

create function fn_tipo_inscricao (@inscricao_federal varchar (50)) -- esse campo recebe at� 50 caracteres

returns char (2) -- tipo de dado que a fun��o ir� retornar, n�o tem outra possibilidade de retornar mais do que 2 caracteres, por isso foi declarado dessa forma

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
     , len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', '')) -- fun��o aninhada que � uma dentro da outra
     , case len (replace (replace (replace (inscricao_federal, '.', '') , '-', '') , '/', ''))
	      when 14
	      then 'pj'
		  when 11
		  then 'pf'
		  else 'nd'
	   end
	 , dbo.fn_tipo_inscricao (inscricao_federal) -- ao incluir a fun��o personalizada e rodar a query, teremos o retorno das mesmas informa��es do c�digo e da fun��o criada, sempre que precisar da inscri��o federal � s� passar a fun��o que j� ir� funcionar de forma r�pida e pr�tica
 from entidades
 
select entidade
    , inscricao_federal
    , dbo.fn_tipo_inscricao (inscricao_federal)
 from entidades

-- Dentro de uma fun��o � poss�vel usar o select pegando os dados das tabelas mesmo, pode n�o ser o mais indicado mas em alguns cen�rios talvez voc� precise usar
-- Rever a aula 'Fixando a sintaxe das fun��es'

create function fn_tipo_inscricao_ii (@cliente numeric (15)) 

returns char (2) -- tipo de dado que a fun��o ir� retornar, n�o tem outra possibilidade de retornar mais do que 2 caracteres, por isso foi declarado dessa forma

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
    , dbo.fn_tipo_inscricao (inscricao_federal) -- a coluna dbo.fn_tipo_inscricao e a coluna dbo.fn_tipo_inscricao_ii possuem a mesma informa��o por�m foram criadas de maneira diferentes 
	, dbo.fn_tipo_inscricao_ii (entidade)
 from entidades

 ---------------------

 -- Procedure: armazena uma dimens�o na tabela clientes, pode ou n�o receber par�metros, a procedure abaixo retorna informa��es de acordo com o c�digo descrito

create procedure usp_retorna_clientes -- ap�s criar a procedura todo o c�digo abaixo n�o precisa ser digitado, � s� chamar atrav�s da procedure

as

begin -- esse termo begin � obrigat�rio nas fun��es mas n�o � obrigat�rio nas procedures, foi clocado apenas por costume e informa��o

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

 end -- esse termo end � obrigat�rio nas fun��es mas n�o � obrigat�rio nas procedures, foi clocado apenas por costume e informa��o

execute usp_retorna_clientes -- essa � a forma de chamar uma procedure

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

 execute usp_retorna_clientes_parametros 'al' -- ir� retorna s� os dados do estado de Alagoas

---------------------
-- Procedures sem retorno

-- Vamos pegar os dados de uma tabela existente e levar autom�ticamente para uma nova tabela que ser� criada, o objetivo � ter uma tabela consolidadora se informa��es
-- 1� Identifique os campos dessa nova tabela;
-- 2� Crie a tabela;
-- 3� Coloque o tipo de dado que cada coluna ir� receber, ou seja, fa�a a tipagem
-- 4� Popule a tabela

if object_id ('pbs_procfit_dados..tbl_clientes') -- aqui est� informando que a tabela est� dentro do banco de dados pbs_procfit_dados e que ir� procurar a tabela dentro dessa base

select object_id ('tbl_clientes') -- object_id retorna o c�digo da tabela, esse c�digo representa a tabela dentro do database

drop table tbl_clientes -- comando para apagar a tabela, aqui ela deixar� de existir

create table tbl_clientes -- se algu�m apagar a sua tabela, a rotina que foi criada n�o ser� executada, por isso � importante sempre deixar a create table dentro da rotina, para que verifique antes se essa tabela existe ou n�o 
(
   entidade           numeric (15)
 , nome               varchar (80)
 , nome_fantasia      varchar (60)
 , inscricao_federal   varchar (19)
 , classificacao      varchar (80) -- quando criamos um varchar, a informa��o n�o necess�riamente ir� ocupar todos os campos da mem�ria, s� vai ocupar o espa�o que realmente � necess�rio, se eu tenho um valor que ocupar� 10 posi��es ent�o ser� ocupado apenas as 10 posi��es
 , cidade             varchar (80) -- se tem um char de 80 posi��es, independente do tamanho da informa��o, ser� ocupada �s 80 posi��es, sendo assim, sempre coloque a quantidade de posi��es que realmente ser� usada, ou seja, quando voc� sabe exatamente qual informa��o armazenar na tipagem
 , estado             varchar (80)
 , uf                 char    (2)
)

----

if object_id ('pbs_procfit_dados..tbl_clientes') is null -- se os dados retornarem nulos, � porque a tabela n�o existe e � necess�rio criar, sendo assim, sem algu�m excluir a tabela, aqui ser� verificado se ela existe, se n�o existir ser� recriada

begin

create table tbl_clientes -- criando a tabela de clientes consolidado, apenas se ela n�o existir, se algu�m apagar a sua tabela, a rotina que foi criada n�o ser� executada, por isso � importante sempre deixar a create table dentro da rotina, para que verifique antes se essa tabela existe ou n�o 
(
   entidade           numeric (15)
 , nome               varchar (80)
 , nome_fantasia      varchar (60)
 , inscricao_federal  varchar (19)
 , classificacao      varchar (80) -- quando criamos um varchar, a informa��o n�o necess�riamente ir� ocupar todos os campos da mem�ria, s� vai ocupar o espa�o que realmente � necess�rio, se eu tenho um valor que ocupar� 10 posi��es ent�o ser� ocupado as 10 posi��es
 , cidade             varchar (80) -- se tem um char de 80 posi��es, independente do tamanho da informa��o, ser� ocupada �s 80 posi��es, sendo assim, sempre coloque a quantidade de posi��es que realmente ser� usada, ou seja, quando voc� sabe exatamente qual informa��o armazenar na tipagem
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
 from tbl_clientes -- aqui a query est� duplicando as informa��es porque n�o estamos tratando as informa��es da tabela

 drop table tbl_clientes

----
-- Agora ser� feito um insert mais inteligente na tabela, vamos usar a cl�usula merge
-- As procedures aceitam tabelas tempor�rias

create procedure usp_atualiza_clientes_consolidado -- comando para criar a procedure � executado no final

alter procedure usp_atualiza_clientes_consolidado -- comando para alterar/atualizar a procedure

as

if object_id ('pbs_procfit_dados..tbl_clientes') is null -- se os dados retornarem nulos � porque a tabela n�o existe e � necess�rio criar, sendo assim, sem algu�m excluir a tabela, aqui ser� verificado se ela existe, se n�o existir ser� recriada

begin

create table tbl_clientes -- criando a tabela de clientes consolidada, apenas se ela n�o existir, se algu�m apagar a sua tabela, a rotina que foi criada n�o ser� executada, por isso � importante sempre deixar a create table dentro da rotina, para que verifique antes se essa tabela existe ou n�o 
(
   entidade           numeric (15) primary key
 , nome               varchar (80)
 , nome_fantasia      varchar (60)
 , inscricao_federal  varchar (19)
 , classificacao      varchar (80) -- quando criamos um varchar, a informa��o n�o necess�riamente ir� ocupar todos os campos da mem�ria, s� vai ocupar o espa�o que realmente � necess�rio, se eu tenho um valor que ocupar� 10 posi��es ent�o ser� ocupado apenas as 10 posi��es
 , cidade             varchar (80) -- se tem um char de 80 posi��es, independente do tamanho da informa��o, ser� ocupada �s 80 posi��es, sendo assim, sempre coloque a quantidade de posi��es que realmente ser� usada, ou seja, quando voc� sabe exatamente qual informa��o armazenar na tipagem
 , estado             varchar (80)
 , uf                 char    (2)
)

end

if object_id ('tempdb..#dados_integracao') is not null drop table #dados_integracao -- aqui est� apagando caso os dados existam, por isso do is not null

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
 
merge tbl_clientes       d   -- ser� feito um merge na tbl_clientes usando os dados da fonte que ser� a tabela tempor�ria #dados_integracao
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

exec usp_atualiza_clientes_consolidado -- comando para executar e chamar a procedure, aqui ela s� informa quantas linhas foram afetadas mas n�o tr�s nenhum retorno de dados

drop table tbl_clientes -- mesmo ap�s apagar, a procedure ir� criar novamente a tabela com a popula��o dos dados

select * from tbl_clientes

-- Observa��o: o retorno de uma procedure pode popular os dados de uma nova tabela, os c�digos extensos s�o salvos em procedures para n�o serem escritos novamente

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

