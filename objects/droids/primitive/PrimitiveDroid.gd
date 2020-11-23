extends Droid

class_name PrimitiveDroid

export var health_max: = 200.0
export var damage_points: = 100.0

export var acceleration_for_landing: = 20.0
export var acceleration_initial: = 100.0
export var acceleration_explosive_min: = 300.0
export var acceleration_explosive_max: = 400.0
# current acceleration
var _acceleration_current: = 0.0
# current random acceleration when player can risk to run plasma
# but it can exlosure if the acceleration_current will be more than
# critical
var _acceleration_explosition: = 0.0
# distance between target position and current position 
# droid should stop
export var DISTANCE_THRESHOLD: = 3.0
export var DISTANCE_LANDING_THRESHOLD: = 100.0

var is_droid_landed: bool = false setget , get_is_droid_landed

func get_is_droid_landed()->bool:
	return global_position.distance_to(landing_global_position) <= DISTANCE_LANDING_THRESHOLD
	
var is_droid_in_platform: bool = false setget , get_is_droid_in_platform
func get_is_droid_in_platform() -> bool:
	return global_position.distance_to(platform_global_position) <= DISTANCE_THRESHOLD
	
var is_droid_in_orbit: bool = false setget , get_is_droid_in_orbit
func get_is_droid_in_orbit() -> bool:
	return global_position.distance_to(orbit_global_position) <= DISTANCE_THRESHOLD
	
var is_droid_going_to_refueling: bool = false setget , get_is_droid_going_to_refueling
func get_is_droid_going_to_refueling() -> bool:
	return target_global_position == platform_global_position
	
var is_tractor_beam_has_objects: bool = false setget , get_is_tractor_beam_has_objects
func get_is_tractor_beam_has_objects()->bool:
	return tractor_beam_objects.size() > 0
	
export var fuel_capacity: = 7000.0
export var fuel_left: = 7000.0
export var fuel_reserve_limit: = 70.0
export var is_drop_droid: = false

# Fuel consumption when droid is not moving
export var idle_fuel_consumption: = 1.0
export var fuel_flying_consumption: = 2.0
export var refueling_consumption: = 100.0
export var debug_is_fuel_infinite: = false
export var is_goto_platform_to_refuel_in_any_cases: = false
onready var root: KinematicBody2D = $'.'

# TRACTOR BEAM SECTION
export var is_tractor_beam_enabled:= false setget set_is_tractor_beam_enabled
const TractorBeamScene: = preload('res://objects/droids/primitive/TractorBeam.tscn')
var _tractorBeam: TractorBeam
var _tractorBeamFuelConsumption: float = 0.0

func set_is_tractor_beam_enabled(isEnable: bool)->void:
	is_tractor_beam_enabled = isEnable
	if isEnable and not is_instance_valid(_tractorBeam):
		_acceleration_current = acceleration_for_landing
		_tractorBeam = TractorBeamScene.instance()
		_tractorBeamFuelConsumption = _tractorBeam.fuel_consumption
		root.call_deferred("add_child",_tractorBeam)
	elif is_instance_valid(_tractorBeam):
		_tractorBeam.queue_free()
		_tractorBeamFuelConsumption = 0.0
		tractor_beam_objects.clear()

# TRACTOR BEAM OBJECT
var tractor_beam_objects: Array = []

# SENSOR SECTION
export var is_short_range_sensor_enabled: = false setget set_is_short_range_sensor_enabled
const ShortRangeSensorScene: = preload('res://objects/droids/primitive/ShortRangeSensor.tscn')
var _shortRangeSensor: ShortRangeSensor 
var _sensorFuelConsumption: float = 0.0

func set_is_short_range_sensor_enabled(isEnable: bool)->void:
	is_short_range_sensor_enabled = isEnable
	if isEnable and not is_instance_valid(_shortRangeSensor):
		_shortRangeSensor = ShortRangeSensorScene.instance()
		_shortRangeSensor.connect(
			_shortRangeSensor.signal_name_enable_tractor_beam, 
			self, 
			_shortRangeSensor.signal_func_name_enable_tractor_beam
		)
		_sensorFuelConsumption = _shortRangeSensor.fuel_consumption
		root.add_child(_shortRangeSensor)
	elif is_instance_valid(_shortRangeSensor):
		_shortRangeSensor.queue_free()
		_sensorFuelConsumption = 0.0

