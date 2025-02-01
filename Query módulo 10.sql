-- Insert posicional 
-- Fiz anota��es no caderno mostrando quais an�lises da tabela devem ser feitas antes de fazer o insert, importante conferir.

select nome
	 , entidade
	 , empresa_usuaria
	 , desconto_maximo_pmc
	 , cadastro_ativo
from vendedores

-------
-- 1�

insert into vendedores
(
   nome
 , entidade
 , empresa_usuaria
 , desconto_maximo_pmc
)
values
(
  'italo mesquita'
 , 1
 , 1
 , 0.00
)

select nome
	 , entidade
	 , empresa_usuaria
	 , desconto_maximo_pmc
from vendedores

-----
-- 2�

insert into vendedores
(
   nome
 , entidade
 , empresa_usuaria
 , desconto_maximo_pmc
)
values
(
'vendedor teste'
 , 1002
 , 1
 , 0.00
)

select nome
	 , entidade
	 , empresa_usuaria
	 , desconto_maximo_pmc
from vendedores

-----
-- 3� 

insert into vendedores
(
  nome
, entidade
, empresa_usuaria
, desconto_maximo_pmc
, cadastro_ativo
)
values
(
'vendedor teste 2'
 , 1003
 , 1
 , 0.00
 , 'n' -- quando espec�fico, o valor � assumido pelo SQL
)

select nome
	 , entidade
	 , empresa_usuaria
	 , desconto_maximo_pmc
	 , cadastro_ativo
from vendedores

-- Insert n�o mais posicional e sim com instru��o select

-- Aqui preciso cadastrar novos vendedores, isso ser� feito atrav�s do select
-- Todas as informa��es inseridas nesse select ser�o passadas para o comando insert into vendedores que est� logo acima

begin tran

insert into vendedores -- o insert vem primeiro e depois vem o comando select que vai popular as informa��es, essa � a ordem, caso constr�rio n�o funcionar�
(nome
 , entidade
 , empresa_usuaria
 , desconto_maximo_pmc)

select nome  -- corresponde a coluna nome
     , entidade -- corresponde a coluna entidade 
	 , 1 -- corresponde a coluna empresa_usuaria
	 , case when year (data_cadastro) <= 2014
	        then 10.00
			when year (data_cadastro) = 2015
			then 5.00
			else 0.00
		end as desconto_maximo_pmc -- corresponde a coluna desconto_maximo_pmc
 from entidades
 where entidade between 1004 and 1050

-- regras das condi��es do case when
-- 2014 para tr�s 10% de desconto
-- 2015 5% de desconto
-- depois de 2015 0.00 

-- Dentro do SQl existe um controle de transa��o para insert, delete, update e acontece atrav�s do begin transaction, ele fica aguardando a confirma��o ou cancelamento da �ltima altera��o
-- N�o esque�a de fazer rollback ou commit ap�s as transa��es, se esquecer, a tabela ir� bloquear

rollback -- desfaz todo o bloco de opera��o que foi rodado anteriormente

commit  -- confirma opera��o rodada anteriormente
-------------------------

-- Update atualiza os dados que j� est�o salvos no banco de dados
-- Para fazer update � importante primeiramente identificar qual o regristro � �nico na tabela que � a primary key. Faz um select filtrando pela chave prim�ria e busca apenas os registros que deseja atualizar na tabela, conforme exemplo de select abaixo

select desconto_maximo_pmc -- esse campo que eu quero atualizar com base no filtro do where, ele traz os vendedores 1 e 2 da tabela vendedores
 from vendedores
 where vendedor in (1,2)

begin tran -- por quest�o de seguran�a, n�o esque�a de colocar esse comando para garantir que a altera��o ainda passe por aprova��o, rode todo o camando begin e tamb�m o comando update para funcionar a seguran�a, se rodar s� o update, o begin n�o funcionar�, muito cuidado aqui
update vendedores -- aqui quer dizer, atualize a tabela de vendedores e defina/set o campo desconto_maximo_pc = 100
  set desconto_maximo_pmc = 100
  where vendedor in (1,2) -- se n�o fizer esse filtro, ir� atualizar todos as linhas, com o filtro a atualiz�o s� ir� acontecer nas linhas 1 e 2

-- rollback 
-- commit

