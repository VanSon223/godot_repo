# EnemyTracker.gd
extends Node

# Dictionary lưu quái đã bị tiêu diệt: { "map_name": ["enemy_id1", "enemy_id2"] }
var defeated_enemies: Dictionary = {}

# Đánh dấu một quái đã bị tiêu diệt
func mark_enemy_defeated(map_name: String, enemy_id: String) -> void:
	if not defeated_enemies.has(map_name):
		defeated_enemies[map_name] = []
	if enemy_id not in defeated_enemies[map_name]:
		defeated_enemies[map_name].append(enemy_id)

# Kiểm tra xem quái đã bị tiêu diệt chưa
func is_enemy_defeated(map_name: String, enemy_id: String) -> bool:
	return map_name in defeated_enemies and enemy_id in defeated_enemies[map_name]

# Hàm reset để dùng khi chơi lại game
func clear() -> void:
	defeated_enemies.clear()
