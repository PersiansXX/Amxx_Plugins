#include <amxmodx>
#include <amxmisc>

new const PLUGIN[] = "UcanBAN + UzaBAN";
new const VERSION[] = "1.5.0";
new const AUTHOR[] = "Persians Special Ban";

new const file[] = "addons/amxmodx/configs/yasakliListesi.ini";
new const server[] = "Persians";

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_clcmd("amx_ozelban", "AnaMenu")
	register_clcmd("amx_ucanban", "AnaMenu")
	register_clcmd("amx_uzaban", "AnaMenu")
	register_clcmd("persians_v", "version")		
}

public client_connect(id)    
{
	new Filee = fopen(file, "rt");
	
	if(Filee)
	{
		new Auth_ID[33], Auth_Control[33], Data[256], name[33];
		get_user_authid(id, Auth_ID, charsmax(Auth_ID));
		get_user_name(id ,name, charsmax(name) )		
		
		while(!feof(Filee))
		{
			fgets(Filee, Data, charsmax(Data));
			if(Data[0] == EOS) {
				continue;
			}			
			
			if(strlen(Data))
			{
				parse(Data, Auth_Control, 32);
				
				if(equal(Auth_ID, Auth_Control))
				{
				sayyaz(0, "!t%s !y: !g[%s] !t isimli oyuncu yasakli oldugu icin sunucudan atildi! Yasakli ID !y:!g[%s]",server,name,Auth_ID)
				server_cmd("kick #%d ^"Yasakli oldugun icin sunucudan atildin^"",get_user_userid(id))
				}
			}
		}
		
		fclose(Filee);
	}
}



public AnaMenu(id) {
	if(!(get_user_flags(id) & ADMIN_RESERVATION))
	{
		RenkliYazi(id,"!g%s !n: !tUzgunum, !nYetkiniz Yeterli Degil.!", server)
		return PLUGIN_HANDLED	
	}
	{
	new menu = menu_create("\y-> \rOzel Ban Sistemi \y<- ","AnaMenuHandle")
	
	menu_additem(menu , "    ---> UzaBAN \r[\ySuresiz Sekilde Yasaklar\r]", "1", 0)
	menu_additem(menu , "    ---> UcanBAN \r[\yServere Girisine Engel Koyar\r]", "2", 0)
	menu_additem(menu , "    ---> Yasak Kaldir \r[\yUcanBAN Yasagini Kaldirir\r]", "3", 0)
	
	
	
	menu_setprop(menu,MPROP_EXITNAME,"Cikis ^n^n\yVersion: \r1.5.0 Tim Ailesi Ozel^n\yby \rPersians");
	
	menu_setprop(menu,MPROP_EXIT,MEXIT_ALL);
	
	menu_display(id,menu)
	return PLUGIN_HANDLED
}
}

public AnaMenuHandle(id, menu, item) {
switch(item) {
	case 0: {
		abuzeruzaban(id);
	}
	case 1: {
		farklibanmenu(id);
	}
	case 2: {
		bankaldir(id) ;
	}
	
}
menu_destroy(menu)
return PLUGIN_HANDLED
}


public farklibanmenu(id){

if(get_user_flags(id) & ADMIN_RCON)
{
	static opcion[64]
	
	formatex(opcion, charsmax(opcion),"\yUCANBAN icin oyuncu sec")
	new iMenu = menu_create(opcion, "farklibanmenudevam")
	
	new players[32], tempid
	new szName[32], szTempid[10]
	new pnum
	
	
	get_players(players, pnum)
	
	for( new i; i<pnum; i++ )
	{
		tempid = players[i]
		if(is_user_connected(tempid) && is_user_bot(tempid) && !(get_user_flags(tempid) & ADMIN_RCON)){
			get_user_name(tempid, szName, 31)
			num_to_str(tempid, szTempid, 9)
			formatex(opcion, charsmax(opcion), "\w%s", szName)
			menu_additem(iMenu, opcion, szTempid, 0)
		}
		
	}
	
	menu_display(id, iMenu)
	
}
else
{
	RenkliYazi(id,"!t[!g%s!t]!n: Yetkiniz Yeterli Degil", server)
}	
}

