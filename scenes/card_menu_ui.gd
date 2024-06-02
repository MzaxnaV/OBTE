extends PanelContainer

func set_card(card: Card):
	(%Type.get_child(1) as Label).text = card.name
	(%Stat1.get_child(1) as Label).text = "mul: %.2f, add: %.2f" % [card.stats[0].mul, card.stats[0].add]
	(%Stat2.get_child(1) as Label).text = "mul: %.2f, add: %.2f" % [card.stats[1].mul, card.stats[1].add]
	(%Stat3.get_child(1) as Label).text = "mul: %.2f, add: %.2f" % [card.stats[2].mul, card.stats[2].add]
	(%Stat4.get_child(1) as Label).text = "mul: %.2f, add: %.2f" % [card.stats[3].mul, card.stats[3].add]


func _on_button_pressed():
	print("clicked")
