-- Insert posicional 
-- Fiz anotações no caderno mostrando quais análises da tabela devem ser feitas antes de fazer o insert, importante conferir.

select nome
	 , entidade
	 , empresa_usuaria
	 , desconto_maximo_pmc
	 , cadastro_ativo
from vendedores

-------
-- 1°

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
-- 2°

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
-- 3° 

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
 , 'n' -- quando específico, o valor é assumido pelo SQL
)

select nome
	 , entidade
	 , empresa_usuaria
	 , desconto_maximo_pmc
	 , cadastro_ativo
from vendedores

-- Insert não mais posicional e sim com instrução select

-- Aqui preciso cadastrar novos vendedores, isso será feito através do select
-- Todas as informações inseridas nesse select serão passadas para o comando insert into vendedores que está logo acima

begin tran

insert into vendedores -- o insert vem primeiro e depois vem o comando select que vai popular as informações, essa é a ordem, caso constrário não funcionará
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

-- regras das condições do case when
-- 2014 para trás 10% de desconto
-- 2015 5% de desconto
-- depois de 2015 0.00 

-- Dentro do SQl existe um controle de transação para insert, delete, update e acontece através do begin transaction, ele fica aguardando a confirmação ou cancelamento da última alteração
-- Não esqueça de fazer rollback ou commit após as transações, se esquecer, a tabela irá bloquear

rollback -- desfaz todo o bloco de operação que foi rodado anteriormente

commit  -- confirma operação rodada anteriormente
-------------------------

-- Update atualiza os dados que já estão salvos no banco de dados
-- Para fazer update é importante primeiramente identificar qual o regristro é único na tabela que é a primary key. Faz um select filtrando pela chave primária e busca apenas os registros que deseja atualizar na tabela, conforme exemplo de select abaixo

select desconto_maximo_pmc -- esse campo que eu quero atualizar com base no filtro do where, ele traz os vendedores 1 e 2 da tabela vendedores
 from vendedores
 where vendedor in (1,2)

begin tran -- por questão de segurança, não esqueça de colocar esse comando para garantir que a alteração ainda passe por aprovação, rode todo o camando begin e também o comando update para funcionar a segurança, se rodar só o update, o begin não funcionará, muito cuidado aqui
update vendedores -- aqui quer dizer, atualize a tabela de vendedores e defina/set o campo desconto_maximo_pc = 100
  set desconto_maximo_pmc = 100
  where vendedor in (1,2) -- se não fizer esse filtro, irá atualizar todos as linhas, com o filtro a atualizão só irá acontecer nas linhas 1 e 2

-- rollback 
-- commit

-- Uma recomendação importante é, monte uma consulta primeiro, depois que tiver certeza do que deseja atualizar, aí sim parta para o update

----------------
select *
  from enderecos
  where cep = '60055-401' -- aqui o endereço é rua teste procfit 

select *
  from cep
 where cep = '60055-401'-- aqui o endereço está correto 'aguanambi'

-- A nível de segurança não esqueça do comando begin transaction antes do comando e de rodar junto

begin transaction
update enderecos -- o SQL vai na tabela enderecos, e irá setar 'aguanambi' quando o cep for '60055-401'. Se não tiver backup antes da alteração, depois não tem como recuperar a versão caso tenha feito algo errado  
   set endereco = 'aguanambi'
where cep = '60055-401'

commit

-- Como montar a consulta, o segredo do SQL é entender a lógica da consulta e montar corretamente a query

select a.cep -- nessa query retornam muitos ceps com novo_endereco e com campos vazios
     , b.cep
	 , a.endereco as endereco_antigo
	 , b.endereco as novo_endereco
 from enderecos a
 join cep       b on a.cep = b.cep

select * -- query confirma que os cep 00000-000 retorna o campo endereço vazio
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

 begin tran -- não esquecer de colocar essa função por questão de segurança
 update enderecos 
    set endereco = b.endereco
	  , cidade   = b.cidade
	from enderecos a
 join cep       b on a.cep = b.cep
 where b.endereco <> '' 

 rollback -- reverte a operação
 commit   -- confirma a operação
 --------------------------
select *
  from vendedores
  where vendedor = 23

-- Nunca faça direto o delete abaixo, aqui você não está vendo o que será apagado, sempre faça a consulta select antes conforme está acima para confirmar o que será apagado

begin tran
delete vendedores -- aqui não se específica a coluna para apagar, deve-se específicar apenas a tabela onde estão os dados e as condições para que aquelas linhas sejam incluídas, o delete é feito na linha
where vendedor = 23

commit

