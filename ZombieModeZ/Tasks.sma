
#define TASK_REMOVE_FREEZE 815
#define Task_SpeedUp 816

public RebuildSpeed(taskid)
{
	new id = taskid-TASK_REMOVE_FREEZE;
	isFrozen[id]=0
	ExecuteHam(Ham_Item_PreFrame, id);
	set_pev(id,pev_gravity,oldGravity[id]);
	remove_entity_name("Ice")
}

public Task_RemoveSpeedUp(taskid)
{
	new id = taskid-Task_SpeedUp
	SpeedUpCheck[id]=0
	ExecuteHam(Ham_Item_PreFrame, id);
}

public RemoveTutor(taskID) 
{
	new id = taskID - 1111
	message_begin(MSG_ALL,get_user_msgid("TutorClose"),_,id)
	message_end()
}