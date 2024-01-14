extends Control

var hoverable = true
var hovering = false
var selected = false
var growing = false
var shrinking = false
var start_scale
var default_scale
var full_scale = 0.75
var start_position
var default_position: Vector2:
	get:
		return default_position
	set(value):
		default_position = value
		global_position = value
var destination: Vector2 = Vector2.ZERO

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

# Called when the node enters the scene tree for the first time.
func _ready():
	default_position = global_position
	default_scale = get_global_transform().get_scale().x
	if $CardName: $CardName.text = card_name
	if $PrestigeLabel: $PrestigeLabel.texture.region.position.x = prestige_level * 16.0
	if $Level: $Level.text = str(level)
	if $Shield/Defense: $Shield/Defense.text = str(defense)
	if $Sword/Attack: $Sword/Attack.text = str(attack)
	if $Art: $Art.texture = art_texture
	if $DescriptionBackground/Description: $DescriptionBackground/Description.text = description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var weight = $AnimationTimer.get_wait_time() - $AnimationTimer.time_left
	weight = remap(weight, 0.0, $AnimationTimer.get_wait_time(), 0.0, 1.0)
	if weight == 1.0:
		if shrinking:
			top_level = false
		growing = false
		shrinking = false
		destination = Vector2.ZERO
	
	if growing:
		global_position = Global.lerpvec2(start_position, destination, weight)
		var scl = lerpf(start_scale, full_scale, weight)
		scale = Vector2(scl, scl)
	elif shrinking:
		global_position = Global.lerpvec2(start_position, default_position, weight)
		var scl = lerpf(start_scale, default_scale, weight)
		scale = Vector2(scl, scl)
	elif destination != Vector2.ZERO:
		global_position = global_position.move_toward(destination, delta * 1000)
		scale = scale.move_toward(Vector2(default_scale, default_scale), delta * 1000)

func _on_mouse_entered():
	if !hoverable: return
	if Global.selected_card == null:
		$AnimationTimer.start(0.5)
		hovering = true
		growing = true
		shrinking = false
		start_position = global_position
		start_scale = get_global_transform().get_scale().x
		destination = default_position + Vector2.UP * 150
		top_level = true

func _on_mouse_exited():
	if !hoverable: return
	if selected: return
	$AnimationTimer.start(0.3)
	hovering = false
	growing = false
	shrinking = true
	start_position = global_position
	start_scale = get_global_transform().get_scale().x


func _on_gui_input(event):
	if event.is_action_pressed("Select"):
		if selected:
			Global.selected_card = null
			get_parent().remove_child(self)
			Global.HUD.discard_pile.discard_card(self)
			start_scale = get_global_transform().get_scale().x
			$AnimationTimer.start(2.0)
		else:
			selected = true
			Global.selected_card = self
