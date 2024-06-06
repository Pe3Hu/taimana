extends MarginContainer


#region vars
@onready var stratums = $Stratums

var proprietor = null
var type = null
var orientation = null
var total = 0
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_stratums()


func init_stratums() -> void:
	custom_minimum_size = Global.vec.size[type]
	size = custom_minimum_size
	var subtypes = {}
	
	match type:
		"safety":
			orientation = "vertical"
			subtypes.success = [1, 70]
			subtypes.failure = [71, 100]
	
	for subtype in subtypes:
		total += subtypes[subtype].back() - subtypes[subtype].front()
	
	for subtype in subtypes:
		add_stratum(subtype, subtypes[subtype])


func add_stratum(type_: String, values_: Array) -> void:
	var input = {}
	input.slope = self
	input.type = type_
	input.values = values_
	
	var stratum = Global.scene.stratum.instantiate()
	stratums.add_child(stratum)
	stratum.set_attributes(input)
#endregion
