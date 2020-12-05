extends Node2D
class_name Instruments

onready var lead: Multisampler = $Lead
onready var player: Multisampler = $Player

var lead_notes := [
  [["A", 3], ["C", 4], ["E", 4], ["A", 4]],
  [["G", 3], ["C", 4], ["E", 4], ["C", 5]],
  [["F", 3], ["A", 3], ["C", 4], ["F", 4]],
  [["E", 3], ["Ab", 3], ["B", 3], ["E", 4]]
]

var player_notes := [
  [["C", 4], ["E", 4], ["A", 4], ["C", 5]],
  [["C", 4], ["E", 4], ["G", 4], ["C", 5]],
  [["C", 4], ["F", 4], ["A", 4], ["C", 5]],
  [["D", 4], ["E", 4], ["Ab", 4], ["D", 5]],
]

func play_lead(bar: int, note_idx: int):
  var notes: Array = lead_notes[bar]
  var note: Array = notes[note_idx]
  lead.play_note(note[0], note[1])

func play_player(bar: int, note_idx: int):
  var notes: Array = player_notes[bar]
  var note: Array = notes[note_idx]
  player.play_note(note[0], note[1])
