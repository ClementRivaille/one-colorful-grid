extends Node2D
class_name Music

signal beat
signal bar
signal end
signal beat_ended

onready var mixing_desk = $MixingDesk
onready var layers = $MixingDesk/Song/AutoLayerContainer
onready var end_layer = $MixingDesk/Song/EndLayer
var metronome: Metronome

var current_bar := 0

var index := 1
var ending := false

func _ready():
  mixing_desk.init_song(0)
  $MixingDesk/Song/EndLayer/layer5.bus = "EndEffect"
  mixing_desk.connect("end", self, "on_end")
  mixing_desk.connect("bar", self, "on_bar")
  mixing_desk.connect("beat", self, "on_beat")

func start():
  mixing_desk.start_alone(0,0)

func stop_after_bar():
  mixing_desk.stop(0)
  
func set_layer(index: int):
  layers.layer_max = index

func trigger_end():
  layers.track_speed = 0.5;
  layers.layer_max = -1;
  end_layer.layer_max = 0;
  
func cancel_end():
  index = 4;
  layers.track_speed = 0.8;
  layers.layer_max = index;
  end_layer.layer_max = -1;
  ending = false
  
func validate_end():
  ending = true

func on_end(_song):
  emit_signal("end")
  
  if ending:
    ending = false
    end_layer.track_speed = 1.0
    end_layer.layer_max = -1
    yield(mixing_desk, "beat")
    mixing_desk.queue_bar_transition(0)
    yield(mixing_desk, "bar")
    layers.track_speed = 1.0
    layers.layer_max = 5

func on_beat(beat):
  emit_signal("beat", beat - 1)

func on_bar(bar):
  current_bar = (bar - 1)%4
  emit_signal("bar", current_bar)
  print(current_bar)

func on_metronome_started(instance: Metronome):
  if metronome:
    metronome.disconnect("beat_ended", self, "on_beat_ended")
  metronome = instance
  metronome.connect("beat_ended", self, "on_beat_ended")
  
func on_beat_ended(beat: int):
  emit_signal("beat_ended", beat)

func get_active_beat() -> int:
  if metronome && metronome.playing:
    return metronome.get_active_beat()
  return -1
