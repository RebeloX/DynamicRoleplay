/*----------------------------------------------------------------------------*\
					==============================
							system_items.p
					==============================

	Descrição: Sistema base do jogador, contém comandos e coisas básicas em si.

	Declaração de callbacks: item_
	Declaração de respostas: r@
	Declaração de váriaveis: item_

						Dynamic Roleplay - BlueX (c)
\*----------------------------------------------------------------------------*/

#include <YSI\y_hooks>
//#include plugins\witem
#include plugins\mapandreas

forward DropItem(playerid,id);
forward r@DropItem(playerid,id);
forward data_LoadItems();
forward r@data_LoadItems(id);
forward data_SaveItem(id);
forward r@data_SaveItems(id);

hook OnGameModeInit(){
	print("> system_item.p carregado com sucesso.");
	data_LoadItems();
	return 1;
}

public DropItem(playerid,id){
	format(mysql_query,sizeof mysql_query,"SELECT * FROM item_info_model_det WHERE id='%d'",id);
	mysql_function_query(mysql_connection,mysql_query,true,"r@DropItem","dd",playerid,id);
	return 1;
}

public r@DropItem(playerid,id){
	new rows,fields;
	cache_get_data(rows,fields);
	if(rows){
		new i;
		i = id - 1;
		cache_get_field_content(0,"id",mysql_query);
		gItemInfo[i][item_id] = strval(mysql_query);

		cache_get_field_content(0,"name",gItemInfo[i][item_name]);

		cache_get_field_content(0,"type",mysql_query);
		gItemInfo[i][item_type] = strval(mysql_query);

		cache_get_field_content(0,"extra",mysql_query);
		gItemInfo[i][item_extra] = strval(mysql_query);

		cache_get_field_content(0,"model",mysql_query);
		gItemInfo[i][item_model] = strval(mysql_query);

		cache_get_field_content(0,"x",mysql_query);
		gItemInfo[i][item_x] = floatstr(mysql_query);

		cache_get_field_content(0,"y",mysql_query);
		gItemInfo[i][item_y] = floatstr(mysql_query);

		cache_get_field_content(0,"z",mysql_query);
		gItemInfo[i][item_z] = floatstr(mysql_query);

		cache_get_field_content(0,"rx",mysql_query);
		gItemInfo[i][item_rx] = floatstr(mysql_query);

		cache_get_field_content(0,"ry",mysql_query);
		gItemInfo[i][item_ry] = floatstr(mysql_query);

		cache_get_field_content(0,"rz",mysql_query);
		gItemInfo[i][item_rz] = floatstr(mysql_query);

		cache_get_field_content(0,"int",mysql_query);
		gItemInfo[i][item_int] = strval(mysql_query);

		cache_get_field_content(0,"vw",mysql_query);
		gItemInfo[i][item_vw] = strval(mysql_query);

		cache_get_field_content(0,"owner",mysql_query);
		gItemInfo[i][item_owner] = strval(mysql_query);

		cache_get_field_content(0,"ownertype",mysql_query);
		gItemInfo[i][item_ownertype] = strval(mysql_query);

		new Float:playerpos[3];
		GetPlayerPos(playerid,playerpos[0],playerpos[1],playerpos[2]);

		MapAndreas_FindZ_For2DCoord(playerpos[0],playerpos[1], playerpos[2]);

		gItemInfo[i][item_objectid] = CreateObject(
			gItemInfo[i][item_model], playerpos[0],playerpos[1],playerpos[2], 
			gItemInfo[i][item_rx], gItemInfo[i][item_ry], gItemInfo[i][item_rz]
		);

		gItemInfo[i][item_x] = playerpos[0];
		gItemInfo[i][item_y] = playerpos[1];
		gItemInfo[i][item_z] = playerpos[2];

		/*witem_push(
			gItemInfo[i][item_id], gItemInfo[i][item_name], gItemInfo[i][item_type], gItemInfo[i][item_extra],
			gItemInfo[i][item_objectid], playerpos[0],playerpos[1],playerpos[2],GetPlayerInterior(playerid),
			GetPlayerVirtualWorld(playerid), gItemInfo[i][item_id], gItemInfo[i][item_ownertype], gItemInfo[i][item_owner]
		);*/
		//UPDATE `item_info` SET `owner`=0 WHERE  `id`=60;
		format(mysql_query,sizeof mysql_query,
			"UPDATE `item_info` SET owner='%d', ownertype='%d', x='%f', y='%f', z='%f' WHERE id='%d'",
			0,1,playerpos[0],playerpos[1],playerpos[2],gItemInfo[i][item_id]);
		mysql_function_query(mysql_connection,mysql_query,false,"r@UpdateItem","d",i);

		SendClientMessage(playerid,-1,"Você dropou um item!");
	}
	return 1;
}

