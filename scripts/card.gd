extends Area2D

var hoverable = true
var growing = false
var shrinking = false
var default_scale = 0.55
var full_scale = 0.75
var start_position
var vertical_translation: Vector2 = Vector2.UP * 200

var card_name: String
var prestige_level: int
var level: int
var defense: int
var attack: int
var description: String

func _init(name: String = "Card Name", prestige_lvl: int = 0, lvl: int = 1, def: int = 0, atk: int = 0, desc: String = ""):
	card_name = name
	prestige_level = prestige_lvl
	level = lvl
	defense = def
	attack = atk
	description = desc

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = global_position
	$CardName.text = card_name
	$PrestigeLabel.texture.region.position.x = prestige_level * 16.0
	$Level.text = str(level)
	$Shield/Defense.text = str(defense)
	$Sword/Attack.text = str(attack)
	$DescriptionBackground/Description.text = description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var weight = 1.0 - $AnimationTimer.time_left
	if growing:
		global_position = Global.lerpvec2(start_position, start_position + vertical_translation, weight)
		var scl = lerpf(default_scale, full_scale, weight)
		global_scale = Vector2(scl, scl)
	elif shrinking:
		global_position = Global.lerpvec2(start_position + vertical_translation, start_position, weight)
		var scl = lerpf(full_scale, default_scale, weight)
		global_scale = Vector2(scl, scl)

func _on_mouse_entered():
	if !hoverable: return
	$AnimationTimer.start(1.0)
	growing = true
	shrinking = false
	top_level = true

func _on_mouse_exited():
	if !hoverable: return
	$AnimationTimer.start(1.0)
	growing = false
	shrinking = true
	top_level = false
