extends KinematicBody2D

class_name Droid
export var DISTANCE_THRESHOLD: = 3.0
var target_global_position: = Vector2.ZERO
# start position, usually needs to be equal platform position
var initial_position: = Vector2.ZERO

var is_in_movement := false setget ,set_is_in_movement

func set_is_in_movement()->bool:
	return global_position.distance_to(target_global_position) <= DISTANCE_THRESHOLD

export var fuel_capacity: = 15000.0
export var fuel_left: = 15000.0