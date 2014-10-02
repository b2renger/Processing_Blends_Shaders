
PShader blobby;

PShader drip;

PShader electro;

PShader bands;

PShader sinewaves;

PShader noisy;

PShader nebula;

PShader monjori;

PShader eye;

PShader fire;

PShader blue_fire;

PShader flame;

PShader lava;

PShader cloud;
PImage texture;

PShader snow;

PShader state_of_the_art;

PShader conway; // from processing doc

PShader deform; // from processing doc


// general variables
float time_shader = 0;
float incr_shader = 0.1;


/////////////////////////////////////////////////////////////////////////
//
void setup_shaders() {

  //16) blobby
  blobby = loadShader("blobby.glsl");
  blobby.set("resolution", float(width), float(height));

  //17) drip
  drip = loadShader("drip.glsl");
  drip.set("resolution", float(width), float(height));

  //18) electro
  electro = loadShader("electro.glsl");
  electro.set("resolution", float(width), float(height));

  //19) bands
  bands = loadShader("bands.glsl");
  bands.set("resolution", float(width), float(height));

  //20) sinewave
  sinewaves = loadShader("sinewave.glsl");
  sinewaves.set("resolution", float(width), float(height));

  //21) noisy
  noisy = loadShader("noisy.glsl");
  noisy.set("resolution", float(width), float(height));

  //22) nebula
  nebula = loadShader("nebula.glsl");
  nebula.set("resolution", float(width), float(height));

  //23) monjori
  monjori = loadShader("monjori.glsl");
  monjori.set("resolution", float(width), float(height));

  //24)eye
  eye = loadShader("eye.glsl");
  eye.set("resolution", float(width), float(height));

  //25) fire shader
  fire = loadShader("fire.glsl");
  fire.set("resolution", float(width), float(height)); 

  //26) blue fire
  blue_fire = loadShader("fire_blue.glsl");
  blue_fire.set("resolution", float(width), float(height)); 

  //27) flame
  flame = loadShader("flame.glsl");
  flame.set("resolution", float(width), float(height));  

  //28) lava
  lava = loadShader("lava.glsl");
  lava.set("resolution", float(width), float(height));  

  //29) clouds, uses a texture
  texture = loadImage("256noise.png");
  cloud = loadShader("clouds.glsl");
  cloud.set("resolution", float(width/2), float(height/2));
  cloud.set("iChannel0", texture);

  //30) snow
  snow = loadShader("snow.glsl");
  snow.set("resolution", float(width), float(height));

  //31) state of the art
  state_of_the_art = loadShader("stateoftheart.glsl");
  state_of_the_art.set("resolution", float(width), float(height));

  //32) conway from processing examples
  conway = loadShader("conway.glsl");
  conway.set("resolution", float(width), float(height)); 

  //33) deform from processing examples
  deform = loadShader("deform.glsl");
  deform.set("resolution", float(width), float(height));
}

/////////////////////////////////////////////////////////////////////////////////////
// 16) blobby : needs a time reference
void draw_blobby_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  blobby.set("time", time_shader);
  if (mousePressed && mouseButton == LEFT && top_mode) {
    blobby.set("depth", map(mouseY, 0, height, 0, 2));
    blobby.set("rate", map(mouseX, 0, width, 0, 2));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    blobby.set("depth", map(mouseY, 0, height, 0, 2));
    blobby.set("rate", map(mouseX, 0, width, 0, 2));
  }   

  pg.shader(blobby);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// 17) drip : needs a time reference
void draw_drip_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  drip.set("time", time_shader);
  drip.set("intense", 0.09);
  drip.set("speed", 0.9);
  if (mousePressed && mouseButton == LEFT && top_mode) {
    drip.set("graininess", (float)mouseX/width, (float)mouseY/height);
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    drip.set("graininess", (float)mouseX/width, (float)mouseY/height);
  }   
  pg.shader(drip);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// 18) electro : needs a time reference
void draw_electro_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  electro.set("time", time_shader);   
  if (mousePressed && mouseButton == LEFT && top_mode) {
    electro.set("rings", map(mouseY, 0, height, 5, 40));  
    electro.set("complexity", map(mouseX, 0, width, 1, 60));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    electro.set("rings", map(mouseY, 0, height, 5, 40));  
    electro.set("complexity", map(mouseX, 0, width, 1, 60));
  }   
  pg.shader(electro);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// 19) bands : needs a time reference
void draw_bands_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  bands.set("time", time_shader);  
  if (mousePressed && mouseButton == LEFT && top_mode) {
    bands.set("noiseFactor", map(mouseX, 0, width, 5, 100));
    bands.set("stripes", map(mouseY, 0, height, 0, 100));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    bands.set("noiseFactor", map(mouseX, 0, width, 5, 100));
    bands.set("stripes", map(mouseY, 0, height, 0, 100));
  }   
  pg.shader(bands);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// 20) sinewaves : needs a time reference
void draw_sinewaves_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  sinewaves.set("time", time_shader);  
  sinewaves.set("colorMult", 2.5, 1.2);
  if (mousePressed && mouseButton == LEFT && top_mode) {
    sinewaves.set("coefficients", 30, map(mouseY, 0, height, 0, 80), map(mouseX, 0, width, 1, 200));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    sinewaves.set("coefficients", 30, map(mouseY, 0, height, 0, 80), map(mouseX, 0, width, 1, 200));
  }   
  pg.shader(sinewaves);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// 21) noisy : needs a time reference
