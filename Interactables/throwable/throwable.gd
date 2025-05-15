class_name Throwable extends Area2D

var animation_player: AnimationPlayer
@onready var hurt_box: HurtBox = $HurtBox

func _ready() -> void:
	animation_player = find_child("AnimationPlayer")
	setup_hurt_box()

func setup_hurt_box() -> void:
	hurt_box.monitoring = true
	hurt_box.monitorable = true
	hurt_box.area_entered.connect(_on_hurtbox_area_entered)

	# Tự động sao chép CollisionShape2D từ vật thể chính vào HurtBox để phát hiện va chạm
	for c in get_children():
		if c is CollisionShape2D:
			var col := c.duplicate()
			hurt_box.add_child(col)
			col.debug_color = Color(1, 0, 0, 0.5)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		destroy()

func destroy() -> void:
	if animation_player:
		animation_player.play("destroy")
		await animation_player.animation_finished
	queue_free()
