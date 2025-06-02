extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = "",
	player = {
		level = 1,
		xp = 0,
		hp = 1,
		max_hp = 1,
		attack = 1,
		defense = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],  # Danh sách các giá trị persistent (ví dụ enemy đã chết)
	quests = [
		# Ví dụ cấu trúc quest
		# { title = "not found", is_complete = false, completed_steps = [''] }
	],
}

func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_data()
	update_quest_data()
	
	var file = FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	file.close()
	
	game_saved.emit()

func get_save_file() -> FileAccess:
	if not FileAccess.file_exists(SAVE_PATH + "save.sav"):
		return null
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)

func load_game() -> void:
	var file = get_save_file()
	if file == null:
		push_error("Save file not found!")
		return
	
	var json = JSON.new()
	var err = json.parse(file.get_line())
	file.close()
	
	if err != OK:
		push_error("Failed to parse save file!")
		return
	
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	# Load scene
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await LevelManager.level_load_started
	
	# Set player data
	PlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	
	var p : Player = PlayerManager.player
	p.level = current_save.player.level
	p.xp = current_save.player.xp
	p.attack = current_save.player.attack
	p.defense = current_save.player.defense
	
	# Load items và quests
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	QuestManager.current_quests = current_save.quests
	
	await LevelManager.level_loaded
	
	game_loaded.emit()

func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	current_save.player.level = p.level
	current_save.player.xp = p.xp
	current_save.player.attack = p.attack
	current_save.player.defense = p.defense

func update_scene_path() -> void:
	var scene_path : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			scene_path = c.scene_file_path
	current_save.scene_path = scene_path

func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()

func update_quest_data() -> void:
	current_save.quests = QuestManager.current_quests

# Thêm giá trị persistent (nếu chưa có)
func add_persistent_value(value : String) -> void:
	if not check_persistent_value(value):
		current_save.persistence.append(value)

# Xóa giá trị persistent (nếu có)
func remove_persistent_value(value : String) -> void:
	var p = current_save.persistence
	p.erase(value)

# Kiểm tra giá trị persistent có tồn tại không
func check_persistent_value(value : String) -> bool:
	return current_save.persistence.has(value)
