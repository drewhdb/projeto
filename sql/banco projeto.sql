DROP DATABASE IF EXISTS projeto;
CREATE DATABASE projeto;
USE projeto;

-- Tabela de usuários para acesso ao sistema
CREATE TABLE usr (
    usrid INT PRIMARY KEY AUTO_INCREMENT,
    usrnome VARCHAR(30),
    usrsenha VARCHAR(20),
    usrcriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usrativo INT DEFAULT 1
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO usr (usrnome, usrsenha) VALUES ('Andrew', 'senha'), ('Luan', 'senha'), ('Braian', 'senha');

-- Tabela de categorias dos módulos
CREATE TABLE ctm (
    ctmid INT PRIMARY KEY AUTO_INCREMENT,
    ctmdesc VARCHAR(10) NOT NULL,
    ctmsubmdl DECIMAL(1,0) DEFAULT 0,
    ctmalexa DECIMAL(1,0) DEFAULT 0
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Tabela de categorias dos módulos
INSERT INTO ctm (ctmdesc) VALUES ('ERP'), ('WHATSAPP');
INSERT INTO ctm (ctmdesc, ctmsubmdl) VALUES ('SUB-MODULO', 1);
INSERT INTO ctm (ctmdesc, ctmalexa) VALUES ('ALEXA', 1);

-- Tabela de módulos
CREATE TABLE mdl (
    mdlmodulo VARCHAR(20) PRIMARY KEY,
    mldesc VARCHAR(100),
    mdlcategoria INT,
    CONSTRAINT fk_mod_ctm FOREIGN KEY (mdlcategoria) REFERENCES ctm (ctmid)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO mdl (mdlmodulo, mldesc, mdlcategoria) VALUES ('GESTÃO', 'sistema ERP de vendas', '1'),
    ('PLACE', 'sistema ERP de vendas', '1'),
    ('MEMO', 'sistema ERP de vendas', '1'),
    ('PV', 'sistema ERP de vendas', '1'),
    ('WHATSAPP', 'automação whatsapp', '2'),
    ('OUTDOOR', 'GESTÃO PARA TABLET', '3'),
    ('ORYXNFE', 'PLACE PARA CELULAR', '3'),
    ('BI', 'Gráficos de dados', '3'),
    ('GERTEC', 'LEITURA DE CÓDIGO DE BARRA PARA OS CLIENTES DOS CLIENTES', '3'),
    ('ALEXA', 'integração Alexa', '4'),
    ('TEF', 'integração Alexa', '3');

-- DO SUPPORT
CREATE TABLE ver (
  verversao INT AUTO_INCREMENT,
  vermodulo INT,
  vernome CHAR(15) DEFAULT '',
  verliberac DATETIME DEFAULT '1899-12-30 00:00:00',
  vervalidad DATETIME DEFAULT '1899-12-30 00:00:00',
  CONSTRAINT fk_ver PRIMARY KEY (verversao, vermodulo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Tabela de clientes principais
CREATE TABLE cl1 (
    cl1cliente INT PRIMARY KEY AUTO_INCREMENT,
    cl1nome VARCHAR(50)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Tabela de tipos de estabelecimentos
CREATE TABLE cl4 (
    cl4tipo INT PRIMARY KEY AUTO_INCREMENT,
    cl4desc VARCHAR(20) NOT NULL
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO cl4 (cl4desc) VALUES ('Fabrica'), ('Loja'), ('Matriz');

-- Tabela de shoppings
CREATE TABLE cl5 (
    cl5shopping INT PRIMARY KEY AUTO_INCREMENT,
    cl5apelido VARCHAR(10) DEFAULT '',
    cl5desc VARCHAR(40) NOT NULL,
    cl5atacado INT DEFAULT 0,
    cl5local VARCHAR(30) DEFAULT '',
    cl5integra VARCHAR(30) DEFAULT ''
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO cl5 (cl5apelido, cl5desc, cl5local, cl5atacado, cl5integra) VALUES
('CCF', 'Centro de Compras Farroupilha', 'Farroupilha - RS', 0, ''),
('FAC', 'Farroupilhas center', 'Farroupilha - RS', 1, ''),
('585', '', 'Farroupilha - RS', 1, ''),
('GOLDEN', 'Golden Center', 'Farroupilha - RS', 1, 'Ezetech'),
('CCB', 'Centro de Compras Bom Principio', 'Bom Principio - RS', 0, ''),
('LITORAL', 'Shopping Litoral', 'Litoral - SC', 0, 'ibasi'),
('BRUSQUE', '', 'Brusque - SC', 0, 'ibasi');

-- Tabela de estabelecimentos, matriz ou filiais de um cliente
CREATE TABLE cl2 (
    cl2est INT PRIMARY KEY AUTO_INCREMENT,
    cl2cliente INT,
    cl2nome VARCHAR(50) NOT NULL,
    cl2tipoest INT,
    cl2shopping INT,
    cl2cnpj VARCHAR(18) DEFAULT '',
    cl2gerente VARCHAR(50) DEFAULT '',
    cl2ctt VARCHAR(15) DEFAULT '',
    cl2fim TIMESTAMP,
    cl2inicio TIMESTAMP,
    cl2pais VARCHAR(50) NOT NULL default 'Brasil',
    cl2estado VARCHAR(2) NOT NULL,
    cl2cidade VARCHAR(50) NOT NULL,
    cl2obs LONGTEXT,
    cl2acesso LONGTEXT,
    cl2ender LONGTEXT,
    CONSTRAINT fk_cl2_cl1 FOREIGN KEY (cl2cliente) REFERENCES cl1 (cl1cliente),
    CONSTRAINT fk_cl2_cl4 FOREIGN KEY (cl2tipoest) REFERENCES cl4 (cl4tipo),
    CONSTRAINT fk_cl2_cl5 FOREIGN KEY (cl2shopping) REFERENCES cl5 (cl5shopping)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Tabela de módulos e versões dos estabelecimentos dos clientes
CREATE TABLE cl3 (
    cl3est INT,
    cl3modulo VARCHAR(20),
    cl3versao INT(11) NOT NULL,
    cl3atualiz VARCHAR(10) DEFAULT '',
    cl3respatt INT DEFAULT NULL,
    cl3resp INT NOT NULL,
    PRIMARY KEY (cl3est, cl3modulo),
    CONSTRAINT fk_cl3_cl2 FOREIGN KEY (cl3est) REFERENCES cl2 (cl2est),
    CONSTRAINT fk_cl3_mdl FOREIGN KEY (cl3modulo) REFERENCES mdl (mdlmodulo),
    CONSTRAINT fk_cl3_ver FOREIGN KEY (cl3versao) REFERENCES ver (verversao),
    CONSTRAINT fk_cl3_responsavel FOREIGN KEY (cl3resp) REFERENCES usr (usrid),
    CONSTRAINT fk_cl3_responsavel_atualizacao FOREIGN KEY (cl3respatt) REFERENCES usr (usrid)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- histórico do cliente
CREATE TABLE cl6 (
    cl6id INT PRIMARY KEY AUTO_INCREMENT,
    cl6est INT,
    cl6desc VARCHAR(50),
    cl6data DATETIME,
    cl6resp INT,
    CONSTRAINT fk_cl6_responsavel FOREIGN KEY (cl6resp) REFERENCES usr (usrid),
    CONSTRAINT fk_cl6_cl2 FOREIGN KEY (cl6est) REFERENCES cl2 (cl2est)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Tabela de anotações
CREATE TABLE nta (
    ntaid INT PRIMARY KEY AUTO_INCREMENT,
    ntatitulo VARCHAR(20) NOT NULL,
    tnaintro VARCHAR(60) DEFAULT '',
    ntaconteudo LONGTEXT,
    ntacriador INT NOT NULL,
    ntacriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ntalink DECIMAL(1,0) DEFAULT 0,
    ntalinkdir VARCHAR(250) DEFAULT '#',
    CONSTRAINT fk_nta_criador FOREIGN KEY (ntacriador) REFERENCES usr (usrid)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;
