class_name TitleScreenOptions
extends VBoxContainer

@export var active := false

@export var can_exit := true

var selected_index := 0

@export var options: Array[Label] = []
@onready var title_screen_parent := owner

signal option_1_selected
signal option_2_selected
signal option_3_selected

signal closed

func vanilla_3485548658__process(_delta: float) -> void:
	if active:
		handle_inputs()

func vanilla_3485548658_open() -> void:
	title_screen_parent.active_options = self
	show()
	await get_tree().physics_frame
	active = true

func vanilla_3485548658_close() -> void:
	active = false
	hide()

func vanilla_3485548658_handle_inputs() -> void:
	if Global.multibind_action_just_pressed("ui_down"):
		selected_index += 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	if Global.multibind_action_just_pressed("ui_up"):
		selected_index -= 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	var amount := []
	for i in options:
		if i.visible:
			amount.append(i)
	selected_index = clamp(selected_index, 0, amount.size() - 1)
	if Global.multibind_action_just_pressed("ui_accept"):
		option_selected()
	elif can_exit and Global.multibind_action_just_pressed("ui_back"):
		close()
		closed.emit()

func vanilla_3485548658_option_selected() -> void:
	active = false
	emit_signal("option_" + str(selected_index + 1) + "_selected")


# ModLoader Hooks - The following code has been automatically added by the Godot Mod Loader.


func _process(_delta: float):
	if _ModLoaderHooks.any_mod_hooked:
		_ModLoaderHooks.call_hooks(vanilla_3485548658__process, [_delta], 1750131824)
	else:
		vanilla_3485548658__process(_delta)


func open():
	if _ModLoaderHooks.any_mod_hooked:
		await _ModLoaderHooks.call_hooks_async(vanilla_3485548658_open, [], 1454305636)
	else:
		await vanilla_3485548658_open()


func close():
	if _ModLoaderHooks.any_mod_hooked:
		_ModLoaderHooks.call_hooks(vanilla_3485548658_close, [], 733082088)
	else:
		vanilla_3485548658_close()


func handle_inputs():
	if _ModLoaderHooks.any_mod_hooked:
		_ModLoaderHooks.call_hooks(vanilla_3485548658_handle_inputs, [], 2809433216)
	else:
		vanilla_3485548658_handle_inputs()


func option_selected():
	if _ModLoaderHooks.any_mod_hooked:
		_ModLoaderHooks.call_hooks(vanilla_3485548658_option_selected, [], 1194857907)
	else:
		vanilla_3485548658_option_selected()
