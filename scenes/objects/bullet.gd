extends RigidBody2D

@export var _timer: Timer
@export var PUSH_FORCE = 100

func _ready() -> void:
	pass

func spawn(pos: Vector2, direction: Vector2, lifetime: float) -> void:
	global_position = pos
	_timer.start(lifetime)

	apply_impulse(direction)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state.get_contact_count() > 0:
		print("Integrate forces)")
		var body = state.get_contact_collider_object(0)
		if body is RigidBody2D:
			# var pos : Vector2 = state.get_contact_collider_position(0)
			(body as RigidBody2D).apply_impulse(linear_velocity * PUSH_FORCE)
			_timer.stop()
			queue_free()

# func _ready() -> void:
# 	setPolygon(PolygonLib.createCirclePolygon(radius, 1))

# func _integrate_forces(state: Physics2DDirectBodyState) -> void:
# 	if state.get_contact_count() > 0:
# 		var body = state.get_contact_collider_object(0)
# 		if body is RigidBody2D:
# 			var pos : Vector2 = state.get_contact_collider_position(0)
# 			point_fracture.fractureCollision(pos, body, self)

# func spawn(pos : Vector2, launch_vector : Vector2, lifetime : float, point_fracture) -> void:
# 	launch_velocity = launch_vector.length()
# 	self.point_fracture = point_fracture
# 	global_position = pos
# 	_timer.start(lifetime)
	
# 	linear_velocity = launch_vector

# func despawn() -> void:
# 	global_rotation = 0.0
# 	linear_velocity = Vector2.ZERO
# 	angular_velocity = 0.0
# 	set_applied_force(Vector2.ZERO)

func destroy() -> void:
	_timer.stop()

	queue_free()
	# emit_signal("Despawn", self)

# func setPolygon(polygon : PoolVector2Array) -> void:
# 	_poly.set_polygon(polygon)
# 	_col_poly.set_polygon(polygon)

# func _on_Timer_timeout() -> void:
# 	point_fracture.fractureBallDespawned(global_position, _poly.get_polygon())
# 	destroy()

func _on_timer_timeout():
	destroy()
