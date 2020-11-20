extends KinematicBody2D

class_name Asteroid

export var max_speed:= 300.0
export var DISTANCE_THRESHOLD: = 3.0
export var health_max: = 300.0
export var mass: = 30.0
export var mass_max: = 300.0

onready var _screen_dimension = OS.get_window_size()
onready var _sprite = $body

var _velocity:= Vector2.ZERO
var target_global_position: = Vector2.ZERO
var _health_current: = 0.0
