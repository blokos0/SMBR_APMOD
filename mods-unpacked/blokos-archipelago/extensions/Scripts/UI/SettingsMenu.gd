extends "res://Scripts/UI/SettingsMenu.gd"
func _ready() -> void:
	var ap_tab: VBoxContainer = load("res://mods-unpacked/blokos-archipelago/scenes/APTab.tscn").instantiate()
	$PanelContainer/MarginContainer/VBoxContainer.add_child(ap_tab)
	containers.append(ap_tab)