-------------

select a.marca
     , b.produto
  from marcas a
  left join produtos b on a.marca = b.marca
 where b.produto is null

delete from marcas 
 where marca in (574,581,588) -- por ser uma base pequena, é fácil informar as marcas que serão deletadas, em um banco de dados com muitas informações isso seria inviável

-- ou

-- Existem várias formas diferentes de delete que fazem a mesma coisa, tente usar a forma que você se sente confortável ou é mais viável

-- 1° Forma

begin tran
delete  
  from marcas
  from marcas a
  left join produtos b on a.marca = b.marca
  where b.produto is null

-- 2° Forma

begin tran
delete marcas
  from marcas a
  left join produtos b on a.marca = b.marca
 where b.produto is null

-- 3°  Forma

begin tran
delete from marcas -- o comando está apagando da tabela de marcas quando a marca estiver dentro da instrução select, que vai retornar todas as marcas que não tem associação com o produto e for nulo
 where marca in( select a.marca
					 from marcas a
					 left join produtos b on a.marca = b.marca
				    where b.produto is null )

-- 4° Forma

begin tran
delete from marcas  -- apague todas as marcas quando ela não estiver no meu resultado select
 where marca not in( select a.marca
					 from marcas a
					 join produtos b on a.marca = b.marca)

rollback -- reverte a operação
commit   -- confirma a operação

-- Sincronizar todas as entidadaes PF com a tabela de pessoas físicas
-- Sincronizar todas as entidadaes PJ com a tabela de pessoas jurídicas


insert --> Inserir um novo registro: cada registro em uma tabela no banco de dados, nada mais é que uma linha que corresponde a um conjunto de informações que são formadas por colunas, todas colunas de uma tabela formam um registro que é uma linha com informação
update --> Atualizar um registro: aqui podemos estar falando de alguns campos ou de um único campo, sempre montar uma query antes para fazer a validação e conseguir colocar a informação para ser atualizado junto
delete --> Apaga um registro

merge --> É um pouco mais complexo, engloba os 3 comandos, esse normalmente é usado quando tem tabelas e você quer sincronizar as tabelas, ou seja, deixá-las idênticas, tudo que tem em uma, terá na outra. Também inserir um dado quando não tiver, atualizar dado caso tenha e excluir caso não tenha na origem. 

-- Sempre que quero levar as informações de um sistema A para B tenho como possibilidade:

-- 1 --> Apago tudo que está no B, deleto todas as informações e insiro novamente as mesmas
-- 2 --> Outra possibilidade é trabalhar com o merge, não preciso apagar, ele vai avaliar e fazer a associação, vendo se um produto de uma base tem em outra, isso acontece através de um relacionamento. Assim como relacionamentos entre campos que tem a mesma informação, ele mesmo vai saber se faz um insert, update ou delete. Para tabelas grandes, que desejamos fazer sincronismo que não é algo pontual, se é uma tarefa que vai se repetir muito e sempre precisa sincronizar, usa-se o merge

merge tabela_destino d -- é para onde as informações vão
using fonte_dados    o on d.campo_produto = o.campo_produto -- é a fonte de dados, ela pode ser uma tabela, view, tabela temporária, pode ser várias coisas aqui. Aqui vamos atualizar a tabela de destino usando alguma fonte de dados, elas precisam ter uma coluna em comum para fazer o relacionamento, as colunas até podem ter nomes diferentes mas seu conteúdo precisa ter as mesmas informações, é possível relacionar mais colunas da tabela caso seja necessário
                                                            -- diga para o SQL o que precisa fazer quando alguma coisa acontecer          
when matched then                                           -- quando coincidir alguma informação (when matched) faça uma atualização, não precisa colocar mais informações além dessas, pois o merge já entende que é a atualização será feira na primeira tabela que já foi informada (tabela_destino)
             update set campo_a = campo_b                   -- atualize setando o campo da tabela que já foi informado e que será igual ao campo da tabela B 
															
when not matched by target then                             -- tenho outra possibilidade, quando não coincidir, quando tiver os dados na tabela que é a fonte de dados e não tiver na tabela de destino, devo inserir/pegar os dados da tabela fonte de dados e jogar para a tabela destino. Target significa destino, que é a fonte de dados nesse caso, por isso não se escreve o nome da tabela novamente
		 insert (campo_a)                                     
		 value  (campo b)    
		 
