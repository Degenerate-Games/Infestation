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
	discard_pile.append(card)
	add_child(card)
