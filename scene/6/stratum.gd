extends Polygon2D


#region vars
@onready var probability = $Probability

var slope = null
var type = null
var values = null
var extent = null
var center = Vector2()
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	slope = input_.slope
	type = input_.type
	values = input_.values
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_vertexs()
	init_icons()
	color = Global.color.result[type]


func init_vertexs() -> void:
	var lengths = Vector2(slope.size)
	extent = values.back() - values.front() + 1
	
	match slope.orientation:
		"vertical":
			lengths.y = float(lengths.y) / slope.values.end * extent
			position.y = float(values.front() - 1) / slope.values.end * slope.size.y
		"horizontal":
			lengths.x = lengths.x / slope.values.end * extent
			position.x = float(values.front() - 1) / slope.values.end * slope.size.x
	
	var vertexs = []
	
	for direction in Global.dict.direction.zero:
		var vertex = Vector2(direction) * lengths
		vertexs.append(vertex)
		center += vertex
	
	center /= vertexs.size()
	set_polygon(vertexs)


func init_icons() -> void:
	var input = {}
	input.proprietor = self
	input.type = "number"
	input.subtype = ceil(float(extent) * 100 / (slope.values.end - slope.values.begin))
	probability.set_attributes(input)
	
	var l = min(slope.size.x, slope.size.y)
	probability.custom_minimum_size = Vector2.ONE * l
	probability.position = center - probability.custom_minimum_size / 2
	
	var font_size = Global.dict.font.size["probability"]
	probability.number.set("theme_override_font_sizes/font_size", font_size)
#endregion
