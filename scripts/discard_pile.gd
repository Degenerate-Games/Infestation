extends Marker2D

var discard_pile: Array[Control]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func discard_card(card):
	card.destination = global_position
	card.hoverable = false
	card.animate()
	discard_pile.append(card)
	await card.animation_timer.timeout
	Global.HUD.hand_node.remove_child(card)
	add_child(card)
	card.position = Vector2.ZERO
	Global.HUD.discarding_cards -= 1

func empty():
	while discard_pile.size() > 0:
		var card = discard_pile.pop_back()
		card.destination = Global.HUD.draw_pile.position
		card.hoverable = false
		card.animate()
		await card.animation_timer.timeout
