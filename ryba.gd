extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dead = false

func _ready():
	$Sound.pitch_scale = randf_range(1,2)
	$Sound2.pitch_scale = randf_range(0.7,1.3)
	sprite.modulate = Color(randf(), randf(), randf())

	var target_position = position
	position.y += 100

	var tween = create_tween()
	tween.tween_property(self, "position", target_position, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_body_entered(body: Node2D):
	if dead:
		return
	$Sound.play()
	$Sound2.play()
	dead = true
	Score.add()
	sprite.play("dead")

	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 500, 0.7).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
