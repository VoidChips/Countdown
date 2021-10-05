extends Control

onready var newGameBtn := $Buttons/NewGameBtn
onready var continueBtn := $Buttons/ContinueBtn


func _ready():
	var settings := Config.get_settings()
	OS.window_fullscreen = settings["screen"]["is_fullscreen"]
	OS.window_size = settings["screen"]["window_size"]
	
	if Game.get_status()["is_new_game"]:
		continueBtn.disabled = true
	else:
		continueBtn.disabled = false
	
	$Buttons/NewGameBtn.grab_focus()
	


func _on_NewGameBtn_pressed():
	get_tree().change_scene("res://scenes/Room1.tscn")


func _on_ContinueBtn_pressed():
	get_tree().change_scene(Game.get_status()["current_room"])


func _on_OptionsBtn_pressed():
	get_tree().change_scene("res://scenes/OptionsMenu.tscn")


func _on_QuitBtn_pressed():
	get_tree().quit()

