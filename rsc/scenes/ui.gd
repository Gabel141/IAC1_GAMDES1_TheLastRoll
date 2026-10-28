extends CanvasLayer

signal movementDiceRolled(index: int)
signal diceRolling

var rollCount = 0

func _on_roll_button_pressed() -> void:
	diceRolling.emit()

func _player_movement(m_dice: int) -> void:
	$RollButton._on_pressed(m_dice)

func _on_roll_button_roll_total(index: int) -> void:
	$RollTotal.text = "Roll Total: " + str(index)
	movementDiceRolled.emit(index)

func _start_game(playerCount: int) -> void:
	for i in playerCount:
		$PlayerHP.get_child(i).show()
	$PlayerTurn.text = "Player 1's Turn"
