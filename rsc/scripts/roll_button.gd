extends Button

signal rollTotal(index: int)

@onready var parentDice = $"../Dice/"
@onready var diceScene: PackedScene = preload("res://rsc/nodes/dice.tscn")

var is_rolling = false
var movement = 0

func _on_pressed(diceCount: int) -> void: # Movement ONLY
	if is_rolling == false:
		
		is_rolling = true
		
		parentDice.roll_finished.connect(_receive_dice)
		parentDice._roll_dice(diceCount)
		await get_tree().create_timer(2).timeout
		parentDice.roll_finished.disconnect(_receive_dice)
		
		is_rolling = false

func _receive_dice(totalDice: int) -> void:
	print(str(totalDice))
	rollTotal.emit(totalDice)
