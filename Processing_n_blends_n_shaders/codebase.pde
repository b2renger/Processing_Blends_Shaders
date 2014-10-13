/*
A set of classes to draw things :
 
 - Rotating_Lines : used to draw nice patterns of bezier curves
 - ParticleSystem : a class to emit a bunch of particles from the mouse pointer
 - Particle : the objects inside a Particle system
 - Mover : uses velocity to move things around
 - Dla_particle : used to make a dla system
 - PointSphere : a 3d point sphere class
 - Soft_body : a 2d structure of springs and nodes
 - Soft_body_2 : another 2d structure of springs and nodes
 - Spring : a 2d or 3d physical simulation of a spring
 - Node : a class to attach springs to each other
 - Integrator : a class to smooth up transition beetween values
 - Moving_rectangles : a class
 
 */




////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
// adapted from this source :
// http://www.openprocessing.org/sketch/14195
class Rotating_Lines {

  int turn =0 ;
  float radius ;
  float cenX, cenY ;

  float noiseFx, noiseFy;

  Rotating_Lines(float radius, float cenX, float cenY) {
    this.radius = radius;
    this.cenX = cenX;
    this.cenY = cenY;

    noiseFx = random(500);
    noiseFy = random(500);
  }

  void run(PGraphics pg) {

    cenX += map(noise(noiseFx, 20, 50), 0, 1, -2, 2);
    cenY += map(noise(noiseFy, 85, 5), 0, 1, -2, 2);

    if (cenX > width) cenX = 0;
    else if (cenX <0) cenX = width;
    else if (cenY <0) cenY = height;
    else if (cenY >height) cenY = 0;

    for (int d = 0; d <= 360; d+=10) {
      float r = radians(d + turn);
      pg.stroke(map(d, 0, 360, 50, 255), 10);    
      pg.bezier(cenX, cenY, 
      cenX + radius / 2 * cos(r), cenY + radius / 2 * sin(r), 
      cenX + radius * cos(r + HALF_PI), cenY + radius * sin(r + HALF_PI), 
      cenX + radius * cos(r + PI), cenY + radius * sin(r + PI)
        );
    }
    turn++;
    noiseFx+=0.005;
    noiseFy+=0.005;
  }
}


/////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
// Two classes : a Particle_system and a Particle
// A class to describe a group of Particles 
class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are born

    ParticleSystem(int num, PVector v) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.get();                        // Store the origin point
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin));    // Add "num" amount of particles to the arraylist
    }
  }

  void run(PGraphics pg) {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run(pg);
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void addParticle(float x, float y) {
    particles.add(new Particle(new PVector(x, y)));
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }
}

// A simple Particle class
class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  float pColor;

  // Another constructor (the one we are using here)
  Particle(PVector l) {
    acc = new PVector(0, -0.15, 0);
    vel = new PVector(random(-3, 3), random(-3, 3), 0);
    loc = l.get();
    r = 25;
    timer = 125.0;
    pColor = 255;
  }

  void run(PGraphics pg) {
    update();
    render(pg);
  }

  // Method to update location
  void update() {
    vel.add(acc);
    loc.add(vel);
    timer -= 1.0;
  }

  // Method to display
  void render(PGraphics pg) {
    // pg.ellipseMode(CENTER);
    pg.fill(pColor, timer);
    pg.ellipse(loc.x, loc.y, r, r);
  }

  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// A mover class : a shape moving with a velocity , used in ball_network animation
// it must be comming from Daniel Shiffman amazing Nature of Code book
// http://natureofcode.com/

class Mover {

  PVector loc, vel;

  Mover(PVector loc, PVector vel) {
    this.loc = loc;
    this.vel = vel;
  } 

  void update() {  
    loc.add(vel);  
    if (loc.x < 0 || loc.x> width) {
      vel.x = -vel.x;
    }
    if (loc.y<0 || loc.y > height) {
      vel.y = -vel.y;
    }
  }

