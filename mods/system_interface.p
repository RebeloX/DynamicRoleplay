// MyRPG Anti-Cheat/Interface - Luís Gustavo Miki 
#include <YSI\y_hooks>

forward OnPlayerUpdateAmmo(playerid, weaponid, oldammo, newammo);
forward OnPlayerShootPlayer(playerid, damagedid, weaponid, Float:damage, Float:maxdamage);
	
enum WEAPON_INFO {
	wi_Allow, // trégua
	wi_CurrentWeapon,
	wi_CurrentAmmo,
	wi_PastWeapon,
	wi_PastAmmo
}
	
new Float:gWeaponsDamage[] = {
	6.600000, 	6.600000, 	6.600000, 	6.600000,	6.600000, 	6.600000,	
	6.600000, 	6.600000,	6.600000, 	6.600000, 	6.600000, 	6.600000,
	6.600000, 	6.600000, 	6.600000, 	6.600000,	0.000000, 	0.000000,
	0.000000, 	0.000000, 	0.000000, 	0.000000,	8.25, 		13.500000,
	46.500000, 	49.6, 		49.6, 		39.7,		6.600000, 	8.25,
	9.900000, 	9.900000,	6.600000, 	24.8, 		41.25,		0.000000,
	0.000000, 	0.2,		46.3, 		0.000000, 	0.000000, 	2.7,
	2.7, 		0.000000,	0.000000, 	0.000000,	0.000000, 	0.000000,
	0.000000, 	0.000000
};

new gPlayerWeaponData[MAX_PLAYERS][13][WEAPON_INFO];

hook OnPlayerConnect(playerid) {
	new slot = -1; while(++slot < 13) {
		gPlayerWeaponData[playerid][slot][wi_PastWeapon] = 0;
		gPlayerWeaponData[playerid][slot][wi_PastAmmo] = 0;
		gPlayerWeaponData[playerid][slot][wi_CurrentWeapon] = 0;
		gPlayerWeaponData[playerid][slot][wi_CurrentAmmo] = 0;
		gPlayerWeaponData[playerid][slot][wi_Allow] = 0;
	}

	return 1;
}

stock wdebug(playerid, str[]) {
	SendClientMessage(playerid, -1, str);
	printf(str);
	return 1;
}

hook OnPlayerUpdate(playerid) {
	if(!(PLAYER_STATUS_SYNCING <= gPlayerInfo[playerid][player_status] <= PLAYER_STATUS_SPAWNED)) {
		return 1;
	}
		
	// Início: Loop Entre todos os slots de armas 1 - 13
	new current_slot = -1;	while(++current_slot < 13) {
		static client_weapon, client_ammo; GetPlayerWeaponData(playerid, current_slot, client_weapon, client_ammo);

		// --------------------------------- //
		if(gPlayerWeaponData[playerid][current_slot][wi_Allow]) {
			new server_weapon, server_ammo;
			
			server_weapon = gPlayerWeaponData[playerid][current_slot][wi_CurrentWeapon];
			server_ammo = gPlayerWeaponData[playerid][current_slot][wi_CurrentAmmo];
			
			if(server_weapon == client_weapon && server_ammo == client_ammo) {
				gPlayerWeaponData[playerid][current_slot][wi_Allow] = 0;
				//SendClientMessage(playerid, -1, "SERVER: A sua arma foi sincronizada.");
			} else {
				if((gPlayerWeaponData[playerid][current_slot][wi_Allow] + 7500) < GetTickCount()) {
					SendClientMessage(playerid, -1, "SERVER: Você entrou em dessincronia. Melhore a sua conexão.");
					//Player_Kick(playerid, "Dessincronia (interface.weapon)");
					return 1;
				}
			}
		} else {
			new server_weapon, server_ammo;
			
			server_weapon = gPlayerWeaponData[playerid][current_slot][wi_CurrentWeapon];
			server_ammo = gPlayerWeaponData[playerid][current_slot][wi_CurrentAmmo];
			
			if(server_weapon == client_weapon && server_ammo >= client_ammo) {
				if(client_ammo < server_ammo) {
					//printf("playerid: %d, server_weapon: %d, server_ammo: %d, client_ammo: %d", playerid, server_weapon, server_ammo, client_ammo);
					//OnPlayerUpdateAmmo(playerid, server_weapon, server_ammo, client_ammo);
					gPlayerWeaponData[playerid][current_slot][wi_CurrentAmmo] = client_ammo;
				}
			} else {
				new temp[128];
				format(temp, sizeof temp,
					"%s [id:%d|pid:%d] - Inconsistência (interface.weapon)",
					gPlayerInfo[playerid][player_name],
					playerid,
					gPlayerInfo[playerid][player_id]
				);
				//Admin_Warn(ADMIN_WARN_TYPE_CHEAT, temp, 1);
			}
		}
	}
	return 1;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid) {
	#pragma unused playerid
	#pragma unused damagedid
	#pragma unused amount
	#pragma unused weaponid
	return 1;
}

