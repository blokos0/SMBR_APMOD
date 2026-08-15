extends Node
func handle_inputs(chain: ModLoaderHookChain) -> void:
	var main_node: Object = chain.reference_object as TitleScreenOptions
	chain.execute_next()
	if main_node.name == "StoryOptions":
		main_node.selected_index = 1
		main_node.get_child(0).modulate = Color.DIM_GRAY
