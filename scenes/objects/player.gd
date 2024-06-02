extends CharacterBody2D

@export var game: Node
@export var data: PlayerData
@onready var spawn_pos: Node2D = %SpawnPos

@export var cards: Array[Card] = []

const StatType = OBTE_Globals.StatType

var flip_h: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wasInAir = false

var move_speed = 0
var jump_velocity = 0
var shoot_force = 0
var push_force = 0

func _ready():
	$AnimatedSprite2D.play("idle")

func _process(_delta):

	# create a copy of base stats
	var stat_mod = {}
	for t in StatType.values():
		stat_mod[t] = Stat.new(t)

	for card in cards:
		card.modify(stat_mod)
	
	move_speed = data.move_speed * stat_mod[StatType.MOVE_SPEED].mul + stat_mod[StatType.MOVE_SPEED].add
	jump_velocity = data.jump_velocity * stat_mod[StatType.JUMP_VELOCITY].mul + stat_mod[StatType.JUMP_VELOCITY].add
	push_force = data.push_force * stat_mod[StatType.PUSH_FORCE].mul + stat_mod[StatType.PUSH_FORCE].add
	shoot_force = data.shoot_force * stat_mod[StatType.SHOOT_FORCE].mul + stat_mod[StatType.SHOOT_FORCE].add
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		wasInAir = true
	
	var mouse_pos = get_global_mouse_position()
	if (mouse_pos.x > position.x):
		flip_h = false
	else:
		flip_h = true
	
	if Input.is_action_just_released("ui_card"):
		var tree = get_tree()
		tree.paused = true
		(tree.root.get_child(1).get_child(1) as SelectCard).generate_cards()
	
	if Input.is_action_just_released("shoot"):
		var launch_direction = (mouse_pos - spawn_pos.global_position).normalized()
		var bullet = data.bullet_scene.instantiate()
		game.add_child(bullet)
		
		# TODO: Move SpawnPos relative to mouse instead.
		var pos = spawn_pos.global_position
		if (flip_h):
			pos.x -= 2 * spawn_pos.position.x
		
		bullet.spawn(pos, launch_direction * shoot_force, 3)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		$AnimatedSprite2D.play("jump")

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var collider = c.get_collider()
		if collider is PhysicsObj:
			collider = collider as PhysicsObj
			collider.apply_central_impulse( - c.get_normal() * push_force)

	if wasInAir and is_on_floor():
		wasInAir = false
		$AnimatedSprite2D.play("idle")
