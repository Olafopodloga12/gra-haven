extends CanvasLayer

@export var confetti_time := 4.0

@onready var confetti: ColorRect = $ColorRect
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var shader_mat: ShaderMaterial

func _ready():
	shader_mat = confetti.material as ShaderMaterial
	shader_mat.set_shader_parameter("resolution", Vector2.ZERO)


func play_win_effect():
	if shader_mat:
		shader_mat.set_shader_parameter(
			"resolution",
			get_viewport().get_visible_rect().size
		)

	if audio:
		audio.play()

	await get_tree().create_timer(confetti_time).timeout

	if shader_mat:
		shader_mat.set_shader_parameter(
			"resolution",
			Vector2.ZERO
		)
