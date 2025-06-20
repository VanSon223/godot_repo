class_name Enemy
extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_dameged(hurt_box: HurtBox)
signal enemy_destroy(hurt_box: HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp: int = 3
@export var xp_reward : int = 1

# 👇 GÁN ID và tên bản đồ từ editor
@export var enemy_id: String = ""
@export var map_name: String = ""

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

var player: Player
var invulnerble: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var state_machein: EnemyStateMachine = $EnemyStateMachine

func _ready() -> void:
	#  Kiểm tra nếu đã bị giết thì xóa luôn
	if EnemyTracker.is_enemy_defeated(map_name, enemy_id):
		queue_free()
		return

	add_to_group("enemies")
	state_machein.initialize(self)
	player = PlayerManager.player
	hit_box.damaged.connect(_take_damaged)

func _physics_process(_delta: float) -> void:
	set_direction(direction)
	move_and_slide()

func set_direction(_new_direction: Vector2) -> bool:
	if _new_direction == Vector2.ZERO:
		return false

	var new_dir: Vector2
	if abs(_new_direction.x) > abs(_new_direction.y):
		new_dir = Vector2.RIGHT if _new_direction.x > 0 else Vector2.LEFT
	else:
		new_dir = Vector2.DOWN if _new_direction.y > 0 else Vector2.UP

	if new_dir == cardinal_direction:
		return false

	cardinal_direction = new_dir
	direction_changed.emit(new_dir)

	if cardinal_direction == Vector2.LEFT:
		sprite.flip_h = true
	elif cardinal_direction == Vector2.RIGHT:
		sprite.flip_h = false

	return true

func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damaged(hurt_box: HurtBox) -> void:
	if invulnerble:
		return

	hp -= hurt_box.damage
	PlayerManager.shake_camera()
	EffectManager.damage_text(hurt_box.damage, global_position + Vector2(0, -36))

	if hp > 0:
		enemy_dameged.emit(hurt_box)
	else:
		#  Lưu trạng thái đã chết
		EnemyTracker.mark_enemy_defeated(map_name, enemy_id)
		enemy_destroy.emit(hurt_box)
		#queue_free()
