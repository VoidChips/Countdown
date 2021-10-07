extends KinematicBody2D

export var run_speed := 350
export var jump_speed := -1000
export var gravity := 2500

onready var inventory := PlayerState.get_items()

var velocity = Vector2()
var is_poisoned := true
var is_dead := false
var is_jumping := false
var is_drinking := false


func _ready():
	$Potion.visible = false


# use input to handle player movement and action
func get_input() -> void:
	velocity.x = 0
	var right := Input.is_action_pressed('ui_right')
	var left := Input.is_action_pressed('ui_left')
	var jump := Input.is_action_just_pressed("jump")
	var drink := Input.is_action_just_pressed("drink")

	# don't process input if the player is dead
	if is_dead:
		return

	# jump if the player pressed the jump button from the ground
	# fall if the player is in the air but not jumping
	if is_on_floor() and jump:
		velocity.y = jump_speed
		is_jumping = true
	
	# move right or left
	if right:
		velocity.x += run_speed
		$Sprite.flip_h = false
		
		if is_on_floor() and not is_drinking:
			$AnimationPlayer.play("walk")
	elif left:
		velocity.x -= run_speed
		$Sprite.flip_h = true
		
		if is_on_floor() and not is_drinking:
			$AnimationPlayer.play("walk")
	elif is_on_floor() and not is_drinking:
		$AnimationPlayer.play("idle")
	
	# drink potion
	if drink:
		if Game.PotionTypes.CURE in inventory["potions"]:
			$AnimationPlayer.play("drink")
			$Potion.frame = 0  # set the type of potion
			$Potion.visible = true
			is_drinking = true


func _physics_process(delta):
	velocity.y += gravity * delta
	
	# play the jumping animation when jumping until player starts to fall
	if is_jumping and not is_drinking:
		$AnimationPlayer.play("jump")
		if velocity.y > 0.0:
			is_jumping = false
			$AnimationPlayer.play("fall")
	elif not is_on_floor() and not is_drinking:
		$AnimationPlayer.play("fall")
			
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# detect collision
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision:
#			var object = collision.collider


# finish drinking when the drinking animation ends
func finish_drinking() -> void:
	is_drinking = false
	inventory["potions"].erase(Game.PotionTypes.CURE)
	is_poisoned = false


# toggle visiblity of potion
func toggle_potion_visible() -> void:
	$Potion.visible = not $Potion.visible
