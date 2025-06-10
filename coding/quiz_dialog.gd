extends CanvasLayer

signal quiz_answered(correct: bool)

var current_question: Question

@onready var result_label = $PanelContainer/Panel/ResultLabel
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
		var btn = buttons[i]
		if i < question.choices.size():
			btn.set_answer_text(question.choices[i])
			btn.visible = true

			# Ngắt kết nối cũ (nếu có)
			for conn in btn.pressed.get_connections():
				btn.pressed.disconnect(conn.callable)

			# Kết nối tới hàm riêng với chỉ số câu trả lời
			btn.pressed.connect(_on_button_pressed.bind(i))
		else:
			btn.visible = false

func _on_button_pressed(index: int) -> void:
	var is_correct = (index == current_question.correct_index)
	print("Button pressed: index =", index, ", correct =", is_correct)

	emit_signal("quiz_answered", is_correct)

	if result_label:
		result_label.text = "*Đúng rồi!*" if is_correct else "*Sai rồi!*"
		result_label.visible = true

	await get_tree().create_timer(0.5).timeout
	queue_free()
