
public fw_StartFrame_Post()
{
	Check_LmbnTime()
}


public fw_PlayerPreThink(id)
{
	if(!is_user_alive(id))
		return PLUGIN_CONTINUE
	if(!pev_valid(id))
		return PLUGIN_CONTINUE
	if(is_user_bot(id))
		return PLUGIN_CONTINUE

	new Float:CurTime
	global_get(glb_time, CurTime)

	if(CurTime < g_fPlayerPreThink[id] || !is_user_alive(id))
	return PLUGIN_CONTINUE

	g_fPlayerPreThink[id] = CurTime + (1.0/TIMER_FREQUANCY)
	Message_Change(id)
	if( !is_user_bot(id) )
	{
		if( !is_user_connected( id ) ) return PLUGIN_CONTINUE
		if(z_level[id]>=max_level) return PLUGIN_CONTINUE
			new percent = floatround( 100 * fSavedDmg[id] / fUpgrade_rst[ iLevel[id] ] )
			if( percent > 100 ) percent = 100
			iPercent[id]=percent
			show_exp( id, percent )

	}
	if(isFrozen[id])
	{
		new Ent
		Func_Ldsl(id,Ent,2)
	}
	if(g_SaveUserData[id][falldown])
		Func_Qzzl(id,0)
	if(g_SaveUserData[id][tommyrush])
		Func_Cftj(id)
	//Func_Zdbb(id)
	return PLUGIN_CONTINUE
}
public fw_PlayerPostThink(id)
{
	if (!is_user_connected(id))
		return PLUGIN_CONTINUE
	if(!pev_valid(id))
		return PLUGIN_CONTINUE
	if(is_user_bot(id))
		return PLUGIN_CONTINUE
	 new iEnt = fm_get_user_weapon_entity(id, CSW_M249)


	if (get_gametime() >= g_fPlayerPostThink[id] && g_fPlayerPostThink[id])
	{
		RemoveInvisible(id,iEnt)
		g_fPlayerPostThink[id] = 0.0
	}
	return PLUGIN_CONTINUE
}
public fw_AddToFullPack(es_handle, e, ent, host, hostflags, player, pSet)
{
	if (ent > 32 || !ent)
		return FMRES_IGNORED;
	if (pev(ent, pev_flags) & FL_KILLME) 
		return FMRES_IGNORED;
	new iOwner;iOwner= pev(ent, pev_owner)

	if (is_user_alive(iOwner) && TmhdEnable[iOwner])
	{
		/*set_es(es_handle, ES_RenderMode, kRenderTransAlpha);
		set_es(es_handle, ES_RenderAmt, 0.0);

		set_es(iOwner, ES_RenderMode, kRenderTransAlpha);
		set_es(iOwner, ES_RenderAmt, 0.0);*/
		set_es(es_handle, ES_Effects, (get_es(es_handle, ES_Effects) | EF_NODRAW));
		set_es(iOwner, ES_Effects, (get_es(iOwner, ES_Effects) | EF_NODRAW));
	}

	return FMRES_IGNORED;
}
public fw_ClientCommand(id)
{
	if(!is_user_alive(id)) return FMRES_IGNORED
	new sCmd[32]
	read_argv(0,sCmd,31)

	if(equal(sCmd,"weapon_",7))
		Reset_Emotion(id);
	if(equal(sCmd,"get_points",7))
		return FMRES_SUPERCEDE
	if(equal(sCmd,"showzbmenu",7))
		return FMRES_SUPERCEDE
	
	return FMRES_IGNORED
}

public fw_SetModel(ent,model[])
{
	new owner = pev(ent,pev_owner);
	if(!is_user_connected(owner)) return FMRES_IGNORED;
	
	// this isn't going to explode
	new Float:dmgtime;
	pev(ent,pev_dmgtime,dmgtime);
	if(dmgtime == 0.0) return FMRES_IGNORED;
	if(hasFrostNade[owner] != CSW_FLASHBANG)
			return FMRES_IGNORED
	
	new csw;
	if(model[7] == 'w' && model[8] == '_')  //w_xxx.mdl
	{
		if(model[9]=='f') //flashbang
		{
			if(hasFrostNade[owner] == CSW_FLASHBANG)
			{
				set_pev(ent,pev_bInDuck,1);
				new rgb[3], Float:rgbF[3];
				rgb[0] = 0;
				rgb[1] = 0;
				rgb[2] = 150;
				IVecFVec(rgb, rgbF);

				// glowshell
				set_pev(ent,pev_rendermode,kRenderNormal);
				set_pev(ent,pev_renderfx,kRenderFxGlowShell);
				set_pev(ent,pev_rendercolor,rgbF);
				set_pev(ent,pev_renderamt,16.0);
			}
		}
		return FMRES_SUPERCEDE
	}
	return FMRES_IGNORED;
}
