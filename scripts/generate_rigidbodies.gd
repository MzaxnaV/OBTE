extends TileMap

@onready var root_node = %RB_Gen

func _ready():
	var cells = get_used_cells(0)
	
	var template_box = create_rigidbody_box(Vector2(32, 32), false, true)
	
	for cell in cells:
		var meta_data = get_cell_tile_data(0, Vector2i(cell.x, cell.y))
		var custom_data = meta_data.get_custom_data("type") 
		if (custom_data == 2):
			var box = template_box.duplicate()
			var pos = Vector2i(cell.x, cell.y)
			set_cell(0, pos)
			box.position = 32 * pos
			box.name = "box_%02d_%02d" % [cell.x, cell.y]
			root_node.add_child(box)
	template_box.queue_free()
	
func create_rigidbody_box(size, pickable = false, use_icon = false, shape_transform = Transform2D.IDENTITY):
	var shape = RectangleShape2D.new()
	shape.size = size

	var body = create_rigidbody(shape, pickable, shape_transform)

	if use_icon:
		var texture = load("res://assets/block.png")
		var icon = Sprite2D.new()
		icon.texture = texture
		icon.scale = size / texture.get_size()
		body.add_child(icon)

	return body

func create_rigidbody(shape, pickable = false, shape_transform = Transform2D.IDENTITY):
	var collision = CollisionShape2D.new()
	collision.shape = shape
	collision.transform = shape_transform

	var body = RigidBody2D.new()
	body.add_child(collision)

	if pickable:
		var script = load("res://scripts/rigidbody_pick.gd")
		body.set_script(script)

	return body
