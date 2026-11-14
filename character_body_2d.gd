extends CharacterBody2D

const SPEED = 300.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var can_hit = false

func _ready() -> void:
	$CollisionShape2D.disabled = true
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "global_rotation", -0.5, 0.15)

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	global_position = Vector2(67, mouse_pos.y)

	if Input.is_action_just_pressed("click"):
		var tween = create_tween()
		can_hit = true
		$CollisionShape2D.disabled = false
		tween.tween_property(sprite, "global_rotation", 0.5, 0.15)
		await get_tree().create_timer(0.2).timeout
		var tweena = create_tween()
		tweena.tween_property(sprite, "global_rotation", -0.5, 0.15)
		can_hit = false
		$CollisionShape2D.disabled = true
