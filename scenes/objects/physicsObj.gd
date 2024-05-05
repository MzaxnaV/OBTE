extends RigidBody2D

class_name PhysicsObj

var id: int

func init(type: int, pos: Vector2, obj_name: String, root: Node2D):
	id = type
	name = obj_name
	position = 32 * pos
	root.add_child(self)

	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#var collider = c.get_collider()
		#if collider is PhysicsObj:
			#collider = PhysicsObj
			#print(collider)
			#collider.apply_central_impulse( - c.get_normal() * FORCE_PUSH)
