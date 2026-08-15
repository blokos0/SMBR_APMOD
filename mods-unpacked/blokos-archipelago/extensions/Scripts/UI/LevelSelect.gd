extends "res://Scripts/UI/LevelSelect.gd"
# i have to replace some functions to handle the randomized level order, sorry
# added the lvl line and replaced occurences of idx with lvl - 1
func setup_visuals() -> void:
	%MarathonBits.visible = Global.current_game_mode == Global.GameMode.MARATHON_PRACTICE
	%ChallengeBits.visible = Global.current_game_mode == Global.GameMode.CHALLENGE
	var idx := 0
	for i in %SlotContainer.get_children():
		if i.visible == false:
			continue
		var lvl: float = $/root/AP.slot_data["levelorder"][str(Global.world_num)][idx]
		var level_theme = Global.LEVEL_THEMES[Global.current_campaign][Global.world_num - 1]
		visited_levels = (SaveManager.visited_levels.substr((Global.world_num - 1) * 4, 4))
		var level_visited = SaveManager.visited_levels[SaveManager.get_level_idx(Global.world_num, idx + 1)] != "0" or Global.debug_mode
		var cur_level = {"SMB1": SMB1_ICONS,"SMBLL": SMBLL_ICONS,"SMBS": SMBS_ICONS,"SMBANN": SMBANN_ICONS}[Global.current_campaign][Global.world_num - 1][(lvl - 1)]
		var cur_icon = ICON_LOCKED if not level_visited else night_level_icons if cur_level[0] == "night" else day_level_icons
		var grid_size = [cur_icon.get_width() - icon_size[0], cur_icon.get_height() - icon_size[1]]
		var clamp_icon = clamp([cur_level[1][0] * icon_size[0], cur_level[1][1] * icon_size[1]], [0, 0], grid_size)
		i.get_node("Icon").texture = cur_icon
		i.get_node("Icon").region_rect = Rect2(clamp_icon[0], clamp_icon[1], icon_size[0], icon_size[1])
		i.get_node("Icon/Number").region_rect.position.y = clamp(NUMBER_Y.find(level_theme) * 12, 0, 9999)
		i.get_node("Icon/Number").region_rect.position.x = (lvl - 1) * 12
		i.get_node("ChallengeModeBits").visible = Global.current_game_mode == Global.GameMode.CHALLENGE
		i.get_node("Icon/RankMedal").hide()
		if Global.current_game_mode == Global.GameMode.CHALLENGE:
			setup_challenge_mode_bits(i.get_node("ChallengeModeBits"), lvl)
		if has_disco_stuff:
			i.get_node("Icon/RankMedal").show()
			i.get_node("Icon/RankMedal").frame = "ZFDCBASP".find(DiscoLevel.level_ranks[SaveManager.get_level_idx(Global.world_num, lvl)])
			i.get_node("Icon/RankMedal/SRankParticles").visible = i.get_node("Icon/RankMedal").frame == 6
			i.get_node("Icon/RankMedal/PRankParticles").visible = i.get_node("Icon/RankMedal").frame == 7
		idx += 1
# replace selected level
func slot_selected(idx := 0) -> void:
	selected_level = $/root/AP.slot_data["levelorder"][str(Global.world_num)][idx] - 1
	update_pb()
	update_score()
	if Settings.file.audio.extra_sfx == 1:
		AudioManager.play_global_sfx("menu_move")
