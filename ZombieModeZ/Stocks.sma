
//Basic Check
/*================================================================================ 
 [Include Basic Files] 
=================================================================================*/ 
stock IsPlayer(pEntity) return is_user_connected(pEntity)
stock IsHostage(pEntity)
{
    new classname[32]; pev(pEntity, pev_classname, classname, charsmax(classname))
    return equal(classname, "hostage_entity")
}
stock IsAlive(pEntity)
{
    if (pEntity < 1) return 0
    return (pev(pEntity, pev_deadflag) == DEAD_NO && pev(pEntity, pev_health) > 0)
}
//Basic Global Datas
//Get Total Players
public GetHumansPlayer()
{
	new iPlayers
	for (new id = 1; id < 33; id ++)
	{
		if (!is_user_connected(id))
			continue
		if (STE_GetUserZombie(id))
			continue
		if (!is_user_alive(id))
			continue
		iPlayers ++
	}
	return floatround(float(iPlayers))
}
public GetTotalPlayer()
{
	new iPlayers
	for (new id = 1; id < 33; id ++)
	{
		if (!is_user_connected(id))
		continue

		iPlayers ++
	}
	return floatround(float(iPlayers))
}

//Create Entity
stock CreateNamedEntity(id)
{
	new Float:origin[3]
	pev(id, pev_origin, origin)

	if(pev(id, pev_flags) & FL_DUCKING) Stock_Get_Postion(id, 15.0, 5.0, -20.0, origin)//如果蹲着就修正模型位置
	else Stock_Get_Postion(id, 15.0, 5.0, -35.0, origin)

	new iEnt = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	set_pev(iEnt, pev_classname, "levelupef")
	set_pev(iEnt, pev_origin, origin)
	set_pev(iEnt, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(iEnt, pev_solid, SOLID_NOT)
	set_pev(iEnt, pev_light_level, 180)
	set_pev(iEnt, pev_rendermode, kRenderTransAdd)
	set_pev(iEnt, pev_renderamt, 255.0)
	set_pev(iEnt, pev_animtime, 0.5)
	engfunc(EngFunc_SetModel, iEnt,LevelUpSpr)//你的模型
	engfunc(EngFunc_SetSize, iEnt, Float:{-1.0, -1.0, -1.0}, Float:{1.0, 1.0, 1.0})
	dllfunc(DLLFunc_Spawn, iEnt)
	set_pev(iEnt, pev_owner, id)
	set_pev(iEnt, pev_nextthink, get_gametime() + 0.01)
	set_pev(iEnt, pev_ltime,get_gametime()+0.55)
}
stock Make_EffSprite(Float:fOrigin[3])
{
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0)
	write_byte(TE_SPRITE)
	engfunc(EngFunc_WriteCoord, fOrigin[0])
	engfunc(EngFunc_WriteCoord, fOrigin[1])
	engfunc(EngFunc_WriteCoord, fOrigin[2])
	write_short(g_SprEff) 
	write_byte(3)
	write_byte(255)
	message_end()
}

//Orpheu
stock ClearMultiDamage()
{
	OrpheuCall(handleClearMultiDamage);
}

stock ApplyMultiDamage(inflictor, iAttacker)
{
	OrpheuCall(handleApplyMultiDamage, inflictor, iAttacker);
}

//Emotion
stock Set_Weapon_Anim(id, Anim)
{
	if(!is_user_alive(id))
		return
		
	set_pev(id, pev_weaponanim, Anim)

	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
	write_byte(Anim)
	write_byte(pev(id, pev_body))
	message_end()
}
stock Set_Entity_Invisible(ent, Invisible = 1)
{
	if(!pev_valid(ent))
		return
		
	set_pev(ent, pev_effects, Invisible == 0 ? pev(ent, pev_effects) & ~EF_NODRAW : pev(ent, pev_effects) | EF_NODRAW)
}
public Reset_Var(id)
{
	if(!is_user_connected(id))
		return
		
	if(g_InDoingEmo[id])
	{
		if(get_user_weapon(id) == CSW_KNIFE)
			engclient_cmd(id, "lastinv")
	}
		
	if(task_exists(id+TASK_EMOTION)) remove_task(id+TASK_EMOTION)	
	
	g_InDoingEmo[id] = 0

}
public Reset_Emotion(id)
{
	id -= TASK_EMOTION
	
	if(!is_user_connected(id))
		return
	if(!is_user_alive(id)) return
	if(!g_InDoingEmo[id])
		return

	z_skilling[id]=0
	z_skilling2[id]=0
		
	Do_Reset_Emotion(id)
}
public Do_Reset_Emotion(id)
{
	if(!is_user_connected(id))
		return
	if(!g_InDoingEmo[id])
		return
	if(!is_user_alive(id)) return
		
	if(task_exists(id+TASK_EMOTION)) remove_task(id+TASK_EMOTION)
		Set_Entity_Invisible(id, 0)

	if(g_OldWeapon[id] == CSW_KNIFE)
	{
		reset_user_knife(id)
	}
	else if(g_OldWeapon[id] == CSW_P228 || g_OldWeapon[id] == CSW_ELITE || g_OldWeapon[id] == CSW_FIVESEVEN || g_OldWeapon[id] == CSW_USP || g_OldWeapon[id] == CSW_GLOCK18 || g_OldWeapon[id] == CSW_DEAGLE)
	{
		draw_weapons(id, 2)
	}
	else if(g_OldWeapon[id] == CSW_HEGRENADE || g_OldWeapon[id] == CSW_SMOKEGRENADE || g_OldWeapon[id] == CSW_FLASHBANG)
	{
		draw_weapons(id, 3)
	}
	else
	{
		draw_weapons(id, 1)
	}


	g_InDoingEmo[id] = 0

}


