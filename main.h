/*

		CITY OF ANGELS : ROLEPLAY

*/

native gpci (playerid, serial [], len);

//constantes do servidor
const 
	C_MAX_PLAYERS = 50,
	C_MAX_VEHICLES = 500
;

//base de dados (MySQL)
new
	const 
	db_host[] = "127.0.0.1",
	db_user[] ="root",
	db_password[] = "1234",
	dbMain_database[] = "maindb",
	dbLog_database[] = "logdb"
;

//handler da base de dados.
new
	dbMain,
	dbLog
;

//enumerações
enum
{
	DIALOG_NULL,
	DIALOG_REGISTER,
	DIALOG_LOGIN,
	DIALOG_BANNED,
	DIALOG_CHAR_NAME,
	DIALOG_CHAR_AGE,
	DIALOG_CHAR_FROM,
	DIALOG_CHAR_SKIN
};

enum
{
	STATUS_CONNECTED,
	STATUS_LOGIN,
	STATUS_REGISTER,
	STATUS_CHAR_SELECTION,
	STATUS_SPAWNED,
	STATUS_ADMIN_DUTY,
	STATUS_TESTER_DUTY,
	STATUS_KILLED
};

//aInfo -> conta do jogador, funciona no uCP



//pInfo -> responsável pelas variáveis do jogador no sa-mp
enum E_PLAYER_INFO
{
	player_id,
	player_name[24],
	player_ip[16],
	
	player_status,
	player_admin,
	player_vip,
	player_login_attempts,

	player_x,
	player_y,
	player_z,
	player_vw,
	player_int,

	character_id,
	character_name[24],
	character_money,
	character_skin,
	character_level,
	character_int,
	character_vw,
	Float:character_x,
	Float:character_y,
	Float:character_z
};

new
	gPlayerInfo[C_MAX_PLAYERS][E_PLAYER_INFO];

//vInfo
enum E_VEHICLES_INFO
{
	vehicle_id,
	vehicle_owner,
	vehicle_int,
	vehicle_vw,
	Float:vehicle_x,
	Float:vehicle_y,
	Float:vehicle_z
};

new
	gVehicleInfo[C_MAX_VEHICLES][E_VEHICLES_INFO];

