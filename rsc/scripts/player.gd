extends Node2D

@onready var position_count: Label = $Label
var board_space_total

signal player_moved(index:int, player: Node)

var board_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_position = 0
	$"../..".board_space_total.connect(_board_space_total)
	$"../..".dice_number.connect(_on_root_dice_number)

func _board_space_total(index: int) -> void:
	board_space_total = int(index)
	print(board_space_total)

func _on_root_dice_number(index: int, player: Node) -> void:
	if player == self:
		board_position += index
		print(self, " moved!")
		if board_position >= board_space_total:
			print(name, " Wins!")
			position_count.text = ("win")
			board_position = board_space_total
			player_moved.emit(board_position - 1, self)
		else:
			position_count.text = str(board_position)
			player_moved.emit(board_position, self)
