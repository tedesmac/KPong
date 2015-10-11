#ifdef GL_ES
precision highp float;
#endif

attribute vec3 pos;
attribute vec2 uv;
attribute vec3 nor;

uniform mat4 MVP;

void kore(){

	gl_Position = MVP * vec4(pos, 1.0);

}

//