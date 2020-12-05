extends Control

onready var music: Music = $Music
onready var instrument: Instruments = $Instruments
onready var melody = $Melody
onready var visualizer: Visualizer = $Visualizer

var playing := false

func _ready():
  music.connect("beat", melody, "on_beat")
  melody.connect("play", self, "play_lead")
  melody.init()
  
func _input(event: InputEvent):
  if event.is_action_pressed("ui_accept") && !playing:
    music.start()
    playing = true
    
  if playing:
    if event.is_action_pressed("ui_down"):
      visualizer.press(0)
    if event.is_action_pressed("ui_left"):
      visualizer.press(1)
    if event.is_action_pressed("ui_right"):
      visualizer.press(2)
    if event.is_action_pressed("ui_up"):
      visualizer.press(3)
    
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
