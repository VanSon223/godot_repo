@tool
class_name ItemPickup
extends CharacterBody2D

@export var item_data: ItemData : set = _set_item_data
@export var item_id: String = ""
@export var map_name: String = ""

signal picked_up

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	if Engine.is_editor_hint():
		_update_texture()
		return

	# 🔥 Kiểm tra nếu item đã nhặt → huỷ luôn
	if ItemPickupTracker.is_item_picked_up(map_name, item_id):
		queue_free()
		return

	_update_texture()
	area_2d.body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	velocity -= velocity * delta * 4


func _on_body_entered(body) -> void:
	if body is Player and item_data:
		if PlayerManager.INVENTORY_DATA.add_item(item_data):
			item_picked_up()


func item_picked_up() -> void:
	# ✅ Đánh dấu item đã được nhặt
	ItemPickupTracker.mark_item_picked_up(map_name, item_id)

	area_2d.body_entered.disconnect(_on_body_entered)
	audio_stream_player_2d.play()
	visible = false
	picked_up.emit()
	await audio_stream_player_2d.finished
	queue_free()


func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture


func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()
