@tool
@icon("uid://0jal45ygyfm0")
class_name EventProducer extends Node

## Defines the method used to extract a payload from '_target_node'.
enum SelectorType { PROPERTY, METHOD, OBJECT }

## Identification of the producer route used to call listeners subscribed to this route.
@export var route: StringName = &""

@export_group('Payload selector')
## Node used to extract payload data from. Useful for sending payloads without writing code.
var _target_node: Node:
	set(value):
		_target_node = value
		if not value: _selected_payload = &""
		notify_property_list_changed()

## Specifies how payload data will be retrieved from '_target_node' (Property value, Method return value, or Node object reference).
var _selector_type: SelectorType = SelectorType.PROPERTY:
	set(value):
		_selector_type = value
		_selected_payload = &""
		notify_property_list_changed()

## Property or method name on '_target_node' used as the payload source.
var _selected_payload: StringName = &""

## Sends an event. The default route can be overridden by passing 'route_override'.
func publish(payload: Variant = null, route_override: StringName = "") -> void:
	var target_route = route_override if route_override != &"" else route
	
	if _target_node and not payload:
		payload = _get_payload()
	
	if target_route.is_empty():
		push_warning("EventProducer: '%s' target route is empty." % name)
		return
	
	EventBroker.publish(target_route, payload)

## Evaluates and returns the payload from '_target_node' based on '_selector_type'.
func _get_payload() -> Variant:
	match _selector_type:
		SelectorType.PROPERTY:
			return _target_node.get(_selected_payload)
		SelectorType.METHOD:
			return _target_node.call(_selected_payload)
		SelectorType.OBJECT:
			return _target_node
	
	return null

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	var hint_string: String = ""
	
	properties.append({
			"name": "_target_node",
			"type": TYPE_OBJECT,
			"hint": PROPERTY_HINT_NODE_TYPE,
			"hint_string": "Node",
			"usage": PROPERTY_USAGE_DEFAULT
		})
	
	if _target_node:
		properties.append({
					"name": "_selector_type",
					"type": TYPE_INT,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": ",".join(SelectorType.keys()).capitalize(),
					"usage": PROPERTY_USAGE_DEFAULT
				})
			
		match _selector_type:
			SelectorType.PROPERTY:
				var node_properties = _target_node.get_property_list()
				var property_names: Array[String] = []
				
				for prop in node_properties:
					if prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE || prop["usage"] & PROPERTY_USAGE_DEFAULT:
						property_names.append(prop["name"])
				
				hint_string = ",".join(property_names)
				
				properties.append({
					"name": "_selected_payload",
					"type": TYPE_STRING_NAME,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": hint_string,
					"usage": PROPERTY_USAGE_DEFAULT
				})
			SelectorType.METHOD:
				var node_methods = _target_node.get_method_list()
				var method_names: Array[String] = []
				
				for method in node_methods:
					var args: Array = method["args"]
					var returns: Dictionary = method["return"]
					if not method["name"][0].begins_with("_") and method["flags"] & METHOD_FLAGS_DEFAULT and args.is_empty() and returns["type"] & TYPE_NIL == 0:
						method_names.append(method["name"])
				
				hint_string = ",".join(method_names)
				
				properties.append({
					"name": "_selected_payload",
					"type": TYPE_STRING_NAME,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": hint_string,
					"usage": PROPERTY_USAGE_DEFAULT
				})
	
	return properties

