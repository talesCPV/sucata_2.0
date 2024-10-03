-- 	DROP VIEW vw_comprador;
-- 	CREATE VIEW vw_comprador AS
	SELECT MOT.*, COALESCE(LOCAL.modelo,"") AS modelo
        FROM tb_motorista AS MOT
        LEFT JOIN tb_local AS LOCAL
        ON MOT.id_local = LOCAL.id        
        ORDER BY nome;
        
	SELECT * FROM vw_comprador;
    
    SELECT * FROM tb_item_estoque;

 	DROP VIEW IF EXISTS vw_item_estq;
 	CREATE VIEW vw_item_estq AS
    SELECT PROD.nome, PROD.und, ROUND(PROD.preco,2) as preco, PROD.margem, ITEM.id_local, ITEM.id_prod, 
    ROUND(ITEM.qtd,2) AS qtd, ROUND(ITEM.val_unit,2) AS val_unit,
    ROUND(ITEM.qtd * ITEM.val_unit ,2) as total,
    ROUND(PROD.margem,2) as val_venda
        FROM tb_item_estoque AS ITEM 
        INNER JOIN tb_prod AS PROD
        ON PROD.id = ITEM.id_prod
        AND ITEM.qtd > 0
        ORDER BY ITEM.id_local, PROD.nome;
        
SELECT *
	FROM vw_item_estq
	WHERE id_local = 6;
    
	SELECT * FROM tb_item_estoque;
    
DROP VIEW IF EXISTS vw_produto;
CREATE VIEW vw_produto AS
	SELECT PROD.id, PROD.nome,PROD.und,ROUND(PROD.preco,2) as compra, ROUND(PROD.margem,2) as venda,
    PROD.id_mat, ROUND(SUM(COALESCE(ITEM.qtd,0)),2) AS qtd_tot
    FROM tb_prod AS PROD
    LEFT JOIN tb_item_estoque AS ITEM
    ON ITEM.id_prod=PROD.ID
    GROUP BY ITEM.id_prod;
    
	SELECT * FROM vw_produto;
    
    
    
SELECT * FROM 
                () AS SEL
            WHERE qtd_tot > 0;
            
            

    