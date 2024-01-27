extends Control

@export_category("Health")
@export var max_health: float

var health: float
var health_bar: ColorRect
# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	health_bar = $Foreground


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	health_bar.scale.x = health / max_health

# Returns true if the entity should die
func take_damage(damage: float):
	health -= damage
	health = clampf(health, 0, max_health)
	return health <= 0

func is_below_half():
	return health < max_health / 2
