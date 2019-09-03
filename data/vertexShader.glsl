#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 col;
varying vec4 position;
varying vec3 objectCoord;

void main(){

	gl_Position = transform*vertex;
	position = gl_Position;
	objectCoord = vertex.xyz;
	
	vec3 vertexCamera = vec3(modelview * vertex);

	vec3 transformedNormal = normalize(normalMatrix * normal);
	vec3 dir = normalize(lightPosition.xyz - vertexCamera);

	float light = max(0.0, dot(dir, transformedNormal));
	col = vec4(light, light, light, 1);
}
