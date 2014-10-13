
String[] animationNames = {
  "image_1  -- (n.a.)", 
  "image_2  -- (n.a.)", 
  "image_travelling  --  ( click and drag the mouse around  /  '-' and '+' to zoom out and in )", 
  "webcam  -- (n.a.)", 
  "movie  -- (n.a.)", 
  "circles  -- ( 'f' and 'F' to decrease, increase fade )", 
  "lines  -- ( 'f' and 'F' to decrease, increase fade  )", 
  "rectangles  -- ( 'f' and 'F' to decrease, increase fade  /  click and drag mouse horizontally to change rotation speed )", 
  "ball_network  -- ( 'f' and 'F' to decrease, increase fade  /  click and drag mouse horizontally to change threshold that connects balls )", 
  "bezier_lines  -- (n.a.)", 
  "spring_structure  -- ( move the mouse around to repulse nodes )", 
  "moiree_springs  -- ( move the mouse around to repulse nodes )", 
  "particle_system   -- ( click to add particles and move the mouse around )", 
  "dla  -- (n.a.)", 
  "sphere  -- ( click and drag to rotate / 'z' and 'Z' to zoom out and in )", 
  "blobby  -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around ) ", 
  "drip  -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around )", 
  "electro  -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around )", 
  "bands  -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around )", 
  "sinewaves  -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around )", 
  "noisy  -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around )", 
  "nebula  -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around )", 
  "monjori  -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around )", 
  "eye -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around )", 
  "fire_shader  -- ( 's' and 'S' to decrease and increase speed ) ", 
  "blue fire  -- ( 's' and 'S' to decrease and increase speed ) ", 
  "flame  -- ( 's' and 'S' to decrease and increase speed ) ", 
  "lava  -- ( 's' and 'S' to decrease and increase speed ) ", 
  "cloud  -- ( 's' and 'S' to decrease and increase speed ) ", 
  "snow  -- ( 's' and 'S' to decrease and increase speed ) ", 
  "state of the art  -- ( 's' and 'S' to decrease and increase speed ) ", 
  "conway_shader  -- ( 's' and 'S' to decrease and increase speed / click and drag mouse around )", 
  "deform_shader  -- (click and drag the mouse around )", 
  "deform_image_shader  -- ( click and drag the mouse around )", 
  "moving_rectangles -- (click to move things aroud)",
  "moving_circles -- (click to move things aroud)"
};


// Let's give a name to each blend mode
static final int BL_DARKEN        =  0;
static final int BL_MULTIPLY      =  1;

static final int BL_COLORBURN     =  2;
static final int BL_LINEARBURN    =  3;
static final int BL_DARKERCOLOR   =  4;

static final int BL_LIGHTEN       =  5;
static final int BL_SCREEN        =  6;
static final int BL_COLORDODGE    =  7;
static final int BL_LINEARDODGE   =  8;
static final int BL_LIGHTERCOLOR  =  9;

static final int BL_OVERLAY       = 10;
static final int BL_SOFTLIGHT     = 11;
static final int BL_HARDLIGHT     = 12;
static final int BL_VIVIDLIGHT    = 13;
static final int BL_LINEARLIGHT   = 14;
static final int BL_PINLIGHT      = 15;
static final int BL_HARDMIX       = 16;

static final int BL_DIFFERENCE    = 17;
static final int BL_EXCLUSION     = 18;
static final int BL_SUBSTRACT     = 19;
static final int BL_DIVIDE        = 20;

static final int BL_HUE           = 21;
static final int BL_COLOR         = 22;
static final int BL_SATURATION    = 23;
static final int BL_LUMINOSITY    = 24;

// Let's store the names of the modes too
String[] blendNames = {
  "Darken", 
  "Multiply", 
  "Color burn", 
  "Linear burn", 
  "Darker color", 
  "Lighten", 
  "Screen", 
  "Color dodge", 
  "Linear dodge", 
  "Lighter color", 
  "Overlay", 
  "Soft light", 
  "Hard light", 
  "Vivid light", 
  "Linear light", 
  "Pin light", 
  "Hard mix", 
  "Difference", 
  "Exclusion", 
  "Substract", 
  "Divide", 
  "Hue", 
  "Color", 
  "Saturation", 
  "Luminosity"
};

