extends Sprite2D

@onready var reels = [
	$Reel1,
	$Reel2,
	$Reel3
]

var spinning = false

func _ready():
	randomize()

func spin():
	if spinning:
		return

	spinning = true

	for i in range(3):
		var reel = reels[i]

		var tween = create_tween()
		tween.tween_property(reel, "rotation_degrees", 360 * 5, 1.5 + i * 0.5)
		tween.tween_callback(func():
			reel.frame = randi_range(0, 5)
			reel.rotation_degrees = 0
		)

	await get_tree().create_timer(2.5).timeout
	spinning = false

func _on_spin_button_pressed():
	spin()
