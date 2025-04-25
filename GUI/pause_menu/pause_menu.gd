extends CanvasLayer
signal shown
signal  hidden

@onready var button_save : Button = $Control/HBoxContainer/Button_Save
@onready var audio_stream_player : AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var button_load : Button = $Control/HBoxContainer/Button_Load
@onready var item_description : Label = $Control/ItemDescription
var is_pause : bool = false


func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(on_save_pressed)
	button_load.pressed.connect(on_load_pressed)
	pass
	
	
func  _unhandled_input(event : InputEvent)-> void:
	if event.is_action_pressed("pause"):
		if is_pause == false:
			show_pause_menu()
		else :
			hide_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu()  -> void:
	get_tree().paused = true
	visible = true
	is_pause = true
	shown.emit()
	
	
func hide_pause_menu()-> void:
	get_tree().paused = false
	visible = false
	is_pause = false
	hidden.emit()
	
func on_save_pressed()-> void:
	if is_pause == false:
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass
	
	
	
func on_load_pressed()-> void:
	if is_pause == false:
		return
	SaveManager.load_game()
	await LevelManager.level_loaded_started
	hide_pause_menu()
	pass
func  update_item_des(new_text : String )-> void:
	item_description.text = new_text


func play_audio( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
