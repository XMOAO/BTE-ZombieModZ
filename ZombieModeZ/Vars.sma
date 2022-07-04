
//ZombieZ
#define skill_count 71 + 1
#define max_level 40
#define skill 0
#define weight 1
#define team 2

#define  _DEBUG

new is_skill_init = 0,z_level[33],z_point[33],SaveData_Pool[33][skill_count][3],SaveData_Get[33][max_level],SaveData_Flag[33][skill_count],z_skilling[33], z_skilling2[33]
new Float: fSavedDmg[33], iLevel[33], Float: fUpgrade_rst[33], Float: AddExp[33]
new iPercent[33]
new g_SaveUserData[33][skill_count]

new g_rount_count,g_startcount,g_iCheck
new g_msgCurWeapon

//Main Vars
enum
{
	common = 0, //通用技能
	human, //人类技能
	zombie //僵尸技能
}
enum
{
	moremoney=0,//金融家0
	master,//格斗带师1
	moreclip,//弹夹扩容2
	fastreload,//高速梯安装3
	alphareload,//透明换弹4
	cheetah,//猎豹5
	kangaroo,//袋鼠6
	restore,//恢复强化7
	frontattack,//正面突击8
	tommyrush,//冲锋推进9
	moreammo,//备弹补充10
	hunt,//狩猎本能11
	djump,//二段跳12
	bombammo,//爆炸弹头13
	geneup,//强化基因14
	nogiveup,//坚持不懈15
	fireammo,//点燃16
	morehp,//生命补液17
	easyinfection,//接触感染18
	respawn,//复活19
	zbarmor,//钢铁铠甲20
	feetfast,//脚掌21
	hardhead,//钢铁头盔22
	easyshoot,//神枪手23
	sixthsense,//第六感24
	morehero,//狗熊出现25
	craze,//狂热26
	specialskills,//持之以恒27
	falldown,//强制坠落28
	adaptability,//适应力29
	slowgrenade,//疫苗手雷30
	grenadebag,//炸弹背包31
	supportboom,//支援轰炸32
	headstrike,//致命一击33
	hardammo,//破甲弹头34
	moregrenade,//连发手雷35
	zombiebomb,//爆弹兽颅36
	fireball,//火焰球37
	Mammoth,//猛犸38
	Frozengrenade,//冷冻手雷39
	ekuce,//伊卡洛斯40
	pydt,//贫铀弹头41
	less,//少数精锐42
	moneypower,//金钱之力43
	weaponup,//武器熟练44
	infres,//感染恢复45
	zbbombup,//兽庐强化46
	longknife,//合金利爪47
	lesscd,//技能冷却48
	miss,//倾斜装甲49

	greenhat,//50,
	morezbnade,//51,
	fuchounade,//52,
	zbnadebarrier,//53,
	miserablememory,//54,
	hidezbnade,//55,
	mix,//56,
	crazyrush,//57,
	vipcard,//58,
	fastdraw,//59,
	crazysolidor,//60,
	IamFaster,//61,
	copydamage,//62,
	energeticnet,//63,
	dangerousinvestment,//64,
	badplace,//65,
	zbLysis,//66,
	Flychair,//67,
	gouzibaodan,//68,
	glasscannon,//69,
	busy,//70,
	variation//71,
}

