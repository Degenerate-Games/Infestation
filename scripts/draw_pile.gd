extends Control

signal finished_animating

var moving_out = false
var moving_in = false
var moving_up = false
var moving_down = false
var default_position: Vector2

@export_category("Node Data")
@export var left_card: TextureRect
@export var right_card: TextureRect
@export var left_position: Vector2
@export var right_position: Vector2
@export var up_position: Vector2
@export var down_position: Vector2

@export_category("Card Data")
@export var card_name: String = "Card Name":
	get:
		return card_name
	set(value):
		if get_node("CardName"):
			$CardName.text = value
		card_name = value
@export var art_texture: Texture2D = null:
	get:
		return art_texture
	set(value):
		if get_node("Art"):
			$Art.texture = value
		art_texture = value

@export_category("Decks")
@export var cards: Dictionary
@export var base_deck: Array[PackedScene]
var deck: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready():
	if $CardName: $CardName.text = card_name
	if $Art: $Art.texture = art_texture
	default_position = global_position
	print(default_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving_out:
		left_card.global_position = left_card.global_position.move_toward(left_position, delta * 100)
		right_card.global_position = right_card.global_position.move_toward(right_position, delta * 100)
		if left_card.global_position == left_position and right_card.global_position == right_position:
			moving_out = false
			moving_in = true
	if moving_in:
		left_card.global_position = left_card.global_position.move_toward(default_position, delta * 100)
		right_card.global_position = right_card.global_position.move_toward(default_position, delta * 100)
		if left_card.global_position == default_position and right_card.global_position == default_position:
			moving_in = false
			moving_up = true
	if moving_up:
		left_card.global_position = left_card.global_position.move_toward(up_position, delta * 100)
		right_card.global_position = right_card.global_position.move_toward(down_position, delta * 100)
		if left_card.global_position == up_position and right_card.global_position == down_position:
			moving_up = false
			moving_down = true
	if moving_down:
		left_card.global_position = left_card.global_position.move_toward(default_position, delta * 100)
		right_card.global_position = right_card.global_position.move_toward(default_position, delta * 100)
		if left_card.global_position == default_position and right_card.global_position == default_position:
			moving_down = false
			finished_animating.emit()

func reload_deck(from_draw_pile: bool = false):
	deck = []
	if from_draw_pile:
		var discard_pile = Global.HUD.discard_pile.discard_pile.duplicate(true)
		await Global.HUD.empty_discard_pile()
		for card in discard_pile:
			var card_scene: PackedScene
			match card.card_name:
				"Cockroach":
					card_scene = load(cards["Cockroach"])
				"Mouse":
					card_scene = load(cards["Mouse"])
				"Rat":
					card_scene = load(cards["Rat"])
				"Bird":
					card_scene = load(cards["Bird"])
			deck.append(card_scene)
	else:
		deck = base_deck.duplicate(true)
	await shuffle_deck()

func shuffle_deck():
	moving_out = true
	randomize()
	deck.shuffle()
	await finished_animating

func draw_card():
	if deck.size() == 0:
		await reload_deck(true)
	return deck.pop_back()
