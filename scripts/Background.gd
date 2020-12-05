extends ColorRect
class_name Background

export(Array, Color) var colors: Array

func set_level(level: int):
  color = colors[level]
