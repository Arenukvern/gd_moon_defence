extends Node

class_name UIState

signal debug_menu_state_updated(enabled)

onready var root: = get_tree().get_root()

var current_scene = null

func _ready():
    var root = get_tree().get_root()
    current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
    # This function will usually be called from a signal callback,
    # or some other function in the current scene.
    # Deleting the current scene at this point is
    # a bad idea, because it may still be executing code.
    # This will result in a crash or unexpected behavior.

    # The solution is to defer the load to a later time, when
    # we can be sure that no code from the current scene is running:

    call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
    # It is now safe to remove the current scene
    current_scene.free()

    # Load the new scene.
    var s = ResourceLoader.load(path)

    # Instance the new scene.
    current_scene = s.instance()

    # Add it to the active scene, as child of root.
    root.add_child(current_scene)

    # Optionally, to make it compatible with the SceneTree.change_scene() API.
    get_tree().set_current_scene(current_scene)


onready var waypointsLayer: = root.get_node("/root/WaypointsState")
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


func openMainMenu()->void:
	self.goto_scene('res://ui/MainMenu.tscn')
	
