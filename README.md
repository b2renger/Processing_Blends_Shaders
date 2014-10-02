Processing_n_Blends_n_Shaders
=============================

check out the demo video : https://vimeo.com/107819398

Foreword
========
most of the code here comes from Raphaël de Courville a.k.a sableRaf 
you should definitely look at his repos, and specifically at this repo : https://github.com/SableRaf/Processing-Experiments which holds most of the shader code used here. Other shaders come from the processing examples (you know ... in File -> Examples -> Topics -> Shaders)

A lot of code also comes from internet, I tried to track down the origins of the code published here, but I may have made mistakes, so don't hesitate to claim attribution if you recognized something you coded, or feel there is a problem of licesing.

if you do something with it, don't hesitate to drop me a mail !

for questions and comments you can use the issues tracker of github.



What is it ?
============
This repo hosts the code for my framework to experiment with blend modes, and shaders in Processing. The main goal is to be able to blend anything with anything, so you've got a basic blending mechanism (blend a "top layer" with a "low layer" made of a PGraphics object), and then you have a bunch of functions to write several things in those two PGraphics objects. All the blending happens with a shader, so it's really fast.

Some functions are processing drawings. (you'll need to use processing video, a webcam could be usefull too)
Some functions are fragment shaders.

You've got control over blend modes, and several drawing modes for each PGraphics object with the keyboard. Sometimes other controls are available with the mouse.


Why
===
I made this because shaders are hard to code but there's a lot of them on the web so I wanted to have a litlle library of shader effects. Also blends are fun, but blends written are a lot more fun since they are fast even on small machines. And when you combine all this it actually gets pretty fun :) 
So it's more for exeperimenting but I wanted to keep it modular so it can be easily re-arranged, it should be easy to create another code structure to have the desired effect at the touch of key. I guess it could easily be turned into a VJing software just moving a few things around.
Those examples won't help you write shaders but hopefully it will help you use them.
So have fun !


Some of the stuff here doesn't make anything, what do I do ?
============================================================
Everything is blended and for convenience, I only use one big list of animation, so for instance if you use the shader "cloud" (which graphics should be mostly white) as a low layer of your blend while being in mode darken ... then you don't get much of result. If you don't undestand this check out more ressources on blends, many people have explained this way better than I would be able to do.



Contribute
==========
Please do some pullrequest to add more shaders or drawings ! just be sure to add them to the list so everything won't break and if you can try to comment the processing code a bit to explain how the shader works (uniforms, controls etc.)

For instance, here is how to add a new shader in three steps.

1- First, in the "shader" tab, you can add you code as you would usually build your processing code : so declare your variables at the top, initialize them in the setup_shaders() function with comments, and then add a new function which writes the output of your shader to PGraphics object : 

void draw_myShader_shader(PGraphics pg){
	pg.beginDraw();
	(...)
	pg.endDraw();
}


2- Then, in the main draw() loop of the programm,  you'll find this : switch_drawings(PGraphics pg, int index, boolean top_mode)
You'll need to modify this function to be able to draw your effect.
 else if (index == myValue) { // (myValue needs to be replaced, by the value that is actually right for were you are)
      draw_myShader_shader(top_pg);
  }


3- And last but not least, here's what you need to modify in the main tab to include your contribution to the showcase : 
you need to add its name to the "String[] animationNames" 

the name is used to be displayed  in the gui so if you don't add it the programm will break (probably with a nullpointer), I also use this array of strings to be able to give interaction info about the shader when applicable.


Interaction with your code needs a little trick, not to interfere with others :

Please note that general controls are kept in the main tab, whereas specific controls are kept in their functions, some key are already used please do not change them, if you add more, you can document them at the start of the code, and in your animation names.

If you plan implementing mouse interaction in the code you contribute, the controls for top_drawing use a left-click on the mouse before passing data to our function and the same goes for low_drawing and right-click. This is because we want to be able the interact with one layer keeping the other one intact. So what we do is use a boolean that we pass on our drawing function to know if we are on the top_layer or not.

if (mousePressed && mouseButton == LEFT && top_mode){
	// this means if we are on top layer so we use left button
}
 else if (mousePressed && mouseButton = RIGHT && !top_mode){

}

it relates to this  in the main tab:
 switch_drawings(top_pg, top_pg_index, true); // we draw on top_pg, we draw the drawing at top_pg_indes in our animation list, we explicitly say true to top_pg

this boolean can then be passed to your drawings if you need it.


If you have done everything right you are good to go !

If you are not used to github pullrequest, you can just send me a mail, but it's not that hard an you should try it and get your profile linked as a contributor.






