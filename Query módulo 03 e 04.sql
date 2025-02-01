Módulo 3

use PBS_PROCFIT_DADOS


select *
from EMPRESAS_USUARIAS

sp_help EMPRESAS_USUARIAS


-- Desafio aula 4, aprendendo a colocar alias
-- ctrl + r oculta e exibe a gride de resultados


select entidade           as cod_cliente
	  ,nome               as nome
      ,inscricao_federal  as cpf_cnpj
      ,ativo              as castrao_ativo
from entidades


-- Operadores aritméticos


+ = adição
- = subtração
* = multiplicação
/ = divisão
% = resto



select 10 + 5 as adicao
select 10 - 5 as subtracao
select 10 * 5 as multiplicacao
select 10 / 5 as divisao
select 10 % 5 as resto
select 10 % 4 as resto_2
select 10.00 / 4.00 as divisao



select produto
	 , quantidade
     , venda_bruta / quantidade as valor_unitario
	 , venda_bruta
 from vendas_analiticas 


select 5 * (4 + 3 ) / 2 */


select *
 from vendas_analiticas
where venda_analitica = 18035 


-- Função aritmética


select venda_bruta
	 , icms_aliquota
	 , venda_bruta * icms_aliquota / 100                 as imposto
	 , venda_bruta - (venda_bruta * icms_aliquota / 100) as lucro_liquido
from vendas_analiticas
where venda_analitica = 18035


-- Desafio aula 6


select produto
     , quantidade
     , valor_unitario
	 , valor_unitario * quantidade as valor_total_produtos
     , icms_aliquota
	 , valor_unitario * quantidade * icms_aliquota / 100 as icms_valor
from nf_faturamento_produtos


-- Operadores de concatenação


-- 1°. forma -> + operador aritmpetico de soma ou operador de concatenação
-- Como o SGD toma a decisão? Conforme a ordem a seguir:

    From
    Where
    Group by
    Having
    Select
    Order by


-- Regra geral: olhar os tipos de dados
-- 1. Passar pelo menos um valor numérico


select 5 + 2   -- o resultado é 7 
select 5 + 't' -- não consegue retornar e exibe um erro
select 5 + '2' -- o resultado é 7, número + varchar, o sistema tenta transforma o varchar em número e dando certo ele soma e não concatena


-- 2. Caso não exista nenhum dado numérico


select 'joao' + ' da silva' -- o resultado é joao da silva, concatena
select '5' + '2'            -- o resultado é 52, varchar + varchar irá concatenar


-- Na prática


select operacao_fiscal + situacao_tributaria 
 from vendas_analiticas


select endereco
     , cidade
	 , estado
	 , cidade + ' - ' + estado
 from enderecos


-- 2°. Forma é utilizar a função nativa concat que é padrão ansi

 
 select concat(5,2)                 -- o resultado é 52
 select concat(5,'t')               -- o resultado é 5t
 select concat(5,'2')               -- o resultado é 52
 select concat('joao',' da silva')  -- o resultado é joao da silva
 select concat('5','2')             -- o resultado é 52


 select endereco
      , cidade
	  , estado
	  , cidade + ' - ' + estado     as operador_mais
	  , concat (cidade, '-', estado) as operador_concat
 from enderecos


-- Evitar concatenar dados usando + quando for tipo numerico + vachar pois não dá certo

-- Desafios aula 10

-- 1° desafio


select *
 from entidades


sp_help entidades


select concat (entidade,nome_fantasia)
  from entidades


-- 2° Desafio


select *
 from produtos


sp_help produtos


select descricao + ' ' + unidade_medida
 from produtos


 -- Order by


select  produto
      , movimento
	  , quantidade
	  , venda_bruta
 from vendas_analiticas
 order by produto asc, venda_bruta desc


 -- Ordenação por posição


select produto
      , movimento
	  , quantidade
	  , venda_bruta
 from vendas_analiticas
 order by 1 asc, 4 desc
 
