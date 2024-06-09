extends MarginContainer


#region vars
@onready var totem = $HBox/Totem
@onready var gold = $HBox/Gold

var camp = null
var god = null
var appraisals = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	camp = input_.camp
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()
	init_appraisals()


func init_tokens() -> void:
	var input = {}
	input.proprietor = self
	input.type = "totem"
	input.subtype = camp.planet.totems.pick_random()
	totem.set_attributes(input)
	totem.custom_minimum_size = Global.vec.size.chest
	camp.planet.totems.erase(input.subtype)
	
	input.type = "reward"
	input.subtype = "gold"
	input.value = 0
	gold.set_attributes(input)
	#gold.designation.custom_minimum_size = Global.vec.size.token


func init_appraisals() -> void:
	for appraisal in Global.arr.appraisal:
		appraisals[appraisal] = {}
		
		for rank in Global.dict.appraisal.rank:
			var description = Global.dict.appraisal.rank[rank].appraisal[appraisal]
			appraisals[appraisal][rank] = [description.min, description.max]
#endregion


func get_appraisal_rank(subtype_: String, value_: int) -> Variant:
	for rank in appraisals[subtype_]:
		var limits = appraisals[subtype_][rank]
		
		if value_ >= limits.front() and value_ <= limits.back():
			return rank
	
	return null