# SELECTIONS 
const DroidSelectionScene: = preload('res://objects/droids/primitive/DroidSelection.tscn')
export var is_droid_selected: bool = false setget set_is_droid_selected
var _droid_selection: DroidSelection 
func set_is_droid_selected(isSelect: bool)->void:
	is_droid_selected = isSelect
	if isSelect:
		_droid_selection = DroidSelectionScene.instance()
		root.add_child(_droid_selection)
		self.are_all_waypoints_shown = true
	elif is_instance_valid(_droid_selection) and _droid_selection != null: 
		self.are_all_waypoints_shown = false
		_droid_selection.queue_free()

export var are_all_waypoints_shown: bool = false setget set_are_all_waypoints_shown
func set_are_all_waypoints_shown(isEnable: bool)->void:
	are_all_waypoints_shown= isEnable
	if isEnable:
		for waypoint in self.waypoints_array:
			var selection: Node = waypoint.waypoint_scene.instance()
			selection.global_position = waypoint.global_position
			$"/root/".add_child(selection)
			_waypoints_selections_array.push_back(selection)
	else :
		for selection in _waypoints_selections_array:
			if is_instance_valid(selection):
				selection.queue_free()
		_waypoints_selections_array.clear()

var _waypoints_selections_array: Array = []

const WaypointGd: = preload('res://objects/droids/Waypoint.gd') 
onready var WaypointFactory: WaypointFactory = preload('res://objects/droids/WaypointFactory.gd').new() # Relative path
onready var platformWaypoint = WaypointGd.new()
onready var orbitWaypoint = WaypointGd.new()
onready var landingWaypoint = WaypointGd.new()

var waypoints_array: Array = [] setget ,get_waypoints_array
func get_waypoints_array()-> Array:
	platformWaypoint.global_position = platform_global_position
	platformWaypoint.waypoint_scene = WaypointFactory.purple
	orbitWaypoint.global_position = orbit_global_position
	orbitWaypoint.waypoint_scene = WaypointFactory.red
	landingWaypoint.global_position = landing_global_position
	landingWaypoint.waypoint_scene = WaypointFactory.yellow
	return [platformWaypoint, orbitWaypoint, landingWaypoint]

# PATH
# platform for refueling 
var platform_global_position:= Vector2.ZERO
# landing asteroids position
var landing_global_position:= Vector2.ZERO
# stationary orbit to catch asteroids position
var orbit_global_position:= Vector2.ZERO
# position to fly
var target_global_position: = Vector2.ZERO
# start position, usually needs to be equal platform position
var initial_position: = Vector2.ZERO

var _previous_global_position: = Vector2.ZERO

# how many px droid already flied
var _total_flying_distance: = 0.0

var _velocity:= Vector2.ZERO

onready var _sprite = $green
onready var _screen_dimension = OS.get_window_size()

var _is_in_movement := false

var is_all_equipment_enabled:bool = false setget set_is_all_equipment_enabled, get_is_all_equipment_enabled

func set_is_all_equipment_enabled(isEnable: bool)->void:
	is_all_equipment_enabled = isEnable
	if isEnable:
		self.is_short_range_sensor_enabled = true
		self.is_tractor_beam_enabled = true
	else:
		self.is_short_range_sensor_enabled = false		
		self.is_tractor_beam_enabled = false
		
func get_is_all_equipment_enabled()->bool:
	return self.is_short_range_sensor_enabled || self.is_tractor_beam_enabled

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

	_check_is_droid_in_target_position()
	
	if not is_drop_droid:
		if fuel_left <= 0 && not debug_is_fuel_infinite:
			_drop_droid()
			return
		elif self.is_droid_in_orbit:
			if not self.is_short_range_sensor_enabled:
				self.is_short_range_sensor_enabled = true
			_eat_idle_fuel()
			_check_and_return_to_refuel()
		elif self.is_droid_landed:
			self.is_all_equipment_enabled = false
			_goto_orbit()
			_eat_idle_fuel()
			_check_and_return_to_refuel()
		elif self.is_droid_in_platform:
			_refuel_droid()
		
		_eat_tractor_beam_fuel()
		
		if fuel_left > 0 && is_tractor_beam_enabled:
			_sync_tractor_beam_object_velocity()
	
	if _is_in_movement:

		move_droid(delta)

		if self.is_droid_going_to_refueling and self.is_all_equipment_enabled:
			self.is_all_equipment_enabled = false
	

