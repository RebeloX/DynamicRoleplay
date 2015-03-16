/* ----------------------------------------------------------------------------


        Definições do código. Caso o game mode está fechando sozinho, veja se a memória
        dinâmica é suficiente para suprir toda carga do servidor em #pragma dynamic

        MAX_DATA_NAME reserva o tamanho médio para cada dado recebido, provedora, cidade, estado ....

--------------------------------------------------------------------------------*/



#if !defined HTTP_ERROR_BAD_HOST

        #include a_http
     

#endif

#pragma dynamic 30000

#if !defined MAX_DATA_NAME
       #define MAX_DATA_NAME 64
#endif




/*-----------------------------------------------------------------------------------


        Função "GetPlayerGeoIP"
        Com ela é pego as informações do jogadores que serão recebidas em OnPlayerGeoIP

        Atualmente recebe:
            - IP pego
            - Provedora do IP
            - Estado, Cidade e Pais

        Nem sempre é preciso, algumas vezes pode acertas, outras vezes pode pegar uma cidade vizinha !!


-----------------------------------------------------------------------------------*/

#define GeoIP::  BSGET_

#define BSGET_fp%0(%1) forward %0(%1); public %0(%1)

GeoIP::fp GetPlayerGeoIP(playerid) {

	static
		geoip[256]
	;

	GetPlayerIp(playerid, geoip, 25);

	format(geoip, 256, "www.infosniper.net/index.php?ip_address=%s&map_source=1&overview_map=1&lang=1&map_type=1&zoom_level=7", geoip);

	return HTTP(playerid, HTTP_GET, geoip, "\0", "Geo_IpResponse");
}




/*-----------------------------------------------------------------------------------

        Parte que receberá a página HTML e fazerá o processamento do código para filtrar as informações

-------------------------------------------------------------------------------------*/

GeoIP::fp Geo_IpResponse(index, response_code, data[])
{
	if(response_code == 200)
	{

		new ip                  [MAX_DATA_NAME];
		new cidade              [MAX_DATA_NAME];
		new estado              [MAX_DATA_NAME];
		new pais                [MAX_DATA_NAME];
		new provedora   		[MAX_DATA_NAME];

		recursiveStrfind(ip,                    data,   "<td class=\"content-td2\">",   001, "<");
		recursiveStrfind(cidade,                data,   "<td class=\"content-td2\">",   002, "<");
		recursiveStrfind(provedora,             data,   "<td class=\"content-td2\">",   005, "<");
		recursiveStrfind(estado,                data,   "<td class=\"content-td2\">",   006, "<");
		recursiveStrfind(pais,                  data,   "<td class=\"content-td2\">",   010, "<");

		if( funcidx("OnPlayerGeoIP") != -1 ) {
			CallLocalFunction("OnPlayerGeoIP", "isssss", index, ip, cidade, estado, pais, provedora);
		}
	}

	return true;
}


/*-----------------------------------------------------------------------------------

        Função recursiva usada para dar strfind recursivamente, facilitando o trabalho
        do processamento de todo código HTML recebido da página !!

-------------------------------------------------------------------------------------*/

recursiveStrfind(dest[], data[], string[], total, after[], current = -1, pos = -1, len = sizeof (dest))
{
	current ++;

	if(current != total) {
		return recursiveStrfind(dest, data, string, total, after, current, strfind(data, string, false, pos+1), len) ;
	}

	static procurar;

	procurar = strfind(data, string, false, pos) + strlen(string);

	strmid(dest, data, procurar, procurar + len, len);

	if(strlen(after)) {

		procurar = strfind(dest, after);

		if( procurar != -1 ) {
			dest[procurar] = EOS;
		}
	}
	return true;
}


forward OnPlayerGeoIP(playerid, ip[], cidade[], estado[], pais[], provedora[]) ;


// ============================================================================