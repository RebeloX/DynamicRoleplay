/*----------------------------------------------------------------------------*\
					==============================
							system_player.p
					==============================

	Descrição: Sistema base do jogador, contém comandos e coisas básicas em si.

	Declaração de callbacks: player_
	Declaração de respostas: r@
	Declaração de váriaveis: player_

						Dynamic Roleplay - BlueX (c)
\*----------------------------------------------------------------------------*/

#include <zcmd>
#include <YSI\y_hooks>
#include plugins\sscanf2


//declaração de funções.
forward player_Spawn(playerid);
forward player_FirstSpawn(playerid);


//funções
player_CreateSign(playerid){
	new string[25],_char[2],_char2[2];
	strmid(_char,gPlayerInfo[playerid][player_name],0,1);
	strmid(_char2,gPlayerInfo[playerid][player_name],strfind(string,"_")+1,strfind(string,"_")+2);

	format(string,sizeof(string),"%s \"%s%s\" %s",
	    player_DeleteName(gPlayerInfo[playerid][player_name],0),_char,_char2,player_DeleteName(gPlayerInfo[playerid][player_name],1)
	);
	return string;
}						

player_DeleteName(string[],type){
	static _string[25];
	format(_string,25,"%s",string);
	if(type == 0) //irá elimiar o "_" e depois do mesmo. ex: Matt_Baron, resultado: Matt
		strdel(_string,strfind(_string,"_"),25);
	else if(type == 1) //irá elimiar o "_" e antes do mesmo. ex: Matt_Baron, resultado: Baron
		strdel(_string,0,strfind(_string,"_")+1);
	return _string;
}

hook OnGameModeInit(){
	print("> system_player.p carregado com sucesso.");
	return 1;
}

public player_FirstSpawn(playerid){
	//gerar impressão digital.
	format(gPlayerInfo[playerid][character_fingerprint],13,"%d%d%s",
		player_DeleteName("Baron",1),player_DeleteName("Matt",0),reverse("1231880")
	);

	//gerar numero do CI.

	format(gPlayerInfo[playerid][character_id],13,"%d0%d%d%d",
	    gPlayerInfo[playerid][character_nationality],gPlayerInfo[playerid][character_sex],
	    player_DeleteName("Baron",1),player_DeleteName("Matt",0)
	);

	SendClientMessage(playerid,-1,"[DEBUG]:Foram gerados dois códigos Impressão digital e Número de Cartão de Identificação:");
	format(gResult,sizeof(gResult),"Impressão Digital: %s | Número do CI: %s",
		gPlayerInfo[playerid][character_fingerprint],gPlayerInfo[playerid][character_id]
	);
	SendClientMessage(playerid,-1,gResult);
	gPlayerInfo[playerid][player_status] = PLAYER_STATUS_SPAWNED;
	return 1;
}

public player_Spawn(playerid){

	if(gPlayerInfo[playerid][player_status] == PLAYER_STATUS_FIRST_SPAWN){
		player_FirstSpawn(playerid);
	}

	SetPlayerScore(playerid,gPlayerInfo[playerid][player_level]);
	SpawnPlayer(playerid);
	SetPlayerSkin(playerid,gPlayerInfo[playerid][character_skin]);
	for(new n=0; n<MAX_PLAYER_ATTACHED_OBJECTS; n++)
			RemovePlayerAttachedObject(playerid, n);

	format(gResult,sizeof(gResult),"Database id: %d",gPlayerInfo[playerid][player_id]);
	SendClientMessage(playerid,-1,gResult);

	format(gResult,sizeof(gResult),"Seja bem vindo de volta: %s",gPlayerInfo[playerid][player_name]);
	SendClientMessage(playerid,-1,gResult);

	format(gResult,sizeof(gResult),"DEBUG: Skin: %d | Nível: %d | Exp: %d",
		gPlayerInfo[playerid][character_skin],gPlayerInfo[playerid][player_level],gPlayerInfo[playerid][player_exp]
	);
	SendClientMessage(playerid,-1,gResult);

	if(gPlayerInfo[playerid][player_admin] != 0){
		SendClientMessage(playerid,-1,"Você é admin, deseja logar como administrador?");
	}
	SetTimerEx("CheckObject",5000,true,"d",playerid);
	return 1;
}

//comandos

CMD:me(playerid,params[]){
	if(isnull(params))
		return SendClientMessage(playerid,-1,"USE: /me [ação]");
	format(gResult,sizeof(gResult),"*%s %s",gPlayerInfo[playerid][player_name],params);
	SendClientMessage(playerid,0xDDA0DDFF,gResult);
	return 1;
}

CMD:do(playerid,params[]){
	if(isnull(params))
		return SendClientMessage(playerid,-1,"USE: /do [ação]");
	format(gResult,sizeof(gResult),"*%s ((%s))",params,gPlayerInfo[playerid][player_name]);
	SendClientMessage(playerid,0xDDA0DDFF,gResult);
	return 1;
}

CMD:rg(playerid,params[]){
	SendClientMessage(playerid,0xBEBEBEFF,"-------------[Cartão de Identificação - Los Santos]-------------");
	//SendClientMessage(playerid,0xBEBEBEFF,"----------------------------------------------------------------");

	format(gResult,sizeof(gResult),"Apelido: %s | Nome: %s | Assinatura: %s",
		player_DeleteName(gPlayerInfo[playerid][player_name],1),player_DeleteName(gPlayerInfo[playerid][player_name],0),
		player_CreateSign(gPlayerInfo[playerid][player_name])
	);
	SendClientMessage(playerid,0xBEBEBEFF,gResult);

	format(gResult,sizeof(gResult),"Sexo: %s | Altura: | Data de validade: 00/00/0000",
			gPlayerInfo[playerid][character_sex] ? ("M") : ("F")
	);
	SendClientMessage(playerid,0xBEBEBEFF,gResult);

	format(gResult,sizeof(gResult),"Data de Nascimento: %s | Nacionalidade: %s",
			fixdate(gPlayerInfo[playerid][character_birth]),gPlayerInfo[playerid][character_nationality]
	);
	SendClientMessage(playerid,0xBEBEBEFF,gResult);

	format(gResult,sizeof(gResult),"Impressão Digital: %s | Número do CI: %s",
		gPlayerInfo[playerid][character_fingerprint],gPlayerInfo[playerid][character_id]
	);
	SendClientMessage(playerid,0xBEBEBEFF,gResult);
	return 1;
}

CMD:idade(playerid,params[]){
	format(gResult,sizeof(gResult),"A sua idade é: %d",getage(gPlayerInfo[playerid][character_birth]));
	SendClientMessage(playerid,0xBEBEBEFF,gResult);
	return 1;
}

CMD:v(playerid,params[]){
	if(isnull(params))
		SendClientMessage(playerid,-1,"USE: /v [id]");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	CreateVehicle(strval(params),x,y,z,90.0,162,162,30);
	return 1;
}