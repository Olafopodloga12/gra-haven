extends Node2D

@export var fish_scene = preload("res://ryba.tscn")

# Granice spawnowania
@export var spawn_min := Vector2(200, 100)
@export var spawn_max := Vector2(1000, 500)

@export var spawn_amount := 10

func _ready():
	Music.play() 
	for i in range(spawn_amount):
		spawn_fish()

func spawn_fish():
	var fish = fish_scene.instantiate()

	fish.position = Vector2(
		randf_range(spawn_min.x, spawn_max.x),
		randf_range(spawn_min.y, spawn_max.y)
	)

	add_child(fish)


func _on_timer_timeout() -> void:
	for i in range(spawn_amount):
		spawn_fish()
	Highscore.send_score(Highscore.player_name,Score.score)
