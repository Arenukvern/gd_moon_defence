extends KinematicBody2D

class_name BaseDroidModule

onready var projectRoot := $"/root/"

# !!! must be filled with base resourse components !!!
var health_damage_system: HealthDamageSystem = HealthDamageSystem.new()
func reduce_health(points: float) -> void:
	health_damage_system.add_random_damage(points)
	if health_damage_system.health <= 0:
		queue_free()


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
	
const WaypointGd: = preload('res://objects/droids/Waypoint.gd') 
onready var WaypointFactory: WaypointFactory = preload('res://objects/droids/WaypointFactory.gd').new() # Relative path
onready var platformWaypoint = WaypointGd.new()
