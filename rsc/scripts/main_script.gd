extends Node

@onready var label: Label = $Label

signal dice_number(dice: int, player: Node)
signal board_space_total(index:int)
signal assign_turn(player: int)

var player_count
var player_turn
var player_dict = {}
var player_id

func _ready() -> void:
	player_id = 0
	player_turn = $Players.get_child(0)
	player_count = $Players.get_child_count()
	label.text = " "
	board_space_total.emit($Board.get_child_count())
	$SpaceCount.text = str($Board.get_child_count())
	for player in $Players.get_children():
		player.global_position = $Board.get_child(0).global_position
		player.player_moved.connect(_on_player_moved)
	var x = 0
	for n in $Players.get_children():
		player_dict = {
			x : n
		}
		x += 1
		
func _on_dice_roll_done(index: int) -> void:
	print("player turn: ",player_id)
	print("player turn: ",player_turn)
	label.text = str(index)
	player_turn = $Players.get_child(player_id)
	dice_number.emit(index, player_turn)
	if player_id < player_count - 1:
		player_id += 1
	else:
		player_id = 0


func _on_player_moved(index: int, player: Node) -> void:
	player.global_position = $Board.get_child(index).global_position
