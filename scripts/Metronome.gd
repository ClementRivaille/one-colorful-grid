extends AudioStreamPlayer
class_name Metronome

signal started
signal beat_ended

export var bpm := 115.0
var debug: Label
export(bool) var debugging := false

var beat_length: float
var next_beat: float = 0.0
var last_beat := 0.0
var index := -1
var song_length = 32

var active_beat := -1
var MARGIN := .06
var accepting := false

func _ready():
  beat_length = 60.0 / (bpm * 2.0)
  if debugging:
    debug = Label.new()
    debug.rect_scale = Vector2(2,2)
    debug.visible = false
    add_child(debug)

func play(from: float = 0.0):
  .play(from)
  next_beat = beat_length
  
  index = 0
  active_beat = 0
  last_beat = 0.0
  accepting = true
  
  emit_signal("started", self)
  if debugging:
    debug.visible = true

func _process(_delta):
  if playing:
    var position := get_playback_position()
    
    if position >= (next_beat - MARGIN) && position < next_beat && !accepting :
      accepting = true
      active_beat = (index + 1) % song_length
      if debugging:
        debug.text = str(active_beat)
        debug.visible = true && debugging
      
    if position >= next_beat:
      while position >= next_beat:
        index = (index + 1) % song_length
        last_beat = next_beat
        next_beat += beat_length
        
    if position >= (last_beat + MARGIN) && position < (next_beat - MARGIN) && accepting:
      accepting = false
      emit_signal("beat_ended", active_beat)
      active_beat = -1
      if debugging:
        debug.visible = false

func get_active_beat() -> int:
  return active_beat
