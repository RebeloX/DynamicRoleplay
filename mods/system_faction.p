/*

	system_factions.p

*/

#include <YSI\y_hooks>

forward r@faction_ShowMembers(playerid,factionid,page);

hook OnGameModeInit()
{
	print("> system_factions carregado com sucesso.");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_FACTION_CREATE:
		{
			if(isnull(inputtext))
				return ShowPlayerDialog(playerid,DIALOG_FACTION_CREATE,DIALOG_STYLE_INPUT,"Criar facção [1/3]","Insira o nome da facção:","Continuar","Cancelar");
			if(!response)
				return 1;
			SetPVarString(playerid,"faction_name",inputtext);
			ShowPlayerDialog(playerid,DIALOG_FACTION_CREATE2,DIALOG_STYLE_INPUT,"Criar facção [2/3]","Inseria uma descrição para a facção:","Continuar","Cancelar");
		}
		case DIALOG_FACTION_CREATE2:
		{
			if(isnull(inputtext))
				return ShowPlayerDialog(playerid,DIALOG_FACTION_CREATE2,DIALOG_STYLE_INPUT,"Criar facção [2/3]","Inseria uma descrição para a facção:","Continuar","Cancelar");
			if(!response)
				return 1;
			SetPVarString(playerid,"faction_desc",inputtext);
			ShowPlayerDialog(playerid,DIALOG_FACTION_CREATE3,DIALOG_STYLE_INPUT,"Criar facção [3/3]","Escolha facção oficial [1], facção governamental [2], facção não-oficial [3]","Continuar","Cancelar");
		}
		case DIALOG_FACTION_CREATE3:
		{
			if(isnull(inputtext))
				return ShowPlayerDialog(playerid,DIALOG_FACTION_CREATE3,DIALOG_STYLE_INPUT,"Criar facção [3/3]","Escolha facção oficial [1], facção governamental [2], facção não-oficial [3]","Continuar","Cancelar");
			if(!isnumeric(inputtext))
				return ShowPlayerDialog(playerid,DIALOG_FACTION_CREATE3,DIALOG_STYLE_INPUT,"Criar facção [3/3]","Escolha facção oficial [1], facção governamental [2], facção não-oficial [3]","Continuar","Cancelar");
			data_CreateFaction(
				playerid,GetPVarStringEx(playerid,"faction_name"),
				GetPVarStringEx(playerid,"faction_desc"),strval(inputtext)
			);
		}
		case DIALOG_FACTION:
		{
			if(!response)
				return 1;
			if(listitem == 0) //membros
			{
				faction_ShowMembers(playerid,gPlayerInfo[playerid][player_faction]);
			}
			else if(listitem == 1) //ranks
			{
				//mostra os ranks
				faction_ShowRanks(playerid,gPlayerInfo[playerid][player_faction]);
				printf("chamou!!");
			}
			else if(listitem == 2) //informações
			{
				//informações aqui.
				return 1;
			} 
		}

	}
	return 1;
}


stock faction_ShowMembers(playerid,factionid,page = 0)
{
	format(mysql_query,sizeof mysql_query,
		"SELECT * FROM `users` WHERE player_faction=%d LIMIT %d,%d",
		factionid,page*10,10
	);
	mysql_function_query(mysql_connection,mysql_query,true,"r@faction_ShowMembers","ddd",playerid,factionid,page);
	return 1;
}

public r@faction_ShowMembers(playerid,factionid,page)
{
	new rows,fields;
	cache_get_data(rows,fields,mysql_connection);
	if(!rows && page > 0)
		return faction_ShowMembers(playerid,factionid);
	print("debug1");
	new member_name[10][25];
	for(new row = 0; row<rows; row++)
	{
		cache_get_field_content(row,"player_name",member_name[row]);
	}
	print("debug2");
	new tempdg[1000];

	if(rows)
	{
		if(page > 0)
		{
			strcat(tempdg,"<< Anterior\n");
		}
		new index = -1; while(++index < rows)
		{
			new tmprow[80];
			format(tmprow, sizeof tmprow, 
				"%d - %s",(index + 1),member_name[index]
			);

			strcat(tmprow,"\n");
			strcat(tempdg,tmprow);

		}
		if(rows == 10)
		{
			strcat(tempdg,"Próximo >>\n");
		}
	}
	print("debug3");
	ShowPlayerDialog(playerid,DIALOG_MEMBER_LIST,DIALOG_STYLE_LIST,"Faction Members",tempdg,"Selecionar","Sair");
	return 1;
}

stock faction_ShowRanks(playerid, factionid, page = 0)
{
	format(mysql_query,sizeof mysql_query, 
		"SELECT * FROM `ranks` WHERE factionid='%d'",factionid
	);
	mysql_function_query(mysql_connection,mysql_query,true,"r@faction_ShowRanks","iii",playerid, factionid, page);
	return 1;
}