-- Desafio aula 13


select entidade
	 , inscricao_federal
	 , nome
	 , data_cadastro
 from entidades


select entidade                               as cod_cliente
     , inscricao_federal
	 , concat (inscricao_federal, ' ', nome)  as cliente
	 , nome
	 , data_cadastro
 from entidades


select entidade                                as cod_cliente
	 , concat (inscricao_federal, ' ', nome)   as cliente
	 , nome
	 , data_cadastro
 from entidades
 order by data_cadastro desc


select entidade                                as cod_cliente
	 , concat (inscricao_federal, ' ', nome)   as cliente
	 , data_cadastro
 from entidades
 order by data_cadastro desc


-- Operadores de comparação

 = igual a 
 <> diferente de -- esse é o padrão ansi, usar essa forma
 != diferente de -- usado em alguns banco de dados
 >  maior que
 >= maior ou igual a
 >  menor que
 >= menor ou igual a  

-- Filtro de informações

select *
 from entidades
where ativo ='n' -- vamos saber quem está inativo para recuperar esses clientes
order 
   by entidade


select *
 from entidades
where ativo = 's'
order 
   by entidade


select *
 from entidades
where entidade > 3100 -- começa a partir desse número
order 
   by entidade

select *
 from entidades
where entidade >= 3100 -- aqui já inclui o 3100 na consulta
order 
   by entidade

select *
 from entidades
where entidade <> 1001 
order 
   by entidade

-- Desafio aula 17

-- 1°

select especie_fiscal
	 , documento_numero
	 , vendedor
	 , movimento
	 , produto
	 , quantidade
	 , venda_bruta
  from vendas_analiticas 
 where movimento > '01/06/2020'

select concat (especie_fiscal ,' ', documento_numero)  as documento
	 , vendedor
	 , movimento
	 , produto
	 , quantidade
	 , venda_bruta
  from vendas_analiticas 
 where movimento > '01/06/2020'

select concat (especie_fiscal ,' ', documento_numero)  as documento
	 , vendedor
	 , movimento
	 , produto
	 , quantidade
	 , venda_bruta
  from vendas_analiticas 
 where movimento > '01/06/2020'

select concat (especie_fiscal ,' ', documento_numero)  as documento
	 , vendedor
	 , movimento
	 , produto
	 , quantidade
	 , venda_bruta
	 , venda_bruta / quantidade                        as valor_unitario
  from vendas_analiticas 
 where movimento > '01/06/2020'
 order 
    by movimento asc

-- 2°

select concat (especie_fiscal ,' ', documento_numero)  as documento
	 , vendedor
	 , movimento
	 , produto
	 , quantidade
	 , venda_bruta
	 , venda_bruta / quantidade                        as valor_unitario
  from vendas_analiticas 
 where produto = 34912
 order 
    by quantidade desc

-- Operador like -> é um filtro de campos varchar(texto)
          -- (%) -> independente do que venha
		  -- (_) -> substituição, busca um texto onde não sei parte dele

select cidade
  from enderecos
 where cidade like 'sao paulo' -- se usar apenas o like ele tem a função do =

select cidade
  from enderecos
 where cidade like '%es' -- comando para trazer tudo que termina com o texto informado (%texto)

select cidade
  from enderecos
 where cidade like 'sa%' -- comando para trazer tudo que começa com o texto informado (texto%)

select cidade
  from enderecos
 where cidade like '%sa%' -- comando para trazer tudo que contem o texto informado (%texto%)

select cidade
  from enderecos
 where cidade like 'fo_taleza' -- _comando de substituição, busca um texto onde não sei parte dele e a correspondencia exata

 select cidade
  from enderecos
 where cidade like 's_o paulo' -- quando a palavra tem acento é possível que no banco de dados tenha registros com acento e sem acento, dessa forma usa-se o _ para trazer todos os regitros

