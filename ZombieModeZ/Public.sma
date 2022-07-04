
#if defined _DEBUG
public cheat(id)
{
	z_point[id]=40
	z_level[id]=40

}
public cheat_remove(id)
{
	z_point[id]=40
	z_level[id]=0

}
#endif




public Func_Jrj(id)
{
	if(!g_SaveUserData[id][moremoney])
		return 
	if(is_user_alive(id)&&cs_get_user_money(id)<32000)
	{
		cs_set_user_money(id,cs_get_user_money(id)+JrjBase+(g_rount_count*JrjRoundAdd),1)
	}
}

public Func_Gdds(id,iCheck,iCheck2)
{
	if(STE_GetUserZombie(id))
		return HAM_IGNORED

	new iButton = pev(id, pev_button);
	new iEntity = get_pdata_cbase(id, 373)
	if(iCheck)
	{
		if (get_user_weapon(id) == CSW_KNIFE)
		{

			//if(!iCheck2)	
			if(pev(id,pev_button)& IN_ATTACK&&get_pdata_float(iEntity, 46, 4)<= 0.6)
			{
				if (g_fStGNextthink[id][0] > get_gametime())
					return HAM_IGNORED
				
				new Float:fCurTime
				global_get(glb_time, fCurTime)
				g_fStGNextthink[id][0] = fCurTime + GddsLeftNextThink//0.5
				g_bStGAttacking[id][0] = true
			}
			//if(iCheck2)
			if(pev(id,pev_button)& IN_ATTACK2&&get_pdata_float(iEntity, 47, 4)<= 0.8)
			{
				if (g_fStGNextthink[id][1] > get_gametime())
					return HAM_IGNORED

				new Float:fCurTime
				global_get(glb_time, fCurTime)
				g_fStGNextthink[id][1] = fCurTime + GddsRightNextThink ///0.8
				g_bStGAttacking[id][1] = true
			}
		}
	}
	if(!iCheck)
	{
		if (/*get_pdata_int(iEntity, 43, 4)*/get_user_weapon(id) == CSW_KNIFE&&g_SaveUserData[id][master])
		{
			if (g_bStGAttacking[id][0] && g_fStGNextthink[id][0] <= get_gametime())
			{
				new iHitResult2
				iHitResult2 = Knife_Damage(id, Range_KNIFE, Angle_KNIFE, DAMAGE_KNIFE+(DAMAGE_KNIFE2*g_rount_count), 1) /*119.0 360.0*/
				switch (iHitResult2)
				{
					case HIT_ENEMY,HIT_WALL,HIT_NOTHING: engfunc(EngFunc_EmitSound, id, CHAN_ITEM, Gdds_Sounds[random_num(0, 1)], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
				}
				g_bStGAttacking[id][0] = false
			}
			if (g_bStGAttacking[id][1] && g_fStGNextthink[id][1] <= get_gametime())
			{
				new iHitResult = Knife_Damage(id, Range_KNIFE, Angle_KNIFE, DAMAGE_KNIFE+(DAMAGE_KNIFE2*g_rount_count), 1)
				switch (iHitResult)
				{
					case HIT_ENEMY,HIT_WALL,HIT_NOTHING: engfunc(EngFunc_EmitSound, id, CHAN_ITEM, Gdds_Sounds[random_num(0, 1)], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
				}
				g_bStGAttacking[id][1] = false
			}
		}
	}
	return HAM_IGNORED
}
public Func_Djkr(id)
{
	
}

public Func_Gstz(id,iEntity)
{
	static Float:multiplier
	multiplier = 1.0  - (FastReloadAddBase+FastReloadAddRound*g_rount_count)
		
	if (multiplier < 0.0 || multiplier == 1.0)
	{
		setreload[id] = false
		return HAM_IGNORED;
	
	}
	static Float:time
	time = get_pdata_float(id, 83, 5) * multiplier

	set_pdata_float(id, 83, time, 5)
	set_pdata_float(iEntity, 48, time+0.5, 4)

	client_print(0,print_chat,"高速装填启用，当前加速度：%f",multiplier)
	setreload[id] = true

	return HAM_IGNORED
}
new Float:TmhdInvisibleBaseTime,Float:TmhdInvisibleRoundAddTime
public Func_Tmhd(id,iEntity)
{
	TmhdEnable[id] = 1
	//set_rendering(id, kRenderFxGlowShell, 0, 0, 0, kRenderTransAlpha, 0)

	g_fPlayerPostThink[id] = get_gametime() + 1.5
	return HAM_IGNORED

}
public RemoveInvisible(id,iEntity)
{
	TmhdEnable[id] = 0
	client_print(id,print_chat,"透明换弹结束了")

	//set_rendering(id, kRenderFxGlowShell, 0, 0, 0, kRenderTransAlpha, 255)

}

public Func_Lb(id)
{
	if(!is_user_alive(id)) 
		return HAM_IGNORED
	set_user_maxspeed(id, get_default_maxspeed(id)+speedfirstadd+speedroundadd*g_rount_count);
}
public Func_Ds(id)
{
	if(!is_user_alive(id)) return
	//if(!ds[id]) return
	if(!g_SaveUserData[id][kangaroo])
	return 

	//if( pev(id, pev_oldbuttons) & IN_JUMP&& (get_entity_flags(id) & FL_ONGROUND) )
	if((!pev(id, pev_oldbuttons) & IN_JUMP) && (pev(id, pev_button) & IN_JUMP) && (get_entity_flags(id) & FL_ONGROUND))	
	{
	new Float: BaseSpeed
	if(g_SaveUserData[id][djump]) BaseSpeed = 285.0
	else BaseSpeed = 250.0
	new Float:velocity[3]	
	entity_get_vector(id,EV_VEC_velocity,velocity)
	velocity[2] = JumpPowerBase + JumpPowerRound * g_rount_count+BaseSpeed
	entity_set_vector(id,EV_VEC_velocity,velocity)	

	new Float:testspeed = BaseSpeed+ JumpPowerBase + (JumpPowerRound * g_rount_count)
	client_print(id, print_chat, "袋鼠正在生效,当前速度%f",testspeed)
	}
}
new MaxHp[33]
public Func_Hfqh(id)
{
	if (!is_user_alive(id))
	return
	//if(!hfqh[id]) return
	if(!g_SaveUserData[id][restore])
	return 

	//MaxHp[id]=bte_zb3_get_max_health(id)
	pev(id, pev_max_health, MaxHp[id])

	if (!g_iReady[id])
	{
		g_fRecoveryTime[0] = RecoverBaseTime- RecoverRoundTime*g_rount_count
		g_iReady[id] = true
		g_fLastThink[id] = get_gametime() + g_fRecoveryTime[0]
	}
	if (get_gametime() < g_fLastThink[id])
	return

	if (pev(id, pev_health) < pev(id,pev_max_health)&&g_fLastThink[id]<=get_gametime())
	{
		new fHealth
		fHealth = min(get_user_health(id) + RecoverBase + RecoverRound * g_rount_count,pev(id,pev_max_health))
		//set_pev(id, pev_health, fHealth)
		fm_set_user_health(id,fHealth)

		client_print(id,print_chat,"恢复强化正在生效")
	}
	g_fLastThink[id] = get_gametime() + g_fRecoveryTime[1]
}


/*死妈技能做烦了
public Func_Zmtj(id,iCheck,Float:damage)
{
	new Piece
	new Check;Check = (g_rount_count/ZmtjRoundAddPeriod)

	if(is_user_alive(id)&&STE_GetUserZombie(id)!=1)
	{
		if(pev(id, pev_movetype)!=MOVETYPE_NONE)
		{
			new Float:CurTime,Float:g_MoveThink[33]
			global_get(glb_time, CurTime)
			if(CurTime >= g_MoveThink[id])
			{
				Piece= ZmtjLimitBase+ZmtjLimitRoundAdd* floatround(float(Check), 1);
			}
			g_MoveThink[id] = CurTime + 1.0

			new Float:AddTimes[33],;
			for (new i = 1; i < sizeof g_szWpnForA; i++)//这样能不能读取到上面括号里的所有武器
			{
				if(get_user_weapon(id)==g_szWpnForA[i][0])
				{
					if(iCheck=1)
					{
						damage = damage + ZmtjDamage*Piece
					}
				}
			}
		}
	}
}
*/
public Func_Cftj(id)
{
	if(STE_GetUserZombie(id))
		return HAM_IGNORED
	if(get_user_weapon(id)==CSW_MAC10||get_user_weapon(id)==CSW_UMP45||get_user_weapon(id)==CSW_MP5NAVY||get_user_weapon(id)==CSW_P90)
	{
		new Float:Velocity[3], Float:Position[3] = { 0.0, 0.0, 0.0 }
		pev(id, pev_velocity, Velocity)
		Velocity[2] = 0.0
		g_fPlayerMove[id] += get_distance_f(Velocity, Position)
			
		if(g_fPlayerMove[id] >= CftjNeedDistance)
		{
			g_fPlayerMove[id] = 0.0
			SpeedUpCheck[id] = 1
			client_print(id,print_chat,"你已经移动了4000.0的距离了，获得推进效果。")

			if(SpeedUpCheck[id])
			{
				SpeedUpCheck[id] = 0

				new Float:SetTime = SpeedUpBaseLoopTime+SpeedUpRoundAddLoopTime*g_rount_count
				//MH_DrawRetina(id,"mode\\zb3\\retina_zombispeedup",1,0,0,1,SetTime+1.0)
				set_user_maxspeed(id,get_default_maxspeed(id)+CftjBaseAdd+CftjRoundAdd*g_rount_count+CftjExtraBaseAdd+CftjExtraRoundAdd*g_rount_count)
				set_task(SetTime,"Task_RemoveSpeedUp",Task_SpeedUp+id)
			}
		}
	}
}

public Func_Bdbc(id)
{
	
}

public Func_Lmbn(id)
{
	//if(!slbn[id]) return
	if(!g_SaveUserData[id][hunt])
		return
	static Float:v[3],Float:v2[2]
	static iReturn
	new bigorsmall
	new pEntity = -1

	new Float:vecOrigin[3]
	pev(id, pev_origin, vecOrigin)//你的坐标

	if(!is_user_bot(id)&&is_user_alive(id))//如果id是bot那么不触发猎马本能.
	{
	while((pEntity = engfunc(EngFunc_FindEntityInSphere, pEntity, vecOrigin, 300.0)) != 0)//以vecOrigin（你的坐标为中心的范围）300.0以内的敌人
	{
	if (!pev_valid(pEntity))
	continue
	if (!is_user_alive(pEntity))//这里漏掉的话尸体不会消失.
	continue
	if (pEntity == id)//你会烈马自己么？
	continue
	if (pev(pEntity, pev_takedamage) == DAMAGE_NO)
	continue
	if(cs_get_user_team(pEntity) == cs_get_user_team(id))//狩猎队友？想peach呢
	continue


	pev( pEntity ,pev_origin, v)//2//敌人的啦
	iReturn = CalcScreen2(id,v,v2)//from Google Return//不能公开别人的代码

	if(iReturn)
	{
	new Float:color[3]//this is colors  这里是触发了猎马本能之后人物变红色
	color[0] = 255.0
	color[1] = 3.0
	color[2] = 0.0	

	new Float:color2[3]//用于恢复人物的颜色
	color2[0] = 255.0
	color2[1] = 255.0
	color2[2] = 255.0


	if (get_distance_f(vecOrigin, v) < 100.0) bigorsmall = 30//这里是根据距离控制字体大小。越远越小。反之则大.
	else if (get_distance_f(vecOrigin, v) > 100.0&&get_distance_f(vecOrigin, v)<500.0) bigorsmall = 20
	else if (get_distance_f(vecOrigin, v) > 500.0) bigorsmall = 15

	/*if(CheckLmbnEnable[id])
	MH_DrawFontText(id,"[+]",1,v2[0],v2[1],255,0,0,bigorsmall,0.01,0.0,0,100)//给所有标记的玩家用metahook注明位置（可以穿透墙体.）*/
	Tracking[pEntity]=1//记录


	set_pev(pEntity,pev_rendermode,kRenderNormal)//让敌人变成姨妈红
	set_pev(pEntity,pev_renderfx,CheckLmbnEnable[id]?kRenderFxGlowShell:kRenderFxNone)
	set_pev(pEntity,pev_rendercolor,CheckLmbnEnable[id]?color:color2)
	set_pev(pEntity,pev_renderamt,CheckLmbnEnable[id]?20.0:255.0)
	set_pev(pEntity, pev_effects, pev(id, pev_effects) & ~ EF_NODRAW);
	}
	}
	new i;
	for(i = 0; i < 32; i++)//这里发生在，你已经标记了敌人，但你或者敌人走出了范围的持续追踪
	{
		if (i == id) continue
		if(!Tracking[i]) continue//如果没有被标记就跳过

		if(!CheckLmbnEnable[id])
		{
			client_print(id,print_chat,"效果移除")
			set_pev(i,pev_rendermode,kRenderNormal:kRenderNormal)//还原人物render
			set_pev(i,pev_renderfx,kRenderFxNone)
			set_pev(i,pev_rendercolor,255.0,255.0,255.0)
			set_pev(i,pev_renderamt,255.0)

			Tracking[i]=0//数组清零

		}
		if(CheckLmbnEnable[id]&&Tracking[i])//这里面你可以自己写东西，被标记了之后会怎么样
		{
			pev( i ,pev_origin, v)//2
			iReturn = CalcScreen2(id,v,v2)
			
			if (get_distance_f(vecOrigin, v) < 100.0) bigorsmall = 30
			else if (get_distance_f(vecOrigin, v) > 100.0&&get_distance_f(vecOrigin, v)<500.0) bigorsmall = 20
			else if (get_distance_f(vecOrigin, v) > 500.0) bigorsmall = 15

			/*if(iReturn)
			MH_DrawFontText(id,"[+]",1,v2[0],v2[1],255,0,0,bigorsmall,0.01,0.0,0,100)*/
		}
		}
	}
	

}
public Func_Edt(id,iCheck)
{
	new newbut = get_user_button(id)
	new oldbut = get_user_oldbutton(id)

	if(!iCheck)
	{
		if((newbut & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND) && !(oldbut & IN_JUMP))
		{
			//还没跳呢
			if(jumpnum[id] < 1 )
			{
				dojump[id] = true
				jumpnum[id]++
				return PLUGIN_CONTINUE
			}
		}
		if((newbut & IN_JUMP) && (get_entity_flags(id) & FL_ONGROUND))//在天上
		{
			jumpnum[id] = 0
			return PLUGIN_CONTINUE
		}
	}

	if(iCheck)
	{
		if(dojump[id] == true )
		{
			new Float:velocity[3]	
			new Float: BaseSpeed
			entity_get_vector(id,EV_VEC_velocity,velocity)

			if(g_SaveUserData[id][kangaroo])
			{
				BaseSpeed = 285.0
				velocity[2] = JumpPowerBase + JumpPowerRound * g_rount_count+BaseSpeed
				new Float:testspeed = BaseSpeed+ JumpPowerBase + (JumpPowerRound * g_rount_count)
				client_print(id, print_chat, "袋鼠+二段跳生效,当前速度%f",testspeed)
			}
			else
				velocity[2] = 285.0
			
			entity_set_vector(id,EV_VEC_velocity,velocity)
			dojump[id] = false
			
			return PLUGIN_CONTINUE
		}
	}
	return PLUGIN_CONTINUE
}
public Func_Bzdt(id)
{
	
}
public Func_Qhjy(id)
{
	
}
public Func_Jcbx(id)
{
	
}
public Func_Dr(id)
{
	
}
public Func_Smby(id,iCheck)
{

	/*if(!STE_GetUserZombie(id)) maxhp = 4800//获取生命最大值
	else if(STE_GetUserZombie(id)==1) maxhp = 28800
	else if(STE_GetUserZombie(id)==3) maxhp = 6800
	*/

	pev(id,pev_health,hp)//当前的血量
	//if(hp>=maxhp)
	//	return

	new SetHealth,hp2,SetHealth2

	pev(id,pev_max_health,hp2)//获取当前生命最大值


	if(!iCheck)
	{
		if(firstgetskill[id])//刚刚得到生命补液
		{
			fm_set_user_health(id,get_user_health(id)+firsthpadd+roundhpadd*g_rount_count)
			set_pev(id,pev_max_health,pev(id,pev_max_health)+firsthpadd+roundhpadd*g_rount_count)
			firstgetskill[id]=0//归零
			//bte_zb3_set_max_health(id,bte_zb3_get_max_health(id)+firsthpadd+roundhpadd*g_rount_count)
		}
	}

	if(iCheck)
	{
		if(!firstgetskill[id])//回合开始的时候
		{
			//bte_zb3_set_max_health(id,bte_zb3_get_max_health(id)+firsthpadd+roundhpadd*g_rount_count)
			fm_set_user_health(id, get_user_health(id)+firsthpadd+roundhpadd*g_rount_count)
			set_pev(id,pev_max_health,pev(id,pev_max_health)+firsthpadd+roundhpadd*g_rount_count)

		}
	}
}

public Func_Jcgr(id,iEnemy)
{
	if(!pev_valid(iEnemy))
		return HAM_IGNORED
	if(!is_user_alive(iEnemy))
		return HAM_IGNORED
	if(STE_GetUserZombie(iEnemy))
		return HAM_IGNORED
	if(!STE_GetUserZombie(id))
		return HAM_IGNORED
	if( !pev( iEnemy, pev_takedamage) )
		return HAM_IGNORED
	//if(!jcgr[id])
	//	return HAM_IGNORED

	if(!g_SaveUserData[id][easyinfection])
		return HAM_IGNORED

	/*if(STE_GetUserZombie(iEnemy)==2)
	{
		client_print(id,print_chat,"英雄给爷死")
		ExecuteHamB(Ham_TakeDamage,iEnemy,id,id, 3500.0,(DMG_SLASH))
	}*/
	/*if(STE_GetUserZombie(iEnemy)==0)
	{
		//bte_zb_infected(iEnemy,id)
		bte_zb3_inflict_player(id,iEnemy)
	}*/
	return HAM_SUPERCEDE
}
public Func_Fh(id)
{
	//:xD
}
public Func_Gtkj(id)
{
	
}

public Func_Jz(id)
{
	if(!STE_GetUserZombie(id))
		return HAM_IGNORED
	if(!is_user_alive(id)) 
		return HAM_IGNORED
	if(pev(id,pev_flags) & FL_DUCKING)
	{
		set_user_maxspeed(id, get_default_maxspeed(id)+JzBaseAdd+JzRoundAdd*g_rount_count);
	}

	
}
public Func_Gttk(id)
{
	
}

public Func_Sqs(id,Ent)
{
	if(get_user_weapon(id) == CSW_SCOUT || get_user_weapon(id) == CSW_AWP || get_user_weapon(id) == CSW_SG550 || get_user_weapon(id) == CSW_G3SG1)
	{
		new Float:PunChangle[3]
		pev(id,pev_punchangle,PunChangle)
		xs_vec_mul_scalar(PunChangle,0.1,PunChangle)
		set_pev(id,pev_punchangle,PunChangle)

		// Acc
		static Accena; Accena = 100
		if(Accena != -1)
		{
			static Float:Accuracy
			Accuracy = (float(100 - 100) * 1.5) / 100.0
			set_pdata_float(Ent, 62, Accuracy, 4);
		}
	}
}
public Func_Dlg(id)
{
	
}

public Func_Gxcx(id)
{
	
}
public Func_Kr(id)
{
	
}

public Func_Czyh(id)
{
	//Already finished
	
}

public Func_Qzzl(iVictim,iCheck)
{
	if(!STE_GetUserZombie(iVictim))
		return HAM_IGNORED
	if(!is_user_alive(iVictim))
		return HAM_IGNORED

	if(is_user_alive(iVictim))
	{
		if(iCheck) //Recommended HAM_TakeDamage
		{
			if(!(pev(iVictim, pev_flags) & FL_ONGROUND) || pev(iVictim, pev_flags) & FL_DUCKING)
			{
				if(pev(iVictim, pev_movetype) == MOVETYPE_FLY)
				{
					new Fallen = random_num(0, 100)
					if(Fallen <= 50)
					{
						message_begin(1, 51, _, iVictim)
						write_byte(strlen("+jump") + 2);
						write_byte(10);
						write_string("+jump");
						message_end();

						QzzlFallDown[iVictim]=true
						QzzlFallDownThink[iVictim] = get_gametime() + QzzlFallDownLoopTime
					}
				}
			}			
		}
		if(!iCheck) //Recommended PlayerPreThink
		{
			if(QzzlFallDownThink[iVictim] <= get_gametime()&& QzzlFallDown[iVictim])
			{
				message_begin(1, 51, _, iVictim)
				write_byte(strlen("-jump") + 2);
				write_byte(10);
				write_string("-jump");
				message_end();

				QzzlFallDown[iVictim] = false
			}
		}
	}
	return HAM_IGNORED
}
public Func_Syl(id)
{
	//Already finished
	
}
public Func_Ymsl(id)
{

	
}

new Float:ZdbbTimeThink[33]
new Float:ZdbbBaseTime,Float:ZdbbRoundDropTime
new ZdbbHowManyToGiveBase,ZdbbHowManyToGivePeriod,ZdbbHowManyToGivePeriodAdd,ZdbbPeriodAdd
public Func_Zdbb(id)
{
	if(STE_GetUserZombie(id))
		return PLUGIN_CONTINUE
	if(ZdbbTimeThink[id] <= get_gametime())
	{

		new RandomRule;RandomRule=g_rount_count%ZdbbPeriodAdd//局数能否被6整除
		//for(new i=0;i<RandomRule==0?(g_rount_count/ZdbbPeriodAdd):1;i++)//

		new ammo = cs_get_user_bpammo(id,CSW_HEGRENADE);
		if(!ammo)
		{
			fm_give_item(id,"weapon_hegrenade");

			message_begin(MSG_ONE,get_user_msgid("WeaponList"), {0,0,0}, id);
			write_string("weapon_hegrenade")
			write_byte(12)
			write_byte(1)
			write_byte(-1)
			write_byte(-1)
			write_byte(3)
			write_byte(4)//CSWPN_POSITION[CSW_HEGRENADE]
			write_byte(CSW_HEGRENADE)
			write_byte(0)
			message_end()

			cs_set_user_bpammo(id,CSW_HEGRENADE,ammo+1);
			message_begin(MSG_ONE,gmsgAmmoPickup,_,id);
			write_byte(12);
			write_byte(ammo+RandomRule==0?(g_rount_count/ZdbbPeriodAdd):1);
			message_end();	

			client_print(id,print_chat,"你获得了高爆手雷")
		}
		ZdbbTimeThink[id]=get_gametime()+(ZdbbBaseTime+ZdbbRoundDropTime*g_rount_count)

	}
	return PLUGIN_CONTINUE
	
}
public Func_Zyhz(id,Float:fStartOrigin[3])
{
	if(is_user_bot(id))
		return

	new StartEf; StartEf = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	if(!pev_valid(StartEf))
		return


	set_pev(StartEf, pev_classname, "StartEf")
	set_pev(StartEf, pev_origin, fStartOrigin)
	set_pev(StartEf, pev_solid, SOLID_SLIDEBOX)
	set_pev(StartEf, pev_movetype, MOVETYPE_NONE)

	set_pev(StartEf, pev_owner, id)
	set_pev(StartEf, pev_frame, 0.0)
	set_pev(StartEf, pev_framerate, 1.0)
	set_pev(StartEf, pev_animtime, get_gametime())
	engfunc(EngFunc_SetModel, StartEf,  "models/bunkerbuster_target.mdl")
	set_pev(StartEf, pev_nextthink, get_gametime() + 0.1)
	set_pev(StartEf,pev_ltime,get_gametime() + 5.0)

	//Plane
	new Float:x;x= fStartOrigin[0]
	new Float:distance= 1000.0

	new Float:StartOrg[3],Float:EndOrg[3]
	StartOrg[0]= x-distance
	EndOrg[0]= x+distance
	StartOrg[1]= fStartOrigin[1]
	EndOrg[1]= fStartOrigin[1]

	OrgSaved[id]=EndOrg[0]

	StartOrg[2]= fStartOrigin[2]+1000.0
	EndOrg[2]= fStartOrigin[2]+1000.0

	set_pev(StartEf, pev_vuser1, StartOrg)
	set_pev(StartEf, pev_vuser2, EndOrg)
	
}

public Func_Zmyj(iAttacker,iVictim,Float:fDamage)
{
	if(!is_user_alive(iVictim))
		return HAM_IGNORED
	if(STE_GetUserZombie(iAttacker)==1)
		return HAM_IGNORED
	new iType;
	if(g_rount_count==1)//%4.5||5.0||5.5||6.0||6.5||7.0||7.5||8.0||
	{
		switch (random_num(0, 1000))
		{
			case 0..44:iType = 0
			case 45..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage*(fDamage*g_rount_count*DeadlyAttackRoundAdd));//0.02
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：4.5% || 当前追加的伤害：102%")
		}
		else
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==2)//%4.5
	{
		//new spd = 45+5*g_rount_count-1
		switch (random_num(0, 1000))
		{
			case 0..49:iType = 0
			case 50..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage*(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：5.0% || 当前追加的伤害：104%")
		}
		else 
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==3)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..54:iType = 0
			case 55..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：5.5% || 当前追加的伤害：106%")
		}
		else 
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==4)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..59:iType = 0
			case 60..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：6.0% || 当前追加的伤害：108%")
		}
		else 
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==5)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..64:iType = 0
			case 65..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：6.5% || 当前追加的伤害：110%")
		}
		else 
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==6)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..69:iType = 0
			case 70..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：7.0% || 当前追加的伤害：112%")
		}
		else 
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==7)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..74:iType = 0
			case 75..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：7.5% || 当前追加的伤害：114%")
		}
		else 
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==8)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..79:iType = 0
			case 80..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：8.0% || 当前追加的伤害：116%")
		}
		else 
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==9)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..84:iType = 0
			case 85..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：8.5% || 当前追加的伤害：118%")
		}
		else
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==10)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..89:iType = 0
			case 90..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：9.0% || 当前追加的伤害：120%")
		}
		else
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==11)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..94:iType = 0
			case 95..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：9.5% || 当前追加的伤害：122%")
		}
		else 
			ZmyjEnable[iAttacker]=0
	}
	else if(g_rount_count==12)//%4.5
	{
		switch (random_num(0, 1000))
		{
			case 0..99:iType = 0
			case 100..1000:iType = 1
		}
		if(iType==0)
		{
		SetHamParamFloat(4, fDamage+(fDamage*g_rount_count*DeadlyAttackRoundAdd));
		ZmyjEnable[iAttacker]=1
		client_print(iAttacker,print_chat,"致命一击触发！当前概率：10.0% || 当前追加的伤害：124%")
		}
		else
			ZmyjEnable[iAttacker]=0
	}
	return HAM_IGNORED
}
public Func_Pjdt(iAttacker,iVictim,Float:fDamage)
{
	if(STE_GetUserZombie(iAttacker)==1)
		return HAM_IGNORED
	if(STE_GetUserZombie(iVictim)!=1)
		return HAM_IGNORED

	SetHamParamFloat(4, fDamage+(PjdtBaseAdd+g_rount_count*PjdtRoundAdd));
	client_print(iAttacker,print_chat,"破甲弹头启用，当前追加伤害：%1.f",(PjdtBaseAdd+g_rount_count*PjdtRoundAdd))
	return HAM_IGNORED

}

