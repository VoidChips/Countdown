extends Control

func _ready():
	var settings := Config.get_settings()
	OS.window_fullscreen = settings["screen"]["is_fullscreen"]
	OS.window_size = settings["screen"]["window_size"]
	
	$VBoxContainer/StartBtn.grab_focus()


func _on_StartBtn_pressed():
	get_tree().change_scene("res://scenes/Room1.tscn")


func _on_OptionsBtn_pressed():
	get_tree().change_scene("res://scenes/OptionsMenu.tscn")


func _on_QuitBtn_pressed():
	get_tree().quit()
