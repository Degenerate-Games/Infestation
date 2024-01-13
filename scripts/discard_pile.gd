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

# Called when the node enters the scene tree for the first time.
func _ready():
	if $CardName: $CardName.text = card_name
	if $Art: $Art.texture = art_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
