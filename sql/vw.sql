DROP VIEW IF EXISTS vw_hora_dia;
CREATE VIEW vw_hora_dia AS
	SELECT 0 AS hora UNION ALL SELECT 1
		UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
		UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
		UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13
		UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17
		UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL SELECT 11
		UNION ALL SELECT 22 UNION ALL SELECT 23;

SELECT * FROM vw_hora_dia;

  DROP VIEW IF EXISTS vw_clube;
 CREATE VIEW vw_clube AS
	SELECT USR.nome AS prof, CLB.*
	FROM tb_clube AS CLB
    INNER JOIN tb_usuario AS USR
    ON CLB.id_usuario = USR.id
    ORDER BY CLB.nome;
    
SELECT * FROM vw_clube;

  DROP VIEW IF EXISTS vw_aluno;
 CREATE VIEW vw_aluno AS
	SELECT USR.nome AS prof, CLB.nome AS clube, ALN.*
	FROM tb_aluno AS ALN
    INNER JOIN tb_usuario AS USR
    INNER JOIN tb_clube AS CLB
    ON ALN.id_usuario = USR.id
    AND ALN.id_clube = CLB.id
    ORDER BY ALN.nome;
    
SELECT * FROM vw_aluno;

  DROP VIEW IF EXISTS vw_aula;
 CREATE VIEW vw_aula AS
	SELECT USR.nome AS prof, CLB.nome AS clube, AUL.*
	FROM tb_aula AS AUL
    INNER JOIN tb_usuario AS USR
    INNER JOIN tb_clube AS CLB
    ON AUL.id_usuario = USR.id
    AND AUL.id_clube = CLB.id
    ORDER BY AUL.descricao;
    
SELECT * FROM vw_aula;

	DROP VIEW IF EXISTS vw_agenda;
 	CREATE VIEW vw_agenda AS
		SELECT AGD.*, ALN.nome, AUL.descricao, CLB.nome AS clube,
        CLB.id AS id_clube, CONCAT("w-",AGD.dia,"-",AGD.hora) AS id_call
		FROM tb_agenda AS AGD
		INNER JOIN tb_aluno AS ALN
		INNER JOIN tb_aula AS AUL
		INNER JOIN tb_clube AS CLB
		ON AGD.id_aluno = ALN.id
		AND AGD.id_aula = AUL.id
		AND AUL.id_clube = CLB.id
		ORDER BY AGD.hora,AGD.dia;
        
SELECT * FROM vw_agenda;

	DROP VIEW IF EXISTS vw_agenda_dia;
 	CREATE VIEW vw_agenda_dia AS
		SELECT id_usuario,dia, GROUP_CONCAT(DISTINCT CONCAT(hora,"|",id_aluno,"|",nome,"|",id_aula,"|", descricao,"|",id_clube,"|",clube) SEPARATOR "*#*") AS aulas  
		FROM vw_agenda
		GROUP BY dia, id_usuario
		ORDER BY dia,hora;
        
SELECT * FROM vw_agenda_dia;

	DROP VIEW IF EXISTS vw_aula_dada;
 	CREATE VIEW vw_aula_dada AS
		SELECT AUD.*, (DAYOFWEEK(AUD.data_hora)-1) AS dia, HOUR(AUD.data_hora) AS hora,
		AUL.descricao AS aula, ALN.nome AS aluno, CLB.id AS id_clube ,CLB.nome AS clube,
        CONCAT("w-",(DAYOFWEEK(AUD.data_hora)-1),"-",HOUR(AUD.data_hora)) AS id_call
		FROM tb_aula_dada AS AUD
		INNER JOIN tb_aula AS AUL
		INNER JOIN tb_aluno AS ALN
        INNER JOIN tb_clube AS CLB
		ON AUD.id_aula = AUL.id
		AND AUD.id_aluno = ALN.id
        AND AUL.id_clube = CLB.id;
		
SELECT * FROM vw_aula_dada;        


(SELECT AGD.dia,AGD.hora, AGD.id_usuario AS id_professor, AGD.id_call,
	GROUP_CONCAT(DISTINCT CONCAT(AGD.id_aluno,"|",AGD.nome,"|",AGD.id_aula,"|", AGD.descricao,"|",AGD.id_clube,"|",AGD.clube) SEPARATOR "*#*") AS aulas,
    0 AS exec
	FROM vw_agenda AS AGD
    GROUP BY AGD.id_usuario,AGD.dia,AGD.hora);
    
--    UNION ALL
    
(SELECT AUD.dia,AUD.hora, AUD.id_usuario AS id_professor, AUD.id_call,
	GROUP_CONCAT(DISTINCT CONCAT(AUD.id_aluno,"|",AUD.aluno,"|",AUD.id_aula,"|", AUD.aula,"|",AUD.id_clube,"|",AUD.clube) SEPARATOR "*#*") AS aulas,
    1 AS exec
	FROM vw_aula_dada AS AUD
    GROUP BY AUD.id_usuario,AUD.dia,AUD.hora
    )
    ORDER BY id_call;