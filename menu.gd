extends Node2D
@onready var bar: HSlider = $HSlider


func _ready():
	bar.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	bar.value = 50
	Music.play()

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
