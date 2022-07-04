/*================================================================================ 
 [Include Basic Files] 
=================================================================================*/ 
#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#include <engine>
#include <fun>

#include <zombiemodez>
#include <orpheu>

 /*================================================================================ 
 [Global Definitions] & [Include Individual Files] ：
 --->Required Library And Definitions. Cannot Be Modified
 仅供查看本插件支持或需要的模块，勿修改.
=================================================================================*/ 
#define LIBRARY_MH "metahook"
#include <metahook>
#define LIBRARY_STE "zombiemode"
#include <zombiemode> 
#define LIBRARY_BTE "bte_api"
#include <bte_api>
#define LIBRARY_ZP "zp50_core"
#include <zp50_core> 


 #define _gBaseData->%0(%1) \
								\
_GlobalBaseData:OnHook_%0				\
(								\
	%1 							\
								\
) 
enum _GlobalBaseData
{
	GlobalBaseIgnored,
	GlobalBaseOverride,
	GlobalBaseSupercede
}

#define	 CBaseData stock

#define gBaseData ~%0(%1,%any...) \\%0\(\%1, \%any...,\\)
#define GlobalBaseData *gBaseData

CBaseData _GlobalBaseData:OnHook_Is_UserZombie(id, Others)
{
	#pragma unused Others
	new iReturn;

	if(LibraryExists(LIBRARY_BTE, LibType_Library) && bte_get_user_zombie(id))
		iReturn = GlobalBaseOverride
	else if(LibraryExists(LIBRARY_STE, LibType_Library) && STE_GetUserZombie(id))
		iReturn =  GlobalBaseOverride
	else if(LibraryExists(LIBRARY_ZP, LibType_Library) && zp_core_is_zombie(id))
		iReturn =  GlobalBaseOverride
	else
		iReturn =  GlobalBaseIgnored
	return  iReturn

}


#include "ZombieModeZ/Vars.sma"
#include "ZombieModeZ/Tasks.sma"
#include "ZombieModeZ/Public.sma"
#include "ZombieModeZ/Stocks.sma"
#include "ZombieModeZ/Ham.sma"
#include "ZombieModeZ/Forward.sma"
#include "ZombieModeZ/EventCmd.sma"
#include "ZombieModeZ/ReadFile.sma"
#include "ZombieModeZ/Extra.sma"
native MH_GetScreenWidth();
native MH_GetScreenHeight();
//自定义函数建议删掉




static const g_WpnNames[][] = { "", "weapon_p228", "", "weapon_scout", "", "", "", "weapon_mac10",
"weapon_aug", "", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550",
"weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249",
"", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "", "weapon_deagle", "weapon_sg552",
"weapon_ak47", "", "weapon_p90" }
new msg1,msg2

public plugin_init()
{
	register_plugin("CSBTE ZBZ", "AlphaTest", "1");
	Upgrade_initial()

	RegisterHam(Ham_Spawn, "player", "HAM_PlayerSpawn_Post", 1);
	RegisterHam(Ham_Killed,"player","RemoveHud");
	RegisterHam(Ham_TakeDamage, "player", "HAM_TakeDamage")

	RegisterHam(Ham_Think,"info_target","Func_EntityThink");
	RegisterHam(Ham_Touch,"info_target","Func_EntityTouch");
	RegisterHam(Ham_Touch,"player","Func_Jcgr");

	RegisterHam(Ham_Think, "weapon_knife", "HAM_Knife_AttackThink")
	RegisterHam(Ham_Think,"grenade","HAM_Grenade_Think",0);
	RegisterHam(Ham_Item_Deploy, "weapon_knife", "HAM_Item_Deploy_Post", 1)
	RegisterHam(Ham_Item_Holster, "weapon_knife", "HAM_Item_Holster_Post", 1)

	RegisterHam(Ham_Item_PreFrame,"player","HAM_Player_ResetMaxSpeed",1);

	for (new i = 1; i < sizeof g_WpnNames; i++)
	{
		if (g_WpnNames[i][0])
		{
			RegisterHam(Ham_Weapon_Reload, g_WpnNames[i], "HAM_WeaponReload", 1)
			RegisterHam(Ham_Weapon_PrimaryAttack, g_WpnNames[i], "HAM_Weapon_PrimaryAttack")
		}
	}

	register_event("DeathMsg", "Event_Death", "a");
	register_event("Damage", "Event_Damage", "b", "2!0", "3=0", "4!0");
	register_event("HLTV","Event_HLTV_New_Round","a","1=0","2=0");
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1")
	g_msgCurWeapon = get_user_msgid("CurWeapon")

	register_forward(FM_CmdStart, "fw_CmdStart");
	register_forward(FM_SetModel,"fw_SetModel",1);
	register_forward(FM_PlayerPreThink,"fw_PlayerPreThink")
	register_forward(FM_PlayerPreThink,"fw_PlayerThink")

	//register_forward(FM_PlayerPostThink, "fw_PlayerPostThink");
	register_forward(FM_ClientCommand , "fw_ClientCommand");
	register_forward(FM_StartFrame, "fw_StartFrame_Post", 1)
	register_forward(FM_AddToFullPack, "fw_AddToFullPack", 1);



	g_MaxPlayers = get_maxplayers();
	gmsgAmmoPickup = get_user_msgid("AmmoPickup");


	handleApplyMultiDamage = OrpheuGetFunction( "ApplyMultiDamage" )
	handleClearMultiDamage = OrpheuGetFunction( "ClearMultiDamage" )


	register_clcmd("get_points", "get_skill");//bind  v
	register_clcmd("get_points2", "Advance_Skill");//bind  p
	server_cmd("bind v get_points");
	//server_cmd("bind m showzbmenu");

	server_cmd("bind p get_points2");

	register_clcmd("dd","ldslc")
	msg2= engfunc(EngFunc_RegUserMsg, "ZBZUI2", -1);
	msg1 = engfunc(EngFunc_RegUserMsg, "ZBZUI", -1);
	

	#if defined _DEBUG
	register_concmd("c30","cheat")
	register_concmd("c0","cheat_remove")
	#endif
	register_clcmd( "ss", "d" );//疫苗弹
	register_clcmd( "neverzombie", "d2" );//疫苗弹
}
public d(id) fm_give_item(id, "weapon_smokegrenade")
public d2(id) 
{
//bte_wpn_give_named_wpn(id,"hegrenade")
set_pev(id,pev_health,1.0)
set_pev(id,pev_takedamage,0)
}
public ldslc(id)
{
	new ent
	Func_Ldsl(id,ent,1)
}

