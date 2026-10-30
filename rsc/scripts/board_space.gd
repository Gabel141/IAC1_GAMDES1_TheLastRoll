extends Node2D

@export_enum("boss", "buff", "empty", "forced_combat", "heal", "monster", "random", "shop", "trap", "treasure", "win") var space_type: String = "empty"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = space_type
