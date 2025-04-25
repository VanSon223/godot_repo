extends CanvasLayer

@onready var animation_player : AnimationPlayer = $Control/AnimationPlayer


func fate_out() -> bool:
	animation_player.play("fate_out")
	await animation_player.animation_finished
	return true
func fate_in() -> bool:
	animation_player.play("fate_in")
	await animation_player.animation_finished
	return true