-- Uma recomenda��o importante �, monte uma consulta primeiro, depois que tiver certeza do que deseja atualizar, a� sim parta para o update

----------------
select *
  from enderecos
  where cep = '60055-401' -- aqui o endere�o � rua teste procfit 

select *
  from cep
 where cep = '60055-401'-- aqui o endere�o est� correto 'aguanambi'

-- A n�vel de seguran�a n�o esque�a do comando begin transaction antes do comando e de rodar junto

begin transaction
update enderecos -- o SQL vai na tabela enderecos, e ir� setar 'aguanambi' quando o cep for '60055-401'. Se n�o tiver backup antes da altera��o, depois n�o tem como recuperar a vers�o caso tenha feito algo errado  
   set endereco = 'aguanambi'
where cep = '60055-401'

commit

-- Como montar a consulta, o segredo do SQL � entender a l�gica da consulta e montar corretamente a query

select a.cep -- nessa query retornam muitos ceps com novo_endereco e com campos vazios
     , b.cep
	 , a.endereco as endereco_antigo
	 , b.endereco as novo_endereco
 from enderecos a
 join cep       b on a.cep = b.cep

select * -- query confirma que os cep 00000-000 retorna o campo endere�o vazio
  from cep
 where cep = '00000-000'

 -- Vamos tratar esse campo vazio

select a.cep 
     , b.cep
	 , a.endereco as endereco_antigo
	 , b.endereco as novo_endereco
	 , a.cidade   as cidade_antiga
	 , b.cidade   as nova_cidade
 from enderecos a
 join cep       b on a.cep = b.cep
 where b.endereco <> '' -- retornar todos os campos diferente de vazio

 begin tran -- n�o esquecer de colocar essa fun��o por quest�o de seguran�a
 update enderecos 
    set endereco = b.endereco
	  , cidade   = b.cidade
	from enderecos a
 join cep       b on a.cep = b.cep
 where b.endereco <> '' 

 rollback -- reverte a opera��o
 commit   -- confirma a opera��o
 --------------------------
select *
  from vendedores
  where vendedor = 23

-- Nunca fa�a direto o delete abaixo, aqui voc� n�o est� vendo o que ser� apagado, sempre fa�a a consulta select antes conforme est� acima para confirmar o que ser� apagado

begin tran
delete vendedores -- aqui n�o se espec�fica a coluna para apagar, deve-se espec�ficar apenas a tabela onde est�o os dados e as condi��es para que aquelas linhas sejam inclu�das, o delete � feito na linha
where vendedor = 23

commit

-------------

select a.marca
     , b.produto
  from marcas a
  left join produtos b on a.marca = b.marca
 where b.produto is null

delete from marcas 
 where marca in (574,581,588) -- por ser uma base pequena, � f�cil informar as marcas que ser�o deletadas, em um banco de dados com muitas informa��es isso seria invi�vel

-- ou

-- Existem v�rias formas diferentes de delete que fazem a mesma coisa, tente usar a forma que voc� se sente confort�vel ou � mais vi�vel

-- 1� Forma

begin tran
delete  
  from marcas
  from marcas a
  left join produtos b on a.marca = b.marca
  where b.produto is null

-- 2� Forma

begin tran
delete marcas
  from marcas a
  left join produtos b on a.marca = b.marca
 where b.produto is null

-- 3�  Forma

begin tran
delete from marcas -- o comando est� apagando da tabela de marcas quando a marca estiver dentro da instru��o select, que vai retornar todas as marcas que n�o tem associa��o com o produto e for nulo
 where marca in( select a.marca
					 from marcas a
					 left join produtos b on a.marca = b.marca
				    where b.produto is null )

-- 4� Forma

begin tran
delete from marcas  -- apague todas as marcas quando ela n�o estiver no meu resultado select
 where marca not in( select a.marca
					 from marcas a
					 join produtos b on a.marca = b.marca)

rollback -- reverte a opera��o
commit   -- confirma a opera��o

-- Sincronizar todas as entidadaes PF com a tabela de pessoas f�sicas
-- Sincronizar todas as entidadaes PJ com a tabela de pessoas jur�dicas


