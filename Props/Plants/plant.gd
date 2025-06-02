class_name Plant
extends Node2D

@export var id: String = ""
@export var map_name: String = ""

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# 👇 Kiểm tra nếu cây này đã bị phá từ trước, thì xoá luôn
	if EnemyTracker.is_enemy_defeated(map_name, id):
		queue_free()
		return

	$HitBox.damaged.connect(take_damage)

func take_damage(_damage: HurtBox) -> void:
	# 👇 Lưu lại trạng thái cây đã bị phá
	EnemyTracker.mark_enemy_defeated(map_name, id)

	animation_player.play("destroy")
	await animation_player.animation_finished
	queue_free()
	pass
