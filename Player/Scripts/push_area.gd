extends Area2D

# Kết nối các tín hiệu trong _ready()
func _ready() -> void:
	# Kết nối tín hiệu với các hàm xử lý
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

# Hàm xử lý khi một đối tượng (body) vào vùng Area2D
func _on_body_entered(b : Node2D) -> void:
	if b is PushableStatue:
		b.push_direction = PlayerManager.player.direction  # Đặt hướng đẩy của PushableStatue theo hướng của player

# Hàm xử lý khi một đối tượng (body) rời khỏi vùng Area2D
func _on_body_exited(b : Node2D) -> void:
	if b is PushableStatue:
		b.push_direction = Vector2.ZERO  # Đặt hướng đẩy của PushableStatue thành không có hướng (Vector2.ZERO)