new Skill_List[skill_count][3] = 
{
	{moremoney,100,0},
	{master,100,1},
	{moreclip,100,1},
	{fastreload,50,1},
	{alphareload,100,1},
	{cheetah,25,0},
	{kangaroo,25,0},
	{restore,100,0},
	{frontattack,100,1},
	{tommyrush,100,1},
	{moreammo,100,1},
	{hunt,100,0},
	{djump,25,0},
	{bombammo,100,1},
	{geneup,25,2},
	{nogiveup,25,2},
	{fireammo,100,1},
	{morehp,100,0},
	{easyinfection,5,2},
	{respawn,100,2},
	{zbarmor,100,2},
	{feetfast,100,2},
	{hardhead,100,2},
	{easyshoot,100,1},
	{sixthsense,100,1},
	{morehero,25,0},
	{craze,100,0},
	{specialskills,100,1},
	{falldown,100,1},
	{adaptability,100,2},
	{slowgrenade,100,1},
	{grenadebag,100,1},
	{supportboom,100,1},
	{headstrike,100,1},
	{hardammo,100,1},
	{moregrenade,100,1},
	{zombiebomb,50,2},
	{fireball,100,1},
	{Mammoth,25,2},
	{Frozengrenade,100,1},
	{ekuce,25,0},
	{pydt,50,1},
	{less,15,1},
	{moneypower,50,1},
	{weaponup,50,1},
	{infres,100,2},
	{zbbombup,15,2},
	{longknife,25,2},
	{lesscd,50,2},
	{miss,50,2},

	{greenhat,100,0},
	{morezbnade,50,2},
	{fuchounade,100,2},
	{zbnadebarrier,100,1},

	{miserablememory,25,2},
	{hidezbnade,25,2},

	{mix,100,2},
	{crazyrush,100,2},
	{vipcard,100,0},
	{fastdraw,100,1},
	{crazysolidor,25,2},
	{IamFaster,100,0},
	{copydamage,100,1},
	{energeticnet,50,1},
	{dangerousinvestment,100,2},
	{badplace,25,2},
	{zbLysis,100,2},
	{Flychair,25,1},
	{gouzibaodan,100,2},
	{glasscannon,100,1},
	{busy,100,1},
	{variation,100,2}
}


