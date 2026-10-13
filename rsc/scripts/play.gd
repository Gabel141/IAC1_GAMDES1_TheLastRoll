extends Node

func _on_button_pressed() -> void:
	play()

func play() -> void:
	get_tree().change_scene_to_file("res://rsc/scenes/root.tscn")
