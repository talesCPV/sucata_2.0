-- 	DROP VIEW vw_comprador;
-- 	CREATE VIEW vw_comprador AS
	SELECT MOT.*, COALESCE(LOCAL.modelo,"") AS modelo
        FROM tb_motorista AS MOT
        LEFT JOIN tb_local AS LOCAL
        ON MOT.id_local = LOCAL.id        
        ORDER BY nome;
        
	SELECT * FROM vw_comprador;