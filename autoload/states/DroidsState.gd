extends Node

onready var root: Node = $'.'
export var acceleration_initial: = 300.0
export var acceleration_explosive_max: = 600.0
export var acceleration_explosive_min: = 400.0
const droid: = preload('res://objects/droids/primitive/PrimitiveDroid.tscn')

func add_droid(targetGlobalPosition: Vector2, initialPosition: Vector2) -> void:
	var droidInstance: = droid.instance()
	droidInstance.initial_position =  initialPosition
	droidInstance.platform_global_position = initialPosition
	droidInstance.orbit_global_position = targetGlobalPosition
	
	droidInstance.target_global_position = droidInstance.orbit_global_position
	
	droidInstance.acceleration_explosive_max = acceleration_explosive_max
	droidInstance.acceleration_explosive_min = acceleration_explosive_min
	droidInstance.acceleration_initial = acceleration_initial
	root.add_child(droidInstance)