

public Do_Register_HamBot(id)
{
	//RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack_Player")
	RegisterHamFromEntity(Ham_TakeDamage, id, "HAM_TakeDamage")
	RegisterHamFromEntity(Ham_Touch, id, "Func_Jcgr")
	RegisterHamFromEntity(Ham_Item_PreFrame , id ,"HAM_Player_ResetMaxSpeed",1);
	//Func_Lmbn(id)
}

#define IsValidPev(%0) 			(pev_valid(%0) == 2)

public Func_EntityThink(iEntity)
{
	if(!pev_valid(iEntity)) 
		return HAM_IGNORED
	static Classname[32]
	pev(iEntity, pev_classname, Classname, sizeof(Classname))

	if(equal(Classname,"levelupef"))
	{
		set_pev(iEntity, pev_nextthink, 0.5)

		new Float:fFrame
		pev(iEntity, pev_frame, fFrame)
		fFrame += 2.0
		set_pev(iEntity, pev_frame, fFrame)

		static Float:fTimeRemove, Float:fValue
		pev(iEntity, pev_ltime, fTimeRemove)

		if(get_gametime() >= fTimeRemove - 0.6)
		{
			pev(iEntity, pev_renderamt, fValue)
			fValue -= 15.0
			fValue = floatmax(fValue, 0.0)
			set_pev(iEntity, pev_renderamt, fValue)
		}
		if(get_gametime() >= fTimeRemove)
		{
			set_pev(iEntity, pev_flags, pev(iEntity, pev_flags) | FL_KILLME)
			return HAM_IGNORED
		}
		return HAM_IGNORED
	}
	if(equal(Classname,"Ice"))
	{
		set_pev(iEntity, pev_nextthink, get_gametime() + 0.01)
		if(get_gametime()>=pev(iEntity,pev_ltime))
		{
			set_pev(iEntity, pev_flags, pev(iEntity, pev_flags) | FL_KILLME)
			return HAM_IGNORED

		}

	}

	if(equal(Classname, "fireball"))
	{
		new Float:vecOrigin[3];
		pev(iEntity, pev_origin, vecOrigin);

		static Float:flFrame 
		pev(iEntity, pev_frame, flFrame)
		if(flFrame <= (30.0 - 2.0)) 
		{
			flFrame += 1.0
			set_pev(iEntity, pev_frame, flFrame)
		}
		set_pev(iEntity, pev_nextthink, get_gametime() + 0.1)

		static Float:Origin[3]
		pev(iEntity, pev_origin, Origin)

		static iOwner; iOwner = pev(iEntity, pev_owner)
		static iAttacker; iAttacker = IsValidPev(iOwner) ? iOwner : 0
		static iVictim; iVictim = 0

		while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, Origin, FireBombAngle)) != 0)
		{
			if(!STE_GetUserZombie(iVictim) || !is_user_alive(iVictim))
				continue
			ExecuteHamB(Ham_TakeDamage, iVictim, iEntity, iAttacker, FireBombDamageBase+FireBombDamageRound*g_rount_count, DMG_DROWNRECOVER)
			fm_set_make_knockback(iAttacker, iVictim, FireBombKnockBackBase+FireBombKnockBackRound*g_rount_count, 100.0)
		}
		return HAM_IGNORED
	}

	if(equal(Classname, "b52"))
	{
		set_pev(iEntity, pev_nextthink, get_gametime() + 0.5)
		new id = pev( iEntity, pev_owner );
		new Float:Org[3],Float:EndOrigin[3],Float:Velocity[3];pev(iEntity,pev_origin,Org);pev(iEntity,pev_origin,EndOrigin)

		new Float:Origin[3], Float:Angles[3]

		new iEnt; iEnt = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
		engfunc(EngFunc_GetAttachment, id, 1, Origin, Angles)

		if(Angles[0] != 90.0)
			Angles[0] = -(360.0 - 270.0) 
		if(Angles[1] != 90.0)
			Angles[1] = -(360.0 - 270.0) 
		if(Angles[2] != 90.0)
			Angles[2] = -(360.0 - 270.0) 
		set_pev(iEnt, pev_angles, Angles)


		set_pev(iEnt, pev_classname, "b52_missile")
		set_pev(iEnt, pev_origin, Org)
		set_pev(iEnt, pev_solid, SOLID_TRIGGER)
		set_pev(iEnt, pev_movetype, MOVETYPE_TOSS)

		set_pev(iEnt, pev_owner, id)
		set_pev(iEnt, pev_frame, 0.0)
		engfunc(EngFunc_SetModel, iEnt,  "models/bunkerbuster_missile.mdl")
		set_pev(iEnt, pev_mins, {-1.0, -1.0, -1.0})
		set_pev(iEnt, pev_maxs, {1.0, 1.0, 1.0})
		set_pev(iEnt, pev_nextthink, get_gametime() + 0.1)
		set_pev(iEnt, pev_ltime, get_gametime() + 5.0)


		EndOrigin[2]=0.0
		get_speed_vector(Org, EndOrigin,500.0, Velocity)
		set_pev(iEnt, pev_velocity, Velocity)

		if(Org[0]>=OrgSaved[id])
		{
			client_print(id,print_chat,"飞机已经到达最大距离！已经抛锚！")
			set_pev(iEntity, pev_flags, pev(iEntity, pev_flags) | FL_KILLME);
			return HAM_IGNORED
		}
		client_print(id,print_chat,"飞机飞行距离：%.1f",OrgSaved[id]-Org[0])

		static Float: flLifeTime;
		if(pev(iEntity, pev_ltime, flLifeTime) && flLifeTime < get_gametime())
		{
			client_print(id,print_chat,"超时~！")
			set_pev(iEntity, pev_flags, pev(iEntity, pev_flags) | FL_KILLME);
			return HAM_IGNORED
		}

		/*static NewText[256],Float:Time=5.0
		formatex(NewText, 255, "Attention!!!");
		replace_all(NewText, 255, "\n", "^n");

		if(is_user_connected(id))
		{
			PlaySound(id, "events/tutor_msg.wav");

			message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("TutorText"), _, id)
			write_string(NewText)
			write_byte(0)
			write_short(0)
			write_short(0)
			write_short(1<<5)
			message_end()
		}

		if(Time != 0.0)
		{
			if( task_exists(id + 1111 ))
			{
				remove_task(id + 1111)
			}
			set_task(Time,"RemoveTutor",id + 1111)
		}*/
		return HAM_SUPERCEDE
	}

	if(equal(Classname, "StartEf"))
	{
		new id = pev( iEntity, pev_owner );
		set_pev(iEntity, pev_nextthink, get_gametime() + 0.05)

		static Float:fFrame
		pev(iEntity, pev_frame, fFrame)

		static Float:fFrameMax
		fFrameMax = float(engfunc(EngFunc_ModelFrames, pev(iEntity, pev_modelindex)))

		fFrame += 0.5
		if(fFrame >= fFrameMax) // from spr
			fFrame = 0.0

		set_pev(iEntity, pev_frame, fFrame)

		new Float:Origin[3]
		pev(iEntity, pev_origin, Origin)

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_BEAMENTPOINT)
		write_short(iEntity)
		engfunc(EngFunc_WriteCoord, Origin[0])
		engfunc(EngFunc_WriteCoord, Origin[1])
		engfunc(EngFunc_WriteCoord, Origin[2]+2048.0)
		write_short(m_spriteTexture)
		write_byte(5)
		write_byte(480)
		write_byte(1)
		write_byte(15)
		write_byte(0)
		write_byte(255)
		write_byte(10)
		write_byte(10)
		write_byte(200)
		write_byte(0)
		message_end()	

		static Float: flLifeTime;
		if(pev(iEntity, pev_ltime, flLifeTime) && flLifeTime < get_gametime()) 
		{
			new Float:StartOrg[3],Float:EndOrg[3]
			pev(iEntity, pev_vuser1, StartOrg)
			pev(iEntity, pev_vuser2, EndOrg)


			for(new i = 0;i<1;i++)
			{
				StartOrg[1]+=150.0
				new Float:Velocity[3]
				new PlaneEnt; PlaneEnt = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))

				set_pev(PlaneEnt, pev_classname, "b52")
				set_pev(PlaneEnt, pev_origin, StartOrg)
				set_pev(PlaneEnt, pev_solid, SOLID_NOT)
				set_pev(PlaneEnt, pev_movetype, MOVETYPE_NOCLIP)

				set_pev(PlaneEnt, pev_owner, id)
				set_pev(PlaneEnt, pev_frame, 0.0)
				engfunc(EngFunc_SetModel, PlaneEnt,  "models/b52.mdl")
				set_pev(PlaneEnt, pev_nextthink, get_gametime() + 0.1)

				set_pev(PlaneEnt,pev_ltime,get_gametime()+5.0)
				get_speed_vector(StartOrg, EndOrg,500.0, Velocity)
				set_pev(PlaneEnt, pev_velocity, Velocity)

				message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
				write_byte(TE_BEAMFOLLOW) // Temporary entity ID
				write_short(PlaneEnt) // Entity
				write_short(m_spriteTexture) // Sprite index
				write_byte(100) // Life
				write_byte(15) // Line width
				write_byte(10)
				write_byte(229)
				write_byte(255)
				write_byte(100) // Alpha
				message_end() 
			}
			set_pev(iEntity, pev_flags, pev(iEntity, pev_flags) | FL_KILLME);
			return HAM_SUPERCEDE
		}
	}

	if(equal(Classname, "B52_missile_fire"))
	{
		new Float:origin[3]
		pev(iEntity, pev_origin, origin)

		new Float:fCurTime
		global_get(glb_time, fCurTime)

		new Float:fuser1
		pev(iEntity, pev_fuser1, fuser1)

		if (fuser1 <= fCurTime)
		{
			//engfunc(EngFunc_EmitSound, Ent, CHAN_AUTO, FireSounds[2], 1.0, ATTN_NORM, 0, PITCH_NORM)
			engfunc(EngFunc_RemoveEntity, iEntity)
			return HAM_SUPERCEDE
		}
		new Float:fuser2, Float:fuser3, Float:fuser4
		pev(iEntity, pev_fuser2, fuser2)
		if (fuser2 <= fCurTime)
		{
			//engfunc(EngFunc_EmitSound, Ent, CHAN_AUTO, FireSounds[1], 1.0, ATTN_NORM, 0, PITCH_NORM)
			set_pev(iEntity, pev_fuser2, fCurTime + 4.0)
		}
		pev(iEntity, pev_fuser3, fuser3)
		if (fuser3 <= fCurTime)
		{

			new Float:fOrigin[3], Float:Range = FIRE_RANGE
			new Ent2 = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
			for (new i = 0; i < floatround(Range/40.0); i++)
			{
				fOrigin[0] = origin[0] + random_float(-Range/2.0, Range/2.0)
				fOrigin[1] = origin[1] + random_float(-Range/2.0, Range/2.0)
				fOrigin[2] = origin[2]
				if (engfunc(EngFunc_PointContents, fOrigin) != CONTENTS_EMPTY) fOrigin[2] += get_distance_f(fOrigin, origin)
					set_pev(Ent2, pev_origin, fOrigin)
				engfunc(EngFunc_DropToFloor, Ent2)
				pev(Ent2, pev_origin, fOrigin)
				
				if (engfunc(EngFunc_PointContents, fOrigin) != CONTENTS_EMPTY)
					continue

				engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0)
				write_byte(TE_SPRITE)
				engfunc(EngFunc_WriteCoord, fOrigin[0])
				engfunc(EngFunc_WriteCoord, fOrigin[1])
				engfunc(EngFunc_WriteCoord, fOrigin[2] + random_float(10.0, 30.0))
				write_short(engfunc(EngFunc_ModelIndex,"sprites/flame3.spr"))
				write_byte(random_num(15, 20))//9,11
				write_byte(100)
				message_end()

				engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0)
				write_byte(TE_DLIGHT)				// TE id
				engfunc(EngFunc_WriteCoord, fOrigin[0])	// x
				engfunc(EngFunc_WriteCoord, fOrigin[1])	// y
				engfunc(EngFunc_WriteCoord, fOrigin[2] + random_float(10.0, 30.0))	// z
				write_byte(10)					// radius in 10's
				write_byte(200)					// r
				write_byte(200)					// g
				write_byte(50)					// b
				write_byte(2)					// life
				write_byte(0)					// decay rate
				message_end()
			}
			set_pev(Ent2, pev_flags, FL_KILLME)
			set_pev(iEntity, pev_fuser3, fCurTime + 0.1)
		}

		pev(iEntity, pev_fuser4, fuser4)
		if (fuser4 <= fCurTime)
		{
			new i = -1
			while ((i = engfunc(EngFunc_FindEntityInSphere, i, origin, FIRE_DAMAGE_RANGE)) > 0)
			{
				if (!pev_valid(i))
					continue
	
				if (pev(i, pev_takedamage) == DAMAGE_NO)
					continue

				new Float:fOrigin[3]
				pev(i, pev_origin, fOrigin)

				engfunc(EngFunc_TraceLine, origin, fOrigin, IGNORE_MONSTERS, 0, 0)
				new Float:fraction
				get_tr2(0, TR_flFraction, fraction)
				if(fraction != 1.0)
					continue

				if (i == pev(iEntity, pev_owner))
					continue

				if (is_user_alive(i))
				{
					set_pdata_float(i, 108, 0.2, 5)
					set_pdata_int(i, 75, 2, 5)
				}
				if (get_cvar_num("mp_friendlyfire") || (!get_cvar_num("mp_friendlyfire") && get_pdata_int(pev(iEntity, pev_owner), 114) != get_pdata_int(i, 114)))
				{
					if (is_user_alive(i)) ExecuteHamB(Ham_TakeDamage, i, iEntity, pev(iEntity, pev_owner), 1.0, DMG_CLUB)
				}
			}
			set_pev(iEntity, pev_fuser4, fCurTime + 0.09)
		}
		set_pev(iEntity, pev_nextthink, fCurTime + 0.01)
	}

	return HAM_SUPERCEDE
}

