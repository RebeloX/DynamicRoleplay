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
#include plugins\witem
#include plugins\mapandreas
#include <modelsizes>

forward Item_LoadWorld();
forward r@Item_LoadWorld();
forward Item_LoadItem(rowid);
forward r@Item_Pickup(playerid, WItem:itemid);

new Text:itemHoverBg;
new Text:itemHoverHint;
new PlayerText:itemHoverItem[MAX_PLAYERS];

new WItem:gLastHover[MAX_PLAYERS];

hook OnGameModeInit(){
	print("> system_items carregado com sucesso.");

	Item_LoadWorld();

	itemHoverBg = TextDrawCreate(315.750000, 374.833343, "usebox");
	TextDrawLetterSize(itemHoverBg, 0.187499, 2.561386);
	TextDrawTextSize(itemHoverBg, 219.875000, 197.750015);
	TextDrawAlignment(itemHoverBg, 2);
	TextDrawColor(itemHoverBg, 0);
	TextDrawUseBox(itemHoverBg, true);
	TextDrawBoxColor(itemHoverBg, 102);
	TextDrawSetShadow(itemHoverBg, 0);
	TextDrawSetOutline(itemHoverBg, 0);
	TextDrawFont(itemHoverBg, 0);
	itemHoverHint = TextDrawCreate(313.125000, 387.333404, "Aperte ~k~~PED_LOCK_TARGET~ para detalhes");
	TextDrawLetterSize(itemHoverHint, 0.253124, 1.004999);
	TextDrawTextSize(itemHoverHint, 640.0, 480.0);
	TextDrawAlignment(itemHoverHint, 2);
	TextDrawColor(itemHoverHint, -1);
	TextDrawSetShadow(itemHoverHint, 0);
	TextDrawSetOutline(itemHoverHint, 1);
	TextDrawBackgroundColor(itemHoverHint, 51);
	TextDrawFont(itemHoverHint, 1);
	TextDrawSetProportional(itemHoverHint, 1);
	return 1;
}

