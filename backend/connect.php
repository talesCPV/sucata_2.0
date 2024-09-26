<?php
    $conexao = new mysqli("50.116.87.200", "d2soft98_tales", "#Sucata65", "d2soft98_ges_3");
//    $conexao = new mysqli("", "", "", "");
    if (!$conexao){
        die ("Erro de conexão com localhost, o seguinte erro ocorreu -> ".mysql_error());
    }    

?>