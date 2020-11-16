extends Area2D

onready var spriteSelect: = $'ui_select'
export var enabled = false setget set_enabled

func set_enabled(value):
	enabled = value
	spriteSelect.visible = value
	
func _input_event(viewport, event, shape_idx ) -> void:
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT)  or event is InputEventScreenTouch:
		if event.is_pressed():
			self.enabled = not enabled

