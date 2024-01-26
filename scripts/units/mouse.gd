extends Unit

func _ready():
  %MouseSprite.stop()

func delayed_spawn(delay, trgt = null):
  await super(delay, trgt)
  %MouseSprite.play("default")