public plugin_natives()
{
	register_library( "Bte_ZbzApi")
	set_module_filter("module_filter")
	set_native_filter("native_filter")

	register_native("zbz_get_headstrike", "native_zbz_get_headstrike", 1)
	register_native("zbz_get_burndamage", "native_zbz_get_burndamage", 1)
	register_native("zbz_get_miss", "native_zbz_get_miss", 1)
	register_native("zbz_get_deadlyattack", "native_zbz_get_deadlyattack", 1)

	register_native("zbz_get_user_level", "native_zbz_get_user_level", 1)
	register_native("zbz_get_user_Exp", "native_zbz_get_Exp", 1)
	register_native("zbz_get_user_levelExp", "native_zbz_get_levelExp", 1)
}

public module_filter(const module[])
{
	if (equal(module, LIBRARY_MH)||equal(module, LIBRARY_BTE)||equal(module, LIBRARY_ZP)||equal(module, LIBRARY_STE))
		return PLUGIN_HANDLED;
    
	return PLUGIN_CONTINUE;
}

public native_filter(const name[], index, trap)
{
	if (!trap)
		return PLUGIN_HANDLED;
    
	return PLUGIN_CONTINUE;
}
public native_zbz_get_user_level(id)
{
	return z_level[id]
}

public native_zbz_get_headstrike(id)
{
	return ZmyjEnable[id]
}
public native_zbz_get_burndamage(id)
{
	return BurnDamageEnable[id]
}
public native_zbz_get_miss(id)
{
	return QxzjEnable[id]
}

public native_zbz_get_deadlyattack(id)
{
	//return czyh[id]
}
public native_zbz_get_Exp(id)
{
	return fSavedDmg[id]
}
public native_zbz_get_levelExp(id)
{
	return fUpgrade_rst[ iLevel[id] ]
}

public plugin_end()
{

}
public plugin_precache()
{
	new file[256], config[256], mapname[256]
	get_mapname(mapname, charsmax(mapname))
	get_localinfo("amxx_configsdir", config, charsmax(config))
	formatex(file, charsmax(file), "%s/zombie.ini", config)
	if (file_exists(file)) LoadConfigs(file)

	engfunc(EngFunc_PrecacheModel, "models/allstarrevenant_fireball.mdl")

	for(new i = 0; i < sizeof(Gdds_Sounds); i++) engfunc(EngFunc_PrecacheSound, Gdds_Sounds[i])
	engfunc(EngFunc_PrecacheModel, "models/zombiezwingfx.mdl")
	engfunc(EngFunc_PrecacheModel,"sprites/ef_smoke_sb.spr")
	engfunc(EngFunc_PrecacheModel, "models/v_emotion2.mdl")
	engfunc(EngFunc_PrecacheModel, "models/b52.mdl")
	engfunc(EngFunc_PrecacheModel, "models/bunkerbuster_missile.mdl")
	engfunc(EngFunc_PrecacheModel, "models/bunkerbuster_target.mdl")
	g_szSmokeSprites = engfunc(EngFunc_PrecacheModel, "sprites/gas_puff_01b.spr")
	g_Explosion_SprId = engfunc(EngFunc_PrecacheModel, "sprites/explodeup.spr")

	engfunc(EngFunc_PrecacheModel, "sprites/ef_cannon6_fire.spr")

	engfunc(EngFunc_PrecacheModel, LevelUpSpr)
	engfunc(EngFunc_PrecacheSound, "zbz/revenant_fireball_explode.wav")

	precache_sound(SOUND_EXPLODE); // grenade explodes
	precache_sound(SOUND_FROZEN); // player is frozen
	engfunc(EngFunc_PrecacheSound, "debris/glass3.wav")
	Eff_FrostSmoke = engfunc(EngFunc_PrecacheModel, "sprites/water_smoke.spr")
	Eff_FrostExplo = engfunc(EngFunc_PrecacheModel, "sprites/frost_explode.spr")
	Eff_FrostGib= engfunc(EngFunc_PrecacheModel, "sprites/frostgib.spr")
	engfunc(EngFunc_PrecacheModel, "models/iceblock.mdl")

	m_spriteTexture = precache_model("sprites/laserbeam.spr")
	rockeexplode = precache_model("sprites/explodeup.spr")
	precache_model("sprites/flame3.spr")


}




