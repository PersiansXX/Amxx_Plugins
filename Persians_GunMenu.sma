/* Plugin generated by AMXX-Studio */


#include <amxmodx>
#include <amxmisc>
#include <reapi>

#define PLUGIN "Silah Menu"
#define VERSION "1.2"
#define AUTHOR "Persians"

#define SetBit(%0,%1)			((%0) |= (1 << (%1 - 1)))
#define ClearBit(%0,%1)			((%0) &= ~(1 << (%1 - 1)))
#define IsSetBit(%0,%1)			((%0) & (1 << (%1 - 1)))
#define InvertBit(%0,%1)		((%0) ^= (1 << (%1 - 1)))
#define IsNotSetBit(%0,%1)		(~(%0) & (1 << (%1 - 1)))

new const TAG[] = "Persians"


enum _: bitsPlayer	{
	BIT_NONE,
	
	BIT_ALIVE,
	BIT_CONNECTED,
	BIT_MENU_EQUIPMENT,
	
	BIT_MAX
};

enum listWeaponInfo	{
	WEAPON_NAME[12],
	WEAPON_CLASSNAME[16],
	WeaponIdType: WEAPON_ID,
	WEAPON_BPAMMO
};

enum playerEquipment	{
	PLAYER_EQUIPMENT_PRIMARY,
	PLAYER_EQUIPMENT_SECONDARY
};

new gp_iBit[bitsPlayer],
	gp_iEquipment[MAX_PLAYERS + 1][playerEquipment];

new gp_iMenuPosition[MAX_PLAYERS + 1];


	
new const g_listPrimaryWeaponszMenu[][listWeaponInfo] =	{
	{},

	{"M4A1", "weapon_m4a1", WEAPON_M4A1, 90},
	{"AK47", "weapon_ak47", WEAPON_AK47, 90},
	{"AWP", "weapon_awp", WEAPON_AWP, 30},
	{"GALIL","weapon_galil", WEAPON_GALIL, 90},
	{"FAMAS", "weapon_famas", WEAPON_FAMAS, 90},
	{"AUG", "weapon_aug", WEAPON_AUG, 90},
	{"MP5", "weapon_mp5navy", WEAPON_MP5N, 90},
	{"TMP", "weapon_tmp", WEAPON_TMP, 90},
	{"G3SG1", "weapon_g3sg1", WEAPON_G3SG1, 90},
	{"SG552", "weapon_sg552", WEAPON_SG552, 90}
};

new const g_listSecondaryWeaponszMenu[][listWeaponInfo] =	{
	{},
	
	{"USP", "weapon_usp", WEAPON_USP, 120},
	{"Deagle", "weapon_deagle", WEAPON_DEAGLE, 30},
	{"Glock18", "weapon_glock18", WEAPON_GLOCK18, 120},
};

new const g_listGrenades[] =	{
	"weapon_hegrenade",
	"weapon_flashbang",
	"weapon_flashbang"
};

new g_iPrimaryWeapons,
	g_iSecondaryWeapons;
	
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	
	register_clcmd("say /silah", "abuzermenuyuacmk")
	
	g_iPrimaryWeapons = sizeof(g_listPrimaryWeaponszMenu);
	g_iSecondaryWeapons = sizeof(g_listSecondaryWeaponszMenu);	
	
	MenuCmd_Init();
	ReAPI_Init();
}

ReAPI_Init()	{
	RegisterHookChain(RG_CBasePlayer_Spawn, "HC_CBasePlayer_Spawn_Post", true);
}

public client_putinserver(iIndex)	{
	if(is_user_bot(iIndex) || is_user_hltv(iIndex))
	{
		return PLUGIN_HANDLED;
	}
	
	SetBit(gp_iBit[BIT_CONNECTED], iIndex);
	SetBit(gp_iBit[BIT_MENU_EQUIPMENT], iIndex);



	return PLUGIN_CONTINUE;
}



public abuzermenuyuacmk(const iIndex)	{
	SetBit(gp_iBit[BIT_MENU_EQUIPMENT], iIndex);
	client_print_color(iIndex, iIndex, "^1[^4%s^1]: ^3Silah Menusu Tekrar Aktif Oldu.", TAG);

	return PLUGIN_HANDLED;
}


