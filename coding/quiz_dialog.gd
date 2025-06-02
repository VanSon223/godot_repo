extends CanvasLayer

signal quiz_answered(correct: bool)

var current_question: Question

@onready var label = $PanelContainer/Panel/Label
@onready var lang_label = $PanelContainer/Panel/LanguageLabel
@onready var buttons := [
	$PanelContainer/Panel/VBoxContainer/ClickButton,
	$PanelContainer/Panel/VBoxContainer/ClickButton2,
	$PanelContainer/Panel/VBoxContainer/ClickButton3,
	$PanelContainer/Panel/VBoxContainer/ClickButton4
]

var ready_called := false
var pending_question: Question = null

func _ready() -> void:
	ready_called = true
	if pending_question != null:
		set_question(pending_question)
		pending_question = null

func set_question(question: Question) -> void:
	if !ready_called:
		pending_question = question
		return

	if label == null:
		push_error("Label node không tồn tại! Kiểm tra lại đường dẫn $Panel/Label.")
		return

	current_question = question
	label.text = question.question_text

	# Hiển thị ngôn ngữ câu hỏi
	if lang_label:
		lang_label.text = "Language: " + question.language
	else:
		push_error("Không tìm thấy Label để hiển thị ngôn ngữ ở $Panel/LanguageLabel")

	for i in range(buttons.size()):
		if i < question.choices.size():
			var btn = buttons[i]
			btn.set_answer_text(question.choices[i])
			btn.visible = true

			# Ngắt tất cả kết nối cũ
			for conn in btn.pressed.get_connections():
				btn.pressed.disconnect(conn.callable)

			var index := i
			btn.pressed.connect(func():
				var is_correct = (index == question.correct_index)
				emit_signal("quiz_answered", is_correct)
				queue_free()
			)
		else:
			buttons[i].visible = false