////////////////////////////////////////////////////////////////////////////////////////////////
#define MAX_SKILLS 71
#define MAX_SLOTS 40
new g_bRegistered;
new g_iSlot[33][MAX_SLOTS+1], g_iActived[33][MAX_SKILLS+1], g_iAdvanced[33][MAX_SKILLS+1];
new g_iSkills[33];
new g_iSave[33]

new get_validskill

// Main Functions
public skill_init()
{
	new id;
	new skill_index;
	for (id = 0; id<32; id++)
	{
		z_level[id] = 1;
		z_point[id] = 1;
		for (skill_index = 0; skill_index<skill_count; skill_index++)
		{
			SaveData_Pool[id][skill_index] = Skill_List[skill_index];
		}
	}
	for(new i=0; i<MAX_SKILLS; i++){
		if(i<=MAX_SLOTS ) g_iSlot[id][i] = 0;
		g_iActived[id][i] = 0;
		g_iAdvanced[id][i] = 0;
	}

}

public update_skill(id)
{
	new skill_index;
	new set_flag;
	new last = z_level[id]-z_point[id];
	for(skill_index = 0; skill_index < last; skill_index++)
	{
		set_flag = SaveData_Get[id][skill_index];
		SaveData_Flag[id][set_flag] = 1;
	}
}

