class  PointyBlobBoy {
  PVector pos, spd, pos_old;
  PVector sz;
  int slices = 20;
  int crossSectiontPtCount = 20;
  float len = 1.0;
  float radiusMax = .4, radiusMin = .02;
  float inertialDamper = .875;
  StarVertex[][] vecs;
  PVector[][] initVecs;
  float r, g, b;
  float[] thetas, phis;
  float tau = 0.0;

  PointyBlobBoy() {
    _init();
  }

  PointyBlobBoy(int slices, int crossSectiontPtCount, float radiusMin, float radiusMax) {
    this.slices = slices;
    this.crossSectiontPtCount = crossSectiontPtCount;
    this.radiusMin = radiusMin;
    this.radiusMax = radiusMax;
    _init();
  }

  void _init() {

    // set basic states
    pos = new PVector(width/2, height/2, -300);
    pos_old = new PVector();
    spd = new PVector(random(-.5, .5), random(-.5, .5), random(-.5, .5));
    sz = new PVector(250, 250, 250);

    // prep geometry
    vecs = new StarVertex[slices][crossSectiontPtCount];
    initVecs = new PVector[slices][crossSectiontPtCount];
    thetas = phis = new float[slices];
    float phi = 0;


    // make pretty Constructivism colors
    float r1 = 255, g1 = 0, b1 = 0;
    float r2 = 0, g2 = 0, b2 = 255;
    float deltaR = (r2-r1)/slices, deltaG = (g2-g1)/slices, deltaB = (b2-b1)/slices;
    float r = r1, g = g1, b = b1;

    for (int i=0; i<slices; ++i) {
      float theta = 0.0; 
      float radius = radiusMin + abs(sin(phi)*(radiusMax-radiusMin));
      r = r1+deltaR*i;
      g = g1+deltaG*i;
      b = b1+deltaB*i;
      for (int j=0; j<crossSectiontPtCount; ++j) {
        initVecs[i][j] = new PVector();
        if (j%2==0) {
          vecs[i][j] = new StarVertex(new PVector(-.5+(len/slices)*i, cos(theta)*radius*.85, sin(theta)*radius*.85), color(r, g, b));
          initVecs[i][j].set(vecs[i][j].p);
        } else {
          vecs[i][j] = new StarVertex(new PVector(-.5+(len/slices)*i, cos(theta)*radius, sin(theta)*radius), color(r, g, b));
          initVecs[i][j].set(vecs[i][j].p);
        }
        theta += TWO_PI/crossSectiontPtCount;
      }
      phi += PI/(slices-1);
    }
  }

  void render() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    PVector direction = PVector.sub(pos, pos_old);
    direction.normalize();
    rotateX(atan2(direction.z, direction.y));
    rotateY(atan2(direction.x, direction.z)+PI/2);
    rotateZ(atan2(direction.y, direction.x));
    scale(350);
    beginShape(QUADS);
    for (int i=0; i<slices; ++i) {
      for (int j=0; j<crossSectiontPtCount; ++j) {

        // patch the mesh
        if (i<slices-1) {
          if (j<crossSectiontPtCount-1) {
            fill(vecs[i][j].c);
            vertex(vecs[i][j].p.x, vecs[i][j].p.y, vecs[i][j].p.z);
            fill(vecs[i+1][j].c);
            vertex(vecs[i+1][j].p.x, vecs[i+1][j].p.y, vecs[i+1][j].p.z);
            fill(vecs[i+1][j+1].c);
            vertex(vecs[i+1][j+1].p.x, vecs[i+1][j+1].p.y, vecs[i+1][j+1].p.z);
            fill(vecs[i][j+1].c);
            vertex(vecs[i][j+1].p.x, vecs[i][j+1].p.y, vecs[i][j+1].p.z);
            // close er up
          } else {
            fill(vecs[i][j].c);
            vertex(vecs[i][j].p.x, vecs[i][j].p.y, vecs[i][j].p.z);
            fill(vecs[i+1][j].c);
            vertex(vecs[i+1][j].p.x, vecs[i+1][j].p.y, vecs[i+1][j].p.z);
            fill(vecs[i+1][0].c);
            vertex(vecs[i+1][0].p.x, vecs[i+1][0].p.y, vecs[i+1][0].p.z);
            fill(vecs[i][0].c);
            vertex(vecs[i][0].p.x, vecs[i][0].p.y, vecs[i][0].p.z);
          }
        }
      }
    }
    endShape();
    popMatrix();
  }



  void breath() {
    for (int i=0; i<slices; ++i) {
      float tempX=0, tempY=0, tempZ=0;
      for (int j=0; j<crossSectiontPtCount; ++j) {
        tempY = vecs[i][j].p.y*cos(thetas[i]) - vecs[i][j].p.z*sin(thetas[i]);
        tempZ = vecs[i][j].p.y*sin(thetas[i]) + vecs[i][j].p.z*cos(thetas[i]);

        vecs[i][j].p.y = tempY + phis[i]*.2;
        vecs[i][j].p.z = tempZ;
      }
      thetas[i] = sin(tau +i*7*PI/180)*.02;
      phis[i] = cos(tau +i*7*PI/180)*.02;
    }
    tau += TWO_PI/360;
  }

  void swim() {
    PVector pos_temp  = new PVector();
    pos_temp.set(pos);
    pos.add(spd);

   println(screenX(pos.x, pos.y, pos.z));
   if (screenX(pos.x, pos.y, pos.z) > width-350/2) {
      spd.x *= -1;
    } else if (screenX(pos.x, pos.y, pos.z) < 350/2) {
      spd.x *= -1;
    }

    if (screenY(pos.x, pos.y, pos.z) > height-350/2) {
      spd.y *= -1;
    } else if (screenY(pos.x, pos.y, pos.z) < 350/2) {
      spd.y *= -1;
    }

    if (pos.z > 0) {
      spd.z *= -1;
    } else if ( pos.z < -600) {
      spd.z *= -1;
    }
    // get position of previous frame
    pos_old.set(pos_temp);
  }
}

