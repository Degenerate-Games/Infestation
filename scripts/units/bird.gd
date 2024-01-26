extends Unit

func _ready():
  %BirdSprite.stop()

func delayed_spawn(delay, trgt = null):
  await super(delay, trgt)
  %BirdSprite.play("default")
