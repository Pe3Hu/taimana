extends MarginContainer


#region vars
@onready var bg = $BG
@onready var totem = $HBox/Totem
@onready var gold = $HBox/Gold

var chest = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	chest = input_.chest
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_tokens()


func init_tokens() -> void:
	var input = {}
	input.proprietor = self
	input.type = "totem"
	input.subtype = chest.totem.subtype
	totem.set_attributes(input)
	totem.custom_minimum_size = Global.vec.size.member
	
	input.type = "reward"
	input.subtype = "gold"
	input.value = 0
	gold.set_attributes(input)
#endregion


#region gold treatment
func get_gold() -> Variant:
	return gold.value.get_number()


func change_gold(gold_: Variant) -> void:
	gold.value.change_number(gold_)
	
	if !gold.visible:
		gold.visible = true


func set_gold(gold_: Variant) -> void:
	gold.value.set_number(gold_)
	
	if !gold.visible:
		gold.visible = true
#endregion

