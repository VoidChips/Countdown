extends Area2D

export (Game.PotionTypes) var type = Game.PotionTypes.CURE


func _ready():
	# change the sprite based on what type it is
	$Sprite.frame = type
