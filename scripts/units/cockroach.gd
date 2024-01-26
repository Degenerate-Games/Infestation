extends Unit

func _ready():
  $CockroachSprite.stop()

func delayed_spawn(delay, trgt = null):
  await super(delay, trgt)
  $CockroachSprite.play("default")
