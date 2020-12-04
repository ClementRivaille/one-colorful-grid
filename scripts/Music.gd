extends Node2D
class_name Music

signal beat
signal bar
signal end

onready var mixing_desk = $MixingDesk
onready var layers = $MixingDesk/Song/AutoLayerContainer
onready var end_layer = $MixingDesk/Song/EndLayer

var index := 1
var ending := false
var ended := false
var credits := false

func _ready():
  mixing_desk.init_song(0)
  $MixingDesk/Song/EndLayer/layer5.bus = "EndEffect"
  mixing_desk.connect("end", self, "on_end")
  mixing_desk.connect("bar", self, "on_bar")
  mixing_desk.connect("beat", self, "on_beat")

func _input(event: InputEvent):
  if event.is_action_pressed("ui_accept"):
    if mixing_desk.playing:
      mixing_desk.stop(0)
    else:
      mixing_desk.start_alone(0,0)
  
  if !ended:
    if event.is_action_pressed("ui_right") && !ending:
      index = int(min(5.0, index+1))
      layers.layer_max = index
    if event.is_action_pressed("ui_left"):
      if index == 5:
        cancel_end()
      else:
        index = int(max(-1, index -1))
        layers.layer_max = index
    
  if index == 5 && !ending:
    trigger_end()

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

func on_end(_song):
  if index == 5 && !ending && !ended:
    ending = true
  elif ending && !ended:
    end_layer.track_speed = 1.0
    end_layer.layer_max = -1
    ended = true    
  
  emit_signal("end")

func on_beat(_beat):
  if ended && !credits:
    mixing_desk.queue_bar_transition(0)
    credits = true
    
  emit_signal("beat")

func on_bar(_bar):
  if credits:
    layers.track_speed = 1.0
    layers.layer_max = 5
    
  emit_signal("bar")


