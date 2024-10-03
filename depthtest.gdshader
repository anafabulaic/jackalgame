shader_type spatial;

render_mode unshaded, fog_disabled;

varying mat4 CAMERA;
uniform sampler2D depthbuffer : filter_nearest;
uniform sampler2D bg : filter_nearest;
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_nearest;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	float depth_raw = texture(depth_texture, SCREEN_UV).x;
	float depth_compare = texture(depthbuffer, SCREEN_UV).x;
	
	if (depth_raw > depth_compare) {
		if (depth_compare == 0.0) {
			ALBEDO.rgb = texture(bg, SCREEN_UV).rgb;
		} else {
			ALPHA = 0.0;
		}
	} else {
		ALBEDO.rgb = texture(bg, SCREEN_UV).rgb;
	}
}