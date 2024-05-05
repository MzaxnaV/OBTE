extends RigidBody2D

@export var _timer: Timer
@export var PUSH_FORCE = 300

# func _ready() -> void:
# 	setPolygon(PolygonLib.createCirclePolygon(radius, 1))

# func spawn(pos : Vector2, launch_vector : Vector2, lifetime : float, point_fracture) -> void:
func spawn(pos: Vector2, direction: Vector2, lifetime: float) -> void:
	global_position = pos
	# self.point_fracture = point_fracture
	_timer.start(lifetime)

	apply_impulse(direction)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state.get_contact_count() > 0:
		print("Integrate forces)")
		var body = state.get_contact_collider_object(0)
		if body is PhysicsObj:
			body = body as PhysicsObj
			# var pos : Vector2 = state.get_contact_collider_position(0)
			# point_fracture.fractureCollision(pos, body, self)
			body.apply_impulse(linear_velocity * PUSH_FORCE)
			destroy()

func despawn() -> void:
	_timer.stop()
# 	global_rotation = 0.0
# 	linear_velocity = Vector2.ZERO
# 	angular_velocity = 0.0
# 	set_applied_force(Vector2.ZERO)

func destroy() -> void:
 	# point_fracture.fractureBallDespawned(global_position, _poly.get_polygon())
	despawn()

	queue_free()
	# emit_signal("Despawn", self)

# func setPolygon(polygon : PoolVector2Array) -> void:
# 	_poly.set_polygon(polygon)
# 	_col_poly.set_polygon(polygon)

func _on_timer_timeout():
	destroy()