forward r@faction_ShowRanks(playerid, factionid, page );
public r@faction_ShowRanks(playerid, factionid, page )
{
	new rows,fields;
	cache_get_data(rows,fields);
	printf("rows %d",rows);
	if(rows)
	{
		static rank_name[10][32];
		if(page == 0)
		{
			cache_get_field_content(0,"rank_1",rank_name[0]);
			cache_get_field_content(0,"rank_2",rank_name[1]);
			cache_get_field_content(0,"rank_3",rank_name[2]);
			cache_get_field_content(0,"rank_4",rank_name[3]);
			cache_get_field_content(0,"rank_5",rank_name[4]);
			cache_get_field_content(0,"rank_6",rank_name[5]);
			cache_get_field_content(0,"rank_7",rank_name[6]);
			cache_get_field_content(0,"rank_8",rank_name[7]);
			cache_get_field_content(0,"rank_9",rank_name[8]);
			cache_get_field_content(0,"rank_10",rank_name[9]);
			
		}
		else if(page == 1)
		{
			cache_get_field_content(0,"rank_11",rank_name[0]);
			cache_get_field_content(0,"rank_12",rank_name[1]);
			cache_get_field_content(0,"rank_13",rank_name[2]);
			cache_get_field_content(0,"rank_14",rank_name[3]);
			cache_get_field_content(0,"rank_15",rank_name[4]);
			cache_get_field_content(0,"rank_16",rank_name[5]);
			cache_get_field_content(0,"rank_17",rank_name[6]);
			cache_get_field_content(0,"rank_18",rank_name[7]);
			cache_get_field_content(0,"rank_19",rank_name[8]);
			cache_get_field_content(0,"rank_20",rank_name[9]);

		}
		print("next");

		print("starting...");

		new tempdg[1000]; //4 kb of data

		if(page > 0)
		{
			strcat(tempdg,"<< Anterior\n");
		}
		print("debug1");
		new tmprow[400];
		format(tmprow, sizeof tmprow,
			"1 - %s\n2 - %s\n3 - %s\n4 - %s\n5 - %s\n6 - %s\n7 - %s\n8 - %s\n9 - %s\n10 - %s\n",
			rank_name[0],rank_name[1],rank_name[2],rank_name[3],rank_name[4],rank_name[5],
			rank_name[6],rank_name[7],rank_name[8],rank_name[9]
		);
		strcat(tempdg,tmprow);
		strcat(tempdg,"Próximo >>\n");

		ShowPlayerDialog(playerid,DIALOG_RANK_LIST,DIALOG_STYLE_LIST,"Faction Ranks",tempdg,"Selecionar","Sair");

	}
	return 1;
}

CMD:criarfaction(playerid,params[])
{
	ShowPlayerDialog(playerid,DIALOG_FACTION_CREATE,DIALOG_STYLE_INPUT,"Criar facção [1/3]","Insira o nome da facção:","Continuar","Cancelar");
	return 1;
}

CMD:darlider(playerid,params[])
{
	new id,factionid;
	if(sscanf(params,"ii",id,factionid))
		return SendClientMessage(playerid,-1,"USE: /darlider [id] [faction]");
	if(IsPlayerConnected(id)){
		gFactionsInfo[factionid][faction_leader] = id;
		gPlayerInfo[id][player_faction] = factionid;
		gPlayerInfo[id][player_rank] = 20; //lider
		format(gResult,sizeof gResult,"Você deu lider da facção %s(%d) para o jogador %s (%d)",
			gFactionsInfo[factionid][faction_name],factionid,gPlayerInfo[id][player_name],id
		);
		SendClientMessage(playerid,-1,gResult);
		format(gResult,sizeof gResult,"Você recebeu lider da facção %s (%d) do administrador %s (%d)",
			gFactionsInfo[factionid][faction_name],factionid,gPlayerInfo[playerid][player_name],playerid
		);
		SendClientMessage(id,-1,gResult);
		data_SaveFaction(factionid);
	}
	return 1;
}

CMD:convidar(playerid,params[])
{
	if(gPlayerInfo[playerid][player_faction] != 0 && gPlayerInfo[playerid][player_rank] == 20)
	{
		new id,rank;
		if(sscanf(params,"ii",id,rank))
			return SendClientMessage(playerid,-1,"USE: /convidar [id] [rank]");
		gPlayerInfo[id][player_faction] = gPlayerInfo[playerid][player_faction];
		gPlayerInfo[id][player_rank] = rank;
		format(gResult,sizeof gResult,"Você convidou o jogador %s (%d) para facção %s",
			gPlayerInfo[id][player_name],id,gFactionsInfo[gPlayerInfo[playerid][player_faction]][faction_name]
		);
		SendClientMessage(playerid,-1,gResult);
		format(gResult,sizeof gResult,"Você foi convidado para a facção %s pelo lider %s (%d)",
			gFactionsInfo[gPlayerInfo[playerid][player_faction]][faction_name],
			gPlayerInfo[playerid][player_name],playerid
		);
		SendClientMessage(id,-1,gResult);
	}
	else
		return SendClientMessage(playerid,-1,"Você não é lider de nenhuma facção.");
	return 1;
}

CMD:faction(playerid,params[])
{
	printf("verificando! %d | %d",gPlayerInfo[playerid][player_faction],gPlayerInfo[playerid][player_rank]);
	if(gPlayerInfo[playerid][player_faction] != 0 && gPlayerInfo[playerid][player_rank] == 20)
	{
		print("sucesso!!!!!!!!!!!!");
		/*new fname[32];
		format(gResult,sizeof gResult,"%s",gFactionsInfo[gPlayerInfo[playerid][player_faction]][faction_name]);*/
		ShowPlayerDialog(playerid,DIALOG_FACTION,DIALOG_STYLE_LIST,"lol","Membros\nRanks\nInformação","Selecionar","Sair");
	}
	return 1;
}