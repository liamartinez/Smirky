import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import org.openkinect.processing.Kinect;

ArrayList<Particle> particles;

//Attractor attractor;

Kinect kinect;

VerletPhysics2D physics;

ArrayList asystems;

int w = 640;
int h = 480;

int depthXPicOffset = 30;
int depthYPicOffset = 30;


//these offsets change the range for creating attractors
int frontThreshold = 440;
int backThreshold = 480;

int fingerX; 
int fingerY; 
boolean oktoplace = true; 
int lastX;
int lastY;
int distanceApart = 20; 

int counter = 0; 

boolean returnValue = false; 

//number of smirkies
int numSmirkies = 50; 

//---------------------------------------------------------------------------------------

void setup () {
  size (w, h, P2D);
  smooth();
  physics = new VerletPhysics2D ();
  physics.setDrag (0.01);

  asystems = new ArrayList();

  //kinect 
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  kinect.enableRGB(true);
  kinect.processDepthImage(false);

  physics.setWorldBounds(new Rect(0, 0, width, height));


  particles = new ArrayList<Particle>();
  for (int i = 0; i < numSmirkies; i++) {
    particles.add(new Particle(new Vec2D(random(width), random(height))));
  }
}

//---------------------------------------------------------------------------------------

void draw () {

  image(kinect.getVideoImage(), 0, 0);
  loadPixels ();

  // fingerDown() ;
  makeSpot (); 
  updatePixels();



  physics.update ();

  // attractor.display();
  for (Particle p: particles) {
    p.display();

  //debugging
  float sS = p.getSmirkyStrength();
    if (key == CODED) {
      if (keyCode == LEFT) {
        sS+=5;
        p.setSmirkyStrength(sS);
      } 
      else if (keyCode == RIGHT) {
        sS-=5;
        p.setSmirkyStrength(sS);
      }
    }
  
    println ("Smirky Strength is" + sS); 
  
  }
  

  for (int i = asystems.size()-1; i >= 0; i--) {
    AttractorSystem asys = (AttractorSystem) asystems.get(i);
    asys.run();
  }
}



//---------------------------------------------------------------------------------------

/*

 //// if hand is within frontThreshold and backThreshold, return true
 boolean fingerDown () { 
 PImage myImage = kinect.getVideoImage();
 // Get the raw depth as array of integers
 int[] depth = kinect.getRawDepth();
 // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
 int skip = 1;
 
 for (int x = 0; x < w; x += skip) {
 for (int y = 0; y < h; y += skip) {
 int offset = x + y * w;
 int rawDepth = depth[offset];
 if (rawDepth > frontThreshold && rawDepth < backThreshold) {
 returnValue = true;
 }
 }
 }
 
 return returnValue;
 }
 
 */

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

      //asystems.add(new AttractorSystem(new Vec2D(fingerX, fingerY)));
      asystems.add(new AttractorSystem(new Vec2D(lastX, lastY)));

      oktoplace = false; 
      counter++;
    }
  }
}

void quit() {
  kinect.quit();
}

