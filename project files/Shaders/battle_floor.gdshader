shader_type spatial;

uniform vec3 colour_1 : source_color;
uniform vec3 colour_2 : source_color;

uniform float time_scale : hint_range(0.0, 10.0, 0.25) = 1.0;

uniform float mix_amount :hint_range(0.0, 1.0, 0.25) = 0.5;

uniform sampler2D noise_img;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
	float s = sin(rotation);
	float c = cos(rotation);
	uv -= pivot;
	uv.x = uv.x * c - uv.y * s;
	uv.y = uv.x * s + uv.y * c;
	uv += pivot;
	
	return uv;
}

void fragment() {
	vec2 _uv = UV;
	vec2 __uv = UV;
	
	_uv.x += sin(TIME + (_uv.x + _uv.y) * 25.0) * 0.01;
	_uv.x += sin(TIME + (_uv.x - _uv.y) * 25.0) * 0.01;

	vec3 greyscale = texture(noise_img, rotateUV(_uv, vec2(0.5), TIME * time_scale)).rgb;
	//vec3 greyscale = texture(noise_img, _uv).rgb;
	vec3 coloured_1 = mix(greyscale, colour_1, mix_amount);
	
	vec3 invert = vec3(1.0 - greyscale);
	vec3 coloured_2 = mix(invert, colour_2, mix_amount);
	
	ALBEDO = (vec3(1) * coloured_1) - (vec3(1) * coloured_2);
}
