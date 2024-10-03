
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

/* SUCATA */

/* EMPRESAS */

 DROP PROCEDURE IF EXISTS sp_view_emp;
DELIMITER $$
	CREATE PROCEDURE sp_view_emp(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT * FROM tb_clientes WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_emp;
DELIMITER $$
	CREATE PROCEDURE sp_set_emp(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
        IN Inome varchar(50),
		IN Ifantasia varchar(40),
		IN Itipo varchar(3),
		IN Icnpj_cpf varchar(18),
		IN Iie varchar(15),
		IN Iim varchar(15),
		IN Iend varchar(60),
		IN Inum varchar(6),
		IN Ibairro varchar(50),
		IN Icep varchar(10),
		IN Icidade varchar(30),
		IN Iuf varchar(2),
		IN Itel varchar(15),
		IN Ibco_nome varchar(15),
		IN Ibco_ag varchar(6),
		IN Ibco_cc varchar(15),
		IN Ibco_pix varchar(40),
		IN Imodal varchar(5),
		IN Iwhatsapp varchar(15)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Inome="")THEN
				DELETE FROM tb_clientes WHERE id=Iid;
            ELSE
				IF(Iid=0)THEN
					INSERT INTO tb_clientes (nome,fantasia,tipo,cnpj_cpf,ie,im,endereco,num,bairro,cep,cidade,estado,tel,bco_nome,bco_ag,bco_cc,bco_pix,modal,whatsapp) 
					VALUES (Inome,Ifantasia,Itipo,Icnpj_cpf,Iie,Iim,Iend,Inum,Ibairro,Icep,Icidade,Iuf,Itel,Ibco_nome,Ibco_ag,Ibco_cc,Ibco_pix,Imodal,Iwhatsapp);
                ELSE
					UPDATE tb_clientes 
                    SET nome=Inome,fantasia=Ifantasia,tipo=Itipo, cnpj_cpf=Icnpj_cpf, ie=Iie, im=Iim, endereco=Iend,
                    num=Inum, bairro=Ibairro, cep=Icep, cidade=Icidade, estado=Iuf, tel=Itel, bco_nome=Ibco_nome,
                    bco_ag=Ibco_ag, bco_cc=Ibco_cc, bco_pix=Ibco_pix, modal=Imodal, whatsapp=Iwhatsapp
					WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

/* COMPRADOR */

 DROP PROCEDURE IF EXISTS sp_view_comprador;
DELIMITER $$
	CREATE PROCEDURE sp_view_comprador(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT * FROM vw_comprador WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_comprador;
DELIMITER $$
	CREATE PROCEDURE sp_set_comprador(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Iid_usuario int(11),
		IN Iid_local int(11),
		IN Inome varchar(40),
		IN Icpf varchar(14),
		IN Irg varchar(12),
		IN Icnh varchar(12),
		IN Itipo varchar(2),
		IN Ivalidade date,
		IN Ilimite tinyint(1)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Inome="")THEN
				DELETE FROM tb_motorista WHERE id=Iid;
            ELSE
				IF(Iid=0)THEN
					INSERT INTO tb_motorista (id_usuario,id_local,nome,cpf,rg,cnh,tipo,validade,limite) 
					VALUES (Iid_usuario,Iid_local,Inome,Icpf,Irg,Icnh,Itipo,Ivalidade,Ilimite);
                ELSE
					UPDATE tb_motorista 
                    SET id_usuario=Iid_usuario,id_local=Iid_local,nome=Inome,cpf=Icpf,rg=Irg,cnh=Icnh,tipo=Itipo,validade=Ivalidade,limite=Ilimite
					WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

/* LOCAL DE ESTOQUE */

 DROP PROCEDURE IF EXISTS sp_view_local_estq;
DELIMITER $$
	CREATE PROCEDURE sp_view_local_estq(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT * FROM tb_local WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_local_estq;
DELIMITER $$
	CREATE PROCEDURE sp_set_local_estq(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Iano varchar(4),
		IN Imodelo varchar(20),
		IN Iplaca varchar(8),
		IN Itipo varchar(10),
		IN Itara double,
		IN Ilocal varchar(5)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Imodelo="")THEN
				DELETE FROM tb_local WHERE id=Iid;
            ELSE
				IF(Iid=0)THEN
					INSERT INTO tb_local (ano,modelo,placa,tipo,tara,local) 
					VALUES (Iano,Imodelo,Iplaca,Itipo,Itara,Ilocal);
                ELSE
					UPDATE tb_local 
                    SET ano=Iano,modelo=Imodelo,placa=Iplaca,tipo=Itipo,tara=Itara,local=Ilocal
					WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

/* UNIDADES */

 DROP PROCEDURE IF EXISTS sp_view_unidades;
DELIMITER $$
	CREATE PROCEDURE sp_view_unidades(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT * FROM tb_und WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_unidade;
DELIMITER $$
	CREATE PROCEDURE sp_set_unidade(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Inome varchar(20),
		IN Isigla varchar(10)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Inome="")THEN
				DELETE FROM tb_und WHERE id=Iid;
            ELSE
				IF(Iid=0)THEN
					INSERT INTO tb_und (nome,sigla) 
					VALUES (Inome,Isigla);
                ELSE
					UPDATE tb_und 
                    SET nome=Inome,sigla=Isigla
					WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

/* MATERIAIS */

 DROP PROCEDURE IF EXISTS sp_view_materiais;
DELIMITER $$
	CREATE PROCEDURE sp_view_materiais(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT * FROM tb_material WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_material;
DELIMITER $$
	CREATE PROCEDURE sp_set_material(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Inome varchar(20),
		IN Icod varchar(20),
		IN Incm varchar(8),
		IN Iund varchar(10)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Inome="")THEN
				DELETE FROM tb_material WHERE id=Iid;
            ELSE
				IF(Iid=0)THEN
					INSERT INTO tb_material (nome,cod,ncm,und) 
					VALUES (Inome,Icod,Incm,Iund);
                ELSE
					UPDATE tb_material 
                    SET nome=Inome,cod=Icod,ncm=Incm,und=Iund
					WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

/* ESTOQUE */

 DROP PROCEDURE IF EXISTS sp_view_estoque;
DELIMITER $$
	CREATE PROCEDURE sp_view_estoque(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_local int(11)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SELECT * FROM vw_item_estq WHERE id_local = Iid_local;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_estoque;
DELIMITER $$
	CREATE PROCEDURE sp_set_estoque(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_local int(11),
		IN Iid_prod int(11),
		IN Iqtd double,
		IN Iund varchar(10),
		IN Ival_unit double
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iqtd=0)THEN
				DELETE FROM tb_item_estoque WHERE id_local=Iid_local AND id_prod=Iid_prod;
            ELSE
				INSERT INTO tb_item_estoque (id_local,id_prod,qtd,und,val_unit) 
					VALUES (Iid_local,Iid_prod,Iqtd,Iund,Ival_unit)
                    ON DUPLICATE KEY UPDATE qtd=Iqtd,val_unit=Ival_unit;
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_view_item_estq;
DELIMITER $$
	CREATE PROCEDURE sp_view_item_estq(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_prod int(11)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN

			SELECT ITEM.*, LOCAL.modelo, PROD.nome, ROUND(SUM(ITEM.qtd),2) AS qtd_tot 
                FROM tb_item_estoque AS ITEM 
                INNER JOIN tb_local AS LOCAL
                INNER JOIN tb_prod AS PROD
                ON LOCAL.id = ITEM.id_local
                AND PROD.id = ITEM.id_prod
                AND ITEM.id_prod=Iid_prod
                WHERE qtd>0
                GROUP BY LOCAL.id;

        END IF;
	END $$
DELIMITER ;

/* Compras */

 DROP PROCEDURE IF EXISTS sp_set_compra;
DELIMITER $$
	CREATE PROCEDURE sp_set_compra(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Iid_cliente int(11),
		IN Iid_resp int(11),
        IN Iid_local int(11),
		IN Istatus varchar(10),
		IN Iobs varchar(255),
		IN Idata datetime		
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iid_cliente=0)THEN
				DELETE FROM tb_compra WHERE id=Iid;
            ELSE
				IF(Iid=0)THEN
					INSERT INTO tb_compra (id_cliente,id_resp,id_local,status,obs)
					VALUES(Iid_cliente,Iid_resp,Iid_local,Istatus,Iobs);
					SELECT MAX(id) FROM tb_compra;
                ELSE
					UPDATE tb_compra SET
                    id_cliente=Iid_cliente,id_resp=Iid_resp,id_local=Iid_local,status=Istatus,obs=Iobs,data=Idata
                    WHERE id=Iid;
                    SELECT Iid as id;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_item_compra;
DELIMITER $$
	CREATE PROCEDURE sp_set_item_compra(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Iid_compra int(11),
		IN Iid_prod int(11),
		IN Iqtd double,
		IN Iund varchar(10),
		IN Ival_unit double,
		IN Iestorno double
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iqtd=0)THEN
				DELETE FROM tb_item_compra WHERE id=Iid;
            ELSE
				IF(Iid=0)THEN
					INSERT INTO tb_item_compra (id_compra,id_prod,qtd,und,val_unit,estorno) 
					VALUES(Iid_compra,Iid_prod,Iqtd,Iund,Ival_unit,Iestorno);
                ELSE
					UPDATE tb_item_compra
                    SET qtd=Iqtd,und=Iund,val_unit=Ival_unit,estorno=Iestorno;
                END IF;				
            END IF;
        END IF;
	END $$
DELIMITER ;

/* PRODUTO */

DROP PROCEDURE IF EXISTS sp_view_produto;
DELIMITER $$
	CREATE PROCEDURE sp_view_produto(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Inome varchar(20)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT * FROM vw_produto WHERE nome LIKE "%',Inome,'%" ORDER BY nome;');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_produto;
DELIMITER $$
	CREATE PROCEDURE sp_set_produto(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Inome varchar(20),
		IN Iund varchar(10),
		IN Ipreco double,
		IN Imargem double,
		IN Iid_mat int(11)
    )
	BEGIN        
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Inome="")THEN
				DELETE FROM tb_prod WHERE id=Iid;
            ELSE
				IF(Iid=0)THEN
					INSERT INTO tb_prod (nome,und,preco,margem,id_mat) 
					VALUES (Inome,Iund,Ipreco,Imargem,Iid_mat);
                ELSE
					UPDATE tb_prod 
                    SET nome=Inome,und=Iund,preco=Ipreco,margem=Imargem,id_mat=Iid_mat
					WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;