public Set_Emotion_Start(id)
{
	if(!is_user_alive(id))
		return
	g_InDoingEmo[id] = 1

	Do_Set_Emotion(id)
}
public Do_Set_Emotion(id)
{
	if(!g_InDoingEmo[id]) return
	if(!is_user_alive(id)) return
	g_OldWeapon[id] = get_user_weapon(id)

	engclient_cmd(id, "weapon_knife")
	
	if(!STE_GetUserZombie(id))//如果不是僵尸的话
	{
		set_pev(id, pev_viewmodel2, "models/v_emotion2.mdl")
		Set_Weapon_Anim(id,0)

		if(task_exists(id+TASK_EMOTION)) remove_task(id+TASK_EMOTION)
			set_task(1.0, "Reset_Emotion", id+TASK_EMOTION)
	}
	else //如果是僵尸的话.
	{
		static PlayerModel[64]
		fm_cs_get_user_model(id, PlayerModel, sizeof(PlayerModel))

		if(equal(PlayerModel,"witch_zombi_origin")||equal(PlayerModel,"witch_zombi_host")||equal(PlayerModel,"teleport_zombi_origin")
			||equal(PlayerModel,"teleport_zombi_host")||equal(PlayerModel,"revival_zombi_origin")||equal(PlayerModel,"revival_zombi_host"))
		{
			engclient_cmd(id, "weapon_knife")
			client_print(id,print_chat,"动作表演：9")
			Set_Weapon_Anim(id, 9)
		}
		else if(equal(PlayerModel,"stamper_zombi_origin")||equal(PlayerModel,"stamper_zombi_host")||equal(PlayerModel,"pc_zombi_origin")||equal(PlayerModel,"pc_zombi_host")
			||equal(PlayerModel,"pass_zombi_origin")||equal(PlayerModel,"pass_zombi_host")||equal(PlayerModel,"heal_zombi_origin")||equal(PlayerModel,"heal_zombi_host")
			||equal(PlayerModel,"heavy_zombi_origin")||equal(PlayerModel,"heavy_zombi_host")||equal(PlayerModel,"deimos_zombi_origin")||equal(PlayerModel,"deimos_zombi_host")
			||equal(PlayerModel,"deimos2_zombi_origin")||equal(PlayerModel,"deimos2_zombi_host")||equal(PlayerModel,"china_zombi_origin")||equal(PlayerModel,"china_zombi_host")
			||equal(PlayerModel,"booster_zombi_origin")||equal(PlayerModel,"booster_zombi_host")||equal(PlayerModel,"boomer_zombi_origin")||equal(PlayerModel,"boomer_zombi_host")
			||equal(PlayerModel,"speed_zombi_origin")||equal(PlayerModel,"speed_zombi_host")||equal(PlayerModel,"tank_zombi_origin")||equal(PlayerModel,"tank_zombi_host"))	
		{
			engclient_cmd(id, "weapon_knife")
			client_print(id,print_chat,"动作表演：8")
			Set_Weapon_Anim(id, 8)
		}

		else if(equal(PlayerModel,"resident_zombi_origin")||equal(PlayerModel,"resident_zombi_host")||equal(PlayerModel,"flyingzombi_origin")
			||equal(PlayerModel,"flyingzombi_host"))
		{
			engclient_cmd(id, "weapon_knife")
			client_print(id,print_chat,"动作表演：11")
			Set_Weapon_Anim(id, 11)
		}
	}
}
public reset_user_knife(id)
{
	// Latest version support
	ExecuteHamB(Ham_Item_Deploy, find_ent_by_owner(FM_NULLENT, "weapon_knife", id)) // v4.3 Support
	
	// Updating Model
	engclient_cmd(id, "weapon_knife")
	emessage_begin(MSG_ONE, g_msgCurWeapon, _, id)
	ewrite_byte(1) // active
	ewrite_byte(CSW_KNIFE) // weapon
	ewrite_byte(0) // clip
	emessage_end()
}


