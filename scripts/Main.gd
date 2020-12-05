extends Control

onready var music: Music = $Music
onready var instrument: Instruments = $Instruments
onready var melody = $Melody
onready var visualizer: Visualizer = $Visualizer
onready var validator: Validator = $Validator
onready var sfx: SFX = $SFX

var playing := false

func _ready():
  music.connect("beat", melody, "on_beat")
  melody.connect("play", self, "play_lead")
  music.connect("beat_ended", validator, "on_beat_end")
  validator.connect("missed", self, "on_miss")
  melody.init()
  
func _input(event: InputEvent):
  if event.is_action_pressed("ui_accept") && !playing:
    music.start()
    playing = true
    
  if playing:
    if event.is_action_pressed("ui_down"):
      play_note(0)
    if event.is_action_pressed("ui_left"):
      play_note(1)
    if event.is_action_pressed("ui_right"):
      play_note(2)
    if event.is_action_pressed("ui_up"):
      play_note(3)
    
    if event.is_action_released("ui_down"):
      visualizer.release(0)
    if event.is_action_released("ui_left"):
      visualizer.release(1)
    if event.is_action_released("ui_right"):
      visualizer.release(2)
    if event.is_action_released("ui_up"):
      visualizer.release(3)

func play_lead(note_idx: int):
  instrument.play_lead(music.current_bar, note_idx)
  visualizer.add_note(note_idx)
  validator.add_note(note_idx, music.get_active_beat())
  
func play_note(value: int):
  visualizer.press(value)
  var valid = validator.read_note(value, music.get_active_beat())
  if valid == Validator.validation.INVALID:
    on_miss()
  elif valid == Validator.validation.VALID:
    visualizer.validate_note(value)
    instrument.play_player(music.current_bar, value)

func on_miss():
  sfx.play_error()
  visualizer.clear()
  validator.clear()
  melody.clear()