public HC_CBasePlayer_Spawn_Post(const iIndex)	{
	if(is_user_alive(iIndex))
	{
		if(IsNotSetBit(gp_iBit[BIT_ALIVE], iIndex))
		{
			SetBit(gp_iBit[BIT_ALIVE], iIndex);
		}

		if(IsSetBit(gp_iBit[BIT_MENU_EQUIPMENT], iIndex))
		{
			ShowMenu_Equipment(iIndex);
		}
		else
		{
			new iPrimaryWeaponId = gp_iEquipment[iIndex][PLAYER_EQUIPMENT_PRIMARY];
			new iSecondaryWeaponId = gp_iEquipment[iIndex][PLAYER_EQUIPMENT_SECONDARY];
			
			givePlayerPrimaryWeapon(iIndex, iPrimaryWeaponId);
			givePlayerSecondaryWeapon(iIndex, iSecondaryWeaponId);
			givePlayerGrenades(iIndex);
		}
		
	}
}



MenuCmd_Init()	{
	register_menucmd(register_menuid("ShowMenu_Equipment"), MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_0, "Handler_Equipment");
	register_menucmd(register_menuid("ShowMenu_PrimaryWeapons"), MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0, "Handler_PrimaryWeapons");
	register_menucmd(register_menuid("ShowMenu_SecondaryWeapons"), MENU_KEY_1|MENU_KEY_2|MENU_KEY_3|MENU_KEY_4|MENU_KEY_5|MENU_KEY_6|MENU_KEY_7|MENU_KEY_8|MENU_KEY_9|MENU_KEY_0, "Handler_SecondaryWeapons");
}


ShowMenu_Equipment(const iIndex)	{
	static szMenu[512]; new iBitKeys = MENU_KEY_1|MENU_KEY_0;
	new iLen = formatex(szMenu, charsmax(szMenu), "\r-------------------------------^n \r--   \ySilahinizi Seciniz  \r--^n\w-------------------------------^n^n^n");
	
	iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\r[\w1\r] \wYeni Silah Sec^n");
	
	static iPrimaryWeaponId; iPrimaryWeaponId = gp_iEquipment[iIndex][PLAYER_EQUIPMENT_PRIMARY];
	static iSecondaryWeaponId; iSecondaryWeaponId = gp_iEquipment[iIndex][PLAYER_EQUIPMENT_SECONDARY];

	if(!(iPrimaryWeaponId) || !(iSecondaryWeaponId))
	{
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\r[\d2\r] \dEski Silahini Sec^n");
	}
	else
	{
		iBitKeys |= MENU_KEY_2;
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\r[\w2\r] \wEski Silahini Sec \r[ \y%s | %s \r]^n", g_listPrimaryWeaponszMenu[iPrimaryWeaponId], g_listSecondaryWeaponszMenu[iSecondaryWeaponId]);
	}
	
	if(!(iPrimaryWeaponId) || !(iSecondaryWeaponId))
	{
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\r[\d3\r] \dMenuyu Bir Daha Gosterme�^n^n^n^n");
	}
	else
	{
		iBitKeys |= MENU_KEY_3;
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\r[\w3\r] \wMenuyu Bir Daha Gosterme^n^n^n^n");
	}
	
	formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\r[\y0\r] \r-- \yCikis \r-- \dPersians");

	return show_menu(iIndex, iBitKeys, szMenu, -1, "ShowMenu_Equipment");
}