new Skill_Name[skill_count][] = 
{
	"金融家",
	"格斗大师",
	"弹夹扩充",
	"高速填装",
	"透明换弹",
	"猎豹",
	"袋鼠",
	"恢复强化",
	"正面突击",
	"冲锋推进",
	"备弹补充",
	"狩猎本能",
	"二段跳",
	"爆炸弹头",
	"强化基因",
	"坚持不懈",
	"点燃",
	"生命补液",
	"接触感染",
	"复活",
	"钢铁铠甲",
	"脚掌",
	"钢铁头盔",
	"神枪手",
	"第六感",
	"英雄出现",
	"狂热",
	"持之以恒",
	"强制坠落",
	"适应力",
	"疫苗手雷",
	"炸弹背包",
	"支援轰炸",
	"致命一击",
	"破甲弹头",
	"连发手雷",
	"爆弹兽颅",
	"火焰球",
	"猛犸",
	"冷冻手雷",
	"伊卡洛斯",
	"贫铀弹头",
	"少数精锐",
	"金钱之力",
	"武器熟练",
	"感染恢复",
	"兽颅强化",
	"合金利爪",
	"技能冷却",
	"倾斜装甲",
	"进化学者",
	"兽颅增殖",
	"复仇投掷",
	"兽颅护盾",
	"痛苦记忆",
	"兽颅寄生",
	"融合",
	"愤怒狂奔",
	"优惠券",
	"快速切换",
	"狂战士",
	"先行者",
	"伤害复制",
	"能量网",
	"风险投资",
	"腐化之地",
	"僵尸猎犬",
	"弹射座椅",
	"钩子爆弹",
	"玻璃大炮",
	"忙碌",
	"变异"
	
}
new const Skill_Info[skill_count][4][]=
{
	{"mode/zbz/zombie3z_mutation_id_000","金融家","回合开始后，获得更多$。","[觉醒]立即获得$%f1a"},
	{"mode/zbz/zombie3z_mutation_id_001","格斗大师","使用近身武器时，攻击力提升。","[觉醒]产生的爆炸伤害提升%f1a倍"},
	{"mode/zbz/zombie3z_mutation_id_002","弹夹扩充","填装时一定概率装填更多的子弹。","[觉醒]装弹时必定会填装更多的子弹"},
	{"mode/zbz/zombie3z_mutation_id_003","高速填装","加快武器的装填速度。",""},
	{"mode/zbz/zombie3z_mutation_id_004","透明换弹","装弹时身体变透明。",""},
	{"mode/zbz/zombie3z_mutation_id_005","猎豹","增加移动速度。追加的移动速度不受重量影响。","[觉醒]提升追加移动速度"},
	{"mode/zbz/zombie3z_mutation_id_006","袋鼠","增加跳跃力。追加跳跃力不受重量影响。","[觉醒]跳跃后不会降低移动速度"},
	{"mode/zbz/zombie3z_mutation_id_007","恢复强化","提高恢复能力。","[觉醒]每秒恢复%f1a%最大生命值"},
	{"mode/zbz/zombie3z_mutation_id_008","正面突击","装备突击步枪时，定期增加移动速度和攻击力。","[觉醒]立即提升突击步枪的战斗力"},
	{"mode/zbz/zombie3z_mutation_id_009","冲锋推进","装备冲锋枪时增加移动速度，定期受到追加加速效果。","[觉醒]立即提升冲锋枪的移动速度"},
	{"mode/zbz/zombie3z_mutation_id_010","备弹补充","增加武器的备弹。",""},	
	{"mode/zbz/zombie3z_mutation_id_011","狩猎本能","定期将周围敌人指定为目标。","[觉醒]人类指定首次命中的敌人为目标\n      僵尸指定范围内所有人类为目标"},	
	{"mode/zbz/zombie3z_mutation_id_012","二段跳","在空中可以再跳一次。","[觉醒]提升第二段跳跃高度"},
	{"mode/zbz/zombie3z_mutation_id_013","爆炸弹头","攻击几率爆炸","[觉醒]射击时有%f1a%概率触发爆炸"},
	{"mode/zbz/zombie3z_mutation_id_014","强化基因","被感染时进化为母体僵尸。",""},
	{"mode/zbz/zombie3z_mutation_id_015","坚持不懈","受到攻击时低概率忽略定身和击退。","[觉醒]%f1a%概率忽略定身和击退"},
	{"mode/zbz/zombie3z_mutation_id_016","点燃","狙击枪命中时，使敌人燃烧。","[觉醒]狙击步枪命中后100%点燃敌人"},
	{"mode/zbz/zombie3z_mutation_id_017","生命补液","增加生命值。",""},
	{"mode/zbz/zombie3z_mutation_id_018","接触感染","身体触发时触发感染。",""},
	{"mode/zbz/zombie3z_mutation_id_019","复活","取得复活能力。",""},
	{"mode/zbz/zombie3z_mutation_id_020","钢铁铠甲","提升防御能力。","[觉醒]受到攻击时护甲值不会降低"},
	{"mode/zbz/zombie3z_mutation_id_021","脚掌","蹲下移动时增加移速。","[觉醒]蹲下移动时提升追加移动速度"},
	{"mode/zbz/zombie3z_mutation_id_022","钢铁头盔","降低致命打击的伤害。","[觉醒]%f1a%致命打击的伤害"},
	{"mode/zbz/zombie3z_mutation_id_023","神枪手","大幅提升狙击步枪的命中率。",""},
	{"mode/zbz/zombie3z_mutation_id_024","第六感","可以感知母体僵尸的出现，亦能感知到自己即将变为母体僵尸。",""},
	{"mode/zbz/zombie3z_mutation_id_025","英雄出现","拥有被选为英雄的资格。",""},
	{"mode/zbz/zombie3z_mutation_id_026","狂热","通过战斗与合作变得更强大。",""},
	{"mode/zbz/zombie3z_mutation_id_027","持之以恒","激活人类特殊技能。",""},
	{"mode/zbz/zombie3z_mutation_id_028","强制坠落","让梯子上的敌人摔落。",""},
	{"mode/zbz/zombie3z_mutation_id_029","适应力","随时改变将是种类。","[觉醒]变更僵尸种类时生命值不会降低"},
	{"mode/zbz/zombie3z_mutation_id_030","疫苗手雷","生成一个装有疫苗的烟雾弹，处于烟雾中的僵尸会受到持续伤害。","[觉醒]命中时自动投掷1枚疫苗手雷"},
	{"mode/zbz/zombie3z_mutation_id_031","炸弹背包","一定周期自动生成手雷。",""},
	{"mode/zbz/zombie3z_mutation_id_032","支援轰炸","手雷爆炸时低概率进行轰炸。",""},
	{"mode/zbz/zombie3z_mutation_id_033","致命一击","低概率触发致命一击。","[觉醒]射击时有%f1a%概率触发致命一击"},
	{"mode/zbz/zombie3z_mutation_id_034","破甲弹头","增加武器的射击威力。",""},
	{"mode/zbz/zombie3z_mutation_id_035","连发手雷","使用投掷装备时，自动追加使用次数。",""},
	{"mode/zbz/zombie3z_mutation_id_036","爆弹兽颅","受到伤害后产生爆弹兽颅。",""},
	{"mode/zbz/zombie3z_mutation_id_037","火焰球","使用狙击枪射击时发射火焰球。","[觉醒]发射火焰球的冷却时间减少至1秒"},
	{"mode/zbz/zombie3z_mutation_id_038","猛犸","受到伤害后产生爆弹兽颅。","[觉醒]站立时依旧提升防御力"},
	{"mode/zbz/zombie3z_mutation_id_039","冷冻手雷","生成一个可击退僵尸的冷冻手雷。",""},
	{"mode/zbz/zombie3z_mutation_id_040","伊卡洛斯","短时间内可以滑翔。",""},
	{"mode/zbz/zombie3z_mutation_id_041","贫铀弹头","增加子弹的穿透效果。",""},
	{"mode/zbz/zombie3z_mutation_id_042","少数精锐","人类数量减少时，增加攻击力和移动速度。",""},
	{"mode/zbz/zombie3z_mutation_id_043","金钱之力","拥有的$越多，武器的攻击力越高。",""},
	{"mode/zbz/zombie3z_mutation_id_044","武器熟练","连续购买同一武器，增加攻击力。",""},
	{"mode/zbz/zombie3z_mutation_id_045","感染恢复","感染时恢复周围僵尸的生命值。",""},
	{"mode/zbz/zombie3z_mutation_id_046","兽颅强化","强化爆弹兽颅。","[觉醒]立即生成1枚爆弹兽颅"},
	{"mode/zbz/zombie3z_mutation_id_047","合金利爪","增加僵尸的攻击距离。","[觉醒]僵尸普通攻击距离提升%f1a"},
	{"mode/zbz/zombie3z_mutation_id_048","技能冷却","减少僵尸技能的冷却时间。",""},
	{"mode/zbz/zombie3z_mutation_id_049","倾斜装甲","受到攻击时，一定概率不受伤害。","[觉醒]能力触发的同时忽略定身和击退"},
	{"mode/zbz/zombie3z_mutation_id_050","进化学者","通过击败僵尸及感染人类也可以提升进化等级。",""},
	{"mode/zbz/zombie3z_mutation_id_051","兽颅增殖","降低兽颅造成的伤害及击退效果。",""},
	{"mode/zbz/zombie3z_mutation_id_052","复仇投掷","作为僵尸死亡时，向前方投掷爆弹兽颅。","[觉醒]受到伤害时有%f1a%概率自动投掷\n      1枚爆弹兽颅"},
	{"mode/zbz/zombie3z_mutation_id_053","兽颅护盾","受到攻击时，一定概率不受伤害。",""},
	{"mode/zbz/zombie3z_mutation_id_054","痛苦记忆","降低击败过我的敌人再次对我造成的伤害。",""},
	{"mode/zbz/zombie3z_mutation_id_055","兽颅寄生","在生化补给箱中放置1个爆弹兽颅。",""},
	{"mode/zbz/zombie3z_mutation_id_056","融合","获得额外的僵尸技能。",""},
	{"mode/zbz/zombie3z_mutation_id_057","愤怒狂奔","生命值较低时提升移动速度。",""},
	{"mode/zbz/zombie3z_mutation_id_058","优惠券","使用资金$时享受折扣。",""},
	{"mode/zbz/zombie3z_mutation_id_059","快速切换","提升武器切换速度。","[觉醒]切换武器后，首次攻击伤害增加\n      %f1a%(觉醒期间仅限触发1次)"},
	{"mode/zbz/zombie3z_mutation_id_060","狂战士","成功击败人类目标后强化自身。",""},
	{"mode/zbz/zombie3z_mutation_id_061","先行者","所有解锁等级要求降低1级。",""},
	{"mode/zbz/zombie3z_mutation_id_062","伤害复制","攻击命中时较低概率重复造成1次相同的伤害。","[觉醒]提升再次造成伤害的触发概率"},
	{"mode/zbz/zombie3z_mutation_id_063","能量网","攻击时较低概率自动发射能量网。","[觉醒]攻击被禁锢的目标时提升伤害"},
	{"mode/zbz/zombie3z_mutation_id_064","风险投资","击败人类目标时获得奖励资金$。",""},
	{"mode/zbz/zombie3z_mutation_id_065","腐化之地","僵尸被击败时生成腐化之地。",""},
	{"mode/zbz/zombie3z_mutation_id_066","僵尸猎犬","使用爆弹兽颅造成伤害后召唤1只僵尸猎犬。","[觉醒]立即召唤1只僵尸猎犬"},
	{"mode/zbz/zombie3z_mutation_id_067","弹射座椅","即将被僵尸击败时，逃离死亡危机。",""},
	{"mode/zbz/zombie3z_mutation_id_068","钩子爆弹","在提升攻击力的同时，提升受到的伤害。",""},
	{"mode/zbz/zombie3z_mutation_id_069","玻璃大炮","使用爆弹兽颅造成伤害后，拉扯命中的目标。",""},
	{"mode/zbz/zombie3z_mutation_id_070","忙碌","无法使用技能时提升攻击力。",""},
	{"mode/zbz/zombie3z_mutation_id_071","变异","有一定概率成为变异僵尸。",""}

	//一共71个技能对吧,现在到49了,你就继续写50 ,51 ,52....
	//然后后面的名字对照cso_chn.txt复制粘贴进去就行了.别用记事本,就用 vs啥的
	//想写几个写几个
	//例子:第一个引号里只写序号就行


	

}