//2.0
public get_skill2(id,iSelect)
{
	if(g_iSkills[id] >= MAX_SLOTS) return PLUGIN_HANDLED;
	new iSelected = iSelect    /*random_num(1, MAX_SKILLS - g_iSkills[id]) */  //选择 要获得 第几个 尚未获得的能力
	/*for(new i=1; i<=MAX_SKILLS; i++ ){
		if(g_iActived[id][i]) continue;   //排除掉已经获得的能力
		iSelected--;                      //等待获取的数量 - 1
		if(iSelected < 1){                        //i为选中的技能id
			g_iSkills[id]++;                //记录获取了多少个能力
			g_iSlot[id][g_iSkills[id]] = i;         //记录技能槽里 是哪个技能
			g_iActived[id][i] = 1;              //标记 这个技能已经被获取
			client_cmd(id, "spk events/enemy_died.wav");  //播放音效提示触发了一次
			break;
		}
	}	*/
	if(!iSelected)
		return PLUGIN_HANDLED;
	g_iSkills[id]++;                //记录获取了多少个能力
	g_iSlot[id][g_iSkills[id]] = iSelected + 1;         //记录技能槽里 是哪个技能
	g_iActived[id][iSelected + 1] = 1;         
	client_cmd(id, "spk events/enemy_died.wav");  //播放音效提示触发了一次
	
	return PLUGIN_HANDLED;
	
	
}
public Advance_Skill(id)
{
	//client_print(id, print_chat, "Tried advancing LittleBloodPlate Skills");

	new iFree_Slop = 0, iCanAdvanceCount = 0;
	for(new i =1; i<=MAX_SLOTS; i++){
		if( !(g_iAdvanced[id][g_iSlot[id][i]]) && Can_Advance(g_iSlot[id][i]) ){  //找到一个能升级的技能
			if( iFree_Slop == 0){   
				iFree_Slop = i;    //记录第一个能升级的技能槽位置
			}
			iCanAdvanceCount++;   //记录有几个技能可以升级
		}
	}

	if(iFree_Slop < 1) return PLUGIN_HANDLED;

	new iSelected = random_num(1, iCanAdvanceCount); //选定 升级第几个可升级的技能槽
	for(new i=0; i<=MAX_SLOTS; i++ ){
		if(!Can_Advance(g_iSlot[id][i])) continue;   //排除掉不可升级的槽位
		if(g_iAdvanced[id][g_iSlot[id][i]] ) continue; //排除掉已经升级的槽位
	//	if(!g_iActived[id][g_iSlot[id][i]]) continue;
		iSelected--;                             //等待升级的数量 - 1
		if(iSelected < 1){                        //i为选中的技能槽 g_iSlot[id][i]为选中要升级的技能
			g_iAdvanced[id][g_iSlot[id][i]] = 1;            //标记 这个能力 已经被升级
			client_cmd(id, "spk events/enemy_died.wav");  //播放音效提示触发了一次
			client_print(id, print_chat,"获得技能 %d :%s ", g_iSlot[id][i], Skill_Name[g_iSlot[id][i]]);

			z_skilling[id] = 0
			z_skilling2[id] = 1
			set_task(0.1,"Set_Emotion_Start",id)
			CreateNamedEntity(id)
			client_cmd(id, "spk sound/%s", LevelUpSound)
			g_iSave[id] = g_iSlot[id][i]



			HookMhMsg2(id)
			DrawTips(id, g_iSlot[id][i])
			Message_Change(id)
	
			break;
		}
	}

	return PLUGIN_HANDLED;
}
stock Can_Advance(iSkillID)
{
	if(equal(Skill_Info[iSkillID][3],"")) return 0;
	return 1;
}
new caleSkill[33]
public get_skill(id)
{
	if(!is_user_alive(id))
		return;
	if(!is_user_connected(id))
		return;
	if(!pev_valid(id))
		return;
	if (!z_point[id])
		return;

	new last = z_level[id] - z_point[id];
	new weight_sum;
	new index;
	for(index=0;index<skill_count-last;index++)
	{
		if(SaveData_Pool[id][index][weight]<=0)
		{
			SaveData_Pool[id][index][weight] = 1;
		}
		weight_sum += SaveData_Pool[id][index][weight];
	}
	new select = random_num(1,weight_sum);
	for(index=0;select>0&&index<skill_count-last;index++)
	{
		select -= SaveData_Pool[id][index][weight];
	}   
	SaveData_Get[id][last] = SaveData_Pool[id][index][skill];
	caleSkill[id]=SaveData_Get[id][last]
	get_skill2(id,SaveData_Get[id][last])



	client_print(id, print_chat,"获得技能 %d :%s ", SaveData_Get[id][last], Skill_Name[SaveData_Get[id][last]]);
	DrawTips(id,SaveData_Get[id][last]);
	//return
	z_point[id]--;
	update_skill(id);
	Message_Change(id)
	set_task(0.1,"Set_Emotion_Start",id)
	CreateNamedEntity(id)
	client_cmd(0, "spk sound/%s", LevelUpSound)
	client_print(id, print_chat,"剩余点数：%d ", z_point[id]);
	if (index<(skill_count-1-last))
	{
		new skill_index;
		for (skill_index = index; skill_index<(skill_count - 1 - last); skill_index++)
		{
			SaveData_Pool[id][skill_index] = SaveData_Pool[id][skill_index + 1];
		}
	}
	g_SaveUserData[id][SaveData_Get[id][last]] = 1;

	for(index = 0;index < last;index++)
	{
		if(STE_GetUserZombie(id))
		{
			if(Skill_List[SaveData_Get[id][index]][team] == human)
			{
				//MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.95,0.745-0.02*index,88,87,86,12,9999.0,0.0,0,70+index)
				//MH_DrawText(id, 0, Skill_Name[SaveData_Get[id][index]],0.95, 0.740-0.02*index, 88, 87, 86, 9999.0,30+index)
			}
			else
			{
				//MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.95,0.745-0.02*index,153,204,51,12,9999.0,0.0,0,70+index)
				//MH_DrawText(id, 0, Skill_Name[SaveData_Get[id][index]],0.95, 0.740-0.02*index, 153, 204, 51, 9999.0,30+index)
			}
		}
		else
		{
			if(Skill_List[SaveData_Get[id][index]][team] == zombie)
			{
				//MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.95,0.745-0.02*index,88,87,86,12,9999.0,0.0,0,70+index)
				//MH_DrawText(id, 0, Skill_Name[SaveData_Get[id][index]],0.95, 0.740-0.02*index, 88, 87, 86, 9999.0,30+index)
			}
			else
			{
				//MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.95,0.745-0.02*index,153,204,51,12,9999.0,0.0,0,70+index)
				//MH_DrawText(id, 0, Skill_Name[SaveData_Get[id][index]],0.95, 0.740-0.02*index, 153, 204, 51, 9999.0,30+index)
			}
		}
	}
	//HookMhMsg(id);

	
}



