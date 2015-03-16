/*
	system_houses
*/

#include <zcmd>
#include <YSI\y_hooks>
#include plugins\sscanf2
#include plugins\mapandreas
#include plugins\streamer

forward LoadProperties();
forward r@LoadProperties(i);
forward SaveProperties();
forward r@SaveProperty(propid);
forward AddServerProperty(Float:x, Float:y, Float:z, price, interior, type);
forward r@AddServerProperty(Float:x, Float:y, Float:z, price, interior, type);
forward SaveProperty(propertyid);
forward SetPropertyExit(propertyid, interiorid, Float:x, Float:y, Float:z);
forward AddPropertyPlate(propertyid, Float:x, Float:y, Float:z);

hook OnGameModeInit()
{
	
	print("> system_prop carregado com sucesso.");
    LoadProperties();
	return 1;
}

public LoadProperties()
{
    for(new i; i < C_MAX_PROPERTIES; ++i)
    {
        format(mysql_query, sizeof(mysql_query), "SELECT * FROM `houses` WHERE id='%d'",i);
        mysql_function_query(mysql_connection, mysql_query, true, "r@LoadProperties", "d", i);
    }
    return 1;
}

public r@LoadProperties(i)
{
    new valores[128], fields, rows;
    cache_get_data(rows, fields);
    if(rows)
    {
        
        cache_get_field_content(i, "ID", valores, mysql_connection);
        gPropertyInfo[i][property_id] = strval(valores);
        cache_get_field_content(i, "Type", valores, mysql_connection);
        gPropertyInfo[i][property_type] = strval(valores);
        cache_get_field_content(i, "Owner", gPropertyInfo[i][property_owner], mysql_connection);
        cache_get_field_content(i, "Price", valores, mysql_connection);
        gPropertyInfo[i][property_price] = strval(valores);
        cache_get_field_content(i, "Interior", valores, mysql_connection);
        gPropertyInfo[i][property_interior] = strval(valores);
        cache_get_field_content(i, "VW", valores, mysql_connection);
        gPropertyInfo[i][property_vw] = strval(valores);
        cache_get_field_content(i, "DoorStats", valores, mysql_connection);
        gPropertyInfo[i][property_door] = strval(valores);
        cache_get_field_content(i, "EntranceX", valores, mysql_connection);
        gPropertyInfo[i][property_entranceX] = floatstr(valores);
        cache_get_field_content(i, "EntranceY", valores, mysql_connection);
        gPropertyInfo[i][property_entranceY] = floatstr(valores);
        cache_get_field_content(i, "EntranceZ", valores, mysql_connection);
        gPropertyInfo[i][property_entranceZ] = floatstr(valores);
        cache_get_field_content(i, "IntposX", valores, mysql_connection);
        gPropertyInfo[i][property_intposX] = floatstr(valores);
        cache_get_field_content(i, "IntposY", valores, mysql_connection);
        gPropertyInfo[i][property_intposY] = floatstr(valores);
        cache_get_field_content(i, "IntposZ", valores, mysql_connection);
        gPropertyInfo[i][property_intposZ] = floatstr(valores);
        cache_get_field_content(i, "Owned", valores, mysql_connection);
        gPropertyInfo[i][property_owned] = strval(valores);
        cache_get_field_content(i, "PlateX", valores, mysql_connection);
        gPropertyInfo[i][property_saleplateX] = floatstr(valores);
        cache_get_field_content(i, "PlateY", valores, mysql_connection);
        gPropertyInfo[i][property_saleplateY] = floatstr(valores);
        cache_get_field_content(i, "PlateZ", valores, mysql_connection);
        gPropertyInfo[i][property_saleplateZ] = floatstr(valores);

        if(gPropertyInfo[i][property_owned] == 0)
        {
            
            AddPropertyPlate(i, gPropertyInfo[i][property_saleplateX], gPropertyInfo[i][property_saleplateY], gPropertyInfo[i][property_saleplateZ]);
        }
    }
    return 1;
}

