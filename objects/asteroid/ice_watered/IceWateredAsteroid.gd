extends KinematicBody2D

onready var sprite: = $"."

export var max_speed:= 300.0
onready var _screen_dimension = OS.get_window_size()
var _velocity:= Vector2.ZERO
var _target_global_position: = Vector2.ZERO

func _ready() -> void:
	randomize()
	var start_x_position: = rand_range( -10,  _screen_dimension.x)
#	sprite.position = 
	global_position = Vector2(start_x_position, -50)
	print(start_x_position)
	var target_x_position: = rand_range( 1,  _screen_dimension.x)
	_target_global_position = Vector2(target_x_position,_screen_dimension.y)

func _physics_process(delta: float) -> void:
	_velocity = Steering.follow(
		_velocity,
		global_position,
		_target_global_position,
		max_speed
	)
	_velocity = move_and_slide(_velocity)

