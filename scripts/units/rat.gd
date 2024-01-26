extends Unit

func _ready():
  %RatSprite.stop()

func delayed_spawn(delay, trgt = null):
  await super(delay, trgt)
  %RatSprite.play("default")
