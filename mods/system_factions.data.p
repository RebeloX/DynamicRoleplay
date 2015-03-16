/*
	system_faction.data.p

*/

#include <YSI\y_hooks>

hook OnGameModeInit(){
	print("> system_faction.data carregado com sucesso.");
	return 1;
}

forward data_LoadFaction(factionid);
forward r@data_LoadFaction(factionid);

forward data_SaveFaction(factionid);
forward r@data_SaveFaction(factionid);

forward data_CreateFaction(playerid,name[],desc[],status);
forward r@data_CreateFaction(playerid,name[]);

public data_LoadFaction(factionid)
{
	format(mysql_query,sizeof mysql_query,"SELECT * FROM `factions` WHERE id=%d",factionid);
	mysql_function_query(mysql_connection,mysql_query,true,"r@data_LoadFaction","i",factionid);
	return 1;
}

public r@data_LoadFaction(factionid)
{
	new rows,fields;
	cache_get_data(rows,fields,mysql_connection);
	if(rows)
	{
		cache_get_field_content(0,"id",mysql_query);
		gFactionsInfo[factionid][faction_id] = strval(mysql_query);

		cache_get_field_content(0,"name",gFactionsInfo[factionid][faction_name]);

		cache_get_field_content(0,"desc",gFactionsInfo[factionid][faction_desc]);

		cache_get_field_content(0,"leader",mysql_query);
		gFactionsInfo[factionid][faction_leader] = strval(mysql_query);

		cache_get_field_content(0,"togfam",mysql_query);
		gFactionsInfo[factionid][faction_togfam] = strval(mysql_query);

		cache_get_field_content(0,"status",mysql_query);
		gFactionsInfo[factionid][faction_status] = strval(mysql_query);


		cache_get_field_content(0,"radiofq",mysql_query);
		gFactionsInfo[factionid][faction_radiofq] = strval(mysql_query);

		cache_get_field_content(0,"rankid",mysql_query);
		gFactionsInfo[factionid][faction_rankid] = strval(mysql_query);
	}
	printf("faction %d carregada com sucesso.",factionid);
	return 1;
}

public data_SaveFaction(factionid)
{
	format(mysql_query,sizeof mysql_query,
		"UPDATE `factions` SET `name`='%s', desc='%s', leader='%d', togfam='%d', status='%d', radiofq='%d', rankid='%d' WHERE id='%d'",
		gFactionsInfo[factionid][faction_name],gFactionsInfo[factionid][faction_desc],gFactionsInfo[factionid][faction_leader],
		gFactionsInfo[factionid][faction_togfam],gFactionsInfo[factionid][faction_status],gFactionsInfo[factionid][faction_radiofq],
		gFactionsInfo[factionid][faction_rankid],gFactionsInfo[factionid][faction_id]
	);
	mysql_function_query(mysql_connection,mysql_query,false,"r@data_SaveFaction","i",factionid);
	return 1;
}

public r@data_SaveFaction(factionid)
{
	printf("> faction %d salva com sucesso.",factionid);
	return 1;
}

public data_CreateFaction(playerid,name[],desc[],status)
{
	format(mysql_query,sizeof mysql_query,
		"INSERT INTO `factions` (`name`,`desc`,`status`,`creator`) VALUES ('%s','%s','%d','%s');",
		name,desc,status,gPlayerInfo[playerid][player_name]
	);
	printf("query: %s",mysql_query);
	mysql_function_query(mysql_connection,mysql_query,true,"r@data_CreateFaction","is",playerid,name);
	return 1;
}

public r@data_CreateFaction(playerid,name[])
{
	mysql_store_result();
    new sqlid = mysql_insert_id();
	mysql_free_result();
	printf("> faction %d criada com sucesso.",sqlid);
	data_LoadFaction(sqlid);
	format(gResult,sizeof gResult,"Facção %s (%d) criada com sucesso, use /darlider para dar lider da facção.",name,sqlid);
	SendClientMessage(playerid,-1,gResult);
	return 1;
}