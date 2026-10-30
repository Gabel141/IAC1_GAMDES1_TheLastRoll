@tool
extends EditorPlugin

const KeyEventBroker := 'EventBroker'
const Paths := {
	KeyEventBroker: "res://addons/event_bus/event_broker.gd"
}

func _enable_plugin() -> void:
	# Add autoloads here.
	add_autoload_singleton(KeyEventBroker, Paths.EventBroker)


func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton(KeyEventBroker)


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
