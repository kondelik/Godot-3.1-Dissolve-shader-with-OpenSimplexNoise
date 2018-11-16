shader_type canvas_item;

//  noise texture (see Dissolve.material for GUI Generated one or Main.gd::_on_reseed_noise_pressed() for scripted one)
uniform sampler2D noise_tex : hint_albedo;
// burn map (gradiant from some color to transparent) - see Dissolve.material for GUI generated one
uniform sampler2D burn_ramp : hint_albedo;
// size of burning path (0 is infinitely short)
uniform float burn_size : hint_range(0.1, 1);

// position (time) of burning
uniform float burn_position : hint_range(-1, 1);

void fragment()
{
	// get pixel color * tint
	// thats our result without burning effect.
	// COLOR is final colour (we can use variable, but i dont see any reason not to use output)
	// TEXTURE is SpriteTexture from GODOT
	// UV is UV from GODOT
	// COLOR is tint from GODOT (from vertex shader)
	COLOR = texture(TEXTURE, UV) * COLOR;
	// get some noise minus our position in time
	// (thats why burn_position is range(-1, 1))
	float test = texture(noise_tex, UV).r - burn_position;
	// if our noise is bigger then treshold
	if (test < burn_size) {
		// get burn color from ramp
		vec4 burn = texture(burn_ramp, vec2(test * (1f / burn_size), 0));
		// override result rgb color with burn rgb color (NOT alpha!)
		COLOR.rgb = burn.rgb;
		// and set alpha to lower one from texture or burn.
		// that means we keep transparent sprite (COLOR.a is lower) and transparent 'burned pathes' (burn.a is lower)
		COLOR.a = min(burn.a, COLOR.a);
	}
}