//Extra Functions
//Running for Gdds
public Knife_ExecuteAttack(iAttacker, iVictim, iEntity, iPtr, Float:fDamage, iHeadShot, iDamageBit)
{
	if (pev(iVictim, pev_takedamage) <= 0.0)
		return 0
	new Float:fMultifDamage, Float:fEnd[3]
	new iHitGroup = get_tr2(iPtr, TR_iHitgroup)
	get_tr2(iPtr, TR_vecEndPos, fEnd)
	set_pdata_int(iVictim, 75, iHitGroup, 4)

	switch(iHitGroup)
	{
		case HIT_HEAD: fMultifDamage  = 4.0
		case HIT_CHEST: fMultifDamage  = 1.0
		case 3: fMultifDamage  = 1.25
		case 4,5,6,7: fMultifDamage  = 0.75
		default: fMultifDamage  = 1.0
	}
	fDamage *= fMultifDamage
	ExecuteHamB(Ham_TakeDamage, iVictim, iEntity, iAttacker, fDamage, iDamageBit)
	return 1
}

public Knife_Damage(id, Float:flRange, Float:fAngle, Float:flDamage, iAttackType)
{
	new iHitResult = HIT_NOTHING
	new Float:vecOrigin[3], Float:vecScr[3], Float:vecEnd[3], Float:V_Angle[3], Float:vecForward[3]
	pev(id, pev_origin, vecOrigin)
	GetGunPosition(id, vecScr)
	pev(id, pev_v_angle, V_Angle)
	engfunc(EngFunc_MakeVectors, V_Angle)
	global_get(glb_v_forward, vecForward)
	xs_vec_mul_scalar(vecForward, flRange, vecForward)
	xs_vec_add(vecScr, vecForward, vecEnd)

	new tr = create_tr2()
	engfunc(EngFunc_TraceLine, vecScr, vecEnd, 0, id, tr)
	new Float:flFraction
	get_tr2(tr, TR_flFraction, flFraction)
	new Float:EndPos2[3]
	get_tr2(tr, TR_vecEndPos, EndPos2)
	Make_EffSprite(EndPos2)

	new Float:vecEndZ = vecEnd[2]
	new pEntity = -1

	while ((pEntity = engfunc(EngFunc_FindEntityInSphere, pEntity, vecOrigin, flRange)) != 0)
	{
		if (!pev_valid(pEntity))
			continue
		if (!IsAlive(pEntity))
			continue
		if (fAngle < 120.0 && !CheckAngle(id, pEntity, fAngle))
			continue

		CreateBombKnockBack(pEntity, vecOrigin, flDamage, KNOBACK_KNIFE+(KNOBACK_KNIFE2*g_rount_count), id, 0.0)
		GetGunPosition(id, vecScr)

		Stock_Get_Origin(pEntity, vecEnd)
		vecEnd[2] = vecScr[2] + (vecEndZ - vecScr[2]) * (get_distance_f(vecScr, vecEnd) / flRange)
		engfunc(EngFunc_TraceLine, vecScr, vecEnd, 0, id, tr)
		get_tr2(tr, TR_flFraction, flFraction)
		if (flFraction >= 1.0)
			engfunc(EngFunc_TraceHull, vecScr, vecEnd, 0, 3, id, tr)
		
		get_tr2(tr, TR_flFraction, flFraction)
		new pHit = get_tr2(tr, TR_pHit)

		if (flFraction < 1.0)
		{
			new Float:EndPos[3]
			get_tr2(tr, TR_vecEndPos, EndPos)
			if (IsPlayer(pEntity) || IsHostage(pEntity))
			{
				iHitResult = HIT_ENEMY
				if (CheckBack(id, pEntity))
					flDamage *= 3.0
				//Make_EffSprite(EndPos)
			}

			if (pev_valid(pEntity) && pHit == pEntity && id != pEntity && !(pev(pEntity, pev_spawnflags) & SF_BREAK_TRIGGER_ONLY))
			{
				ClearMultiDamage()
				ExecuteHamB(Ham_TraceAttack, pEntity, id, flDamage, vecForward, tr, DMG_NEVERGIB | DMG_CLUB)
				ApplyMultiDamage(id, id)
				Knife_ExecuteAttack(id, pEntity, id, tr, Float:flDamage, 1, DMG_NEVERGIB | DMG_CLUB)
				if (iAttackType == 1)
				{
					if (get_cvar_num("mp_friendlyfire") || (!get_cvar_num("mp_friendlyfire") && get_pdata_int(id, 114) != get_pdata_int(pEntity, 114)))
						fm_set_make_knockback(id, pEntity, KNOBACK_KNIFE+(KNOBACK_KNIFE2*g_rount_count), KNOBACK_HIGH_KNIFE)
				}
			}
		}
		free_tr2(tr)
	}
	return iHitResult
}
stock CreateBombKnockBack(iVictim, Float:vAttacker[3], Float:fMulti, Float:fRadius, iAttacker, Float:fMaxDamage)
{
	new Float:vVictim[3];
	pev(iVictim, pev_origin, vVictim);

	xs_vec_sub(vVictim, vAttacker, vVictim);

	if (is_user_connected(iAttacker))
	{
		if (get_pdata_int(iVictim, 114) != get_pdata_int(iAttacker, 114) || get_cvar_num("mp_friendlyfire") || iAttacker == iVictim)
		{
			new Float:fDamage, Float:fDistance = xs_vec_len(vVictim);
			fDamage = (fRadius - fDistance) / fRadius * fMaxDamage;
			fDamage = fDamage < 1.0 ? 1.0 : fDamage;
			
			if (iAttacker == iVictim)
				fDamage *= 0.1;
			
			ExecuteHam(Ham_TakeDamage, iVictim, iAttacker, iAttacker, fDamage, (1<<24));
		}
	}
	
	xs_vec_mul_scalar(vVictim, fMulti * 0.7, vVictim);
	xs_vec_mul_scalar(vVictim, fRadius / xs_vec_len(vVictim), vVictim);
	
	set_pev(iVictim, pev_velocity, vVictim);
}
stock Float:get_default_maxspeed(id)
{	
	const m_pActiveItem		= 373
	new wEnt = get_pdata_cbase(id, m_pActiveItem), Float:result = 250.0;

	if(pev_valid(wEnt))
	{
		ExecuteHam(Ham_CS_Item_GetMaxSpeed, wEnt, result);
	}
	
	return result;
}
stock PlaySound(id, const sound[])
{
	if(equal(sound[strlen(sound)-4], ".mp3")) client_cmd(id, "mp3 play ^"sound/%s^"", sound)
	else client_cmd(id, "spk ^"sound/%s^"", sound)
}

