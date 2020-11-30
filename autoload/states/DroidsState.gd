extends Node

onready var root: Node = $'.'

export var acceleration_initial: = 300.0
export var acceleration_explosive_max: = 600.0
export var acceleration_explosive_min: = 400.0
const droid: = preload('res://objects/droids/primitive/PrimitiveDroid.tscn')
export var maxDroidsQuantity: = 5.0
var currentDroidsQuantity: = 0.0 setget ,get_currentDroidsQuantity
signal droids_on_air_updated
const signal_name_droids_on_air_updated: = 'droids_on_air_updated'
const signal_func_name_droids_on_air_updated: = "_on_%s" % signal_name_droids_on_air_updated
	
func get_currentDroidsQuantity()->float:
	var newSize= float(root.get_children().size())
	return newSize

func add_droid(targetGlobalPosition: Vector2, initialPosition: Vector2) -> void:
	if self.currentDroidsQuantity == maxDroidsQuantity:
#		TODO: add warning
		return
	var droidInstance: = droid.instance()
	droidInstance.initial_position =  initialPosition
	droidInstance.platform_global_position = initialPosition
	droidInstance.orbit_global_position = targetGlobalPosition
	
	droidInstance.target_global_position = droidInstance.orbit_global_position
	
	droidInstance.acceleration_explosive_max = acceleration_explosive_max
	droidInstance.acceleration_explosive_min = acceleration_explosive_min
	droidInstance.acceleration_initial = acceleration_initial
	root.add_child(droidInstance)
	notifyDroidsOnAirUpdated()

func clearChildren()->void:
	for child in root.get_children():
		child.free()

	call_deferred('notifyDroidsOnAirUpdated')
	
func notifyDroidsOnAirUpdated()->void:
	emit_signal(signal_name_droids_on_air_updated)