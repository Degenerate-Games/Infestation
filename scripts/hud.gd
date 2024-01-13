extends Node2D

enum PHASE {DRAW, PLAY}

@export var base_deck: Array[PackedScene]
var deck: Array[PackedScene]
@export var hand_size_limit: int
var hand: Array
@export var card_width: float = 256.0
@export var current_phase: PHASE = PHASE.DRAW

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
	#if deck.size() == 0:
		#deck = base_deck.duplicate(true)
		#shuffle_deck()
		#for card in hand:
			#remove_card_from_deck(card)
	
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
			
#func remove_card_from_deck(card):
	#for i in deck.size():
		#if deck[i] == card:
			#deck.pop_at(i)


func _on_control_button_1_gui_input(event):
	if event.is_action_pressed("Select"):
		match $ControlButton1.texture.region.position.x:
			0.0:
				$ControlButton1.texture.region.position.x = 32
			32.0:
				$ControlButton1.texture.region.position.x = 64
			64.0:
				$ControlButton1.texture.region.position.x = 32


func _on_control_button_2_gui_input(event):
	if event.is_action_pressed("Select"):
		match $ControlButton2.texture.region.position.x:
			0.0:
				$ControlButton2.texture.region.position.x = 32
			32.0:
				$ControlButton2.texture.region.position.x = 64
			64.0:
				$ControlButton2.texture.region.position.x = 32