public Func_Lfsl(id)
{
	
}
public Func_Bdsl(iAttacker,iVictim,Float:fDamage)
{
	if(STE_GetUserZombie(iAttacker)==1)
		return HAM_IGNORED
	if(STE_GetUserZombie(iVictim)!=1)
		return HAM_IGNORED
	if(STE_GetUserZombie(iVictim)==1)
	{
		g_TotalDmg[iVictim] += fDamage

		if (g_TotalDmg[iVictim] >= (BdslEnableBaseDamage+BdslEnableRoundAddDamage*g_rount_count) /*&& !bte_zb_get_metaron_skilling(iVictim)*/)
		{
			g_TotalDmg[iVictim] = 0.0

			new ammo = cs_get_user_bpammo(iVictim,CSW_HEGRENADE);
			// give him one
			if(!ammo)
			{
				fm_give_item(iVictim,"weapon_hegrenade");

				message_begin(MSG_ONE,get_user_msgid("WeaponList"), {0,0,0}, iVictim);
				write_string("weapon_zombibomb")
				write_byte(12)
				write_byte(1)
				write_byte(-1)
				write_byte(-1)
				write_byte(3)
				write_byte(4)//CSWPN_POSITION[CSW_HEGRENADE]
				write_byte(CSW_HEGRENADE)
				write_byte(0)
				message_end()
			}
			else
			{
				cs_set_user_bpammo(iVictim,CSW_HEGRENADE,ammo+1);
				message_begin(MSG_ONE,gmsgAmmoPickup,_,iVictim);
				write_byte(12);
				write_byte(ammo+1);
				message_end();
			}
			client_print(iVictim,print_chat,"你已经被艹了太多下了，获得一颗兽颅。")
			return HAM_IGNORED

		}
	}
	return HAM_IGNORED
}
public Func_Hyq(id)
{
	new Float:origin[3], Float:angles[3]
	pev(id, pev_angles, angles)
	angles[0] *= 3.0
	get_position(id, 20.0, 0.0, 10.0, origin)
	new iEntity = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))

	set_pev(iEntity, pev_classname, "fireball")
	set_pev(iEntity, pev_solid, SOLID_TRIGGER)
	set_pev(iEntity, pev_movetype, MOVETYPE_STEP)
	set_pev(iEntity, pev_owner, id)
	set_pev(iEntity, pev_angles, angles)
	set_pev(iEntity, pev_rendermode, kRenderTransAdd)
	set_pev(iEntity, pev_renderamt, 255.0)
	
	engfunc(EngFunc_SetModel, iEntity, "models/allstarrevenant_fireball.mdl")
	engfunc(EngFunc_SetOrigin, iEntity, origin)
	engfunc(EngFunc_SetSize, iEntity, {-8.0, -8.0, -8.0}, {8.0, 8.0, 8.0})

	new Float:start[3], Float:view_ofs[3], Float:end[3]
	pev(id, pev_origin, start)
	pev(id, pev_view_ofs, view_ofs)
	xs_vec_add(start, view_ofs, start)
	
	pev(id, pev_v_angle, end)
	engfunc(EngFunc_MakeVectors, end)
	global_get(glb_v_forward, end)
	xs_vec_mul_scalar(end, 8120.0, end)
	xs_vec_add(start, end, end)
	engfunc(EngFunc_TraceLine, start, end, DONT_IGNORE_MONSTERS, id, 0)
	get_tr2(0, TR_vecEndPos, end)
	
	new Float:velocity[3]
	Stock_Get_Speed_Vector(origin, end, 1200.0, velocity)
	set_pev(iEntity, pev_velocity, velocity)
	set_pev(iEntity, pev_nextthink, get_gametime() +0.1)


	new Float:origin2[3], Float:angles2[3]
	pev(id, pev_angles, angles2)
	angles2[0] *= 3.0
	get_position(id, 20.0, 0.0, 10.0, origin2)
	new iEntity2 = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))

	set_pev(iEntity2, pev_classname, "fireball")
	set_pev(iEntity2, pev_solid, SOLID_TRIGGER)//SOLID_SLIDEBOX  SOLID_TRIGGER
	set_pev(iEntity2, pev_movetype, MOVETYPE_STEP)
	set_pev(iEntity2, pev_owner, id)
	set_pev(iEntity2, pev_angles, angles2)
	set_pev(iEntity2, pev_rendermode, kRenderTransAdd)
	set_pev(iEntity2, pev_renderamt, 255.0)
	
	engfunc(EngFunc_SetModel, iEntity2, "sprites/ef_cannon6_fire.spr")
	engfunc(EngFunc_SetOrigin, iEntity2, origin2)
	engfunc(EngFunc_SetSize, iEntity2, {-1.0, -1.0, -1.0}, {1.0, 1.0, 1.0})

	new Float:start2[3], Float:view_ofs2[3], Float:end2[3]
	pev(id, pev_origin, start2)
	pev(id, pev_view_ofs, view_ofs2)
	xs_vec_add(start2, view_ofs2, start2)
	
	pev(id, pev_v_angle, end2)
	engfunc(EngFunc_MakeVectors, end2)
	global_get(glb_v_forward, end2)
	xs_vec_mul_scalar(end2, 8120.0, end2)
	xs_vec_add(start2, end2, end2)
	engfunc(EngFunc_TraceLine, start2, end2, DONT_IGNORE_MONSTERS, id, 0)
	get_tr2(0, TR_vecEndPos, end2)
	
	new Float:velocity2[3]
	Stock_Get_Speed_Vector(origin2, end2, 1200.0, velocity2)
	set_pev(iEntity2, pev_velocity, velocity2)
	set_pev(iEntity2, pev_nextthink, get_gametime() +0.1)

}
public Func_Mm(id)
{
	
}

