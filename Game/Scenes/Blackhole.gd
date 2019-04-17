extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var c = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_param("centerX", c)
	if c>-1 and c<=2:
		c+=0.001
	else:
		c+=0.01
	if c>5:
		c=-5
	
	