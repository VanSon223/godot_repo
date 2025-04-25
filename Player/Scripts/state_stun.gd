class_name State_Stun extends State

# Các biến export để chỉnh sửa dễ dàng trong Inspector
@export var knockback_speed: float = 200.0     # Tốc độ đẩy lùi
@export var decelerate_speed: float = 10.0     # Tốc độ giảm vận tốc khi bị đẩy lùi
@export var stun_duration: float = 1.0         # Thời gian bị choáng

var hurt_box: HurtBox                         # Đối tượng gây sát thương (để biết hướng bị đánh)
var direction: Vector2                        # Hướng bị đẩy lùi

@onready var idle: State = $"../Idle"         # Trạng thái Idle (để chuyển về sau khi choáng)

# Kết nối sự kiện khi player bị sát thương
func init() -> void:
	player.player_damage.connect(_player_damaged)

# Khi bắt đầu trạng thái Stun
func Enter() -> void:
	player.UpdateAnimation("stun")                         # Phát animation choáng
	player.effect_animation_player.play("damaged")         # Hiệu ứng bị đánh (nhấp nháy, v.v.)

	direction = player.global_position.direction_to(hurt_box.global_position) # Tính hướng bị đánh
	player.velocity = direction * -knockback_speed        # Gán vận tốc đẩy ngược hướng
	player.SetDirection()                                 # Cập nhật hướng quay mặt của player

	player.make_invulnerable(stun_duration)               # Làm player bất tử trong lúc choáng

	await get_tree().create_timer(stun_duration).timeout  # Chờ hết thời gian choáng
	state_machine.ChangeState(idle)                       # Chuyển về trạng thái Idle

# Khi thoát khỏi trạng thái Stun
func Exit() -> void:
	pass

# Gọi mỗi frame, giảm dần vận tốc (dừng lại từ từ)
func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return null  # Không chuyển trạng thái tại đây

# Không xử lý vật lý trong trạng thái Stun
func Physics(_delta: float) -> State:
	return null

# Không xử lý input trong trạng thái Stun
func HandleInput(_event: InputEvent) -> State:
	return null

# Khi bị đánh, gọi hàm này để chuyển sang trạng thái Stun
func _player_damaged(_hurt_box: HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.ChangeState(self)
