extends Control

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reload_deck(from_draw_pile: bool = false):
	deck = []
	if from_draw_pile:
		var discard_pile = Global.HUD.discard_pile.discard_pile.duplicate(true)
		Global.HUD.empty_discard_pile()
		for card in discard_pile:
			var card_scene: PackedScene
			match card.card_name:
				"Cockroach":
					card_scene = load(cards["Cockroach"])
			deck.append(card_scene)
	else:
		deck = base_deck.duplicate(true)
	shuffle_deck()

func shuffle_deck():
	randomize()
	deck.shuffle()

func draw_card():
	if deck.size() == 0:
		reload_deck(true)
	return deck.pop_back()
