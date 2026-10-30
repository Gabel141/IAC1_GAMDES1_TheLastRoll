extends Node

var _topics: Dictionary = {}

## Subscribes a Callable to a specific route.
func subscribe(route: StringName, callable: Callable) -> void:
	if not _topics.has(route):
		_topics[route] = []
	if not _topics[route].has(callable):
		_topics[route].append(callable)

## Removes a subscription for a Callable from a specific route.
func unsubscribe(route: StringName, callable: Callable) -> void:
	if _topics.has(route):
		_topics[route].erase(callable)
		if _topics[route].is_empty():
			_topics.erase(route)


## Sends an event payload to all Callables subscribed to the specified route.
func publish(route: StringName, payload: Variant = null) -> void:
	if _topics.has(route):
		for i in range(_topics[route].size() - 1, -1, -1):
			var callable = _topics[route][i]
			if callable.is_valid():
				callable.call(payload)
			else:
				_topics[route].remove_at(i)

