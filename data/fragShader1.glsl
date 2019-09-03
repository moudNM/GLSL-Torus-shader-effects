#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec2 u_resolution;
uniform float u_time_millis;
uniform float u_mouseX;
uniform float u_mouseY;

#define PI 3.14159265358979323846

#define PROCESSING_LIGHT_SHADER
varying vec4 position;
varying vec3 objectCoord;

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

vec2 tile(vec2 _st, float _zoom){
    _st *= _zoom;
    return fract(_st);
}

float box(vec2 _st, vec2 _size, float _smoothEdges){
    _size = vec2(0.5)-_size*0.5;
    vec2 aa = vec2(_smoothEdges*0.5);
    vec2 uv = smoothstep(_size,_size+aa,_st);
    uv *= smoothstep(_size,_size+aa,vec2(1.0)-_st);
    return uv.x*uv.y;
}

float circle(in vec2 _st, in float _radius){
    vec2 l = _st-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(l,l)*2.0);
}
void main(void)
{
    
    vec2 st = objectCoord.xy/u_resolution.xy;
    vec3 circlePattern = vec3(1,0,0);
    vec3 squarePattern = vec3(0,0,1);
    vec3 colour = vec3(1,0,0);
    
    // Divide the space
    st = tile(st,10.);
    
    // Use a matrix to rotate
    st = rotate2D(st,2*PI*(mod(u_time_millis,6000)/6000.0));
    
    float b = box(st,vec2(0.2+(0.6*u_mouseX)),0.01);
    float c = circle(st,0.5);

    //circle
    circlePattern = vec3(c,u_mouseX,0);
    //diamond
    squarePattern = vec3(b,b,u_mouseY);
    
    float bw = abs(st.x);
    
    colour = vec3(mix(circlePattern,squarePattern,bw));
    
    gl_FragColor = vec4(colour, 1.0);
    
}


