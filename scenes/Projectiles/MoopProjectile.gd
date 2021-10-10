extends Area2D

export var speed := 4

var velocity := Vector2()


# keep moving in the direction
func _physics_process(delta):
	position.y += gravity * delta
	position += velocity
	

# aim towards the target using the direction
func set_target(v : Vector2) -> void:
	velocity = v * speed


func _on_MoopProjectile_body_entered(body):
	if body.get_name() == "Player":
		PlayerState.set_state("hit", Game.PotionTypes.SPEED_DOWN)
	queue_free()
