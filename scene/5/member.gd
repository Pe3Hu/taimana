extends MarginContainer


#region vars
@onready var bg = $BG
@onready var totem = $HBox/Totem
@onready var gold = $HBox/Gold
@onready var hazard = $HBox/Appraisals/Hazard
@onready var remnant = $HBox/Appraisals/Remnant
@onready var trophy = $HBox/Appraisals/Trophy

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
	
	for subtype in Global.arr.appraisal:
		input.type = "appraisal"
		input.subtype = subtype
		
		var appraisal = get(subtype)
		appraisal.set_attributes(input)
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


func update_appraisal(subtype_: String) -> void:
	var value = chest.camp.cave.route.get(subtype_)
	
	match subtype_:
		"hazard":
			pass
		"remnant":
			pass
		"trophy":
			value = gold.get_value() - value
	
	var rank = chest.get_appraisal_rank(subtype_, value)
	var appraisal = get(subtype_)
	appraisal.set_value(rank)
