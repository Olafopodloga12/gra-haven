extends Sprite2D

@onready var spinners = [
	$Slot1,
	$Slot2,
	$Slot3
]

@onready var win_effect = $"../CanvasLayer"

var tween: Tween


func spin():
	$ElectricSlotMachine.play()

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
			2.0
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

	if check_win():
		got_win()


func check_win() -> bool:
	for spinner in spinners:
		var value = wrapf(
			spinner.material.get_shader_parameter("y_offset"),
			0.0,
			1.0
		)

		value = round(value / 0.25) * 0.25

		if value >= 1.0:
			value = 0.0

		# Dozwolona tylko pierwsza lub ostatnia ikonka
		if value != 0.0 and value != 0.75:
			return false

	return true


func got_win():
	$Yippe.play()
	print("WYGRANA!")


func _on_button_button_up() -> void:
	$on.hide()
	$off.show()


func _on_button_button_down() -> void:
	spin()
	$on.show()
	$off.hide()
