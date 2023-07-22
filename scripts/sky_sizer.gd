extends Container

@export var texture: Texture2D
@export var texture_rect : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().connect("size_changed", _on_viewport_resize)
	self.set_texture()
	self.size_texture_rect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_viewport_resize():
	self.size_texture_rect()

func set_texture():
	var texRect = self.texture_rect
	texRect.texture = self.texture

func size_texture_rect():
	var viewRect = get_viewport_rect()
	var texRect = self.texture_rect
	texRect.set_size(viewRect.size)
	
