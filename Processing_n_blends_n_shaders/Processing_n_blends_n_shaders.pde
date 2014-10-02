// Based on code by Raphaël de Courville <Twitter: @sableRaph> https://github.com/SableRaf/Processing-Experiments
// Tweaked by berenger recoules to add more shaders ported also by Raphaël, other shaders from processing examples,
// and classic processing drawings to be blended together 

import processing.video.*; // it's necessary to capture webcam, and play movies, see drawings tab


/*
 // Controls:  Always available
 //  
 //  'G':     Display/Hide GUI
 //  '7':     Select previous blend mode
 //  '8':     Select next blend mode
 //  '4':     Select previous drawing mode for top layer
 //  '5':     Select next drawing mode for top layer
 //  '1':     Select previous drawing mode for low layer
 //  '2':     Select next drawing mode for low layer
 //  'o':     Decrease blend opacity
 //  'O':     Increase blend opacity
 //  's':     Decrease shader speed
 //  'S':     Increase shader speed
 //
 //  mouse interactions are available in top layer with LEFT-click
 //  mouse interactions are available in low layer with RIGHT-click
 */



// two Pgraphics objects to be blended
PGraphics top_pg, low_pg;

// Start with that mode
int blendIndex = 0;
int top_pg_index=1;
int low_pg_index=2;

// to wrap around cases in the keyReleased() function
int nb_top_modes ;
int nb_low_modes;

// Show the GUI by default?
boolean isGUI = false;



void setup() {

  size( 1280, 720, P3D );

  top_pg = createGraphics(width, height, P3D);
  low_pg = createGraphics(width, height, P3D);

  setup_shaders(); // see "b_shaders" tab
  setup_blends(); // see "b_blends"tab
  setup_drawings(); // see "b_drawings" tab

  nb_top_modes = animationNames.length;
  nb_low_modes = animationNames.length;

  //println(nb_top_modes);
  //frameRate(30);
}


void draw() {

  // draw things in top_pg according to its index, see bottom of "z_utils" tab
  switch_drawings(top_pg, top_pg_index, true);

  // draw things in low_pg according to its index
  switch_drawings(low_pg, low_pg_index, false);

  // blend both together : top_pg being the "top layer", and low_pg the "low" one
  draw_blends();

  // see the "z_utils" tab
  draw_gui();

  //saveFrame("../frames/####.tif");
}

void keyPressed() {

  // change the time increment to give the shader a time reference
  if (key == 's') {
    incr_shader -= 0.001;
    incr_shader = constrain(incr_shader, 0.0001, 0.25);
  } else if (key == 'S') {
    incr_shader += 0.001;
    incr_shader = constrain(incr_shader, 0.0001, 0.25);
  }

  // modifying fade effect in some drawings
  else if (key == 'f') {
    fade -= 0.5;
    fade = constrain(fade, 0, 255);
  } else if (key == 'F') {
    fade += 0.5;
    fade = constrain(fade, 0, 255);
  }
}


void keyReleased() {

  if ( key == 'g' || key == 'G') {
    isGUI = !isGUI;
  }

  if (key == '7') {
    blendIndex--;
    clean_pg(); // see below
  } else if (key == '8') {
    blendIndex++;
    clean_pg();
  } else if (key == '4') {
    top_pg_index--;
    clean_pg();
  } else if (key == '5') {
    top_pg_index++;
    clean_pg();
  } else if (key == '1') {
    low_pg_index--;
    clean_pg();
  } else if (key == '2') {
    low_pg_index++;
    clean_pg();
  }

  // we need this when changing shaders
  low_pg.resetShader();
  top_pg.resetShader();

  // wrap around
  if ( blendIndex > 24 ) blendIndex =  0;
  else if ( blendIndex <  0 ) blendIndex = 24;
  if ( top_pg_index >= nb_top_modes ) top_pg_index =  0;
  else if ( top_pg_index <  0 ) top_pg_index = nb_top_modes-1;
  if ( low_pg_index >= nb_low_modes ) low_pg_index =  0;
  else if ( low_pg_index <  0 ) low_pg_index = nb_low_modes-1;
}

void movieEvent(Movie movie) {
  mov.read();
}


void clean_pg() {
  // we also need to clean our graphics objects or "layers"
  top_pg.beginDraw();
  top_pg.background(0);
  top_pg.endDraw();

  low_pg.beginDraw();
  low_pg.background(0);
  low_pg.endDraw();
}

