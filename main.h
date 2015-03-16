/*
================================================================================
                                header.h
================================================================================


*/

//funções

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

native gpci(playerid, serial [], len);

GetPVarStringEx(playerid,varname[]){
	static extraction[128];GetPVarString(playerid,varname,extraction,sizeof(extraction)); return extraction;
}
/*
GetPlayerIPEx(playerid){
	static extraction[18];GetPlayerIp(playerid,extraction,sizeof(extraction)); return extraction;
}

GetPlayerSerial(playerid){
	static extraction[64];gpci(playerid,extraction,sizeof(extraction)); return extraction;
}*/


reverse(const source[]) //a stock pra inverter o texto //por Gabriel "Larcius" Cordes
{
   	static string[255];
    for(new i=(strlen(source)-1); i>=0; i--)
    {
        strcat(string,GetSingleChar(source,i));
    }
    return string;
}

GetSingleChar(const source[], num) //stock necessaria pra usar a stock reverse(const source[]) //por Gabriel "Larcius" Cordes
{
    static string[255];
    strmid(string,source,num,(num+1));
    return string;
}

fixdate(date){
	static _date[11];
	valstr(_date,date);
	strins(_date,"/",2);strins(_date,"/",5);
	return _date;
}


getage(age){
	static _date[11],y,m,d;
	valstr(_date,age);strdel(_date,0,4);
	getdate(y,m,d);age = strval(_date);
	return (y-age);
}

parsetdtext(input[]) {
    new index = -1, len = strlen(input);
    while(++index < len) {
        if(input[index] == 'À') input[index] = 128;
        if(input[index] == 'Á') input[index] = 129;
        if(input[index] == 'Â') input[index] = 130;
        if(input[index] == 'Ä') input[index] = 131;
        if(input[index] == 'Ç') input[index] = 133;
        if(input[index] == 'È') input[index] = 134;
        if(input[index] == 'É') input[index] = 135;
        if(input[index] == 'Ê') input[index] = 136;
        if(input[index] == 'Ë') input[index] = 137;
        if(input[index] == 'Ì') input[index] = 138;
        if(input[index] == 'Í') input[index] = 139;
        if(input[index] == 'Î') input[index] = 140;
        if(input[index] == 'Ï') input[index] = 141;
        if(input[index] == 'Ò') input[index] = 142;
        if(input[index] == 'Ó') input[index] = 143;
        if(input[index] == 'Ô') input[index] = 144;
        if(input[index] == 'Ö') input[index] = 145;
        if(input[index] == 'Ù') input[index] = 146;
        if(input[index] == 'Ú') input[index] = 147;
        if(input[index] == 'Û') input[index] = 148;
        if(input[index] == 'Ü') input[index] = 149;
        
        if(input[index] == 'à') input[index] = 151;
        if(input[index] == 'á') input[index] = 152;
        if(input[index] == 'â') input[index] = 153;
        if(input[index] == 'ä') input[index] = 154;
        if(input[index] == 'ç') input[index] = 156;
        if(input[index] == 'è') input[index] = 157;
        if(input[index] == 'é') input[index] = 158;
        if(input[index] == 'ê') input[index] = 159;
        if(input[index] == 'ë') input[index] = 160;
        if(input[index] == 'ì') input[index] = 161;
        if(input[index] == 'í') input[index] = 162;
        if(input[index] == 'î') input[index] = 163;
        if(input[index] == 'ï') input[index] = 164;
        if(input[index] == 'ò') input[index] = 165;
        if(input[index] == 'ó') input[index] = 166;
        if(input[index] == 'ô') input[index] = 167;
        if(input[index] == 'ö') input[index] = 168;
        if(input[index] == 'ù') input[index] = 169;
        if(input[index] == 'ú') input[index] = 170;
        if(input[index] == 'û') input[index] = 171;
        if(input[index] == 'ü') input[index] = 172;
    }
    return 1;
}


//Constantes

const
	C_MAX_PLAYERS = 60,
	C_MAX_CARS = 200,
	C_MAX_PROPERTIES = 500
;

new const
	mysql_host[] = "localhost",
	mysql_user[] = "root",
	mysql_password[] = "1234",
	mysql_database[] = "main"
;

/*new const
	mysql_host[] = "184.22.52.152",
	mysql_user[] = "root",
	mysql_password[] = "dynamicdb",
	mysql_database[] = "main"
;-*/

