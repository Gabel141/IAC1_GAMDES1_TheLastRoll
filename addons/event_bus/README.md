# Godot Event Bus Addon

A lightweight, decoupled pub/sub event bus system for **Godot 4**.

The **Event Bus** addon allows nodes across different scenes and UI hierarchies to communicate seamlessly via string-based routes without creating direct scene dependencies or cluttering global singleton scripts with hardcoded signals.

---

## 🚀 Features

- 🔌 **Decoupled Architecture**: Send and receive messages across scenes without needing node references (`get_node`, `%UniqueNames`, etc.).
- 🛠️ **No-Code Node Workflow**: Use custom `EventProducer` and `EventListener` nodes directly in the Godot inspector.
- 🎯 **Flexible Payload Extraction**: `EventProducer` can automatically extract and send a property value, call a method return value, or pass an entire node object reference visually from the inspector without code.
- ⚡ **Pure Script / API Support**: Direct usage via the global `EventBroker` singleton.
- 🧹 **Automatic Lifecycle Management**: `EventListener` auto-subscribes on `_enter_tree()` and auto-unsubscribes on `_exit_tree()`. Stale callbacks are cleaned up automatically during publishing.

---

## 📦 Installation

1. Copy or clone the `addons/event_bus` directory into your Godot project's `addons/` folder.
2. Open your Godot project and navigate to **Project Settings** > **Plugins**.
3. Enable the **Event Bus** plugin.
   > **Note**: Enabling the plugin automatically registers the `EventBroker` singleton in your project's Autoload settings.

---

## 🛠️ Usage Modes

### Method 1: Node-Based (Visual / Inspector Workflow)

This approach requires minimal to no code and integrates directly with Godot's Signal system.

#### 1. Listening for Events (`EventListener`)
1. Add an `EventListener` node to any scene that needs to receive messages.
2. In the Inspector, set the **`Route`** field to your desired event key (e.g., `"player/health_changed"`).
3. Select the `EventListener` node, go to the **Node > Signals** dock, and connect the `message_received(payload)` signal to any function on your receiving node (e.g., updating a Health Bar UI).

#### 2. Sending Events (`EventProducer`)
1. Add an `EventProducer` node to any scene that triggers events.
2. In the Inspector, set the **`Route`** field (e.g., `"player/health_changed"`).
3. *(Optional)* Select a **`Target Node`** under **Payload selector** to enable visual payload extraction:
   - **`Selector Type`**:
     - `PROPERTY`: Select a specific property from `Target Node` to send as the payload.
     - `METHOD`: Select a parameterless method from `Target Node`; its return value will be sent as the payload.
     - `OBJECT`: Sends the `Target Node` object itself as the payload.
   - **`Selected Payload`**: Pick the target property or method from the inspector dropdown.
4. Trigger the event:
   - **Via Editor Signals**: Connect a node's signal (e.g., a `Button`'s `pressed` signal or an `Area2D`'s `body_entered` signal) directly to `EventProducer.publish()`.
   - **Via Code**: Call `$EventProducer.publish(payload)` from a script.

---

### Method 2: Code / Script API Workflow

If you prefer writing pure GDScript without placing extra helper nodes in the scene tree, you can use the global `EventBroker` singleton directly.

#### Publishing Events
```gdscript
# Publish an event with a payload
EventBroker.publish(&"player/health_changed", 80)

# Publish an event without payload
EventBroker.publish(&"game/paused")
```

#### Subscribing to Events
```gdscript
func _ready() -> void:
	# Subscribe a method to a topic route
	EventBroker.subscribe(&"player/health_changed", _on_health_changed)

func _exit_tree() -> void:
	# Always unsubscribe when the node is freed
	EventBroker.unsubscribe(&"player/health_changed", _on_health_changed)

func _on_health_changed(payload: Variant) -> void:
	print("Health updated:", payload)
```

---

## 📖 API Reference

### `EventBroker` (Autoload Singleton)
| Method | Parameters | Description |
| :--- | :--- | :--- |
| `publish` | `route: StringName, payload: Variant = null` | Sends an event to all subscribers listening on `route`. |
| `subscribe` | `route: StringName, callable: Callable` | Registers a callback function for the specified `route`. |
| `unsubscribe` | `route: StringName, callable: Callable` | Removes a callback registration for `route`. |

### `EventProducer` (Node)
| Property / Method | Type | Description |
| :--- | :--- | :--- |
| `route` | `StringName` | Default topic route for messages emitted by this producer. |
| `_target_node` | `Node` | Node used to extract payload data from. |
| `_selector_type` | `SelectorType` (`PROPERTY`, `METHOD`, `OBJECT`) | Specifies how payload data is retrieved from `_target_node`. |
| `_selected_payload` | `StringName` | Property or method name on `_target_node` used as the payload source. |
| `publish()` | `(payload = null, route_override = "")` | Publishes a message to `route` (or `route_override`). Evaluates target node payload if `payload` is `null`. |

### `EventListener` (Node)
| Property / Signal | Type | Description |
| :--- | :--- | :--- |
| `_route` | `String` | Topic route to listen to. Auto-subscribes on enter tree. |
| `message_received` | `signal(payload)` | Emitted when a message is published to `_route`. |

---

## 💡 Best Practices

1. **Consistent Route Naming**: Use organized, namespaced route strings like `"game/state_changed"`, `"ui/score_updated"`, or `"player/died"`.
2. **Use StringNames**: When calling `EventBroker` in script, prefix routes with `&` (e.g., `&"player/health_changed"`) for optimal StringName hashing performance in Godot 4.
3. **Clean Up Manual Subscriptions**: If using `EventBroker.subscribe` directly in GDScript, remember to call `EventBroker.unsubscribe` in `_exit_tree()` to avoid memory leaks or unnecessary calls. (The `EventListener` node handles this automatically!).

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](file:///d:/Documents/GodotProjects/4.7/GodotEventBus/addons/event_bus/LICENSE) file for details.


