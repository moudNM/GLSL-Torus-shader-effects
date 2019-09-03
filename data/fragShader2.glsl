#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform float u_time_millis;
uniform float u_mouseX;
uniform float u_mouseY;

#define PROCESSING_LIGHT_SHADER
varying vec3 objectCoord;

vec2 brickTile(vec2 _st, float _zoom){
    _st *= _zoom;
    
    // Here is where the offset is happening
    _st.x += step(1., mod(_st.y,2.0)) * u_mouseX;
    _st.y += step(1., mod(_st.y,2.0)) * u_mouseY;
    return fract(_st);
}

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

void main()
{
    
    vec2 st = objectCoord.xy/u_resolution;
    vec3 c = vec3(0.0);

    st *= 5.0;      // Scale up the space by 5
    st = fract(st); // Wrap arround 1.0
    
    
    //repeat every 6 seconds
    float modval = (mod(u_time_millis,6000));
    
    //1 to 3 seconds
    if(modval<=3000){
        st = brickTile(st,1.0 + 5*(modval/6000));
    //after 3, until 6 seconds
    }else{
        st = brickTile(st,6.0 - 5*(modval/6000));
    }

    // Now we have 3 spaces that goes from 0-1
    c = vec3((0.5*st.x*u_mouseX)+(0.5*st.y*u_mouseY),(1.0*st.x*u_mouseX),(1.0*st.y*u_mouseY));

    gl_FragColor = vec4(c, 1.0);
			
}


