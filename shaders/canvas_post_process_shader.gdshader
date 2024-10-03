shader_type canvas_item;

uniform float intensity;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

vec4 process(vec4 base, vec4 blend){
	return base + blend - 1.0;
	//return 1.0 - (1.0 - base) / blend;
}

void fragment() {
	vec4 screen_sample = texture(screen_texture, SCREEN_UV);

	COLOR = process(screen_sample, vec4(intensity, intensity, intensity, 1.0));
}