extends BaseDroidModule

onready var spriteSelect: = $ui_select
export var enabled = false setget set_enabled
func set_enabled(value):
	enabled = value
	spriteSelect.visible = value

func _unhandled_input(event: InputEvent) -> void:
	if enabled:
		if (not isMouseOver) && InputHelper.isLeftClick(event) :
			_fire_droid()
			return
		if InputHelper.isRightClick(event):
			 self.enabled = false

func _fire_droid() -> void:
	var droid_global_position: = get_global_mouse_position()
	DroidsState.add_droid(droid_global_position, global_position)

func _on_PrimitiveDroidPlatform_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if InputHelper.isLeftClick(event):
		self.enabled = not self.enabled

var isMouseOver:bool = false

func _on_PrimitiveDroidPlatform_mouse_entered() -> void:
	isMouseOver =true

func _on_PrimitiveDroidPlatform_mouse_exited() -> void:
	isMouseOver =false