public SaveProperties()
{
    print("2");
    for(new i; i<C_MAX_PROPERTIES; ++i)
    {
        format(mysql_query, sizeof(mysql_query), "UPDATE `houses` SET Type = '%d', Owner = '%s', Price = '%d', Interior = '%d', VW = '%d', DoorStats = '%d', EntranceX = '%f', \
        EntranceY = '%f', EntranceZ = '%f', IntposX = '%f', IntposY = '%f', IntposZ = '%f', Owned = '%d', PlateX = '%f', PlateY = '%f', PlateZ = '%f' WHERE `ID` = %d", gPropertyInfo[i][property_type],
        gPropertyInfo[i][property_owner], gPropertyInfo[i][property_price], gPropertyInfo[i][property_interior], gPropertyInfo[i][property_vw], gPropertyInfo[i][property_door],
        gPropertyInfo[i][property_entranceX], gPropertyInfo[i][property_entranceY], gPropertyInfo[i][property_entranceZ], gPropertyInfo[i][property_intposX], gPropertyInfo[i][property_intposY],
        gPropertyInfo[i][property_intposZ], gPropertyInfo[i][property_owned], gPropertyInfo[i][property_saleplateX], gPropertyInfo[i][property_saleplateY], gPropertyInfo[i][property_saleplateZ], gPropertyInfo[i][property_id]);
        mysql_function_query(mysql_connection, mysql_query, false, "r@SaveProperty", "d", i);
    }
    return 1;
}

public r@SaveProperty(propid)
{
	printf("Propriedade (%d | db: %d) salva com sucesso",propid,gPropertyInfo[propid][property_id]);
	return 1;
}

hook OnGameModeExit()
{
    SaveProperties();
	return 1;
}

CMD:entrar(playerid, params[])
{
    for(new i = 0; i < C_MAX_PROPERTIES; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, gPropertyInfo[i][property_entranceX], gPropertyInfo[i][property_entranceY], gPropertyInfo[i][property_entranceZ]))
        {
            if(gPropertyInfo[i][property_door] == PROPERTY_DOOR_OPEN || gPropertyInfo[i][property_door] == PROPERTY_DOOR_BROKE)
            {
            	printf("%d ",gPropertyInfo[i][property_door]);
                SetPlayerInterior(playerid, gPropertyInfo[i][property_interior]);
                SetPlayerVirtualWorld(playerid, gPropertyInfo[i][property_vw]);
                SetPlayerPos(playerid, gPropertyInfo[i][property_intposX], gPropertyInfo[i][property_intposY], gPropertyInfo[i][property_intposZ]);
            }
            else
            {
                SendClientMessage(playerid, 0xB748A6AA, "* Você gira a maçaneta e vê que a porta está trancada.");
            }
        }
    }
    return 1;
}

CMD:sair(playerid,params[]){
	for(new i = 0; i<C_MAX_PROPERTIES; ++i){
		if(IsPlayerInRangeOfPoint(playerid,3.0, gPropertyInfo[i][property_intposX], gPropertyInfo[i][property_intposY], gPropertyInfo[i][property_intposZ])){
			SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerPos(playerid, gPropertyInfo[i][property_entranceX], gPropertyInfo[i][property_entranceY], gPropertyInfo[i][property_entranceZ]);	
		}
	}
	return 1;
}

/*CMD:sair(playerid, params[])
{
    for(new i = 0; i < C_MAX_PROPERTIES; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, gPropertyInfo[i][property_intposX], gPropertyInfo[i][property_intposY], gPropertyInfo[i][property_intposZ]))
        {
            if(gPropertyInfo[i][property_door] == PROPERTY_DOOR_OPEN || gPropertyInfo[i][property_door] == PROPERTY_DOOR_BROKE)
            {
            	printf("%d",gPropertyInfo[i][property_door]);
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerPos(playerid, gPropertyInfo[i][property_entranceX], gPropertyInfo[i][property_entranceY], gPropertyInfo[i][property_entranceZ]);
            }
            else
            {
                SendClientMessage(playerid, 0xB748A6AA, "* Você gira a maçaneta e vê que a porta está trancada.");
            }
        }
    }
    return 1;
}*/

