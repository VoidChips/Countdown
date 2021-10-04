extends KinematicBody2D

export var run_speed := 350
export var jump_speed := -1000
export var gravity := 2500

onready var inventory := PlayerState.inventory

var velocity = Vector2()
var is_poisoned := true
var is_dead := false

# use input to handle player movement and action
func get_input() -> void:
	velocity.x = 0
	var right := Input.is_action_pressed('ui_right')
	var left := Input.is_action_pressed('ui_left')
	var jump := Input.is_action_just_pressed("jump")
	var drink := Input.is_action_just_pressed("drink")

	if is_dead:
		return

	if is_on_floor() and jump:
		velocity.y = jump_speed
		$AnimatedSprite.play("jump")
	elif not is_on_floor():
		$AnimatedSprite.play("fall")
	
	if right:
		velocity.x += run_speed
		$AnimatedSprite.flip_h = false
		
		if is_on_floor():
			$AnimatedSprite.play("walk")
	elif left:
		velocity.x -= run_speed
		$AnimatedSprite.flip_h = true
		
		if is_on_floor():
			$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")
	
	if drink:
		if "cure potion" in inventory:
			is_poisoned = false
			inventory.erase("cure potion")

			

func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# detect collision
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			var object = collision.collider
			if object.name == "CurePotion":
				inventory["cure potion"] = 100
				object.queue_free()