  void draw() {
    pushStyle();
    noStroke();
    fill(255, 25);
    ellipse(loc.x, loc.y, 50, 50);
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// A class for DLA
/**
 * Simulate: Diffusion-Limited Aggregation
 * from Form+Code in Design, Art, and Architecture 
 * by Casey Reas, Chandler McWilliams, and LUST
 * Princeton Architectural Press, 2010
 * ISBN 9781568989372
 * 
 * This code was written for Processing 1.2+
 * Get Processing at http://www.processing.org/download
 */

// addapted to make it resizable to a specific field given in pixels
//
// ---------------
// Particle.pde
// ---------------

class Dla_particle
{
  int x, y;
  boolean stuck = false;

  int fieldWidth, fieldHeight;

  Dla_particle(int fieldWidth, int fieldHeight) {
    this.fieldWidth =fieldWidth;
    this.fieldHeight =fieldHeight;
    reset();
  }

  void reset() {
    // keep choosing random spots until an empty one is found
    do {
      x = floor(random(fieldWidth));
      y = floor(random(fieldHeight));
    } 
    while (field[y * fieldWidth + x]);
  }

  void update() {
    // move around
    if (!stuck) {
      x += round(random(-3, 3));
      y += round(random(-3, 3));

      if (x < 0 || y < 0 || x >= fieldWidth || y >= fieldHeight) {
        reset();
        return;
      }

      // test if something is next to us
      if (!alone()) {
        stuck = true;
        field[y * fieldWidth + x] = true;
      }
    }
  }

  // returns true if no neighboring pixels
  boolean alone() {
    int cx = x;
    int cy = y;

    // get positions
    int lx = cx-1;
    int rx = cx+1;
    int ty = cy-1;
    int by = cy+1;

    if (cx <= 0 || cx >= fieldWidth || 
      lx <= 0 || lx >= fieldWidth || 
      rx <= 0 || rx >= fieldWidth || 
      cy <= 0 || cy >= fieldHeight || 
      ty <= 0 || ty >= fieldHeight || 
      by <= 0 || by >= fieldHeight) return true;

    // pre multiply the ys
    cy *= fieldWidth;
    by *= fieldWidth;
    ty *= fieldWidth;

    // N, W, E, S
    if (field[cx + ty] || 
      field[lx + cy] ||
      field[rx + cy] ||
      field[cx + by]) return false;

    // NW, NE, SW, SE

    if (field[lx + ty] || 
      field[lx + by] ||
      field[rx + ty] ||
      field[rx + by]) return false;


    return true;
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PointSphere {
  float noiseF = 25;
  float noiseI =random(100);
  int seed =10;
  float zoom_sphere =400;
  int maxPoints = 4000;
  PVector[] points = new PVector[maxPoints];
  float rotX, rotY = 0.0;


  PointSphere(int seed) {
    this.seed = seed ;
    noiseI = random(100);
  }

  void draw_sphere(PGraphics pg, boolean top_mode) {
    pg.beginDraw();
    pg.strokeWeight(4.0);
    randomSeed(seed); 
    for (int ni=0; ni<maxPoints; ni++) {
      points[ni] = randomSpherePoint(zoom_sphere);
    }
    pg.translate(width*0.5, height*0.5);
    pg.noStroke();
    pg.fill(0, 0, 0, 150);
    pg.box(10000);
    pg.rotateX (rotX);
    pg.rotateY (rotY);
    pg.stroke(255);
    for (int ni=1; ni<maxPoints; ni++) {   
      if (ni!=0) {
        pg.strokeWeight(0.5);
        pg.stroke(180, 50);
        pg.line(points[ni].x+noise(noiseI+ni, 10, 10)*noiseF, points[ni].y+noise(noiseI+10, ni, 10)*noiseF, points[ni].z+noise(noiseI+50, 10, ni)*noiseF, 
        points[ni-1].x+noise(noiseI+ni-1, 10, 10)*noiseF, points[ni-1].y+noise(noiseI+10, ni-1, 10)*noiseF, points[ni-1].z+noise(noiseI+50, 10, ni-1)*noiseF);
      }
      //pg.point (points[ni].x+noise(noiseI+ni, 10, 10)*noiseF, points[ni].y+noise(noiseI+10, ni, 10)*noiseF, points[ni].z+noise(noiseI+50, 10, ni)*noiseF);
    }
    if (mousePressed && mouseButton == LEFT && top_mode) {
      rotY += (pmouseX - mouseX) * -0.002;
      rotX += (pmouseY - mouseY) * +0.002;
    } else  if (mousePressed && mouseButton == RIGHT && !top_mode) {
      rotY += (pmouseX - mouseX) * -0.002;
      rotX += (pmouseY - mouseY) * +0.002;
    } 
    if (keyPressed && key == 'z') {
      zoom_sphere -=1;
    } else if (keyPressed && key == 'Z') {
      zoom_sphere +=1;
    }
    noiseI+=0.005;  
    pg.endDraw();
  }


  //--------------------------------------------------------
  // return random sphere point using method of Cook/Neumann
  //--------------------------------------------------------
  PVector randomSpherePoint(float radius) {

    float a=0, b=0, c=0, d=0, k=99;
    while (k >= 1.0) {
      a = random (-1.0, 1.0);
      b = random (-1.0, 1.0);
      c = random (-1.0, 1.0);
      d = random (-1.0, 1.0);
      k = a*a +b*b +c*c +d*d;
      //print('.');
    }
    //println ("s");
    k = k/radius;
    return new PVector
      ( 2*(b*d + a*c) / k
      , 2*(c*d - a*b) / k 
      , (a*a + d*d - b*b - c*c) / k);
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Two classes of "soft bodies" built with nodes and springs (from the node and spring class below)

//////////////////////////////////////////////////////////////////////////////////////////////////
// class used in the draw_spring_struct()
class Soft_body {
  int resolution  ;
  Node [] nodes ;
  Spring [] springs ;
  float centerX ;
  float centerY ;
  float radius;
  float damp;
  float stiff;

  Soft_body(float centerX, float centerY, float radius, int resolution, float damp, float stiff) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius ;
    this.resolution = resolution; 
    this.damp = damp;
    this.stiff = stiff ;
    nodes = new Node[resolution];
    springs = new Spring[resolution -1];
    nodes[0] = new Node (centerX, centerY);

    for (int i = 1 ; i < resolution ; i++) {
      float angle = map(i, 0, resolution, -2*TWO_PI, 2*TWO_PI);
      float nodeX = radius * cos((angle))+centerX;
      float nodeY = radius * sin((angle)) + centerY;
      nodes[i] = new Node (nodeX, nodeY);
      nodes[i].setDamping(damp);
      springs[i-1]= new Spring (nodes[0], nodes[i]);
      springs[i-1].setLength(radius);
      springs[i-1].setStiffness(stiff);
      springs[i-1].setDamping(damp);
    }
  }

  void run (PGraphics pg) {
    pg.beginShape();
    for (int i = 0; i < resolution ; i++) {
      if (i !=0) {
        nodes[i].update();
        nodes[i].attract(nodes);
        pg.stroke(255, 50);
        pg.curveVertex(nodes[i].location.x, nodes[i].location.y);
        springs[i-1].update();
      }
    }
    pg.endShape(CLOSE);
  }
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// used in draw_moiree_springs() 
class Soft_body_2 {
  int resolution  ;
  Node [] nodes ;
  Spring [] springs ;

  float centerX ;
  float centerY ;
  float radius;


  Soft_body_2(float centerX, float centerY, float radius, int resolution) {

    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius ;
    this.resolution = resolution; 

    nodes = new Node[resolution];
    springs = new Spring[resolution -1];
    nodes[0] = new Node (centerX, centerY);

    for (int i = 1 ; i < resolution ; i++) {
      float angle = map(i, 1, resolution, 0, 360);
      float nodeX = radius * cos(radians(angle))+centerX;
      float nodeY = radius * sin(radians(angle)) + centerY;

      nodes[i] = new Node (nodeX, nodeY);
      nodes[i].setDamping(0.195);

      springs[i-1]= new Spring (nodes[0], nodes[i]);
      springs[i-1].setLength(radius);
      springs[i-1].setStiffness(0.1);
      springs[i-1].setDamping(0.39);
    }
  }

  void run (PGraphics pg) {
    pg.beginShape();
    for (int i = 0; i < resolution ; i++) {
      if (i !=0) {
        nodes[i].update();
        nodes[i].attract(nodes);
        pg.vertex(nodes[i].location.x, nodes[i].location.y);
        springs[i-1].update();
      }
    }
    pg.endShape(CLOSE);
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// class used in the draw_spring_struct()
// M_6_1_02.pde
// Spring.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// modified for js compatibility by berenger.recoules@gmail.com
class Spring {
  Node fromNode;
  Node toNode;

  float length = 100;
  float stiffness = 0.6;
  float damping = 0.9;

  // ------ constructors ------
  Spring(Node theFromNode, Node theToNode) {
    fromNode = theFromNode;
    toNode = theToNode;
  }

  Spring(Node theFromNode, Node theToNode, float theLength, float theStiffness, float theDamping) {
    fromNode = theFromNode;
    toNode = theToNode;

    length = theLength;
    stiffness = theStiffness;
    damping = theDamping;
  }

  // ------ apply forces on spring and attached nodes ------
  void update() {
    // calculate the target position
    // target = normalize(to - from) * length + from
    PVector diff = PVector.sub(toNode.location, fromNode.location);
    diff.normalize();
    diff.mult(length);
    PVector target = PVector.add(fromNode.location, diff);

    PVector force = PVector.sub(target, toNode.location);
    force.mult(0.5);
    force.mult(stiffness);
    force.mult(1 - damping);

    toNode.velocity.add(force);
    fromNode.velocity.add(PVector.mult(force, -1));
  }

  // ------ getters and setters ------
  Node getFromNode() {
    return fromNode;
  }

  void setFromNode(Node theFromNode) {
    fromNode = theFromNode;
  }

  Node getToNode() {
    return toNode;
  }

  void setToNode(Node theToNode) {
    toNode = theToNode;
  }

  float getLength() {
    return length;
  }

  void setLength(float theLength) {
    this.length = theLength;
  }

  float getStiffness() {
    return stiffness;
  }

  void setStiffness(float theStiffness) {
    this.stiffness = theStiffness;
  }

  float getDamping() {
    return damping;
  }

  void setDamping(float theDamping) {
    this.damping = theDamping;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// class used in the draw_spring_struct()
// M_6_1_01.pde
// Node.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// modified for js compatibility by berenger.recoules@gmail.com
class Node extends PVector {

  // ------   properties ------
  // if needed, an ID for the node
  String id = "";
  float diameter = 0;

  float minX = -60000;
  float maxX = 60000;
  float minY = -60000;
  float maxY = 60000;
  float minZ = -60000;
  float maxZ = 60000;

  PVector location = new PVector();

  PVector velocity = new PVector();
  PVector pVelocity = new PVector();
  float maxVelocity = 10;

  float damping = 0.5f;
  // radius of impact
  float radius = 200;
  // strength: positive for attraction, negative for repulsion (default for Nodes)
  float strength = -1;
  // parameter that influences the form of the function
  float ramp = 1.0f;




  // ------ constructors ------
  Node() {
  }
  Node(float theX, float theY) {
    location.x = theX;
    location.y = theY;
  }


  Node(float theX, float theY, float theZ) {
    location.x = theX;
    location.y = theY;
    location.z = theZ;
  }

  Node(PVector theVector) {
    location.x = theVector.x;
    location.y = theVector.y; 
    location.z = theVector.z;
  }

  // ------ custom function for what we need -------
  void over(float ex, float wy) {
    PVector mouse = new PVector(ex, wy);
    PVector loc = new PVector(location.x, location.y);
    pushStyle();
    fill(0);
    float d = dist(mouse, loc);

    if (d<15) {
      println("over node");
    } 
    popStyle();
  }

  // ------ rotate position around origin ------
  void rotateX(float theAngle) {
    float newy = location.y * cos(theAngle) - location.z * sin(theAngle);
    float newz = location.y * sin(theAngle) + location.z * cos(theAngle);
    location.y = newy;
    location.z = newz;
  }

  void rotateY(float theAngle) {
    float newx = location.x * cos(-theAngle) - location.z * sin(-theAngle);
    float newz = location.x * sin(-theAngle) + location.z * cos(-theAngle);
    location.x = newx;
    location.z = newz;
  }

  void rotateZ(float theAngle) {
    float newx = location.x * cos(theAngle) - location.y * sin(theAngle);
    float newy = location.x * sin(theAngle) + location.y * cos(theAngle);
    location.x = newx;
    location.y = newy;
  }

  // ------ calculate attraction ------
  void attract(Node[] theNodes) {
    // attraction or repulsion part
    for (int i = 0; i < theNodes.length; i++) {
      Node otherNode = theNodes[i];
      // stop when empty
      if (otherNode == null) break;
      // not with itself
      if (otherNode == this) continue;

      this.attract(otherNode);
    }
  }

  void attract(Node theNode) {
    float d = PVector.dist(location, theNode.location);

    if (d > 0 && d < radius) {
      float s = pow(d / radius, 1 / ramp);
      float f = s * 9 * strength * (1 / (s + 1) + ((s - 3) / 4)) / d;
      PVector df = PVector.sub(this.location, theNode.location);
      df.mult(f);

      theNode.velocity.x += df.x;
      theNode.velocity.y += df.y;
      theNode.velocity.z += df.z;
    }
  }

  // ------ update positions ------
  void update() {
    update(false, false, false);
  }

  void update(boolean theLockX, boolean theLockY, boolean theLockZ) {

    velocity.limit(maxVelocity);

    pVelocity.set(velocity);

    if (!theLockX) location.x += velocity.x;
    if (!theLockY) location.y += velocity.y;
    if (!theLockZ) location.z += velocity.z;

    if (location.x < minX) {
      location.x = minX - (location.x - minX);
      velocity.x = -velocity.x;
    }
    if (location.x > maxX) {
      location.x = maxX - (location.x - maxX);
      velocity.x = -velocity.x;
    }

    if (location.y < minY) {
      location.y = minY - (location.y - minY);
      velocity.y = -velocity.y;
    }
    if (location.y > maxY) {
      location.y = maxY - (location.y - maxY);
      velocity.y = -velocity.y;
    }

    if (location.z < minZ) {
      location.z = minZ - (location.z - minZ);
      velocity.z = -velocity.z;
    }
    if (location.z > maxZ) {
      location.z = maxZ - (location.z - maxZ);
      velocity.z = -velocity.z;
    }

    velocity.mult(1 - damping);
  }

  // ------ getters and setters ------
  String getID() {
    return id;
  }

  void setID(String theID) {
    this.id = theID;
  }

  float getDiameter() {
    return diameter;
  }

  void setDiameter(float theDiameter) {
    this.diameter = theDiameter;
  }

  void setBoundary(float theMinX, float theMinY, float theMinZ, 
  float theMaxX, float theMaxY, float theMaxZ) {
    this.minX = theMinX;
    this.maxX = theMaxX;
    this.minY = theMinY;
    this.maxY = theMaxY;
    this.minZ = theMinZ;
    this.maxZ = theMaxZ;
  }

  void setBoundary(float theMinX, float theMinY, float theMaxX, 
  float theMaxY) {
    this.minX = theMinX;
    this.maxX = theMaxX;
    this.minY = theMinY;
    this.maxY = theMaxY;
  }

  float getMinX() {
    return minX;
  }

  void setMinX(float theMinX) {
    this.minX = theMinX;
  }

  float getMaxX() {
    return maxX;
  }

  void setMaxX(float theMaxX) {
    this.maxX = theMaxX;
  }

  float getMinY() {
    return minY;
  }

  void setMinY(float theMinY) {
    this.minY = theMinY;
  }

  float getMaxY() {
    return maxY;
  }

  void setMaxY(float theMaxY) {
    this.maxY = theMaxY;
  }

  float getMinZ() {
    return minZ;
  }

  void setMinZ(float theMinZ) {
    this.minZ = theMinZ;
  }

  float getMaxZ() {
    return maxZ;
  }

  void setMaxZ(float theMaxZ) {
    this.maxZ = theMaxZ;
  }

  PVector getVelocity() {
    return velocity;
  }

  void setVelocity(PVector theVelocity) {
    this.velocity = theVelocity;
  }

  float getMaxVelocity() {
    return maxVelocity;
  }

  void setMaxVelocity(float theMaxVelocity) {
    this.maxVelocity = theMaxVelocity;
  }

  float getDamping() {
    return damping;
  }

  void setDamping(float theDamping) {
    this.damping = theDamping;
  }

  float getRadius() {
    return radius;
  }

  void setRadius(float theRadius) {
    this.radius = theRadius;
  }

  float getStrength() {
    return strength;
  }

  void setStrength(float theStrength) {
    this.strength = theStrength;
  }

  float getRamp() {
    return ramp;
  }

  void setRamp(float theRamp) {
    this.ramp = theRamp;
  }

  void setLocation(float x, float y) {
    location.x = x;
    location.y =y;
  }
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Integrator class
class Integrator {

  final float DAMPING = 0.25;
  final float ATTRACTION = 0.015;

  float value=0;
  float vel;
  float accel;
  float force;
  float mass = .9;

  float damping = DAMPING;
  float attraction = ATTRACTION;
  boolean targeting ;
  float target;

  Integrator() {
  }

  Integrator(float value) {
    this.value = value;
  }

  Integrator(float value, float damping, float attraction) {
    this.value = value;
    this.damping = damping;
    this.attraction = attraction;
  }


  void set(float v) {
    value = v;
  }


  void update() {
    if (targeting) {
      force += attraction * (target - value);
    }
    accel = force / mass;
    vel = (vel + accel) * damping;
    value += vel;
    force = 0;
  }


  void target(float t) {
    targeting = true;
    target = t;
  }


  void noTarget() {
    targeting = false;
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Moving_rectangle it implements comparable so that an array of moving rectangles can be sorted by radiuses
// it needs an import
import java.util.*;

class MovingRect implements Comparable {
  float xpos, ypos;
  color c_col;
  Integrator hue;
  Integrator radius;

  MovingRect(float rad, float hu) {
    xpos = width/2;
    ypos = height/2;

    radius = new Integrator(rad);
    hue = new Integrator(hu);
  }

  void update() {
    radius.update();
    hue.update();
  }

  void draw_me(PGraphics pg) {
    pg.beginDraw();
    //pg.background(0);

    pg.pushMatrix();
    pg.noStroke();
    pg.rectMode(CENTER);
    pg.translate (xpos, ypos);
    pg.fill(hue.value);   
    pg.rect(0, 0, radius.value*2, radius.value);
    pg.rectMode(CORNER);
    pg.popMatrix();
    pg.endDraw();
  }

  void set_radius(float newValue) {
    radius.target(newValue);
  }

  void set_hue (float newHue) {
    hue.target(newHue);
  }

  int compareTo(Object o) {
    MovingRect other=(MovingRect) o;
    if (other.radius.value  > radius.value)  
      return 1;
    if (other.radius.value == radius.value)
      return 0;
    else
      return -1;
  }
}
/////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Moving_rectangle it implements comparable so that an array of moving rectangles can be sorted by radiuses
// it needs an import
import java.util.*;

class MovingCircle implements Comparable {
  float xpos, ypos;
  color c_col;
  Integrator hue;
  Integrator radius;

  MovingCircle(float rad, float hu) {
    xpos = width/2;
    ypos = height/2;

    radius = new Integrator(rad);
    hue = new Integrator(hu);
  }

  void update() {
    radius.update();
    hue.update();
  }

  void draw_me(PGraphics pg) {
    pg.beginDraw();
    //pg.background(0);

    pg.pushMatrix();
    pg.noStroke();
    pg.rectMode(CENTER);
    pg.translate (xpos, ypos);
    pg.fill(hue.value);   
    pg.ellipse(0, 0, radius.value, radius.value);
    pg.rectMode(CORNER);
    pg.popMatrix();
    pg.endDraw();
  }

  void set_radius(float newValue) {
    radius.target(newValue);
  }

  void set_hue (float newHue) {
    hue.target(newHue);
  }

  int compareTo(Object o) {
    MovingCircle other=(MovingCircle) o;
    if (other.radius.value  > radius.value)  
      return 1;
    if (other.radius.value == radius.value)
      return 0;
    else
      return -1;
  }
}




