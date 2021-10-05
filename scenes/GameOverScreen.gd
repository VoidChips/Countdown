extends Control


func _ready():
	$Menu/Buttons/RetryBtn.grab_focus()


func _on_RetryBtn_pressed():
	get_tree().change_scene(Game.get_status()["current_room"])


func _on_MainMenuBtn_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
