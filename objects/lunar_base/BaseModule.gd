extends KinematicBody2D

export var glassHealth: = 4000.0
export var metalHealth: = 4000.0

var debug_is_selection_disabled: bool = true

func add_damage(massDistancePoints: int):
	metalHealth -= massDistancePoints/2
	glassHealth -= massDistancePoints/2

func recover_points(metal: int =0, glass: int =0)->void:
	metalHealth += metal
	glassHealth += glass
onready var root: = $'.'

const ModuleSelectionScene: = preload('res://objects/lunar_base/ModuleSelection.tscn')
var _module_selection: Area2D
var is_module_selected: bool = false setget set_is_module_selected
func set_is_module_selected(isSelect: bool)->void:
	is_module_selected = isSelect
	if isSelect:
		_module_selection = ModuleSelectionScene.instance()
		root.add_child(_module_selection)
	elif not isSelect and is_instance_valid(_module_selection):
		_module_selection.queue_free()

func _on_BaseModule_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if debug_is_selection_disabled: return
	var isLeftClick = InputHelper.isLeftClick(event)
	if isLeftClick:
		self.is_module_selected = not self.is_module_selected
