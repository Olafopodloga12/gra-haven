extends Sprite2D

@onready var spinners = [
	$Slot1,
	$Slot2,
	$Slot3
]

var tween: Tween

func spin():
	if tween:
		tween.kill()

	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

	for spinner in spinners:
		var current = wrapf(
			spinner.material.get_shader_parameter("y_offset"),
			0.0,
			1.0
		)

		var target = randi_range(0, 3) * 0.25
		var destination = current + randi_range(1, 3) + target

		tween.parallel().tween_method(
			func(value):
				spinner.material.set_shader_parameter("y_offset", value),
			current,
			destination,
			1.0
		)

	await tween.finished

	for spinner in spinners:
		var value = wrapf(
			spinner.material.get_shader_parameter("y_offset"),
			0.0,
			1.0
		)

		value = round(value / 0.25) * 0.25

		if value >= 1.0:
			value = 0.0

		spinner.material.set_shader_parameter(
			"y_offset",
			value
		)

func _on_button_pressed() -> void:
	spin()
