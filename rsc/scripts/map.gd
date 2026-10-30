extends Node2D

@onready var dice = $"../UI/Dice"

var total_dice_roll = 0
var player_movement_left = 0

func _player_on_boss(player: Node):
	_prep_fight("boss", player)

func _player_on_buff():
	pass

func _player_on_empty():
	pass

func _player_on_forced_combat(player: Node):
	_prep_fight("monster", player)

func _player_on_heal():
	pass
	
func _player_on_monster(player: Node):
	_prep_fight("monster", player)

func _player_on_random():
	pass

func _player_on_shop():
	pass

func _player_on_trap():
	pass

func _player_on_treasure():
	pass

func _player_combat_loss(lostTo: String, player: Node):
	print("player lost to: " + lostTo)
	match lostTo:
		'boss':
			player.total_movement = 0
			pass
		'monster':
			# needs a choice here
			pass
		'player':
			# needs a choice here
			pass

func _player_combat_win(player: Node):
	$".."._on_root_dice_number(player.movement_left, player)

func _initiate_combat(type: String, party1: Node): 
	match type:
		"boss":
			pass
		"monster":
			pass
	
	var monster_roll = _roll_dice(2)
	print("Mosnter Roll: " + str(monster_roll))

	var player_roll = _roll_dice(party1.atk_dice)
	print("Player Roll: " + str(player_roll))
	
	if player_roll > monster_roll:
		print("player victory")
	elif player_roll == monster_roll:
		_initiate_combat(type, party1)
	else:
		_player_combat_loss(type, party1)

func _initiate_combat_pvp(type: String, party1: Node, party2: Node):
	pass

func _receive_dice(total_dice: int):
	total_dice_roll += total_dice
	if dice.roll_finished.is_connected(_receive_dice) == true:
		dice.roll_finished.disconnect(_receive_dice)

func _roll_dice(dice_number: int) -> int:
	var total_dice_number = 0
	for i in dice_number:
		total_dice_number += randi_range(1, 6)
	return total_dice_number

func _prep_fight(type: String, player: Node) -> void:
	$"../UI"._prep_fight(type, player)
