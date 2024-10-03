shader_type spatial;

uniform sampler2D depthbuffer;

render_mode vertex_lighting, skip_vertex_transform, depth_prepass_alpha, diffuse_lambert_wrap, shadows_disabled, unshaded;
//render_mode unshaded, depth_prepass_alpha, fog_disabled;

uniform sampler2D depth_tex : hint_depth_texture;

void fragment()
{
	float depth_raw = FRAGCOORD.z;
	float depth_compare = texture(depthbuffer, SCREEN_UV).x;

	// vec2 uv = UV / VERTEX.z;
	// ALBEDO.rgb = texture_rgb;
	ALBEDO.rgb = vec3(depth_compare);

	if(depth_raw < depth_compare) {
		ALPHA = 0.0;
	} else {
		ALPHA = 1.0;
	}
}