extends Node

var questions: Array[Question] = []
var current_index := 0
func _ready():
	load_questions()

func load_questions():
	var file := FileAccess.open("res://coding/questions.json", FileAccess.READ)
	if file:
		var raw_text = file.get_as_text()
		var data = JSON.parse_string(raw_text)
		if data is Array:
			for q in data:
				if q.has("question_text") and q.has("choices") and q.has("correct_index") and q.has("language"):
					# Ép kiểu về Array[String]
					var choices: Array[String] = []
					for c in q["choices"]:
						choices.append(str(c))
					
					# Lưu đáp án đúng gốc
					var correct_answer := choices[int(q["correct_index"])]

					# Shuffle choices
					choices.shuffle()

					# Tìm correct_index mới sau khi shuffle
					var new_index := choices.find(correct_answer)

					# Tạo đối tượng Question đầy đủ
					var question := Question.new(
						str(q["question_text"]),
						choices,
						new_index,
						str(q["language"])
					)
					questions.append(question)
		else:
			push_error("Invalid JSON format in questions.json")
	else:
		push_error("Failed to open questions.json")


func get_random_question() -> Question:
	if questions.size() > 0:
		return questions[randi() % questions.size()]
	else:
		return Question.new("No question loaded", ["..."], 0)
func get_next_question() -> Question:  # ← thay cho get_random_question()
	if current_index < questions.size():
		var q = questions[current_index]
		current_index += 1
		return q
	else:
		return Question.new("No more questions", ["..."], 0)
