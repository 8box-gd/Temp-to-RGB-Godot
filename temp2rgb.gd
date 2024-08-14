extends Node2D

@onready var color_rect = $ColorRect
@onready var slider = $HSlider
@onready var label = $Label

## Helland's Temperature (K) to RGB (Normalized) algorithm
func temp_to_rgb(temp: float) -> Color:
	temp = clamp(temp, 1000.0, 40000.0)
	temp = temp / 100.0
	
	# Red
	var r: float
	if temp <= 66.0:
		r = 1.0
	else:
		r = temp - 60.0
		r = 329.698727446 * (r ** -0.1332047592)
		r = r / 255.0
		r = clamp(r, 0.0, 1.0)
	
	# Green
	var g: float
	if temp <= 66.0:
		g = temp
		g = 99.4708025861 * log(g) - 161.1195681661
		g = g / 255.0
		g = clamp(g, 0.0, 1.0)
	else:
		g = temp - 60.0
		g = 288.1221695283 * (g ** -0.0755148492)
		g = g / 255.0
		g = clamp(g, 0.0, 1.0)
	
	# Blue
	var b: float
	if temp >= 66.0:
		b = 1.0
	elif temp <= 19.0:
		b = 0.0
	else:
		b = temp - 10.0
		b = 138.5177312231 * log(b) - 305.0447927307
		b = b / 255.0
		b = clamp(b, 0.0, 1.0)
	
	return Color(r, g, b)


# Everything below this point is just code to make the Godot program work

func _ready() -> void:
	update_everything()

func update_everything() -> void:
	color_rect.color = temp_to_rgb(slider.value)
	label.text = ("Input temp: " + str(slider.value) + " K
	Output color: ("
	+ str(snapped(color_rect.color.r, 0.01)) +", "
	+ str(snapped(color_rect.color.g, 0.01)) +", "
	+ str(snapped(color_rect.color.b, 0.01)) + ")")

func _on_h_slider_value_changed(_value) -> void:
	update_everything()
