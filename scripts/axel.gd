extends CharacterBody2D

const SPEED := 115.0
const JUMP_VELOCITY := -310.0
const GRAVITY := 850.0

var facing := 1.0
var walk_time := 0.0

func _physics_process(delta: float) -> void:
    var direction := Input.get_axis("move_left", "move_right")
    if direction != 0.0:
        facing = sign(direction)
        walk_time += delta * 10.0
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0.0, SPEED * 7.0 * delta)

    if not is_on_floor():
        velocity.y += GRAVITY * delta
    elif Input.is_action_just_pressed("jump"):
        velocity.y = JUMP_VELOCITY

    if Input.is_action_just_released("jump") and velocity.y < -110.0:
        velocity.y = -110.0

    move_and_slide()
    queue_redraw()

func _draw() -> void:
    var bob := sin(walk_time) * 1.5 if absf(velocity.x) > 5.0 and is_on_floor() else 0.0
    var dark := Color("#171321")
    var darker := Color("#0d0b16")
    var scarf := Color("#812c50")
    var scarf_light := Color("#a34468")
    var amber := Color("#ffc66d")

    # Tail
    draw_colored_polygon(PackedVector2Array([
        Vector2(8 * facing, -17 + bob), Vector2(24 * facing, -12 + bob),
        Vector2(31 * facing, -17 + bob), Vector2(25 * facing, -7 + bob),
        Vector2(8 * facing, -9 + bob)
    ]), dark)

    # Small body and legs
    draw_rect(Rect2(-10, -27 + bob, 20, 22), dark)
    draw_rect(Rect2(-9, -8 + bob, 7, 9), darker)
    draw_rect(Rect2(2, -8 + bob, 7, 9), darker)

    # Oversized cat head with pointed ears
    draw_colored_polygon(PackedVector2Array([
        Vector2(-20, -43 + bob), Vector2(-19, -62 + bob),
        Vector2(-8, -55 + bob), Vector2(0, -59 + bob),
        Vector2(9, -55 + bob), Vector2(20, -63 + bob),
        Vector2(20, -42 + bob), Vector2(15, -30 + bob),
        Vector2(0, -25 + bob), Vector2(-15, -30 + bob)
    ]), dark)

    # Scarf around neck, with a long red end
    draw_rect(Rect2(-13, -32 + bob, 26, 7), scarf)
    draw_colored_polygon(PackedVector2Array([
        Vector2(4, -27 + bob), Vector2(13, -27 + bob),
        Vector2(17, -2 + bob), Vector2(8, -5 + bob)
    ]), scarf_light)

    # Amber eyes
    var eye_y := -43 + bob
    draw_rect(Rect2(-12, eye_y, 8, 6), amber)
    draw_rect(Rect2(4, eye_y, 8, 6), amber)
    draw_rect(Rect2(-8, eye_y, 2, 6), Color("#39243a"))
    draw_rect(Rect2(8, eye_y, 2, 6), Color("#39243a"))

    # Expandable staff, held at the side
    draw_line(Vector2(12 * facing, -16 + bob), Vector2(25 * facing, -3 + bob), Color("#b9a0a8"), 2.0)
    draw_circle(Vector2(25 * facing, -3 + bob), 2.0, Color("#e2c4bd"))