public Handler_Equipment(const iIndex, const iKey)	{
	if(IsNotSetBit(gp_iBit[BIT_ALIVE], iIndex))
	{
		return PLUGIN_HANDLED;
	}
	
	switch(iKey)
	{
		case 0:
		{
			return ShowMenu_PrimaryWeapons(iIndex, gp_iMenuPosition[iIndex] = 0);
		}
		case 1, 2:
		{
			new iPrimaryWeaponId = gp_iEquipment[iIndex][PLAYER_EQUIPMENT_PRIMARY];
			new iSecondaryWeaponId = gp_iEquipment[iIndex][PLAYER_EQUIPMENT_SECONDARY];
			
			givePlayerPrimaryWeapon(iIndex, iPrimaryWeaponId);
			givePlayerSecondaryWeapon(iIndex, iSecondaryWeaponId);
			
			givePlayerGrenades(iIndex);

			if(iKey == 2){
			ClearBit(gp_iBit[BIT_MENU_EQUIPMENT], iIndex) ;
			client_print_color(iIndex, iIndex, "^1[^4%s^1]: ^3Otomatik Silah Modu Aktif. Menuyu Tekrar Aktif Etmek Icin /silah Yazin.", TAG);
		}
		}
	}
	
	return PLUGIN_HANDLED;
}

ShowMenu_PrimaryWeapons(const iIndex, const iPos)	{
	if(iPos < 0 || !(g_iPrimaryWeapons))
	{
		return PLUGIN_HANDLED;
	}
	
	static iStart; iStart = iPos * 8;
	
	if(iStart > g_iPrimaryWeapons)
	{
		iStart = g_iPrimaryWeapons;
	}
	
	iStart = iStart - (iStart % 8);
	
	gp_iMenuPosition[iIndex] = iStart / 8;

	static iEnd; iEnd = iStart + 8;
	
	if(iEnd > g_iPrimaryWeapons)
	{
		iEnd = g_iPrimaryWeapons;
	}
	
	static iPagesNum; iPagesNum = (g_iPrimaryWeapons / 8 + ((g_iPrimaryWeapons % 8) ? 1 : 0));
	
	static szMenu[512], iBitKeys = MENU_KEY_0;
	new iLen = formatex(szMenu, charsmax(szMenu), "\r[%s] \wSilahinizi Seciniz \d[\r%d\w|\r%d\d]^n^n", TAG, iPos + 1, iPagesNum);

	new iItem = 0, iCount;
	for(iCount = iStart + 1; iCount < iEnd; iCount++)
	{
		iBitKeys |= (1 << iItem);
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\r[%d] \w%s^n", ++iItem, g_listPrimaryWeaponszMenu[iCount][WEAPON_NAME]);
	}
	
	for(iCount = iItem; iCount < 8; iCount++)
	{
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n");
	}
	
	if(iEnd < g_iPrimaryWeapons)
	{
		iBitKeys |= MENU_KEY_9;
		formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n\r[9] \wIleri^n\r[0] \w%s", iPos ? "Geri" : "Cikis");
	}
	else
	{
		formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n^n\r[0] \w%s", iPos ? "Geri" : "Cikis");
	}
	
	return show_menu(iIndex, iBitKeys, szMenu, -1, "ShowMenu_PrimaryWeapons");
}

public Handler_PrimaryWeapons(const iIndex, const iKey)	{
	if(IsNotSetBit(gp_iBit[BIT_ALIVE], iIndex))
	{
		return PLUGIN_HANDLED;
	}
	
	switch(iKey)
	{
		case 8:
		{
			return ShowMenu_PrimaryWeapons(iIndex, ++gp_iMenuPosition[iIndex]);
		}
		case 9:
		{
			return ShowMenu_PrimaryWeapons(iIndex, --gp_iMenuPosition[iIndex]);
		}
		default:
		{
			new iWeaponId = gp_iMenuPosition[iIndex] * 8 + iKey + 1;
			
			givePlayerPrimaryWeapon(iIndex, iWeaponId);

			return ShowMenu_SecondaryWeapons(iIndex, gp_iMenuPosition[iIndex] = 0);
		}
	}
	return PLUGIN_HANDLED;
}

