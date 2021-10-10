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
var is_facing_right := true
var can_move := true
var potion_type := -1


func _ready():
	$Potion.visible = false


# use input to handle player movement and action
func get_input() -> void:
	var right := Input.is_action_pressed('ui_right')
	var left := Input.is_action_pressed('ui_left')
	var jump := Input.is_action_just_pressed("jump")
	var drink := Input.is_action_just_pressed("drink")
	
	velocity.x = 0

	# don't process input if the player is dead or can't move
	if is_dead:
		return
	elif not can_move:
		$AnimationPlayer.play("idle")
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
		is_facing_right = true
		
		if is_on_floor():
			$AnimationPlayer.play("walk")
	elif left:
		velocity.x -= run_speed
		$Sprite.flip_h = true
		is_facing_right = false
		
		if is_on_floor():
			$AnimationPlayer.play("walk")
	elif is_on_floor():
		$AnimationPlayer.play("idle")
		
	# drink potion
	if drink:
		var potions_list = inventory["potions"]
		var types := Game.PotionTypes
		
		if types.CURE in potions_list:
			drink_potion(types.CURE)
		elif types.POISON in potions_list:
			drink_potion(types.POISON)
		elif types.SPEED_DOWN in potions_list:
			drink_potion(types.SPEED_DOWN)
		elif types.SPEED_UP in potions_list:
			drink_potion(types.SPEED_UP)
		elif types.JUMP_BOOST in potions_list:
			drink_potion(types.JUMP_BOOST)


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
	
	if not is_drinking:
		get_input()

	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	handle_projectile_hit(PlayerState.get_state("hit"))
	
	# detect collision
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision:
#			var object = collision.collider


# start drinking a potion
func drink_potion(type : int) -> void:
	if is_facing_right:
		$AnimationPlayer.play("drink right")
	else:
		$AnimationPlayer.play("drink left")
	$Potion.frame = type  # set the type of potion's sprite
	potion_type = type
	is_drinking = true


# finish drinking when the drinking animation ends
func finish_drinking() -> void:
	var types := Game.PotionTypes
	
	is_drinking = false
	inventory["potions"].erase(potion_type)
	
	match potion_type:
		types.CURE:
			is_poisoned = false
		types.POISON:
			is_dead = true
		types.SPEED_DOWN:
			run_speed /= 2
			jump_speed /= 2
		types.SPEED_UP:
			run_speed *= 2
		types.JUMP_BOOST:
			jump_speed *= 2
			
	potion_type = -1
	


# toggle visiblity of potion
func toggle_potion_visible() -> void:
	$Potion.visible = not $Potion.visible


# give the player a power boost or power down from being hit
func handle_projectile_hit(hit_state : int) -> void:
	if hit_state == -1:
		return
	
	var types := Game.PotionTypes
	
	match hit_state:
		types.CURE:
			is_poisoned = false
		types.POISON:
			is_dead = true
		types.SPEED_DOWN:
			run_speed /= 2
			jump_speed /= 2
		types.SPEED_UP:
			run_speed *= 2
		types.JUMP_BOOST:
			jump_speed *= 2
			
	PlayerState.set_state("hit", -1)
