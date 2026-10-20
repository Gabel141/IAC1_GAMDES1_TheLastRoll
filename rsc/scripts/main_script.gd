extends Node

@onready var label: Label = $Label
@onready var map: Node2D = $Map

signal dice_number(dice: int, player: Node)
signal board_space_total_count(index:int)

var board_space_count
var player_count
var player_turn
var player_id


func _ready() -> void:
	
	# used for creating an array of tiles
	board_space_count = $Map.get_child_count()
	print("NEW MAP START: ", $Map.get_child(0).position, ", TYPE: ", $Map.get_child(0).space_type)
	print("TOTAL SPACE COUNT incl START and FINISH: ", board_space_count)
	
	# start of game prep
	# counts players, fix later with connection to main menu
	player_id = 0
	player_turn = $Players.get_child(0)
	player_count = $Players.get_child_count()
	
	label.text = " "
	board_space_total_count.emit(board_space_count)
	
	# gets all players, puts them at the starting position, and connects their signals
	var start_space = $Map.get_child(0)
	for player in $Players.get_children():
		player.global_position = start_space.global_position
		player.player_moved.connect(_on_player_moved)

# player rolling dice and turn management
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
	var tween = create_tween()
	print(index)
	var target_space = $Map.get_child(index)
	var target_pixel = target_space.get_global_position()
	tween.tween_property(player, "global_position", target_pixel, 0.25)
