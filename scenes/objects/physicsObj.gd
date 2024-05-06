extends RigidBody2D

# parts taken from https://github.com/SoloByte/godot-polygon2d-fracture

class_name PhysicsObj

@export var fracture_body: PackedScene

@export var health: int = 1
@export var cuts : int = 2
@export var min_area : int = 25

var _root: Node

var id: int
var _rng = Globals._rng

var should_free = false

func init(type: int, pos: Vector2, obj_name: String, root: Node) -> void:
	id = type
	name = obj_name
	position = 32 * pos
	_root = root
	root.add_child(self)

func _physics_process(_delta) -> void:
	if (health < 0) and !should_free:
		destroy()
		fracture()

func destroy() -> void:
	should_free = true
	queue_free()

func damage(amount: int) -> void:
	health -= amount
	# TODO: change colour to denote damage

func fracture() -> void:
	var source = get_child(1) as Polygon2D

	var fracture_info = fractureSimple(source.polygon, global_transform, cuts, min_area)

	for entry in fracture_info:
		var texture_info : Dictionary = {"texture" : source.texture, "rot" : source.texture_rotation, "offset" : source.texture_offset, "scale" : source.texture_scale}
		spawnFractureBody(entry, texture_info)

#all fracture functions return an array of dictionaries -> where the dictionary is 1 fracture shard (see func makeShapeInfo) -------------------------------------

#fracture simple generates random cut lines around the bounding box of the polygon -> cut_number is the amount of lines generated
#cut_number is capped at 32 because cut_number is not equal to the amount of shards generated -> 32 cuts can produce a lot of fracture shards
func fractureSimple(source_polygon : PackedVector2Array, source_global_trans : Transform2D, cut_number : int, min_discard_area : float) -> Array:
	cut_number = clamp(cut_number, 0, 32)
#	source_polygon = PolygonLib.rotatePolygon(source_polygon, world_rot_rad)
	var bounding_rect : Rect2 = PolygonLib.getBoundingRect(source_polygon)
	var cut_lines : Array = getCutLines(bounding_rect, cut_number)
	
	var polygons : Array = [source_polygon]
	
	for line in cut_lines:
		var poly_line = PolygonLib.offsetPolyline(line, 0.1, true)[0]
		var new_polies : Array = []
		for poly in polygons:
			var result : Array = PolygonLib.clipPolygons(poly, poly_line, true)
			new_polies += result
		
		polygons.clear()
		polygons += new_polies
	
	var fracture_info : Array = []
	for poly in polygons:
		var triangulation : Dictionary = PolygonLib.triangulatePolygon(poly, true, true)
		
		if triangulation.area > min_discard_area:
			var shape_info : Dictionary = PolygonLib.getShapeInfoSimple(source_global_trans, poly, triangulation)
			fracture_info.append(shape_info)
	
	return fracture_info

#returns an array of PoolVector2Arrays -> each PoolVector2Array consists of two Vector2 [start, end]
#is used in the func fractureSimple
func getCutLines(bounding_rect : Rect2, number : int) -> Array:
	var corners : Dictionary = PolygonLib.getBoundingRectCorners(bounding_rect)
	
	var horizontal_pair : Dictionary = {"left" : [corners.A, corners.D], "right" : [corners.B, corners.C]}
	var vertical_pair : Dictionary = {"top" : [corners.A, corners.B], "bottom" : [corners.D, corners.C]}
	
	var lines : Array = []
	for i in range(number):
		
		if _rng.randf() < 0.5:#horizontal
			var start : Vector2 = lerp(horizontal_pair.left[0], horizontal_pair.left[1], _rng.randf())
			var end : Vector2 = lerp(horizontal_pair.right[0], horizontal_pair.right[1], _rng.randf())
			var line : PackedVector2Array = [start, end]
			lines.append(line)
		else:#vertical
			var start : Vector2 = lerp(vertical_pair.top[0], vertical_pair.top[1], _rng.randf())
			var end : Vector2 = lerp(vertical_pair.bottom[0], vertical_pair.bottom[1], _rng.randf())
			var line : PackedVector2Array = [start, end]
			lines.append(line)
	
	return lines

func spawnFractureBody(fracture_shard : Dictionary, texture_info : Dictionary) -> void:
	var instance = fracture_body.instantiate()
	if not instance: 
		return
	
	instance.init(fracture_shard.spawn_pos, _root)
	instance.global_rotation = fracture_shard.spawn_rot
	if instance.has_method("setPolygon"):
		var s : Vector2 = fracture_shard.source_global_trans.get_scale()
		instance.setPolygon(fracture_shard.centered_shape, s)


	instance.setColor(Color.WHITE)
	var dir : Vector2 = (fracture_shard.spawn_pos - fracture_shard.source_global_trans.get_origin()).normalized()
	instance.linear_velocity = dir * _rng.randf_range(200, 400)
	instance.angular_velocity = _rng.randf_range(-1, 1)

	instance.setTexture(PolygonLib.setTextureOffset(texture_info, fracture_shard.centroid))
	
