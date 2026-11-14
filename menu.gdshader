
shader_type canvas_item;

uniform vec4 first_color : source_color = vec4(0.749, 1.0, 0.937, 1.0);
uniform vec4 second_color : source_color = vec4(0.569, 0.949, 0.761, 1.0);

uniform float position : hint_range(-0.5, 0.5) = 0.0;
uniform float size : hint_range(0.0, 1.0) = 0.5;
uniform float angle : hint_range(0.0, 360.0) = 0.0;

uniform float balance_speed = 1.0;
uniform float balance_amount : hint_range(0.0, 0.5) = 0.3;
uniform float fade_width : hint_range(0.01, 2.0) = 0.5;

void fragment() {
    float pivot = position + 0.5;
    vec2 uv = UV - pivot;

    float rotated = uv.x * cos(radians(angle)) - uv.y * sin(radians(angle));

    float balance = sin(TIME * balance_speed) * balance_amount;

    float pos = smoothstep(
        -fade_width + balance,
        fade_width + balance,
        rotated
    );

    vec4 gradient = mix(first_color, second_color, pos);

    COLOR = gradient;
}
