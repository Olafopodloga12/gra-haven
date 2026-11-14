extends LineEdit

func _ready():
	text_changed.connect(check_name)

func check_name(new_text):
	var regex = RegEx.new()
	regex.compile("[^a-zA-Z0-9_]")

	text = regex.sub(new_text, "", true)

	Global.player_name = text
