PointyBlobBoy pbb;

void setup() {
  size(900, 800, P3D);
  //int slices, int crossSectiontPtCount, float radiusMin, float radiusMax
  pbb = new PointyBlobBoy(15, 12, .02, .25);
  pbb.pos = new PVector(width/2, height/2, -200);
  pbb.spd = new PVector(-1.2, 0, 0);
  strokeWeight(.5);
  stroke(150, 75, 0);
  noStroke();
}

void draw() {
  background(0);
  //lights();

  lightSpecular(255, 255, 255);
  directionalLight(204, 204, 204, 0, 0, -1);
  specular(255, 255, 255);
  shininess(5.0); 

 //translate(width/2, height/2);
  //rotateY(frameCount*PI/720);
  //rotateZ(frameCount*PI/720);
  //scale(350);
  pbb.swim();
  pbb.breath();
  pbb.render();
}

