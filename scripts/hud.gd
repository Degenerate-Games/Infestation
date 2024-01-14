extends Node2D

enum PHASE {DRAW, PLAY}

@export var hand_size_limit: int
var hand: Array
@export var card_width: float = 256.0
@export var current_phase: PHASE = PHASE.DRAW
var current_wave = 1:
	get:
		return current_wave
	set(value):
		current_wave = value
		wave_display.text = " " + ("0" if current_wave - 10 < 0 else "") + str(current_wave) + "/" + str(wave_count) + " "
var wave_count = 10
@export_category("Node References")
@export var wave_display: Label
@export var draw_pile: Control
@export var discard_pile: Node2D
@export var round_timer: Control
@export var control_button_1: TextureRect
@export var control_button_2: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_pile.reload_deck()
	hand = []
	for i in hand_size_limit:
		draw_card()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_hand_positions()
	match current_phase:
		PHASE.DRAW:
			
			pass
		PHASE.PLAY:
			pass
	
func update_hand_positions():
	var hand_count = hand.size()
	var scl = clampf(hand_count, 2, 20)
	var shift = (card_width / scl * hand_count / 2)
	for i in hand.size():
		var current_card = hand[i]
		if not (current_card.growing or current_card.shrinking or current_card.hovering):
			current_card.default_position = $Hand.global_position + Vector2((i * card_width / scl) - shift, 0)

func draw_card():
	#if deck.size() == 0:
		#deck = base_deck.duplicate(true)
		#shuffle_deck()
		#for card in hand:
			#remove_card_from_deck(card)
	
	var card = draw_pile.draw_card()
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

func _on_control_button_1_gui_input(event):
	if event.is_action_pressed("Select"):
		match control_button_1.texture.region.position.x:
			0.0:
				control_button_1.texture.region.position.x = 32
			32.0:
				control_button_1.texture.region.position.x = 64
			64.0:
				control_button_1.texture.region.position.x = 32

func _on_control_button_2_gui_input(event):
	if event.is_action_pressed("Select"):
		match control_button_2.texture.region.position.x:
			0.0:
				control_button_2.texture.region.position.x = 32
			32.0:
				control_button_2.texture.region.position.x = 64
			64.0:
				control_button_2.texture.region.position.x = 32
