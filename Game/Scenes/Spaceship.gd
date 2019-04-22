extends KinematicBody2D

var inputActive = true
var speed = 750
var velocity = Vector2()
var current_velocity = 10000
#var escape_velocity = 40320
var fuel = 100
var fuel_usage = 3.0
var engine_mode = 1
onready var star_dust = get_parent().get_node("BackgroundNode/StarDust")
onready var fuel_bar = get_parent().get_node("UI/fuel_bar")
onready var speed_bar = get_parent().get_node("UI/speed_meter")
onready var speed_digits = get_parent().get_node("UI/speed_digits_label/speed_digits_number")
onready var speed_digits_label = get_parent().get_node("UI/speed_digits_label")
onready var GUI = get_parent().get_node("UI")
onready var Spawner = get_parent().get_node("Spawner")
onready var Game = $"/root/Game"

func _ready():
	$EngineSound.playing = true
	inputActive = true
	

func get_input():
    # Detect up/down/left/right keystate and only move when pressed.
    velocity = Vector2()
    if Input.is_action_pressed('ui_right'):
        velocity.x += 1
    if Input.is_action_pressed('ui_left'):
        velocity.x -= 1
    if Input.is_action_pressed('ui_down'):
        velocity.y += 1
    if Input.is_action_pressed('ui_up'):
        velocity.y -= 1
    velocity = velocity.normalized() * speed
	#afterburner
    if Input.is_action_just_pressed("ui_Lshift"):
	    afterburner()
    if Input.is_action_just_released("ui_Lshift"):
	    normal_burn()

func _physics_process(delta):
	if current_velocity>=40320:
		Win()
	elif current_velocity<=0:
		Lose()
	
	#print(current_velocity)
	check_pos()
	if inputActive:
		get_input()
		fuel_script(delta)
		escape()
	
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.get("pickable")==true:
		   #print(current_velocity) 
		   fuel+=20
		   $PickupSound.play()
		elif collision.collider.get("pickable")==false:
			current_velocity -=1000*round(collision.collider.scale.x)
			$CollisionSound.play()
			$SpaceShip_Sprite/CollisionEffect.restart()
			$SpaceShip_Sprite/CollisionEffect.emitting = true
			
		collision.collider.queue_free()
	
func check_pos():
	"""if position.x<100:
		position.x=100
	if position.x>1900:
		position.x=1900
	if position.y<40:
		position.y=40
	if position.y>1000:
		position.y=1000"""
	if inputActive:
		position.x = clamp(position.x, 100, 1900)
		position.y = clamp(position.y, 40, 1000)
	elif !inputActive and position.x>2200:
		Game.win = true
		hide()
	elif !inputActive and position.x<-200:
		hide()
		Game.lose = true
		

func afterburner():
	engine_mode = 2
	fuel_usage = 10
	$SpaceShip_Sprite/BigEngineSmoke.process_material.initial_velocity = 2000
	$SpaceShip_Sprite/BigEngineSmoke.lifetime = 2
	$SpaceShip_Sprite/SmallEngineSmoke1.process_material.initial_velocity = 2000
	$SpaceShip_Sprite/SmallEngineSmoke1.lifetime = 2
	$SpaceShip_Sprite/SmallEngineSmoke2.process_material.initial_velocity = 2000
	$SpaceShip_Sprite/SmallEngineSmoke2.lifetime = 2
	star_dust.process_material.initial_velocity = -2000
	star_dust.process_material.scale = 0.5
	star_dust.process_material.trail_divisor = 20
	star_dust.amount = 1000
	$EngineSound.pitch_scale=2

func normal_burn():
	engine_mode = 1
	fuel_usage = 3
	$SpaceShip_Sprite/BigEngineSmoke.process_material.initial_velocity = 500
	$SpaceShip_Sprite/BigEngineSmoke.lifetime = 10
	$SpaceShip_Sprite/SmallEngineSmoke1.process_material.initial_velocity = 500
	$SpaceShip_Sprite/SmallEngineSmoke1.lifetime = 10
	$SpaceShip_Sprite/SmallEngineSmoke2.process_material.initial_velocity = 500
	$SpaceShip_Sprite/SmallEngineSmoke2.lifetime = 10
	star_dust.process_material.initial_velocity = -1000
	star_dust.process_material.scale = 0.01
	star_dust.process_material.trail_divisor = 5
	star_dust.amount = 200
	$EngineSound.playing = true
	$EngineSound.pitch_scale=0.5
	
func no_burn():
	engine_mode = 0
	fuel_usage = 0
	$SpaceShip_Sprite/BigEngineSmoke.emitting = false
	$SpaceShip_Sprite/SmallEngineSmoke1.emitting = false
	$SpaceShip_Sprite/SmallEngineSmoke2.emitting = false
	star_dust.process_material.initial_velocity = 0
	star_dust.process_material.scale = 0
	star_dust.process_material.trail_divisor = 0
	$EngineSound.playing = false
	
func fuel_script(delta):
	#fuel script
	if fuel >100:
		fuel = 100
	if fuel>0:
		fuel -= fuel_usage*delta
		if $SpaceShip_Sprite/BigEngineSmoke.emitting == false:
			$SpaceShip_Sprite/BigEngineSmoke.emitting = 1
			$SpaceShip_Sprite/SmallEngineSmoke1.emitting = 1
			$SpaceShip_Sprite/SmallEngineSmoke2.emitting = 1
			normal_burn()
	else:
		fuel = 0
		no_burn()
	
	fuel_bar.set_value(fuel)
	
	if !$FuelAlarm.playing and fuel<10:
		$FuelAlarm.play()
		GUI.set("fuel_critical",true)
		#print("fuel low")
	elif $FuelAlarm.playing and fuel>=10:
		 $FuelAlarm.stop()
		 GUI.set("fuel_critical",false)
		 #print("fuel high")
	
	
func escape():
	if engine_mode == 2:
		current_velocity +=10
	elif engine_mode == 1:
		current_velocity -=3
	else:
		current_velocity -=10
		
	if current_velocity<0:
		current_velocity=0
		
	var posY = 830 - (current_velocity * 0.02)
	#print(posY)
		
	speed_digits.set_text(String(current_velocity) + " km/h")
	speed_digits_label.set_position(Vector2(80,posY))
	speed_bar.set_value(current_velocity)
	
	
	if !$VelocityAlarm.playing and current_velocity<9000:
		$VelocityAlarm.play()
		GUI.set("velocity_critical",true)
	elif $VelocityAlarm.playing and current_velocity>=9000:
		$VelocityAlarm.stop()
		GUI.set("velocity_critical",false)
	
	
func Win():
	speed_bar.hide()
	speed_digits_label.hide()
	fuel_bar.hide()
	Spawner.spawnerOn = false
	inputActive = false
	position.x +=10
	#print(current_velocity)

func Lose():
	speed_bar.hide()
	speed_digits_label.hide()
	fuel_bar.hide()
	Spawner.spawnerOn = false
	inputActive = false
	position.x -=10
	
