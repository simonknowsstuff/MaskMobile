extends Control

var led_data: Dictionary = {}

func _ready():
	MaskCommunicator.establish_mask_conn("192.168.2.194", 2006)

func _on_ColorPicker_color_changed(color: Color):
	led_data = {}
	led_data["all"] = "0x" + color.to_html(false)
	MaskCommunicator.send_data(led_data)
