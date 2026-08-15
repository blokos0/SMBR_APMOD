extends "res://Scripts/Parts/GameOver.gd"
func reset_values() -> void:
	super()
	match Settings.file.difficulty.game_over_behaviour:
		0:
			Global.level_num = $"/root/AP".slot_data["levelorder"][str(Global.world_num)][0]
		1:
			pass
		2:
			Global.world_num = $"/root/AP".slot_data["starting_world"]
			Global.level_num = $"/root/AP".slot_data["levelorder"][str(Global.world_num)][0]
			Global.custom_level_idx = 0
