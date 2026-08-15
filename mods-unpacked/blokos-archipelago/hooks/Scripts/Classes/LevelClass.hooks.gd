extends Node
# i have to replace some functions to handle the randomized level order, sorry
func update_next_level_info(chain: ModLoaderHookChain) -> void:
	var main_node: Object = chain.reference_object as Level
	var lo: Array = main_node.get_node("/root/AP").slot_data["levelorder"][str(Global.world_num)]
	var nli: float = lo.find(float(Global.level_num)) + 1
	if nli > 3: # TODO: i dont wanna bother with checking if the next world is unlocked right now
		Global.transition_to_scene("res://Scenes/Levels/TitleScreen.tscn")
		return
	else:
		main_node.next_level = lo[nli]
		main_node.next_world = Global.world_num
	main_node.next_level_file_path = main_node.get_scene_string(main_node.next_world, main_node.next_level)
	LevelTransition.level_to_transition_to = main_node.next_level_file_path
