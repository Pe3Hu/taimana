extends MarginContainer


#region vars
@onready var stratums = $Stratums
@onready var landslide = $Landslide

var proprietor = null
var type = null
var orientation = null
var subtypes = {}
var values = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size[type]
	size = custom_minimum_size
	
	match type:
		"safety":
			orientation = "vertical"
	
	var input = {}
	input.slope = self
	landslide.set_attributes(input)


func set_subtypes(subtypes_: Dictionary) -> void:
	values.begin = 0
	values.end = 0
	subtypes = {}
	var counter = int(values.begin)
	
	for subtype in subtypes_:
		var begin = int(counter + 1)
		var end = int(counter + subtypes_[subtype])
		subtypes[subtype] = [begin, end]
		counter += subtypes_[subtype] 
		values.end += subtypes_[subtype]
	
	reset_stratums()


func reset_stratums() -> void:
	while stratums.get_child_count() > 0:
		var stratum = stratums.get_child(0)
		stratums.remove_child(stratum)
		stratum.queue_free()
	
	for subtype in subtypes:
		add_stratum(subtype, subtypes[subtype])


func add_stratum(type_: String, values_: Array) -> void:
	if values_.back() > values_.front():
		var input = {}
		input.slope = self
		input.type = type_
		input.values = values_
		
		var stratum = Global.scene.stratum.instantiate()
		stratums.add_child(stratum)
		stratum.set_attributes(input)
#endregion
