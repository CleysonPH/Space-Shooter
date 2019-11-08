extends Camera2D


var magnutide = 0
var time_left = 0
var is_shaking = false


func _ready():
	pass


func shake(new_magnitude, life_time):
	if magnutide > new_magnitude: return
	
	magnutide = new_magnitude
	time_left = life_time
	
	if is_shaking: return
	is_shaking = true
	
	while time_left > 0:
		var pos = Vector2()
		pos.x = rand_range(-magnutide, magnutide)
		pos.y = rand_range(-magnutide, magnutide)
		position = pos
		
		time_left -= get_process_delta_time()
		yield(get_tree(), "idle_frame")
	
	magnutide = 0
	is_shaking = false
	position = Vector2(0, 0)