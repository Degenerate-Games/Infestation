extends Control

signal finished_animating

var in_hand = false
var hovering = false
var selected = false
var destination_scale: Vector2
var default_scale: Vector2
var full_scale: Vector2 = Vector2(0.75, 0.75)
var destination_position: Vector2
var hand_position: Vector2
var animating: bool = false

@export_category("Card Data")
@export var card_name: String = "Card Name":
	get:
		return card_name
	set(value):
		if $CardName:
			$CardName.text = value
		card_name = value
@export var prestige_level: int = 0:
	get:
		return prestige_level
	set(value):
		if $PrestigeLabel:
			$PrestigeLabel.texture.region.position.x = value * 16.0
		prestige_level = value
@export var level: int = 1:
	get:
		return level
	set(value):
		if $Level:
			$Level.text = str(value)
		level = value
@export var defense: int = 0:
	get:
		return defense
	set(value):
		if $Shield/Defense:
			$Shield/Defense.text = str(value)
		defense = value
@export var attack: int = 0:
	get:
		return attack
	set(value):
		if $Sword/Attack:
			$Sword/Attack.text = str(value)
		attack = value
@export var art_texture: Texture2D = null:
	get:
		return art_texture
	set(value):
		if $Art:
			$Art.texture = value
		art_texture = value
@export var description: String = "":
	get:
		return description
	set(value):
		if $DescriptionBackground/Description:
			$DescriptionBackground/Description.text = value
		description = value
@export var play_actions: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	default_scale = get_global_transform().get_scale()
	if $CardName: $CardName.text = card_name
	if $PrestigeLabel: $PrestigeLabel.texture.region.position.x = prestige_level * 16.0
	if $Level: $Level.text = str(level)
	if $Shield/Defense: $Shield/Defense.text = str(defense)
	if $Sword/Attack: $Sword/Attack.text = str(attack)
	if $Art: $Art.texture = art_texture
	if $DescriptionBackground/Description: $DescriptionBackground/Description.text = description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animating:
		global_position = global_position.move_toward(destination_position, delta * 1000)
		scale = scale.move_toward(destination_scale, delta * 1000)
		if global_position == destination_position and scale == destination_scale:
			animating = false
			finished_animating.emit()
	elif in_hand and !hovering:
		if global_position != hand_position:
			animate(hand_position, default_scale)

func animate(dest: Vector2, dest_scale: Vector2):
	destination_position = dest
	destination_scale = dest_scale
	animating = true

func play_card():
	for key in play_actions.keys():
		match key:
			"queue_unit":
				Global.HUD.queue_unit(play_actions[key])

func _on_mouse_entered():
	if animating: return
	if !in_hand: return
	if Global.selected_card == null:
		animate(global_position + Vector2.UP * 150, full_scale)
		hovering = true
		z_index = RenderingServer.CANVAS_ITEM_Z_MAX

func _on_mouse_exited():
	if !in_hand: return
	if selected: return
	animate(hand_position, default_scale)
	hovering = false
	z_index = 0 

func _on_gui_input(event):
	if event.is_action_pressed("Select"):
		if selected:
			Global.selected_card = null
			selected = false
			play_card()
			Global.HUD.discard_card(self)
		else:
			selected = true
			Global.selected_card = self
