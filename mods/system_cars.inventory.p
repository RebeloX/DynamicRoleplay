/*
	system_cars.inventory.p
*/

#include <YSI\y_hooks>
#include <zcmd>

hook OnGameModeInit(){
	print("> system_cars.inventory.p carregado com sucesso.");
	return 1;
}

forward r@car_ShowInventory(playerid, vehicleid, page);

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid){
		case DIALOG_CAR_INV:{
			if(!response)
				return 1;

			if(listitem == 0) /* Botão Estatísticas/Informações */
			{
				SendClientMessage(playerid,-1,"lal0");
				return 1;
			}
			if(listitem == 1) /* Botão Opções */
			{
				SendClientMessage(playerid,-1,"lal1");
				return 1;				
			}

			new page = GetPVarInt(playerid, "civ_pg"),
				nofitems = GetPVarInt(playerid, "civ_shwn");
			if(page == 0 /*&& page2 == 0*/){
				//print("chamou page 0");
				if(listitem == (2 + nofitems)){
					inv_ShowInventory(playerid,page + 1);
					//print("chamando page+1");
					return 1;
				}

				new buffer[11], item;
				format(buffer,sizeof(buffer),"civ_%d", listitem - 2);
				//printf("index: %d | value: %d",listitem,GetPVarInt(playerid,buffer));
				item = GetPVarInt(playerid,buffer);

				new temp[300];
				format(temp, sizeof temp, "SELECT * FROM item_info_model_det WHERE id='%d'", item);
				//print(temp);
				mysql_function_query(mysql_connection,temp,true,"r@car_InventoryDet","i",playerid);
				return 1;

			}
			if(page > 0){
				if(listitem == 2){
					return inv_ShowInventory(playerid, page - 1);
				}
				if(listitem == (3 + nofitems))
					return inv_ShowInventory(playerid, page + 1);

				new buffer[11], item;
				format(buffer,sizeof(buffer),"civ_%d", listitem - 3);
				//printf("index: %d | value: %d",listitem,GetPVarInt(playerid,buffer));
				item = GetPVarInt(playerid,buffer);

				new temp[300];
				format(temp, sizeof temp, "SELECT * FROM item_info_model_det WHERE id='%d'", item);
				//print(temp);
				mysql_function_query(mysql_connection,temp,true,"r@car_InventoryDet","i",playerid);
			}
		}
		case DIALOG_CAR_INV_MENU:{
			if(response){
				if(listitem == 0){ //pegar
					new tmp[500];
					format(tmp, sizeof tmp,
						"set @a = concat('update item_info set ownertype=0, owner=%d, x=0, y=0, z=0, rx=0, ry=0, rz=0 \
						where id=%d and ownertype=1 limit ', (select count(*) from item_info where ownertype=0 and owner=%d) < %d);",
						gPlayerInfo[playerid][player_id],
						GetPVarInt(playerid,"civ_id"),
						gPlayerInfo[playerid][player_id],
						10
					);
					mysql_function_query(mysql_connection, tmp, false, "", "");
					mysql_function_query(mysql_connection, "prepare stmt1 from @a;",false,"","");
					mysql_function_query(mysql_connection, "execute stmt1;",false,"r@Car_ItemPickup","i",playerid);
				}
				else if(listitem == 1){ //dropar
					//DropItem(playerid,GetPVarInt(playerid,"piv_id"));
					return 1;
				}
				else if(listitem == 2){
					new page = GetPVarInt(playerid,"piv_page");
					return inv_ShowInventory(playerid,page);
				}
			}
		}
	}
	return 1;
}


stock car_ShowInventory(playerid, vehicleid, page = 0){
	/////////////////////////////////////////////////////item_info_model_det
	print("chamou2");
	format(mysql_query,sizeof(mysql_query),"SELECT * FROM item_info_model_det WHERE owner=%d AND ownertype=1 LIMIT %d,%d",
		gCarInfo[wcar_getid(vehicleid)][car_id],page * 10,10
	);
	mysql_function_query(mysql_connection,mysql_query,true,"r@car_ShowInventory","ddd",playerid, vehicleid, page);
	return 1;
}


