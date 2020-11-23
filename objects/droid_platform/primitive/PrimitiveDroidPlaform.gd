extends Area2D

onready var spriteSelect: = $ui_select
export var enabled = false setget set_enabled
func set_enabled(value):
	enabled = value
	spriteSelect.visible = value
	

func _input_event(viewport, event, shape_idx ) -> void:
	if InputHelper.isLeftClick(event):		
		self.enabled = true
	
func _unhandled_input(event: InputEvent) -> void:
	if enabled && InputHelper.isLeftClick(event):
		_fire_droid()
		return
	if enabled && InputHelper.isRightClick(event):
		 self.enabled = false


func _fire_droid() -> void:
	var target_global_position: = get_global_mouse_position()
	DroidsState.add_droid(target_global_position, global_position)