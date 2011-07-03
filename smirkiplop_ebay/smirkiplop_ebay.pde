

import org.openkinect.*;
import org.openkinect.processing.*;

Kinect kinect;

// Size of kinect image
int w = 640;
int h = 480;

PImage level1;
PImage level2;
PImage level3;
PImage level4;

PImage imgMask; 
PImage leftImage;

//mb edits
PImage depthDataImg;
PImage blurredDepthImg;

int Threshold0; 
int Threshold1 = 790; 
int Threshold2 = 780;
int Threshold3 = 770;
int Threshold4 = 660;
int Threshold5 = 350;

int currentLevel = 1;
int previousLevel = 2;

int[] depth;




//----------------------------------------------------------------------------------------------------------

void setup() {

  size(640, 480,P3D);


  println ("Initializing Kiwis .... "); 
  println ("Collecting Watermelons .... "); 
  println ("Calibrating Bananas ...."); 
  println (" "); 
  println (" "); 
  println ("To calibrate Level 1: q and w");  
  println ("To calibrate Level 2: e and r");  
  println ("To calibrate Level 3: t and y");
  println ("To calibrate Level 4: u and i")  ;
  println ("To calibrate Level 5: o and p "); 
 
  
  level4 = loadImage("LVL4HELL.png");
  level3 = loadImage("LVL3GEMS2.png");
  level2 = loadImage("LV2Sand.png");
  level1 = loadImage("LVL1moon.png");

 
  
  calibrate = loadImage ("smirky_calibrate.png"); 

  imgMask = loadImage ("newmask2.jpg"); 
  imgMask.loadPixels();

  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  kinect.processDepthImage(true);

  leftImage = new PImage(640, 480);



}




//----------------------------------------------------------------------------------------------------------------




