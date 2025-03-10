extends Control

@onready var initial: Control = $Panel/Initial

@onready var how_to_play: Control = $Panel/HowToPlay

@onready var options: Control = $Panel/Options

enum MENU_PAGES {INITIAL,HOWTOPLAY,OPTIONS}

@onready var language_option: OptionButton = $Panel/Options/Control4/VBoxContainer/Control2/HBoxContainer/LanguageOption

const CLICK_CLICK_MONO = preload("res://Assets/Sounds/click-click-mono.wav")


func _ready() -> void:
	change_menu(MENU_PAGES.INITIAL)
	
	language_option.select(1 if TranslationServer.get_locale().begins_with("pt") else 0) 
	

func change_menu(menu : MENU_PAGES):
	
	initial.visible = false
	initial.mouse_filter = Control.MOUSE_FILTER_PASS
	
	how_to_play.visible = false
	how_to_play.mouse_filter = Control.MOUSE_FILTER_PASS
	
	options.visible = false
	options.mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Worse way of making a menu, I know, leave me alone, I have no time and 
	# I'm doing this with 4 hours remaining for the end of the JAM
	match menu:
		MENU_PAGES.INITIAL:
			initial.visible = true
			initial.mouse_filter = Control.MOUSE_FILTER_STOP
		
		MENU_PAGES.HOWTOPLAY:
			how_to_play.visible = true
			how_to_play.mouse_filter = Control.MOUSE_FILTER_STOP
			
		MENU_PAGES.OPTIONS:
			options.visible = true
			options.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_start_button_up() -> void:
	
	Globals.to_level()


func _on_how_to_play_button_up() -> void:
	change_menu(MENU_PAGES.HOWTOPLAY)
	Globals.sfx.stream = CLICK_CLICK_MONO
	Globals.sfx.play()


func _on_htp_back_button_up() -> void:
	change_menu(MENU_PAGES.INITIAL)
	Globals.sfx.stream = CLICK_CLICK_MONO
	Globals.sfx.play()


func _on_options_button_up() -> void:
	change_menu(MENU_PAGES.OPTIONS)
	Globals.sfx.stream = CLICK_CLICK_MONO
	Globals.sfx.play()


func _on_opt_back_button_up() -> void:
	change_menu(MENU_PAGES.INITIAL)
	Globals.sfx.stream = CLICK_CLICK_MONO
	Globals.sfx.play()


func _on_language_option_item_selected(index: int) -> void:
	TranslationServer.set_locale(language_option.get_item_text(index))




func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUSIC"), linear_to_db(value))
