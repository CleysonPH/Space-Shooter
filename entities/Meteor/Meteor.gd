extends Area2D


const explosion = preload("res://entities/Explosion/Explosion.tscn")

export(int) var armor = 2
export(int) var min_speed = 600
export(int) var max_speed = 800

onready var sprite_height = $Sprite.texture.get_height()
onready var sprite_width = $Sprite.texture.get_width()

var velocity = Vector2.ZERO
var damage = 1


func _ready():
	add_to_group("enemies")
	randomize()
	velocity.y = rand_range(min_speed, max_speed)
	set_process(true)


func _process(delta):
	self.position += velocity * delta
	
	if self.position.y >= get_viewport_rect().size.y + (sprite_height/2):
		queue_free()


func choose(list):
	return list[randi() % list.size()]
	
	
func take_damage(damage):
	armor -= damage
	
	if armor <= 0:
		get_tree().get_current_scene().get_node("Camera").shake(8, 0.2)
		var explosion_instance = explosion.instance()
		explosion_instance.global_position = self.global_position
		get_tree().get_current_scene().add_child(explosion_instance)
		queue_free()


func _on_Meteor_area_entered(area):
	if area.is_in_group("player"):
		area.take_damage(damage)
		take_damage(100)
