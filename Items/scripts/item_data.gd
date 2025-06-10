class_name ItemData
extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture2D
@export var cost: int = 10

@export_category("Item Use Effects")
@export var effects: Array[ItemEffect]

var parent_node = null

func set_parent_node(parent) -> void:
	parent_node = parent

func use() -> bool:
	if effects.is_empty():
		return false

	for e in effects:
		if e:
			if e.has_method("set_parent_node"):
				e.set_parent_node(parent_node)
			e.use()
	return true
