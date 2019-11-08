extends Area2D


export var velocity = Vector2(0, -350)
export var damage = 1

onready var sprite_height = $Sprite.texture.get_height()


func _ready():
	set_process(true)
	
	
func _process(delta):
	self.position += velocity * delta
	
	if self.position.y <= 0 - (sprite_height/2):
		queue_free()


func _on_PlayerShoot_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		get_tree().get_current_scene().get_node("Camera").shake(1, 0.13)
		queue_free()
