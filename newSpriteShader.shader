shader_type spatial;
render_mode unshaded;

uniform bool Is_White;
uniform sampler2D Sprites : hint_albedo;

uniform float cam_dist;


// GlobalExpression:0
	uniform sampler2D tex : hint_albedo;

void vertex() {
// Expression:2

	//Billboard
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],CAMERA_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]);
	
	//No idea where 2.7 comes from. Thought it should be PI but 3.14 ended up being too big
	float fov = atan(1.0 / PROJECTION_MATRIX[0][0]) * 2.0;
	//float sc = -(MODELVIEW_MATRIX)[3].z;
	//float sc = -(MODELVIEW_MATRIX)[3].z * (fov/3.14);
	//float sc = -(MODELVIEW_MATRIX)[3].z / (PROJECTION_MATRIX[1][1] * 1.35);
	//float sc =  (atan((fov/2.0)) * -(MODELVIEW_MATRIX)[3].z);
	//float sc = -(MODELVIEW_MATRIX)[3].z PROJECTION_MATRIX[0][0];
	//float sc = tan(fov / 2.0) * -(MODELVIEW_MATRIX)[3].z * 2.0;
	//float sc = -(MODELVIEW_MATRIX)[3].z * 
	//float sc = 360.0/(tan(fov / 2.0) * -(MODELVIEW_MATRIX)[3].z * 2.0);
	//float sc = (-(MODELVIEW_MATRIX)[3].z / PROJECTION_MATRIX[0][0]);
	//vec3 world_camera = (CAMERA_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	//sc *= 1.0/(distance(vec3(0.0, 0.0, 0.0), world_camera) * 0.1);
	//vec3 world_cam = vec4(CAMERA_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	//sc *= distance(world_cam, vec3(world_cam.x, world_cam.y, world_cam.z + 100));
	//float sc = (-(MODELVIEW_MATRIX)[3].z / PROJECTION_MATRIX[0][0]);
	
	//float sc = (-(MODELVIEW_MATRIX)[3].z / PROJECTION_MATRIX[0][0]) / (tan(fov/2.0)*(cam_dist)*0.1);
	
	// SECOND RENDITION
	float sc = 0.0;
	if(-(MODELVIEW_MATRIX)[3].z / PROJECTION_MATRIX[0][0] > 18.0) {
		sc = 1.0;
	} else {
		sc = (-(MODELVIEW_MATRIX)[3].z / PROJECTION_MATRIX[0][0]) * 0.055;
	}
	
	MODELVIEW_MATRIX[0]*=sc;
	MODELVIEW_MATRIX[1]*=sc;
	MODELVIEW_MATRIX[2]*=sc;
	
	//set_fov(2*rad2deg(atan(18/get_translation().z)))
	/*
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],CAMERA_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]);
	float sc = -MODELVIEW_MATRIX[3].z * 0.01;
	MODELVIEW_MATRIX[0] *= sc;
	MODELVIEW_MATRIX[1] *= sc;
	MODELVIEW_MATRIX[2] *= sc;*/

// Output:0

}

void fragment() {
// BooleanUniform:6
	bool n_out6p0 = Is_White;

// Color:8
	vec3 n_out8p0 = vec3(1.000000, 1.000000, 1.000000);
	float n_out8p1 = 1.000000;

// TextureUniform:2
	vec3 n_out2p0;
	float n_out2p1;
	{
		vec4 n_tex_read = texture(Sprites, UV.xy);
		n_out2p0 = n_tex_read.rgb;
		n_out2p1 = n_tex_read.a;
	}

// VectorSwitch:7
	vec3 n_out7p0;
	if(n_out6p0)
	{
		n_out7p0 = n_out8p0;
	}
	else
	{
		n_out7p0 = n_out2p0;
	}

// Scalar:3
	float n_out3p0 = 0.980000;

// Output:0
	ALBEDO = n_out7p0;
	ALPHA = n_out2p1;
	ALPHA_SCISSOR = n_out3p0;

}

void light() {
// Output:0

}
