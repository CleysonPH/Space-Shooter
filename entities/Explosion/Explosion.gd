extends AnimatedSprite

func _ready():
	$".".play("explosion")
	yield($SoundEffect, "finished")
	queue_free()
