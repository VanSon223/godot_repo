class_name Player extends CharacterBody2D
var cardinal_direction : Vector2 = Vector2.DOWN

var invulnarble :bool = false
var hp : int = 6
var max_hp : int = 6
var direction : Vector2 = Vector2.ZERO
const DIR_4 =[Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var hit_box : HitBox = $HitBox
@onready var audio : AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D
signal  DirectionChaged(new_direction : Vector2)
signal player_damage( hurt_box : HurtBox )


func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.damaged.connect(_take_damaged)
	update_hp(99)
	pass
func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	).normalized()
	direction = direction.normalized()
	pass
	
func  _physics_process( _delta ) -> void:
	move_and_slide()
	
	
	
func  SetDirection() -> bool :
	
	if direction == Vector2.ZERO:
		return false
		
	var direction_id : int = int (round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_dir =  DIR_4[direction_id]
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	DirectionChaged.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

	
func  UpdateAnimation(state : String ) -> void :
	animation_player.play(state + "_" + AnimaDirection())
	pass
	
func  AnimaDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	return "side"
func _take_damaged( hurt_box : HurtBox) -> void:
	if invulnarble == true:
		return
	update_hp( - hurt_box.dame)
	if hp > 0:
		player_damage.emit(hurt_box)
	else:
		player_damage.emit(hurt_box)
		update_hp(99)
	pass
	
func update_hp( _delta : int ) -> void:
	hp = clampi(hp + _delta, 0 , max_hp)
	PlayerHud.update_hp(hp,max_hp)
	pass
	
func  make_invulnerable(_duration : float = 1.0)-> void:
	invulnarble = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	invulnarble = false
	hit_box.monitoring = true
	pass
