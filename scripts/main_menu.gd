extends Control

onready var ip_enter = $MainMenu/InputContainer/HContainer/IPEnter

func _on_IPButton_pressed():
	if ip_enter.text.is_valid_ip_address():
		print("Establishing connection!")
		MaskCommunicator.establish_mask_conn(ip_enter.text, 2006)
	return
