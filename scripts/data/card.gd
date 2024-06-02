class_name Card
extends Resource

enum Type { MOBILITY = 0 }

const StatType = OBTE_Globals.StatType

@export var name: String = "Name"
@export var desc: String = "Desc"
@export var stats: Array[Stat]
@export var type: Type = Type.MOBILITY

func _init():
	for t in StatType.values():
		stats.append(Stat.new(t))

func modify(stat_mod):
	assert(stats.size() == Globals.StatType.size(), "Stats in the card %s not configured correctly." % name)
	for t in range(stats.size()):
		assert(stat_mod[t].type == stats[t].type, "Incorrect type of stat.")
		stat_mod[t].mul *= stats[t].mul
		stat_mod[t].add += stats[t].add
