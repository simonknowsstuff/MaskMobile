extends Control

const PRESET_DIR: String = "res://scenes/presets/"
var PRESET_BTN: Resource = preload("res://prefabs/PresetButton.tscn")

func load_scenes(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.begins_with("preset_") and file_name.ends_with(".tscn"):
					var btn: Button = PRESET_BTN.instance()
					btn.connect("pressed", self, "_load_preset", [PRESET_DIR + file_name])
					btn.add_to_group("preset_btn")
					add_child(btn)
			file_name = dir.get_next()
	else:
		push_error("Could not access presets directory.")
	return

func _ready():
	load_scenes(PRESET_DIR)

func _load_preset(preset_path: String):
	get_tree().change_scene(preset_path)
	return
