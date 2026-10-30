extends Node2D

@onready var position_count: Label = $Label
@onready var map: Node = $"../../Map"

var board_space_total
signal player_moved(index:int, player: Node, end_move: bool, move_left: int)
var board_position
var new_board_position

var hp = 5
var move_dice = 1
var atk_dice = 2
var gold = 0
var buff
var debuff
var potion_buff

var total_movement
var total_movement_left
var can_move
var is_initial_move

func _ready() -> void:
	board_position = 0
	board_space_total = map.get_child_count() - 1
	can_move = true

func _on_root_dice_number(index: int, player: Node) -> void:
	await get_tree().create_timer(1.5).timeout
	is_initial_move = true
	print("player._on_root_dice_number: " + str(index))
	if player == self:
		print(self, " moved!")
		new_board_position = board_position + index
		total_movement = new_board_position - board_position
		total_movement_left = total_movement
		print("New Board Position: " + str(new_board_position))
		print("Total Movement: " + str(total_movement))
		for i in range(total_movement):
			if can_move == true:
				if i == total_movement - 1:
					if board_position < board_space_total:
						total_movement_left -= 1
						print("end movement")
						print("movement left: " + str(total_movement_left))
						player_moved.emit((board_position + 1), self, true, total_movement_left)
						await get_tree().create_timer(0.5).timeout
						board_position += 1
						is_initial_move = false
					else:
						_win_game()
						break
				else:
					if board_position < board_space_total:
						total_movement_left -= 1
						print("movement left: " + str(total_movement_left))
						player_moved.emit((board_position + 1), self, false, total_movement_left)
						await get_tree().create_timer(0.5).timeout
						board_position += 1
						is_initial_move = false
					else:
						_win_game()
						break
			else:
				player_moved.emit((board_position), self, false, total_movement_left)
				break

func _win_game():
	$"../.."._win_game(self)