//这些不知道怎么分就放这把
//native MH_DrawRetina(id,sTga[],iShow,iFullScreen,iFlash,iChanne,Float:fTime)
#define defaultx -1.50
new g_HamBot
new OrpheuFunction:handleApplyMultiDamage//Require Orpheu
new OrpheuFunction:handleClearMultiDamage

#define TIMER_FREQUANCY 2.0 // 计时器的计数频率( 越小越快) 1.0为1秒1次
new Float:g_fPlayerPreThink[33],Float:g_fPlayerPostThink[33]

enum
{
	HIT_NOTHING = 0,
	HIT_ENEMY,
	HIT_WALL
}


//Useful Msg
new g_MaxPlayers,gmsgAmmoPickup

//Ui
new forwardpointnumber[32],backpointnumber[32]

//Emotion
new g_InDoingEmo[33], g_OldWeapon[33], g_OldKnifeModel[33][128]
#define TASK_EMOTION 1962

//level Up
new const LevelUpSpr[]={"sprites/ef_smoke_sb.spr"}
new LevelUpSound[64]

//Eff In Need
new Eff_FrostSmoke, Eff_FrostExplo,Eff_FrostGib,g_Explosion_SprId //火焰球

//Skill Api And Functions
new ZmyjEnable[33],BurnDamageEnable[33],QxzjEnable[33],TmhdEnable[33]

