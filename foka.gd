extends CharacterBody2D

var speed = 10
@onready var label: Label = $Label
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var min_speed = 3
var is_dead = false
var normal_scale = Vector2.ONE
var is_tweening = false
var rating_tween: Tween
var label_start_position: Vector2

func _ready():
	label_start_position = label.position
	velocity = Vector2(-speed, 0)
	label.text = ""

func _physics_process(delta: float) -> void:
	var stretch = clamp(speed / 20.0, 1.0, 1.5)
	sprite.scale = Vector2(stretch, 1.0 / stretch)
	
	var col := move_and_collide(velocity)

	# Obracanie piłeczki
	sprite.rotation += velocity.x * delta * 0.05

	if col:
		sound(false)
		var normal = col.get_normal()
		var collider = col.get_collider()

		if collider.is_in_group("paletka"):
			if collider.can_hit:
				var hit_position = col.get_position()
				var paddle_center = collider.global_position

				var offset = abs(hit_position.y - paddle_center.y)
				var max_offset = collider.get_node("CollisionShape2D").shape.size.y / 2

				var accuracy = clamp(1.0 - offset / max_offset, 0.0, 1.0)

				var bonus = 0.0
				var rating = ""

				if accuracy >= 0.9:
					bonus = 1
					rating = "PERFECT!"
					label.add_theme_color_override("font_color", Color("f2c291"))
					label.add_theme_color_override("font_outline_color", Color("cc785c"))
				elif accuracy >= 0.7:
					bonus = 0.5
					rating = "GREAT!"
					label.add_theme_color_override("font_color", Color("801337"))
					label.add_theme_color_override("font_outline_color", Color("590034"))
				elif accuracy >= 0.4:
					bonus = 0.4
					rating = "GOOD!"
					label.add_theme_color_override("font_color", Color("6c32a6"))
					label.add_theme_color_override("font_outline_color", Color("2e1380"))

				else:
					bonus = -0.2
					rating = "BAD!"
					label.add_theme_color_override("font_color", Color("000059"))
					label.add_theme_color_override("font_outline_color", Color("000d33"))

				speed *= (1.0 + bonus)

				var angle = ((hit_position.y - paddle_center.y) / max_offset) * 60.0
				velocity = normal.rotated(deg_to_rad(angle)) * speed

				show_rating(rating)
				collider.can_hit = false

		else:
			velocity = velocity.bounce(normal)
			squash()
			if collider.is_in_group("siatka"):
				speed *= 1.1
			else:
				speed *= 0.9
			velocity = velocity.normalized() * speed
	if speed <= min_speed and not is_dead:
		is_dead = true
		die_animation()
		
	if speed >= 21:
		$CPUParticles2D.emitting = true
		sprite.play("fast")
	elif speed <= 4.5:
		$CPUParticles2D.emitting = false
		sprite.play("slow")
	else:
		$CPUParticles2D.emitting = false
		sprite.play("normal")



func die_animation():
	speed = 0
	print("smierc")
	

	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	tween.set_parallel(true)
	tween.tween_property(self, "velocity", Vector2.ZERO, 1)
	tween.tween_property(sprite, "global_rotation", 3, 0.5)
	tween.tween_property(sprite, "position", Vector2(0, 1000), 3)
	await get_tree().create_timer(1).timeout
	sound(true)
	await get_tree().create_timer(1).timeout
	Highscore.send_score(Highscore.player_name,Score.score)
	await Transition.change_scene("res://menu.tscn")
	
func squash():
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.3, 0.7), 0.08)
	tween.tween_property(sprite, "scale", normal_scale, 0.2)
func sound(slow:bool):
	var sounds = [
		load("res://eu.wav"),
		load("res://eu2.wav"),
		load("res://eu3.wav"),
		load("res://eu4.wav")
	]
	$Eu.stream = sounds.pick_random()
	if slow:
		$Eu.pitch_scale = 1.2
	else:
		$Eu.pitch_scale = 1
	$Eu.play()

func show_rating(rating: String):
	label.position = label_start_position
	if rating_tween and rating_tween.is_running():
		rating_tween.kill()

	label.text = rating
	label.modulate.a = 1
	label.scale = Vector2.ZERO
	label.rotation = 0

	var tween = create_tween()
	rating_tween = tween

	# Wyskakiwanie
	tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2.ONE, 0.15)

	# Taniec i unoszenie
	tween.set_parallel()
	tween.tween_property(label, "rotation", deg_to_rad(12), 0.2)
	tween.tween_property(label, "position:y", label.position.y - 25, 0.7)

	tween.chain().tween_property(label, "rotation", deg_to_rad(-12), 0.2)
	tween.tween_property(label, "rotation", 0.0, 0.2)

	# Znikanie
	tween.tween_interval(0.3)
	tween.tween_property(label, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func(): label.text = "")