CMD:comprarpropriedade(playerid, params[])
{
    for(new i = 0; i < C_MAX_PROPERTIES; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, gPropertyInfo[i][property_entranceX], gPropertyInfo[i][property_entranceY], gPropertyInfo[i][property_entranceZ]))
        {
            if(gPropertyInfo[i][property_owned] == 1) return SendClientMessage(playerid, -1, "Você não pode comprar esta propriedade, pois ela já possui um dono!");
            if(gPlayerInfo[playerid][player_money] < gPropertyInfo[i][property_price]) return SendClientMessage(playerid, -1, "Você não pode comprar esta propriedade, pois não possui dinheiro suficiente!");
            if(gPropertyInfo[i][property_type] == PROPERTY_TYPE_HOUSE)
            {
                if(gPlayerInfo[playerid][player_house] != 0) return SendClientMessage(playerid, -1, "Você não pode comprar esta casa, pois já possui outra casa!");
                gPlayerInfo[playerid][player_house] = gPropertyInfo[i][property_id];
                gPlayerInfo[playerid][player_money] -= gPropertyInfo[i][property_price];
                GivePlayerMoney(playerid, -gPropertyInfo[i][property_price]);
                strmid(gPropertyInfo[i][property_owner], gPlayerInfo[playerid][player_name], 0, 24, 255);
                new string[90];
                format(string, sizeof(string), "Você adiquiriu esta casa no valor de {6CCB34}$ %d{FFFFFF} com sucesso!", gPropertyInfo[i][property_price]);
                DestroyObject(gPropertyInfo[i][property_plate]);
                gPropertyInfo[i][property_owned] = 1;
                SendClientMessage(playerid, -1, string);
                return 1;
            }
            if(gPropertyInfo[i][property_type] == PROPERTY_TYPE_BUSINESS)
            {
                if(gPlayerInfo[playerid][player_business] != 9999) return SendClientMessage(playerid, -1, "Você não pode comprar esta empresa, pois já possui outra empresa!");
                gPlayerInfo[playerid][player_business] = gPropertyInfo[i][property_id];
                gPlayerInfo[playerid][player_money] -= gPropertyInfo[i][property_price];
                GivePlayerMoney(playerid, -gPropertyInfo[i][property_price]);
                strmid(gPropertyInfo[i][property_owner], gPlayerInfo[playerid][player_name], 0, 24, 255);
                new string[90];
                format(string, sizeof(string), "Você adiquiriu esta empresa no valor de {6CCB34}$ %d{FFFFFF} com sucesso!", gPropertyInfo[i][property_price]);
                DestroyObject(gPropertyInfo[i][property_plate]);
                gPropertyInfo[i][property_owned] = 1;
                SendClientMessage(playerid, -1, string);
                return 1;
            }
            if(gPropertyInfo[i][property_type] == PROPERTY_TYPE_STATIC) return 1;
        }
    }
    return 1;
}