public Func_EntityTouch(iEntity, iEnemy)
{
	if(!pev_valid(iEntity)) 
		return HAM_IGNORED

	static Classname[32]
	pev(iEntity, pev_classname, Classname, sizeof(Classname))
	static Float:Origin[3]
	pev(iEntity, pev_origin, Origin)

	
	if(equal(Classname, "fireball"))
	{

		static iOwner; iOwner = pev(iEntity, pev_owner)
		static iAttacker; iAttacker = IsValidPev(iOwner) ? iOwner : 0
		static iVictim; iVictim = 0

		new iVec[3];
		FVecIVec(Origin, iVec);

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY,iVec)
		write_byte(TE_EXPLOSION)
		engfunc(EngFunc_WriteCoord, Origin[0])
		engfunc(EngFunc_WriteCoord, Origin[1])
		engfunc(EngFunc_WriteCoord, Origin[2])
		write_short(g_Explosion_SprId)
		write_byte(15)
		write_byte(35)
		write_byte(TE_EXPLFLAG_NOSOUND|TE_EXPLFLAG_NOPARTICLES)
		message_end()

		while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, Origin, FireBombAngle)) != 0)
		{
			if(!STE_GetUserZombie(iVictim) || !is_user_alive(iVictim))
				continue

			ExecuteHamB(Ham_TakeDamage, iVictim, iEntity, iAttacker, FireBombDamageBase+FireBombDamageRound*g_rount_count, DMG_DROWNRECOVER)
			fm_set_make_knockback(iAttacker, iVictim, FireBombKnockBackBase+FireBombKnockBackRound*g_rount_count, 100.0)
		}
		remove_entity(iEntity)
		return HAM_IGNORED
	}

	if(equal(Classname, "b52_missile"))
	{

		set_pev(iEntity, pev_nextthink, get_gametime() + 0.05)

		new Float:Org[3]
		pev(iEntity,pev_origin,Org)
		new Float:OrgFake[3]
		pev(iEntity,pev_origin,OrgFake)

		if(Org[2]>100.0)//导弹在地面之上爆炸
		{
			#define MaxTimes 2//最多炸五次
			for(new i = 0; i < MaxTimes; i++)
			{
				client_print(1,print_chat,"done")

				OrgFake[2]-=100.0
				if(OrgFake[2]<=0.0)//已经到地面上了
					break

				//执行爆炸
				message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
				write_byte(TE_EXPLOSION)
				engfunc(EngFunc_WriteCoord, OrgFake[0])
				engfunc(EngFunc_WriteCoord, OrgFake[1])
				engfunc(EngFunc_WriteCoord, OrgFake[2] + 20.0)
				write_short(rockeexplode)
				write_byte(25)
				write_byte(10)
				write_byte(TE_EXPLFLAG_NONE)
				message_end()
				

				new Fire; Fire = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
				set_pev(Fire, pev_classname, "B52_missile_fire")
				set_pev(Fire, pev_origin, OrgFake)
				set_pev(Fire, pev_solid, SOLID_NOT)
				set_pev(Fire, pev_movetype, MOVETYPE_NONE)
				set_pev(Fire, pev_owner, pev(iEntity, pev_owner))

				new Float:fCurTime
				global_get(glb_time, fCurTime)
				set_pev(Fire, pev_nextthink, fCurTime + 0.01)
				set_pev(Fire, pev_fuser1, fCurTime + FIRE_TIME)	// 移除时间
			}
		}
		else
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_EXPLOSION)
			engfunc(EngFunc_WriteCoord, Org[0])
			engfunc(EngFunc_WriteCoord, Org[1])
			engfunc(EngFunc_WriteCoord, Org[2] + 50.0)
			write_short(rockeexplode)
			write_byte(25)
			write_byte(10)
			write_byte(TE_EXPLFLAG_NONE)
			message_end()

			new Fire; Fire = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
			set_pev(Fire, pev_classname, "B52_missile_fire")
			set_pev(Fire, pev_origin, OrgFake)
			set_pev(Fire, pev_solid, SOLID_NOT)
			set_pev(Fire, pev_movetype, MOVETYPE_NONE)
			set_pev(Fire, pev_owner, pev(iEntity, pev_owner))

			new Float:fCurTime
			global_get(glb_time, fCurTime)
			set_pev(Fire, pev_nextthink, fCurTime + 0.01)
			set_pev(Fire, pev_fuser1, fCurTime + FIRE_TIME)	// 移除时间
		}

		static Float: flLifeTime;
		if(pev(iEntity, pev_ltime, flLifeTime) && flLifeTime < get_gametime())
		{
			set_pev(iEntity, pev_flags, pev(iEntity, pev_flags) | FL_KILLME);
		}
		set_pev(iEntity, pev_flags, pev(iEntity, pev_flags) | FL_KILLME);
		return HAM_IGNORED

	}


	return HAM_SUPERCEDE
}

