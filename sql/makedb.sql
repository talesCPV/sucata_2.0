
/* TABELAS */

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

/* FUNCTIONS */

 DROP PROCEDURE IF EXISTS sp_getHash;
DELIMITER $$
	CREATE PROCEDURE sp_getHash(
		IN Iemail varchar(80),
		IN Isenha varchar(30)
    )
	BEGIN    
		SELECT SHA2(CONCAT(Iemail, Isenha), 256) AS HASH;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_allow;
DELIMITER $$
	CREATE PROCEDURE sp_allow(
		IN Iallow varchar(80),
		IN Ihash varchar(64)
    )
	BEGIN    
		SET @access = (SELECT IFNULL(access,-1) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SET @quer =CONCAT('SET @allow = (SELECT ',@access,' IN ',Iallow,');');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
	END $$
DELIMITER ;

/* LOGIN */

 DROP PROCEDURE IF EXISTS sp_login;
DELIMITER $$
	CREATE PROCEDURE sp_login(
		IN Iemail varchar(80),
		IN Isenha varchar(30)
    )
	BEGIN    
		SET @hash = (SELECT SHA2(CONCAT(Iemail, Isenha), 256));
		SELECT *, IF(nome="",SUBSTRING_INDEX(email,"@",1),nome) AS nome FROM tb_usuario WHERE hash=@hash;
	END $$
DELIMITER ;

/* USER */

 DROP PROCEDURE IF EXISTS sp_setUser;
DELIMITER $$
	CREATE PROCEDURE sp_setUser(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid int(11),
		IN Inome varchar(30),
		IN Iemail varchar(80),
		IN Isenha varchar(30),
        IN Iaccess int(11)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iemail="")THEN
				DELETE FROM tb_mail WHERE de=Iid OR para=Iid;
				DELETE FROM tb_user WHERE id=Iid;
            ELSE			
				IF(Iid=0)THEN
					INSERT INTO tb_usuario (email,hash,access,nome)VALUES(Iemail,SHA2(CONCAT(Iemail, Isenha), 256),Iaccess,Inome);
                ELSE
					IF(Isenha="")THEN
						UPDATE tb_usuario SET access=Iaccess, nome=Inome WHERE id=Iid;
                    ELSE
						UPDATE tb_usuario SET email=Iemail, hash=SHA2(CONCAT(Iemail, Isenha), 256), access=Iaccess, nome=Inome WHERE id=Iid;
                    END IF;
                END IF;
            END IF;
            SELECT 1 AS ok;
		ELSE 
			SELECT 0 AS ok;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_viewUser;
DELIMITER $$
	CREATE PROCEDURE sp_viewUser(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT id,email,nome,access, IF(access=0,"ROOT",IFNULL((SELECT nome FROM tb_usr_perm_perfil WHERE USR.access = id),"DESCONHECIDO")) AS perfil FROM tb_usuario AS USR WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
		ELSE 
			SELECT 0 AS id, "" AS email, 0 AS access;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_updateUser;
DELIMITER $$
	CREATE PROCEDURE sp_updateUser(	
		IN Ihash varchar(64),
		IN Inome varchar(30),
        IN Isenha varchar(30)
    )
	BEGIN    
		SET @call_id = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@call_id > 0)THEN
			UPDATE tb_usuario SET hash = SHA2(CONCAT(email, Isenha), 256), nome=Inome WHERE id=@call_id;
            SELECT 1 AS ok;
		ELSE 
			SELECT 0 AS ok;
        END IF;
	END $$
DELIMITER ;

/* PERMISSÂO */

 DROP PROCEDURE IF EXISTS sp_set_usr_perm_perf;
DELIMITER $$
	CREATE PROCEDURE sp_set_usr_perm_perf(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        In Iid int(11),
		IN Inome varchar(30)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN   
			IF(Iid = 0 AND Inome != "")THEN
				INSERT INTO tb_usr_perm_perfil (nome) VALUES (Inome);
            ELSE
				IF(Inome = "")THEN
					DELETE FROM tb_usr_perm_perfil WHERE id=Iid;
				ELSE
					UPDATE tb_usr_perm_perfil SET nome = Inome WHERE id=Iid;
                END IF;
            END IF;			
			SELECT * FROM tb_usr_perm_perfil;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_view_usr_perm_perf;
DELIMITER $$
	CREATE PROCEDURE sp_view_usr_perm_perf(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN   
			SET @quer = CONCAT('SELECT * FROM tb_usr_perm_perfil WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
		ELSE 
			SELECT 0 AS id, "" AS nome;
        END IF;
	END $$
DELIMITER ;

/* CALENDAR */

 DROP PROCEDURE IF EXISTS sp_view_calendar;
DELIMITER $$
	CREATE PROCEDURE sp_view_calendar(	
		IN Ihash varchar(64),
		IN IdataIni date,
		IN IdataFin date
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SELECT * FROM tb_calendario WHERE id_user=@id_call AND data_agd>=IdataIni AND data_agd<=IdataFin;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_calendar;
DELIMITER $$
	CREATE PROCEDURE sp_set_calendar(	
		IN Ihash varchar(64),
		IN Idata date,
		IN Iobs varchar(255)
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
        IF(@id_call >0)THEN
			SET @exist = (SELECT COUNT(*) FROM tb_calendario WHERE id_user=@id_call AND data_agd = Idata);
			IF(@exist AND Iobs = "")THEN
				DELETE FROM tb_calendario WHERE id_user=@id_call AND data_agd = Idata; 
			ELSE
				INSERT INTO tb_calendario (id_user, data_agd, obs) VALUES(@id_call, Idata, Iobs)
                ON DUPLICATE KEY UPDATE obs=Iobs;
			END IF;
        END IF;
	END $$
DELIMITER ;

/* MAIL */

 DROP PROCEDURE IF EXISTS sp_check_usr_mail;
DELIMITER $$
	CREATE PROCEDURE sp_check_usr_mail(
		IN Ihash varchar(64)
    )
	BEGIN
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call>0)THEN        
			SELECT COUNT(*) AS new_mail FROM tb_mail WHERE id_to = @id_call AND looked=0;
		ELSE
			SELECT 0 AS new_mail ;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_mail;
DELIMITER $$
	CREATE PROCEDURE sp_set_mail(	
		IN Ihash varchar(64),
        IN Iid_to int(11),
		IN Imessage varchar(512)
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
        IF(@id_call >0)THEN
			INSERT INTO tb_mail (id_from,id_to,message) VALUES (@id_call,Iid_to,Imessage);
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_view_mail;
DELIMITER $$
	CREATE PROCEDURE sp_view_mail(	
		IN Ihash varchar(64),
        IN Isend boolean
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call > 0)THEN
			IF(Isend)THEN
				SELECT MAIL.*, USR.email AS mail_from
					FROM tb_mail AS MAIL 
					INNER JOIN tb_usuario AS USR
					ON MAIL.id_from = USR.id AND MAIL.id_to = @id_call;            
            ELSE
				SELECT MAIL.*, USR.email AS mail_to
					FROM tb_mail AS MAIL 
					INNER JOIN tb_usuario AS USR
					ON MAIL.id_to = USR.id AND MAIL.id_from = @id_call;            
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_del_mail;
DELIMITER $$
	CREATE PROCEDURE sp_del_mail(	
		IN Ihash varchar(64),
        IN Idata datetime,
        IN Iid_from int(11),
        IN Iid_to int(11)
    )
	BEGIN        
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call = Iid_to OR @id_call = Iid_from)THEN
			DELETE FROM tb_mail WHERE data = Idata AND id_from = Iid_from AND id_to = Iid_to;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_mark_mail;
DELIMITER $$
	CREATE PROCEDURE sp_mark_mail(	
		IN Ihash varchar(64),
        IN Idata datetime,
        IN Iid_from int(11),
        IN Iid_to int(11)
    )
	BEGIN        
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call = Iid_to OR @id_call = Iid_from)THEN
			UPDATE tb_mail SET looked=1 WHERE data = Idata AND id_from = Iid_from AND id_to = Iid_to;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_all_mail_adress;
DELIMITER $$
	CREATE PROCEDURE sp_all_mail_adress(	
		IN Ihash varchar(64)
    )
	BEGIN
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SELECT id,email FROM tb_usuario WHERE id != @id_call ORDER BY email ASC;
	END $$
DELIMITER ;

/* FIM PADRÂO */


