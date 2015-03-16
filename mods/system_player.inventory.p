/*----------------------------------------------------------------------------*\
					==============================
					   system_player_inventory.p
					==============================

	Descrição: Sistema de inventório do jogador.

	Declaração de callbacks: inv_
	Declaração de respostas: r@
	Declaração de váriaveis: inv_

						Dynamic Roleplay - BlueX (c)
\*----------------------------------------------------------------------------*/

#include <zcmd>
#include <YSI\y_hooks>
#include plugins\sscanf2
#include plugins\streamer

GetWeaponIDbyModel(model){
	switch(model){
		case 331: return 1;case 333: return 2;
		case 334: return 3;case 335: return 4;
		case 336: return 5;case 337: return 6;
		case 338: return 7;case 339: return 8;
		case 341: return 9;case 321: return 10;
		case 322: return 11;case 323: return 12;
		case 324: return 13;case 325: return 14;
		case 326: return 15;case 342: return 16;
		case 343: return 17;case 344: return 18;
		case 346: return 22;case 347: return 23;
		case 348: return 24;case 349: return 25;
		case 350: return 26;case 351: return 27;
		case 352: return 28;case 353: return 29;
		case 355: return 30;case 356: return 31;
		case 372: return 32;case 357: return 33;
		case 358: return 358;case 365: return 41;
		case 366: return 42;case 367: return 43;
	}
	return 0;
}

//forwards

forward r@inv_ShowInventory(playerid,page);


