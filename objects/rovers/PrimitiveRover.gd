extends Droid

export var fuel_consumption_coeff := 5.0
export var rover_mass_kg := 300.0

onready var root: = $'.'

func consume_fuel()->void:
	fuel_left -= (rover_mass_kg * fuel_consumption_coeff)

func _physics_process(delta: float) -> void:
	if self.is_in_movement:
		consume_fuel()

var is_selected: = false setget set_is_selected
const _selectionScene = preload('res://objects/rovers/RoverSelection.tscn') 
var _selectionInstance 

func set_is_selected(isSelect: bool)->void:
	is_selected = isSelect
	if isSelect:
		if is_instance_valid(_selectionInstance):
			_selectionInstance.queue_free()
		_selectionInstance = _selectionScene.instance()
		root.add_child(_selectionInstance)
	elif is_instance_valid(_selectionInstance):
		_selectionInstance.queue_free()

var is_mouse_hovered: bool = false
func _on_PrimitiveRover_mouse_entered() -> void:
	is_mouse_hovered =true

func _on_PrimitiveRover_mouse_exited() -> void:
	is_mouse_hovered =false

func _on_PrimitiveRover_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var isLeftClick = InputHelper.isLeftClick(event)
	if isLeftClick:
		self.is_selected = not self.is_selected

func _input(event: InputEvent) -> void:
	var isLeftClick = InputHelper.isLeftClick(event)
	if isLeftClick and not is_mouse_hovered:
		selectFollowMeWaypoint()
		return
	var isRightClick = InputHelper.isRightClick(event)
	if isRightClick:
		self.is_selected = false

func selectFollowMeWaypoint()->void:
#	TODO:
	return

