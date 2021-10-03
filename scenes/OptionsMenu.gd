extends Control

onready var resolution_btn := $Options/ResolutionOption/ResolutionBtn
onready var fullscreen_checkbox := $Options/FullscreenOption/FullscreenCheckBox
onready var confirm_btn := $Options/ConfirmBtn
onready var options := $Options
onready var resolution := Config.window_size
onready var is_fullscreen := Config.is_fullscreen

func _ready():
	options.alignment = BoxContainer.ALIGN_CENTER
	
	resolution_btn.add_item("640x360")
	resolution_btn.add_item("1280x720")
	resolution_btn.add_item("1920x1080")
	resolution_btn.add_item("2560x1440")
	resolution_btn.add_item("3840x2160")
	
	disable_invalid_resolutions()
	select_current_resolution()
	confirm_btn.disabled = true
	
	print("resolution: " + str(resolution))
	print("fullscreen: " + str(is_fullscreen))

# disable resolutions if they are less than the display resolution
func disable_invalid_resolutions():
	var screen_size := OS.get_screen_size()
	
	for i in range(1, 3):
		if screen_size[0] < 640 * (i + 1) and screen_size[1] < 360 * (i + 1):
			resolution_btn.set_item_disabled(i, true)

	if screen_size[0] < 3840 and screen_size[1] < 2160:
		resolution_btn.set_item_disabled(4, true)
	
# select current resolution of the game	
func select_current_resolution():
	match resolution:
		Vector2(640, 360):
			resolution_btn.select(0)
		Vector2(1280, 720):
			resolution_btn.select(1)
		Vector2(1920, 1080):
			resolution_btn.select(2)
		Vector2(2560, 1440):
			resolution_btn.select(3)
		Vector2(3840, 2160):
			resolution_btn.select(4)

func _process(delta):
	pass

# change the resolution
func _on_ResolutionBtn_item_selected(index):
	match index:
		0:
			resolution = Vector2(640, 360)
		1:
			resolution = Vector2(1280, 720)
		2:
			resolution = Vector2(1920, 1080)
		3:
			resolution = Vector2(2560, 1440)
		4:
			resolution = Vector2(3840, 2160)
	
	confirm_btn.disabled = false
	print("resolution: " + str(resolution))

# toggle fullscreen
func _on_FullscreenCheckBox_toggled(button_pressed):
	is_fullscreen = !is_fullscreen
	confirm_btn.disabled = false
	print("fullscreen: " + str(is_fullscreen))

# apply changes
func _on_ConfirmBtn_pressed():
	OS.window_size = resolution
	OS.window_fullscreen = is_fullscreen
	
	Config.window_size = resolution
	Config.is_fullscreen = is_fullscreen
	
	confirm_btn.disabled = true

# return to main menu
func _on_BackBtn_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
