class_name PLant extends Node2D

func  _ready() -> void:
	$HitBox.damaged.connect(_take_damaged)
	pass
	
func _take_damaged(_hurt_box: HurtBox) -> void:
	queue_free()
	pass