public level_up(id)
{
	new levelmsg3[64]
	if (z_level[id] >= max_level)
	{
		return;
	}
	z_level[id]+=1;
	z_point[id]+=1;
	client_print(id, print_chat,"剩余点数 %d | 当前等级 %d ", z_point[id],z_level[id]);
	format(levelmsg3, 63, " Level UP! Level: %d",z_level[id]);
	
	if(LibraryExists(LIBRARY_MH, LibType_Library))
		MH_DrawFontText(id,levelmsg3,1,0.50,0.68,155,110,76,20,2.5,0.0,1,21)

	//if (MH_IsMetaHookPlayer(id))
	//{
		//MH_PlayBink(id,"djb_tga/bik/zbz/levelup_line_top.bik",0.5,0.654,255,255,255,0,1,1,0)//
		//MH_PlayBink(id,"djb_tga/bik/zbz/levelup_line_bottom.bik",0.5,0.675,255,255,255,0,1,1,0)
		
		//MH_PlayBink( "media/zbz/levelup_line_top.bik", MH_GetScreenWidth()/2,MH_GetScreenHeight()/2+250, 35,255, 255, 255, 0 );
		//MH_PlayBink( "media/zbz/levelup_line_bottom.bik", MH_GetScreenWidth()/2,MH_GetScreenHeight()/2+285, 35,255, 255, 255, 0 );
		
		//native MH_PlayBink( const Video[], x,y,FrameRate = 35, Red, Green, Blue, bool: Loop );
	//}

	fnGetFirstUnlock()
	Message_Change(id)
	//Message_Change_Point(id)
	HookMhMsg(id);
}
new Nas[2][32]
fnGetFirstUnlock()
{
	static max, id,maxid
	//max=0
	new trueid[2]
	
	for (id = 1; id < 33; id++)
	{
		if (is_user_connected(id))
		{
			if(z_level[id]>max)
			{
				client_print(id,print_chat," 获取最大等级")//71
				max = z_level[id]
				maxid = id
				client_print(id,print_chat," id:%d,level%d",maxid,max)//71

				//return
				if(z_level[maxid]>=5&&z_level[maxid]<30)
				{
					new idmsg[64]
					new szName[32]
					new calelevel
					calelevel = z_level[maxid]

					get_user_name(maxid,szName,31)  //  获取名字
					get_user_name(maxid,Nas[0],31)  //  获取名字
					pev(maxid, pev_netname, szName, charsmax(szName))
					//pev(maxid, pev_netname, Nas[0], charsmax(Nas[0]))

					client_print(id,print_center," %s这个b是全房等级最高的.等级 ：%d",szName,max)//71
					format(idmsg, 63, "%d  ", szName,charsmax(szName));//转换一下，直接不然metahook不能绘制
					format(Nas[1], 31, "%d  ", calelevel,charsmax(calelevel));//转换一下，直接不然metahook不能绘制

					/*MH_DrawTargaImage(id,"mode/zbz/first_release_bg",0,0,255,255,255,0.005,0.30,2,9,6.0)
					MH_DrawFontText(id,szName,0,0.028,0.355,178,130,52,16,5.0,0.0,0,99)

					if(z_level[maxid]==5) MH_DrawTargaImage(id,"mode/zbz/zombi/speed_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==6) MH_DrawTargaImage(id,"mode/zbz/zombi/stamper_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==7) MH_DrawTargaImage(id,"mode/zbz/zombi/heal_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==11) MH_DrawTargaImage(id,"mode/zbz/zombi/pc_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==13) MH_DrawTargaImage(id,"mode/zbz/zombi/heavy_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==15) MH_DrawTargaImage(id,"mode/zbz/zombi/boomer_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==17) MH_DrawTargaImage(id,"mode/zbz/zombi/deimos_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==19) MH_DrawTargaImage(id,"mode/zbz/zombi/resident_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==21) MH_DrawTargaImage(id,"mode/zbz/zombi/deimos2_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==23) MH_DrawTargaImage(id,"mode/zbz/zombi/witch_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==25) MH_DrawTargaImage(id,"mode/zbz/zombi/pass_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==27) MH_DrawTargaImage(id,"mode/zbz/zombi/booster_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					else if(z_level[maxid]==29) MH_DrawTargaImage(id,"mode/zbz/zombi/flying_zombi",0,0,255,255,255,0.008,0.358,2,10,6.0)
					
					else
					{
						MH_DrawTargaImage(id,"",0,0,255,255,255,0.005,0.30,0,9,6.0)
						MH_DrawTargaImage(id,"",0,0,255,255,255,0.005,0.30,0,10,6.0)
						MH_DrawFontText(id,"",0,0.028,0.355,178,130,52,16,5.0,0.0,0,99)
						return
					}*/
				}
			}
		}
	}
}

new vkey[33],g_dmg[33],g_attacker[33],b_send[33];  //记录要发送的信息
new TipType[33],TipType2[33]
new SkILLname[128];