void draw_noisy_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  noisy.set("time", time_shader);  
  noisy.set("noiseFactorTime", 1.0); 
  if (mousePressed && mouseButton == LEFT && top_mode) {
    noisy.set("noiseFactor", map(mouseX, 0, width, 0, 2), map(mouseY, 0, width, 0, 2));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    noisy.set("noiseFactor", map(mouseX, 0, width, 0, 2), map(mouseY, 0, width, 0, 2));
  }   
  pg.shader(noisy);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// 22) nebula : needs a time reference
void draw_nebula_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  nebula.set("time", time_shader);  
  if (mousePressed && mouseButton == LEFT && top_mode) {
    nebula.set("starspeed", map(mouseX, 0, width, 0, 100));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    nebula.set("starspeed", map(mouseX, 0, width, 0, 100));
  }   
  pg.shader(nebula);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// 23) monjori : needs a time reference
void draw_monjori_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  monjori.set("time", time_shader); 
  monjori.set("pace", 50.0); 
  if (mousePressed && mouseButton == LEFT && top_mode) {
    monjori.set("graininess", map(mouseX, 0, width, 10, 100));  
    monjori.set("twist", map(mouseY, 0, height, 0, 100));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    monjori.set("graininess", map(mouseX, 0, width, 10, 100));  
    monjori.set("twist", map(mouseY, 0, height, 0, 100));
  } 
  pg.shader(monjori);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// 24) eye : needs a time reference
void draw_eye_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  eye.set("time", time_shader);  
  if (mousePressed && mouseButton == LEFT && top_mode) {
    eye.set("mouse", (float)mouseX, (float)height-mouseY);
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    eye.set("mouse", (float)mouseX, (float)height-mouseY);
  } 
  pg.shader(eye);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// 25) fire : needs a time reference
void draw_fire_shader(PGraphics pg) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  fire.set("time", time_shader);
  pg.shader(fire);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////
// 26) blue fire : needs a time reference
void draw_blue_fire_shader(PGraphics pg) {
  pg.beginDraw();
  time_shader += incr_shader; 
  blue_fire.set("time", time_shader);
  pg.shader(blue_fire);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////
// 27) flame : needs a time reference
void draw_flame_shader(PGraphics pg) {
  pg.beginDraw();
  time_shader += incr_shader; 
  flame.set("time", time_shader);
  pg.shader(flame);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////
// 28) lava : needs a time reference
void draw_lava_shader(PGraphics pg) {
  pg.beginDraw();
  time_shader += incr_shader; 
  lava.set("time", time_shader);
  pg.shader(lava);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////
// 29) cloud : needs a time reference
void draw_cloud_shader(PGraphics pg) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  cloud.set("time", time_shader);
  pg.shader(cloud);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////
// 30) snow : needs a time reference
void draw_snow_shader(PGraphics pg) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  snow.set("time", time_shader);
  pg.shader(snow);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////
// 31) stateoftheart : needs a time reference
void draw_state_of_the_art_shader(PGraphics pg ) {
  pg.beginDraw();
  pg.background(0);
  time_shader += incr_shader; 
  state_of_the_art.set("time", time_shader);
  pg.shader(state_of_the_art);
  pg.fill(255);
  pg.rect(0, 0, width, height);  
  pg.endDraw();
}
///////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////
// 32) conway : needs a time reference
// and has a mouse uniform to pass coordinates
void draw_conway_shader(PGraphics pg, boolean top_mode) {
  time_shader += incr_shader; 
  conway.set("time", time_shader);
  float x = map(mouseX, 0, width, 0, 1);
  float y = map(mouseY, 0, height, 0, 1);
  if (mousePressed && mouseButton == LEFT && top_mode) {
    conway.set("mouse", x, y);
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {  
    conway.set("mouse", x, y);
  } 
  pg.beginDraw();
  pg.background(0);
  pg.shader(conway);
  pg.fill(255);
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();
}
///////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////
// 33) deform shader needs an image or a graphic to deform it, if you use it on top layer without something drawn to the screen it won't do anything.
// so i overloaded this function :
// one that works with a second PGraphics object
void draw_deform_shader(PGraphics pg, boolean top_mode) {
  pg.beginDraw();
  time_shader += incr_shader; 
  deform.set("time", time_shader);
  if (mousePressed && mouseButton == LEFT && top_mode) {
    deform.set("mouse", float(mouseX), float(mouseY));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {
    deform.set("mouse", float(mouseX), float(mouseY));
  }
  pg.shader(deform);
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();
}
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////
// 34) one that works with a PImage object
void draw_deform_image_shader(PGraphics pg, PImage pi, boolean top_mode) {
  pg.beginDraw();
  time_shader += incr_shader; 
  deform.set("time", time_shader);
  if (mousePressed && mouseButton == LEFT && top_mode) {
    deform.set("mouse", float(mouseX), float(mouseY));
  } else if (mousePressed && mouseButton == RIGHT && !top_mode) {
    deform.set("mouse", float(mouseX), float(mouseY));
  }
  pg.shader(deform);
  pg.image(pi, 0, 0);
  pg.endDraw();
}
////////////////////////////////////////////////////////////