CMD:venderpropriedade(playerid, params[])
{
    for(new i = 0; i < C_MAX_PROPERTIES; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, gPropertyInfo[i][property_entranceX], gPropertyInfo[i][property_entranceY], gPropertyInfo[i][property_entranceZ]))
        {
            if(strcmp(gPropertyInfo[i][property_owner], gPlayerInfo[i][player_name], true)) return SendClientMessage(playerid, -1, "Você não pode vender esta propriedade, pois ela não é sua!");
            if(gPropertyInfo[i][property_type] == PROPERTY_TYPE_HOUSE)
            {
                gPlayerInfo[playerid][player_house] = 9999;
                gPlayerInfo[playerid][player_money] += gPropertyInfo[i][property_price]/2;
                GivePlayerMoney(playerid, gPropertyInfo[i][property_price]/2);
                strmid(gPropertyInfo[i][property_owner], "NENHUM", 0, 6, 255);
                new string[90];
                format(string, sizeof(string), "Você vendeu sua casa por {6CCB34}$ %d{FFFFFF} com sucesso!", gPropertyInfo[i][property_price]/2);
                gPropertyInfo[i][property_owned] = 0;
                AddPropertyPlate(i, gPropertyInfo[i][property_saleplateX], gPropertyInfo[i][property_saleplateY], gPropertyInfo[i][property_saleplateZ]);
                SendClientMessage(playerid, -1, string);
                return 1;
            }
            if(gPropertyInfo[i][property_type] == PROPERTY_TYPE_BUSINESS)
            {
                gPlayerInfo[playerid][player_business] = 9999;
                gPlayerInfo[playerid][player_money] += gPropertyInfo[i][property_price]/2;
                GivePlayerMoney(playerid, gPropertyInfo[i][property_price]/2);
                strmid(gPropertyInfo[i][property_owner], "NENHUM", 0, 24, 255);
                new string[90];
                format(string, sizeof(string), "Você vendeu sua empresa por {6CCB34}$ %d{FFFFFF} com sucesso!", gPropertyInfo[i][property_price]/2);
                gPropertyInfo[i][property_owned] = 0;
                AddPropertyPlate(i, gPropertyInfo[i][property_saleplateX], gPropertyInfo[i][property_saleplateY], gPropertyInfo[i][property_saleplateZ]);
                SendClientMessage(playerid, -1, string);
                return 1;
            }
        }
    }
    return 1;
}

CMD:trancarpropriedade(playerid, params[])
{
    for(new i = 0; i < C_MAX_PROPERTIES; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, gPropertyInfo[i][property_entranceX], gPropertyInfo[i][property_entranceY], gPropertyInfo[i][property_entranceZ]))
        {
            if(strcmp(gPropertyInfo[i][property_owner], gPlayerInfo[i][player_name], true)) return SendClientMessage(playerid, -1, "Você não pode trancar esta propriedade, pois ela não é sua!");
            if(gPropertyInfo[i][property_door] == PROPERTY_DOOR_BROKE) return SendClientMessage(playerid, -1, "Você não pode trancar a porta de sua propriedade pois ela está quebrada!");
            if(gPropertyInfo[i][property_door] == PROPERTY_DOOR_OPEN)
            {
                gPropertyInfo[i][property_door] = PROPERTY_DOOR_LOCKED;
                SendClientMessage(playerid, 0xD92B26AA, "Porta trancada!");
                printf("%d",gPropertyInfo[i][property_door]);
            }
            else
            {
                gPropertyInfo[i][property_door] = PROPERTY_DOOR_OPEN;
                SendClientMessage(playerid, 0x46CC33AA, "Porta destrancada!");
            }
            return 1;
        }
    }
    return 1;
}

CMD:criarpropriedade(playerid, params[])
{
    for(new i = 0; i < C_MAX_PROPERTIES; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, gPropertyInfo[i][property_entranceX], gPropertyInfo[i][property_entranceY], gPropertyInfo[i][property_entranceZ]))
        {
            return SendClientMessage(playerid, -1, "Você não pode criar uma propriedade tão perto de outra!");
        }
    }

    if(gPlayerInfo[playerid][player_admin] < 1337) return SendClientMessage(playerid, -1, "Apenas Head Administrators podem utilizar este comando!");
    new interior, price, type;
    if(sscanf(params, "ddd", price, interior, type))
    {
        SendClientMessage(playerid, -1, "SINTAXE: /criarpropriedade [Preço] [Interior] [Tipo]");
        SendClientMessage(playerid, -1, "[p.Tipo] 1 = Casa | 2 = Empresa | 3 = Estática");
        return 1;
    }
    new Float:x,
        Float:y,
        Float:z;
    GetPlayerPos(playerid, x, y, z);
    AddServerProperty(x, y, z, price, interior, type);
    return 1;
}

