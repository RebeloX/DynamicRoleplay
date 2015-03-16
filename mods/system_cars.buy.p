/*
	system_cars.buy

*/

#include <YSI\y_hooks>

//Player Textdraws:
GetVehiclePrice(model){
	switch(model){
		case 411: return 1000;
	}
	return 1;
}

new PlayerText:Textdraw0[MAX_PLAYERS];

new PlayerText:gListInfo[MAX_PLAYERS][21];
const PAGES = 21;

new gCarsList[98] =
{
	400,401,402,404,405,410,411,412,413,414,415,418,419,421,422,424,426,429,434,436,439,440,442,
	443,445, 451,458,459,461,462,463,466,467,468,471,474,475, 477,478,479,480,
	482,483,485,489,491,492,494,495,496,500,502, 503, 504,505,506,507,508, 516,517,518,521,522,
	526,527,529,533,534,535, 526, 540, 541,542,543, 547,549,550,551,555,559,560,561,562, 565,566,
	567,575,576,579,579,580,581, 585,587,589,600,602,603,
};

PlayerText:PlayerTextDrawCreatePreview(playerid, modelindex, color, Float:sX, Float:sY, Float:width, Float:height, selectable, color1, color2){
	new PlayerText:_textpreview;
	_textpreview = CreatePlayerTextDraw(playerid, sX, sY, "_");
	PlayerTextDrawFont(playerid, _textpreview, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawUseBox(playerid, _textpreview, 1);
	PlayerTextDrawColor(playerid, _textpreview, color);
	PlayerTextDrawTextSize(playerid, _textpreview, width, height);
	PlayerTextDrawSetPreviewModel(playerid, _textpreview, modelindex);
	PlayerTextDrawSetPreviewRot(playerid, _textpreview, -16.0, 0.0, -55.0);
	PlayerTextDrawSetSelectable(playerid, _textpreview, selectable);
	if(modelindex > 399 && modelindex < 612 )
		PlayerTextDrawSetPreviewVehCol(playerid, _textpreview, color1, color2);
	PlayerTextDrawShow(playerid, _textpreview);
	return _textpreview;
}

CreatePreviewList(playerid){
	new 
		Float:xPos = 75.0,
		Float:yPos = 130.0 - (70.0 * 0.33),
		line = 0
	;
	for(new i; i<PAGES; ++i){
		if(line == 0){
			xPos = 75.0 + 25.0;
			yPos += 70.0 + 1.0;
		}
		gListInfo[playerid][i] = PlayerTextDrawCreatePreview(playerid,gCarsList[i], 0xBEBEBEFF, xPos, yPos, 60.0, 70.0, true, 6, 6);
		line ++;
		xPos += 60.0 + 1;
		if(line == 7) line = 0;
	}
	SelectTextDraw(playerid, 0xFF4040AA);
	return 1;
}

DestroyPreviewList(playerid){
	for(new i; i<PAGES; ++i){
		PlayerTextDrawHide(playerid, gListInfo[playerid][i]);
	}
	PlayerTextDrawHide(playerid, Textdraw0[playerid]);
	return 1;
}

hook OnGameModeInit(playerid){
	print("> system_cars.buy.p carregado com sucesso.");
	return 1;
}



hook OnPlayerConnect(playerid){
	Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 130.0, 525.0, "_"); //Background
	PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.000000, 27.807777);
	PlayerTextDrawTextSize(playerid, Textdraw0[playerid], 13.199999, 0.000000);
	PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw0[playerid], 0);
	PlayerTextDrawUseBox(playerid, Textdraw0[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw0[playerid], -86);
	PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw0[playerid], -1);
	PlayerTextDrawFont(playerid, Textdraw0[playerid], 0);
	return 1;
}

CMD:comprarc(playerid){
	PlayerTextDrawShow(playerid, Textdraw0[playerid]);
	CreatePreviewList(playerid);
	return 1;
}
 
hook OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    for(new i; i<PAGES; ++i){
    	if(playertextid == gListInfo[playerid][i]){
    		format(gResult,sizeof gResult,"Você clicou no veiculo (%d) preço: $%d",gCarsList[i],GetVehiclePrice(gCarsList[i]));
    		SendClientMessage(playerid,-1,gResult);
    		if(GetPlayerMoney(playerid) >= GetVehiclePrice(gCarsList[i])){
    			//data_CreateCar(playerid,owner,ownertype,model,x,y,z,angle,color1,color2)
    			data_CreateCar(
    				playerid, gPlayerInfo[playerid][player_id], 0, gCarsList[i], 2176.7808, -2312.2375, 13.2739, 229.2775, 6, 6
    			);
    		}
    		else{
    			SendClientMessage(playerid,-1,"Você não tem dinheiro suficiente para comprar este veiculo.");
    		}
    		CancelSelectTextDraw(playerid);
    		DestroyPreviewList(playerid);
    		//2176.7808,-2312.2375,13.2739,229.2775,162,162
    	}
    }
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    SendClientMessage(playerid,-1,"Procure pelo seu carro.");
    return 1;
}
