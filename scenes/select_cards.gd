class_name SelectCard
extends PanelContainer

@export var card: PackedScene
@export var cards: Array[Card]

@onready var container : GridContainer = %GridContainer

func generate_cards():
	for i in container.get_child_count():
		container.get_child(i).queue_free()

	var num_cards = Globals.rng.randi_range(1, cards.size())
	
	print(num_cards, cards.size())
	
	for i in range(num_cards):
		var c = card.instantiate()
		var r = Globals.rng.randi_range(0, cards.size()-1)
		print(r)
		c.set_card(cards[r])
		container.add_child(c)
	
	show()

func _on_close_button_pressed():
	hide()
	get_tree().paused = false
