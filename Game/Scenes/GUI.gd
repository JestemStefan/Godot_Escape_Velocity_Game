extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0
onready var speedmeter = $speed_meter
onready var speeddigits = $speed_digits_label
onready var fuelbar = $fuel_bar
var velocity_critical = false
var fuel_critical  = false
var interpolate1 = 1
var interpolate2 = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func _process(delta):
	check_velocity(delta)
	check_fuel(delta)
	
		
func check_velocity(delta):
	if velocity_critical == true:
		time += delta
		interpolate1 = sin(time * 15)
		speedmeter.modulate = Color(1,interpolate1, interpolate1)
		speeddigits.modulate = Color(1,interpolate1, interpolate1)
	elif velocity_critical==false and interpolate1!=1:
		interpolate1 = 1
		speedmeter.modulate = Color(1,1,1)
		speeddigits.modulate = Color(1,1,1)
		#print("color changed")

func check_fuel(delta):
	if fuel_critical == true:
		time += delta
		interpolate2 = sin(time * 15)
		fuelbar.modulate = Color(1,interpolate2, interpolate2)
	elif fuel_critical==false and interpolate2!=1:
		interpolate2 = 1
		fuelbar.modulate = Color(1,1,1)
		#print("color changed")
	