public farklibanmenudevam(id, menu, item)
{
if( item == MENU_EXIT )
{
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

new Data[6], Name[64]
new Access, Callback
menu_item_getinfo(menu, item, Access, Data,5, Name, 63, Callback)

new tempid = str_to_num(Data)


cmdFarkliBan(id,tempid)
menu_destroy(menu)
return PLUGIN_HANDLED
}


public cmdFarkliBan(id,banlanan)
{

	if (!banlanan)
	return PLUGIN_HANDLED;
	new iFile = fopen(file, "a+");	
	new authid[32]
	new userid = get_user_userid(banlanan)
	new address[32]
	get_user_ip(banlanan, address, 31, 1)
	
	get_user_authid(banlanan, authid, 31)
	if(iFile) {
	server_cmd("kick #%d ^"UcanBAN ile banlandiniz^";wait;banid 999999999999 %s;wait;writeid", userid, authid)
	server_cmd("wait;addip ^"9999999999999^" ^"%s^";wait;writeip", address)
	fprintf(iFile, fmt("%s^n", authid));	
	pers_duzenle(file)
	RenkliYazi(id,"!t[!g%s!t]!n: !g^"%s^" !t isimli yetkili !g^"%s^" !t isimli oyuncuya !gUCAN BAN ATTI",server ,isimver(id), isimver(banlanan))
	fclose(iFile);
	}
	return PLUGIN_HANDLED
}

public isimver(oyuncu){
	new isim[32]
	get_user_name(oyuncu, isim, 31)
	return isim;
}


public abuzeruzaban(id){
	
	if(get_user_flags(id) & ADMIN_BAN)
	{
		static opcion[64]
		
		formatex(opcion, charsmax(opcion),"\yUZABan icin oyuncu sec")
		new iMenu = menu_create(opcion, "abuzeruzabandevam")
		
		new players[32], tempid
		new szName[32], szTempid[10]
		new pnum
		
		
		get_players(players, pnum)
		
		for( new i; i<pnum; i++ )
		{
			tempid = players[i]
			if(is_user_connected(tempid) && !is_user_bot(tempid) && !(get_user_flags(tempid) & ADMIN_BAN)){
				get_user_name(tempid, szName, 31)
				num_to_str(tempid, szTempid, 9)
				formatex(opcion, charsmax(opcion), "\w%s", szName)
				menu_additem(iMenu, opcion, szTempid, 0)
			}
			
		}
		
		menu_display(id, iMenu)
		
	}
	else
	{
		RenkliYazi(id,"!t[!g%s!t]!n: Yetkiniz Yeterli Degil", server)
	}		
}

public abuzeruzabandevam(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new Data[6], Name[64]
	new Access, Callback
	menu_item_getinfo(menu, item, Access, Data,5, Name, 63, Callback)
	
	new tempid = str_to_num(Data)
	
	
	abuzeruzaban1(id,tempid)
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public abuzeruzaban1(id,banlanan)
{
	
	if (!banlanan)
		return PLUGIN_HANDLED
	
	new authid[32]
	new userid = get_user_userid(banlanan)
	new address[32]
	get_user_ip(banlanan, address, 31, 1)
	
	get_user_authid(banlanan, authid, 31)
	
	server_cmd("kick #%d ^"UzaBAN ile banlandiniz^";wait;banid 999999999999 %s;wait;writeid", userid, authid)
	
	server_cmd("wait;addip ^"9999999999999^" ^"%s^";wait;writeip", address)
	
	RenkliYazi(id,"!t[!g%s!t]!n: !g^"%s^" !t isimli yetkili !g^"%s^" !t isimli oyuncuya !gUZA BAN ATTI",server ,isimver(id), isimver(banlanan))
	
	
	return PLUGIN_HANDLED
}

public bankaldir(id) {
	
	new menu = menu_create("\rUcanBAN \yKaldir","bankaldir2")
	
	new szLine[248];
	new LineName[32];
	new maxlines,txtlen,linee[6];
	maxlines = file_size(file,1);
	for(new line;line<maxlines;line++) {
		szLine[0] = 0;
		LineName[0] = 0;
		read_file(file,line,szLine,247,txtlen)
		
		if(szLine[0]) {
			parse(szLine,LineName,31)
			if(!equali(LineName,";") ) {
				num_to_str(line,linee,5)
				menu_additem(menu,LineName,linee)
			}
		}
	}
	menu_setprop(menu,MPROP_EXIT,MEXIT_ALL)
	menu_display(id,menu,0)
}

public bankaldir2(id,menu,item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new data[6],name[64];
	new access,callback;
	menu_item_getinfo(menu,item,access,data,5,name,63,callback)
	write_file(file,"",str_to_num(data))
	pers_duzenle(file)
	RenkliYazi(id,"!t[!g%s!t]!n: !tBan Basarili Bir Sekilde Kaldirildi!n. !gYasakli ID!n:!t%s",server,name)
	return PLUGIN_HANDLED
}


public version(id)
	{
	console_print(id, "[Persians] Suanki Kullanilan Version: [%s]", VERSION);
	}


stock sayyaz(const id, const string[], {Float, Sql, Resul,_}:...) {
	
	new msg[191], players[32], count = 1;
	vformat(msg, sizeof msg - 1, string, 3);
	
	replace_all(msg,190,"!g","^4");
	replace_all(msg,190,"!y","^1");
	replace_all(msg,190,"!t","^3");
	
	if(id)
		players[0] = id;
	else
		get_players(players,count,"ch");
	
	for (new i = 0 ; i < count ; i++)
	{
		if (is_user_connected(players[i]))
		{
			message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"),_, players[i]);
			write_byte(players[i]);
			write_string(msg);
			message_end();
		}		
	}
}


stock RenkliYazi(const id, const input[], any:...)
{
	new count = 1, players[32];
	static msg[191];
	vformat(msg, sizeof(msg) - 1, input, 3);
	
	replace_all(msg, sizeof(msg) - 1, "!n", "^x01"); 
	replace_all(msg, sizeof(msg) - 1, "!g", "^x04"); 
	replace_all(msg, sizeof(msg) - 1, "!t", "^x03"); 
	
	if(id) players[0] = id; else get_players(players, count, "ch"); {
		for(new i = 0; i < count; i++)
		{
			if(is_user_connected(players[i]))
			{
				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i]);
				write_byte(players[i]);
				write_string(msg);
				message_end();
			}
		}
	}
}

pers_duzenle(const filename[]) {
	
	static const temp_filename[] = "silinen_bosluklar.txt";
	
	new f = fopen(filename, "rt");
	
	if( !f ) return -1;
	
	new lines = 0;
	new t = fopen(temp_filename, "wt");
	
	static data[512];
	while( !feof(f) ) {
		fgets(f, data, sizeof(data) - 1);
		if( data[0] && data[0] != '^n' ) {
			fputs(t, data);
		}
		else {
			lines++;
		}
	}
	
	fclose(f);
	fclose(t);
	
	delete_file(filename);
	
	rename_file(temp_filename, filename, 1);
	
	return lines;
} 