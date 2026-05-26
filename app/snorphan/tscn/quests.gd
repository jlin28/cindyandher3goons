extends VBoxContainer

@onready var quest_boxes := self.get_children()
@onready var MultiplayerClient := get_tree().get_first_node_in_group('socket')

signal update_quests

func _ready() -> void:
	fetch_quests()
	update_quests.connect(_on_quests_update)

func _on_quests_update():
	fetch_quests()

func fetch_quests():
	quests = MultiplayerClient.fetch_quests()