new
	mysql_query[1000],
	mysql_connection
;



//player status
enum {
	PLAYER_STATUS_OFFLINE, //caso o jogador não esteja logado será OFFLINE, ou seja, 0
	PLAYER_STATUS_ONLINE, //caso o jogador tenha conectado ao servidor ele estará online.
	PLAYER_STATUS_FIRST_SPAWN, //caso o jogador seja novo no servidor ele terá um status "especial."
	PLAYER_STATUS_SPAWNED, //caso o jogador spawn ele terá status de spawned
	PLAYER_STATUS_DUTY, //caso o jogador seja admin e esteja em trabalho ele usará este status
	PLAYER_STATUS_BANNED, //caso o jogador seja banido terá este status
	PLAYER_STATUS_KICKED, //caso o jogador seja kickado terá este status
	PLAYER_STATUS_TEMPBAN, //caso o jogador sejá preso, terá o status de tempban.
	PLAYER_STATUS_SYNCING
}


//dados da main account
enum E_PLAYER_INFO {
	//player informations
	player_id, //id da database
	player_name[25], //nome da main account
	player_password[65], //password da main account
	player_time, //timestamp usado para salt e outras coisas
	player_status, //status usado para diversas coisas
	player_admin, //valor do admin
	player_level, //nivel do jogador
	player_exp, //exp do jogador
	player_inventory, //id da database do inventório
	player_money, //dinheiro na mão do jogador
    player_house, //Database ID da casa do jogador
    player_business, //Database ID da empresa do jogador
    player_helpstring[128], //string armazenada no /helpme
    player_reportstring[128], //string armazenada no /report
    player_askhelp, // se o player pedir ajuda
    player_askreport, // se o player reportar alguém
    player_car,
    player_faction,
    player_rank,

	//character informations
	character_skin, //skin do personagem
	character_id[13], //id do cartão de identificação do personagem
	character_idv, //validadade do id do cartão de identificação
	character_birth, //data de nascimento do jogador.
	character_fingerprint[13], //numero da impressão digital do jogador.
	character_sex, //sexo do jogador.
	character_nationality[25] //nacionalidade do jogador.

};

new gPlayerInfo[C_MAX_PLAYERS][E_PLAYER_INFO];

//modelos dos items

enum {
	ITEM_TYPE_ARMOUR, //0
	//weapons
	ITEM_TYPE_WEP_PISTOL, //1
	ITEM_TYPE_WEP_SHOTGUN, //2
	ITEM_TYPE_WEP_ASSAULT, //3
	ITEM_TYPE_WEP_SNIPER, //4
	ITEM_TYPE_WEP_SUBMACHINE, //5
	//bullets
	ITEM_TYPE_BULLET_CLIP, //6
	ITEM_TYPE_HELEMT, //7
	ITEM_TYPE_VEST, //8
	ITEM_TYPE_MASK, //9
	ITEM_TYPE_WEP_TAZER, //10
	ITEM_TYPE_WEP_REVOLVER, //11
	ITEM_TYPE_TRAFFIC, //12
};

//dialog enumeration

enum {
	DIALOG_NULL, //0
	DIALOG_LOGIN, //1
	DIALOG_INV,
	DIALOG_INV_MENU,
	DIALOG_INV_MENU_2,
	DIALOG_WITEM, //5
	DIALOG_CAR_INV,
	DIALOG_CAR_INV_MENU,
	DIALOG_INV_WEAPON,
	DIALOG_FACTION_CREATE,
	DIALOG_FACTION_CREATE2,
	DIALOG_FACTION_CREATE3,
	DIALOG_FACTION,
	DIALOG_RANK_LIST,
	DIALOG_MEMBER_LIST
	
};

//cliptypes

enum {
	CLIP_TYPE_NULL, //0
	CLIP_TYPE_REVOLVER, //1
	CLIP_TYPE_9MM, //2
	CLIP_TYPE_9MMS, //3
	CLIP_TYPE_SHOTGUN, //4
	CLIP_TYPE_SPAS, //5
	CLIP_TYPE_M4, //6
	CLIP_TYPE_AK //7
};

//car types
enum {
	CAR_TYPE_PLAYER,
	CAR_TYPE_FACTION,
	CAR_TYPE_SERVER
};

//car status
enum {
	CAR_STATUS_ENGINE_ON,
	CAR_STATUS_ENGINE_OFF,
	CAR_STATUS_ENGINE_BROKEN
}

