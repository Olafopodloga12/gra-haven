extends Node2D

@export var fish_scene = preload("res://ryba.tscn")
@export var star_scene = preload("res://star.tscn")

# Granice spawnowania
@export var spawn_min := Vector2(200, 100)
@export var spawn_max := Vector2(1000, 500)

@export var spawn_amount := 10

func _ready():
	Score.score = -1
	Score.add()

	for i in range(spawn_amount):
		spawn_fish()

func spawn_fish():
	var scene

	# 1 na 20 szans na star.tscn
	if randi_range(1, 20) == 1:
		scene = star_scene
	else:
		scene = fish_scene

	var fish = scene.instantiate()

	fish.position = Vector2(
		randf_range(spawn_min.x, spawn_max.x),
		randf_range(spawn_min.y, spawn_max.y)
	)

	add_child(fish)

func _on_timer_timeout() -> void:
	for fih in get_tree().get_nodes_in_group("fih"):
		fih.spierdalaj()

	for i in range(spawn_amount):
		spawn_fish()

	Highscore.send_score(Highscore.player_name, Score.score)
