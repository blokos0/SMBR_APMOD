extends "res://Scripts/Parts/CastleBridge.gd"
func victory_sequence(player: Player) -> void:
	if $/root/AP.playing:
		print("send check (axe edition)")
		var level: String = str(Global.world_num) + "-" + str(Global.level_num)
		if Global.world_num == -1:
			level = "-" + str(Global.level_num)
		$/root/AP.check(level)
	super(player)
