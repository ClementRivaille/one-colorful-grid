extends Node2D

onready var music: Music = $Music
onready var instrument: Instruments = $Instruments
onready var melody = $Melody


func _ready():
  music.connect("beat", melody, "on_beat")
  melody.connect("play", self, "play_lead")

func play_lead(note_idx: int):
  instrument.play_lead(music.current_bar, note_idx)
