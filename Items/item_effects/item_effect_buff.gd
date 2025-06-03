# ItemEffectBuff.gd
class_name ItemEffectBuff
extends ItemEffect

enum BuffType { ATTACK, DEFENSE }

@export var buff_type: BuffType = BuffType.ATTACK
@export var amount: int = 1
@export var duration: float = 10.0 # giây
@export var audio: AudioStream

func use() -> void:
	match buff_type:
		BuffType.ATTACK:
			PlayerManager.player.add_attack_buff(amount, duration)
		BuffType.DEFENSE:
			PlayerManager.player.add_defense_buff(amount, duration)
	
	if audio:
		PauseMenu.play_audio(audio)