//cars
enum E_CAR_INFO {
	car_id,
	car_server_id,
	car_area_id,
	car_owner,
	car_owned,
	car_ownertype,
	car_model,
	car_status,
	Float:car_engine_status,
	Float:car_distance,
	Text3D:car_textlabel,

	Float:car_x,
	Float:car_y,
	Float:car_z,
	Float:car_angle,

	car_respawn,
	car_color[2]

}

new gCarInfo[C_MAX_CARS][E_CAR_INFO]; 

enum {
    PROPERTY_NULL, //0
    PROPERTY_TYPE_HOUSE, //1
    PROPERTY_TYPE_BUSINESS, //2
    PROPERTY_TYPE_STATIC //3
}

enum {
    PROPERTY_DOOR_NULL, //0
    PROPERTY_DOOR_LOCKED, //1
    PROPERTY_DOOR_OPEN, //2
    PROPERTY_DOOR_BROKE //3
}

enum E_PROPERTY_INFO {
    property_id, //SQL ID da propriedade
    property_type, //Tipo de propriedade (PROPERTY_TYPE_HOUSE, PROPERTY_TYPE_BUSINESS, PROPERTY_TYPE_STATIC)
    property_owner[32], //Nickname do dono da propriedade
    property_owned, // 0 = À venda, 1 = Tem algum dono
    property_price, //Preço da propriedade para aquisição
    property_interior, //ID do Interior da propriedade
    property_vw, //Virtual World da propriedade
    property_door, //Status da porta da propriedade (PROPERTY_DOOR_LOCKED, PROPERTY_DOOR_OPEN, PROPERTY_DOOR_BROKE)
    Float:property_entranceX, // Porta de entrada do lado de fora (Pos X)
    Float:property_entranceY, // Porta de entrada do lado de fora (Pos Y)
    Float:property_entranceZ, // Porta de entrada do lado de fora (Pos Z)
    Float:property_intposX, // Porta de entrada do lado de dentro (Pos X)
    Float:property_intposY, // Porta de entrada do lado de dentro (Pos Y)
    Float:property_intposZ, // Porta de entrada do lado de dentro (Pos Z)
    Float:property_saleplateX, // Posição X da placa de vende-se da casa
    Float:property_saleplateY, // Posição Y da placa de vende-se da casa
    Float:property_saleplateZ, // Posição Z da placa de vende-se da casa
    property_plate //Variavel que armazena o ID do objeto criado da placa de vende-se
}

new gPropertyInfo[C_MAX_PROPERTIES][E_PROPERTY_INFO];

enum E_EITEM_INFO
{
	eitem_IID,
	eitem_Type,
	eitem_Model,
	Float:eitem_Info,
	//eitem_Info2, // used as remaining weapon clips on inventory as pri/sec wep
	Float:eitem_X,
	Float:eitem_Y,
	Float:eitem_Z,
	Float:eitem_RX,
	Float:eitem_RY,
	Float:eitem_RZ,
	eitem_Name[64],
	Float:eitem_Damage,
	eitem_Caliber, // calibre
	eitem_RemainingAmmo,
	eitem_BulletType, // jhp or hpf
	//eitem_AntiCheatSync,
	eitem_ProtectionRate // para coletes (% de chance de nao dar o dano)
}

enum E_ITEM_SLOTS_INFO
{
	islot_Hat,
	islot_Shades,
	islot_PrimaryWep,
	islot_SecondaryWep,
	islot_Melee,
	islot_Armour,
	islot_Null
}
//new gPlayerHoldingInfo[MAX_PLAYERS][E_ITEM_SLOTS_INFO][E_EITEM_INFO];

enum 
{
	FACTION_STATUS_NULL,
	FACTION_STATUS_OFICIAL,
	FACTION_STATUS_GOVERNAMENTAL,
	FACTION_STATUS_NONOFICIAL
}

enum E_FACTION_INFO
{
	faction_id,
	faction_name[32],
	faction_desc[64],
	faction_leader,
	faction_togfam,
	faction_status,
	faction_radiofq, //ferquencia do rádio da facção
	faction_rankid, //id dos ranks da facção
};

new gFactionsInfo[30][E_FACTION_INFO];

//strings
new
	gResult[128]
;

//


/*
================================================================================
                                     END
==============================================================================
*/
