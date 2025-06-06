@tool
class_name ItemDropper
extends Node2D

signal drop_collected

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

@export var item_data: ItemData : set = _set_item_data
@export var item_id: String = ""       # ✅ để dùng với ItemPickupTracker
@export var map_name: String = ""      # ✅ tên bản đồ đang sử dụng

var has_dropped: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var has_dropped_data: PersistentDataHandler = $PersistentDataHandler
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		_update_texture()
		return
	
	sprite.visible = false
	has_dropped_data.data_loaded.connect(_on_data_loaded)
	_on_data_loaded()

func drop_item() -> void:
	if has_dropped:
		return
	has_dropped = true

	# ✅ Nếu item đã từng được nhặt → không drop nữa
	if ItemPickupTracker.is_item_picked_up(map_name, item_id):
		return

	var drop = PICKUP.instantiate() as ItemPickup
	drop.item_data = item_data

	# ✅ Gán ID/map để ItemPickup tự huỷ nếu cần
	drop.item_id = item_id
	drop.map_name = map_name

	add_child(drop)

	drop.picked_up.connect(_on_drop_pickup)
	audio.play()

func _on_drop_pickup() -> void:
	drop_collected.emit()
	has_dropped_data.set_value()

func _on_data_loaded() -> void:
	has_dropped = has_dropped_data.value

func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()

func _update_texture() -> void:
	if Engine.is_editor_hint():
		if item_data and sprite:
			sprite.texture = item_data.texture
