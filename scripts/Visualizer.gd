extends Control
class_name Visualizer

onready var bottom_pipe: Pipe = $Bottom
onready var left_pipe: Pipe = $Left
onready var right_pipe: Pipe = $Right
onready var top_pipe: Pipe = $Top

onready var bottom_center: ColorRect = $Center/Bottom
onready var left_center: ColorRect = $Center/Left
onready var right_center: ColorRect = $Center/Right
onready var top_center: ColorRect = $Center/Top

var pipes: Array
var center: Array

func _ready():
  pipes = [bottom_pipe, left_pipe, right_pipe, top_pipe]
  center = [bottom_center, left_center, right_center, top_center]
  
func add_note(note: int):
  var pipe: Pipe = pipes[note]
  pipe.add_line()

func clear():
  for pipe in pipes:
    pipe.clear()
  
func validate_note(note: int):
  var pipe: Pipe = pipes[note]
  pipe.remove_line()

func press(note: int):
  var position: ColorRect = center[note]
  position.visible = true
  
func release(note: int):
  var position: ColorRect = center[note]
  position.visible = false