insert --> Inserir um novo registro: cada registro em uma tabela no banco de dados, nada mais � que uma linha que corresponde a um conjunto de informa��es que s�o formadas por colunas, todas colunas de uma tabela formam um registro que � uma linha com informa��o
update --> Atualizar um registro: aqui podemos estar falando de alguns campos ou de um �nico campo, sempre montar uma query antes para fazer a valida��o e conseguir colocar a informa��o para ser atualizado junto
delete --> Apaga um registro

merge --> � um pouco mais complexo, engloba os 3 comandos, esse normalmente � usado quando tem tabelas e voc� quer sincronizar as tabelas, ou seja, deix�-las id�nticas, tudo que tem em uma, ter� na outra. Tamb�m inserir um dado quando n�o tiver, atualizar dado caso tenha e excluir caso n�o tenha na origem. 

-- Sempre que quero levar as informa��es de um sistema A para B tenho como possibilidade:

-- 1 --> Apago tudo que est� no B, deleto todas as informa��es e insiro novamente as mesmas
-- 2 --> Outra possibilidade � trabalhar com o merge, n�o preciso apagar, ele vai avaliar e fazer a associa��o, vendo se um produto de uma base tem em outra, isso acontece atrav�s de um relacionamento. Assim como relacionamentos entre campos que tem a mesma informa��o, ele mesmo vai saber se faz um insert, update ou delete. Para tabelas grandes, que desejamos fazer sincronismo que n�o � algo pontual, se � uma tarefa que vai se repetir muito e sempre precisa sincronizar, usa-se o merge

merge tabela_destino d -- � para onde as informa��es v�o
using fonte_dados    o on d.campo_produto = o.campo_produto -- � a fonte de dados, ela pode ser uma tabela, view, tabela tempor�ria, pode ser v�rias coisas aqui. Aqui vamos atualizar a tabela de destino usando alguma fonte de dados, elas precisam ter uma coluna em comum para fazer o relacionamento, as colunas at� podem ter nomes diferentes mas seu conte�do precisa ter as mesmas informa��es, � poss�vel relacionar mais colunas da tabela caso seja necess�rio
                                                            -- diga para o SQL o que precisa fazer quando alguma coisa acontecer          
when matched then                                           -- quando coincidir alguma informa��o (when matched) fa�a uma atualiza��o, n�o precisa colocar mais informa��es al�m dessas, pois o merge j� entende que � a atualiza��o ser� feira na primeira tabela que j� foi informada (tabela_destino)
             update set campo_a = campo_b                   -- atualize setando o campo da tabela que j� foi informado e que ser� igual ao campo da tabela B 
															
when not matched by target then                             -- tenho outra possibilidade, quando n�o coincidir, quando tiver os dados na tabela que � a fonte de dados e n�o tiver na tabela de destino, devo inserir/pegar os dados da tabela fonte de dados e jogar para a tabela destino. Target significa destino, que � a fonte de dados nesse caso, por isso n�o se escreve o nome da tabela novamente
		 insert (campo_a)                                     
		 value  (campo b)    
		 
when not matched by source delete;                          -- tenho outra possibilidade, quando n�o coincidir (not matched) na fonte de dados (source), tenho dados na tabela de destino e n�o tenho na fonte de dados, nesse comando pede-se para apagar os dados na tabela destino, o SQL faz um select na tabela, identifica quais campos est�o diferentes e precisam ser apagados das colunas
                                                            -- n�o precisa usar os 3 comandos, e sim o que for necess�rio, a sintaxe sempre termina com ;
---------------
-- Sincronizar todas as entidadaes PF com a tabela de pessoas f�sicas
-- Sincronizar todas as entidadaes PJ com a tabela de pessoas jur�dicas

-- Objetivo: sincronizar todas as informa��es da tabela

select *
 from entidades a
 left join pessoas_fisicas b on a.entidade = b.entidade
 where b.entidade is null -- filtro para saber tudo que tem na tabela entidades e n�o tem na tabela de pessoas_fisicas

select *
 from entidades a
 left join pessoas_fisicas b on a.entidade = b.entidade
 where b.entidade is null 
   and len (a.inscricao_federal) = 14

select a.entidade as cod_ent
     , b.entidade as cod_pf
	 , a.inscricao_federal
	 , b.inscricao_federal
 from entidades  a -- entidades � a fonte de dados, ent�o tudo que estiver nessa tabela precisa estar na tabela pessoas_fisicas
 full join pessoas_fisicas b on a.entidade = b.entidade
 where len (a.inscricao_federal) = 14

