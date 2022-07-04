

public LoadConfigs(files[])
{
	new linedata[192], key[64], value[64], szBuffer[192]
	new file = fopen(files, "rt")
	while (file && !feof(file))
	{
		fgets(file, linedata, charsmax(linedata))
		replace(linedata, charsmax(linedata), "^n", "")
		if (!linedata[0] || linedata[0] == ';' || linedata[0] == '[')
		continue

		strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
		trim(key)
		trim(value)

		if (!strcmp(key, "levelsound"))
		{
			copy(LevelUpSound, charsmax(value), value)
			engfunc(EngFunc_PrecacheSound, value)
		}

		else if (!strcmp(key, "二段跳跳跃时追加的速度"))
			doublejumpv = str_to_num(value)

		else if (!strcmp(key, "生命补液增加的最大生命值"))
			maxhp = str_to_num(value)
		else if (!strcmp(key, "生命补液瞬发补给的生命值"))
			firsthpadd = str_to_num(value)
		else if (!strcmp(key, "生命补液每局补给的生命值"))
			roundhpadd = str_to_num(value)  

		//else if (!strcmp(key, "猎豹追加的最大速度值")) maxspeed = str_to_num(value)
		else if (!strcmp(key, "猎豹瞬发补给的速度值"))
			speedfirstadd = str_to_float(value)
		else if (!strcmp(key, "猎豹每局补给的速度值"))
			speedroundadd = str_to_float(value)

		//else if (!strcmp(key, "袋鼠追加的最大速度值")) maxspeed = str_to_float(value)
		else if (!strcmp(key, "袋鼠瞬发补给的速度值"))
			JumpPowerBase = str_to_float(value)
		else if (!strcmp(key, "袋鼠每局补给的速度值"))
			JumpPowerRound = str_to_float(value)

		else if (!strcmp(key, "冷冻手雷能否冰冻自己"))
			hitself1 = str_to_num(value)
		else if (!strcmp(key, "冷冻手雷冰冻范围"))
			FROST_RADIUS = str_to_float(value)
		else if (!strcmp(key, "冷冻手雷冷冻后（冻结结束）玩家最大速度"))
			chill_speed = str_to_float(value)
		else if (!strcmp(key, "冷冻手雷造成最大伤害"))
			maxdamage1 = str_to_float(value)
		else if (!strcmp(key, "冷冻手雷造成最低伤害"))
			mindamage1 = str_to_float(value)    



		else if (!strcmp(key, "格斗大师特效"))
			g_SprEff = engfunc(EngFunc_PrecacheModel, value)
		else if (!strcmp(key, "格斗大师攻击距离"))
			Range_KNIFE = str_to_float(value) //80
		else if (!strcmp(key, "格斗大师攻击范围"))
			Angle_KNIFE = str_to_float(value)//60
		else if (!strcmp(key, "格斗大师攻击伤害||基础伤害值"))
			DAMAGE_KNIFE = str_to_float(value)  
		else if (!strcmp(key, "格斗大师攻击伤害||每回合追加"))
			DAMAGE_KNIFE2 = str_to_float(value) 
		else if (!strcmp(key, "格斗大师攻击平地击退值||基础数值"))
			KNOBACK_KNIFE = str_to_float(value)
		else if (!strcmp(key, "格斗大师攻击平地击退值||每回合追加"))
			KNOBACK_KNIFE2 = str_to_float(value)
		else if (!strcmp(key, "格斗大师攻击击飞值"))
			KNOBACK_HIGH_KNIFE = str_to_float(value)    
		else if (!strcmp(key, "近身武器左键攻击触发格斗大师的频率"))
			GddsLeftNextThink = str_to_float(value)
		else if (!strcmp(key, "近身武器右键攻击触发格斗大师的频率"))
			GddsRightNextThink = str_to_float(value)

		else if (!strcmp(key, "疫苗手雷基础伤害值"))
			POISON_DAMAGE_BASE = str_to_float(value)
		else if (!strcmp(key, "疫苗手雷回合追加伤害值"))
			POISON_DAMAGE1 = str_to_float(value)
		else if (!strcmp(key, "疫苗手雷存在时间（基础值）"))
			BASE_POISON_LIFE = str_to_float(value)
		else if (!strcmp(key, "疫苗手雷存在时间（回合追加）"))
			POISON_LIFE1 = str_to_float(value)

		else if (!strcmp(key, "恢复强化基础回血"))
			RecoverBase = str_to_num(value)
		else if (!strcmp(key, "恢复强化每回合追加回血"))
			RecoverRound = str_to_num(value)
		else if (!strcmp(key, "恢复强化脱离战场基础回血时间"))
			RecoverBaseTime = str_to_float(value)
		else if (!strcmp(key, "恢复强化脱离战场每回合减少的追加回血时间"))
			RecoverRoundTime = str_to_float(value)
		else if (!strcmp(key, "恢复强化回血间隔"))
			g_fRecoveryTime[1] = str_to_float(value)

		else if (!strcmp(key, "金融家补给金钱基础值"))
			addmoneybase = str_to_num(value)
		else if (!strcmp(key, "金融家补给金钱每回合追加值"))
			addmoneyround = str_to_num(value)

		else if (!strcmp(key, "高速填装基础增加的换弹速度"))
			FastReloadAddBase = str_to_float(value)
		else if (!strcmp(key, "高速填装每回合增加的换弹速度"))
			FastReloadAddRound = str_to_float(value)

		else if (!strcmp(key, "致命一击每回合额外伤害增加值（小数化百分比）"))
			DeadlyAttackRoundAdd = str_to_float(value)

		else if (!strcmp(key, "火焰球模型"))
			FireBombModel = engfunc(EngFunc_PrecacheModel, value)
		else if (!strcmp(key, "火焰球飞行速度"))
			FireBombFlySpeed = str_to_float(value)
		else if (!strcmp(key, "火焰球基础伤害值"))
			FireBombDamageBase = str_to_float(value)
		else if (!strcmp(key, "火焰球每回合增加伤害值"))
			FireBombDamageRound = str_to_float(value)
		else if (!strcmp(key, "火焰球基础击退值"))
			FireBombKnockBackBase = str_to_float(value)
		else if (!strcmp(key, "火焰球每回合增加击退值"))
			FireBombKnockBackRound = str_to_float(value)
		else if (!strcmp(key, "火焰球爆炸范围"))
			FireBombAngle = str_to_float(value)


		else if (!strcmp(key, "倾斜装甲基础概率"))
			QxzjBaseAdd = str_to_num(value)
		else if (!strcmp(key, "倾斜装甲回合追加概率"))
			QxzjRoundAdd = str_to_num(value)

		else if (!strcmp(key, "感染恢复基础恢复值"))
			GrhfBaseAdd = str_to_float(value)
		else if (!strcmp(key, "感染恢复回合追加恢复值"))
			GrhfRoundAdd = str_to_float(value)

		else if (!strcmp(key, "脚掌基础速度"))
			JzBaseAdd = str_to_float(value)
		else if (!strcmp(key, "脚掌回合追加速度"))
			JzRoundAdd = str_to_float(value)

		else if (!strcmp(key, "破甲弹头追加伤害基础值"))
			PjdtBaseAdd = str_to_float(value)
		else if (!strcmp(key, "破甲弹头追加伤害回合追加值"))
			PjdtRoundAdd = str_to_float(value)

		else if (!strcmp(key, "僵尸承受伤害获得爆弹兽颅基础值"))
			BdslEnableBaseDamage = str_to_float(value)
		else if (!strcmp(key, "僵尸承受伤害获得爆弹兽颅回合追加值"))
			BdslEnableRoundAddDamage = str_to_float(value)

		else if (!strcmp(key, "冲锋推进基础速度值"))
			CftjBaseAdd = str_to_float(value)
		else if (!strcmp(key, "冲锋推进回合追加速度值"))
			CftjRoundAdd = str_to_float(value)
		else if (!strcmp(key, "[冲锋推进]推进器提供的基础速度值"))
			CftjExtraBaseAdd = str_to_float(value)
		else if (!strcmp(key, "[冲锋推进]推进器提供的回合追加速度值"))
			CftjExtraRoundAdd = str_to_float(value)
		else if (!strcmp(key, "[冲锋推进]推进器基础存在时间"))
			SpeedUpBaseLoopTime = str_to_float(value)
		else if (!strcmp(key, "[冲锋推进]推进器回合追加存在时间"))
			SpeedUpRoundAddLoopTime = str_to_float(value)
		else if (!strcmp(key, "冲锋推进触发距离"))
			CftjNeedDistance = str_to_float(value)

		else if (!strcmp(key, "强制坠落持续时间"))
			QzzlFallDownLoopTime = str_to_float(value)

		else if (!strcmp(key, "炸弹背包手雷创造周期"))
			ZdbbBaseTime = str_to_float(value)
		else if (!strcmp(key, "炸弹背包手雷创造周期回合追加值"))
			ZdbbRoundDropTime = str_to_float(value)
		else if (!strcmp(key, "炸弹背包创造手雷的数量"))
			ZdbbHowManyToGiveBase = str_to_num(value)
		else if (!strcmp(key, "炸弹背包创造手雷的数量回合追加值"))
			ZdbbHowManyToGivePeriodAdd = str_to_num(value)
		else if (!strcmp(key, "zdbb_increment_period"))
			ZdbbHowManyToGivePeriod = str_to_num(value)

		else if (!strcmp(key, "金融家补给金钱基础值"))
			JrjBase = str_to_num(value)
		else if (!strcmp(key, "金融家补给金钱每回合追加值 "))
			JrjRoundAdd = str_to_num(value)

		else if (!strcmp(key, "正面突击增加的攻击力"))
			ZmtjDamage = str_to_num(value)
		else if (!strcmp(key, "正面突击增加的准确度 "))
			ZmtjAccuracy = str_to_float(value)
		else if (!strcmp(key, "正面突击增加的击退"))
			ZmtjFuck = str_to_float(value)
		else if (!strcmp(key, "正面突击属性叠加基础值 "))
			ZmtjLimitBase = str_to_num(value)
		else if (!strcmp(key, "正面突击属性叠加回合追加值 "))
			ZmtjLimitRoundAdd = str_to_num(value)

		else if (!strcmp(key, "zmtj_increment_period "))
			ZmtjRoundAddPeriod = str_to_num(value)

		/*else if (!strcmp(key, "点燃触发几率基础值 "))
			DrBase = str_to_num(value)
		else if (!strcmp(key, "点燃触发几率回合追加值 "))
			DrRoundAdd = str_to_num(value)
		else if (!strcmp(key, "点燃爆头时是否立刻触发 "))
			DrHeadShootEnable = str_to_num(value)
		else if (!strcmp(key, "点燃火焰持续时间基础值 "))
			DrAliveTimeBase = str_to_num(value)
		else if (!strcmp(key, "点燃火焰持续时间回合追加值 "))
			DrAliveTimeRoundAdd = str_to_num(value)
		else if (!strcmp(key, "点燃火焰伤害基础值 "))
			ZmtjRoundAddPeriod = str_to_num(value)
		else if (!strcmp(key, "点燃火焰伤害回合追加值 "))
			ZmtjRoundAddPeriod = str_to_num(value)*/



	}
	fclose(file)
}