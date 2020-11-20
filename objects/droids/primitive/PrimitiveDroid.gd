extends KinematicBody2D

export var health_max: = 200.0
export var damage_points: = 100.0

export var acceleration_for_landing: = 20.0
export var acceleration_initial: = 100.0
export var acceleration_explosive_min: = 300.0
export var acceleration_explosive_max: = 400.0
export var DISTANCE_THRESHOLD: = 3.0
export var fuel_capacity: = 2000.0
export var fuel_left: = 7000.0
export var is_drop_droid: = false
# Fuel consumption when droid is not moving
export var idle_fuel_consumption: = 1.0
export var debug_is_fuel_infinite: = false
onready var root: KinematicBody2D = $'.'

# TRACTOR BEAM SECTION
export var is_tractor_beam_enabled:= false setget set_is_tractor_beam_enabled
const TractorBeam: = preload('res://objects/droids/primitive/TractorBeam.tscn')
var _tractorBeam: Area2D
var _tractorBeamFuelConsumption: float = 0.0
func set_is_tractor_beam_enabled(isEnable: bool)->void:
	is_tractor_beam_enabled = isEnable
	if isEnable:
		_acceleration_current = acceleration_for_landing
		_tractorBeam = TractorBeam.instance()
		_tractorBeamFuelConsumption = _tractorBeam.fuel_consumption
		root.call_deferred("add_child",_tractorBeam)
	elif _tractorBeam != null:
		_tractorBeam.queue_free()
		_tractorBeamFuelConsumption = 0.0
		

# TRACTOR BEAM OBJECT
var tractor_beam_object: PhysicsBody2D

# SENSOR SECTION
export var is_short_range_sensor_enabled: = false setget set_is_short_range_sensor_enabled
const ShortRangeSensor: = preload('res://objects/droids/primitive/ShortRangeSensor.tscn')
var _shortRangeSensor: Area2D 
var _sensorFuelConsumption: float = 0.0

func set_is_short_range_sensor_enabled(isEnable: bool)->void:

	if isEnable && not is_short_range_sensor_enabled:
		is_short_range_sensor_enabled = isEnable
		_shortRangeSensor = ShortRangeSensor.instance()
		_shortRangeSensor.connect(
			_shortRangeSensor.signal_name_enable_tractor_beam, 
			self, 
			_shortRangeSensor.signal_func_name_enable_tractor_beam
		)
		_sensorFuelConsumption = _shortRangeSensor.fuel_consumption
		root.add_child(_shortRangeSensor)
		return
	elif _shortRangeSensor != null:
		_shortRangeSensor.queue_free()
		_sensorFuelConsumption = 0.0
	is_short_range_sensor_enabled = isEnable
	

var landing_global_position:= Vector2.ZERO
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
	landing_global_position =  Vector2(rand_range(10, _screen_dimension.x),_screen_dimension.y)
	global_position = initial_position
	_previous_global_position = initial_position
	_acceleration_current = acceleration_initial
	

func _physics_process(delta: float) -> void:
	if _acceleration_current >= _acceleration_explosition: 
		queue_free()
#		TODO: make explosition
	if not is_drop_droid && fuel_left <= 0 && not debug_is_fuel_infinite:
		self.is_short_range_sensor_enabled = false
		_drop_droid()
		return
		
	if global_position.distance_to(target_global_position) < DISTANCE_THRESHOLD :
		#		stopping droid
		if not is_short_range_sensor_enabled:
			self.is_short_range_sensor_enabled = true
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
	_eat_tractor_beam_fuel()
#	calculate distance to eat fuel
	_recalculate_distances()
	if fuel_left > 0 && is_tractor_beam_enabled:
		_sync_tractor_beam_object_velocity()	
	
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
	_acceleration_current = acceleration_initial
	self.is_tractor_beam_enabled = false
	self.is_short_range_sensor_enabled = false
	tractor_beam_object = null
	is_drop_droid = true

func _to_land_droid()->void:
	target_global_position = landing_global_position
	
	
func _eat_idle_fuel()-> void:
	fuel_left -= idle_fuel_consumption
	if self.is_short_range_sensor_enabled:
		fuel_left -= _sensorFuelConsumption

func _sync_tractor_beam_object_velocity()->void:
	if tractor_beam_object is Asteroid:
		tractor_beam_object.max_speed = _acceleration_current
		tractor_beam_object._velocity = _velocity

func _on_enable_tractor_beam(collisionObject: PhysicsBody2D) -> void:
	self.is_tractor_beam_enabled = true
	tractor_beam_object = collisionObject
	if tractor_beam_object is Asteroid:
		_to_land_droid()
		tractor_beam_object.target_global_position = target_global_position
		_tractorBeam.rotation = tractor_beam_object._velocity.angle()
	else:
		self.is_tractor_beam_enabled = false
		
func _eat_tractor_beam_fuel():
	if is_tractor_beam_enabled:
		if tractor_beam_object == null:
			self.is_tractor_beam_enabled = false
		elif tractor_beam_object is Asteroid :
			var object_mass: float = tractor_beam_object.get('mass')
			fuel_left -= _tractorBeamFuelConsumption + _tractorBeam.calculate_fuel_consumtion_for_mass(object_mass)
	
