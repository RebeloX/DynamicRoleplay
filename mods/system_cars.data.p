/*----------------------------------------------------------------------------*\
					==============================
					   system_player_inventory.p
					==============================

	Descrição: Sistema de inventório do jogador.

	Declaração de callbacks: data_
	Declaração de respostas: r@
	Declaração de váriaveis: data_

						Dynamic Roleplay - BlueX (c)
\*----------------------------------------------------------------------------*/

#include <YSI\y_hooks>

/*GetXYBehindVehicle(vehicleid, &Float:q, &Float:w, Float:distance)
{
    new Float:a;
    GetVehiclePos(vehicleid, q, w, a);
    q = gCarInfo[vehicleid][car_x];
    w = gCarInfo[vehicleid][car_y];
    a = gCarInfo[vehicleid][car_z];
    a = gCarInfo[vehicleid][car_angle];
    q += (distance * -floatsin(-a, degrees));
    w += (distance * -floatcos(-a, degrees));
}*/

stock GetPosBehindVehicle(vehicleid, &Float:x, &Float:y, &Float:z, Float:offset=0.5)
{
    new Float:vehicleSize[3];
    GetVehicleModelInfo(gCarInfo[vehicleid][car_model], VEHICLE_MODEL_INFO_SIZE, vehicleSize[0], vehicleSize[1], vehicleSize[2]);
    GetXYBehindVehicle(vehicleid, x, y, (vehicleSize[1]/2)+offset);
    return 1;
}

hook OnGameModeInit(){
	print("> system_cars.data carregado com sucesso.");
	for(new i=0; i<C_MAX_CARS; ++i){
		data_LoadCars(i);
	}
	return 1;
}

forward data_LoadCars(carid);
forward r@data_LoadCars(carid);

forward data_SaveCars();
forward r@data_SaveCars();

forward data_CreateCar(playerid,owner,ownertype,model,Float:x,Float:y,Float:z,Float:angle,color1,color2);
forward r@data_CreateCar(playerid,owner,ownertype,model,Float:x,Float:y,Float:z,Float:angle,color1,color2);

public data_LoadCars(carid){
	format(mysql_query,sizeof(mysql_query),"SELECT * FROM `cars` WHERE id='%d'",carid);
	mysql_function_query(mysql_connection,mysql_query,true,"r@data_LoadCars","d",carid);
	return 1;
}

public r@data_LoadCars(carid){
	new rows,fields;
	cache_get_data(rows,fields);
	if(rows){
		cache_get_field_content(0,"id",mysql_query);
		gCarInfo[carid][car_id] = strval(mysql_query);

		cache_get_field_content(0,"owner",mysql_query);
		gCarInfo[carid][car_owner] = strval(mysql_query);

		cache_get_field_content(0,"ownertype",mysql_query);
		gCarInfo[carid][car_ownertype] = strval(mysql_query);

		cache_get_field_content(0,"model",mysql_query);
		gCarInfo[carid][car_model] = strval(mysql_query);

		cache_get_field_content(0,"x",mysql_query);
		gCarInfo[carid][car_x] = floatstr(mysql_query);

		cache_get_field_content(0,"y",mysql_query);
		gCarInfo[carid][car_y] = floatstr(mysql_query);

		cache_get_field_content(0,"z",mysql_query);
		gCarInfo[carid][car_z] = floatstr(mysql_query);

		cache_get_field_content(0,"angle",mysql_query);
		gCarInfo[carid][car_angle] = floatstr(mysql_query);

		cache_get_field_content(0,"respawn",mysql_query);
		gCarInfo[carid][car_respawn] = strval(mysql_query);

		cache_get_field_content(0,"color1",mysql_query);
		gCarInfo[carid][car_color][0] = strval(mysql_query);

		cache_get_field_content(0,"color2",mysql_query);
		gCarInfo[carid][car_color][1] = strval(mysql_query);

		gCarInfo[carid][car_server_id] = CreateVehicle(
			gCarInfo[carid][car_model], gCarInfo[carid][car_x], gCarInfo[carid][car_y], gCarInfo[carid][car_z], 
			gCarInfo[carid][car_angle], gCarInfo[carid][car_color][0], gCarInfo[carid][car_color][1], gCarInfo[carid][car_respawn]

		);
		SetVehicleParamsEx(gCarInfo[carid][car_server_id],0,0,0,0,0,0,0);

		printf("Carro (%d) criado (db: %d | svid: %d",carid,gCarInfo[carid][car_id],gCarInfo[carid][car_server_id]);
	}
	return 1;
}

public data_CreateCar(playerid,owner,ownertype,model,Float:x,Float:y,Float:z,Float:angle,color1,color2){
	format(mysql_query,sizeof mysql_query, "INSERT INTO `cars` \
		(`owner`, `ownertype`, `owned`, `model`, `x`, `y`, `z`, `angle`, `respawn`, `color1`, `color2`) VALUES \
		(%d, %d, 0, %d, %f, %f, %f, %f, -1, %d, %d);",owner,ownertype,model,x,y,z,angle,color1,color2
	);

	mysql_function_query(mysql_connection,mysql_query,false,"r@data_CreateCar",
		"ddddffffdd",playerid,owner,ownertype,model,x,y,z,angle,color1,color2
	);
	return 1;
}

public r@data_CreateCar(playerid,owner,ownertype,model,Float:x,Float:y,Float:z,Float:angle,color1,color2){
	printf("%d %d %d %d %f %f %f %f %d %d",playerid,owner,ownertype,model,Float:x,Float:y,Float:z,Float:angle,color1,color2);
	mysql_store_result();
    new sqlid = mysql_insert_id();
	mysql_free_result();
	printf("sqlid: %d",sqlid);
	new id;
	id = (sqlid-1);
	printf("varid: %d",id);
	if(ownertype == CAR_TYPE_PLAYER){
		SendClientMessage(playerid,-1,"Parabéns você comprou o seu carro.");
		SetPlayerCheckpoint(playerid, 2176.7808,-2312.2375,13.2739, 3.0);
		//GivePlayerMoney(playerid,-GetVehiclePrice(model));
	}
	gCarInfo[id][car_id] = sqlid;
	printf("sqlid: %d",gCarInfo[id][car_id]);
	gCarInfo[id][car_owner] = owner;
	printf("owner: %d",owner);
	gCarInfo[id][car_ownertype] = ownertype;
	gCarInfo[id][car_model] = model;
	gCarInfo[id][car_x] = x;gCarInfo[id][car_y] = y;gCarInfo[id][car_z] = z;gCarInfo[id][car_angle] = angle;
	gCarInfo[id][car_respawn] = 99999;
	gCarInfo[id][car_color][0] = color1;gCarInfo[id][car_color][1] = color2;

	gCarInfo[id][car_server_id] = CreateVehicle(model, x, y, z, angle, color1, color2, 99999);
	SetVehicleParamsEx(gCarInfo[id][car_server_id],0,0,0,0,0,0,0);

	printf("Carro (%d) criado (db: %d | svid: %d)",id,gCarInfo[id][car_id],gCarInfo[id][car_server_id]);
	printf("id: %d",gCarInfo[id][car_server_id]);	
	gCarInfo[id][car_engine_status] = 100.0;
	return 1;
}