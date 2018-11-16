extends Node2D


onready var _material = get_node("Sprite_Text").material;
var _is_running = false;
var _is_running_forever = false;
var _time = -1.0;
var burn_position = 0 setget _set_burn_position,  _get_burn_position;

func _ready():
	pass 

func _process(delta):
	if _is_running:
		_time += delta;
		$GridContainer/HSlider.value = _time;
		if _time > 1.0:
			if _is_running_forever:
				_time = -1.0;
			else:
				_is_running = false;
	pass

func _set_burn_position(value : float):
	burn_position = value;
	_material.set_shader_param("burn_position", value);
	pass

func _get_burn_position():
	return burn_position;
	
func _on_size_value_changed(value):
	_material.set_shader_param("burn_size", value);
	pass

func _on_current_position_value_changed(value : float):
	_set_burn_position(value);
	pass


func _on_run_from_start_pressed():
	_time = -1.0;
	_is_running = true;
	pass 


func _on_run_forever_pressed():
	_on_run_from_start_pressed();
	_is_running_forever = true;
	pass 


func _on_stop_pressed():
	_is_running = false;
	_is_running_forever = false;
	pass 

func _on_reseed_noise_pressed():
	var noise = OpenSimplexNoise.new();
	# this is only example, so we use "Default" noise texture
	# only with randomized seed
	noise.seed = randi();
	noise.octaves = 3;
	noise.period = 64;
	noise.persistence = 0.5;
	noise.lacunarity = 2;
	
	var noise_tex = NoiseTexture.new();
	noise_tex.width = 512;
	noise_tex.height = 256;
	noise_tex.noise = noise;
	
	_material.set_shader_param("noise_tex", noise_tex);
	pass