public Func_Ldsl(id,Ent,iCheck)
{
	#define AMMO_FLASHBANG		11
	#define NT_FLASHBANG		(1<<0) 
	new type
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(STE_GetUserZombie(id)==1)
		return HAM_IGNORED
	if(iCheck==1)
	{
		fm_give_item(id,"weapon_flashbang");
		//bte_wpn_give_named_wpn(id,"flashbang")
		if(type & NT_FLASHBANG)
			hasFrostNade[id] = CSW_FLASHBANG; //标记闪光弹

	}
	if(iCheck==0)
	{
		if(pev(Ent,pev_bInDuck)!=1)
			return HAM_IGNORED
		if(hasFrostNade[id] != CSW_FLASHBANG)
			return HAM_IGNORED
		#define message_begin_fl(%1,%2,%3,%4) engfunc(EngFunc_MessageBegin, %1, %2, %3, %4)
		#define write_coord_fl(%1) engfunc(EngFunc_WriteCoord, %1)

		new nadeOrigin[3]

		pev(Ent,pev_origin,nadeOrigin);

		// make the smoke
		message_begin_fl(MSG_PVS,SVC_TEMPENTITY,nadeOrigin,0);
		write_byte(TE_SMOKE);
		write_coord_fl(nadeOrigin[0]); // x
		write_coord_fl(nadeOrigin[1]); // y
		write_coord_fl(nadeOrigin[2]); // z
		write_short(Eff_FrostSmoke); // sprite
		write_byte(random_num(30,40)); // scale
		write_byte(5); // framerate
		message_end();

		new rgb[3];
		rgb[0] = 0;rgb[1] = 0;rgb[2] = 150;
		// smallest ring
		message_begin_fl(MSG_PVS,SVC_TEMPENTITY,nadeOrigin,0);
		write_byte(TE_BEAMCYLINDER);
		write_coord_fl(nadeOrigin[0]); // x
		write_coord_fl(nadeOrigin[1]); // y
		write_coord_fl(nadeOrigin[2]); // z
		write_coord_fl(nadeOrigin[0]); // x axis
		write_coord_fl(nadeOrigin[1]); // y axis
		write_coord_fl(nadeOrigin[2] + 385.0); // z axis
		write_short(Eff_FrostExplo); // sprite
		write_byte(0); // start frame
		write_byte(0); // framerate
		write_byte(4); // life
		write_byte(60); // width
		write_byte(0); // noise
		write_byte(rgb[0]); // red
		write_byte(rgb[1]); // green
		write_byte(rgb[2]); // blue
		write_byte(100); // brightness
		write_byte(0); // speed
		message_end();

		// medium ring
		message_begin_fl(MSG_PVS,SVC_TEMPENTITY,nadeOrigin,0);
		write_byte(TE_BEAMCYLINDER);
		write_coord_fl(nadeOrigin[0]); // x
		write_coord_fl(nadeOrigin[1]); // y
		write_coord_fl(nadeOrigin[2]); // z
		write_coord_fl(nadeOrigin[0]); // x axis
		write_coord_fl(nadeOrigin[1]); // y axis
		write_coord_fl(nadeOrigin[2] + 470.0); // z axis
		write_short(Eff_FrostExplo); // sprite
		write_byte(0); // start frame
		write_byte(0); // framerate
		write_byte(4); // life
		write_byte(60); // width
		write_byte(0); // noise
		write_byte(rgb[0]); // red
		write_byte(rgb[1]); // green
		write_byte(rgb[2]); // blue
		write_byte(100); // brightness
		write_byte(0); // speed
		message_end();

		// largest ring
		message_begin_fl(MSG_PVS,SVC_TEMPENTITY,nadeOrigin,0);
		write_byte(TE_BEAMCYLINDER);
		write_coord_fl(nadeOrigin[0]); // x
		write_coord_fl(nadeOrigin[1]); // y
		write_coord_fl(nadeOrigin[2]); // z
		write_coord_fl(nadeOrigin[0]); // x axis
		write_coord_fl(nadeOrigin[1]); // y axis
		write_coord_fl(nadeOrigin[2] + 555.0); // z axis
		write_short(Eff_FrostExplo); // sprite
		write_byte(0); // start frame
		write_byte(0); // framerate
		write_byte(4); // life
		write_byte(60); // width
		write_byte(0); // noise
		write_byte(rgb[0]); // red
		write_byte(rgb[1]); // green
		write_byte(rgb[2]); // blue
		write_byte(100); // brightness
		write_byte(0); // speed
		message_end();

		//message_begin (MSG_BROADCAST,SVC_TEMPENTITY)
		message_begin_fl(MSG_BROADCAST,SVC_TEMPENTITY,nadeOrigin,0);
		write_byte( TE_SPRITETRAIL ) // Throws a shower of sprites or models
		engfunc(EngFunc_WriteCoord, nadeOrigin[ 0 ]) // start pos
		engfunc(EngFunc_WriteCoord, nadeOrigin[ 1 ])
		engfunc(EngFunc_WriteCoord, nadeOrigin[ 2 ] + 200.0)
		engfunc(EngFunc_WriteCoord, nadeOrigin[ 0 ]) // velocity
		engfunc(EngFunc_WriteCoord, nadeOrigin[ 1 ])
		engfunc(EngFunc_WriteCoord, nadeOrigin[ 2 ] + 30.0)
		write_short(Eff_FrostGib) // spr
		write_byte(60) // (count)
		write_byte(random_num(27,30)) // (life in 0.1's)
		write_byte(2) // byte (scale in 0.1's)
		write_byte(50) // (velocity along vector in 10's)
		write_byte(10) // (randomness of velocity in 10's)
		message_end() 


		new pEntity = -1
		while((pEntity = engfunc(EngFunc_FindEntityInSphere, pEntity, nadeOrigin, FROST_RADIUS)) != 0)//以vecOrigin（你的坐标为中心的范围）300.0以内的敌人
		{
			if (!pev_valid(pEntity))
				continue
			if (!is_user_alive(pEntity))
				continue
			if(!hitself1)
			{
				if (pEntity == id)
					continue
			}
			if(STE_GetUserZombie(pEntity)!=1)
				continue

			ExecuteHamB(Ham_TakeDamage,pEntity,Ent,id,maxdamage1,(1<<24));
			isFrozen[id] = pEntity;
			ExecuteHam(Ham_Item_PreFrame, pEntity);
			set_pev(pEntity,pev_velocity,Float:{0.0,0.0,0.0});

			static ent, Float:FixOrigin[3]
			pev( pEntity, pev_origin, FixOrigin )
			if( pev( pEntity, pev_flags ) & FL_DUCKING  )
				FixOrigin[2] -= 15.0
			else
				FixOrigin[2] -= 35.0

			new iEntity = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
			set_pev( iEntity, pev_classname, "Ice" )
			dllfunc(DLLFunc_Spawn, iEntity)

			engfunc(EngFunc_SetModel, iEntity, "models/iceblock.mdl")
			engfunc(EngFunc_SetOrigin, iEntity, FixOrigin)
			engfunc(EngFunc_SetSize, iEntity, {-15.0, -15.0, -15.0}, {15.0, 15.0, 15.0})

			set_pev(iEntity, pev_solid, SOLID_BBOX)
			set_pev(iEntity, pev_movetype, MOVETYPE_FLY)
			set_pev(iEntity, pev_ltime, get_gametime() + 5.0)
			set_rendering(iEntity, kRenderFxNone, 255, 255, 255, kRenderTransAdd, 255)

		}
		set_pev(Ent,pev_flags,pev(Ent,pev_flags)|FL_KILLME);
		return HAM_SUPERCEDE
	}
	if(iCheck==2)
	{
		if(isFrozen[id])
		{
			set_pev(id,pev_velocity,Float:{0.0,0.0,0.0});
			ExecuteHam(Ham_Item_PreFrame, id);

			new Float:gravity;
			pev(id,pev_gravity,gravity);

			if(gravity != 0.000000001 && gravity != 999999999.9)
				oldGravity[id] = gravity;
			if((pev(id,pev_button) & IN_JUMP) && !(pev(id,pev_oldbuttons) & IN_JUMP) && (pev(id,pev_flags) & FL_ONGROUND)||(pev(id,pev_flags) & FL_DUCKING))
				set_pev(id,pev_gravity,999999999.9);
			else set_pev(id,pev_gravity,0.000000001);
			set_task(5.0,"RebuildSpeed",TASK_REMOVE_FREEZE+id)
		}

	}
}
public Func_Ykls(id)
{
	if(pev(id, pev_button) & IN_JUMP)
	{
		if(!(get_entity_flags(id) & FL_ONGROUND)/*&&CheckEkuce[id]*/)
		{
			CheckEkuce[id]=0
			new Float:velocity[3]
			entity_get_vector(id, EV_VEC_velocity, velocity)
			if(velocity[2] < 0)
			{
				if(wing[id] == 0)
				{
					wing[id] =  engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
					if(wing[id] > 0)
					{
						new Float:vOrigin[3]
						pev(id, pev_origin, vOrigin)
						set_pev(wing[id], pev_origin, vOrigin)
						set_pev(wing[id], pev_solid, SOLID_TRIGGER)

						engfunc(EngFunc_SetModel, wing[id], "models/zombiezwingfx.mdl")
	
						set_pev(wing[id], pev_scale, 2.5)
						set_pev(wing[id], pev_movetype, MOVETYPE_FOLLOW)
						set_pev(wing[id], pev_aiment, id)
						set_pev(wing[id], pev_framerate,1.0)

						set_pev(wing[id], pev_rendermode, kRenderNormal)
						set_pev(wing[id], pev_renderamt, 255.0)
						set_pev(wing[id], pev_light_level, 180.0)

						engfunc(EngFunc_SetSize, wing[id], Float:{-30.0, -30.0, 0.0}, Float:{30.0, 30.0, 30.0})

					}
				}
				if(wing[id] > 0)
				{

					new Float:vecVelocity[3];
					new const g_iDownhillSpeed				= 500; //
					new const Float:g_flDownhillSpeedY			= -200.0;//下落速度

					velocity_by_aim(id, g_iDownhillSpeed, vecVelocity);
					vecVelocity[2] = g_flDownhillSpeedY;
					set_pev(id, pev_velocity, vecVelocity);

					if(entity_get_float(wing[id], EV_FL_frame) < 0.0 || entity_get_float(wing[id], EV_FL_frame) > 254.0)
					{
						if(entity_get_int(wing[id], EV_INT_sequence) != 1)
						{
							entity_set_int(wing[id], EV_INT_sequence, 1)
						}
						entity_set_float(wing[id], EV_FL_frame, 0.0)
					}
					else 
					{
						entity_set_float(wing[id], EV_FL_frame, entity_get_float(wing[id], EV_FL_frame) + 33.0)
					}
				}
			}
			else
			{
				if(wing[id] > 0)
				{
					remove_entity(wing[id])
					wing[id] = 0
					CheckEkuce[id]=1
				}
			}
		}
		else
		{
			if(wing[id] > 0)
			{
				remove_entity(wing[id])
				wing[id] = 0
				CheckEkuce[id]=1
			}
		}
	}
	else if(get_user_oldbutton(id) & IN_JUMP)
	{
		if(wing[id] > 0)
		{
			remove_entity(wing[id])
			wing[id] = 0
			CheckEkuce[id]=1
		}
	}
	
}

