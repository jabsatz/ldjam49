extends Node2D

var Platform = preload('res://FloorSegment.tscn')
var Monster = preload('res://Enemy1.tscn')
onready var camera = $Player/Camera2D
onready var last_camera_position = camera.get_camera_screen_center().x
var render_limit = [-2000, 5000]
var render_position = Vector2(0, 200)

var min_distance = 800
var max_distance = 1100
var max_height_diff = 50
var min_height_diff = 150

var monster_chance = 0.2

var platforms = []
var monsters = []


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

	while render_position.x < render_limit[1]:
		render_platform()


func render_platform():
	var platform = Platform.instance()
	platform.position = render_position
	add_child(platform)
	platforms.push_back(platform)
	var spawn_monster = rand_range(0, 1) <= monster_chance
	if spawn_monster:
		var monster = Monster.instance()
		monster.position = render_position
		monster.position.y -= 300
		add_child(monster)
		monsters.push_back(monster)

	render_position.x += min_distance + randi() % (max_distance - min_distance)
	render_position.y += (randi() % (max_height_diff + min_height_diff)) - max_height_diff


func _process(delta):
	var new_camera_position = camera.get_camera_screen_center().x
	if new_camera_position > last_camera_position:
		print(render_limit)
		var diff = new_camera_position - last_camera_position
		last_camera_position = new_camera_position
		render_limit[0] += diff
		render_limit[1] += diff
		if render_limit[1] > render_position.x + max_distance:
			render_platform()
		if platforms[0].position.x < render_limit[0]:
			platforms[0].queue_free()
			platforms.pop_front()
		if not monsters.empty() and monsters[0].position.x < render_limit[0]:
			monsters[0].queue_free()
			monsters.pop_front()
