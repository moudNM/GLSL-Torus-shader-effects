/*
Student Name: Nur Muhammad Bin Khameed
SRN: 160269044
CO3355 Advanced Graphics and Animation CW1
Part B, Questions 1,2,3

Instructions:
Press keys 1 to 8 for the different patterns.
1,2,3 are basic patterns.
4 to 8 are patterns made using random and other functions.
*/

import peasy.*;
PShader shader;
PeasyCam cam;
float time;
float timeMill;

void setup() {
  size(800, 800, P3D);  
  //sets to default pattern (pattern 1)
  updateShader(1);
  cam = new PeasyCam(this, 0, 0, 0, 1500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);
}

void draw() {
  background(100);
  timeMill = millis();
  // sets all these variables for use in glsl files
  shader.set("u_time_millis", timeMill);
  shader.set("u_mouse",float(mouseX),float(mouseY));
  shader.set("u_mouseX",float(mouseX)/float(width));
  shader.set("u_mouseY",float(mouseY)/float(height));

  shader(shader);
  lights();
  PShape myShape = getTorus(200, 100, 32, 32);
  shape(myShape);
}

// Example of use:     torus = getTorus(200,100,32,32);
PShape getTorus(float outerRad, float innerRad, int numc, int numt) {

  PShape sh = createShape();
  sh.beginShape(TRIANGLE_STRIP);
  sh.noStroke();

  float x, y, z, s, t, u, v;
  float nx, ny, nz;
  float a1, a2;

  for (int i = 0; i < numc; i++) {
    for (int j = 0; j <= numt; j++) {
      for (int k = 1; k >= 0; k--) {
        s = (i + k) % numc + 0.5;
        t = j % numt;
        u = s / numc;
        v = t / numt;
        a1 = s * TWO_PI / numc;
        a2 = t * TWO_PI / numt;

        x = (outerRad + innerRad * cos(a1)) * cos(a2);
        y = (outerRad + innerRad * cos(a1)) * sin(a2);
        z = innerRad * sin(a1);

        nx = cos(a1) * cos(a2); 
        ny = cos(a1) * sin(a2);
        nz = sin(a1);
        sh.normal(nx, ny, nz);
        sh.vertex(x, y, z);
      }
    }
  }
  sh.endShape(); 
  return sh;
}

//changes to a pattern depending on key pressed
void keyReleased() {
  switch(key) {

    case('1'):
    updateShader(1);
    break;
    case('2'):
    updateShader(2);
    break;
    case('3'):
    updateShader(3);
    break;
    case('4'):
    updateShader(4);
    break;
    case('5'):
    updateShader(5);
    break;
    case('6'):
    updateShader(6);
    break;
    case('7'):
    updateShader(7);
    break;
    case('8'):
    updateShader(8);
    break;
  }
}

// changes the shader
void updateShader(int n) {
  String s = "fragShader" + n + ".glsl";
  println(s);
  shader = loadShader(s, "vertexShader.glsl");
  shader.set("u_resolution", float(width), float(height));
}
