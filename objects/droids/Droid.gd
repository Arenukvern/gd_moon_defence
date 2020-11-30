extends BaseDroidModule

class_name Droid


# platform for refueling 
var platform_global_position:= Vector2.ZERO
export var DISTANCE_PLATFORM_THRESHOLD: = 50.0
var is_droid_in_platform: bool = false setget , get_is_droid_in_platform
func get_is_droid_in_platform() -> bool:
	return global_position.distance_to(platform_global_position) <= DISTANCE_PLATFORM_THRESHOLD

func _init_healthComponents()->void:
	var oxygenResource: = BaseResourceFactory.getOxygen(mass_kg)
	var titaniumResource: = BaseResourceFactory.getTitanium(mass_kg)
	health_damage_system.initSystem([oxygenResource,titaniumResource])