new jumpnum[33] = 0,doublejumpv,bool:dojump[33] = false

new firstgetskill[33],hp,maxhp,firsthpadd,roundhpadd

new Float:speedroundadd,Float:speedfirstadd

new wing[33],CheckEkuce[33]

//
new Float:FROST_RADIUS,hitself1,Float:chill_speed,Float:maxdamage1,Float:mindamage1,firstgetskillldsl[33]
new isFrozen[33], Float:oldGravity[33], hasFrostNade[33];
new const SOUND_EXPLODE[]   = "weapons/waterbomb_exp.wav";
new const SOUND_FROZEN[]  = "debris/glass1.wav";

new g_szSmokeSprites,Float:POISON_DAMAGE_BASE,Float:POISON_DAMAGE1,Float:BASE_POISON_LIFE,Float:POISON_LIFE1
new Float:g_fLastHurt[33],Float:g_fDmgToRestore[33],g_iHealer;

new Float:g_fStGNextthink[33][2], Float:g_fSpecialThink[33][2],bool:g_bStGAttacking[33][2],g_SprEff,Float:Range_KNIFE, Float:Angle_KNIFE, Float:DAMAGE_KNIFE,Float:DAMAGE_KNIFE2,Float:KNOBACK_KNIFE, Float:KNOBACK_HIGH_KNIFE,Float:KNOBACK_KNIFE2
new Float:GddsLeftNextThink,Float:GddsRightNextThink
new const Gdds_Sounds[][] = 
{
	"weapons/stormgiant_hit1.wav",
	"weapons/stormgiant_hit2.wav"
}

