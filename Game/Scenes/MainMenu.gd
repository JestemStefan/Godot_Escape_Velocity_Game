extends Control


"""
onready var VolPlus = $MainMenuScreen/OptionMenu/MusicVol/PlusCont/VolPlus
onready var VolMinus = $MainMenuScreen/OptionMenu/MusicVol/MinusCont/VolMinus


onready var SFXPlus = $MainMenuScreen/OptionMenu/SFXVol/PlusCont/SFXPlus
onready var SFXMinus = $MainMenuScreen/OptionMenu/SFXVol/MinusCont/SFXMinus"""

onready var VolBar = $MainMenuScreen/OptionMenu/MusicVol/MusicCont/MusicVolBar
onready var SFXBar = $MainMenuScreen/OptionMenu/SFXVol/SFXCont/SFXVolBar
#onready var MenuButtons = $MainMenuScreen/MenuButtons
onready var DifficultyMenu = $MainMenuScreen/DifficultyMenu
onready var OptionMenu = $MainMenuScreen/OptionMenu
onready var CreditsMenu = $MainMenuScreen/CreditsMenu
onready var ClickSound = $PressedSound
onready var HoverSound = $Hoversound
onready var MenuMusic = $MenuMusic

var startmenu_ispressed = false
var optionmenu_ispressed = false
var creditsmenu_ispressed = false

func _ready():
	MenuMusic.play()

#func _process(delta):
	#pass

func LoadGame():
	get_parent().isPlayed = true
	var root = get_parent()
	# Remove the current level
	var MenuLvl = root.get_node("MainMenu")
	root.remove_child(MenuLvl)
	MenuLvl.call_deferred("free")

# Add the next level
	var gameLvl = load("res://Scenes/MainScene.tscn")
	var next_level = gameLvl.instance()
	root.add_child(next_level)
	

func _on_VolMinus_button_down():
	ClickSound.play()
	if VolBar.value>-20:
		VolBar.value-=10
		get_parent().SoundVol = VolBar.value
		MenuMusic.volume_db -=10
		
func _on_VolPlus_button_down():
	ClickSound.play()
	if VolBar.value<20:
		VolBar.value+=10
		get_parent().SoundVol = VolBar.value
		MenuMusic.volume_db +=10
	

func _on_SFXMinus_button_down():
	ClickSound.play()
	if SFXBar.value>-20:
		SFXBar.value-=10
		get_parent().SFXVol = SFXBar.value
		ClickSound.volume_db += -10
		HoverSound.volume_db += -10

func _on_SFXPlus_button_down():
	ClickSound.play()
	if SFXBar.value<20:
		SFXBar.value+=10
		get_parent().SFXVol = SFXBar.value
		ClickSound.volume_db += 10
		HoverSound.volume_db += 10

func _on_VolMinus_mouse_entered():
	HoverSound.play()

func _on_VolPlus_mouse_entered():
	HoverSound.play()

func _on_SFXMinus_mouse_entered():
	HoverSound.play()

func _on_SFXPlus_mouse_entered():
	HoverSound.play()


func _on_StartButton_mouse_entered():
	HoverSound.play()


func _on_StartButton_button_down():
	ClickSound.play()
	
	if !startmenu_ispressed:
		CreditsMenu.hide()
		OptionMenu.hide()
		DifficultyMenu.show()
		creditsmenu_ispressed = false
		optionmenu_ispressed = false
		startmenu_ispressed = true
	else:
		DifficultyMenu.hide()
		startmenu_ispressed = false
	
	


func _on_OptionsButton_mouse_entered():
	HoverSound.play()


func _on_OptionsButton_button_down():
	ClickSound.play()
	
	if !optionmenu_ispressed:
		CreditsMenu.hide()
		OptionMenu.show()
		DifficultyMenu.hide()
		creditsmenu_ispressed = false
		optionmenu_ispressed = true
		startmenu_ispressed = false
	else:
		OptionMenu.hide()
		optionmenu_ispressed = false


func _on_CreditsButton_mouse_entered():
	HoverSound.play()



func _on_CreditsButton_button_down():
	ClickSound.play()
	
	if !creditsmenu_ispressed:
		CreditsMenu.show()
		OptionMenu.hide()
		DifficultyMenu.hide()
		creditsmenu_ispressed = true
		optionmenu_ispressed = false
		startmenu_ispressed = false
	else:
		CreditsMenu.hide()
		creditsmenu_ispressed = false


func _on_QuitButton_mouse_entered():
	HoverSound.play()


func _on_QuitButton_button_down():
	ClickSound.play()
	get_tree().quit()


func _on_Easy_mouse_entered():
	HoverSound.play()


func _on_Easy_button_down():
	ClickSound.play()
	get_parent().DifficultyLevel = 0
	LoadGame()


func _on_Medium_mouse_entered():
	HoverSound.play()


func _on_Medium_button_down():
	ClickSound.play()
	get_parent().DifficultyLevel = 0.5
	LoadGame()


func _on_Hard_mouse_entered():
	HoverSound.play()


func _on_Hard_button_down():
	ClickSound.play()
	get_parent().DifficultyLevel = 1
	LoadGame()


func _on_Impossible_mouse_entered():
	HoverSound.play()


func _on_Impossible_button_down():
	ClickSound.play()
	get_parent().DifficultyLevel = 1.5
	LoadGame()