hook OnPlayerConnect(playerid){
	itemHoverItem[playerid] = CreatePlayerTextDraw(playerid, 315.000000, 375.083435, "  ");
	PlayerTextDrawLetterSize(playerid, itemHoverItem[playerid], 0.276249, 1.168331);
	PlayerTextDrawTextSize(playerid, itemHoverItem[playerid], 640.0, 480.0);
	PlayerTextDrawAlignment(playerid, itemHoverItem[playerid], 2);
	PlayerTextDrawColor(playerid, itemHoverItem[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, itemHoverItem[playerid], 0);
	PlayerTextDrawSetOutline(playerid, itemHoverItem[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, itemHoverItem[playerid], 51);
	PlayerTextDrawFont(playerid, itemHoverItem[playerid], 1);
	PlayerTextDrawSetProportional(playerid, itemHoverItem[playerid], 1);
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys){
	if(gPlayerInfo[playerid][player_status] != PLAYER_STATUS_SPAWNED)
		return 1;
	if(PRESSED(KEY_HANDBRAKE)){
		new area = witem_getarea(gLastHover[playerid]);
		if(IsPlayerInDynamicArea(playerid,area)){
			if(newkeys & KEY_WALK){
				if(witem_gettype(gLastHover[playerid]) >= 1000){
					SendClientMessage(playerid, -1, "Você não pode simplesmente pegar tipo de item!");
					return 1;
				}
				new tmp[500];
				format(tmp, sizeof tmp,
					"set @a = concat('update item_info set ownertype=0, owner=%d, x=0, y=0, z=0, rx=0, ry=0, rz=0 \
					where id=%d and ownertype=2 limit ', (select count(*) from item_info where ownertype=0 and owner=%d) < %d);",
					gPlayerInfo[playerid][player_id],
					witem_getrow(gLastHover[playerid]),
					gPlayerInfo[playerid][player_id],
					10
				);
				mysql_function_query(mysql_connection, tmp, false, "", "");
				mysql_function_query(mysql_connection, "prepare stmt1 from @a;",false,"","");
				mysql_function_query(mysql_connection, "execute stmt1;",false,"r@Item_Pickup","ii",playerid,_:gLastHover[playerid]);
			} else {
				if(witem_gettype(gLastHover[playerid]) >= 1000){

				}
				new name[64];
				witem_getname(gLastHover[playerid], name);
				ShowPlayerDialog(playerid, DIALOG_WITEM, DIALOG_STYLE_LIST,
					name, "Pegar\nUsar\nInfo","Selecionar", "Sair"
				);
			}
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	if(gPlayerInfo[playerid][player_status] != PLAYER_STATUS_SPAWNED)
		return 1;

	switch(dialogid){
		case DIALOG_WITEM:{
			if(response){
				if(listitem == 0){
					new tmp[500];
					format(tmp, sizeof tmp,
						"set @a = concat('update item_info set ownertype=0, owner=%d, x=0, y=0, z=0, rx=0, ry=0, rz=0 where id=%d and \
						ownertype=2 limit ', (select count(*) from item_info where ownertype=0 and owner=%d) < %d);",
						gPlayerInfo[playerid][player_id],
						witem_getrow(gLastHover[playerid]),
						gPlayerInfo[playerid][player_id],
						10
					);
					mysql_function_query(mysql_connection, tmp, false, "", "");
					mysql_function_query(mysql_connection, "prepare stmt1 from @a;",false,"","");
					mysql_function_query(mysql_connection, "execute stmt1;",false,"r@Item_Pickup","ii",playerid,_:gLastHover[playerid]);	
				}
				else if(listitem == 1){
					if(witem_gettype(gLastHover[playerid]))
						return SendClientMessage(playerid,-1,"Este item não pode ser usado no chão.");
				}
			}
		}
	}
	return 1;
}

#define MAX_WORLD_ITENS 10000

// ----------------------- //

public Item_LoadWorld(){
	print("carregando items");
	format(mysql_query,sizeof mysql_query,"SELECT * FROM item_info_ground LIMIT %d",#MAX_WORLD_ITENS);
	mysql_function_query(mysql_connection,mysql_query, true, "r@Item_LoadWorld","");
	printf("carregando...");
	return 1;
}

public r@Item_LoadWorld(){
	new rows,fields, index = -1;
	cache_get_data(rows,fields, mysql_connection);

	printf("rows: %d",rows);

	new buffer[32];
	while(++index < rows){
		static
			id, name[32], type, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz,
			int, vw, model, extra, ownertype, owner;

		cache_get_field_content(index, "id", buffer, mysql_connection);
		id = strval(buffer);

		cache_get_field_content(index, "name", name, mysql_connection);
		cache_get_field_content(index, "type", buffer, mysql_connection);
		type = strval(buffer);

		cache_get_field_content(index, "x", buffer, mysql_connection);
		x = floatstr(buffer);
		printf("%f",x);
		cache_get_field_content(index, "y", buffer, mysql_connection);
		y = floatstr(buffer);
		cache_get_field_content(index, "z", buffer, mysql_connection);
		z = floatstr(buffer);
		cache_get_field_content(index, "rx", buffer, mysql_connection);
		rx = floatstr(buffer);
		cache_get_field_content(index, "ry", buffer, mysql_connection);
		ry = floatstr(buffer);
		cache_get_field_content(index, "rz", buffer, mysql_connection);
		rz = floatstr(buffer);

		cache_get_field_content(index, "int", buffer, mysql_connection);
		int = strval(buffer);
		cache_get_field_content(index, "vw", buffer, mysql_connection);
		vw = strval(buffer);
		cache_get_field_content(index, "model", buffer, mysql_connection);
		model = strval(buffer);
		cache_get_field_content(index, "extra", buffer, mysql_connection);
		extra = strval(buffer);

		cache_get_field_content(index, "ownertype", buffer, mysql_connection);
		ownertype = strval(buffer);
		cache_get_field_content(index, "owner", buffer, mysql_connection);
		owner = strval(buffer);

		if(type != ITEM_TYPE_TRAFFIC)
			MapAndreas_FindZ_For2DCoord(x,y,z);
		printf("%f %f %f",x,y,z);

		new obj = CreateDynamicObject(model, x, y, z, rx, ry, rz, vw, int, -1, 75.0);

		new Float:radius = GetColSphereRadius(model);
		if(radius > 0){
			radius += 1.0;
		} else {
			radius += 1.5;
		}

		new area = CreateDynamicSphere(x, y, z, radius, vw, int, -1);
		witem_push(id, name, type, extra, obj, x, y, z, int, vw, area, ownertype, owner);

		for(new p; p < MAX_PLAYERS; ++p){
			if(IsPlayerInRangeOfPoint(p, 75.0, x, y, z)){
				Streamer_UpdateEx(p, x, y, z, vw, int);
			}
		}

		printf("Item %d | nome: %s |  obj: %d | model: %d | cords: %f %f %f",id,name,obj,model,x,y,z);

	}
	return 1;
}

public OnWItemDestroy(obj, area){
	DestroyDynamicObject(obj);
	DestroyDynamicArea(area);
	return 1;
}

public Item_LoadItem(rowid){
	new WItem:item = witem_getbyrow(rowid);
	if(_:item != -1){
		witem_destroy(item);
	}
	new tmp[200];
	format(tmp, sizeof tmp, "select * from item_info_model_det where id=%d",rowid);
	mysql_function_query(mysql_connection, tmp, true, "r@Item_LoadWorld", "");
	return 1;
}

Item_OnPlayerEnterDynamicArea(playerid, areaid){
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
		return 1;

	new WItem:item = witem_getbyarea(areaid);
	if(_:item == -1) return 1;

	gLastHover[playerid] = item;

	new type = witem_gettype(item);
	TextDrawShowForPlayer(playerid, itemHoverBg);

	if(type < 1000){
		TextDrawShowForPlayer(playerid, itemHoverHint);
	}

	new name[64]; witem_getname(item, name);
	parsetdtext(name);
	PlayerTextDrawSetString(playerid, itemHoverItem[playerid], name);
	PlayerTextDrawShow(playerid, itemHoverItem[playerid]);
	return 1;
}

Item_OnPlayerLeaveDynamicArea(playerid, areaid){
	new WItem:item = witem_getbyarea(areaid);
	if(_:item == -1) return 1;

	if(gLastHover[playerid] == item){
		gLastHover[playerid] = WItem:0;
		TextDrawHideForPlayer(playerid, itemHoverBg);
		TextDrawHideForPlayer(playerid, itemHoverHint);
		PlayerTextDrawHide(playerid, itemHoverItem[playerid]);
	}
	return 1;
}

public r@Item_Pickup(playerid, WItem:itemid){
	mysql_store_result(mysql_connection);
	if(mysql_affected_rows(mysql_connection)){
		Item_OnPlayerLeaveDynamicArea(playerid, witem_getarea(itemid));
		witem_destroy(itemid);
		SendClientMessage(playerid, -1, "Você pegou esse item com sucesso.");
	} else {
		SendClientMessage(playerid, -1, "Houve um erro ao pegar o item. {FFFFFF}Verifique se o item está no chão ou você tem espaço no inventário.");
	}
	mysql_free_result(mysql_connection);
	return 1;
}

forward item_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
public item_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz){
	if(response == EDIT_RESPONSE_FINAL)
	{
		format(mysql_query,sizeof mysql_query,
			"UPDATE `item_info` SET ownertype=2, owner=0, x='%f', y='%f', z='%f', rx='%f', ry='%f', rz='%f' WHERE `id`=%d",
			x,y,z,rx,ry,rz,GetPVarInt(playerid,"piv_id")
		);
		mysql_function_query(mysql_connection,mysql_query,false,"","");
		DestroyDynamicObject(objectid);
		Item_LoadItem(GetPVarInt(playerid,"piv_id"));
	}
 
	if(response == EDIT_RESPONSE_CANCEL)
	{
		DestroyDynamicObject(objectid);
	}
}