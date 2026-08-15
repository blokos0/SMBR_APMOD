extends "res://Scripts/UI/WorldSelect.gd"
# i have to replace some functions to get rid of the world one checks, sorry
# remove selected != 0
func handle_input() -> void:
	if Global.multibind_action_just_pressed("ui_accept"):
		if SaveManager.visited_levels.substr((selected_world + world_offset) * 4, 4) == "0000" and not Global.debug_mode:
			AudioManager.play_sfx("bump")
		else:
			select_world()
	elif Global.multibind_action_just_pressed("ui_back"):
		close()
		cleanup()
		cancelled.emit()
		return
# change world_visited
func setup_visuals() -> void:
	var idx := 0
	%Slot1.focus_neighbor_left = %Slot8.get_path()
	%Slot8.focus_neighbor_right = %Slot1.get_path()
	if Global.current_campaign == "SMBLL" && (Global.game_beaten or Global.debug_mode) && Global.current_game_mode == Global.GameMode.CAMPAIGN:
		%Slot1.focus_neighbor_left = %Slot13.get_path()
		%Slot8.focus_neighbor_right = %Slot9.get_path()
	for i in %SlotContainer.get_children():
		if idx >= 8:
			i.visible = Global.current_campaign == "SMBLL" && (Global.game_beaten or Global.debug_mode) && Global.current_game_mode == Global.GameMode.CAMPAIGN
		if i.visible == false:
			idx += 1
			continue
		var level_theme = Global.LEVEL_THEMES[Global.current_campaign][idx + world_offset]
		var world_visited = (SaveManager.visited_levels.substr((idx + world_offset) * 4, 4) != "0000" or Global.debug_mode)
		if world_visited == false:
			level_theme = "Mystery"
		var campaign_idx := 0
		if ((idx >= 4 and idx <= 8) or Global.current_campaign == "SMBANN"): campaign_idx = 1
		i.get_node("Icon").region_rect = CustomLevelContainer.THEME_RECTS[level_theme]
		i.get_node("Icon").texture = resource_getter.get_resource(load(CustomLevelContainer.ICON_TEXTURES[campaign_idx]), false)
		i.get_node("Icon/Number").position.y = 10 if has_challenge_stuff else 17
		i.get_node("Icon/Number").region_rect.position.y = clamp(NUMBER_Y.find(level_theme) * 12, 0, 9999)
		i.get_node("Icon/Number").region_rect.position.x = (idx + world_offset) * 12
		setup_challenge_mode_bits(i.get_node("Icon/RedCoins"), i.get_node("Icon/Egg"), i.get_node("Icon/Score"), i.get_node("Icon/RedCoins/Full"), i.get_node("Icon/Egg/Full"), i.get_node("Icon/Score/Full"), idx + world_offset)
		setup_marathon_bits(i.get_node("Icon/Medal"), i.get_node("Icon/Medal/Full"), idx + world_offset)
		setup_disco_bits(i.get_node("Icon/Medal"), i.get_node("Icon/Medal/Full"), i.get_node("Icon/Medal/Full/SRankParticles"), i.get_node("Icon/Medal/Full/PRankParticles"), idx + world_offset)
		idx += 1
