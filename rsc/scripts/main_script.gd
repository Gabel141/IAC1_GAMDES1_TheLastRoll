extends Node

@onready var label: Label = $Label
@onready var boardmap: TileMapLayer = $MapLayers/BoardPath

signal dice_number(dice: int, player: Node)
signal board_space_total(index:int)

var player_count
var player_turn
var player_id

var TRACK_PATH: Array[Vector2i] = []

func _ready() -> void:
	
	# used for creating an array of tiles
	
	for i in range(5):
		for j in range(13):
			TRACK_PATH.push_back(Vector2i(j,i))

	
	# start of game prep
	# counts players
	player_id = 0
	player_turn = $Players.get_child(0)
	player_count = $Players.get_child_count()
	
	label.text = " "
	board_space_total.emit(boardmap.get_used_cells().size())
	
	# gets all players, puts them at the starting position, and connects their signals
	var start_tile = TRACK_PATH[0]
	var start_pixel = boardmap.map_to_local(start_tile)
	for player in $Players.get_children():
		player.global_position = start_pixel
		player.player_moved.connect(_on_player_moved)

		
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
	var target_tile = TRACK_PATH[index]
	print(target_tile)
	var target_pixel = boardmap.map_to_local(target_tile)
	tween.tween_property(player, "global_position", target_pixel, 0.25)
