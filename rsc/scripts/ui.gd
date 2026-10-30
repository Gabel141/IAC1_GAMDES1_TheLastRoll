extends CanvasLayer

@onready var game: Node2D = $".."

signal movementDiceRolled(index: int)
signal endTurn
var rollCount = 0

func _process(_delta: float) -> void:
	$Debug.text = "is_player_moving: " + str(game.is_player_moving) + " 
	\n has_player_rolled: " + str(game.has_player_rolled) + "
	\n is_initial_move: " + str(game.current_player.is_initial_move)

func _on_roll_button_pressed() -> void:
	_player_movement(game.current_player.move_dice)
	$RollButton.hide()
	game.is_player_moving = true
	await get_tree().create_timer(3).timeout
	$EndTurnButton.show()

func _end_turn_pressed() -> void:
	if game.is_player_moving == true:
		pass
	else:
		endTurn.emit()
		print("End Turn Pressed!")
		$RollButton.show()
		$EndTurnButton.hide()

func _player_movement(m_dice: int) -> void:
	print("move dice: " + str(m_dice))
	$RollButton._on_pressed(m_dice)

func _on_roll_button_roll_total(index: int) -> void:
	$RollTotal.text = "Roll Total: " + str(index)
	print("move dice: " + str(index))
	print("ui._on_roll_button_roll_total: " + str(index))
	movementDiceRolled.emit(index)

func _start_game(playerCount: int) -> void:
	for i in playerCount:
		$PlayerHP.get_child(i).show()
	$PlayerTurn.text = "Player 1's Turn"

func _test_dice() -> void:
	$Dice._roll_dice(2)

var fight_type
var attacking_player

func _prep_fight(type: String, player: Node) -> void:
	fight_type = type
	attacking_player = player
	$FightButton.show()

func _fight():
	var map = $"../Map"
	match fight_type:
		"boss":
			map._initiate_combat("boss", attacking_player)
		"monster":
			map._initiate_combat("monster", attacking_player)
		"player":
			pass
	$FightButton.hide()
