extends Button

signal rollTotal(index: int)

@onready var parentDice = $"../Dice/"
@onready var roll_total = $"../RollTotal"
@onready var diceScene: PackedScene = preload("res://rsc/nodes/dice.tscn")

var isRolling = false
var totalRollCount = 0
var diceNumber = -1
var dicePosition = Vector2(0, 0)

func _on_pressed(diceCount: int) -> void: # Movement ONLY

	if isRolling == false:
		isRolling = true
		for i in diceCount:
			var die = diceScene.instantiate()
			get_node("../Dice").add_child(die)
		for die in $"../Dice".get_children():
			if diceCount == 1:
				die.position = get_viewport_rect().size / 2 + Vector2(0, 120)
			else:
				dicePosition = Vector2(diceNumber * 128, 120)
				die.position = get_viewport_rect().size / 2 + dicePosition
				diceNumber += 1
			die.roll_done.connect(_on_dice_roll_done)
			die._roll_dice()
		
		await get_tree().create_timer(1.2).timeout
		rollTotal.emit(totalRollCount)
		
		await get_tree().create_timer(2).timeout
		for die in $"../Dice".get_children():
			die.queue_free()
		
		totalRollCount = 0
		diceNumber = -1
		isRolling = false

func _on_dice_roll_done(index: int) -> void:
	print(str(index))
	totalRollCount += index
	print("Total Rolls: " + str(totalRollCount))
