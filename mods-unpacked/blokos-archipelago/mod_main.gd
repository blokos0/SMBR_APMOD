extends Node

const MOD_DIR := "blokos-archipelago"
const LOG_NAME := "blokos-archipelago:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
	install_script_extensions()
	install_script_hook_files()

func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/UI/SettingsMenu.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/UI/WorldSelect.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/UI/LevelSelect.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Classes/Singletons/SaveManager.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Parts/EndFlagpole.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Parts/CastleBridge.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Parts/GameOver.gd"))

func install_script_hook_files() -> void:
	var hooks_dir_path: String = mod_dir_path.path_join("hooks")
	ModLoaderMod.install_script_hooks("res://Scripts/UI/TitleScreenOptions.gd", hooks_dir_path.path_join("Scripts/UI/TitleScreenOptions.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Classes/LevelClass.gd", hooks_dir_path.path_join("Scripts/Classes/LevelClass.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Parts/WarpPipeArea.gd", hooks_dir_path.path_join("Scripts/Parts/WarpPipeArea.hooks.gd"))

func _ready() -> void:
	$/root.add_child.call_deferred(load("res://mods-unpacked/blokos-archipelago/scenes/AP.tscn").instantiate())
	Global.game_beaten = true
	SaveManager.visited_levels = "0000000000000000000000000000000000000000000000000000"
