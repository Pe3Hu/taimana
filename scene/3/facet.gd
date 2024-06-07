extends MarginContainer


#region vars
@onready var mark = $Mark
@onready var power = $Power

var dice = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	dice = input_.dice
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = input_.type
	input.subtype = input_.subtype
	
	for type in Global.arr:
		if input.type == "facet":
			if Global.arr[type].has(input.subtype):
				input.type = type
		else:
			break
	
	mark.set_attributes(input)
	mark.custom_minimum_size = Vector2(Global.vec.size.mark)
	
	input.type = "number"
	input.subtype = input_.value
	power.set_attributes(input)
	power.custom_minimum_size = Vector2(Global.vec.size.power)
	
	custom_minimum_size = Vector2(Global.vec.size.facet)
#endregion


func get_power_value() -> int:
	return power.get_number()


func crush() -> void:
	dice.facets.remove_child(self)
	queue_free()
	#dice.crushs += 1
