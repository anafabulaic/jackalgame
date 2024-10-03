shader_type spatial;

render_mode vertex_lighting, skip_vertex_transform, depth_prepass_alpha, diffuse_lambert_wrap, shadows_disabled, unshaded;
//render_mode unshaded, depth_prepass_alpha, fog_disabled;

global uniform sampler2D depth_pass;
uniform sampler2D image_texture: source_color;

const float vertex_snapping_offset = -1.0;
varying float vertex_distance;

void vertex() {
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;

    float z_origin = VERTEX.z;
    float snap_i = (1.0 - vertex_snapping_offset) * min(VIEWPORT_SIZE.x, VIEWPORT_SIZE.y) / 2.0;

    float projection_w = (PROJECTION_MATRIX * vec4(VERTEX, 1.0)).w;
    VERTEX = round(VERTEX / projection_w * snap_i) / snap_i * projection_w;
    VERTEX = VERTEX;

	UV *= VERTEX.z;
}

void fragment()
{
	float depth_raw = FRAGCOORD.z;
	float depth_compare = texture(depth_pass, SCREEN_UV).x;

	vec2 uv = UV / VERTEX.z;
	vec3 texture_rgb = (texture(image_texture, uv).rgb * COLOR.rgb);

	ALBEDO.rgb = texture_rgb;

	if(depth_raw < depth_compare) {
		discard;
		// ALPHA = 0.0;
	} else {
		ALPHA = 1.0;
	}
}