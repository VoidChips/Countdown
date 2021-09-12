extends Control

func _ready():
	$VBoxContainer/startBtn.grab_focus()


func _on_startBtn_pressed():
	get_tree().change_scene("res://scenes/Room1.tscn")


func _on_optionsBtn_pressed():
	pass # Replace with function body.


func _on_quitBtn_pressed():
	get_tree().quit()