public Func_Prdt(id)
{
	
}
public Func_Ssjr(id)
{
	new HumNum = GetHumansPlayer()
	new Float:speed,SetSpeed[33],lefthum
	lefthum = GetTotalPlayer()-GetHumansPlayer()

	fm_set_user_maxspeed(id,fm_get_user_maxspeed(id)+(lefthum*0.7*fm_get_user_maxspeed(id)))
	client_print(0,print_chat,"当前人类剩余：%d,你的速度加成：%.1f",HumNum,fm_get_user_maxspeed(id)+(lefthum*0.7*fm_get_user_maxspeed(id)))
}

public Func_Jqzl(iAttacker,Float:fDamage)
{
	//if(!jqzl[iAttacker]) return
	if(!g_SaveUserData[iAttacker][moneypower])
	return 

	new money = cs_get_user_money(iAttacker)
	if(money>= 6000 && money< 8000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：101%")
		SetHamParamFloat(4, fDamage +fDamage* 1.01)
	}
	else if(money>= 8000 && money < 10000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：102%")
		SetHamParamFloat(4, fDamage +fDamage* 1.02)
	}
	else if(money>= 10000 && money < 12000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：103%")
		SetHamParamFloat(4, fDamage +fDamage* 1.03)
	}
	else if(money>= 12000 && money < 14000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：104%")
		SetHamParamFloat(4, fDamage +fDamage* 1.04)
	}
	else if(money>= 14000 && money < 16000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：105%")
		SetHamParamFloat(4, fDamage +fDamage* 1.05)
	}
	else if(money>= 16000 && money < 18000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：106%")
		SetHamParamFloat(4, fDamage +fDamage* 1.06)
	}
	else if(money>= 18000 && money < 20000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：107%")
		SetHamParamFloat(4, fDamage +fDamage* 1.07)
	}
	else if(money>= 20000 && money < 22000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：108%")
		SetHamParamFloat(4, fDamage +fDamage* 1.08)
	}
	else if(money>= 22000 && money < 24000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：109%")
		SetHamParamFloat(4, fDamage +fDamage* 1.09)
	}
	else if(money>= 24000 && money < 26000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：110%")
		SetHamParamFloat(4, fDamage +fDamage* 1.10)
	}
	else if(money>= 26000 && money < 28000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：113%")
		SetHamParamFloat(4, fDamage +fDamage* 1.13)
	}
	else if(money>= 28000 && money < 30000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：116%")
		SetHamParamFloat(4, fDamage +fDamage* 1.16)
	}
	else if(money>= 30000 && money < 32000)
	{
		client_print(iAttacker,print_chat,"金钱之力启用：当前攻击力加成：120%")
		SetHamParamFloat(4, fDamage +fDamage* 1.20)
	}



}
public Func_Wqsl(id)
{
	
}

