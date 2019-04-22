extends KinematicBody2D

var rotationSpeed
var movingSpeed

var pickable = false
var collided = false
onready var spaceship = get_parent().get_parent().get_node("SpaceShip")

func _ready():
	randomize()
	rotationSpeed = rand_range(-0.05, 0.05)
	movingSpeed = rand_range(-500,-300)

func _process(delta):
	var fs = spaceship.fuel
	var enginemode = spaceship.engine_mode
	var speedFactor = spaceship.current_velocity
	if Input.is_action_pressed("ui_Lshift") and fs>0 and enginemode == 2:
		speedFactor = 4
	else:
		speedFactor = 1
	rotate(rotationSpeed)
	translate(Vector2(movingSpeed*delta*speedFactor,0))
	if collided:
		$CollisionEffect.emitting = true
	if position.x<0:
		queue_free()
	