void draw_gui() {
  // Display the GUI ( press G to hide/show )
  if (isGUI) {
    fill(255, 255, 255, 150);
    noStroke();
    rect(0, 0, width, 100);
    pushStyle();
    textAlign(LEFT);
    textSize(14);
    fill(255, 0, 0);  
    text("Framerate : " + nf(frameRate, 0, 1) + "  --  Fade value : "+ fade+"  --  Shader speed : "+incr_shader, 10, 15 );
    textSize(12);
    fill(0);
    text("Blend mode             : " + blendIndex + ") " + blendNames[ blendIndex] + "  --  ('o' to decrease / 'O' to increase)" + "  --  " +"Opacity : "+ floor(blendOpacity * 100) + "%", 10, 40 );
    text("Top layer animation  : " + top_pg_index +") " + animationNames[top_pg_index], 10, 60 );
    text("Low layer animation  : " + low_pg_index +") " + animationNames[low_pg_index], 10, 80 );


    popStyle();
  }
}

void switch_drawings(PGraphics pg, int index, boolean top_mode) {
  if (index == 0) {
    draw_image(pg, image_1);
  } else if (index == 1) {
    draw_image(pg, image_2);
  } else if (index == 2) {
    draw_image_travelling(pg, image_1, top_mode);
  } else if (index == 3) {
    //draw_webcam(pg);
  } else if (index == 4) {
    draw_movie(pg);
  } else if (index == 5) {
    draw_circles(pg);
  } else if (index == 6) {
    draw_lines(pg);
  } else if (index == 7) {
    draw_rectangles(pg, top_mode);
  } else if (index == 8) {
    draw_ball_network(pg, top_mode);
  } else if (index == 9) {
    draw_bezier_lines(pg);
  } else if (index == 10) {
    draw_spring_structure(pg);
  } else if (index == 11) {
    draw_moiree_springs(pg);
  } else if (index == 12) {
    draw_particle_system(pg, top_mode);
  } else if (index == 13) {
    draw_dla(pg);
  } else if (index == 14) {
    draw_sphere(pg, top_mode);
  } else if (index == 15) {
    draw_blobby_shader(pg, top_mode);
  } else if (index == 16) {
    draw_drip_shader(pg, top_mode);
  } else if (index == 17) {
    draw_electro_shader(pg, top_mode);
  } else if (index == 18) {
    draw_bands_shader(pg, top_mode);
  } else if (index == 19) {
    draw_sinewaves_shader(pg, top_mode);
  } else if (index == 20) {
    draw_noisy_shader(pg, top_mode);
  } else if (index == 21) {
    draw_nebula_shader(pg, top_mode);
  } else if (index == 22) {
    draw_monjori_shader(pg, top_mode);
  } else if (index == 23) {
    draw_eye_shader(pg, top_mode);
  } else if (index == 24) {
    draw_fire_shader(pg);
  } else if (index == 25) {
    draw_blue_fire_shader(pg);
  } else if (index == 26) {
    draw_flame_shader(pg);
  } else if (index == 27) {
    draw_lava_shader(pg);
  } else if (index == 28) {
    draw_cloud_shader(pg);
  } else if (index == 29) {
    draw_snow_shader(pg);
  } else if (index == 30) {
    draw_state_of_the_art_shader(pg);
  } else if (index == 30) {
    draw_conway_shader(pg, top_mode);
  } else if (index == 32) {
    draw_deform_shader(pg, top_mode);
  } else if (index == 33) {
    draw_deform_image_shader(pg, image_1, top_mode);
  } else if (index == 34) {
    draw_moving_rectangles(pg, top_mode);
  }
  else if (index == 35) {
    draw_moving_circles(pg, top_mode);
  }
}

