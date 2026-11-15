extends LineEdit

func _ready():
	text_changed.connect(check_name)
	AudioServer.set_bus_volume_db(0, linear_to_db(0.25))

func check_name(new_text):
	var regex = RegEx.new()
	regex.compile("[^a-zA-Z0-9_]")

	var clean_text = regex.sub(new_text, "", true)

	if clean_text != new_text:
		var cursor = caret_column - (new_text.length() - clean_text.length())
		text = clean_text
		caret_column = max(0, cursor)
	Highscore.player_name = text
func _process(delta: float) -> void:
	$"../Button".disabled = text.is_empty()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
