extends Node2D
@onready var bar: HSlider = $HSlider
@onready var nick1 = $Nick1
@onready var nick2 = $Nick2
@onready var nick3 = $Nick3
@onready var nick4 = $Nick4
@onready var nick5 = $Nick5


func _ready():
	bar.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	bar.value = 25
	Music.play()
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT_IN)
	Highscore.leaderboard_received.connect(update_leaderboard)
	Highscore.get_leaderboard(5)
	
	tween.tween_property($Logo, "scale", Vector2(1, 1), 1.0)
	tween.tween_property($Logo, "scale", Vector2(1.3, 1.3), 1.0)

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(bar.value / 100))
	
func sound():
	var sounds = [
		load("res://eu.wav"),
		load("res://eu2.wav"),
		load("res://eu3.wav"),
		load("res://eu4.wav")
	]
	$Eu.stream = sounds.pick_random()
	$Eu.play()

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	sound()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gra.tscn")

func update_leaderboard(scores):
	var labels = [nick1, nick2, nick3, nick4, nick5]

	for i in range(5):
		if i < scores.size():
			labels[i].text = str(i + 1) + ". " + str(scores[i]["player_name"])
		else:
			labels[i].text = str(i + 1) + ". ---"
