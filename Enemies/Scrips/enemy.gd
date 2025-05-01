class_name Enemy extends CharacterBody2D

# Các tín hiệu để phát hiện thay đổi hướng, bị sát thương hoặc bị tiêu diệt
signal direction_changed(new_direction: Vector2)
signal enemy_dameged(hurt_box: HurtBox)
signal enemy_destroy(hurt_box: HurtBox)

# Hướng cơ bản theo 4 chiều
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

# Máu của enemy
@export var hp: int = 3

# Hướng chính hiện tại (cardinal_direction) và hướng đang di chuyển
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

# Tham chiếu đến người chơi và trạng thái miễn nhiễm sát thương
var player: Player
var invulnerble: bool = false

# Các node con tham chiếu
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var state_machein: EnemyStateMachine = $EnemyStateMachine

# Gọi khi enemy sẵn sàng
func _ready() -> void:
	state_machein.initialize(self)
	player = PlayerManager.player
	hit_box.damaged.connect(_take_damaged)  # Kết nối sự kiện khi bị trúng đòn

# Hàm vật lý chạy mỗi frame
func _physics_process(_delta: float) -> void:
	set_direction(direction)  # ✅ Cập nhật hướng dựa trên vector direction hiện tại
	move_and_slide()  # Di chuyển enemy
# Hàm xác định hướng di chuyển và phát tín hiệu nếu có thay đổi
func set_direction(_new_direction: Vector2) -> bool:
	if _new_direction == Vector2.ZERO:
		return false  # Không đổi hướng nếu đứng yên

	# Tính hướng mới dựa trên trục X hoặc Y lớn hơn
	var new_dir: Vector2
	if abs(_new_direction.x) > abs(_new_direction.y):
		new_dir = Vector2.RIGHT if _new_direction.x > 0 else Vector2.LEFT
	else:
		new_dir = Vector2.DOWN if _new_direction.y > 0 else Vector2.UP

	if new_dir == cardinal_direction:
		return false  # Nếu hướng không thay đổi, không làm gì thêm

	cardinal_direction = new_dir
	direction_changed.emit(new_dir)  # Phát tín hiệu hướng đã đổi

	# ✅ Lật mặt sprite nếu đi trái hoặc phải
	if cardinal_direction == Vector2.LEFT:
		sprite.flip_h = true
	elif cardinal_direction == Vector2.RIGHT:
		sprite.flip_h = false

	return true

# Phát animation theo trạng thái và hướng
func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())

# Trả về chuỗi hướng hiện tại ("down", "up", "side")
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"  # Bao gồm trái và phải

# Xử lý khi enemy bị nhận sát thương
func _take_damaged(hurt_box: HurtBox) -> void:
	if invulnerble:
		return  # Nếu đang miễn nhiễm thì bỏ qua

	hp -= hurt_box.dame  # Trừ máu

	if hp > 0:
		enemy_dameged.emit(hurt_box)  # Nếu còn sống, phát tín hiệu bị trúng đòn
	else:
		enemy_destroy.emit(hurt_box)  # Nếu hết máu, phát tín hiệu bị tiêu diệt
