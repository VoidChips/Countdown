extends Control

onready var newGameBtn := $Buttons/NewGameBtn
onready var continueBtn := $Buttons/ContinueBtn


func _ready():
	var settings := Config.get_settings()
	OS.window_fullscreen = settings["screen"]["is_fullscreen"]
	OS.window_size = settings["screen"]["window_size"]
	
	# reset music_pos before playing music so that it starts from the beginning
	Game.set_status("music_pos", 0.0)
	Game.set_status("curr_scene", "main_menu")
	Game.play_music($MusicPlayer)
	
	if Game.get_status()["is_new_game"]:
		continueBtn.disabled = true
	else:
		continueBtn.disabled = false
	
	$Buttons/NewGameBtn.grab_focus()
	


func _on_NewGameBtn_pressed():
	Game.reset(true)
	Game.set_status("prev_scene", "main_menu")
	get_tree().change_scene("res://scenes/Room1.tscn")


func _on_ContinueBtn_pressed():
	Game.reset(false)
	Game.set_status("prev_scene", "main_menu")
	get_tree().change_scene(Game.getCurrRoomPath())


func _on_OptionsBtn_pressed():
	Game.set_status("prev_scene", "main_menu")
	Game.set_status("music_pos", $MusicPlayer.get_playback_position())
	get_tree().change_scene("res://scenes/OptionsMenu.tscn")


func _on_QuitBtn_pressed():
	get_tree().quit()

