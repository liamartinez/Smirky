
//Kinect
import org.openkinect.*;
import org.openkinect.processing.*;
Kinect kinect;

//Toxi
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.audio.*;
import toxi.geom.*;
VerletPhysics2D physics;


//Audio
AudioSource sound[];
SoundListener listener;
JOALUtil audioSys;

// Size of kinect image
int w = 640;
int h = 480;

//PImages for the levels
PImage level1;
PImage level2;
PImage level3;
PImage level4;
PImage imgMask; 
PImage imgMaskAlpha; 
PImage surface;

PImage depthDataImg;
PImage blurredDepthImg;

//Threshholds
int Threshold0; 
int Threshold1 = 790; 
int Threshold2 = 780;
int Threshold3 = 770;
int Threshold4 = 660;
int Threshold5 = 350;

int[] depth;

boolean enableMask = false; 

float returnValue;

//Smirkies
ArrayList<Smirky> Smirkys;

//number of smirkies
int numSmirkies = 50; 

//Attractors
ArrayList asystems;

//for getting fingerX & fingerY
int depthXPicOffset = 30;
int depthYPicOffset = 30;
int fingerX; 
int fingerY; 
int lastX;
int lastY;
 
//variables that determine if they are too close together
int distanceApart = 20; 
boolean oktoplace = true; 
int counter = 0; 

//these offsets change the range for creating attractors
int frontThreshold = 440;
int backThreshold = 480;

//returnValue
//boolean returnValue = false; 

//----------------------------------------------------------------------------------------------------------

void setup() {

  size(w, h, P2D);
  smooth();

  //initialize startup sequence
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

  //initialize Kinect
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  kinect.processDepthImage(true);
  //kinect.enableRGB(true); //if you want picture




    //----------- the following is for the background and the audio -----------//

  //setupAudio();     //disable this if you dont want audio

  level4 = loadImage("LVL4HELL.png");
  level3 = loadImage("LVL3GEMS2.png");
  level2 = loadImage("LV2Sand.png");
  level1 = loadImage("LVL1moon.png");

  imgMask = loadImage ("smirkymask_white.jpg"); 
  imgMaskAlpha = loadImage ("smirkymask.jpg"); 
  imgMask.loadPixels();
  imgMaskAlpha.loadPixels(); 
  imgMaskAlpha.mask(imgMask);

  surface = new PImage(640, 480);

  //----------- the following is for the Smirkies and the Attractors ---------//


  //physics
  physics = new VerletPhysics2D ();
  physics.setDrag (0.05f);
  // This is the center of the world
  Vec2D center = new Vec2D(width/2,height/2);
  // these are the worlds dimensions (50%, a vector pointing out from the center in both directions)
  Vec2D extent = new Vec2D(230, 230);
  //physics.setWorldBounds(new Rect(0, 0, width, height));  
  physics.setWorldBounds(Rect.fromCenterExtent (center, extent));  

  //initialize arrays
  asystems = new ArrayList();

  Smirkys = new ArrayList<Smirky>();
  for (int i = 0; i < numSmirkies; i++) {
    Smirkys.add(new Smirky(new Vec2D(random(width), random(height))));
  }
}




//----------------------------------------------------------------------------------------------------------------




void draw() { 

  //----------- the following is for the background and the audio -----------//

  depth = kinect.getRawDepth();
  background(0);


  enableMask(); //remove this if you dont want to use a mask
  drawSurface(); //the original without blending
  //drawSurfaceBlended(); //with blending

  getDeepestDepth(); //get the deepest depth based on a narrow area in the middle
  //enableAudio(); //remember to enable setupAudio() in the setup 


  image (surface, 0, 0); //draw the surface

  //----------- the following is for the Smirkies and the Attractors -----------//

  loadPixels ();

  makeSpot (); 
  updatePixels();

  physics.update ();

  // I dont know why they are different kinds of for loops but
  // the first one calls the Smirkies and ...
  for (Smirky p: Smirkys) {
    p.display();
  }

  // ... this one calls the Attractors
  for (int i = asystems.size()-1; i >= 0; i--) {
    AttractorSystem asys = (AttractorSystem) asystems.get(i);
    asys.run();
  }
  
  image (imgMaskAlpha, 0,0); 
}