//native fm_get_user_health(id)
public Func_Grhf(victim,attacker)
{
	if(!STE_GetUserZombie(attacker))
		return
	new Float:vecOrigin[3],pEntity
	pev(attacker, pev_origin, vecOrigin)
	new PlayerId[32]


	if(is_user_alive(attacker))
	{
		//fm_set_user_health(attacker,(get_user_health(attacker)*floatround(GrhfBaseAdd+GrhfRoundAdd*g_rount_count)))
		while((pEntity = engfunc(EngFunc_FindEntityInSphere, pEntity, vecOrigin, 100.0)) != 0)
		{
			if (!pev_valid(pEntity))
				continue
			if (!is_user_alive(pEntity))
				continue
			if (STE_GetUserZombie(pEntity)!=1)
				continue

			fm_set_user_health(pEntity,float(floatround(GrhfRoundAdd*g_rount_count*get_user_health(pEntity))))
			get_user_name(attacker,PlayerId,31)
			client_print(0,print_chat,"玩家%s感染了人类为您恢复了%.1f的生命值",PlayerId,float(floatround(GrhfRoundAdd*g_rount_count*get_user_health(pEntity))))
		}
	}
}
public Func_Slqh(id)
{
	
}

public Func_Hjlz(id,iCheck)
{
	if(!STE_GetUserZombie(id))
		return HAM_IGNORED

	new iButton = pev(id, pev_button);
	new iEntity = get_pdata_cbase(id, 373)
	if(iCheck)
	{
		if (get_user_weapon(id) == CSW_KNIFE)
		{
			if(pev(id,pev_button)& IN_ATTACK&&get_pdata_float(iEntity, 46, 4)<= 0.6)
			{
				if (g_fStGNextthink[id][0] > get_gametime())
					return HAM_IGNORED
				
				new Float:fCurTime
				global_get(glb_time, fCurTime)
				g_fStGNextthink[id][0] = fCurTime + GddsLeftNextThink//0.5
				g_bStGAttacking[id][0] = true
			}
			if(pev(id,pev_button)& IN_ATTACK2&&get_pdata_float(iEntity, 47, 4)<= 0.8)
			{
				if (g_fStGNextthink[id][1] > get_gametime())
					return HAM_IGNORED

				new Float:fCurTime
				global_get(glb_time, fCurTime)
				g_fStGNextthink[id][1] = fCurTime + GddsRightNextThink ///0.8
				g_bStGAttacking[id][1] = true
			}
		}
	}
	if(!iCheck)
	{
		if (get_user_weapon(id) == CSW_KNIFE)
		{
			if (g_bStGAttacking[id][0] && g_fStGNextthink[id][0] <= get_gametime())
			{
				Knife_Damage(id, Range_KNIFE, Angle_KNIFE, DAMAGE_KNIFE+(DAMAGE_KNIFE2*g_rount_count), 1) /*119.0 360.0*/
				g_bStGAttacking[id][0] = false
			}
			if (g_bStGAttacking[id][1] && g_fStGNextthink[id][1] <= get_gametime())
			{
				Knife_Damage(id, Range_KNIFE, Angle_KNIFE, DAMAGE_KNIFE+(DAMAGE_KNIFE2*g_rount_count), 1)
				g_bStGAttacking[id][1] = false
			}
		}
	}
	return HAM_IGNORED
	
}
public Func_Jnlq(id)
{
	
}

public Func_Qxzj(iAttacker,iVictim,Float:fDamage)
{
	if(!STE_GetUserZombie(iVictim))
		return HAM_IGNORED
	if(STE_GetUserZombie(iAttacker))
		return HAM_IGNORED

	if(random_num(0,1000)<QxzjBaseAdd+QxzjRoundAdd*(g_rount_count>5?5:g_rount_count))
	{
		new Float:percent = float(QxzjBaseAdd+QxzjRoundAdd*(g_rount_count>5?5:g_rount_count))
		client_print(iAttacker,print_chat,"倾斜装甲触发，当前概率：%1.f%",percent/10)
		client_print(iVictim,print_chat,"倾斜装甲触发，当前概率：%1.f%",percent/10)

		SetHamParamFloat(4, 0.0)
		QxzjEnable[iVictim]= 1
		return HAM_IGNORED
	}
	else
	{
		SetHamParamFloat(4, fDamage)
		QxzjEnable[iVictim]=0
		return HAM_IGNORED
	}
	return HAM_IGNORED
}
