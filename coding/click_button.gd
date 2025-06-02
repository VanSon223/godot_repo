class_name ClickButton extends Button

var item : ItemData


func set_answer_text(text: String) -> void:
	if $Label:
		$Label.text = text
