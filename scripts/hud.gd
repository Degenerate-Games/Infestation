extends Node2D

@export var base_deck: Array[PackedScene]
var deck: Array[PackedScene]
@export var hand_size_limit: int
var hand: Array
@export var card_width: float = 256.0

# Called when the node enters the scene tree for the first time.
func _ready():
	deck = base_deck.duplicate(true)
	shuffle_deck()
	hand = []
	for i in hand_size_limit:
		draw_card()
	print(hand)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_hand_positions()
	
func update_hand_positions():
	var hand_count = hand.size()
	var scl = clampf(hand_count, 2, 20)
	var shift = (card_width / scl * hand_count / 2)
	for i in hand.size():
		var current_card = hand[i]
		if not (current_card.growing or current_card.shrinking or current_card.hovering):
			current_card.default_position = $Hand.global_position + Vector2((i * card_width / scl) - shift, 0)

func shuffle_deck():
	randomize()
	deck.shuffle()

func draw_card():
	var card = deck.pop_back()
	card = card.instantiate()
	card.name = card.card_name
	card.hoverable = true
	add_card_to_hand(card)

func add_card_to_hand(card):
	if hand.size() < hand_size_limit:
		hand.append(card)
		$Hand.add_child(card)
	pass

func remove_card_from_hand(card):
	for i in hand.size():
		if hand[i] == card:
			var c = hand.pop_at(i)
			c.queue_free()
