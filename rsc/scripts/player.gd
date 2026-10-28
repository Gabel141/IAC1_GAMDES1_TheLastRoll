extends Node2D

@onready var position_count: Label = $Label
var board_space_total

signal player_moved(index:int, player: Node)
signal player_stats(health: int, m_dice: int, a_dice: int)

var board_position
var hp = 5
var move_dice = 1
var atk_dice = 2

func _ready() -> void:
	board_position = 0
	$"../..".board_space_total_count.connect(_board_space_total)
	$"../..".dice_number.connect(_on_root_dice_number)

func _board_space_total(index: int) -> void:
	board_space_total = int(index)

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
