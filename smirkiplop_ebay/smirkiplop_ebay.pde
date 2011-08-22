//temp
float helloDist; 
float smirkyDist; 
int distanceToChange = 30; 

//to calculate dist
Vec2D locationAttractor;
Vec2D locationSmirky; 
float distance; 

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

//PImage greenbug; 

PImage depthDataImg;
PImage blurredDepthImg;

//Threshholds
int Threshold0; 
int Threshold1 = 830; 
int Threshold2 = 815;
int Threshold3 = 805;
int Threshold4 = 800;
int Threshold5 = 790;

//SoundThreshholds
int SoundThresh = 300; 
int SoundListener = 30;
int SoundThresh2 = 400;
int SoundListener2 = 100;

//SmirkyLimits
int SmirkyStartX = 212; 
int SmirkyEndX = 476; 
int SmirkyStartY = 139; 
int SmirkyEndY = 359; 

int[] depth;

boolean enableMask = false; 
float returnValue;

//Smirkies
ArrayList<Smirky> Smirkys;
PImage [] smirkyPics = new PImage [12];

//number of smirkies
int numSmirkies = 50; 

//Rocks
ArrayList<Rock> Rocks;

//number of rocks
int numRocks = 20; 

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
  println (" "); 
  println (" "); 
  println ("... be patient this step takes a while ... ");
  println (" :-) ");


  //initialize Kinect
  kinect = new Kinect(this);
  kinect.start();
  kinect.processDepthImage(true);
  //kinect.enableRGB(true); //if you want picture


    //----------- the following is for the background and the audio -----------//

  setupAudio();     //disable this if you dont want audio

  level4 = loadImage("LVL4HELL.png");
  level3 = loadImage("LVL3GEMS2.png");
  level2 = loadImage("LV2Sand.png");
  level1 = loadImage("LVL1moon.png");

  imgMask = loadImage ("mask_white2.jpg"); 
  imgMaskAlpha = loadImage ("mask_black.jpg"); 
  imgMask.loadPixels();
  imgMaskAlpha.loadPixels(); 
  imgMaskAlpha.mask(imgMask);

  surface = new PImage(width, height);

  //----------- the following is for the Smirkies and the Attractors ---------//

  smirkyPics[0] = loadImage ("doods/blueDOOD.png");
  smirkyPics[1] = loadImage ("doods/green_YELLOWeyed_DOOD.png");
  smirkyPics[2] = loadImage ("doods/greenDOOD.png");
  smirkyPics[3] = loadImage ("doods/greenestDOOD.png");
  smirkyPics[4] = loadImage ("doods/lightGREEN_DOOD.png");
  smirkyPics[5] = loadImage ("doods/pinkDOOD.png");
  smirkyPics[6] = loadImage ("doods/purpleDOOD.png");
  smirkyPics[7] = loadImage ("doods/redDOOD.png");
  smirkyPics[8] = loadImage ("doods/tealDOOD.png");
  smirkyPics[9] = loadImage ("doods/tealDOOD2.png");
  smirkyPics[10] = loadImage ("doods/yellowDOOD.png");
  smirkyPics[11] = loadImage ("doods/yellowDOOD2.png");

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
  
    Rocks = new ArrayList<Rock>();
  for (int i = 0; i < numRocks; i++) {
    Rocks.add(new Rock(new Vec2D(random(width), random(height))));
  }
}

//----------------------------------------------------------------------------------------------------------------

void draw() { 

  //----------- the following is for the background and the audio -----------//

  depth = kinect.getRawDepth();
  background(0);

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
    p.isSmirkyNear(locationAttractor); 
  }
  
  /*
  //rocks
    for (Rock r: Rocks) {
    r.display();
    //p.update (locationAttractor); 
    r.isRockNear(locationAttractor); 
  }
  */

  // ... this one calls the Attractors
  for (int i = asystems.size()-1; i >= 0; i--) {
    AttractorSystem asys = (AttractorSystem) asystems.get(i);
    asys.run();
    asys.getAttLocation();
    locationAttractor = asys.getAttLocation();
    
  }
  
  //remove this if you dont want to use a mask
  image (imgMaskAlpha, 0,0); 
}



//------------------------------------------------------------------------------------------------------------------------------------------------------------------


void mouseClicked() {
  int p = mouseX + (640 * mouseY);
  println ("mouse location: " + mouseX + ", " +  mouseY); 
  println("depth " + depth[p]);
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------


public void keyPressed() {


  if (key == 'q') {
    Threshold1--;
  } 
  else if (key == 'w') {
    Threshold1++;
  }
  if (key == 's') {
    SoundThresh--;
  }
  else if (key == 'd') {
    SoundThresh++;
  }
  if (key =='x') {
    SoundListener++;
  }
  else if (key == 'c') 
  {
    SoundListener--;
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

  println ("Level 1:" + Threshold1 + " , Level 2: " + Threshold2 + " ,Level 3:" + Threshold3 + " , Level 4 " + Threshold4 + " , Level 5 " + Threshold5  );
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------


void stop () {

  kinect.quit();
}
