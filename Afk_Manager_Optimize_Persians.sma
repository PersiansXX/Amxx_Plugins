#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <cstrike>
#include <reapi>

#define MAX_AFK_WARNING 2  //Oyuncunun kac uyarı hakki oldugunu ayarlar.

new const PLUGIN[] = "AFK Kontrol";
new const VERSION[] = "1.5";
new const AUTHOR[] = "Persians";

new const TAG[] = "T-IM";

new bool:oyuncuyasiyor[33], bool:oyuncubot[33], bool:oyuncuserverde[33];
new Time, g_maxplayers, afk_oto;
new  abuzerafk[33] = 0, bool:abuzerbuafk[33] = false;
new Float: Player_Origin[33][3];

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	bind_pcvar_num(create_cvar("afk_slay_sure","15.0"),Time)
	bind_pcvar_num(create_cvar("afk_oto_kontrol","0"),afk_oto)
	
	RegisterHookChain(RG_CBasePlayer_Spawn, "CBasePlayer_Spawn", .post = true);
	register_logevent("abuzer_elbasi", 2, "1=Round_Start")
	register_clcmd( "say /afk", "degistir" );
	register_clcmd("say /afkmenu", "abuzer_afkmenu", ADMIN_SLAY, "Afk Menusunu Gosterir")
	register_clcmd("say", "HookSay");
	register_clcmd("say_team", "HookSay");
	g_maxplayers = get_maxplayers()
}

public client_putinserver(id)
{
	abuzerbuafk[id] = false;
	abuzerafk[id] = 0;
	if(is_user_bot(id)){
		oyuncubot[id] = true;
	}
	if(is_user_connected(id)){
		oyuncuserverde[id]= true;
	}
}


public CBasePlayer_Spawn(ID)
{
	remove_task(ID);
	if(afk_oto)
	{
	if(is_user_alive(ID) && !oyuncubot[ID] && !is_user_hltv(ID))
	{
		oyuncuyasiyor[ID] = true;
		set_task(5.0, "Get_Spawn", ID);
	}
	}
}


public abuzer_elbasi(){
	static id
	for(id = 0; id <= g_maxplayers; id++)
	{
		if(oyuncuserverde[id] && !oyuncubot[id]) {
			if(abuzerbuafk[id] == true){				
			user_kill(id, 1)
			client_print_color(id,print_team_grey,"^1[^4%s^1]: ^3Afk Modunuz Afk Kaldiginiz Icin Otomatik Olarak ^4Aktif Oldu.",TAG);
			client_print_color(id,print_team_grey,"^1[^4%s^1]: ^3Afk Modundan Cikmak Icin Saya ^4/afk ^3Yazmaniz Yeterlidir.",TAG);
			set_user_frags(id,0)
			cs_set_user_deaths(id,0)			
		} 		
	}
	}
}


public Get_Spawn(ID)
{
	get_entvar(ID, var_origin, Player_Origin[ID]);
	set_task(float(Time), "Check_AFK", ID);
}

public Check_AFK(ID)
{
	new Name[33];
	get_user_name(ID, Name, 32);
	
	if(oyuncuyasiyor[ID] && Origin_Control(ID) && !oyuncubot[ID])
	{
		if(abuzerafk[ID] < MAX_AFK_WARNING){
			user_kill(ID, 1);
			abuzerafk[ID]++
			client_print_color(ID, ID, "^1[^4%s^1]: ^3Hareket etmiyorsun! Otomatik AFK Modu Icin Kalan Uyari: ^4%i/%i", TAG,abuzerafk[ID], MAX_AFK_WARNING);
		}
		else {
			user_kill(ID, 1)			
			abuzerbuafk[ID] = true
			client_print_color(ID, ID, "^1[^4%s^1]: ^3Otomatik AFK Modu Aktif. Artik El Basi Olduruleceksin.", TAG);
			client_print_color(0, 0, "^1[^4%s^1]: ^4%s ^3AFK Oldugu Tespit Edildi Ve Otomatik AFK Moduna Gecirildi.Her El Oldurulecek.", TAG, Name);
		}
		set_user_frags(ID,0)
		cs_set_user_deaths(ID,0)		
	}	
}

public Origin_Control(ID)
{
	new Float: Origin[3];
	get_entvar(ID, var_origin, Origin);

	for(new i; i < 3; i++)
	{
		if(Origin[i] != Player_Origin[ID][i])
		{
			return 0;
		}
	}
	
	return 1;
}

public degistir(id)
{
    if(abuzerbuafk[id]){
	abuzerbuafk[id]=false;
	abuzerafk[id] = 0;
	client_print_color(id,print_team_red,"^1[^4%s^1]: ^3Afk Modunu ^4Pasif ^3Yaptin.",TAG);
    }
    else{
	abuzerbuafk[id]=true;
	client_print_color(id,print_team_grey,"^1[^4%s^1]: ^3Afk Modunu ^4Aktif ^3Yaptin.",TAG);
    }
    return PLUGIN_HANDLED;
} 

public HookSay(id)
{
	if(abuzerbuafk[id])
	{
		client_print_color(id,print_team_grey,"^1[^4%s^1]: ^3Afk Modunda Oldugunuz Icin Say'dan Yazamazsiniz.",TAG);
		client_print_color(id,print_team_grey,"^1[^4%s^1]: ^3Afk Modundadan Cikmak Icin Saya ^4/afk ^3Yazmaniz Yeterli.",TAG);
		return PLUGIN_HANDLED;
	}
	
	return PLUGIN_CONTINUE;
}


public abuzer_afkmenu(id, level, cid)
{
	if (cmd_access(id, level, cid, 1))
	{
		build_menu(id)
	}
	return PLUGIN_HANDLED
}

stock build_menu(id, page = 0)
{
	new menu = menu_create("-- TIM AFK Menu --\r V1.2 Persians", "menu_handler")
	
	static players[32], num, szName[64], cmd[5], itemtxt[60]
	
	get_players(players, num)
	for (new i = 0; i < num; i++)
	{
		if(!oyuncuserverde[players[i]] || oyuncubot[players[i]])	continue;
		
		get_user_name(players[i], szName, charsmax(szName))
		
		num_to_str(players[i],cmd,charsmax(cmd));
		
		formatex(itemtxt, 59, "%s %s", szName, abuzerbuafk[players[i]] ? "\yON":"\rOFF")
		
		menu_additem(menu, itemtxt, cmd)
	}
	
	menu_display(id, menu, page)
}

public menu_handler(id, menu, item)
{
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return ;
	}
	
	static cmd[5], callback, access, pid
	menu_item_getinfo(menu, item, access, cmd, 4, _, _, callback)
	
	pid = str_to_num(cmd)
	
	if (oyuncuserverde[pid])
	{
		abuzerbuafk[pid] = !abuzerbuafk[pid];		
	}
	if(abuzerbuafk[pid]){
	client_print_color(pid,print_team_red,"^1[^4%s^1]: ^3AFK Modunuz ^4Aktif ^3Olarak Degistirildi.",TAG);
	}
	else{
	client_print_color(pid,print_team_grey,"^1[^4%s^1]: ^3AFK Modunuz ^4Pasif ^3Olarak Degistirildi.",TAG);
	}
	
	menu_destroy(menu)
	
	build_menu(id, item / 7)
}

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
