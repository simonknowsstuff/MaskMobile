extends Control

const BARS = 9
const MAX_HZ = 11050.0
const MIN_DB = 60

var MAX_HEIGHT: float = 0
var MAX_WIDTH: float = 0
var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
var SPECTRUM_ANALYZER

onready var MusicPlayer = $AudioStreamPlayer
onready var LiveVisualizer = $MainVContainer/ScreenSpace/AudioContainer/LiveVisualizer

func _ready():
	MAX_HEIGHT = LiveVisualizer.rect_size.y
	MAX_WIDTH = LiveVisualizer.rect_size.x
	SPECTRUM_ANALYZER = AudioServer.get_bus_effect_instance(MUSIC_BUS_ID, 0)

func _process(_delta):
	update()
	
func _draw():
	var prev_hz = 0.0
	var prev_height = 0.0
	for i in range(1, BARS+1):
		var hz: float = i * MAX_HZ / BARS
		var mag: float = SPECTRUM_ANALYZER.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear2db(mag)) / MIN_DB, 0, 1)
		
		var color_rect_pos = Vector2(LiveVisualizer.rect_global_position.x * i, LiveVisualizer.rect_global_position.y + MAX_HEIGHT)
		var color_rect_size = Vector2(MAX_WIDTH / BARS, energy * MAX_HEIGHT)
		var color_rect = Rect2(color_rect_pos, color_rect_size)
		draw_rect(color_rect, Color.white)
		prev_hz = hz
		prev_height = color_rect.size.y
	
