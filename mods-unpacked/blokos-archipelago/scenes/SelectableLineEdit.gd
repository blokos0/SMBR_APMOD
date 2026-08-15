extends HBoxContainer

#@export var option_key := ""
#@export var title := ""
#@export var value_descs: Array[String] = []
#@export var values := []
#@export var settings_category := "video"
@export var selected := false
@export var placeholder := "Meow"
@export var setting := "address"

signal value_changed(new_value)

func _ready() -> void:
	%LineEdit.placeholder_text = placeholder
	await get_tree().process_frame

func _process(_delta: float) -> void:
	if selected:
		handle_inputs()
	else:
		%LineEdit.release_focus()
	$Cursor.modulate.a = int(selected)
	$AutoScrollContainer.is_focused = selected
	#%Title.text = tr(title) + ":"
	#%Value.text = tr(str(values[selected_index]))
	#%LeftArrow.modulate.a = int(selected and selected_index > 0)
	#%RightArrow.modulate.a = int(selected and selected_index < values.size() - 1)

func set_selected(active := false) -> void:
	selected = active

func handle_inputs() -> void:
	%LineEdit.edit()
	%LineEdit.grab_focus()
	%LineEdit.text_submitted.emit()
