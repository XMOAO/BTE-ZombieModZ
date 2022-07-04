
/*
public bte_zb_infected(victim,attacker)
{
	if(attacker >= 33) return;
	new HumNum = GetHumansPlayer()
	HumNum--
	//Func_Ssjr(attacker)
	if(grhf[attacker])
	Func_Grhf(victim,attacker)
}
*/
public Event_Damage(id)
{

	new attacker = get_user_attacker( id )
	if(!pev_valid(attacker))
		return
	if(!is_user_alive(attacker))
		return
	ControlDamExp(attacker)
	fSavedDmg[attacker] += read_data( 2 ) 
	new damage = read_data( 2 ) 
	 
	while( fSavedDmg[attacker] > fUpgrade_rst[ iLevel[attacker] ] && iLevel[attacker] < 29 )
	{		
		fSavedDmg[attacker] -= fUpgrade_rst[ iLevel[attacker] ]
		iLevel[attacker]++
		fSavedDmg[attacker]=0.0
		levelupsystem(attacker)
	}
	new percent = floatround( 100 * fSavedDmg[attacker] / fUpgrade_rst[ iLevel[attacker] ] )
	if( percent > 100 ) percent = 100

	//if(!MH_IsMetaHookPlayer(id))
	//return;
	iPercent[attacker]=percent
	HookMhMsg(attacker)
	if(pev(attacker, pev_takedamage) != DAMAGE_NO&& percent >=1&&z_level[attacker]<max_level)
	{

	//MH_DrawTargaImage(attacker,"mode/zbz/zmode_level_bar_custom.tga",0,0,255,50,50,defaultx+(percent*0.02/ 2),0.99,3,101,1.0)//3是淡入淡出，51通道//255 50 50
	}

}

public Event_Death()
{
	static Victim; Victim = read_data(2)
	Do_Reset_Emotion(Victim)
}
public Event_HLTV_New_Round()
{

	if(!is_skill_init)
	{
		skill_init();
		is_skill_init = 1;
	}
	for(new i = 1; i < g_MaxPlayers; i++)
	{
		if(!is_user_connected(i))
			continue
			
		Reset_Var(i)
	}

	g_rount_count += 1
	client_print(0,print_chat,"新的一局开始了，现在是第 %d 局！",g_rount_count)

	for(new id=1; id< g_MaxPlayers; id++)
	{
		g_fLastHurt[id] = g_fDmgToRestore[id] = 0.0;
		if(g_SaveUserData[id][moremoney])
		{
			new money = cs_get_user_money(id)
			if(money<16000)
			{
				cs_set_user_money(id, money+addmoneybase+addmoneyround*g_rount_count,1)
			}
		}
	}
}
public Event_CurWeapon(id)
{
	if(!is_user_alive(id))
		return
	
	if(g_InDoingEmo[id] && get_user_weapon(id) != CSW_KNIFE) Do_Reset_Emotion(id)
	client_print(id,print_console,"状态：%d",_gBaseData->Is_UserZombie(id))
}

