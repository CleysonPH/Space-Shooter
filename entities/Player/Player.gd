extends Area2D


const shoot = preload("res://entities/PlayerShoot/PlayerShoot.tscn")
const flash = preload("res://entities/Flash/Flash.tscn")
const explosion = preload("res://entities/Explosion/Explosion.tscn")

onready var sprite_width = $Sprite.texture.get_width()

var armor = 4

signal armor_changed

var motion = Vector2()
var velocity = 200
var can_shoot = true


func _ready():
	add_to_group("player")
	set_process(true)
	

func _process(delta):
	motion.x = 0
	
	#Verificar a entrada do Jogador
	if Input.is_action_pressed("move_left"):
		motion.x = -1
	if Input.is_action_pressed("move_right"):
		motion.x = 1
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		
	self.position.x += motion.x * velocity * delta
	self.position.x = clamp(self.position.x, 0 + (sprite_width/2), get_viewport_rect().size.x - (sprite_width/2))


func shoot():
	create_shoot($Cannons/Right.global_position)
	create_shoot($Cannons/Left.global_position)
	
	can_shoot = false
	$Timer.start()


func create_shoot(pos):
	var shoot_instance = shoot.instance()
	shoot_instance.position = pos
	get_tree().get_current_scene().add_child(shoot_instance)


func _on_Timer_timeout():
	can_shoot = true


func take_damage(damage):
	armor -= damage
	emit_signal("armor_changed", armor)
	get_tree().get_current_scene().add_child(flash.instance())
	
	if armor <= 0:
		get_tree().get_current_scene().get_node("Camera").shake(8, 0.2)
		var explosion_instance = explosion.instance()
		explosion_instance.global_position = self.global_position
		get_tree().get_current_scene().add_child(explosion_instance)
		queue_free()
