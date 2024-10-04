<?php

    $query_db = array(
        /* LOGIN */
        "LOG-0"  => 'CALL sp_login("x00", "x01");', // USER, PASS

        /* USERS */
        "USR-0"  => 'CALL sp_viewUser(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "USR-1"  => 'CALL sp_setUser(@access,@hash,x00,"x01","x02","x03",x04);', // ID, NOME, EMAIL, PASS, ACCESS
        "USR-2"  => 'CALL sp_updateUser(@hash,"x00","x01");', // NOME, PASS
        "USR-3"  => 'CALL sp_check_usr_mail(@hash);', //

        /* CALENDAR */
        "CAL-0"  => 'CALL sp_view_calendar(@hash,"x00","x01");', // DT_INI, DT_FIN
        "CAL-1"  => 'CALL sp_set_calendar(@hash,"x00","x01");', // DT_AGD, OBS

        /* MAIL */
        "MAIL-0"  => 'CALL sp_set_mail(@hash,"x00","x01");', // ID_TO, MESSAGE
        "MAIL-1"  => 'CALL sp_view_mail(@hash,x00);', // I_SEND
        "MAIL-2"  => 'CALL sp_all_mail_adress(@hash);', //      
        "MAIL-3"  => 'CALL sp_del_mail(@hash,"x00",x01,x02);', // DATA, ID_FROM, ID_TO
        "MAIL-4"  => 'CALL sp_mark_mail(@hash,"x00",x01,x02);', // DATA, ID_FROM, ID_TO

        /* SYSTEMA */
        "SYS-0"  => 'CALL sp_set_usr_perm_perf(@access,@hash,x00,"x01");', // ID, NOME
        "SYS-1"  => 'CALL sp_view_usr_perm_perf(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE

        /* ADMIN */
        "ADM-0"  => 'CALL sp_view_emp(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL,VALUE
        "ADM-1"  => 'CALL sp_set_emp(@access,@hash,"x00","x01","x02","x03","x04","x05","x06","x07","x08","x09","x10","x11","x12","x13","x14","x15","x16","x17","x18","x19");', // id,nome,fantasia,tipo,cnpj_cpf,ie,im,endereco,num,bairro,cep,cidade,estado,tel,bco_nome,bco_ag,bco_cc,bco_pix,modal,whatsapp
        "ADM-2"  => 'CALL sp_view_comprador(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL,VALUE
        "ADM-3"  => 'CALL sp_set_comprador(@access,@hash,x00,x01,"x02","x03","x04","x05","x06","x07","x08","x09");', // id_usuario,id_local,nome,cpf,rg,cnh,tipo,validade,limite
        "ADM-4"  => 'CALL sp_view_local_estq(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL,VALUE
        "ADM-5"  => 'CALL sp_set_local_estq(@access,@hash,x00,"x01","x02","x03","x04","x05","x06");', // id,ano,modelo,placa,tipo,tara,local

        /* CONFIGURAÇÕES */
        "CONF-0" => 'CALL sp_view_unidades(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL,VALUE
        "CONF-1" => 'CALL sp_set_unidade(@access,@hash,x00,"x01","x02");', // ID,NOME,SIGLA
        "CONF-2" => 'CALL sp_view_materiais(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL,VALUE
        "CONF-3" => 'CALL sp_set_material(@access,@hash,x00,"x01","x02","x03","x04");', // ID,NOME,COD,NCM,UND

        /* ESTOQUE */
        "ESTQ-0" => 'CALL sp_view_estoque(@access,@hash,x00);', // ID_LOCAL
        "ESTQ-1" => 'CALL sp_set_estoque(@access,@hash,x00,x01,"x02","x03","x04");', // id_local,id_prod,qtd,und,val_unit
        "ESTQ-2" => 'CALL sp_view_produto(@access,@hash,"x00");', // NOME_PRODUTO
        "ESTQ-3" => 'CALL sp_set_produto(@access,@hash,x00,"x01","x02","x03","x04","x05");', // id,nome,und,preco,margem,id_mat
        "ESTQ-4" => 'CALL sp_view_item_estq(@access,@hash,x00);', // ID_PRODUTO

        /* COMERCIAL */
        "COM-0" => 'CALL sp_view_compra(@access,@hash,x00);', // 
        "COM-1" => 'CALL sp_set_compra(@access,@hash,x00,x01,x02,"x03","x04","x05");', // id,id_cliente,id_local,status,obs,data
        "COM-2" => 'CALL sp_set_item_compra(@access,@hash,x00,x01,x02,"x03","x04","x05","x06");', // id,id_compra,id_prod,qtd,und,val_unit,estorno
        


    );

?>