public Message_Change(id)
{
	if(!is_user_alive(id))
		return
	if(!is_user_connected(id))
		return
	if(!pev_valid(id))
		return 
	if(is_user_bot(id))
		return 


	b_send[id] = 1
	new levelmsg[64],levelmsg2[64],pointmsg[64],pointmsg2[64]
	new last = z_level[id]-z_point[id];
	new index;


	format(levelmsg, 63, "LV. %d  ", z_level[id]);
	//MH_DrawTargaImage(id,"mode/zbz/zmode_level_bg",1,0,255,255,255,0.465,0.915,0,72,999.0)
	//MH_DrawFontText(id,levelmsg,1,0.05,0.95,255,255,255,16,999.0,0.0,0,36)

	//new get_skill_num[64];
	//format(get_skill_num, 63, "目前已获得进化能力：%d  个^n状态确认[L]键", last);
	//MH_DrawText(id,get_skill_num,1,0.925,0.765,153,204,51,12,999.0,0.0,0,34)
	//MH_DrawText(id, 1,get_skill_num,0.925, 0.765, 153, 204, 51, 9999.0,29)
	//format(get_skill_num, 63, "#CSO_ZBZ_UI_NumMutation%d", last);
	//replace(get_skill_num, charsmax(get_skill_num), "%d", " %d")
	//这样可以显示%d，但是没法通过cstrike.cn.txt翻译文件显示文字

	//问：如何兼顾两点

	//format(get_skill_num, 63, "目前已获得进化能力：%d  个^n状态确认[L]键", last);
	//MH_DrawFontText(id,get_skill_num,1,0.945,0.765,153,204,51,12,999.0,0.0,0,34)//765
	//MH_DrawFontText(id,"#CSO_ZBZ_UI_Mut_KeyInfo",1,0.925,0.785,153,204,51,12,999.0,0.0,0,35)//785

	//format(pointmsg, 63, "%d", z_point[id]);
	//format(pointmsg2, 63, "%d/", z_point[id]-1);
	//Message_Change_Point(id)

	if(z_point[id])
	{
		/*MH_DrawTargaImage(id,"mode/zbz/zmode_vkey",1,1,255,255,255,0.50,0.75,0,5,999.0)*/
		/*if(z_skilling[id]||z_skilling2[id])
			MH_DrawFontText(id,"",1,0.50,0.80,153,204,51,16,999.0,0.0,0,30)
		else
			MH_DrawFontText(id,"开始进化",1,0.50,0.80,153,204,51,16,999.0,0.0,0,30)*/
		vkey[id]=1

	}
	else
	{
		/*MH_DrawTargaImage(id,"",1,1,255,255,255,0.50,0.75,0,5,999.0)
		MH_DrawFontText(id,"",1,0.50,0.80,153,204,51,16,999.0,0.0,0,30)
		//MH_DrawTargaImage(id,"",1,1,255,255,255,0.50,0.50,0,74,999.0)
		MH_DrawFontText(id,"",0,0.5,0.6,255,255,255,16,999.0,0.0,0,37)*/
		vkey[id]=0
	}
	HookMhMsg(id)
	HookMhMsg2(id)

	for(index = 0;index < last;index++)
	{
		new caleString[128]
		if(SaveData_Get[id][index]<10)
			format(caleString,127,"#CSO_ZBZ_Tooltip_Zombie3z_Mutation_id_00%d_name",SaveData_Get[id][index])
		else
			format(caleString,127,"#CSO_ZBZ_Tooltip_Zombie3z_Mutation_id_0%d_name",SaveData_Get[id][index])
		/*if(STE_GetUserZombie(id))
		{
			if(Skill_List[SaveData_Get[id][index]][team] == human)//
			{
				MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.95,0.745-0.02*index,88,87,86,12,999.0,0.0,0,70+index)
			}
			else
			{
				MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.95,0.745-0.02*index,153,204,51,12,999.0,0.0,0,70+index)
			}
		}
		else
		{
			if(Skill_List[SaveData_Get[id][index]][team] == zombie)//僵尸的技能
			{
				MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.95,0.745-0.02*index,88,87,86,12,999.0,0.0,0,70+index)
			}
			else
			{
				MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.95,0.745-0.02*index,153,204,51,12,999.0,0.0,0,70+index)
			}
		}*/
	}
		
		
}

public HookMhMsg(id)
{
	if(z_skilling2[id])
		return

	engfunc(EngFunc_MessageBegin, MSG_ONE, msg1, 0, id);
	write_short(z_level[id]);         //等级
	write_short(caleSkill[id]);
	write_short(TipType[id]);        //
	write_short(z_skilling[id]);        //
	write_short(z_point[id]);        //
	write_short(iPercent[id]);        //

	message_end();
}
public HookMhMsg2(id)
{

	engfunc(EngFunc_MessageBegin, MSG_ONE, msg2, 0, id);
	write_short(g_iSave[id]);        //
	write_short(z_skilling2[id]);        //
	write_short(TipType2[id]);        //

	message_end();
}
public fw_PlayerThink(iPlayer)
{
	//if(! ( 1 < iPlayer < 33 ) ) return;
	if(!pev_valid(iPlayer)) return
	if(! is_user_alive(iPlayer) ) return;
	//HookMhMsg(iPlayer)


}

