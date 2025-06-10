extends Node

var quiz_dialog_scene = preload("res://coding/quiz_dialog.tscn")

func ask_question(callback: Callable) -> void:
	var question = QuestionLoader.get_random_question()
	var dialog = quiz_dialog_scene.instantiate()
	dialog.set_question(question)

	# Truyền kết quả trả lời về callback
	dialog.quiz_answered.connect(callback)
	get_tree().current_scene.add_child(dialog)
