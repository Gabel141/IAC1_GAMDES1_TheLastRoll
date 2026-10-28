extends Node

@onready var label: Label = $Label
@onready var map: Node2D = $Map
@onready var camera: Camera2D = $Camera

signal dice_number(dice: int, player: Node)
signal board_space_total_count(index:int)

var board_space_count
var player_count
var player_turn # determines current player
var player_id

func _ready() -> void:
	
	get_window().size = Vector2i(1280, 720)
	
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
	
	var playerID = 0
	for player in $Players.get_children():
		player.global_position = start_space.global_position
		player.player_moved.connect(_on_player_moved)
		$UI/PlayerHP.get_child(playerID).text = "Player " + str(playerID + 1) + " HP: " + str(player.hp)
		playerID += 1
	playerID = 0
	$UI._start_game(player_count)
	
	camera.reparent(player_turn)
	camera.global_position = player_turn.global_position

# player rolling dice and turn management
func _on_dice_roll_done(index: int) -> void:
	print("player turn: ",player_id)
	print("player turn: ",player_turn)
	label.text = str(index)
	player_turn = $Players.get_child(player_id)
	player_turn._on_root_dice_number(index, player_turn) # movement dice 
	# old movement dice_number.emit(index, player_turn) # movement rolls for NOW
	if player_id < player_count - 1: # next turn function, move this to an end turn function later on
		player_id += 1
	else:
		player_id = 0
		
	camera.reparent(player_turn)
	camera.global_position = player_turn.global_position
	await get_tree().create_timer(2).timeout
	$UI/PlayerTurn.text = "Player " + str(player_id + 1) + "'s Turn"
	
func _on_ui_dice_rolling() -> void:
	var move_dice = player_turn.move_dice
	$UI._player_movement(move_dice)

func _on_player_moved(index: int, player: Node) -> void:
	var tween = create_tween()
	print(index)
	var target_space = $Map.get_child(index)
	var target_pixel = target_space.get_global_position()
	tween.tween_property(player, "global_position", target_pixel, 0.5)
