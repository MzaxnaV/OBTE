class_name Stat
extends Resource

@export var type: OBTE_Globals.StatType
@export var add: float = 0.0
@export var mul: float = 1.0

func _init(_type: OBTE_Globals.StatType = OBTE_Globals.StatType.MOVE_SPEED):
	type = _type