hook OnGameModeInit(){
	print("> system_player_inventory.p carregado com sucesso.");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid){
		case DIALOG_INV:{
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

			new page = GetPVarInt(playerid, "piv_pg"),
				nofitems = GetPVarInt(playerid, "piv_shwn");
			printf("%d page: %d",gettime(),page);
			if(page == 0 /*&& page2 == 0*/){
				//print("chamou page 0");
				if(listitem == (2 + nofitems)){
					inv_ShowInventory(playerid,page + 1);
					//print("chamando page+1");
					return 1;
				}

				new buffer[11], item;
				format(buffer,sizeof(buffer),"piv_%d", listitem - 2);
				//printf("index: %d | value: %d",listitem,GetPVarInt(playerid,buffer));
				item = GetPVarInt(playerid,buffer);

				new temp[300];
				format(temp, sizeof temp, "SELECT * FROM item_info_model_det WHERE id='%d'", item);
				//print(temp);
				mysql_function_query(mysql_connection,temp,true,"r@inv_InventoryDet","i",playerid);
				return 1;

			}
			if(page > 0){
				print("page > 1");
				if(listitem == 2){
					printf("return: page (%d)",page - 1);
					return inv_ShowInventory(playerid, page - 1);
				}
				if(listitem == (3 + nofitems))
					return inv_ShowInventory(playerid, page + 1);

				new buffer[11], item;
				format(buffer,sizeof(buffer),"piv_%d", listitem - 3);
				//printf("index: %d | value: %d",listitem,GetPVarInt(playerid,buffer));
				item = GetPVarInt(playerid,buffer);

				new temp[300];
				format(temp, sizeof temp, "SELECT * FROM item_info_model_det WHERE id='%d'", item);
				//print(temp);
				mysql_function_query(mysql_connection,temp,true,"r@inv_InventoryDet","i",playerid);
			}
		}
		case DIALOG_INV_MENU:{
			if(response){
				if(listitem == 0){
					//new type = GetPVarInt(playerid,"piv_type");
					//new id = GetPVarInt(playerid,"piv_id");
					//new cliptype = GetPVarInt(playerid,"piv_cliptype"); 
				}
				else if(listitem == 1){
					//DropItem(playerid,GetPVarInt(playerid,"piv_id"));
					return 1;
				}
				else if(listitem == 2){
					new page = GetPVarInt(playerid,"piv_page");
					return inv_ShowInventory(playerid,page);
				}
			}
		}
		case DIALOG_INV_MENU_2:{
			if(response){
				if(listitem == 0){
					/*
						Tirar, ou seja, ele vai guardar novamente o item.
					*/
					new type = GetPVarInt(playerid,"piv_type");
					new model = GetPVarInt(playerid,"piv_model");
					new id = GetPVarInt(playerid,"piv_id");
					if(type == ITEM_TYPE_ARMOUR){
						new buffer[15];
						format(buffer, sizeof buffer,"piv_index_%d",id);
						new index = GetPVarInt(playerid,buffer);
						RemovePlayerAttachedObject(playerid, index);
						format(buffer,sizeof buffer,"piv_useing_%d",id);
						SetPVarInt(playerid,buffer,0); //falso;
					}
					else if(type == ITEM_TYPE_WEP_PISTOL || type == ITEM_TYPE_WEP_SHOTGUN || type == ITEM_TYPE_WEP_REVOLVER){
						new buffer[15];
						format(buffer, sizeof buffer,"piv_using_%d",id);
						SetPVarInt(playerid,buffer,0);
						SetPlayerAmmo(playerid,GetWeaponIDbyModel(model),0);
					}
				}
				else if(listitem == 1){
					new type = GetPVarInt(playerid,"piv_type");
					new model = GetPVarInt(playerid,"piv_model");
					new id = GetPVarInt(playerid,"piv_id");
					if(type == ITEM_TYPE_ARMOUR){
						new buffer[15];
						format(buffer, sizeof buffer,"piv_index_%d",id);
						new index = GetPVarInt(playerid,buffer);
						RemovePlayerAttachedObject(playerid, index);
						format(buffer,sizeof buffer,"piv_useing_%d",id);
						SetPVarInt(playerid,buffer,0); //falso;
					}
					else if(type == ITEM_TYPE_WEP_PISTOL || type == ITEM_TYPE_WEP_SHOTGUN || type == ITEM_TYPE_WEP_REVOLVER){
						new buffer[15];
						format(buffer, sizeof buffer,"piv_using_%d",id);
						SetPVarInt(playerid,buffer,0);
						SetPlayerAmmo(playerid,GetWeaponIDbyModel(model),0);
					}
					//DropItem(playerid,GetPVarInt(playerid,"piv_id"));
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

stock inv_ShowInventory(playerid,page = 0){
	/*if(page > 0){
		SendClientMessage(playerid,-1,"Você não pode ter mais que 10 items.");
	}*/
	format(mysql_query,sizeof(mysql_query),"SELECT * FROM item_info_model_det WHERE owner=%d AND ownertype=0 LIMIT %d,%d",
		gPlayerInfo[playerid][player_id],page * 10,10
	);
	mysql_function_query(mysql_connection,mysql_query,true,"r@inv_ShowInventory","ii",playerid,page);
	return 1;
}

public r@inv_ShowInventory(playerid, page){
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

		format(buffer,sizeof buffer,"piv_%d",row);
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
	SetPVarInt(playerid, "piv_pg", page);
	SetPVarInt(playerid, "piv_shwn", rows);

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
	ShowPlayerDialog(playerid, DIALOG_INV, DIALOG_STYLE_LIST, "Inventário", tempdg, "Selecionar", "Sair");
	return 1;
}

forward r@inv_InventoryDet(playerid);
public r@inv_InventoryDet(playerid){
	static rows,fields;
	cache_get_data(rows,fields);
	
	if(rows){
		//printf("rows %d | fields: %d",rows,fields);
		cache_get_field_content(0,"type",mysql_query);
		SetPVarInt(playerid,"piv_type",strval(mysql_query));

		cache_get_field_content(0,"id",mysql_query);
		SetPVarInt(playerid,"piv_id",strval(mysql_query));

		cache_get_field_content(0,"cliptype",mysql_query);
		SetPVarInt(playerid,"piv_cliptype",strval(mysql_query));

		new buffer[15],using;
		format(buffer,sizeof buffer,"piv_using_%d",GetPVarInt(playerid,"piv_id"));
		//printf("using: %s | piv_using_id",buffer);
		using = GetPVarInt(playerid,buffer);
		//printf("using: %d",using);

		if(using == 0)
			ShowPlayerDialog(playerid,DIALOG_INV_MENU,2,"Opção","Usar\nJogar Fora\n<< Voltar","Selecionar","Sair");
		else if(using == 1)
			ShowPlayerDialog(playerid,DIALOG_INV_MENU_2,2,"Opção","Tirar\nJogar Fora\n<< Voltar","Selecionar","Sair");
	}
	return 1;
}

forward r@DeleteItem(item);
public r@DeleteItem(item){
	printf("Item (%d) eliminado da DB",item);
	return 1;
}

CMD:inv(playerid,params[]){
	inv_ShowInventory(playerid);
	return 1;
}