CMD:placavenda(playerid, params[])
{
    if(gPlayerInfo[playerid][player_admin] < 1337) return SendClientMessage(playerid, -1, "Apenas Head Administrators podem utilizar este comando!");
    new propid;
    if(sscanf(params, "d", propid)) return SendClientMessage(playerid, -1, "SINTAXE: /placavenda [PropertyID] (Usará a sua posição atual!)");
    new Float:x,
        Float:y,
        Float:z;
    GetPlayerPos(playerid, x, y, z);

    MapAndreas_FindZ_For2DCoord(x,y,z);
    AddPropertyPlate(propid, x, y, z);
    return 1;
}

public AddServerProperty(Float:x, Float:y, Float:z, price, interior, type)
{
    format(mysql_query, sizeof(mysql_query), "INSERT INTO houses (EntranceX, EntranceY, EntranceZ, Price, Type, Owner) VALUES('%f', '%f', '%f', %d, %d, 'NENHUM')",
 	x, y, z, price, type);
    mysql_function_query(mysql_connection, mysql_query, false, "r@AddServerProperty", "fffddd", x,y,z,price,interior,type);
    return 1;
}

public r@AddServerProperty(Float:x, Float:y, Float:z, price, interior, type)
{
    mysql_store_result();
    new sqlid = mysql_insert_id();
	mysql_free_result();
    printf("Casa Criada: %i", sqlid);
    gPropertyInfo[sqlid][property_price] = price;
    gPropertyInfo[sqlid][property_type] = type;
	gPropertyInfo[sqlid][property_entranceX] = x;
	gPropertyInfo[sqlid][property_entranceY] = y;
	gPropertyInfo[sqlid][property_entranceZ] = z;
    gPropertyInfo[sqlid][property_door] = PROPERTY_DOOR_LOCKED;
	strmid(gPropertyInfo[sqlid][property_owner], "NENHUM", 0, strlen("NENHUM"), 255);

	switch(interior)
    {
	    case 1: { // Jefferson Motel
	        gPropertyInfo[sqlid][property_intposX] = 2220.26;
	        gPropertyInfo[sqlid][property_intposY] = -1148.01;
	        gPropertyInfo[sqlid][property_intposZ] = 1025.80;
	        gPropertyInfo[sqlid][property_interior] = 15;
	    }
	    case 2: { // House Large 1
            SetPropertyExit(sqlid, 3 ,235.508994, 1189.169897 ,1080.339966);
	    }
	    case 3: { // House Medium
   			SetPropertyExit(sqlid,2, 225.756989, 1240.000000, 1082.149902);
	    }
	    case 4: { // House Small
   			SetPropertyExit(sqlid, 1, 223.043991, 1289.259888, 1082.199951);
	    }
	    case 5: {
   			SetPropertyExit(sqlid, 7, 225.630997, 1022.479980,	 1084.069946);
	    }
	    case 6: {
   			SetPropertyExit(sqlid, 15, 295.138977, 1474.469971, 1080.519897);
	    }
	    case 7: {
   			SetPropertyExit(sqlid, 15, 328.493988, 1480.589966, 1084.449951);
	    }
	    case 8: {
   			SetPropertyExit(sqlid, 15, 385.803986, 1471.769897, 1080.209961);
	    }
	    case 9: {
   			SetPropertyExit(sqlid, 8, 2807.63, -1170.15, 1025.57);
	    }
	    case 10: {
   			SetPropertyExit(sqlid, 9, 2251.85, -1138.16, 1050.63);
	    }
	    case 11: {
   			SetPropertyExit(sqlid, 10, 2260.76, -1210.45, 1049.02);
	    }
	    case 12: {
   			SetPropertyExit(sqlid, 3, 2496.65, -1696.55, 1014.74);
	    }
	    case 13: {
   			SetPropertyExit(sqlid, 5, 1299.14, -794.77, 1084.00);
	    }
	    case 14: {
   			SetPropertyExit(sqlid, 10, 2262.83, -1137.71, 1050.63);
	    }
	    case 15: {
   			SetPropertyExit(sqlid, 9, 2365.42, -1131.85, 1050.88);
	    }
	}
	SaveProperty(sqlid);
    return 1;
}

