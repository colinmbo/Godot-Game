shader_type spatial;
render_mode unshaded;

uniform bool Is_White;
uniform bool Color_Override;
uniform vec4 Color : hint_color;
uniform bool Horizontal_Dither;
uniform bool Vertical_Dither;
uniform sampler2D Sprites : hint_albedo;

void vertex() {

	//Billboard
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],CAMERA_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]);
	
	float sc = 0f;
	if(-(MODELVIEW_MATRIX)[3].z / PROJECTION_MATRIX[0][0] > 18f) {
		sc = 1f;
	} else {
		sc = (-(MODELVIEW_MATRIX)[3].z / PROJECTION_MATRIX[0][0]) * 0.1 * (5f/9f);
	}
	
	MODELVIEW_MATRIX[0]*=sc;
	MODELVIEW_MATRIX[1]*=sc;
	MODELVIEW_MATRIX[2]*=sc;

}

void fragment() {

	vec4 n_tex_read = texture(Sprites, UV.xy);
	vec3 texcol = n_tex_read.rgb;
	float texalpha = n_tex_read.a;

	if (Is_White) {
		texcol = vec3(1f);
	}
	
	if (Color_Override) {
		if (length(texcol) < 0.02) {
			// Black Cut
			texalpha = 0f;
		}
		texcol = Color.rgb;
	}
	
	vec2 ss = vec2(textureSize(SCREEN_TEXTURE, 0));
	if (Vertical_Dither && int((SCREEN_UV * ss).x) % 2 == 1) {
		texalpha = 0f;
	} if (Horizontal_Dither && int((SCREEN_UV * ss).y) % 2 == 1) {
		texalpha = 0f;
	}

	ALBEDO = texcol;
	ALPHA = texalpha;
	//ALPHA_SCISSOR = 0.98;

}