extends HBoxContainer

onready var root: Node = $'.'
export var is_spawn_enabled: bool= false setget set_is_spawn_enabled
onready var checkButton: CheckButton = get_node('SpawnAsteroidMouseClickCheckButton')

func set_is_spawn_enabled(isEnable:bool)->void:
	is_spawn_enabled = isEnable
	checkButton.pressed = isEnable

func _ready() -> void:
	self.is_spawn_enabled = false


func check_is_button_left_click(event: InputEvent)-> bool:
	var isLeftClick = (event is InputEventMouseButton and event.button_index == BUTTON_LEFT)  or event is InputEventScreenTouch 
	return isLeftClick and event.is_pressed()
	
func _unhandled_input(event: InputEvent) -> void:
	if self.is_spawn_enabled:
		var isLeftClick = check_is_button_left_click(event)
		if isLeftClick:
			AsteroidsState.add_asteroid(get_global_mouse_position())

func _on_SpawnAsteroidMouseClickCheckButton_button_up() -> void:
	self.is_spawn_enabled = not is_spawn_enabled

func _on_SpawnAsteroidToMouseClickButton_button_up() -> void:
	self.is_spawn_enabled = not is_spawn_enabled
