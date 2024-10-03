extends Control
class_name DocumentCanvas

@export var background_image: Sprite2D
@export var text_label: RichTextLabel
var document: Document
var document_text_array: Array[String]
var document_current_page: int = 0

signal faded_in
signal faded_out

func _ready() -> void:
	visible = false
	background_image.modulate.a = 0.0
	text_label.modulate.a = 0.0

func set_document(doc: Document) -> void:
	if doc == null or doc.document_image == null or doc.document_text == null:
		return
	
	document = doc
	
	visible = true
	background_image.texture = document.document_image
	document_text_array = document.document_text
	document_current_page = 0
	set_text(document.document_text[0])
	
func set_background(texture: Texture2D) -> void:
	if texture != null:
		background_image.texture = texture
		
func set_text(text: String) -> void:
	if text != null and document_text_array.size() == 1:
		text_label.text = "[center]" + text + "[/center]"
	elif text != null and document_text_array.size() > 1:
		text_label.text = "[center]" + text + "\n Page " + str(document_current_page + 1) + "/" + str(document_text_array.size()) + "[/center]"
		
func go_page(left_or_right: bool) -> void:
	if document_text_array == null or document_text_array.size() == 1:
		return
	if left_or_right == true and document_current_page > 0:
		document_current_page -= 1
		set_text(document_text_array[document_current_page])
	elif left_or_right == false and document_current_page + 1 < document_text_array.size():
		document_current_page += 1
		set_text(document_text_array[document_current_page])
	elif left_or_right == false and document_current_page + 1 == document_text_array.size():
		document_exit(0.5)
	else:
		return
	
func document_fade_in(seconds: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.parallel().tween_property(background_image, "modulate:a", 0.5, seconds)
	tween.parallel().tween_property(text_label, "modulate:a", 1.0, seconds)
	tween.tween_callback(faded_in.emit)
	
func document_exit(seconds: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.parallel().tween_property(background_image, "modulate:a", 0.0, seconds)
	tween.parallel().tween_property(text_label, "modulate:a", 0.0, seconds)
	tween.tween_callback(faded_out.emit)
	
	await faded_out
	visible = false
	Global.fade_camera(true, 0.25)
	PlayerManager.player_state = PlayerManager.PLAYER_READY

func _input(event: InputEvent) -> void:
	if PlayerManager.player_state != PlayerManager.PLAYER_IN_INSPECTING:
		return
	
	print("current page is ", document_current_page, " and size is ", document_text_array.size())
	if Input.is_action_just_pressed("moveleft"):
		go_page(true)
	if Input.is_action_just_pressed("moveright"):
		go_page(false)
	if Input.is_action_just_pressed("inventory"):
		document_exit(0.5)
