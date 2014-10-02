PShader blends;
float blendOpacity =0.85;


void setup_blends() {

  // Load the shader file from the "data" folder
  blends = loadShader( "blends.glsl" );
  blends.set( "sketchSize", float(width), float(height) );


  // Pass the images to the shader
  blends.set( "topLayer", top_pg ); 
  blends.set( "lowLayer", low_pg );

  // Pass the resolution of the images to the shader
  blends.set( "topLayerResolution", float( width ), float( height ) );
  blends.set( "lowLayerResolution", float( width ), float( height ) );
  // You can set the blend mode using the name directly
  blends.set( "blendMode", BL_DIFFERENCE );
}


void draw_blends() {

  blends.set( "topLayer", top_pg ); 
  blends.set( "lowLayer", low_pg );

  if (keyPressed) {
    if (key == 'o') {
      blendOpacity -= 0.005;
    } else if (key == 'O') {
      blendOpacity += 0.005;
    }
  }
  blendOpacity = constrain(blendOpacity, 0, 1.5);
  blends.set( "blendAlpha", blendOpacity );
  blends.set( "blendMode", blendIndex );
  shader(blends);
  // Draw the output of the shader onto a rectangle that covers the whole viewport
  rect(0, 0, width, height);
  // Call resetShader() so that further geometry remains unaffected by the shader
  resetShader();
}

