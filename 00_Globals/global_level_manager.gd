extends Node

signal  level_loaded_started
signal  level_loaded
signal tilemap_bounds_changed ( bounds : Array[Vector2])
var current_tile_map_bounds : Array [Vector2]
var target_transition :String	
var position_offset : Vector2



func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()
	
func ChangeTilemapBounds(bounds :Array [Vector2]) -> void:
	current_tile_map_bounds = bounds
	tilemap_bounds_changed.emit(bounds)
	
var is_loading: bool = false
func load_new_level(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:
	
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fate_out() #Level Transition
	
	level_loaded_started.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	
	await SceneTransition.fate_in() #Level Transition	
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	pass
