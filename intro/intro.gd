extends Node2D

func _ready() -> void:
	Music.stop()
	await get_tree().create_timer(6).timeout
	print("bleh")
	await Transition.change_scene("res://nicknameenter.tscn")
