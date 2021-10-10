extends Area2D

export (PackedScene) var Projectile

onready var cooldown_timer := $CooldownTimer

var target := Vector2()
var is_on_cooldown := false


func _physics_process(delta):
	var space_state := get_world_2d().direct_space_state
	var result := space_state.intersect_ray(Vector2(0, 0), target, [self])
	
	if result and not is_on_cooldown:
		var projectile = Projectile.instance()
		
		add_child(projectile)
		projectile.set_velocity(position.direction_to(target))
		cooldown_timer.start()
		is_on_cooldown = true

		
	play_animation()


func play_animation() -> void:
	$AnimationPlayer.play("idle")
	

func set_target(v : Vector2) -> void:
	target = v


func _on_Cooldown_timeout():
	is_on_cooldown = false
