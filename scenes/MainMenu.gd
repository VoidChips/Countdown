extends Control

func _ready():
	OS.window_size = Config.window_size
	OS.window_fullscreen = Config.window_fullscreen
	
	$VBoxContainer/startBtn.grab_focus()

func _on_startBtn_pressed():
	get_tree().change_scene("res://scenes/Room1.tscn")

func _on_optionsBtn_pressed():
	pass # Replace with function body.

func _on_quitBtn_pressed():
	get_tree().quit()
