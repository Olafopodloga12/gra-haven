extends CanvasLayer

@onready var rect: ColorRect = $ColorRect

func _ready():
	randomize()
	rect.material.set_shader_parameter("progress", 0.0)

func random_direction():
	var dirs = [
		0.0,          # lewo -> prawo
		PI / 2.0,     # góra -> dół
		PI,           # prawo -> lewo
		PI * 1.5      # dół -> góra
	]

	rect.material.set_shader_parameter("angle", dirs.pick_random())

func wipe_out(duration := 0.5):
	random_direction()

	var tween = create_tween()
	tween.tween_property(
		rect.material,
		"shader_parameter/progress",
		1.0,
		duration
	)

	await tween.finished

func wipe_in(duration := 0.5):
	var tween = create_tween()
	tween.tween_property(
		rect.material,
		"shader_parameter/progress",
		0.0,
		duration
	)

	await tween.finished

func change_scene(path: String, duration := 0.5):
	await wipe_out(duration)

	get_tree().change_scene_to_file(path)

	await get_tree().process_frame

	await wipe_in(duration)
