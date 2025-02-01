M�dulo 1 

-- Fun��o que tr�s a informa��o da data e hora atual

select GETDATE() as data_atual

select GETDATE() as data_atual_02

select GETDATE() as data_atual_03

M�dulo 2

-- N�meros inteiros

1. bit (0 e 1)                                                       1 byte
2. tinyint (0 a 255)                                                 1 byte por registro
3. smallint ( -32.768 a 32.767)                                      2 byte por registro
4. int (-2.147.483.648 a 2.147.483.647)                              4 byte por registro
5. bigint (-9.223.372.036.854.755.808 a 9.223.372.036.854.775.807)   8 byte por registro

-- Valores monet�rios

1. smallmoney (-214.748,3648 at� 214.748,3647)                    4 bytes
2. money (-922.337.203.685.477,5808 at� 922.337.203.685.477,5807) 8 bytes

-- N�meros com tamanho e precis�o espec�ficos

1.numeric(t,p) (at� 38 d�gitos) 5 at� 17 bytes
*t = tamaho � a quantidade de d�gitos que o n�mero possui
*p = precis�o � a quantidade de casas decimais 
*/

exemplo: numeric(3) 255            -- possui 3 d�gitos
         numeric(5) 25548          -- possui 5 d�gitos
		 numeric(5,2) 25.548,56    -- possui 5 d�gitos com dus casas decimais

-- Valores textuais

1. char ()      (1 at� 800 d�gitos)     1 byte por digito por registro --- usado para textos que tem o tamanho definido e padr�o, exemplo: cpf pois tem 11 d�gitos definidos
2. varchar()    (1 at� 800 d�gitos)     1 byte por digito por registro + 1 byte de leitura
3. varchar(max) (2.140.000.000 d�gitos) 1 byte por digito por registro + 1 byte 

-- exemplo: varchar (60) -- quer dizer que possui 60 caracteres

-- Valores temporais

1.date         (01/01/0001 at� 31/12/9999)                                     
2.datetime     (01/01/1753 00:00:00.000 at� 31/12/9999 23:59:59.999)
3.datetime2 () (01/01/0001 00:00:00.0000000 at� 31/12/9999 23:59:59.99999999)
4.time ()      (00:00:00.0000000 at� 23:59:59.99999999)

-- comando para cria��o de banco de dados

create database curso_sql

-- comando para usar o banco de dados conforme apontado

use curso_sql

-- comando para criar tabela

create table clientes

(
   nome             varchar(60)  
  ,cpf             char(11)     
  ,data_nascimento date      
  ,idade           tinyint
  ,data_cadastro   datetime
  ,ativo           bit
)

-- Colocando not null para que n�o seja permitido ausencia de informa��o no campo, ou seja, sempre ser� necess�rio colocar informa��o no campo.

-- Default � usado para passar a informa��o inicial, posteriormente ela pode mudar.

create table clientes
(

   id               numeric (9)  not null primary key identity(1,1)
  ,nome             varchar(60)  not null
  ,cpf              char(11)     not null
  ,data_nascimento  date         null
  ,idade            tinyint      null
  ,data_cadastro    datetime     not null default (getdate ())
  ,ativo            bit          not null default (1)
  ,limite           numeric(5,2) not null default(0.00)

)

-- comandos com in�cio drop precisam de aten��o pois geralmente s�o para excluir informa��o

drop table clientes

create table clientes
(

   id               numeric (9)  not null primary key identity(1,1)
  ,nome             varchar(60)  not null
  ,cpf              char(11)     not null
  ,data_nascimento  date         null
  ,idade            tinyint      null
  ,data_cadastro    datetime     not null default (getdate ())
  ,ativo            bit          not null default (1)
  ,limite           numeric(5,2) not null default(0.00)

)

---sp_help � um comando muito importante do sql server que mostra todas as informa��es da tabela

sp_help clientes

--- inserindo informa��es nos campos que n�o tem informa��o com default

insert into clientes
(   nome
  , cpf
  , data_nascimento )

values ('italo mesquita vieira', '04438574610', '19/10/1996')

select * 
from clientes

insert into clientes
(   nome
  , cpf
  , data_nascimento
  , limite )

values ('maria julia luna', '25845620118', '07/10/2001', 100.00)

select * 
from clientes

insert into clientes
(   nome
  , cpf
  , data_nascimento
  , idade
  ,limite )

values ('maria leticia', '85214785210', '07/10/2001', '', 150.00)

select * 
from clientes

insert into clientes
(   nome
  , cpf
  , data_nascimento
  , idade
  ,limite )

values ('', '85214785210', '07/10/2001', '', 150.00)

select * 
from clientes

-- chave prim�ria � um �nico campo na tabela, ou seja, n�o se repete
-- chave estrangeira � uma chave prim�ria em outra tabela
-- Forma normal

-- 1.Ter uma chave prim�ria ou pk (abrevia��o)
-- 2.Valores at�micos (valores indivisiveis, que � uma informa��o que pode ficar em uma �nica coluna)
-- 3.N�o ter campos multivalorados que s�o duas informa��es na mesma colunca

drop table clientes

create table clientes
(  id_cliente       int           not null primary key identity (1,1)
  ,nome             varchar(60)   not null
  ,tipo_endere�o    varchar(20)   not null
  ,endere�o         varchar(60)   not null
  ,numero           numeric(5)    not null
  ,bairro           varchar(60)   not null
  ,complemento      varchar(80)   null
  ,cep              char(8)       not null
)

---clientes_telefone

create table cliente_telefones
(
   id_cliente   int references clientes (id_cliente)
  ,ddd         numeric(2)
  ,telefone    numeric(9)
  primary key  (id_cliente, ddd, telefone)
)

sp_help clientes

sp_help cliente_telefones