forward r@UpdateItem(id);
public r@UpdateItem(id){
	printf("item (%d | db: %d)",id,(id+1));
	return 1;
}

forward CheckObject(playerid);
public CheckObject(playerid){
	//new name[32];
	for(new i; i<1000; ++i){
		if(IsPlayerInRangeOfPoint(playerid,1.5,gItemInfo[i][item_x],gItemInfo[i][item_y],gItemInfo[i][item_z]) &&
			gItemInfo[i][item_x] != 0.0 && gItemInfo[i][item_y] != 0.0 && gItemInfo[i][item_z] != 0.0 ){
			//witem_getname(WItem:i, name);
			format(gResult,sizeof(gResult),"Use /apanhar para pegar o item (%s)",gItemInfo[i][item_name]);
			SendClientMessage(playerid,-1,gResult);
		}
	}
	return 1;
}

public data_LoadItems(){
	for(new i; i<1000; i++){
		format(mysql_query,sizeof(mysql_query),"SELECT * FROM item_info_model_det WHERE id='%d' AND ownertype='1'",i);
		mysql_function_query(mysql_connection,mysql_query,true,"r@data_LoadItems","d",i);
	}
	return 1;
}

/*
enum E_ITEM_INFO{
	item_id,
	item_name[32],
	item_type,
	item_extra,
	item_worn,
	item_model,
	Float:item_info,
	Float:item_x,
	Float:item_y,
	Float:item_z,
	Float:item_rx,
	Float:item_ry,
	Float:item_rz,
	item_int,
	item_vw,
	item_areaid,
	item_owner,
	item_ownertype,
	item_objectid
}
*/

public r@data_LoadItems(id){
	new rows,fields;
	cache_get_data(rows,fields);
	if(rows){
		cache_get_field_content(0,"id",mysql_query);
		gItemInfo[id][item_id] = strval(mysql_query);

		cache_get_field_content(0,"name",gItemInfo[id][item_name]);

		cache_get_field_content(0,"type",mysql_query);
		gItemInfo[id][item_type] = strval(mysql_query);

		cache_get_field_content(0,"extra",mysql_query);
		gItemInfo[id][item_extra] = strval(mysql_query);

		cache_get_field_content(0,"worn",mysql_query);
		gItemInfo[id][item_worn] = strval(mysql_query);

		cache_get_field_content(0,"model",mysql_query);
		gItemInfo[id][item_model] = strval(mysql_query);

		cache_get_field_content(0,"info",mysql_query);
		gItemInfo[id][item_info] = floatstr(mysql_query);

		cache_get_field_content(0,"x",mysql_query);
		gItemInfo[id][item_x] = floatstr(mysql_query);

		cache_get_field_content(0,"y",mysql_query);
		gItemInfo[id][item_y] = floatstr(mysql_query);

		cache_get_field_content(0,"z",mysql_query);
		gItemInfo[id][item_z] = floatstr(mysql_query);

		cache_get_field_content(0,"rx",mysql_query);
		gItemInfo[id][item_rx] = floatstr(mysql_query);

		cache_get_field_content(0,"ry",mysql_query);
		gItemInfo[id][item_ry] = floatstr(mysql_query);

		cache_get_field_content(0,"rz",mysql_query);
		gItemInfo[id][item_rz] = floatstr(mysql_query);

		cache_get_field_content(0,"owner",mysql_query);
		gItemInfo[id][item_owner] = strval(mysql_query);

		cache_get_field_content(0,"ownertype",mysql_query);
		gItemInfo[id][item_ownertype] = strval(mysql_query);

		gItemInfo[id][item_objectid] = CreateObject(
			gItemInfo[id][item_model], gItemInfo[id][item_x], gItemInfo[id][item_y], gItemInfo[id][item_z], 
			gItemInfo[id][item_rx], gItemInfo[id][item_ry], gItemInfo[id][item_rz]
		);

		/*witem_push(
			gItemInfo[id][item_id], gItemInfo[id][item_name], gItemInfo[id][item_type], gItemInfo[id][item_extra],
			gItemInfo[id][item_objectid], gItemInfo[id][item_x], gItemInfo[id][item_y], gItemInfo[id][item_z],0,
			0, gItemInfo[id][item_id], gItemInfo[id][item_ownertype], gItemInfo[id][item_owner]
		);*/

	}
	return 1;
}

