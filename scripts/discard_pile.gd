extends Marker2D

var discard_pile: Array[Control]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func discard_card(card):
	card.in_hand = false
	card.animate(global_position, card.default_scale)
	await card.finished_animating
	discard_pile.append(card)
	card.reparent(self)
	Global.HUD.discarding_cards -= 1

func empty():
	var last_card
	while discard_pile.size() > 0:
		last_card = discard_pile.pop_back()
		last_card.in_hand = false
		last_card.animate(Global.HUD.draw_pile.global_position, last_card.default_scale)
	await last_card.finished_animating