public r@car_ShowInventory(playerid, vehicleid, page){
	new rows,fields;
	cache_get_data(rows,fields);

	if(page > 0 && !rows){
		inv_ShowInventory(playerid);
		return 1;
	}

	//getdata
	new buffer[32];
	enum item_response{
		response_id,
		response_name[64],
		response_worn,
		response_type,
		response_faction,
		Float:response_info,
		response_model
	} new response[10][item_response];

	for(new row = 0; row < rows; row++) {
		cache_get_field_content(row, "id", buffer);
		//printf("row: %d | id: %d",row,strval(buffer));
		response[row][response_id] = strval(buffer);
		//printf("response: %d",response[row][response_id]);

		format(buffer,sizeof buffer,"civ_%d",row);
		//printf("[SET]index: %d | value: %d",row,response[row][response_id]);
		SetPVarInt(playerid,buffer,response[row][response_id]);
		//printf("[GET]index: %d | value: %d",row,GetPVarInt(playerid,buffer));

		cache_get_field_content(row, "name", response[row][response_name]);
		cache_get_field_content(row, "worn", buffer);
		response[row][response_worn] = strval(buffer);
		cache_get_field_content(row, "faction", buffer);
		response[row][response_faction] = strval(buffer);
		cache_get_field_content(row, "type", buffer);
		response[row][response_type] = strval(buffer);
		cache_get_field_content(row, "faction", buffer);
		response[row][response_faction] = strval(buffer);
		cache_get_field_content(row, "model", buffer);
		response[row][response_model] = strval(buffer);
		cache_get_field_content(row, "info", buffer);
		response[row][response_info] = floatstr(buffer);

	}
	SetPVarInt(playerid, "civ_pg", page);
	SetPVarInt(playerid, "civ_shwn", rows);

	//displaying data//
	new tempdg[1000]; //4kb of data
	strcat(tempdg,"Estatísticas/Informações...\n");
	strcat(tempdg,"Opções...\n");

	if(rows){
		if(page > 0){
			strcat(tempdg,"<< Anterior\n");
		}
		new index = -1; while(++index < rows){
			new itemid = (index + 1) + (page * 10);
			new color[9];
			if(response[index][response_faction]){
				if(response[index][response_faction] == 1) {
							color = "{FFF5B8}";
						} else if(response[index][response_faction] == 2) {
							color = "{B8FFB9}";
						}
			}
			new tmprow[80];
			format(tmprow, sizeof tmprow,
						"%s%2d - %s ", color, itemid, response[index][response_name]);
			if(response[index][response_worn]) {
				strcat(tmprow," E");
			}
			strcat(tmprow, "\n");
			strcat(tempdg, tmprow);

		}
		if(rows == 10) {
			strcat(tempdg,"Próximo >>\n");
		}
	}
	if(page > 0){
		SetPVarInt(playerid,"page",page);
		printf("(2) page: %d",GetPVarInt(playerid,"page"));
	}
	ShowPlayerDialog(playerid, DIALOG_CAR_INV, DIALOG_STYLE_LIST, "Inventário", tempdg, "Selecionar", "Sair");
	return 1;
}

forward r@car_InventoryDet(playerid);
public r@car_InventoryDet(playerid){
	static rows,fields;
	cache_get_data(rows,fields);
	
	if(rows){
		//printf("rows %d | fields: %d",rows,fields);
		cache_get_field_content(0,"type",mysql_query);
		SetPVarInt(playerid,"piv_type",strval(mysql_query));

		cache_get_field_content(0,"model",mysql_query);
		//printf("row: %d | model: %d",rows,strval(mysql_query));
		SetPVarInt(playerid,"civ_model",strval(mysql_query));

		cache_get_field_content(0,"id",mysql_query);
		//printf("row: %d | id: %d",rows,strval(mysql_query));
		SetPVarInt(playerid,"civ_id",strval(mysql_query));

		cache_get_field_content(0,"cliptype",mysql_query);
		SetPVarInt(playerid,"civ_cliptype",strval(mysql_query));

		ShowPlayerDialog(playerid,DIALOG_CAR_INV_MENU,2,"Opção","Pegar\nJogar Fora\n<< Voltar","Selecionar","Sair");
	}
	return 1;
}

forward r@Car_ItemPickup(playerid);
public r@Car_ItemPickup(playerid){
	mysql_store_result(mysql_connection);
	if(mysql_affected_rows(mysql_connection)){
		SendClientMessage(playerid, -1, "Você pegou esse item com sucesso.");
	} else {
		SendClientMessage(playerid, 0xFF0000AA, "Houve um erro ao pegar o item. {FFFFFF}Verifique se o item está no chão ou você tem espaço no inventário.");
	}
	mysql_free_result(mysql_connection);
	return 1;
}

CMD:portamalas(playerid, params[]){
	new result[8];
	if(sscanf(params,"s[8]",result))
		return SendClientMessage(playerid,-1,"USE: /portamalas [abrir / fechar / ver]");
	new Float:_x,Float:_y,Float:_z;
	for(new i; i<MAX_VEHICLES; ++i){
		GetVehiclePos(i,_x,_y,_z);
		if(IsPlayerInRangeOfPoint(playerid,10.0,_x,_y,_z)){
			printf("tá no range!");
			printf("x: %f y: %f z: %f v: %d",_x, _y, _z,i);
			new engine, lights, alarm, doors, bonnet, boot, objective;
			if(!strcmp(params,"abrir")){
				GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
				if(doors == 0){
					SetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, 1, objective);
					return SendClientMessage(playerid,-1,"Você abriu o portamalas.");
				}
				else if(doors == 1)
					return SendClientMessage(playerid,-1,"Veiculo trancado.");
			}
			else if(!strcmp(params,"fechar")){
				GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
				if(boot == 1){
					SetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, 0, objective);
					return SendClientMessage(playerid,-1,"Você fechou o portamalas.");
				}
				else if(boot == 0)
					return SendClientMessage(playerid,-1,"Este veiculo já tem o portamalas fechado.");
			}
			else if(!strcmp(params,"ver")){
				GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
				if(boot == 1){
					car_ShowInventory(playerid, wcar_getid(i));
					printf("open inv: %d",wcar_getid(i));
				}
				else
					return SendClientMessage(playerid,-1,"O portamalas não está aberto.");
			}
		}
	}
	return 1;
}