public RemoveHud(id)
{
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(!pev_valid(id))
		return HAM_IGNORED
/*
MH_DrawTargaImage(id,"",0,0,255,255,255,0.00,0.0,0,5,0.0)//v键
MH_DrawTargaImage(id,"",0,0,255,255,255,0.0,0.0,0,72,0.0)//技能点数背景栏
MH_DrawTargaImage(id,"",0,0,255,255,255,0.0,0.0,0,73,0.0)//
MH_DrawTargaImage(id,"",0,0,255,255,255,0.0,0.0,0,74,0.0)//
MH_DrawTargaImage(id,"",0,0,255,255,255,0.0,0.0,0,35,0.0)//技能背景栏
MH_DrawTargaImage(id,"",0,0,255,255,255,0.00,0.0,0,36,0.0)//技能图标
MH_DrawTargaImage(id,"",0,0,255,255,255,0.00,0.0,0,33,0.0)//左边技能框
MH_DrawTargaImage(id,"",0,0,255,255,255,0.00,0.0,0,34,0.0)//右边技能框

MH_DrawTargaImage(id,"",0,0,255,255,255,0.00,0.0,0,50,0.0)//
MH_DrawTargaImage(id,"",0,0,255,255,255,0.00,0.0,0,99,0.0)//
MH_DrawTargaImage(id,"",0,0,255,255,255,0.00,0.0,0,100,0.0)//
MH_DrawTargaImage(id,"",0,0,255,255,255,0.00,0.0,0,101,0.0)//



MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,30)//开始进化
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,36)//等级数
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,37)//等级数2
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,31)//技能叙述
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,32)//技能叙述2
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,34)//右边的技能数和L键显示
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,35)//

MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,40)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,41)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,42)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,43)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,44)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,45)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,46)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,47)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,48)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,49)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,50)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,51)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,52)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,53)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,54)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,55)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,56)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,57)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,58)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,59)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,60)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,61)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,62)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,63)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,64)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,65)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,66)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,67)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,68)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,69)//右边技能栏
MH_DrawFontText(id,"",0,0.0,0.0,255,255,255,0,0.0,0.0,0,70)//右边技能栏
*/
if(isFrozen[id]) RebuildSpeed(TASK_REMOVE_FREEZE+id);

return HAM_SUPERCEDE
}

