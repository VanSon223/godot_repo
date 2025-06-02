class_name Question
extends Resource

@export var question_text: String
@export var choices: Array[String]
@export var correct_index: int
@export var language: String = ""  # Thêm biến language với giá trị mặc định là chuỗi rỗng

func _init(q: String = "", c: Array[String] = [], idx: int = 0, lang: String = "") -> void:
	question_text = q
	choices = c
	correct_index = idx
	language = lang