stock Weapon_Set(playerid, weaponid, ammo) {
	new slot = GetWeaponSlot(weaponid);
	
	if(slot == -1) {
		return 1;
	}
	// ------------- //
	new client_weapon, client_ammo; GetPlayerWeaponData(playerid, slot, client_weapon, client_ammo);
	
	if(weaponid == client_weapon) {
		if(weaponid == 0 || weaponid == 1 || weaponid == 10) {
			return 1;
		}		

		gPlayerWeaponData[playerid][slot][wi_CurrentWeapon] = weaponid;
		gPlayerWeaponData[playerid][slot][wi_CurrentAmmo] = ammo;
		ResetPlayerWeapons(playerid);
		new index = -1; while(++index < 13) {
			GivePlayerWeapon(playerid, gPlayerWeaponData[playerid][index][wi_CurrentWeapon], gPlayerWeaponData[playerid][index][wi_CurrentAmmo]);
			gPlayerWeaponData[playerid][index][wi_Allow] = GetTickCount();
		}		
	} else {
		GivePlayerWeapon(playerid, weaponid, ammo);
		gPlayerWeaponData[playerid][slot][wi_PastWeapon] = gPlayerWeaponData[playerid][slot][wi_CurrentWeapon];
		gPlayerWeaponData[playerid][slot][wi_PastAmmo] = gPlayerWeaponData[playerid][slot][wi_CurrentAmmo];
		
		gPlayerWeaponData[playerid][slot][wi_CurrentWeapon] = weaponid;
		gPlayerWeaponData[playerid][slot][wi_CurrentAmmo] = ammo;
		
		gPlayerWeaponData[playerid][slot][wi_Allow] = GetTickCount();
	}	
	return 1;
}

stock Weapon_Give(playerid, weaponid, ammo) {
	new slot = GetWeaponSlot(weaponid);
	
	if(slot == -1) {
		return 1;
	}
	// ------------- //
	new client_weapon, client_ammo; GetPlayerWeaponData(playerid, slot, client_weapon, client_ammo);
	if(weaponid == client_weapon) {
		gPlayerWeaponData[playerid][slot][wi_PastWeapon] = gPlayerWeaponData[playerid][slot][wi_CurrentWeapon];
		gPlayerWeaponData[playerid][slot][wi_PastAmmo] = gPlayerWeaponData[playerid][slot][wi_CurrentAmmo];
		gPlayerWeaponData[playerid][slot][wi_CurrentWeapon] = weaponid;
		gPlayerWeaponData[playerid][slot][wi_CurrentAmmo] += ammo;
	} else {
		gPlayerWeaponData[playerid][slot][wi_PastWeapon] = gPlayerWeaponData[playerid][slot][wi_CurrentWeapon];
		gPlayerWeaponData[playerid][slot][wi_PastAmmo] = gPlayerWeaponData[playerid][slot][wi_CurrentAmmo];
		gPlayerWeaponData[playerid][slot][wi_CurrentWeapon] = weaponid;
		gPlayerWeaponData[playerid][slot][wi_CurrentAmmo] = ammo;
	}
	GivePlayerWeapon(playerid, weaponid, ammo);
	
	gPlayerWeaponData[playerid][slot][wi_Allow] = GetTickCount();
	return 1;
}

stock Weapon_ResetAll(playerid) {
	new slot = -1; while(++slot < 13) {
		gPlayerWeaponData[playerid][slot][wi_PastWeapon] = gPlayerWeaponData[playerid][slot][wi_CurrentWeapon];
		gPlayerWeaponData[playerid][slot][wi_PastAmmo] = gPlayerWeaponData[playerid][slot][wi_CurrentAmmo];
		gPlayerWeaponData[playerid][slot][wi_CurrentWeapon] = 0;
		gPlayerWeaponData[playerid][slot][wi_CurrentAmmo] = 0;
		gPlayerWeaponData[playerid][slot][wi_Allow] = GetTickCount();
	}
	ResetPlayerWeapons(playerid);
	return 1;
}

stock Weapon_ClearSlot(playerid, slot) {
	ResetPlayerWeapons(playerid);
	
	new index = -1; while(++index < 13) {
		if(index == slot) { 
			gPlayerWeaponData[playerid][index][wi_PastWeapon] = gPlayerWeaponData[playerid][index][wi_CurrentWeapon];
			gPlayerWeaponData[playerid][index][wi_PastAmmo] = gPlayerWeaponData[playerid][index][wi_CurrentAmmo];
			gPlayerWeaponData[playerid][slot][wi_CurrentWeapon] = 0;
			gPlayerWeaponData[playerid][slot][wi_CurrentAmmo] = 0;
			gPlayerWeaponData[playerid][index][wi_Allow] = GetTickCount();
			continue; 
		}
		GivePlayerWeapon(playerid, gPlayerWeaponData[playerid][index][wi_CurrentWeapon], gPlayerWeaponData[playerid][index][wi_CurrentAmmo]);
		gPlayerWeaponData[playerid][index][wi_PastWeapon] = gPlayerWeaponData[playerid][index][wi_CurrentWeapon];
		gPlayerWeaponData[playerid][index][wi_PastAmmo] = gPlayerWeaponData[playerid][index][wi_CurrentAmmo];
		gPlayerWeaponData[playerid][index][wi_Allow] = GetTickCount();
	}
	return 1;
}

stock Weapon_Remove(playerid, weaponid) {
	new slot = GetWeaponSlot(weaponid);
	Weapon_ClearSlot(playerid, slot);
	return 1;
}

stock GetWeaponSlot(wid)
{
	switch(wid)
	{
		case 0, 1: return 0;
		case 2..9: return 1;
		case 22..24: return 2;
		case 25..27: return 3;
		case 28, 29, 32: return 4;
		case 30, 31: return 5;
		case 33, 34: return 6;
		case 35..38: return 7;
		case 16..19, 39: return 8;
		case 41..43: return 9;
		case 10..15: return 10;
		case 44..46: return 11;
		case 40: return 12;
		default: return -1;
	}
	return -1;
}