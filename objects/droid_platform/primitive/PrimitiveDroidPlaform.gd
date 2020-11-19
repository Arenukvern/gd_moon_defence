extends Area2D

onready var spriteSelect: = $ui_select
export var enabled = false setget set_enabled

func set_enabled(value):
	enabled = value
	spriteSelect.visible = value
	
func check_is_button_left_click(event: InputEvent)-> bool:
	var isLeftClick = (event is InputEventMouseButton and event.button_index == BUTTON_LEFT)  or event is InputEventScreenTouch 
	return isLeftClick && event.is_pressed()
	
func _input(event: InputEvent) -> void:
	if enabled && check_is_button_left_click(event):
		_fire_droid()
		
	
func _input_event(viewport, event, shape_idx ) -> void:
	if check_is_button_left_click(event):		
		self.enabled = not enabled
			

func _fire_droid() -> void:
	var target_global_position: = get_global_mouse_position()
	DroidsState.add_droid(target_global_position, global_position)