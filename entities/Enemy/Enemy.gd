extends Area2D


const shot = preload("res://entities/EnemyShot/EnemyShot.tscn")
const explosion = preload("res://entities/Explosion/Explosion.tscn")

export(int) var armor = 2
export(int) var min_speed = 100
export(int) var max_speed = 400

onready var sprite_height = $Sprite.texture.get_height()
onready var sprite_width = $Sprite.texture.get_width()

var velocity = Vector2(0, 100)
var can_shot = false
var damage = 1


func _ready():
	add_to_group("enemies")
	randomize()
	velocity.x = rand_range(min_speed, max_speed)
	velocity.x = choose([velocity.x, -velocity.x])
	set_process(true)


func _process(delta):
	self.position += velocity * delta
	
	if self.position.y >= get_viewport_rect().size.y + (sprite_height/2):
		queue_free()
		
	if self.position.x <= sprite_width / 2:
		velocity.x = abs(velocity.x)
	if self.position.x >= get_viewport_rect().size.x - (sprite_width/2):
		velocity.x = -abs(velocity.x)
		
	if can_shot:
		shot()


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


func shot():
	create_shoot($Cannons/Right.global_position)
	create_shoot($Cannons/Left.global_position)
	
	can_shot = false
	$Timer.start()


func create_shoot(pos):
	var shot_instance = shot.instance()
	shot_instance.position = pos
	get_tree().get_current_scene().add_child(shot_instance)


func _on_Timer_timeout():
	can_shot = true


func _on_Enemy_area_entered(area):
	if area.is_in_group("player"):
		area.take_damage(damage)
		take_damage(100)