public HAM_TakeDamage(iVictim, iInflictor, iAttacker, Float:fDamage,damage_type)
{
	if (!is_user_connected(iVictim))
		return HAM_IGNORED

	if (!is_user_connected(iAttacker))
		return HAM_IGNORED

	if(g_SaveUserData[iAttacker][moneypower])
		Func_Jqzl(iAttacker,Float:fDamage)

	if (is_user_alive(iVictim))
	{
		g_iReady[iVictim] = false
		client_print(iVictim,print_chat,"你受伤了，停止恢复强化技能效果.")
	}
	if ( (damage_type & DMG_DROWNRECOVER) /*&& STE_GetUserZombie(iVictim) */) BurnDamageEnable[iAttacker]=1
	else BurnDamageEnable[iAttacker]=0

	if(g_SaveUserData[iAttacker][headstrike])
		Func_Zmyj(iAttacker,iVictim,Float:fDamage)

	if(STE_GetUserZombie(iVictim))
		Func_Qxzj(iAttacker,iVictim,Float:fDamage)

	if(g_SaveUserData[iAttacker][hardammo])
		Func_Pjdt(iAttacker,iVictim,Float:fDamage)
	
	Func_Bdsl(iAttacker,iVictim,Float:fDamage)
	Func_Qzzl(iVictim,1)

	return HAM_IGNORED
}


