extends Node
func run_player_check(chain: ModLoaderHookChain, player: Player) -> void:
	var main_node: Object = chain.reference_object as WarpPipeArea
	print(main_node.world_num)
	if main_node.get_node("/root/AP").unlocked_worlds["SMB"].has(main_node.world_num):
		chain.execute_next_async([player])
