extends Control

@onready var master_slider: HSlider = %master_vol_slider
@onready var sfx_slider: HSlider = %sfx_vol_slider
@onready var music_slider: HSlider = %music_vol_slider
@onready var mouse_slider: HSlider = %mouse_sens_slider
@onready var apply: Button = %apply_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_saved_settings()
	
	master_slider.value_changed.connect(on_master_changed)
	sfx_slider.value_changed.connect(on_sfx_changed)
	music_slider.value_changed.connect(on_music_changed)
	mouse_slider.value_changed.connect(on_mouse_changed)
	apply.pressed.connect(save_all)
	
	visibility_changed.connect(on_visibility_changed)

func on_visibility_changed() -> void:
	load_saved_settings()

func load_saved_settings() -> void:
	if OS.has_feature("web"):
		master_slider.value = float(JavaScriptBridge.eval("localStorage.getItem('mVol') || 50", true))
		sfx_slider.value = float(JavaScriptBridge.eval("localStorage.getItem('sfxVol') || 50", true))
		music_slider.value = float(JavaScriptBridge.eval("localStorage.getItem('aVol') || 0", true))
		mouse_slider.value = float(JavaScriptBridge.eval("localStorage.getItem('mouseSens') || 50", true))
	else:
		master_slider.value = 50
		sfx_slider.value = 50
		music_slider.value = 0
		mouse_slider.value = 50
	apply_all()
	
func apply_all() -> void:
	set_bus_volume("Master", master_slider.value)
	set_bus_volume("SFX", sfx_slider.value)
	set_bus_volume("Music", music_slider.value)
	on_mouse_changed(mouse_slider.value)

func save_all() -> void:
	save_setting("mVol", master_slider.value)
	save_setting("sfxVol", sfx_slider.value)
	save_setting("aVol", music_slider.value)
	save_setting("mouseSens", mouse_slider.value)

func on_master_changed(value: float) -> void:
	set_bus_volume("Master", value)

func on_sfx_changed(value: float) -> void:
	set_bus_volume("SFX", value)

func on_music_changed(value: float) -> void:
	set_bus_volume("Music", value)
	
func on_mouse_changed(value: float) -> void:
	var player = get_tree().get_first_node_in_group("player") # please woprk
	var pivot = player.get_node("pivot")
	pivot.mouse_sensitivity = max(0.001, value * 0.0002) # since vals are 0-100

func set_bus_volume(bus_name: String, value: float) -> void:
	# godot has an audio bus!!! (named sound channels) yay!
	var bus_i = AudioServer.get_bus_index(bus_name)
	if bus_i == -1:
		print("Audio bus not found: ", bus_name)
		return
	var p = value / 100.0
	if p <= 0:
		AudioServer.set_bus_volume_db(bus_i, -80) # vol measured in decibals!
	else:
		AudioServer.set_bus_volume_db(bus_i, linear_to_db(p))

func save_setting(key: String, value: float) -> void:
	# in-game setting changes back to browser
	if OS.has_feature("web"):
		JavaScriptBridge.eval("localStorage.setItem('%s', '%s')" % [key, str(value)], true)
