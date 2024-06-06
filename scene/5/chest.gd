extends MarginContainer


#region vars
@onready var totem = $HBox/Totem
@onready var gold = $HBox/Gold

var camp = null
var god = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	camp = input_.camp
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()


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
#endregion
