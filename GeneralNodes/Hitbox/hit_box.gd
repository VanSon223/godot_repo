class_name HitBox extends Area2D

signal damaged (dame : int )


func _ready() -> void:
	pass
	
	
func _process(_delta: float) -> void:
	pass
func _take_damaged(hurt_box : HurtBox ) -> void:
	damaged.emit(hurt_box)
	
