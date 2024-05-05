extends TileMap

@onready var root_node = %RB_Gen

@export var physics_obj: PackedScene

func _ready():
	var cells = get_used_cells(0)

	for cell in cells:
		var meta_data = get_cell_tile_data(0, Vector2i(cell.x, cell.y))
		var custom_data = meta_data.get_custom_data("type") 
		if (custom_data == 2):
			var box = physics_obj.instantiate() as PhysicsObj
			var pos = Vector2i(cell.x, cell.y)
			set_cell(0, pos)
			box.init(custom_data, pos, "box_%02d_%02d" % [cell.x, cell.y], root_node)