void draw() { 
  
  background(0);




  depth = kinect.getRawDepth();

  // keep track of the deepest depth that we know about. this is for sound and for the movies. 
  float deepestdepth = 2000;
  float averagedepth = 0;
  float numpoints = 0;

  for (int x = 300; x < 350; x++) {
    for (int y = 200; y < 250; y++) {
      int p = (640 * y) + x;

      // get the depth at this location
      float currentdepth = depth[p];

      averagedepth = averagedepth + currentdepth;
      numpoints++;

      if (currentdepth < deepestdepth)
      {
        deepestdepth = currentdepth;
      }
    }
  }

 averagedepth = averagedepth / numpoints;


   //blurring the kinect data : enable this if needed      
   
  // blurredDepthImg = new PImage( 640, 480 );
   //System.arraycopy( kinect.getDepthImage().pixels, 0, blurredDepthImg.pixels, 0, kinect.getDepthImage().pixels.length );
   //fastblur( blurredDepthImg, 7 ); // change the last number for the radius of the blur
   
   





  // go through the entire banana
  ////////////////////////////////////////////////////////////////////////////////////////// THIS IS THE BIG FOR LOOP

  for (int x = 0; x < 640; x++) {
    for (int y = 0; y < 480; y++) {

      int p = (640 * y) + x; 





      // is this a black pixel in the image mask?
      color maskcolor = imgMask.pixels[p];
      float redness = red(maskcolor);

      if (redness > 50)
      {
        leftImage.pixels[p] = level1.pixels[p];
      }


      ///////////////////////////// THIS IS FOR LEFT IMAGE ////////////////////////////////


      // calculate the percentage values for each level
      if (depth[p] > Threshold1)
      {
        leftImage.pixels[p] = level1.pixels[p];
      }

 else if (depth[p] < Threshold1 && depth[p] > Threshold2)
 {
leftImage.pixels[p] = level2.pixels[p];
 }
 
  else if (depth[p] < Threshold2 && depth[p] > Threshold3)
 {
leftImage.pixels[p] = level3.pixels[p];
 }
 
  else if (depth[p] < Threshold3 && depth[p] > Threshold4)
 {
leftImage.pixels[p] = level4.pixels[p];
 }
 
 
 
 
 




      // we start blending here

//      else if (depth[p] < Threshold1 && depth[p] > Threshold2)
//      {
//        // map between level 1 and level 2
//        float percent_level1 = map(depth[p], Threshold2, Threshold1, 0, 1); 
//        float percent_level2 = 1 - percent_level1;
//
//        // extract color values from the first level
//        float level1_red   = red(level1.pixels[p]);
//        float level1_green = green(level1.pixels[p]);
//        float level1_blue  = blue(level1.pixels[p]);
//
//        // extract color values from the second level
//        float level2_red   = red(level2.pixels[p]);
//        float level2_green = green(level2.pixels[p]);
//        float level2_blue  = blue(level2.pixels[p]);
//
//        // construct average pixel colors based on our mapped weights value
//        float newred   = ( level1_red*percent_level1   + level2_red*percent_level2 ) / 2;
//        float newgreen = ( level1_green*percent_level1 + level2_green*percent_level2 ) / 2;
//        float newblue  = ( level1_blue*percent_level1  + level2_blue*percent_level2 ) / 2;
//
//        // construct a new color
//        color newcolor = color( newred, newgreen, newblue );
//
//        // assign that color to this pixel
//        leftImage.pixels[p] = newcolor;
//      }
//
//      else if (depth[p] < Threshold2 && depth[p] > Threshold3)
//      {
//        // map between level 1 and level 2
//        float percent_level1 = map(depth[p], Threshold3, Threshold2, 0, 1); 
//        float percent_level2 = 1 - percent_level1;
//
//        // extract color values from the first level
//        float level1_red   = red(level2.pixels[p]);
//        float level1_green = green(level2.pixels[p]);
//        float level1_blue  = blue(level2.pixels[p]);
//
//        // extract color values from the second level
//        float level2_red   = red(level3.pixels[p]);
//        float level2_green = green(level3.pixels[p]);
//        float level2_blue  = blue(level3.pixels[p]);
//
//        // construct average pixel colors based on our mapped weights value
//        float newred   = ( level1_red*percent_level1   + level2_red*percent_level2 ) / 2;
//        float newgreen = ( level1_green*percent_level1 + level2_green*percent_level2 ) / 2;
//        float newblue  = ( level1_blue*percent_level1  + level2_blue*percent_level2 ) / 2;
//
//        // construct a new color
//        color newcolor = color( newred, newgreen, newblue );
//
//        // assign that color to this pixel
//        leftImage.pixels[p] = newcolor;
//      }
//
//      else if (depth[p] < Threshold3 && depth[p] > Threshold4)
//      {
//        // map between level 1 and level 2
//        float percent_level1 = map(depth[p], Threshold4, Threshold3, 0, 1); 
//        float percent_level2 = 1 - percent_level1;
//
//        // extract color values from the first level
//        float level1_red   = red(level3.pixels[p]);
//        float level1_green = green(level3.pixels[p]);
//        float level1_blue  = blue(level3.pixels[p]);
//
//        // extract color values from the second level
//        float level2_red   = red(level4.pixels[p]);
//        float level2_green = green(level4.pixels[p]);
//        float level2_blue  = blue(level4.pixels[p]);
//
//        // construct average pixel colors based on our mapped weights value
//        float newred   = ( level1_red*percent_level1   + level2_red*percent_level2 ) / 2;
//        float newgreen = ( level1_green*percent_level1 + level2_green*percent_level2 ) / 2;
//        float newblue  = ( level1_blue*percent_level1  + level2_blue*percent_level2 ) / 2;
//
//        // construct a new color
//        color newcolor = color( newred, newgreen, newblue );
//
//        // assign that color to this pixel
//        leftImage.pixels[p] = newcolor;
//        
//       
//      }        

      // all else fails -- do this        
      else
      {
        leftImage.pixels[p] = level1.pixels[p];
      }

    }

  }  
  image (leftImage, 0,0); 
  //image (blurredDepthImg, 0,0);
  
  
}




/////////////////////////////////////////////////////////////////////////////////// END DRAW //////////////////////////////////////////////////////////







void mouseClicked() {
  int p = mouseX + (640 * mouseY);

  println(depth[p]);
}



public void keyPressed() {


  if (key == 'q') {
    Threshold1--;
  } 
  else if (key == 'w') {
    Threshold1++;
  }
  if (key == 'e') {
    Threshold2--;
  } 
  else if (key == 'r') {
    Threshold2++;
  }
  if (key == 't') {
    Threshold3--;
  } 
  else if (key == 'y') {
    Threshold3++;
  }
  else if (key == 'u') {
    Threshold4--;
  } 
  else if (key == 'i') {
    Threshold4++;
  } 
  else if (key == 'o') {
    Threshold5++;
  } 
  else if (key == 'p') {
    Threshold5++;
  }
  else if (key == 'c') {
    image (calibrate, 0, 0); 
  }

  println("Level 1:" + Threshold1 + " , Level 2: " + Threshold2 + " ,Level 3:" + Threshold3 + " , Level 4 " + Threshold4 + " , Level 5 " + Threshold5);
}






void stop () {

  kinect.quit();


}

