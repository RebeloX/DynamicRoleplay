/*
================================================================================
								main.pwn
================================================================================
*/

//server includes

#include <a_samp>

#include plugins\mapandreas
#include plugins\streamer

//server mods
#include main.h
#include system.main.p
#include mods\system_player.data
#include mods\system_player
#include mods\system_cars.data
#include mods\system_prop.p
#include mods\system_cars.buy.p
#include mods\system_cars.p
#include mods\system_items
#include mods\system_cars.inventory
#include mods\system_interface
#include mods\system_player.inventory
#include mods\system_factions.data
#include mods\system_faction

player_GetName(playerid)
	return GetPlayerName(playerid,gPlayerInfo[playerid][player_name],25);

main()
{
	print("\n----------------------------------");
	print(" main.pwn carregado com sucesso.");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText("DC-RP (0.0.3)");
	AddPlayerClass(243,1498.8385,-1675.5094,14.0469,124.6517, 0, 0, 0, 0, 0, 0);
	MapAndreas_Init(MAP_ANDREAS_MODE_FULL);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	return 1;
}

public OnPlayerRequestClass(playerid,classid)
{
	if(IsPlayerNPC(playerid)) return 1;
	SendClientMessage(playerid,-1,"Verificando a sua conta...");
	player_GetName(playerid);
	data_CheckAccount(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success){
	if(!success)
		return SendClientMessage(playerid,0xBEBEBEFF,"SERVER: Este comando não existe.");
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid) 
{
	//Prop_OnPlayerEnterDynamicArea(playerid, areaid);
 	Item_OnPlayerEnterDynamicArea(playerid, areaid);
 	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	Item_OnPlayerLeaveDynamicArea(playerid, areaid);
	return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz){
	//item_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
	return 1;
}
