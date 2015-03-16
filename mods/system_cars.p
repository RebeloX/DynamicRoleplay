 /*

	system_cars.p
*/

#include <YSI\y_hooks>
#include <zcmd>

wcar_getid(vehicleid){
	for(new i; i<C_MAX_CARS; ++i){
		if(gCarInfo[i][car_server_id] == vehicleid)
			return i;
	}
	return false;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(!ispassenger){
		for(new i; i<C_MAX_CARS; ++i){
			if(gCarInfo[i][car_ownertype] == CAR_TYPE_PLAYER){
				SendClientMessage(playerid,-1,"USE: /motor ou /ligacaodireta para iniciar o carro.");
				return 1;
			}
		}
	}
    return 1;
}

CMD:motor(playerid,params[]){
	if(GetPlayerVehicleSeat(playerid) == 0){
		for(new i; i<C_MAX_CARS; ++i){
			if(gCarInfo[i][car_ownertype] == CAR_TYPE_PLAYER && gCarInfo[i][car_owner] == gPlayerInfo[playerid][player_id] && gCarInfo[i][car_server_id] == GetPlayerVehicleID(playerid)){
				if(gCarInfo[i][car_status] == CAR_STATUS_ENGINE_BROKEN){
					return cmd_do(playerid,"*Veiculo quebrado, não é possível ligar o motor*");
				}

				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(gCarInfo[i][car_server_id], engine, lights, alarm, doors, bonnet, boot, objective);
				if(engine == 1){
					SetVehicleParamsEx(gCarInfo[i][car_server_id],0,lights,alarm,doors,bonnet,boot,objective);
					cmd_me(playerid,"leva a sua mão a chave do veiculo desligando o mesmo.");
				}
				else if(engine == 0){
					SetVehicleParamsEx(gCarInfo[i][car_server_id],1,lights,alarm,doors,bonnet,boot,objective);
					cmd_me(playerid,"leva a sua mão a chave do veiculo ligando o mesmo.");
				}
			}
		}
	}
	return 1;
}

CMD:conce(playerid,params[]){
	SendClientMessage(playerid,-1,"SEU NOBI TÁ USANDO CHEAT HEIN? VOU TE PEGA RÇRÇRÇRÇRÇR");
	SetPlayerPos(playerid,2176.4272,-2302.7678,13.5469);
	return 1;
}

/*
	OnPlayerStartVehicle(playerid,vehicleid);

	distancia entre pontos = result = floatsqroot(floatpower(x-x1,2) + floatpower(y-y1,2) + floatpower(z-z2,2)); (retorna em metros)
	
	UpdateVehicleDistance(vehicleid,yes);

	OnVehicleChangeStatus(vehicleid,statustype);
	ChangeVehicleStatus(vehicleid,statustype);
*