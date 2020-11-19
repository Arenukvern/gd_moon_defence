extends KinematicBody2D

export var health_max: = 200.0
export var damage_points: = 100.0
export var acceleration_initial: = 100.0
export var acceleration_explosive_min: = 300.0
export var acceleration_explosive_max: = 400.0
export var DISTANCE_THRESHOLD: = 3.0
export var fuel_capacity: = 2000.0
export var fuel_left: = 1000.0
export var is_drop_droid: = false
# Fuel consumption when droid is not moving
export var idle_fuel_consumption: = 1.0

var target_global_position: = Vector2.ZERO
var initial_position: = Vector2.ZERO
var _previous_global_position: = Vector2.ZERO
# current acceleration
var _acceleration_current: = 0.0
# how many px droid already flied
var _total_flying_distance: = 0.0

# current random acceleration when player can risk to run plasma
# but it can exlosure if the acceleration_current will be more than
# critical
var _acceleration_explosition: = 0.0
var _velocity:= Vector2.ZERO

onready var _sprite = $green
onready var _screen_dimension = OS.get_window_size()

func _ready() -> void:
	randomize()
	_acceleration_explosition = rand_range(acceleration_explosive_min, acceleration_explosive_max)
	global_position = initial_position
	_previous_global_position = initial_position
	_acceleration_current = acceleration_initial
	

func _physics_process(delta: float) -> void:
	if target_global_position == Vector2.ZERO or _acceleration_current >= _acceleration_explosition: 
		queue_free()
#		TODO: make explosition
	if not is_drop_droid && fuel_left <= 0:
		_drop_droid()
		return
		
	if global_position.distance_to(target_global_position) < DISTANCE_THRESHOLD :
		#		stopping droid
		_eat_idle_fuel()
		return
	_velocity = Steering.follow(
		_velocity,
		global_position,
		target_global_position,
		_acceleration_current
	)
	_velocity = move_and_slide(_velocity)
	_sprite.rotation = _velocity.angle()
	
#	calculate distance to eat fuel
	_recalculate_distances()
	
# recalculates already made distance and distance left
# before fuel will go out
func _recalculate_distances()->void:
	var dx: float = global_position.x - _previous_global_position.x
	var dy: float = global_position.y - _previous_global_position.y
	var distance: float = round(sqrt(dx*dx + dy*dy))
	fuel_left -= distance
	_total_flying_distance += distance
	_previous_global_position = global_position


# fall droid to the ground
func _drop_droid()->void:
	randomize()
	target_global_position = Vector2(global_position.x, _screen_dimension.y)
	is_drop_droid = true
	
	
func _eat_idle_fuel()-> void:
	fuel_left -= idle_fuel_consumption
	print(fuel_left)
		