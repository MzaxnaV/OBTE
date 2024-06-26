extends RigidBody2D

class_name FractureBody

var _col_poly: CollisionPolygon2D
var _poly : Polygon2D
var _timer : Timer

func init(pos:Vector2, root: Node2D) -> void:
	_col_poly = $CollisionPolygon2D
	_poly = $Polygon2D
	_timer = $Timer
	global_position = pos
	root.add_child(self)

func setPolygon(polygon : PackedVector2Array, new_scale : Vector2) -> void:
	_poly.set_polygon(polygon)
	polygon.append(polygon[0])
	if new_scale != Vector2(1.0, 1.0):
		#collision polygons can be scaled with "shape_owner_set_transform(owner_id,transform)
		#but here I just scale the polygon for the collision polygon
		polygon = PolygonLib.scalePolygon(polygon, new_scale)
		_poly.scale = new_scale
	_col_poly.set_polygon(polygon)


func setTexture(texture_info : Dictionary) -> void:
	_poly.texture = texture_info.texture
	_poly.texture_scale = texture_info.scale
	_poly.texture_offset = texture_info.offset
	_poly.texture_rotation = texture_info.rot


func setColor(color : Color) -> void:
	_poly.modulate = color

func _on_timer_timeout():
	queue_free()
