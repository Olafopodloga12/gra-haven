extends Node2D

func _ready() -> void:
	Music.stop()
	await get_tree().create_timer(6).timeout
	print("bleh")
	get_tree().change_scene_to_file("res://nicknameenter.tscn")