public HAM_PlayerSpawn_Post(id)
{
	if (!is_user_alive(id))
		return;
	if(!pev_valid(id))
		return
	if(id>32||id<=0)
		return
	client_cmd(id,"bind v get_points")
	g_InDoingEmo[id] = 0

	Message_Change(id)

	if(g_SaveUserData[id][morehp])
		Func_Smby(id,1)

	g_fTime = 0.0
	g_fTime = get_gametime() + g_fTime2


	if(isFrozen[id]) RebuildSpeed(TASK_REMOVE_FREEZE+id);
}

public HAM_Item_Deploy_Post(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4)

	if(!g_SaveUserData[id][master])	
		return

	g_bStGAttacking[id][0] = false
	g_bStGAttacking[id][1] = false
	g_fStGNextthink[id][0] = 0.0
	g_fStGNextthink[id][1] = 0.0
}

public HAM_Item_Holster_Post(iEntity)
{
	new id = get_pdata_cbase(iEntity, 41, 4)

	if(!g_SaveUserData[id][master])	
		return

	g_bStGAttacking[id][0] = false
	g_bStGAttacking[id][1] = false
	g_fStGNextthink[id][0] = 0.0
	g_fStGNextthink[id][1] = 0.0
}
public HAM_WeaponReload(iEntity)
{
	if (!pev_valid(iEntity))
		return HAM_IGNORED;
		
	if (!get_pdata_int(iEntity, 54, 4))
		return HAM_IGNORED;
	new id = pev(iEntity,pev_owner)

	Func_Tmhd(id,iEntity)
	Func_Gstz(id,iEntity)
	/*if(id&&id<33)
	MH_SetViewFps(id, "reload", 200);*/
	//MH_SetViewRender(id, kRenderNormal, kRenderFxGlowShell, 255, 180, 30, 5);

	return HAM_IGNORED
}