select nome
  from entidades
 where nome like 'client__112%' -- é possível usar dois comando juntos _ e %, o espaço também conta na hora de usar o _

 -- like corresnponde ao (=)
 -- not like corresponde ao (<>)

select cidade
  from enderecos
 where cidade not like 'sa%'

-- Desafio aula 21

-- 1°
select cidade
     , estado
  from enderecos
where cidade like 's_o%'

-- 2°

select nome
     , data_cadastro
  from entidades
 where nome not like'%00%'

 -- and (e) -> todas as condições deverão ser obedecidas, usado sempre que for preciso usar mais filtros, é comum usar nas consultas
 -- or  (ou)-> se pelo menos uma das condições forem obedecidas o resultado retornará

and

select ativo
      ,data_cadastro
	  ,inscricao_federal
  from entidades
 where ativo = 's'
   and data_cadastro >= '18/06/2019'
   and inscricao_federal not like '%0001%'
order by data_cadastro desc

or

select *
  from entidades
 where entidade = 1001
    or entidade = 1002
    or entidade = 1003

-- Consultando intervalos usando in e not in, a informação é passada como lista, condições usadas para que o código não fique grande

select *
  from entidades
 where entidade in (1001,1002,1003)

select cidade
     , estado
  from enderecos
 where estado in ('ce', 'sp', 'ba')

 select *
  from entidades
 where entidade not in (1001,1002,1003) -- trás os números exceto esses que foram informados 

select cidade
     , estado
  from enderecos
 where estado not in ('ce', 'sp', 'ba')

-- Desafio aula 25

select cliente
     , quantidade
	 , vendedor
	 , produto
	 , movimento
  from vendas_analiticas
 where cliente in (1876,1422,2249)
   and quantidade > 0
   and vendedor in (4,16)
   and produto in (34726,34304,34394,34593)
order by movimento 

select cliente
     , quantidade
	 , vendedor
	 , produto
	 , movimento
  from vendas_analiticas
 where cliente in (1876,1422,2249)
   and quantidade > 0
   and vendedor in (4,16)
   and produto not in (34726,34304,34394,34593)
order by movimento 

-- between -> operador onde é possível buscar dados entre um intervalo

select entidade
  from entidades
 where entidade between 1001 and 1010

select valor
  from titulos_receber
 where valor between 0.00 and 100.00

select data_cadastro
  from entidades
 where data_cadastro between '01/01/2018' and '31/01/2018'
 order 
    by data_cadastro

-- Desafio aula 29

select movimento
     , entidade
	 , titulo
	 , valor
  from titulos_receber
 where movimento >= '2020' -- também é possível escrever >= '01/01/2020' ou > '31/12/2019'
   and entidade in (1874,2308,1520)
   and titulo like '%/1%'--se ele conter os caracteres /1 deve trazer a informação
   and (valor between 150.00 and 255.23 or valor between 425.57 and 550.12) -- colocar em parênteses para que o sql priorize essa parte do filtro para depois executar as demais
   -- os separadores de casas decimais no sql é o . e não a ,

-- Instrução top limita a quantidade de linhas buscadas no banco de dados
-- Em outros bancos a instrução usada é o limit

select top 100 -- informação da quantidade de linhas
       cliente
	 , produto
	 , quantidade
	 , venda_bruta
from vendas_analiticas
order by venda_bruta desc

select top 100 -- informação da quantidade de linhas
       cliente
	 , produto
	 , quantidade
	 , venda_bruta
from vendas_analiticas
order by quantidade asc

select top 10 percent -- informação do % de todas as linhas da tabela
       cliente
	 , produto
	 , quantidade
	 , venda_bruta
	 , movimento
from vendas_analiticas
where movimento >= '01/01/2020'
order by quantidade asc

-- Retirar valores duplicados (linhas) na consulta usando o comando distinct, ele trará valores únicos

select distinct -- também funciona se colocarmos filtros e outros comandos do sql
       cidade
  from enderecos
 order by cidade

 -- null -> totalmente ausente de informação

   














