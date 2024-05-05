extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var FORCE_PUSH = 80.0
@export var SHOOT_FORCE = 100;

@export var game: Node

@export var bullet_scene: PackedScene

@onready var spawn_pos: Node2D = %SpawnPos

var flip_h: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wasInAir = false

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		wasInAir = true
	
	var mouse_pos = get_global_mouse_position()
	if (mouse_pos.x > position.x):
		flip_h = false
	else:
		flip_h = true
	
	if Input.is_action_just_released("shoot"):
		var launch_direction = (mouse_pos - spawn_pos.global_position).normalized()
		var bullet = bullet_scene.instantiate()
		game.add_child(bullet)
		
		# TODO: Move SpawnPos relative to mouse instead.
		var pos = spawn_pos.global_position
		if (flip_h):
			pos.x -= 2 * spawn_pos.position.x
		
		bullet.spawn(pos, launch_direction * SHOOT_FORCE, 3)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var collider = c.get_collider()
		if collider is PhysicsObj:
			collider = collider as PhysicsObj
			collider.apply_central_impulse( - c.get_normal() * FORCE_PUSH)

	if wasInAir and is_on_floor():
		wasInAir = false
		$AnimatedSprite2D.play("idle")
