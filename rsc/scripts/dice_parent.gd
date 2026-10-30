extends Node

@onready var parentDice = self
@onready var sfx_player = $"../SFX"
@onready var diceScene: PackedScene = preload("res://rsc/nodes/dice.tscn")
@onready var viewport_rect = get_viewport().get_visible_rect()

@onready var dice_sfx1 = preload("res://rsc/assets/sfx/Roll 1d6.wav")
@onready var dice_sfx2 = preload("res://rsc/assets/sfx/Roll 2d6.wav")
@onready var dice_sfx3 = preload("res://rsc/assets/sfx/Roll 3d6.wav")

var totalRollCount = 0
var diceNumber = -1
var dicePosition = Vector2(0, 0)

signal roll_finished(total_roll: int)
func _roll_dice(dice_count: int) -> void:
	if dice_count == 1:
		print("SFX1")
		sfx_player.stream = dice_sfx1
		sfx_player.play()
	elif dice_count == 2:
		print("SFX2")
		sfx_player.stream = dice_sfx2
		sfx_player.play()
	else:
		print("SFX3")
		sfx_player.stream = dice_sfx3
		sfx_player.play()
	for i in dice_count:
		var die = diceScene.instantiate()
		parentDice.add_child(die)
	for die in parentDice.get_children():
		if dice_count == 1:
			die.position = viewport_rect.size / 2 + Vector2(0, 120)
		else:
			dicePosition = Vector2(diceNumber * 128, 120)
			die.position = viewport_rect.size / 2 + dicePosition
			diceNumber += 1
		if die.roll_done.is_connected(_on_dice_roll_done):
			print("Already Connected!")
			$"../RollButton".show()
		else:
			die.roll_done.connect(_on_dice_roll_done)
		die._roll_dice()
	
	print("Total Roll count: " + str(totalRollCount))
	roll_finished.emit(totalRollCount)

	await get_tree().create_timer(2).timeout
	for die in $"../Dice".get_children(): # move dice ending to seperate function for better maintainability
		die.queue_free()
	
	totalRollCount = 0
	diceNumber = -1

func _on_dice_roll_done(index: int) -> void:
	print("dice_parent._on_dice_roll_done: " + str(index))
	totalRollCount += index
	print("dice_parent.roll_button.totalRollCount: " + str(totalRollCount))
