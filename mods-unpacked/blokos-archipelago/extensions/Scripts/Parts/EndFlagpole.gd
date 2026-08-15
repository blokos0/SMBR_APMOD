extends "res://Scripts/Parts/EndFlagpole.gd"
func player_touch(player: Player):
	if $/root/AP.playing:
		print("send check")
		var level: String = str(Global.world_num) + "-" + str(Global.level_num)
		if Global.world_num == -1:
			level = "-" + str(Global.level_num)
		$/root/AP.check(level)
	super(player)
