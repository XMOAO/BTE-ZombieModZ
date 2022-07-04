

public client_PreThink(id)
{
	if(!is_user_alive(id)) return PLUGIN_CONTINUE

	//new wpn = get_user_weapon(id)

	if(g_SaveUserData[id][djump])
	{
		Func_Edt(id,0)
	}
	if(g_SaveUserData[id][ekuce])
	{
		Func_Ykls(id)
	}
	if(g_SaveUserData[id][hunt])
	{
		Func_Lmbn(id)
	}

	//static SpeedNum; SpeedNum = fm_get_speed(id)//获取玩家的速度
	//set_hudmessage(255,255,255,0.50, 0.85, 0, 3.0, 6.0, 0.5, 0.15, 3)
	//show_hudmessage(id," Speed: %d" , SpeedNum )//将数字绘制出来

	return PLUGIN_CONTINUE
}

public client_PostThink(id)
{
	if(!is_user_alive(id)) return PLUGIN_CONTINUE

	if(g_SaveUserData[id][djump])
	{
		Func_Edt(id,1)
	}
	if(g_SaveUserData[id][morehp])
	{
		Func_Smby(id,0)
	}

	if(g_SaveUserData[id][Frozengrenade] && firstgetskillldsl[id])
	{
		//frostnade(id)
		firstgetskillldsl[id]=0
	}
	if(g_SaveUserData[id][kangaroo])
	{
		Func_Ds(id)
	}
	if(g_SaveUserData[id][master])
	{
		Func_Gdds(id,0,0)
	}
	if(g_SaveUserData[id][restore])
	{
		Func_Hfqh(id)
	}

	return PLUGIN_CONTINUE
}

public client_putinserver(id)
{
	if(!g_HamBot && is_user_bot(id))
	{
		g_HamBot = 1
		set_task(0.1, "Do_Register_HamBot", id)
	}
	//g_iDamageTotal[id]=0
	//SavedDamage[ id ]=0
	//xp{id}=0

	/*jumpnum[id] = 0
	dojump[id] = false
	edt[id]=0
	ykls[id]=0
	wing[id]=0
	CheckEkuce[id]=0

	isFrozen[id] = 0;
	hasFrostNade[id] = 0;
	ldsl[id]=0
	firstgetskillldsl[id]=0
*/
	g_bStGAttacking[id][0] = false
	g_bStGAttacking[id][1] = false
	g_fStGNextthink[id][0] = 0.0
	g_fStGNextthink[id][1] = 0.0


}
public client_disconnect(id)
{
	/*jumpnum[id] = 0
	dojump[id] = false
	edt[id]=0

	smby[id] = 0

	if(wing[id] > 0)
	{
		remove_entity(wing[id])
	}
	ykls[id] = 0
	wing[id] = 0
	CheckEkuce[id]=0

	ldsl[id]=0
*/
	g_rount_count=0
	if(isFrozen[id]) RebuildSpeed(TASK_REMOVE_FREEZE+id);

}

public LmbnEnd(id)
{
	g_fTime = 0.0
	CheckLmbnEnable[id]=0
	Tracking[id]=0
	g_fTime = get_gametime() + g_fTime2
	client_print(id,print_chat,"猎马本能已经结束了")
}
public Check_LmbnTime()
{
	//new rad=random_num(1,10000)
	new id;
	for(id = 1; id < 32; id++)
	{
		if (get_gametime() >= g_fTime && g_fTime &&!CheckLmbnEnable[id])	
		{
			CheckLmbnEnable[id]=1
			set_task(10.0,"LmbnEnd",id)
			//client_print(id,print_chat,"猎马本能已经发动了，随机数：%d",rad)
			g_fTime = get_gametime() + g_fTime2
		}
	}
}

public FireBallTimer(id)
{
	CheckFireBall[id]=0
	client_print(id,print_chat,"火焰球冷却完毕.")
}


