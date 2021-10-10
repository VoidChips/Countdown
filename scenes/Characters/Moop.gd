extends Area2D

export (PackedScene) var Projectile
export var direction := Vector2(0, 1)

onready var cooldown_timer := $CooldownTimer

var target := Vector2()
var is_on_cooldown := false
var is_tracking := false
var player_pos := Vector2()


func _physics_process(_delta):
	if is_tracking and not is_on_cooldown and found_player():
		shoot()

	play_animation()


func play_animation() -> void:
	$AnimationPlayer.play("idle")
	

func set_player_pos(v : Vector2) -> void:
	player_pos = v
	is_tracking = true


# checks if moop found the player in its field of view
func found_player() -> bool:
	var direction_to_player := position.direction_to(player_pos)
	return direction_to_player.dot(direction) > 0.3


# shoot a projectile at player
func shoot() -> void:
	var projectile = Projectile.instance()
	add_child(projectile)
	projectile.set_target(position.direction_to(player_pos))
	cooldown_timer.start()
	is_on_cooldown = true


func _on_Cooldown_timeout():
	is_on_cooldown = false
