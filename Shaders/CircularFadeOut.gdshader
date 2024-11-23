shader_type canvas_item;

uniform float circle_size : hint_range(0.0, 1.0) = 0.0f;

void fragment() {
	if (distance(vec2(0.5, 0.5), UV) < circle_size) {
		discard;
	}
}