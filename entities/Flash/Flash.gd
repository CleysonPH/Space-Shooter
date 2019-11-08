extends Sprite

func _ready():
	$Anim.play("FadeOut")
	yield($Anim, "animation_finished")
	queue_free()
