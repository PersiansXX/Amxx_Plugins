#include <amxmodx>


new aktifadmin=0;
new bool:buadmin[MAX_PLAYERS+1];

public plugin_init() 
{
	register_plugin("Tim Admin Mic", "1.1", "Persians");
	set_cvar_num("sv_voiceenable", 0);
}
public client_putinserver(id){
	if(get_user_flags(id) & ADMIN_BAN){
		aktifadmin++;
		buadmin[id]=true;
		abuzer_acik()
	}
}
public client_disconnected(id){
	if(buadmin[id]){
		aktifadmin--
		buadmin[id]=false;
		abuzer_kapali()
	}
	remove_task(id)
}
public client_infochanged(id) 
{
	new newname[32], oldname[32]
	
	get_user_info(id, "name", newname, charsmax(newname))
	get_user_name(id, oldname, charsmax(oldname))
	
	if(!equali(newname, oldname)){
		set_task(1.0,"taskiledon",id)
	}
}
public taskiledon(id){
	if(is_user_connected(id)){
		if(buadmin[id]){
			if(!(get_user_flags(id) & ADMIN_BAN)){
				aktifadmin--;
				buadmin[id]=false;
				abuzer_kapali()
			}
		}
		else{
			if(get_user_flags(id) & ADMIN_BAN){
				aktifadmin++;
				buadmin[id]=true;
				abuzer_acik()
			}
		}
	}
}


public abuzer_acik(){
	if(aktifadmin > 0)
	{
		set_cvar_num("sv_voiceenable", 1);
	} 
	return PLUGIN_HANDLED
}

public abuzer_kapali(){
	if(aktifadmin < 1)
	{
		set_cvar_num("sv_voiceenable", 0);
		client_print_color(0, 0, "^1[^4Teskilat-I Mahsusa^1] ^3 Oyunda admin olmadigi icin mikrofonlar kapatilmistir.");
	} 
	return PLUGIN_HANDLED
		
}
	