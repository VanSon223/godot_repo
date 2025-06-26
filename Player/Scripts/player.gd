extends CharacterBody2D
class_name Player

signal direction_changed(new_direction: Vector2)
signal player_damaged(hurt_box: HurtBox)
signal stats_changed

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]


var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

var invulnerable: bool = false
var hp: int = 6
var max_hp: int = 6

var level: int = 1
var xp: int = 0

var attack: int = 1:
	set(v):
		attack = v
		update_damage_values()
var defense: int = 1
var defense_bonus: int = 0


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box: HitBox = $HitBox
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var audio: AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D


# ======= READY =======
func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.damaged.connect(_take_damage)
	update_hp(99)
	update_damage_values()
	PlayerManager.player_leveled_up.connect(_on_player_leveled_up)
	PlayerManager.INVENTORY_DATA.equipment_changed.connect(_on_equipment_changed)
	#invulnerable = true
# ======= NHẬP INPUT =======
func _process(_delta):
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()

func _physics_process(_delta):
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		update_hp(-99)
		player_damaged.emit(%AttackHurtBox)

# ======= THAY ĐỔI HƯỚNG NHÂN VẬT =======
func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size())) % DIR_4.size()
	var new_dir = DIR_4[direction_id]

	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

# ======= CẬP NHẬT ANIMATION =======
func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())

func anim_direction() -> String:
	match cardinal_direction:
		Vector2.DOWN: return "down"
		Vector2.UP: return "up"
		_: return "side"

# ======= NHẬN SÁT THƯƠNG =======
func _take_damage(hurt_box: HurtBox) -> void:
	if invulnerable:
		return

	if hp > 0:
		var dmg: int = hurt_box.damage
		if dmg > 0:
			dmg = clampi(dmg - defense - defense_bonus, 1, dmg)
		update_hp(-dmg)
		player_damaged.emit(hurt_box)
		print("Damage:", hurt_box.damage, " | Defense:", defense, " | Bonus:", defense_bonus)
		print("Final Damage:", dmg)

# ======= CẬP NHẬT MÁU =======
func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)

# ======= TRẠNG THÁI MIỄN NHIỄM =======
func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true

# ======= HỒI SINH NHÂN VẬT =======
func revive_player() -> void:
	update_hp(99)
	state_machine.change_state($StateMachine/Idle)

# ======= CẬP NHẬT GIÁ TRỊ SÁT THƯƠNG =======
func update_damage_values() -> void:
	var damage_value: int = attack + PlayerManager.INVENTORY_DATA.get_attack_bonus()
	%AttackHurtBox.damage = damage_value
	# Nếu có thêm chiêu khác:
	# %ChargeSpinHurtBox.damage = damage_value * 2

# ======= LEVEL UP =======
func _on_player_leveled_up() -> void:
	effect_animation_player.play("level_up")
	update_hp(max_hp)

# ======= TRANG BỊ THAY ĐỔI =======
func _on_equipment_changed() -> void:
	update_damage_values()
	defense_bonus = PlayerManager.INVENTORY_DATA.get_defense_bonus()

# ======= ĐỔI SPRITE (ví dụ để thay skin) =======
func change_sprite() -> void:
	sprite.texture = load("res://path/to/sprite.png")
# ======= CẬP NHẬT HIỆU ỨNG =======
# Buff attack
func add_attack_buff(amount: int, duration: float) -> void:
	attack += amount
	update_damage_values()
	emit_signal("stats_changed") 
	print(" Attack buff +", amount) # Cập nhật UI
	await get_tree().create_timer(duration).timeout
	attack -= amount
	update_damage_values()
	emit_signal("stats_changed")  # Cập nhật UI khi buff kết thúc

# Buff defense
func add_defense_buff(amount: int, duration: float) -> void:
	defense += amount
	emit_signal("stats_changed")  #  Gửi tín hiệu cập nhật UI
	print(" Defense buff +", amount)

	await get_tree().create_timer(duration).timeout

	defense -= amount
	emit_signal("stats_changed")  #  Gửi lại khi hết hiệu lực
	print(" Defense buff ended")

# Tăng attack vĩnh viễn (không hết hạn)
func increase_attack_permanent(amount: int) -> void:
	attack += amount
	update_damage_values()
	emit_signal("stats_changed")
	print(" Attack buff + ", amount)

# Tăng defense vĩnh viễn (không hết hạn)
func increase_defense_permanent(amount: int) -> void:
	defense += amount
	emit_signal("stats_changed")
	print(" Defense buff + ", amount)
