extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.stop()
	$Label.hide()
	$AnimationPlayer.play("new_animation")
	await get_tree().create_timer(1.5).timeout
	$AmAm.play()
	await get_tree().create_timer(0.75).timeout
	$Sadge.play()
	await get_tree().create_timer(1.75).timeout
	$Label.text = "that's my chance"
	$Label.show()
	$ThatsMyChance.play()
	$AnimationPlayer.play("new_animation_2")
	await get_tree().create_timer(1).timeout
	$Dream.play()
	await get_tree().create_timer(1.4667).timeout
	$Label.hide()
	$AnimationPlayer.play("new_animation_3")
	await get_tree().create_timer(1.5).timeout
	$Wah.play()
	await get_tree().create_timer(2.5667).timeout
	$Dream.pitch_scale = 3
	$Dream.play()
	await get_tree().create_timer(1).timeout
	$Wah.stop()
	await get_tree().create_timer(0.5).timeout
	$Label.text = "I'll Help you"
	$Label.show()
	$IWillHelpYou.play()
	$AnimationPlayer.play("new_animation_4")
	await get_tree().create_timer(4).timeout
	$Label.hide()
	$Piona.play()
	await get_tree().create_timer(3).timeout
	await Transition.change_scene("res://gra.tscn")
