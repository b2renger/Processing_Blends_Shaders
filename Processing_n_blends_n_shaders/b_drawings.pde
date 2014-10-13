
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// variables for drawings

// used in draw_circles(PGraphics pg), draw_lines(PGraphics pg), draw_rectangles(PGraphics pg)
float fade; 

// 1) and 2)
PImage image_1; 
PImage image_2;

// 3) image_travelling
float incr;  
float zoom;
int travelx;
int travely;

// 4) webcam
Capture cam;

// 5) movie
Movie mov;
float movieSpeed;

// 8) rotating_rectangles
float step; // used in draw_rectangles(PGraphics pg)
float add;

// 9) ball_network
int num = 1000; // used in draw_ball_network()
Mover[] movs=new Mover[num]; 
float treshold = 50;

// 10) bezier_lines
Rotating_Lines rt1, rt2, rt3, rt4; // see codebase

// used in draw_spring_structure() and in draw_moiree_springs()
Node mouseNode; // see codebase

// 11) spring_structure
Soft_body [] bodies; // used in draw_spring_structure() // see codebase

// 12) moiree_spring
Soft_body_2 [] bodies2;  // used in draw_moiree_springs() // see codebase

// 13) paricle_system
ParticleSystem ps; //used in draw_particle_system() // see codebase

// 14) dla
int particleCount; // used in draw_dla()
Dla_particle[] particles1; // see codebase
Dla_particle[] particles2;
Dla_particle[] particles3;
int dla_width, dla_height;
boolean[] field;

// 15) sphere ! yes you can draw 3D too :)
PointSphere sphere ; // see codebase

// 34) moving rectangles
MovingRect [] rects = new MovingRect[20];

// 35) moving circles
MovingCircle [] circs = new MovingCircle[20];