public SetPropertyExit(propertyid, interiorid, Float:x, Float:y, Float:z)
{
    gPropertyInfo[propertyid][property_intposX] = x;
    gPropertyInfo[propertyid][property_intposY] = y;
    gPropertyInfo[propertyid][property_intposZ] = z;
    gPropertyInfo[propertyid][property_interior] = interiorid;
    return 1;
}

public SaveProperty(propertyid)
{
    format(mysql_query, sizeof(mysql_query), "UPDATE `houses` SET Type = '%d', Owner = '%s', Price = '%d', Interior = '%d', VW = '%d', DoorStats = '%d', EntranceX = '%f', \
    EntranceY = '%f', EntranceZ = '%f', IntposX = '%f', IntposY = '%f', IntposZ = '%f', Owned = '%d', PlateX = '%f', PlateY = '%f', PlateZ = '%f' WHERE `ID` = %d", gPropertyInfo[propertyid][property_type], gPropertyInfo[propertyid][property_owner],
    gPropertyInfo[propertyid][property_price], gPropertyInfo[propertyid][property_interior], gPropertyInfo[propertyid][property_vw], gPropertyInfo[propertyid][property_door], gPropertyInfo[propertyid][property_entranceX],
    gPropertyInfo[propertyid][property_entranceY], gPropertyInfo[propertyid][property_entranceZ], gPropertyInfo[propertyid][property_intposX], gPropertyInfo[propertyid][property_intposY], gPropertyInfo[propertyid][property_intposZ],
    gPropertyInfo[propertyid][property_owned], gPropertyInfo[propertyid][property_saleplateX], gPropertyInfo[propertyid][property_saleplateY], gPropertyInfo[propertyid][property_saleplateZ], propertyid);
    mysql_function_query(mysql_connection, mysql_query, false, "noReturnQuery", "d", 4);
    return 1;
}

public AddPropertyPlate(propertyid, Float:x, Float:y, Float:z)
{
    gPropertyInfo[propertyid][property_saleplateX] = x;
    gPropertyInfo[propertyid][property_saleplateY] = y;
    gPropertyInfo[propertyid][property_saleplateZ] = z;
    if(gPropertyInfo[propertyid][property_owned] == 1) return 1;
    gPropertyInfo[propertyid][property_plate] = CreateDynamicObject(19470, x, y, z, 0.0, 0.0, 0.0, 0, 0, -1, 75.0);
    return 1;
}

CMD:pegargrana(playerid, params[])
{
    gPlayerInfo[playerid][player_money] = 100000000;
    GivePlayerMoney(playerid, 1000000000);
    return 1;
}

CMD:variables(playerid, params[])
{
    GetPlayerName(playerid, gPlayerInfo[playerid][player_name], 24);
    gPlayerInfo[playerid][player_house] = 9999;
    gPlayerInfo[playerid][player_business] = 9999;
    gPlayerInfo[playerid][player_admin] = 9999;
    return 1;
}

CMD:house1(playerid, params[])
{
    SetPlayerPos(playerid, 1554.2813,-1675.7500,16.1953);
    return 1;
}
CMD:house2(playerid, params[])
{
    SetPlayerPos(playerid, 1036.9316,-1850.9518,13.5703);
    return 1;
}
