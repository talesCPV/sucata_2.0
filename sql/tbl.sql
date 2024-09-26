* TABELAS */

 DROP TABLE IF EXISTS tb_usuario;
CREATE TABLE tb_usuario (
    id int(11) NOT NULL AUTO_INCREMENT,
    email varchar(70) NOT NULL,
    hash varchar(64) NOT NULL,
    nome varchar(30) NOT NULL DEFAULT "",
    token varchar(64) DEFAULT NULL,
    access int(11) DEFAULT -1,
	UNIQUE KEY (hash),
	UNIQUE KEY (email),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 INSERT INTO tb_usuario (email,hash,access,nome)VALUES("admin@planet3.com.br","af67057179cb1e8fbefdfb19411dccb7b472afc2ff6884d5f5b9a9eec717d239",0,"Developer");
-- usuario: admin@planet3.com.br
-- senha: 123456

 DROP TABLE IF EXISTS tb_usr_perm_perfil;
CREATE TABLE tb_usr_perm_perfil (
    id int(11) NOT NULL AUTO_INCREMENT,
    nome varchar(30) NOT NULL,
    perm varchar(50) NOT NULL DEFAULT "0",
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_mail;
CREATE TABLE tb_mail (
	data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    id_from int(11) NOT NULL,
    id_to int(11) NOT NULL,
    message varchar(1000),
    looked boolean DEFAULT 0,
    FOREIGN KEY (id_from) REFERENCES tb_usuario(id),
    FOREIGN KEY (id_to) REFERENCES tb_usuario(id),
    PRIMARY KEY (data,id_from)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_calendario;
CREATE TABLE tb_calendario (
    id_user int(11) NOT NULL,
    data_agd date NOT NULL,
    obs varchar(255),
    PRIMARY KEY (id_user,data_agd)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

/* FIM PADRÃO */

DROP TABLE IF EXISTS tb_banco;
CREATE TABLE tb_banco (
  id int(11) NOT NULL AUTO_INCREMENT,
  banco varchar(50) NOT NULL,
  bco_ag varchar(6) DEFAULT NULL,
  bco_cc varchar(15) DEFAULT NULL,
  bco_pix varchar(40) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_prod;
CREATE TABLE tb_prod (
  id int(11) NOT NULL AUTO_INCREMENT,
  nome varchar(20) NOT NULL,
  und varchar(10) NOT NULL,
  preco double NOT NULL DEFAULT '0',
  margem double NOT NULL DEFAULT '100',
  id_mat int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (id),
  KEY id_mat (id_mat)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_clientes;
CREATE TABLE tb_clientes (
  id int(11) NOT NULL AUTO_INCREMENT,
  nome varchar(50) NOT NULL,
  fantasia varchar(40) DEFAULT NULL,
  tipo varchar(3) DEFAULT NULL,
  cnpj_cpf varchar(18) DEFAULT NULL,
  ie varchar(15) DEFAULT NULL,
  im varchar(15) DEFAULT NULL,
  endereco varchar(60) DEFAULT NULL,
  num varchar(6) DEFAULT NULL,
  bairro varchar(50) DEFAULT NULL,
  cep varchar(10) DEFAULT NULL,
  cidade varchar(30) DEFAULT NULL,
  estado varchar(2) DEFAULT NULL,
  tel varchar(15) DEFAULT NULL,
  bco_nome varchar(15) DEFAULT NULL,
  bco_ag varchar(6) DEFAULT NULL,
  bco_cc varchar(15) DEFAULT NULL,
  bco_pix varchar(40) DEFAULT NULL,
  saldo double NOT NULL DEFAULT '0',
  modal varchar(5) DEFAULT 'FORN',
  whatsapp varchar(15) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (nome)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_local;
CREATE TABLE tb_local (
  id int(11) NOT NULL AUTO_INCREMENT,
  ano varchar(4) NOT NULL,
  modelo varchar(20) NOT NULL,
  placa varchar(8) NOT NULL,
  tipo varchar(10) DEFAULT 'CAMINHÃO',
  tara double NOT NULL DEFAULT '0',
  local varchar(5) DEFAULT 'FIXO',
  PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_compra;
CREATE TABLE tb_compra (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_cliente int(11) NOT NULL,
  id_resp int(11) NOT NULL,
  status varchar(10) NOT NULL DEFAULT 'FECHADO',
  obs varchar(255) DEFAULT NULL,
  data datetime DEFAULT CURRENT_TIMESTAMP,
  id_local int(11) NOT NULL DEFAULT '3',
  PRIMARY KEY (id),
  FOREIGN KEY (id_cliente) REFERENCES tb_clientes(id),
  FOREIGN KEY (id_resp) REFERENCES tb_usuario(id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_item_compra;
CREATE TABLE tb_item_compra (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_compra int(11) NOT NULL,
  id_prod int(11) NOT NULL,
  qtd double unsigned DEFAULT '0',
  und varchar(10) NOT NULL,
  val_unit double NOT NULL DEFAULT '0',
  estorno double DEFAULT '0',
  id_local_origem int(11) DEFAULT '0',
  PRIMARY KEY (id),
  FOREIGN KEY (id_compra) REFERENCES tb_compra(id),
  FOREIGN KEY (id_prod) REFERENCES tb_prod(id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_venda;
CREATE TABLE tb_venda (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_cliente int(11) NOT NULL,
  id_resp int(11) NOT NULL,
  status varchar(10) NOT NULL DEFAULT 'ABERTO',
  obs varchar(255) DEFAULT NULL,
  data datetime DEFAULT CURRENT_TIMESTAMP,
  id_local int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  FOREIGN KEY (id_cliente) REFERENCES tb_clientes(id),
  FOREIGN KEY (id_resp) REFERENCES tb_usuario(id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_item_venda;
CREATE TABLE tb_item_venda (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_venda int(11) NOT NULL,
  id_prod int(11) NOT NULL,
  qtd double unsigned DEFAULT '0',
  und varchar(10) NOT NULL,
  val_unit double NOT NULL DEFAULT '0',
  estorno double DEFAULT '0',
  id_local_origem double DEFAULT '0',
  PRIMARY KEY (id),
  FOREIGN KEY (id_venda) REFERENCES tb_venda(id),
  FOREIGN KEY (id_prod) REFERENCES tb_prod(id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_item_estoque;
CREATE TABLE tb_item_estoque (
  id_local int(11) NOT NULL,
  id_prod int(11) NOT NULL,
  qtd double unsigned DEFAULT '0',
  und varchar(10) NOT NULL,
  val_unit double NOT NULL DEFAULT '0',
  PRIMARY KEY (id_local,id_prod),
  FOREIGN KEY (id_prod) REFERENCES tb_prod(id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_item_temp;
CREATE TABLE tb_item_temp (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_local int(11) NOT NULL,
  id_prod int(11) NOT NULL,
  nome varchar(20) NOT NULL,
  qtd double unsigned DEFAULT '0',
  und varchar(10) NOT NULL,
  val_venda double NOT NULL DEFAULT '0',
  id_item_compra int(11) DEFAULT '0',
  qtd_orig double DEFAULT '0',
  PRIMARY KEY (id),
  FOREIGN KEY (id_local) REFERENCES tb_local(id),
  FOREIGN KEY (id_prod) REFERENCES tb_prod(id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS tb_lanc_bancario;
CREATE TABLE tb_lanc_bancario (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_banco int(11) NOT NULL,
  id_cliente int(11) NOT NULL,
  data datetime NOT NULL,
  valor double NOT NULL,
  forma varchar(10) DEFAULT NULL,
  ref varchar(40) DEFAULT NULL,
  obs varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_banco) REFERENCES tb_banco(id),
  FOREIGN KEY (id_cliente) REFERENCES tb_clientes(id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_material;
CREATE TABLE tb_material (
  id int(11) NOT NULL AUTO_INCREMENT,
  nome varchar(20) NOT NULL,
  cod varchar(20) DEFAULT NULL,
  ncm varchar(8) DEFAULT '',
  und varchar(10) DEFAULT 'KG',
  PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_motorista;
CREATE TABLE tb_motorista (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_usuario int(11) DEFAULT NULL,
  id_local int(11) DEFAULT NULL,
  nome varchar(40) NOT NULL DEFAULT '',
  cpf varchar(14) NOT NULL DEFAULT '',
  rg varchar(12) NOT NULL DEFAULT '',
  cnh varchar(12) NOT NULL DEFAULT '',
  tipo varchar(2) NOT NULL DEFAULT '',
  validade date DEFAULT NULL,
  limite tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
  FOREIGN KEY (id_local) REFERENCES tb_local(id)  
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_saldo;
CREATE TABLE tb_saldo (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_cliente int(11) NOT NULL,
  data datetime DEFAULT CURRENT_TIMESTAMP,
  valor double NOT NULL DEFAULT '0',
  tipo varchar(7) NOT NULL DEFAULT 'PAGAR',
  quitado tinyint(1) DEFAULT '0',
  obs varchar(255) NOT NULL DEFAULT '',
  id_origem int(11) NOT NULL,
  tb_origem varchar(10) NOT NULL DEFAULT 'tb_compra',
  PRIMARY KEY (id),
  FOREIGN KEY (id_cliente) REFERENCES tb_clientes(id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_und;
CREATE TABLE tb_und (
  id int(11) NOT NULL AUTO_INCREMENT,
  nome varchar(20) NOT NULL,
  sigla varchar(10) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS tb_viagem;
CREATE TABLE tb_viagem (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_motorista int(11) NOT NULL,
  id_veiculo int(11) NOT NULL,
  data datetime DEFAULT CURRENT_TIMESTAMP,
  aberta tinyint(1) DEFAULT '1',
  obs varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_motorista) REFERENCES tb_motorista(id),
  FOREIGN KEY (id_veiculo) REFERENCES tb_local(id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

/* FIM TABELAS */