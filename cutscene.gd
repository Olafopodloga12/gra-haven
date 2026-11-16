extends Node2D

var current_slide = 0
var can_continue = false

@onready var slides = [$slide1, $slide2, $slide3, $slide4]

func _ready():
	for slide in slides:
		slide.modulate.a = 0

	show_slide()
	await get_tree().create_timer(0.3).timeout
	$Sadge.play()

func show_slide():
	var tween = create_tween()
	tween.tween_property(slides[current_slide], "modulate:a", 1.0, 1.0)

	await get_tree().create_timer(1.0).timeout
	can_continue = true

func _input(event):
	if not can_continue:
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			next_slide()

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
			next_slide()

func next_slide():
	if not can_continue:
		return

	can_continue = false

	if current_slide >= slides.size() - 1:
		await Transition.change_scene("res://gra.tscn")
		return

	current_slide += 1
	show_slide()
	if current_slide ==1:
		await get_tree().create_timer(0.3).timeout
		$AmAm.play()
	elif current_slide ==2:
		$Dream.play()
	elif current_slide ==3:
		await get_tree().create_timer(0.3).timeout
		$Piona.play()
