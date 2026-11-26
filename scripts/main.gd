extends Node2D

const AXEL_SCENE := preload("res://scenes/axel.tscn")

var axel: CharacterBody2D

func _ready() -> void:
    _setup_input()
    _make_world()
    _make_touch_controls()
    axel = AXEL_SCENE.instantiate()
    axel.position = Vector2(90, 205)
    add_child(axel)

func _setup_input() -> void:
    _add_key_action("move_left", [KEY_A, KEY_LEFT])
    _add_key_action("move_right", [KEY_D, KEY_RIGHT])
    _add_key_action("jump", [KEY_SPACE, KEY_W, KEY_UP])

func _add_key_action(action: String, keys: Array) -> void:
    if not InputMap.has_action(action):
        InputMap.add_action(action)
    for keycode in keys:
        var event := InputEventKey.new()
        event.physical_keycode = keycode
        if not InputMap.action_has_event(action, event):
            InputMap.action_add_event(action, event)

func _make_world() -> void:
    var floor_body := StaticBody2D.new()
    floor_body.position = Vector2(240, 250)
    add_child(floor_body)

    var floor_shape := CollisionShape2D.new()
    var rectangle := RectangleShape2D.new()
    rectangle.size = Vector2(1200, 40)
    floor_shape.shape = rectangle
    floor_body.add_child(floor_shape)

    queue_redraw()

func _draw() -> void:
    draw_rect(Rect2(-1000, -500, 2200, 800), Color("#100d22"))
    # Distant dreamlike hills
    draw_colored_polygon(PackedVector2Array([
        Vector2(-500, 215), Vector2(-350, 110), Vector2(-220, 175),
        Vector2(-70, 95), Vector2(80, 175), Vector2(240, 105),
        Vector2(410, 175), Vector2(570, 100), Vector2(800, 205),
        Vector2(800, 300), Vector2(-500, 300)
    ]), Color("#211a3d"))
    # Moon
    draw_circle(Vector2(350, 82), 25, Color("#a88bb8"))
    draw_circle(Vector2(360, 75), 24, Color("#211a3d"))
    # Ground and path
    draw_rect(Rect2(-500, 250, 1500, 80), Color("#211c2c"))
    draw_rect(Rect2(-500, 250, 1500, 3), Color("#51405c"))
    # Small distant lights
    for i in range(28):
        var x := float((i * 67) % 850) - 300.0
        var y := float((i * 31) % 190) + 25.0
        draw_rect(Rect2(x, y, 2, 2), Color(0.72, 0.64, 0.9, 0.65))

func _make_touch_controls() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)

    _add_touch_button(layer, "◀", Vector2(18, -82), "move_left")
    _add_touch_button(layer, "▶", Vector2(112, -82), "move_right")
    _add_touch_button(layer, "SALTO", Vector2(-104, -82), "jump", true)

func _add_touch_button(layer: CanvasLayer, caption: String, offset: Vector2, action: String, right_side := false) -> void:
    var button := TouchScreenButton.new()
    button.action = action
    button.visibility_mode = TouchScreenButton.VISIBILITY_ALWAYS
    button.position = Vector2(0, 0)
    layer.add_child(button)

    # A visible, finger-friendly button is drawn separately.
    var visual := Button.new()
    visual.text = caption
    visual.custom_minimum_size = Vector2(76, 62) if caption != "SALTO" else Vector2(94, 62)
    visual.add_theme_font_size_override("font_size", 22)
    visual.modulate = Color(0.85, 0.78, 1.0, 0.88)
    visual.anchor_left = 1.0 if right_side else 0.0
    visual.anchor_right = 1.0 if right_side else 0.0
    visual.anchor_top = 1.0
    visual.anchor_bottom = 1.0
    visual.offset_left = offset.x
    visual.offset_right = offset.x + visual.custom_minimum_size.x
    visual.offset_top = offset.y
    visual.offset_bottom = offset.y + visual.custom_minimum_size.y
    layer.add_child(visual)
    visual.button_down.connect(func(): Input.action_press(action))
    visual.button_up.connect(func(): Input.action_release(action))
