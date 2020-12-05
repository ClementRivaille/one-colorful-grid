extends Control
class_name Pipe

var duration := 60.0 / 115.0

export(PackedScene) var line_prefab: PackedScene

onready var lines: Control = $Lines

func add_line():
  var line: ColorRect = line_prefab.instance()
  lines.add_child(line)
  var line_tween: Tween = line.get_child(0)
  line_tween.interpolate_property(line, "anchor_left", 0.0, 1.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  line_tween.start()

func clear():
  while lines.get_child_count() > 0:
    remove_line()

func remove_line():
  if lines.get_child_count() > 0:
    var line: ColorRect = lines.get_child(0)
    var tween:Tween = line.get_child(0)
    tween.stop_all()
    lines.remove_child(line)
