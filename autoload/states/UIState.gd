extends Node

class_name UIState

signal debug_menu_state_updated(enabled)

onready var waypointsLayer = $'/root/MoonFlat/WaypointsManagerLayer'
const WaypointsManagerScene: = preload('res://ui/WaypointsManager.tscn')
var waypointManager: Node
const signal_name_debug_menu_state_updated: = 'debug_menu_state_updated'
const signal_func_name_debug_menu_state_updated: = "_on_%s" % signal_name_debug_menu_state_updated

var isDebugMenuOpen:= false setget set_isDebugMenuOpen

func set_isDebugMenuOpen(value: bool) -> void:
	isDebugMenuOpen = value
	emit_signal(signal_name_debug_menu_state_updated,value)

var isWaypointsManagerOpen: bool = false setget set_isWaypointsManagerOpen

func set_isWaypointsManagerOpen(isEnable: bool)->void:
	isWaypointsManagerOpen = isEnable
	if isEnable :
		if is_instance_valid(waypointManager) and waypointManager is WaypointsManager:
			waypointManager.closeSelected()
			waypointManager.queue_free()
			
		waypointManager = WaypointsManagerScene.instance()
		waypointManager.connect(
			waypointManager.signal_name_close_waypoints_selection,
			self,
			waypointManager.signal_func_name_close_waypoints_selection
		)
		waypointsLayer.add_child(waypointManager)
	elif not isEnable and is_instance_valid(waypointManager):
		waypointManager.queue_free()

func _on_close_waypoints_selection()->void:
	self.isWaypointsManagerOpen = false
