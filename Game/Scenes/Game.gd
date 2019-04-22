extends Node

var SoundVol = 0
var SFXVol = 0
var DifficultyLevel = 0
var isPlayed = false
var paused = false
var win = false
var lose = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	 # Replace with function body.
#gettree().reloadcurrent_scene()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("true")
	if !win and !lose:
		if Input.is_action_just_pressed("ui_cancel") and isPlayed:
			if paused == false:
				paused = true
				move_child($Pause,3)
				$Pause.show()
				get_tree().paused = true
				
			elif paused == true:
				get_tree().paused = false
				move_child($Pause,0)
				$Pause.hide()
				paused = false
			
	if win:
		move_child($YouWin,3)
		$YouWin.show()
	elif lose:
		move_child($YouLose,3)
		$YouLose.show()
			

	

func _on_Quit_button_down():
	$Pause/PressedSound2.play()
	get_tree().paused = false
	move_child($Pause,0)
	$Pause.hide()
	paused = false
	get_tree().reload_current_scene()


func _on_Quit_mouse_entered():
	$Pause/Hoversound2.play()
	