public Message_Change_Point(id)
{
	//set_task(998.0,"Message_Changef",id)
	new forwardpoint[64],backpoint[64]

	format(forwardpoint,63,"%d",z_point[id]-1)
	format(backpoint,63,"%d",z_point[id])
	/*for(new i = 0 ; i < 2;i++)
	{
		MH_DrawTargaImage(id,"",0,0,153,204,51,0.0,0.96,0,200+i,0.0)
	}
	for(new i = 0 ; i < 2;i++)
	{
		MH_DrawTargaImage(id,"",0,0,153,204,51,0.0,0.96,0,204+i,0.0)
	}*/

	new forwardarry[2]
	//forwardarry[0] = ((z_point[id]-1)%1000)/100
	forwardarry[0] = ((z_point[id]-1)%100)/10
	forwardarry[1] = ((z_point[id]-1)%10)/1

	new x=0
	new Float:Xpoint = 0.70
	if((z_point[id]-1)>=0)
	{
		for(new i = 0 ; i < 2;i++)
		{
			//MH_DrawTargaImage(id,"",0,0,153,204,51,Xpoint,0.96,0,200+i,0.0)
			if(forwardarry[i]==0 && x==0 && i!=2)
				continue;
			x=1
			new number[64]
			format(number,63,"number/hud_sb_num_big_white_%d/",forwardarry[i])
			//MH_DrawTargaImage(id,number,0,0,153,204,51,Xpoint,0.955,0,200+i,999.0)
			Xpoint +=0.018
		}
	}
	new backarry[2]
	//backarry[0] = (z_point[id]%10000)/1000
	//backarry[1] = (z_point[id]%1000)/100
	backarry[0] = (z_point[id]%100)/10
	backarry[1] = (z_point[id]%10)/1

	x=0
	Xpoint = 0.75
	for(new i = 0 ; i < 2;i++)
	{
		
		//MH_DrawTargaImage(id,"",0,0,153,204,51,Xpoint,0.96,0,204+i,0.0)
		if(backarry[i]==0 && x==0 && i!=2)
			continue;
		x=1
		new number[64]
		format(number,63,"number/hud_sb_num_big_white_%d",backarry[i])
		//MH_DrawTargaImage(id,number,0,0,153,204,51,Xpoint,0.955,0,204+i,999.0)
		Xpoint +=0.018
	}

}
public DrawTips(id, skill_index)//SaveData_Get[id][last]
{
	if(!is_user_alive(id)) 
		return;
	if(!is_user_connected(id)) 
		return;
	if(!pev_valid(id))
		return 
	if(is_user_bot(id))
		return 
	
	
	/*new caleString[128]
	if(skill_index<10)
		format(caleString,127,"#CSO_ZBZ_Tooltip_Zombie3z_Mutation_id_000_name",skill_index)
	else
		format(caleString,127,"#CSO_ZBZ_Tooltip_Zombie3z_Mutation_id_000_name",skill_index)
	new caleString2[128]
	if(skill_index<10)
		format(caleString2,127,"#CSO_ZBZ_Tooltip_Zombie3z_Mutation_id_000_Desc_Simple",skill_index)
	else
		format(caleString2,127,"#CSO_ZBZ_Tooltip_Zombie3z_Mutation_id_000_Desc_Simple",skill_index)*/
	if(Skill_List[skill_index][team] == common)
	{
		
		//MH_DrawFontText(id,Skill_Info[skill_index][1],1,0.50,0.760 + 0.040,153,204,51,15,1.0,0.2,0,100)
		//MH_DrawFontText(id,Skill_Info[skill_index][2],1,0.50,0.785 + 0.040,153,204,51,17,1.0,0.2,0,101)

		/*MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_common",1,1,255,255,255,0.50,0.732,0,35,2.0)
		MH_DrawTargaImage(id,Skill_Info[skill_index][0],1,1,153,204,51,0.50,0.70,0,36,2.0)*/
		TipType[id]= 1
		TipType2[id]= 1

	}
	else if(Skill_List[skill_index][team] == human)
	{
		/*MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_human",1,1,255,255,255,0.50,0.732,0,35,2.0)
		MH_DrawTargaImage(id,Skill_Info[skill_index][0],1,1,137,207,240,0.50,0.70,0,36,2.0)*/

		//MH_DrawFontText(id,Skill_Info[skill_index][1],1,0.50,0.760 + 0.040,137,207,240,15,1.0,0.2,0,100)
		//MH_DrawFontText(id,Skill_Info[skill_index][2],1,0.50,0.785 + 0.040,137,207,240,17,1.0,0.2,0,101)

		TipType[id] = 2
		TipType2[id]= 2

	}
	else if(Skill_List[skill_index][team] == zombie)
	{
		/*MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_zombie",1,1,255,255,255,0.50,0.732,0,35,2.0)
		MH_DrawTargaImage(id,Skill_Info[skill_index][0],1,1,255,99,71,0.50,0.70,0,36,2.0)*/
		
		//MH_DrawFontText(id,Skill_Info[skill_index][1],1,0.50,0.760 + 0.040,255,99,71,15,1.0,0.2,0,100)
		//MH_DrawFontText(id,Skill_Info[skill_index][2],1,0.50,0.785 + 0.040,255,99,71,17,1.0,0.2,0,101)

		TipType[id] = 3
		TipType2[id]= 3

	}
	/*format(SkILLname,127,"%s",Skill_Info[skill_index][0])
	replace(SkILLname, charsmax(SkILLname), "mode/zbz/zombie3z_mutation_id_", "")

	MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_left",1,1,255,255,255,0.399,0.732,0,33,2.0)//-6//+2
	MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_right",1,1,255,255,255,0.602,0.732,0,34,2.0)*/

	
	//Message_Change_Point(id)
	if(!z_skilling2[id])
	{

		z_skilling[id]=1
		HookMhMsg(id)
	}
	else
	{
		HookMhMsg2(id)
	}
	HookMhMsg2(id)
	
}
public ControlDamExp(id)
{
	if(z_level[id]>=1&&z_level[id]<3)  AddExp[id] = 0.0
	else if(z_level[id]>=3&&z_level[id]<6) AddExp[id] = 25000.0 
	else if(z_level[id]>=6&&z_level[id]<10)  AddExp[id] = 30000.0
	else if(z_level[id]>=10&&z_level[id]<11)  AddExp[id] = 35000.0
	else if(z_level[id]>=11&&z_level[id]<13)  AddExp[id] = 45000.0
	else if(z_level[id]>=13&&z_level[id]<14)  AddExp[id] = 51000.0
	else if(z_level[id]>=14&&z_level[id]<15)  AddExp[id] = 48000.0
	else if(z_level[id]>=15&&z_level[id]<16)  AddExp[id] = 51000.0
	else if(z_level[id]>=16&&z_level[id]<17)  AddExp[id] = 51000.0
	else if(z_level[id]>=17&&z_level[id]<19)  AddExp[id] = 42000.0
	else if(z_level[id]>=19&&z_level[id]<22)  AddExp[id] = 48000.0
	else if(z_level[id]>=22&&z_level[id]<23)  AddExp[id] = 48000.0
	else if(z_level[id]>=23&&z_level[id]<25)  AddExp[id] = 51000.0
	else if(z_level[id]>=25&&z_level[id]<26)  AddExp[id] = 60000.0
	else if(z_level[id]>=26&&z_level[id]<28)  AddExp[id] = 62000.0
	else if(z_level[id]>=28&&z_level[id]<29)  AddExp[id] = 65000.0
	else if(z_level[id]>=29&&z_level[id]<30)  AddExp[id] = 65000.0
	else AddExp[id] = 70000.0

}
public Upgrade_initial()
{
	for(new i=0; i<30; i++){
		fUpgrade_rst[ i ] = 13000 + AddExp[ i ] * i//600.0

	}
}