//------------------------------------------------------------------------------------------------------------------------------------------------------------------

void drawSurface() {
  for (int x = 0; x < 640; x++) {
    for (int y = 0; y < 480; y++) {

      int p = (640 * y) + x; 


      // is this a black pixel in the image mask?
      color maskcolor = imgMask.pixels[p];
      float redness = red(maskcolor);
      if (enableMask && redness > 50)
      {
        surface.pixels[p] = color (0, 0, 0);
      }


      // calculate the percentage values for each level
      else if (depth[p] > Threshold1)
      {
        surface.pixels[p] = level1.pixels[p];
      }

      else if (depth[p] < Threshold1 && depth[p] > Threshold2)
      {
        surface.pixels[p] = level2.pixels[p];
      }

      else if (depth[p] < Threshold2 && depth[p] > Threshold3)
      {
        surface.pixels[p] = level3.pixels[p];
      }

      else if (depth[p] < Threshold3 && depth[p] > Threshold4)
      {
        surface.pixels[p] = level4.pixels[p];
      }


      // all else fails -- do this        
      else
      {
        surface.pixels[p] = level1.pixels[p];
      }
    }
  }
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------

void drawSurfaceBlended() {


  for (int x = 0; x < 640; x++) {
    for (int y = 0; y < 480; y++) {

      int p = (640 * y) + x;           

      // is this a black pixel in the image mask?

      color maskcolor = imgMask.pixels[p];
      float redness = red(maskcolor);
      if (enableMask && redness > 50)
      {
        surface.pixels[p] = color (0, 0, 0);
      }


      else if (depth[p] < Threshold1 && depth[p] > Threshold2)
      {
        // map between level 1 and level 2
        float percent_level1 = map(depth[p], Threshold2, Threshold1, 0, 1); 
        float percent_level2 = 1 - percent_level1;

        // extract color values from the first level
        float level1_red   = red(level1.pixels[p]);
        float level1_green = green(level1.pixels[p]);
        float level1_blue  = blue(level1.pixels[p]);

        // extract color values from the second level
        float level2_red   = red(level2.pixels[p]);
        float level2_green = green(level2.pixels[p]);
        float level2_blue  = blue(level2.pixels[p]);

        // construct average pixel colors based on our mapped weights value
        float newred   = ( level1_red*percent_level1   + level2_red*percent_level2 ) / 2;
        float newgreen = ( level1_green*percent_level1 + level2_green*percent_level2 ) / 2;
        float newblue  = ( level1_blue*percent_level1  + level2_blue*percent_level2 ) / 2;

        // construct a new color
        color newcolor = color( newred, newgreen, newblue );

        // assign that color to this pixel
        surface.pixels[p] = newcolor;
      }

      else if (depth[p] < Threshold2 && depth[p] > Threshold3)
      {
        // map between level 1 and level 2
        float percent_level1 = map(depth[p], Threshold3, Threshold2, 0, 1); 
        float percent_level2 = 1 - percent_level1;

        // extract color values from the first level
        float level1_red   = red(level2.pixels[p]);
        float level1_green = green(level2.pixels[p]);
        float level1_blue  = blue(level2.pixels[p]);

        // extract color values from the second level
        float level2_red   = red(level3.pixels[p]);
        float level2_green = green(level3.pixels[p]);
        float level2_blue  = blue(level3.pixels[p]);

        // construct average pixel colors based on our mapped weights value
        float newred   = ( level1_red*percent_level1   + level2_red*percent_level2 ) / 2;
        float newgreen = ( level1_green*percent_level1 + level2_green*percent_level2 ) / 2;
        float newblue  = ( level1_blue*percent_level1  + level2_blue*percent_level2 ) / 2;

        // construct a new color
        color newcolor = color( newred, newgreen, newblue );

        // assign that color to this pixel
        surface.pixels[p] = newcolor;
      }

      else if (depth[p] < Threshold3 && depth[p] > Threshold4)
      {
        // map between level 1 and level 2
        float percent_level1 = map(depth[p], Threshold4, Threshold3, 0, 1); 
        float percent_level2 = 1 - percent_level1;

        // extract color values from the first level
        float level1_red   = red(level3.pixels[p]);
        float level1_green = green(level3.pixels[p]);
        float level1_blue  = blue(level3.pixels[p]);

        // extract color values from the second level
        float level2_red   = red(level4.pixels[p]);
        float level2_green = green(level4.pixels[p]);
        float level2_blue  = blue(level4.pixels[p]);

        // construct average pixel colors based on our mapped weights value
        float newred   = ( level1_red*percent_level1   + level2_red*percent_level2 ) / 2;
        float newgreen = ( level1_green*percent_level1 + level2_green*percent_level2 ) / 2;
        float newblue  = ( level1_blue*percent_level1  + level2_blue*percent_level2 ) / 2;

        // construct a new color
        color newcolor = color( newred, newgreen, newblue );

        // assign that color to this pixel
        surface.pixels[p] = newcolor;
      }

      // all else fails -- do this        
      else
      {
        surface.pixels[p] = level1.pixels[p];
      }
    }
  }
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------
void setupAudio() {

  //initialize Audio
  audioSys = JOALUtil.getInstance();
  listener=audioSys.getListener();

  sound = new AudioSource[1];

  sound[0]=audioSys.generateSourceFromFile(dataPath("WIND1_11.wav"));
  sound[0].setPosition(300, 0, 0); 
  sound[0].setReferenceDistance(20);

  sound[0].setLooping(true);
  sound[0].play();


  for (int g = 0; g < sound.length; g++) {
    sound[g].play();
  }
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------
void enableAudio() {
  //enableAudio needs getDeepestDepth() declared

  listener.setPosition(getDeepestDepth()-450, 0, 0);
  println(getDeepestDepth());
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------
float getDeepestDepth() {
  //getDeepestDepth is for audio or anything that needs to change based on deepest depth, not pixel by pixel

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

      returnValue = deepestdepth;
    }
  }


  return returnValue;
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------

void enableMask() {
  enableMask = true;
}



//------------------------------------------------------------------------------------------------------------------------------------------------------------------


void mouseClicked() {
  int p = mouseX + (640 * mouseY);

  println(depth[p]);
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------


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


  println("Level 1:" + Threshold1 + " , Level 2: " + Threshold2 + " ,Level 3:" + Threshold3 + " , Level 4 " + Threshold4 + " , Level 5 " + Threshold5);
}

//---------------------------------------------------------------------------------------

// This makes new attractors
void makeSpot () {

  int[] depth = kinect.getRawDepth();

  int allX = 0;
  int allY = 0;
  int all = 0;

  int pointX; 
  int pointY; 

  for (int x = 0; x < w; x ++) {
    for (int y = 0; y < h; y ++) {
      int offset = x + y * w;
      //int offset = w-x-1+y*w;
      int rawDepth = depth[offset];
      //  if (depth == null) return;
      if (rawDepth < backThreshold) {
      //if (rawDepth < Threshold5) {  
        allX += x;
        allY += y;
        all++;
      }
    }
  }

  if (all != 0) {
    //fingerX and fingerY are the location of the new attractors
    fingerX = allX / all;
    fingerY =  allY / all;

    if (dist(lastX, lastY, fingerX, fingerY) > distanceApart) {
      lastX = fingerX;
      lastY = fingerY;

      asystems.add(new AttractorSystem(new Vec2D(lastX, lastY)));

      oktoplace = false; 
      counter++;
    }
  }
}



//------------------------------------------------------------------------------------------------------------------------------------------------------------------


void stop () {

  kinect.quit();
}

