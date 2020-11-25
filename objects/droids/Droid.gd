extends KinematicBody2D

class_name Droid

onready var projectRoot := $"/root/"

export var health_max: = 200.0
export var mass_kg: = 10.0
export var DISTANCE_THRESHOLD: = 3.0
var target_global_position: = Vector2.ZERO
var _previous_global_position: = Vector2.ZERO
# start position, usually needs to be equal platform position
var initial_position: = Vector2.ZERO
var _velocity:= Vector2.ZERO
export var fuel_capacity: = 15000.0
export var fuel_left: = 15000.0
export var refueling_consumption: = 100.0
export var debug_is_fuel_infinite: = false
var is_in_movement := false setget ,get_is_in_movement

func get_is_in_movement()->bool:
	return global_position.distance_to(target_global_position) > DISTANCE_THRESHOLD

var is_droid_in_target := false setget , get_is_droid_in_target
func get_is_droid_in_target()->bool:
	return not self.is_in_movement

# platform for refueling 
var platform_global_position:= Vector2.ZERO
export var DISTANCE_PLATFORM_THRESHOLD: = 50.0
var is_droid_in_platform: bool = false setget , get_is_droid_in_platform
func get_is_droid_in_platform() -> bool:
	return global_position.distance_to(platform_global_position) <= DISTANCE_PLATFORM_THRESHOLD

const WaypointGd: = preload('res://objects/droids/Waypoint.gd') 
onready var WaypointFactory: WaypointFactory = preload('res://objects/droids/WaypointFactory.gd').new() # Relative path
onready var platformWaypoint = WaypointGd.new()


