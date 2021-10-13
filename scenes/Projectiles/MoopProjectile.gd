extends Area2D

export var speed := 4

var velocity := Vector2()


# keep moving in the direction
func _physics_process(delta):
	position.y += gravity * delta
	position += velocity
	

# aim towards the target using the direction
func set_target(direction : Vector2, angle : float) -> void:
	velocity = direction * speed
	
	# set the rotation of sprite to match the direction of movement
	var rotation = rad2deg(acos(angle))
	rotation = rotation if direction.x < 0 else -rotation
	rotation_degrees = rotation


func _on_MoopProjectile_body_entered(body):
	if body.get_name() == "Player":
		PlayerState.set_state("hit", Game.PotionTypes.SPEED_DOWN)
	queue_free()