new bool:g_iReady[33]
new Float:g_fLastThink[33],Float:g_fRecoveryTime[2]
new Float:RecoverBaseTime,Float:RecoverRoundTime,RecoverBase,RecoverRound

new Float:JumpPowerBase,Float:JumpPowerRound

new Float:g_fTime,Float:g_fTime2=15.0
new CheckLmbnEnable[33],Tracking[33]

new addmoneybase,addmoneyround

new Float:DeadlyAttackRoundAdd

new FireBombModel,Float:FireBombFlySpeed,Float:FireBombDamageBase,Float:FireBombDamageRound
new Float:FireBombAngle,Float:FireBombKnockBackBase,Float:FireBombKnockBackRound
new CheckFireBall[33]

#define WEAPON_RELOAD_TIME  0.25 // 增加25%换弹速度
new Float:FastReloadAddBase,Float:FastReloadAddRound
new bool:setreload[33]

new QxzjRoundAdd,QxzjBaseAdd

new g_OldWeapon2[33], g_OldModel[33][128]

new Float:MaxSpeed[33][3]

new Float:GrhfBaseAdd,Float:GrhfRoundAdd

new Float:JzBaseAdd,Float:JzRoundAdd

new Float:PjdtBaseAdd,Float:PjdtRoundAdd

new Float:BdslEnableBaseDamage,Float:BdslEnableRoundAddDamage,Float:g_TotalDmg[33]
native Float:bte_zb_get_metaron_skilling(id)

new Float:CftjNeedDistance
new Float:CftjBaseAdd,Float:CftjRoundAdd,Float:CftjExtraBaseAdd,Float:CftjExtraRoundAdd
new Float:SpeedUpBaseLoopTime,Float:SpeedUpRoundAddLoopTime
new Float:g_fPlayerMove[33],SpeedUpCheck[33]

////持续时间
new Float:QzzlFallDownLoopTime=1.0 //CSOL JSON = 1.0
new QzzlFallDown[33],Float:QzzlFallDownThink[33]
//是否触发强制坠落      //计时器

#define FIRE_TIME		10.0
#define FIRE_DAMAGE		50.0
#define FIRE_RANGE		80.0
#define FIRE_DAMAGE_RANGE	125.0

new Float:OrgSaved[33],m_spriteTexture,rockeexplode
new JrjBase,JrjRoundAdd

new ZmtjDamage,ZmtjLimitBase,ZmtjLimitRoundAdd,Float:ZmtjAccuracy,Float:ZmtjFuck,ZmtjRoundAddPeriod
static const g_szWpnForA[][] = {"weapon_aug", "weapon_sg550","weapon_galil", "weapon_famas", "weapon_m4a1", "weapon_g3sg1", "weapon_sg552","weapon_ak47" }