////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// one general setup
void setup_drawings() {

  fade= 25;

  // 1) & 2) can be used by draw_image(PGraphics pg, PImage pi);
  image_1 = loadImage( "building1.jpg" );
  image_1.resize(width, height);
  image_2 = loadImage( "arbre.jpg");
  image_2.resize(width, height);

  // 3) used in image_travelling()
  incr = 0.05;
  zoom = 25;
  travelx =width/2;
  travely =height/2;

  // 4) used in webcam()
  cam = new Capture(this, width, height);
  cam.start();

  // 5) used in movie()
  mov = new Movie(this, "transit.mov");
  mov.loop();
  mov.speed(2);

  // 8) used in draw_rectangles(PGraphics pg);
  step = 0;

  // 9) used in draw_ball_network()
  for (int i = 0 ; i < num ; i++) {
    PVector initLoc = new PVector(random(5, width-5), random(5, height-5));
    PVector initVel = new PVector(random(-1, 1), random(-1, 1));
    movs[i] = new Mover (initLoc, initVel);
  }

  // 10) used in draw_bezier_lines()
  rt1 = new Rotating_Lines(width/5*sqrt(255), width/2, height/2);
  rt2 = new Rotating_Lines(width/5*sqrt(25), width/2, height/2);
  rt3 = new Rotating_Lines(width/5*sqrt(255), width/2, height/2);
  rt4 = new Rotating_Lines(width/5*sqrt(255), width/2, height/2);

  // 11) used in draw_spring_structure
  bodies = new Soft_body [300];
  for (int i=0 ; i <300 ; i++) {  
    bodies[i] = new Soft_body (width/2, height/2, 310-i*1, 10, 0.09, 0.09);
  }

  // warning this node is used in both draw_spring_structure() and draw_moiree_springs()
  mouseNode = new Node(); 

  // 12) used in draw_moiree_springs()  
  bodies2 = new Soft_body_2 [400];
  for (int i=0 ; i <400 ; i++) {  
    bodies2[i] = new Soft_body_2 (width/2, height/2, +i*2.5, 10);
  }

  // 13) used in draw_particle_system()
  ps = new ParticleSystem(100, new PVector(width/2, height/2, 0));

  // 14) used in draw_dla()
  setup_dla();

  // 15) used in draw_sphere()
  sphere = new PointSphere(round(random(255)));

  // 34) moving rectangles
  for (int i = 0 ; i < rects.length ; i++) {    
    rects[i] = new MovingRect(random(50, 1000), random(0, 255));
  }
  
   // 35) moving circles
  for (int i = 0 ; i < circs.length ; i++) {    
    circs[i] = new MovingCircle(random(50, 1000), random(0, 255));
  }
}
////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1) & 2) draw a simple image
void draw_image(PGraphics pg, PImage pi) {
  pg.beginDraw();
  pg.scale(1, -1);
  pg.image(pi, 0, -height); // you need to reverse it processing so it could be loaded right in the shader
  pg.endDraw();
}
/////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 3) draw an image but with travelling option (mouse), and also a zoom (keys '-' and '+')
void draw_image_travelling(PGraphics pg, PImage pi, boolean top_mode) {
  pg.beginDraw();
  if (keyPressed && key == '-') {
    zoom +=0.1;
  } else if (keyPressed && key == '+') {
    zoom -=0.1;
  }
  int wi = int(constrain(map(zoom, 0, 50, 50, pi.width), 50, pi.width));
  int he = int(constrain(map(zoom, 0, 50, 50, pi.height), 50, pi.height));
  if (mousePressed && mouseButton == LEFT && top_mode) {
    travelx = int(map(mouseX, 0, width, 0, pi.width-wi));
    travely = int(map(mouseY, 0, height, 0, pi.height-he));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {
    travelx = int(map(mouseX, 0, width, 0, pi.width-wi));
    travely = int(map(mouseY, 0, height, 0, pi.height-he));
  }  
  pg. copy(pi, travelx, travely, wi, -he, 0, 0, width, height);
  pg.endDraw();
  incr += 0.01;
}
/////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 4) draw a webcam
void draw_webcam (PGraphics pg) {
  if (cam.available() == true) {
    cam.read();
  }
  pg.smooth(8);
  pg.beginDraw();
  pg.scale(1, -1);
  pg.image(cam, 0, -height);
  pg.endDraw();
}
/////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 5) draw a movie 
void draw_movie (PGraphics pg) {
  pg.beginDraw();
  pg.scale(1, -1);
  pg.image(mov, 0, -height, width, height);
  pg.endDraw();
}
/////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 6) draw a bunch of circles, uses mouse vertical position for fade
void draw_circles(PGraphics pg) {
  pg.smooth(8);
  pg.beginDraw();
  pg.noStroke();
  pg.fill(0, fade);
  pg.rect(0, 0, width, height);
  for (int i = 0 ; i < 50 ; i++) {
    float alpha = random(255);
    float rad = random(50);
    pg.stroke(255, alpha);
    pg.fill(255, alpha);
    pg.ellipse (random(width), random(height), rad, rad);
  }
  pg.endDraw();
}
//////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 7) draw a bunch of lines, uses mouse vertical position for fade
void draw_lines(PGraphics pg) {
  pg.smooth(8);
  pg.beginDraw();
  pg.noStroke();
  pg.fill(0, fade);
  pg.rect(0, 0, width, height);
  float xpos = random(width);
  for (int i = 0 ; i < 50 ; i++) {
    //float xpos = random(width);
    float rand = random(-width/2, width/2);
    float alpha = random(250);
    pg.stroke(255, alpha);
    pg.fill(255, alpha);
    pg.line (xpos, height, xpos+rand, 0); // reverse coordinates for the shader
  }
  pg.endDraw();
}
//////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8) draw a bunch of rotating rectangles, uses mousePressed vertical position for fade
void draw_rectangles(PGraphics pg, boolean top_mode) {
  if (mousePressed && mouseButton == LEFT && top_mode) {
    add = map (mouseX, 0, width, 0.0025, 0.5);
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {
    add = map (mouseX, 0, width, 0.0025, 0.5);
  }
  step += add ;
  pg.smooth(8);
  pg.beginDraw();
  pg.noStroke();
  pg.fill(0, fade);
  pg.rect(0, 0, width, height);   
  for (int i = 0 ; i < 1280 ; i+=50) {
    for (int j = 0 ;j < 720 ; j+=50) {
      //pg.fill(255,50);
      pg.noFill();
      pg.stroke(255);
      pg.pushMatrix();
      pg.translate(i, j);
      pg.rotate(step+(i+j));

      pg.rect(0, 0, 75, 75);
      pg.popMatrix();
    }
  }
  pg.endDraw();
}
//////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 9) draw a network of balls bouncing aroud, an connecting according to a distance threshold
// mouse vertically to adjust threshold, and mouse for fade
void draw_ball_network(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.smooth(8);
  pg.fill(0, fade);
  pg.rect(0, 0, width, height); 
  if (mousePressed && mouseButton == LEFT && top_mode) {
    treshold = map (mouseX, 0, width, 0, 150);
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {
    treshold = map (mouseX, 0, width, 0, 150);
  }
  pg.stroke(255);
  for (int i = 0 ; i < num ; i++) {
    movs[i].update();
    for (int j = i ; j < num ; j++) {  
      if (dist(movs[i].loc.x, movs[i].loc.y, movs[j].loc.x, movs[j].loc.y) < treshold) {     
        pg.line(movs[i].loc.x, movs[i].loc.y, movs[j].loc.x, movs[j].loc.y);
      }
    }
  }
  pg.endDraw();
}
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 10) draw a nice pattern of bezier curves with 4 agent
void draw_bezier_lines(PGraphics pg) {
  pg.beginDraw();
  pg.smooth(8);
  pg.strokeWeight(0.2);
  pg.fill(0, 0);
  pg.rect(0, 0, width, height); 
  rt1.run(pg);
  rt2.run(pg);
  rt3.run(pg);
  rt4.run(pg);
  pg.endDraw();
}
//////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 11) draw a spring structure reacting to the mouse (it need c_node, c_spring and c_spring_structure tabs to work)
// it reacts at the position of the mouse
void draw_spring_structure(PGraphics pg) {
  pg.beginDraw();
  pg.smooth(8);
  pg.background(0);
  mouseNode.setLocation(mouseX, mouseY);
  mouseNode.update();
  pg.noFill();
  for (int i = 0 ; i <300 ; i++) {
    bodies[i].run(pg);
    mouseNode.attract(bodies[i].nodes);
  }
  pg.endDraw();
}
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 12) draw a moiree spring structure reacting to the mouse (it need c_node, c_spring and c_spring_structure tabs to work)
// it reacts at the position of the mouse
void draw_moiree_springs(PGraphics pg) {
  mouseNode.setLocation(mouseX, mouseY);
  mouseNode.update();
  pg.beginDraw();
  pg.background(0);
  pg.stroke(255);
  pg.noFill();
  for (int i = 0 ; i <400 ; i++) {
    bodies2[i].run(pg);
    mouseNode.attract(bodies2[i].nodes);
  }
  pg.fill(255);
  pg.ellipse(width/2, height/2, 95, 95);
  pg.endDraw();
}
///////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 13) draw a particle system (it need c_particle_system tab to work)
// it reacts at the position of the mouse
void draw_particle_system(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.smooth(8);
  pg.background(0);
  pg.noStroke();
  ps.run(pg);
  if (mousePressed && mouseButton == LEFT && top_mode) {
    ps.addParticle(mouseX, height-mouseY);  
    ps.addParticle(mouseX, height-mouseY);  
    ps.addParticle(mouseX, height-mouseY);
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {
    ps.addParticle(mouseX, height-mouseY);  
    ps.addParticle(mouseX, height-mouseY);  
    ps.addParticle(mouseX, height-mouseY);
  }
  pg.endDraw();
}
///////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 14) setup and draw a dla process
// we need a setup to be able to recall it every now and then
void setup_dla() {
  particleCount = 20000;
  dla_width = width/2;
  dla_height = height/2 ;
  field = new boolean[dla_width * dla_height];
  field[int(random(dla_width) + random(dla_height) * (dla_width))] = true;
  field[int(random(dla_width) + random(dla_height) * (dla_width))] = true;
  field[int(random(dla_width) + random(dla_height) * (dla_width))] = true;
  particles1 = new Dla_particle[particleCount]; 
  particles2 = new Dla_particle[particleCount]; 
  particles3 = new Dla_particle[particleCount]; 
  for (int i=0; i<particleCount; i++) {
    particles1[i] = new Dla_particle(dla_width, dla_height);
    particles2[i] = new Dla_particle(dla_width, dla_height);
    particles3[i] = new Dla_particle(dla_width, dla_height);
  }
}

void draw_dla(PGraphics pg) {
  pg.beginDraw();
  pg.smooth(8);
  // pg.background(0);
  pg.stroke(255);
  pg.scale(2, 2);
  pg.strokeWeight(1);
  //pg.strokeCap(ROUND);
  // pg.translate(width/4, height/4);
  for (int i=0; i<particleCount; i++) {
    particles1[i].update();
    particles2[i].update();
    particles3[i].update();
    if (particles1[i].stuck) {
      pg.point(particles1[i].x, particles1[i].y);
    }
    if (particles2[i].stuck) {
      pg.point(particles2[i].x, particles2[i].y);
    }
    if (particles3[i].stuck) {
      pg.point(particles3[i].x, particles3[i].y);
    }
  }
  pg.endDraw();
  if (frameCount % 125 == 0) { // dla is more and more cpu hungry as it runs, so we reset everything with new position every 125 frame
    setup_dla();
  }
}
////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 15) draw a special sphere 
void draw_sphere(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.smooth(8);
  sphere.draw_sphere(pg, top_mode);
  pg.endDraw();
}


////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 34) draw moving rectangles
void draw_moving_rectangles(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  pg.smooth(8);
  Arrays.sort(rects);
  for (int i = 0 ; i <rects.length ; i+=1) {    
    rects[i].draw_me(pg);
    rects[i].update();
  }

  if (mousePressed && mouseButton == LEFT && top_mode) {
    for (int i = 0 ; i < rects.length ; i++) {   
      float newRad = random(0, 1200);
      rects[i].set_radius(newRad);
      float newHue = random(0, 255);
      //rects[i].set_hue(newHue);
    }
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {
    for (int i = 0 ; i < rects.length ; i++) {   
      float newRad = random(0, 1200);
      rects[i].set_radius(newRad);
      float newHue = random(0, 255);
      //rects[i].set_hue(newHue);
    }
  }
  pg.endDraw();
}


////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 34) draw moving rectangles
void draw_moving_circles(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  pg.smooth(8);
  Arrays.sort(circs);
  for (int i = 0 ; i <circs.length ; i+=1) {    
    circs[i].draw_me(pg);
    circs[i].update();
  }

  if (mousePressed && mouseButton == LEFT && top_mode) {
    for (int i = 0 ; i < circs.length ; i++) {   
      float newRad = random(0, 1200);
      circs[i].set_radius(newRad);
      float newHue = random(0, 255);
      //rects[i].set_hue(newHue);
    }
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {
    for (int i = 0 ; i < circs.length ; i++) {   
      float newRad = random(0, 1200);
      circs[i].set_radius(newRad);
      float newHue = random(0, 255);
      //rects[i].set_hue(newHue);
    }
  }
  pg.endDraw();
}


////////////////////////////////////////////////////////////////////////////////////////////

