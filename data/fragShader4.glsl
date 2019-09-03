#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform float u_time_millis;
uniform float u_mouseX;
uniform float u_mouseY;

#define PROCESSING_LIGHT_SHADER
varying vec4 position;
varying vec3 objectCoord;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
                 43758.5453123);
}

void main() {
    vec2 st = objectCoord.xy/u_resolution.xy;
    st *= 5.0 + (20*u_mouseX)+(20*u_mouseY); // Scale the coordinate system
//
    vec2 ipos = floor(st);  // get the integer coords
    vec2 fpos = fract(st);  // get the fractional coords
    
    // Assign a random value based on the time
    vec3 color = vec3(random( ipos*mod(u_time_millis,1000) ));
    
    gl_FragColor = vec4(color,1.0);
}