public HAM_Knife_AttackThink(Ent)
{
	static id; id = pev(Ent, pev_owner)
	if(!is_user_alive(id))
		return HAM_IGNORED

	if(get_user_weapon(id)==CSW_KNIFE)
	{
		if(g_SaveUserData[id][master])
			Func_Gdds(id,1,1)
	}
	return HAM_IGNORED
}
public HAM_Grenade_Think(Ent)
{

	// Invalid entity
	if (!pev_valid(Ent)) return HAM_IGNORED;
	
	
	// Get damage time of grenade
	static Float:dmgtime, Float:current_time
	pev(Ent, pev_dmgtime, dmgtime)
	current_time = get_gametime()
	
	// Check if it's time to go off
	if (dmgtime > current_time)
		return HAM_IGNORED;
	//if(pev(Ent,pev_bInDuck)!=1)
	//	return HAM_IGNORED;

	if(pev(Ent,pev_bInDuck)==1)
	{
		Func_Ldsl(pev(Ent,pev_owner),Ent,0)
		return HAM_SUPERCEDE;
	}

	new Float:Origin[3]
	pev(Ent,pev_origin,Origin)
	//Func_Zyhz(pev(Ent,pev_owner),Origin)

	return HAM_IGNORED;
}


public HAM_Weapon_PrimaryAttack(Ent)
{
	static id; id = pev(Ent, pev_owner)
	new iClip = get_pdata_int(Ent, 51, 4)
	new Float:fCurTime,Float:g_fNextthink[33]=0.0
	if(!is_user_alive(id))
		return HAM_IGNORED
	if(iClip)
	{
		if(g_SaveUserData[id][fireball])	
		{
			if(!CheckFireBall[id])
			{
				if(get_user_weapon(id) == CSW_SCOUT || get_user_weapon(id) == CSW_AWP || get_user_weapon(id) == CSW_SG550 || get_user_weapon(id) == CSW_G3SG1)
				{   
					Func_Hyq(id)
					CheckFireBall[id]=1
					set_task(5.0-g_rount_count*0.2,"FireBallTimer",id)
					client_print(id,print_chat,"火焰球发动")
				}
			}
		}
	}
	if(get_user_weapon(id)==CSW_KNIFE)
	{

		if(g_SaveUserData[id][master])
			Func_Gdds(id,1,0)
	}

	
	/*new classname[32];
	new wpnId;
	new iWpn = get_pdata_cbase(id, 373, 5, 5);
	new iSlot = ExecuteHam(79, iWpn);

	new ent;
	ent = get_pdata_cbase(id, 368, 5, 5);


	set_pdata_int(Ent, 51, 4,get_pdata_int(Ent, 51, 4) + 1)
	pev(ent, 1, classname, 31);
	wpnId = get_weaponid(classname);
	cs_set_user_bpammo(id, wpnId, cs_get_user_bpammo(id, wpnId) - 1)

*/
	Func_Sqs(id,Ent)
	return HAM_IGNORED
}

public HAM_Player_ResetMaxSpeed(id)
{
	if(isFrozen[id])
	{
		set_user_maxspeed(id, 0.0);
	}

	if(g_SaveUserData[id][cheetah])	
	{
		Func_Lb(id)
		//set_user_maxspeed(id, 800.0);

	}
	if(g_SaveUserData[id][feetfast])	
	{
		Func_Jz(id)

	}
	Func_Cftj(id)

	return HAM_IGNORED;
}