when not matched by source delete;                          -- tenho outra possibilidade, quando não coincidir (not matched) na fonte de dados (source), tenho dados na tabela de destino e não tenho na fonte de dados, nesse comando pede-se para apagar os dados na tabela destino, o SQL faz um select na tabela, identifica quais campos estão diferentes e precisam ser apagados das colunas
                                                            -- não precisa usar os 3 comandos, e sim o que for necessário, a sintaxe sempre termina com ;
---------------
-- Sincronizar todas as entidadaes PF com a tabela de pessoas físicas
-- Sincronizar todas as entidadaes PJ com a tabela de pessoas jurídicas

-- Objetivo: sincronizar todas as informações da tabela

select *
 from entidades a
 left join pessoas_fisicas b on a.entidade = b.entidade
 where b.entidade is null -- filtro para saber tudo que tem na tabela entidades e não tem na tabela de pessoas_fisicas

select *
 from entidades a
 left join pessoas_fisicas b on a.entidade = b.entidade
 where b.entidade is null 
   and len (a.inscricao_federal) = 14

select a.entidade as cod_ent
     , b.entidade as cod_pf
	 , a.inscricao_federal
	 , b.inscricao_federal
 from entidades  a -- entidades é a fonte de dados, então tudo que estiver nessa tabela precisa estar na tabela pessoas_fisicas
 full join pessoas_fisicas b on a.entidade = b.entidade
 where len (a.inscricao_federal) = 14

-- Criando uma tabela temporária para armazenar a informação e não trabalhar com a tabela original

begin tran
if object_id('tempdb..#atualizacao') is not null drop table #atualizacao

select a.entidade as cod_ent -- query que associa todas os dados da tabela entidades com a tabela de pessoa_fisica
     , b.entidade as cod_pf
	 , case when a.entidade is not null -- essa etapa é para tratar as informações nulas, para saber se tem que atualizar, incluir ou apagar
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

insert into pessoas_fisicas -- montou o insert com base no select abaixo, a ação é incluir
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

select b.entidade -- irá popular o insert com as informações dessa query, a função é incluir
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
 using #atualizacao_II o on d.entidade = o.entidade -- essa é a tabela origem, ou seja, a fonte
 when matched then -- quando coincidir os campos da tabela, atualizar a informação
      update  set nome                  = o.nome
			    , nome_fantasia         = o.nome_fantasia
				, inscricao_federal     = o.inscricao_federal
			    , inscricao_estadual    = o.inscricao_estadual
				, cadastro_ativo        = o.cadastro_ativo 
				, classificacao_cliente = o.classificacao_cliente

 when not matched by target then -- quando não coincidir os campos da tabela, inserir a informação
 insert -- aqui não precisa referenciar o nome da tabela, pois o SQL já sabe qual é, já referenciamos na query acima
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

when not matched by source then delete; -- quando não tiver na minha origem mas tiver no meu destino
                                        -- **atenção: muito cuidado ao colocar o comando delete, pois irá apagar dados da tabela origem, normalmente o Ítalo não usa ele, só quando está trabalhando com sincronização de tabelas onde sincroniza ela por completo, se tem algum filtro especifico em alguma tabela, já evita usar porque pode dar problema ao apagar os dados
										-- no merge pode-se usar um, dois ou os três comandos (update, insert e delete), o uso é conforme necessidade
-----------------------
-- Desafio final

-- 1°

select * -- consulta que retorna os cnpj das pessoas jurídicas
 from entidades a
 where len (a.inscricao_federal) = 18

-- 2°

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

-- 3°

begin tran
merge pessoas_juridicas d -- d de destino
using ( -- tudo que está aqui dentro do parênteses é como se fosse uma tabela virtual que rodasse essa consulta e armazenasse assim uma tabela virtual, para poder comparar essas informações da mesma forma que é uma subquery e subselect que aprendemos 
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

 ) o on d.entidade = o.entidade -- quando criamos essa consulta, o SQL vai fazer a relação entre as duas fontes de dados da query, e com base nessa relação ele vai saber se vai coincidir a informação (update), se não vai coincidir na origem (delete) ou se não vai coincidir no destino (insert) e dependendo dessas condições você que irá dizer quando cada coisa vai acontecer, os comandos update, insert e delete não são regras, você que coloca a regra

when matched then update
set   nome                   = o.nome
	, nome_fantasia          = o.nome_fantasia 
	, inscricao_federal      = o.inscricao_federal
	, inscricao_estadual     = o.inscricao_estadual
	, cadastro_ativo         = o.cadastro_ativo
	, classificacao_cliente  = o.classificacao_cliente; -- sempre que termina o merge colocar o ; no final, nesse código só estou pedindo para atualizar, os outros comandos ele não irá fazer, pois não especifiquei

-- 4°

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
