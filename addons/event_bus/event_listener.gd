@icon("uid://bdfxm1xfcj511")
class_name EventListener extends Node

## Topic route string to listen to for incoming events.
@export var _route: String = ""

## Emitted when the node receives a message from the EventBroker.
signal message_received(payload)

func _enter_tree() -> void:
	if not _route.is_empty():
		EventBroker.subscribe(_route, _on_message)

func _exit_tree() -> void:
	if not _route.is_empty():
		EventBroker.unsubscribe(_route, _on_message)

func _on_message(payload: Variant = null) -> void:
	message_received.emit(payload)