func _check_is_droid_in_target_position()->void:
	if global_position.distance_to(target_global_position) <= DISTANCE_THRESHOLD:
		_is_in_movement = false
	else: 
		_is_in_movement = true
	
func move_droid(delta: float)->void:
	#	calculate distance to eat fuel
	_recalculate_distances_and_eat_fuel()
	
	_velocity = Steering.follow(
		_velocity,
		global_position,
		target_global_position,
		_acceleration_current
	)
	_velocity = move_and_slide(_velocity)
	_sprite.rotation = _velocity.angle()
	
# recalculates already made distance and distance left
# before fuel will go out
func _recalculate_distances_and_eat_fuel()->void:
	var dx: float = global_position.x - _previous_global_position.x
	var dy: float = global_position.y - _previous_global_position.y
	var distance: float = round(sqrt(dx*dx + dy*dy))
	fuel_left -= distance * fuel_flying_consumption
	_total_flying_distance += distance
	_previous_global_position = global_position


# fall droid to the ground
func _drop_droid()->void:
	self.is_all_equipment_enabled = false
	randomize()
	target_global_position = Vector2(global_position.x, _screen_dimension.y)
	_acceleration_current = acceleration_initial
	tractor_beam_objects.clear()
	is_drop_droid = true

func _to_land_droid()->void:
	target_global_position = landing_global_position
	
func _eat_idle_fuel()-> void:
	fuel_left -= idle_fuel_consumption
	if self.is_short_range_sensor_enabled:
		fuel_left -= _sensorFuelConsumption

func _sync_tractor_beam_object_velocity()->void:
	for tractorObject in tractor_beam_objects:
		if tractorObject is Asteroid:
			tractorObject.max_speed = _acceleration_current
			tractorObject._velocity = _velocity

func _on_enable_tractor_beam(collisionObject: PhysicsBody2D) -> void:
	if collisionObject is Asteroid and is_instance_valid(collisionObject):
		self.is_tractor_beam_enabled = true
		collisionObject.target_global_position = landing_global_position
		tractor_beam_objects.push_back(collisionObject)
		_tractorBeam.rotation = collisionObject._velocity.angle()
		_to_land_droid()

func _eat_tractor_beam_fuel():

	if self.is_tractor_beam_enabled:
		var totalAseroidMass := 0.0
		if tractor_beam_objects.size() <= 0:
			self.is_tractor_beam_enabled = false
			return
		for tractorObject in tractor_beam_objects:
			if tractorObject is Asteroid:
				var asteroidMass: float = tractorObject.get('mass')
				totalAseroidMass += asteroidMass

		fuel_left -= _tractorBeamFuelConsumption + TractorBeam.calculate_fuel_consumtion_for_mass(totalAseroidMass)
	
func _check_and_return_to_refuel() -> void:
# if we have an asteroid catched we cannot return 
# to base, as we need to land it first
	if fuel_left <= 0:
		return 
	elif not is_goto_platform_to_refuel_in_any_cases and self.is_tractor_beam_has_objects:
		return 
	elif self.is_droid_going_to_refueling:
		return 
	elif self.is_droid_in_platform:
		return 
	
#	calculate distance to platform and find out how many
#	fuel it will take
	var distanceToPlatform = global_position.distance_to(platform_global_position)
	var expectedFuelConsumption = distanceToPlatform * fuel_flying_consumption
	if fuel_left <= expectedFuelConsumption + fuel_reserve_limit:
#		reroute to platform
		self.is_all_equipment_enabled = false
		target_global_position = platform_global_position
		_acceleration_current = acceleration_initial

func _refuel_droid() -> void:
	if fuel_left >= fuel_capacity:
		fuel_left = fuel_capacity
		_goto_orbit()
	else:
		fuel_left += refueling_consumption

func _goto_orbit() -> void:
	target_global_position = orbit_global_position
	_acceleration_current = acceleration_initial


func _on_PrimitiveDroid_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var isLeftClick = InputHelper.isLeftClick(event)
	if isLeftClick:
		self.is_droid_selected = not self.is_droid_selected
