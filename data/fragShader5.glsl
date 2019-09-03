// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time_millis;
uniform vec2 u_mouse;
uniform float u_mouseX;
uniform float u_mouseY;

#define PROCESSING_LIGHT_SHADER
varying vec4 position;
varying vec3 objectCoord;

float random (in vec2 st) {
    //lines change based on mouse position
    return fract(sin(dot(st.xy,
                         vec2(u_mouse.x,u_mouse.y)))
                 * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f*f*(3.0-2.0*f);
    return mix( mix( random( i + vec2(0.0,0.0) ),
                    random( i + vec2(1.0,0.0) ), u.x),
               mix( random( i + vec2(0.0,1.0) ),
                   random( i + vec2(1.0,1.0) ), u.x), u.y);
}

mat2 rotate2d(float angle){
    return mat2(cos(angle),-sin(angle),
                sin(angle),cos(angle));
}

float lines(in vec2 pos, float b){
    float scale = 10.0;
    pos *= scale;
    return smoothstep(0.0,
                      .5+b*.5,
                      abs((sin(pos.x*3.1415)+b*2.0))*.5);
}

void main() {
    vec2 st = objectCoord.xy/u_resolution.xy;
    st.y *= u_resolution.y/u_resolution.x;
    
    vec2 pos = st.yx*vec2(10.,3.);
    
    float pattern = pos.x;
    
    // Add noise
    pos = rotate2d( noise(pos) ) * pos;
    
    // Draw lines
    //lines fade based on time
    pattern = lines(pos,2.0 * mod(u_time_millis,6000)/6000);
    
    gl_FragColor = vec4(vec3(pattern),1.0);
}
