class_name ItemEffectQuizBuff
extends ItemEffect

enum BuffType { ATTACK, DEFENSE }

@export var buff_type: BuffType = BuffType.ATTACK
@export var amount: int = 1
@export var audio: AudioStream

signal effect_finished(success: bool)
var parent_node: Node = null

func set_parent_node(parent: Node) -> void:
	parent_node = parent

func use() -> void:
	if parent_node == null:
		push_error("❌ ItemEffectQuizBuff: parent_node is not set!")
		return

	# Hiển thị câu hỏi và ẩn pause menu
	QuizHandler.ask_question(_on_quiz_answered)
	PauseMenu.hide_pause_menu()

func _on_quiz_answered(correct: bool) -> void:
	if correct:
		match buff_type:
			BuffType.ATTACK:
				PlayerManager.player.increase_attack_permanent(amount)
			BuffType.DEFENSE:
				PlayerManager.player.increase_defense_permanent(amount)
	else:
		print("❌ Sai rồi! Không được buff.")

	if audio:
		PauseMenu.play_audio(audio)

	PauseMenu.show_pause_menu()
	effect_finished.emit(correct)
