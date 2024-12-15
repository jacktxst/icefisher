shader_type spatial;

uniform float wave_amplitude : hint_range(0.0, 1.0) = 0.1; // Height of the wave
uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;     // Speed of the wave
uniform float wave_frequency : hint_range(0.0, 10.0) = 4.0; // Frequency of the wave
uniform sampler2D albedo_texture;

void vertex() {
    // Compute the wave displacement for the vertex
    float wave = sin(VERTEX.x * wave_frequency + TIME * wave_speed) +
                 cos(VERTEX.z * wave_frequency + TIME * wave_speed);
    wave *= wave_amplitude;

    // Displace the vertex position along the y-axis
    VERTEX.y += wave;
}

void fragment() {
    // Sample the texture and output it as the color
    vec4 tex_color = texture(albedo_texture, UV);
    ALBEDO = tex_color.rgb; // Set RGB from texture
    ALPHA = tex_color.a;    // Use texture's alpha
}