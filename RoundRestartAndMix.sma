#pragma semicolon 1

#include <amxmodx>
#include <reapi>

enum _:IntCvar {
    elsonunubekle,
    roundkac,
    karistirma,
    roundd
};
new g_cvars[IntCvar], Round;
new bool:g_LastRound;
new const server[] = "TIM";

public plugin_init() {
    register_plugin("Takim Karistirma Ve Round Restart", "1.1", "Persians");

    register_clcmd("say /karistir", "persians");
    register_clcmd("karistir", "persians");
    register_clcmd("say !karistir", "persians");

    register_logevent("RoundEnd", 2, "1=Round_End");

    bindler();
}

bindler(){
    bind_pcvar_num(create_cvar("Pers_Elsonunubekle", "1"), g_cvars[elsonunubekle]); // Karistir Baslatilinca El Sonunu Beklesinmi. (default 1)
    bind_pcvar_num(create_cvar("Pers_Restart", "1"), g_cvars[roundd]); // Belirli Rounda Gelince Oto Restart Atilsinmi. (default 1)
    bind_pcvar_num(create_cvar("Pers_Karistirma", "1"), g_cvars[karistirma]); // Restart'tan Sonra Takımlar Karıştırılsınmı. (default 1)
    bind_pcvar_num(create_cvar("Pers_Restart_Round", "15"), g_cvars[roundkac]); // Kac Tur Sonra Restart Atılsın.(default 15)
}

public plugin_natives()
{
    register_native("abuzer_karistir", "karistir_native_abuzer", 1);
}


public persians(id){
    if(get_user_flags(id) & ADMIN_BAN){
    if(g_cvars[elsonunubekle] == 1){
        g_LastRound = true;
        
        client_print_color(0,0,"^4[%s]: ^4%s ^1Adli Yetkili Takim Karistirma Sistemini Aktif Etti.",server,isimver(id));
        client_print_color(0,0,"^4[%s]: ^1El Sonu Oyuncular Rastgele Takimlara Transfer Edilecek.",server);
    }
    else{
        set_task(3.0, "karistir");
    }
    }
    else{
    client_print_color(id,id,"^4[%s]: ^1Yetkiniz Yeterli Degil",server);
    }       
}

public karistir(id){
    new players[MAX_PLAYERS],num,id,te=0,ct=0; get_players(players, num, "chi");
    for(new i=0; i<num; i++) {
        if(!is_user_alive(id) && is_user_bot(id)) {
            return PLUGIN_HANDLED;
        }
        id=players[i];
        if(is_user_connected(id)){
        if(ct>te) rg_set_user_team(id, TEAM_TERRORIST),te++;
        else if(te>ct) rg_set_user_team(id, TEAM_CT),ct++;
        else {
            switch(random_num(1, 2)) {
                case 1: rg_set_user_team(id, TEAM_TERRORIST),te++;
                case 2: rg_set_user_team(id, TEAM_CT),ct++;
            }
        }
        }
        client_print_color(0, print_team_grey, "^4[%s]: ^3Oyuncular Rastgele Takimlara Transfer Edildi.", server);
        g_LastRound = false;
    }
    return PLUGIN_HANDLED;
}

public isimver(oyuncu){
    new isim[32];
    get_user_name(oyuncu, isim, 31);
    return isim;
}

public karistir_native_abuzer(id)
{
    karistir(id);
}

public RoundEnd(id){
    Round++;
    if(g_cvars[roundd] == 1)
    {    
        if(Round % g_cvars[roundkac] == 0)
        {
            server_cmd("amx_cvar sv_restart 3");
            
            client_print_color(0, print_team_grey, "^4[%s]: ^3Round Sayisi ^4%i ^3Oldugu Icin Restart Atiliyor", server, g_cvars[roundkac]);
            if(g_cvars[karistirma] == 1){
                karistir(id);
            }            
        }
    }        
    if(g_LastRound){
        set_task(3.0, "karistir");
    }
}