show_exp( id, percent )
{
	//if(!MH_IsMetaHookPlayer(id))
	//	return PLUGIN_CONTINUE;
	//new attacker = get_user_attacker( id )
	//if(!pev_valid(attacker))
	//	return PLUGIN_CONTINUE
	//if(is_user_bot(attacker))
	//	return PLUGIN_CONTINUE

	/*if(percent>=1)
		MH_DrawTargaImage(id,"mode/zbz/zmode_level_bar_custom",0,0,255,255,255,defaultx+(percent*0.02/ 2),0.98,0,51,1.0)
	if(percent==0)
		MH_DrawTargaImage(id,"",0,0,255,255,255,defaultx+(percent*0.01/ 3),0.99,0,51,999.0)
		*/

	//MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_common",0,0,255,255,255,0.5,0.5,0,50,999.0)


	//MH_DrawTargaImage(attacker,"mode/zbz/zmode_level_bar_bg_custom",0,0,255,255,255,0.0,0.99,0,50,1.0)//50

	//MH_DrawTargaImage(attacker,"mode/zbz/zmode_level_bar_custom",0,0,255,test[attacker]?0:255,test[attacker]?0:255,defaultx+(percent*0.02/ 2),0.99,test[attacker]?3:0,50,test[attacker]?1.5:999.0)
}
public levelupsystem(id)
 {
 	if(iLevel[id]>0&&iLevel[id]<40)
	level_up(id);

	/*if (iLevel[id] == 1)
	level_up(id)
	else if (iLevel[id] == 2)
	level_up(id)
	else if (iLevel[id] == 3)
	level_up(id)
	else if (iLevel[id] == 4)
	level_up(id)
	else if (iLevel[id] == 5)
	level_up(id)
	else if (iLevel[id] == 6)
	level_up(id)
	else if (iLevel[id] == 7)
	level_up(id)
	else if (iLevel[id] == 8)
	level_up(id)
	else if (iLevel[id] == 9)
	level_up(id)
	else if (iLevel[id] == 10)
	level_up(id)
	else if (iLevel[id] == 11)
	level_up(id)
	else if (iLevel[id] == 12)
	level_up(id)
	else if (iLevel[id] == 13)
	level_up(id)
	else if (iLevel[id] == 14)
	level_up(id)
	else if (iLevel[id] == 15)
	level_up(id)
	else if (iLevel[id] == 16)
	level_up(id)
	else if (iLevel[id] == 17)
	level_up(id)
	else if (iLevel[id] == 18)
	level_up(id)
	else if (iLevel[id] == 19)
	level_up(id)
	else if (iLevel[id] == 20)
	level_up(id)
	else if (iLevel[id] == 21)
	level_up(id)
	else if (iLevel[id] == 22)
	level_up(id)
	else if (iLevel[id] == 23)
	level_up(id)
	else if (iLevel[id] == 24)
	level_up(id)
	else if (iLevel[id] == 25)
	level_up(id)
	else if (iLevel[id] == 26)
	level_up(id)
	else if (iLevel[id] == 27)
	level_up(id)
	else if (iLevel[id] == 28)
	level_up(id)
	else if (iLevel[id] == 29)
	level_up(id)
	else if (iLevel[id] == 30)
	level_up(id);

*/

//以上纯属脑瘫写法


 }









