extends Node

# Declare member variables here. Examples:
# var a = 2
var pickUpH2 = preload("res://Scenes/PickUp_H2.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$H2_Timer.start(2)

#func _process(delta):
	 #pass
	
func spawner(spawn_object):
	randomize()
	var spawn = spawn_object.instance()
	var pos = Vector2()
	pos.x = 2000
	pos.y = rand_range(100,900)
	spawn.position = pos
	#print(pos)
	add_child(spawn)

func _on_H2_Timer_timeout():
	randomize()
	var spawn_time = rand_range(0.01,0.035)
	var cur_vel = get_parent().get_node("SpaceShip").current_velocity
	$H2_Timer.start((spawn_time*cur_vel/270)+1)
	spawner(pickUpH2)
	print((spawn_time*cur_vel/270)+1)