-- Criando uma tabela tempor�ria para armazenar a informa��o e n�o trabalhar com a tabela original

begin tran
if object_id('tempdb..#atualizacao') is not null drop table #atualizacao

select a.entidade as cod_ent -- query que associa todas os dados da tabela entidades com a tabela de pessoa_fisica
     , b.entidade as cod_pf
	 , case when a.entidade is not null -- essa etapa � para tratar as informa��es nulas, para saber se tem que atualizar, incluir ou apagar
	         and b.entidade is not null
			then 'atualizar'
			when b.entidade is null
			then 'incluir'
			else 'apagar'
		end as acao
 into #atualizacao
 from entidades  a
 full join pessoas_fisicas b on a.entidade = b.entidade
 where len (a.inscricao_federal) = 14

insert into pessoas_fisicas -- montou o insert com base no select abaixo, a a��o � incluir
( 
   entidade
 , nome
 , nome_fantasia
 , inscricao_federal
 , inscricao_estadual
 , data_hora_inclusao
 , cadastro_ativo
 , classificacao_cliente
 , data_cadastro
)

select b.entidade -- ir� popular o insert com as informa��es dessa query, a fun��o � incluir
     , b.nome
	 , b.nome_fantasia
	 , b.inscricao_federal
	 , b.inscricao_estadual
	 , getdate() as data_hora_inclusao
	 , isnull (b.ativo, 's')
	 , b.classificacao_cliente
	 , b.data_cadastro
 from #atualizacao a
 join entidades    b on a.cod_ent = b.entidade
 where acao = 'incluir'

update pessoas_fisicas
   set nome                  = b.nome
     , nome_fantasia         = b.nome_fantasia
	 , inscricao_federal     = b.inscricao_federal
	 , inscricao_estadual    = b.inscricao_estadual
	 , cadastro_ativo        = isnull (b.ativo, 's')
	 , classificacao_cliente = b.classificacao_cliente

 from #atualizacao a
 join entidades    b on a.cod_ent = b.entidade
 where acao = 'atualizar'

 rollback

 delete from pessoas_fisicas
        from pessoas_fisicas a
		join #atualizacao a on a.entidade = b.cod_pf
		where acao = 'apagar'
------------------------------
-- Trabalhando com merge

if object_id ('tempdb..#atualizacao_II') is not null drop table #atualizacao_II

select entidade 
     , nome
	 , nome_fantasia
	 , inscricao_federal
	 , inscricao_estadual
	 , getdate() as data_hora_inclusao
	 , isnull (ativo, 's') as cadastro_ativo
	 , classificacao_cliente
	 , data_cadastro
 into #atualizacao_II
 from entidades a
 where len (a.inscricao_federal) = 14

 begin tran
 merge pessoas_fisicas d -- tabela de destino
 using #atualizacao_II o on d.entidade = o.entidade -- essa � a tabela origem, ou seja, a fonte
 when matched then -- quando coincidir os campos da tabela, atualizar a informa��o
      update  set nome                  = o.nome
			    , nome_fantasia         = o.nome_fantasia
				, inscricao_federal     = o.inscricao_federal
			    , inscricao_estadual    = o.inscricao_estadual
				, cadastro_ativo        = o.cadastro_ativo 
				, classificacao_cliente = o.classificacao_cliente

 when not matched by target then -- quando n�o coincidir os campos da tabela, inserir a informa��o
 insert -- aqui n�o precisa referenciar o nome da tabela, pois o SQL j� sabe qual �, j� referenciamos na query acima
		( 
		  entidade
		, nome
		, nome_fantasia
		, inscricao_federal
		, inscricao_estadual
		, data_hora_inclusao
		, cadastro_ativo
		, classificacao_cliente
		, data_cadastro
		)

		values (

	     o.entidade
	   , o.nome
	   , o.nome_fantasia
	   , o.inscricao_federal
	   , o.inscricao_estadual
	   , o.data_hora_inclusao
	   , o.cadastro_ativo 
	   , o.classificacao_cliente
	   , data_cadastro
	   )

