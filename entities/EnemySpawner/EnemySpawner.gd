extends Node2D


const enemy = preload("res://entities/Enemy/Enemy.tscn")
const meteor = preload("res://entities/Meteor/Meteor.tscn")

onready var timer = $Timer

export var min_time = 0.5
export var max_time = 1.5


func _ready():
	randomize()
	spawn()
	
	
func spawn():
	var enemy_instance = choose([enemy, meteor]).instance()
	var pos = Vector2()
	pos.x = rand_range(22, get_viewport_rect().size.x - 22)
	enemy_instance.position = pos

	$Container.add_child(enemy_instance)
	
	timer.wait_time = rand_range(min_time, max_time)
	timer.start()


func choose(list):
	return list[randi() % list.size()]


func _on_Timer_timeout():
	spawn()
