class_name State_Idle extends State
@onready var walk : State = $"../Walk"
@onready var attack : State = $"../Attack"

func _ready() -> void:
	pass


#Chuyen gi se xay ra neu nguoi dung nhan ENTER cais State nay
func  Enter() -> void:
	player.UpdateAnimation("idle")
	pass
	
	
#Chuyen gi se xay ra neu nguoi dung nhan ENTER cais State nay
func  Exit() -> void:
	pass


func  Process(_detal : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null




func  Physics(_detal : float) -> State:
	return null


func  HandleInput(_event : InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("pick"):
		PlayerManager.interact_pressed.emit()
	return null