ShowMenu_SecondaryWeapons(const iIndex, const iPos)	{
	if(iPos < 0 || !(g_iSecondaryWeapons))
	{
		return PLUGIN_HANDLED;
	}
	
	static iStart; iStart = iPos * 8;
	
	if(iStart > g_iSecondaryWeapons)
	{
		iStart = g_iSecondaryWeapons;
	}
	
	iStart = iStart - (iStart % 8);
	
	gp_iMenuPosition[iIndex] = iStart / 8;

	static iEnd; iEnd = iStart + 8;
	
	if(iEnd > g_iSecondaryWeapons)
	{
		iEnd = g_iSecondaryWeapons;
	}
	
	static iPagesNum; iPagesNum = (g_iSecondaryWeapons / 8 + ((g_iSecondaryWeapons % 8) ? 1 : 0));
	
	static szMenu[512], iBitKeys = MENU_KEY_0;
	new iLen = formatex(szMenu, charsmax(szMenu), "\r[%s] \wSilahinizi Seciniz \d[%d|%d]^n^n", TAG, iPos + 1, iPagesNum);

	new iItem = 0, iCount;
	for(iCount = iStart + 1; iCount < iEnd; iCount++)
	{
		iBitKeys |= (1 << iItem);
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "\r[%d] \w%s^n", ++iItem, g_listSecondaryWeaponszMenu[iCount][WEAPON_NAME]);
	}
	
	for(iCount = iItem; iCount < 8; iCount++)
	{
		iLen += formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n");
	}
	
	if(iEnd < g_iSecondaryWeapons)
	{
		iBitKeys |= MENU_KEY_9;
		formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n\r[9] \wIleri^n\r[0] \w%s", iPos ? "Geri" : "Cikis");
	}
	else
	{
		formatex(szMenu[iLen], charsmax(szMenu) - iLen, "^n^n\r[0] \w%s", iPos ? "Geri" : "Cikis");
	}
	
	return show_menu(iIndex, iBitKeys, szMenu, -1, "ShowMenu_SecondaryWeapons");
}

public Handler_SecondaryWeapons(const iIndex, const iKey)	{
	if(IsNotSetBit(gp_iBit[BIT_ALIVE], iIndex))
	{
		return PLUGIN_HANDLED;
	}
	
	switch(iKey)
	{
		case 8:
		{
			return ShowMenu_SecondaryWeapons(iIndex, ++gp_iMenuPosition[iIndex]);
		}
		case 9:
		{
			return ShowMenu_SecondaryWeapons(iIndex, --gp_iMenuPosition[iIndex]);
		}
		default:
		{
			new iWeaponId = gp_iMenuPosition[iIndex] * 8 + iKey + 1;
			
			givePlayerSecondaryWeapon(iIndex, iWeaponId);
			givePlayerGrenades(iIndex);
		}
	}
	
	return PLUGIN_HANDLED;
}

stock givePlayerPrimaryWeapon(const iIndex, const iPrimaryWeaponId)	{
	if(iPrimaryWeaponId)
	{
		gp_iEquipment[iIndex][PLAYER_EQUIPMENT_PRIMARY] = iPrimaryWeaponId;

		rg_give_item(iIndex, g_listPrimaryWeaponszMenu[iPrimaryWeaponId][WEAPON_CLASSNAME], GT_REPLACE);
		rg_set_user_bpammo(iIndex, g_listPrimaryWeaponszMenu[iPrimaryWeaponId][WEAPON_ID], g_listPrimaryWeaponszMenu[iPrimaryWeaponId][WEAPON_BPAMMO]);
	}
}

stock givePlayerSecondaryWeapon(const iIndex, const iSecondaryWeaponId)	{
	if(iSecondaryWeaponId)
	{
		gp_iEquipment[iIndex][PLAYER_EQUIPMENT_SECONDARY] = iSecondaryWeaponId;

		rg_give_item(iIndex, g_listSecondaryWeaponszMenu[iSecondaryWeaponId][WEAPON_CLASSNAME], GT_REPLACE);
		rg_set_user_bpammo(iIndex, g_listSecondaryWeaponszMenu[iSecondaryWeaponId][WEAPON_ID], g_listSecondaryWeaponszMenu[iSecondaryWeaponId][WEAPON_BPAMMO]);
	}
}

stock givePlayerGrenades(const iIndex)	{
	for(new iCount = 0; iCount < sizeof(g_listGrenades); iCount++)
	{
		rg_give_item(iIndex, g_listGrenades[iCount]);
	}
}