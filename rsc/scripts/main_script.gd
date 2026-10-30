extends Node

@onready var map: Node2D = $Map
@onready var camera: Camera2D = $Camera
@onready var map_script: Node2D = $Map

var winners = 0
var is_player_moving
var has_player_rolled
var board_space_count
var player_count
var current_player # determines current player
var player_id # determines id of players

func _ready() -> void:
	_start_game()
	
func _start_game() -> void:
	# add changeable resolutions
	get_window().size = Vector2i(1280, 720)
	
	# used for creating an array of tiles
	board_space_count = $Map.get_child_count()
	print("NEW MAP START: ", $Map.get_child(0).position, ", TYPE: ", $Map.get_child(0).space_type)
	print("TOTAL SPACE COUNT incl START and FINISH: ", board_space_count)
	
	# start of game prep
	# counts players, fix later with connection to main menu
	player_id = 0
	current_player = $Players.get_child(0)
	player_count = $Players.get_child_count()
	has_player_rolled = false
	is_player_moving = false
	
	# gets all players, puts them at the starting position, and connects their signals
	var start_space = $Map.get_child(0)
	
	var playerID = 0
	for player in $Players.get_children():
		player.global_position = start_space.global_position
		player.player_moved.connect(_on_player_moved)
		$UI/PlayerHP.get_child(playerID).text = "Player " + str(playerID + 1) + " HP: " + str(player.hp)
		playerID += 1
	playerID = 0
	
	# UI stuff
	$UI._start_game(player_count)
	camera.reparent(current_player)
	camera.global_position = current_player.global_position
	current_player = $Players.get_child(player_id)

# player rolling dice and turn management
func _on_dice_roll_done(index: int) -> void:
	print("player turn: ",player_id)
	print("player turn: ",current_player)
	print("main_script._on_dice_roll_done" + str(index))
	current_player._on_root_dice_number(index, current_player)

func _on_player_moved(index: int, player: Node, end_move: bool, move_left: int) -> void:
	var tween = create_tween()
	var target_space = $Map.get_child(index)
	var target_pixel = target_space.get_global_position()
	tween.tween_property(player, "global_position", target_pixel, 0.5)
	_player_on_board_space(target_space.space_type, end_move, move_left)

func _player_on_board_space(space_type: String, end_move: bool, move_left: int):
	if end_move == true and move_left == 0:
		await get_tree().create_timer(0.5).timeout
		is_player_moving = false

	print("Player " + str(player_id) + " passed a " + str(space_type) + " space!")
	if current_player.is_initial_move == false:
		match(space_type):
			"boss": # interrupt
				current_player.can_move = false
				map_script._player_on_boss(current_player)
			"buff":
				map_script._player_on_buff()
			"empty":
				map_script._player_on_empty()
			"forced_combat": # interrupt
				current_player.can_move = false
				map_script._player_on_forced_combat(current_player)
			"heal":
				map_script._player_on_heal()
			"monster":
				if end_move == true:
					map_script._player_on_monster(current_player)
				else:
					print("passed a monster")
			"random":
				map_script._player_on_random()
			"shop":
				map_script._player_on_shop()
			"trap":
				map_script._player_on_trap()
			"treasure":
				map_script._player_on_treasure()
			"win":
				_win_game(current_player)

func _end_turn():
	if is_player_moving == false and has_player_rolled == true:
		if player_id < player_count - 1:
			player_id += 1
		else:
			player_id = 0
		current_player = $Players.get_child(player_id)
		camera.reparent(current_player)
		camera.global_position = current_player.global_position
		$UI/PlayerTurn.text = "Player " + str(player_id + 1) + "'s Turn"
		has_player_rolled = false
	else:
		print("PLAYER IS STILL MOVING")

func _win_game(player: Node):
	winners += 1
	
	if winners == 1:
		print(str(player) + " wins!")