when not matched by source then delete; -- quando n�o tiver na minha origem mas tiver no meu destino
                                        -- **aten��o: muito cuidado ao colocar o comando delete, pois ir� apagar dados da tabela origem, normalmente o �talo n�o usa ele, s� quando est� trabalhando com sincroniza��o de tabelas onde sincroniza ela por completo, se tem algum filtro especifico em alguma tabela, j� evita usar porque pode dar problema ao apagar os dados
										-- no merge pode-se usar um, dois ou os tr�s comandos (update, insert e delete), o uso � conforme necessidade
-----------------------
-- Desafio final

-- 1�

select * -- consulta que retorna os cnpj das pessoas jur�dicas
 from entidades a
 where len (a.inscricao_federal) = 18

-- 2�

select entidade 
     , nome
	 , nome_fantasia
	 , inscricao_federal
	 , inscricao_estadual
	 , getdate() as data_hora_inclusao
	 , isnull (ativo, 's') as cadastro_ativo
	 , classificacao_cliente
	 , data_cadastro
 from entidades a
 where len (a.inscricao_federal) = 18

-- 3�

begin tran
merge pessoas_juridicas d -- d de destino
using ( -- tudo que est� aqui dentro do par�nteses � como se fosse uma tabela virtual que rodasse essa consulta e armazenasse assim uma tabela virtual, para poder comparar essas informa��es da mesma forma que � uma subquery e subselect que aprendemos 
select entidade 
     , nome
	 , nome_fantasia
	 , inscricao_federal
	 , inscricao_estadual
	 , getdate() as data_hora_inclusao
	 , isnull (ativo, 's') as cadastro_ativo
	 , classificacao_cliente
	 , data_cadastro
 from entidades a
 where len (a.inscricao_federal) = 18

 ) o on d.entidade = o.entidade -- quando criamos essa consulta, o SQL vai fazer a rela��o entre as duas fontes de dados da query, e com base nessa rela��o ele vai saber se vai coincidir a informa��o (update), se n�o vai coincidir na origem (delete) ou se n�o vai coincidir no destino (insert) e dependendo dessas condi��es voc� que ir� dizer quando cada coisa vai acontecer, os comandos update, insert e delete n�o s�o regras, voc� que coloca a regra

when matched then update
set   nome                   = o.nome
	, nome_fantasia          = o.nome_fantasia 
	, inscricao_federal      = o.inscricao_federal
	, inscricao_estadual     = o.inscricao_estadual
	, cadastro_ativo         = o.cadastro_ativo
	, classificacao_cliente  = o.classificacao_cliente; -- sempre que termina o merge colocar o ; no final, nesse c�digo s� estou pedindo para atualizar, os outros comandos ele n�o ir� fazer, pois n�o especifiquei

-- 4�

begin tran
merge pessoas_juridicas d -- d de destino
using (
select entidade 
     , nome
	 , nome_fantasia
	 , inscricao_federal
	 , inscricao_estadual
	 , getdate() as data_hora_inclusao
	 , isnull (ativo, 's') as cadastro_ativo
	 , classificacao_cliente
	 , data_cadastro
	 , 's' as empresa_nacional
 from entidades a
 where len (a.inscricao_federal) = 18

 ) o on d.entidade = o.entidade 

when matched then update
set   nome                   = o.nome
	, nome_fantasia          = o.nome_fantasia 
	, inscricao_federal      = o.inscricao_federal
	, inscricao_estadual     = o.inscricao_estadual
	, cadastro_ativo         = o.cadastro_ativo
	, classificacao_cliente  = o.classificacao_cliente
	, empresa_nacional       = o.empresa_nacional 

when not matched by target then 
insert (
		  entidade
		, nome
		, nome_fantasia
		, inscricao_federal
		, inscricao_estadual
		, data_hora_inclusao
		, cadastro_ativo
		, classificacao_cliente
		, data_cadastro
		, empresa_nacional 
		)

		values (

	     o.entidade
	   , o.nome
	   , o.nome_fantasia
	   , o.inscricao_federal
	   , o.inscricao_estadual
	   , o.data_hora_inclusao
	   , o.cadastro_ativo 
	   , o.classificacao_cliente
	   , data_cadastro
	   , o.empresa_nacional 
	   )

when not matched by source then delete;
