/*
================================================================================
						system_main.p
================================================================================
*/

#include <a_samp>
#include <YSI\y_hooks>
#include plugins\a_mysql

hook OnGameModeInit()
{
	mysql_connection = mysql_connect(mysql_host,mysql_user,mysql_database,mysql_password);
	if(mysql_connection){
		print("Conexao establecida com o servidor.");
	}
	else {
		print("Não foi possivel establecer uma conexao com o servidor.");
		print("O servidor sera fechado por segurança.");
		SendRconCommand("exit");
	}
	print("> system_main.p carregado com sucesso.");
	return 1;
}

hook OnGameModeExit()
{
	return 1;
}

public OnQueryError(errorid, error[], callback[], query[], connectionHandle){
	printf("errorid: %d",errorid);
	printf("error: %s",error);
	printf("callback: %s",callback);
	printf("query: %s",query);
	return 1;
}