stock get_speed_vector(const Float:origin1[3],const Float:origin2[3],Float:speed, Float:new_velocity[3])
{
	new_velocity[0] = origin2[0] - origin1[0]
	new_velocity[1] = origin2[1] - origin1[1]
	new_velocity[2] = origin2[2] - origin1[2]
	new Float:num = floatsqroot(speed*speed / (new_velocity[0]*new_velocity[0] + new_velocity[1]*new_velocity[1] + new_velocity[2]*new_velocity[2]))
	new_velocity[0] *= num
	new_velocity[1] *= num
	new_velocity[2] *= num
}
const GRENADE_WEAPONS_BIT_SUM = (1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)
const SECONDARY_WEAPONS_BIT_SUM = (1<<CSW_P228)|(1<<CSW_ELITE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_DEAGLE)
const PRIMARY_WEAPONS_BIT_SUM = 
(1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<
CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90)

stock draw_weapons(id, drawwhat)
{
	static weapons[32], num, i, weaponid
	num = 0
	get_user_weapons(id, weapons, num)
     
	for (i = 0; i < num; i++)
	{
		weaponid = weapons[i]
          
		if (drawwhat == 1 && ((1<<weaponid) & PRIMARY_WEAPONS_BIT_SUM))
		{
			static wname[32]
			get_weaponname(weaponid, wname, sizeof wname - 1)
			engclient_cmd(id, wname)
		}
		
		if (drawwhat == 2 && ((1<<weaponid) & SECONDARY_WEAPONS_BIT_SUM))
		{
			static wname[32]
			get_weaponname(weaponid, wname, sizeof wname - 1)
			engclient_cmd(id, wname)
		}
		
		if (drawwhat == 3 && ((1<<weaponid) & GRENADE_WEAPONS_BIT_SUM))
		{
			static wname[32]
			get_weaponname(weaponid, wname, sizeof wname - 1)
			engclient_cmd(id, wname)
		}
	}
}