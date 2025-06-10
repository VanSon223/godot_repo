@tool
class_name TreasureChest extends Node2D

@export var item_data : ItemData : set = _set_item_data
@export var quantity : int = 1 : set = _set_quantity
@export var quiz: Question

var quiz_active := false
var is_open : bool = false

@onready var sprite: Sprite2D = $ItemSprite
@onready var label: Label = $ItemSprite/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D
@onready var is_open_data: PersistentDataHandler = $IsOpen



func _ready() -> void:
	_update_texture()
	_update_label()
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )
	is_open_data.data_loaded.connect( set_chest_state )
	set_chest_state()
	pass



func set_chest_state() -> void:
	is_open = is_open_data.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")



func player_interact() -> void:
	#if is_open == true:
		#return
	#is_open = true
	#is_open_data.set_value()
	#animation_player.play("open_chest")
	#if item_data and quantity > 0:
		#PlayerManager.INVENTORY_DATA.add_item( item_data, quantity )
	#else:
		#printerr("No Items in Chest!")
		#push_error("No Items in Chest! Chest Name: ", name)
		
	if is_open or quiz_active:
		return

	quiz_active = true

	# Lấy câu hỏi ngẫu nhiên
	var question := QuestionLoader.get_random_question()
	var dialog_scene := preload("res://coding/quiz_dialog.tscn")
	var dialog := dialog_scene.instantiate()
	dialog.set_question(question)

	# Kết nối signal quiz_answered với 2 hàm xử lý
	dialog.quiz_answered.connect(_on_quiz_answered)
	dialog.quiz_answered.connect(_on_quiz_closed)
	
	get_tree().current_scene.add_child(dialog)

func _on_quiz_answered(correct: bool) -> void:
	if correct:
		print(" Trả lời đúng! Nhận vật phẩm.")
		PlayerManager.INVENTORY_DATA.add_item(item_data, quantity)

		#  Chỉ mở rương nếu trả lời đúng
		is_open = true
		is_open_data.set_value()
		await get_tree().create_timer(1.0).timeout
		animation_player.play("open_chest")
		
	else:
		print(" Trả lời sai! Không có phần thưởng.")
		
func _on_quiz_closed(_correct: bool) -> void:
	# Khi dialog đóng hoặc trả lời xong, reset trạng thái
	quiz_active = false

func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture()
	pass


func _set_quantity( value : int ) -> void:
	quantity = value
	_update_label()
	pass


func _update_texture() -> void:
	if item_data and sprite:
		sprite.texture = item_data.texture


func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str( quantity )
