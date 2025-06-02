extends Node

var picked_up_items := {}  # Dạng: { "map_name": { "item_id_01": true, "item_id_02": true } }

func is_item_picked_up(map_name: String, item_id: String) -> bool:
	return picked_up_items.get(map_name, {}).get(item_id, false)

func mark_item_picked_up(map_name: String, item_id: String) -> void:
	if not picked_up_items.has(map_name):
		picked_up_items[map_name] = {}
	picked_up_items[map_name][item_id] = true
