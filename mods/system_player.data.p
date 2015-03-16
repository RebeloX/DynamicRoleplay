/*----------------------------------------------------------------------------*\
					==============================
						system_player.data.p
					==============================

	Descrição: Este sistema dá acesso aos dados do jogador em sí, ele contém
	funções de salvamento e carregamento de contas, também contém o próprio
	login e suas funções extras.

	Declaração de callbacks: data_
	Declaração de respostas: r@
	Declaração de váriaveis: data_

						Dynamic Roleplay - BlueX (c)
\*----------------------------------------------------------------------------*/

#include <a_samp>
#include plugins\a_mysql
#include <YSI\y_hooks>
#include plugins\Encrypt


//declaração de funções

forward data_CheckAccount(playerid);
forward r@data_CheckAccount(playerid);

forward data_CheckPassword(playerid,data_password[]);
forward r@data_CheckPassword(playerid);

forward data_LoadAccount(playerid);
forward r@data_LoadAccount(playerid);

forward data_SaveAccount(playerid);
forward r@data_SaveAccount(playerid);

//funções nativas

hook OnGameModeInit(){
	print("> system_player.data carregado com sucesso.");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid){
		case DIALOG_LOGIN:{
			static password[64],buffer[65];
			format(password,sizeof(password),"%s%d",inputtext,gPlayerInfo[playerid][player_time]);
			sha2(password,buffer);
			if(!strcmp(buffer,gPlayerInfo[playerid][player_password],false)){
				SendClientMessage(playerid,-1,"Password Correta");
				data_LoadAccount(playerid);
			}
			//data_CheckPassword(playerid,password);
		}
	}
	return 1;
}


//funções costum

public data_CheckAccount(playerid){
	format(mysql_query,sizeof(mysql_query),"SELECT * FROM `users` WHERE player_name='%s'",gPlayerInfo[playerid][player_name]);
	mysql_function_query(mysql_connection,mysql_query,true,"r@data_CheckAccount","d",playerid);
	return 1;
}

public r@data_CheckAccount(playerid){
	static rows,fields;
	cache_get_data(rows,fields);
	if(rows){
		cache_get_field_content(0,"player_time",mysql_query);
		gPlayerInfo[playerid][player_time] = strval(mysql_query);
		
		cache_get_field_content(0,"player_password",mysql_query);
		format(gPlayerInfo[playerid][player_password],65,"%s",mysql_query);

		ShowPlayerDialog(playerid,DIALOG_LOGIN,3,"Login","Insira a sua password.","Logar","Sair");
	}
	else {
		SendClientMessage(playerid,-1,"Faça o registo pelo ucp: ucp.dc-rp.com");
		Kick(playerid);
	}
	return 1;
}

public data_CheckPassword(playerid,data_password[]){
	format(mysql_query,sizeof(mysql_query),"SELECT * FROM `users` WHERE player_name='%s' AND player_password=sha2('%s',256)",
		gPlayerInfo[playerid][player_name],data_password
	);
	mysql_function_query(mysql_connection,mysql_query,true,"r@data_CheckPassword","d",playerid);
	return 1;
}

public r@data_CheckPassword(playerid){
	static rows,fields;
	cache_get_data(rows,fields);
	if(rows){
		SendClientMessage(playerid,-1,"Password Correta");
		data_LoadAccount(playerid);
	}
	else {

		SendClientMessage(playerid,-1,"Password Incorreta.");
	}
	return 1;
}

public data_LoadAccount(playerid){
	format(mysql_query,sizeof(mysql_query),"SELECT * FROM `users` WHERE player_name='%s'",gPlayerInfo[playerid][player_name]);
	mysql_function_query(mysql_connection,mysql_query,true,"r@data_LoadAccount","d",playerid);
	return 1;
}

public r@data_LoadAccount(playerid){
	static rows,fields;
	cache_get_data(rows,fields);
	if(rows){
			//carregamento dos dados OOC (dados do jogador)
			cache_get_field_content(0,"player_id",mysql_query);
			gPlayerInfo[playerid][player_id] = strval(mysql_query);

			cache_get_field_content(0,"player_admin",mysql_query);
			gPlayerInfo[playerid][player_admin] = strval(mysql_query);

			cache_get_field_content(0,"player_level",mysql_query);
			gPlayerInfo[playerid][player_level] = strval(mysql_query);

			cache_get_field_content(0,"player_exp",mysql_query);
			gPlayerInfo[playerid][player_exp] = strval(mysql_query);

			cache_get_field_content(0,"player_status",mysql_query);
			gPlayerInfo[playerid][player_status] = strval(mysql_query);

			//carregamento dos dados IC (dados do personagem)
			cache_get_field_content(0,"character_skin",mysql_query);
			gPlayerInfo[playerid][character_skin] = strval(mysql_query);

			cache_get_field_content(0,"character_id",mysql_query);
			format(gPlayerInfo[playerid][character_id],13,"%s",mysql_query);

			cache_get_field_content(0,"character_idv",mysql_query);
			gPlayerInfo[playerid][character_idv] = strval(mysql_query);

			cache_get_field_content(0,"character_birth",mysql_query);
			gPlayerInfo[playerid][character_birth] = strval(mysql_query);

			cache_get_field_content(0,"character_fingerprint",mysql_query);
			format(gPlayerInfo[playerid][character_fingerprint],13,"%s",mysql_query);

			cache_get_field_content(0,"character_sex",mysql_query);
			gPlayerInfo[playerid][character_sex] = strval(mysql_query);

			cache_get_field_content(0,"character_nationality",mysql_query);
			format(gPlayerInfo[playerid][character_nationality],25,"%s",mysql_query);
			
			player_Spawn(playerid);
	}
	return 1;
}

public data_SaveAccount(playerid){
	format(mysql_query,sizeof(mysql_query),"UPDATE `users` SET player_admin='%d' , player_inventory='%d', player_exp='%d',\
		player_level='%d',character_skin='%d',player_name='%s' WHERE player_id='%d'",gPlayerInfo[playerid][player_admin],
		gPlayerInfo[playerid][player_inventory],gPlayerInfo[playerid][player_exp],gPlayerInfo[playerid][player_level],
		gPlayerInfo[playerid][character_skin],gPlayerInfo[playerid][player_name],gPlayerInfo[playerid][player_id]
	);

	mysql_function_query(mysql_connection,mysql_query,false,"r@data_SaveAccount","d",playerid);
	return 1;
}

public r@data_SaveAccount(playerid){
	printf("DEBUG: conta %d foi salva com sucesso.",playerid);
	SendClientMessage(playerid,-1,"DEBUG: Conta salva com sucesso.");
	return 1;
}