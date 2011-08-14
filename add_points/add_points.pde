////////// Smirkiplops for Comp Cameras////////
////////// Will "brother may" Jennings & Lia "sister may" Martinez///////

import toxi.physics2d.behaviors.*;
import toxi.physics2d.*;


import toxi.geom.*;
import toxi.math.*;

VerletPhysics2D physics;
VerletParticle2D selected=null;

// squared snap distance for picking particles
float snapDist=10*10;

import org.openkinect.processing.Kinect;


Kinect kinect;

int w = 640;
int h = 480;

int depthXPicOffset = 30;
int depthYPicOffset = 30;


//these offsets change the range for creating attractors
int frontThreshold = 500;
int backThreshold = 550;

int fingerX; 
int fingerY; 
boolean oktoplace = true; 
int lastX;
int lastY;
int distanceApart = 20; 


ArrayList psystems;

int counter = 0; 

///maximum smirkys
int MAX = 20;
Smirky[] t = new Smirky[MAX];
Blanket[] b = new Blanket[2]; 

boolean showVectors = false;
boolean returnValue = false; 



void setup() {
  size(w, h, P2D);
  psystems = new ArrayList();



  //kinect 
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  kinect.enableRGB(true);
  kinect.processDepthImage(false);

  smooth();

  physics=new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.1)));
  physics.setWorldBounds(new Rect(0, 0, width, height));


  //PImage kinect = kinect.getVideoImage();

  // introduce the smirkys

  for (int i = 0; i < t.length; i++) {
    PVector ac = new PVector(0.0, 0.0);
    PVector ve = new PVector(random(-.5, 5.), random(-.5, .5));
    PVector lo = new PVector(random(width), random(height));
    t[i] = new Smirky(ac, ve, lo, random(8, 16));
  }
  
    for (int i = 0; i < b.length; i++) {
    PVector ac = new PVector(0.0, 0.0);
    PVector ve = new PVector(random(-.5, 5.), random(-.5, .5));
    PVector lo = new PVector(random(width), random(height));
    b[i] = new Blanket(ac, ve, lo, random(8, 16));
  }
  
  
  
}


//show vectors or not
void keyPressed() {
  showVectors = !showVectors;
}


///////////////////////////////// DRAW /////////////////////////////////////////
void draw() {

  image(kinect.getVideoImage(), 0, 0);
  // background(255);
  /////kinect///
  loadPixels();

  //this detects if something is between front and back threshold
  fingerDown(); 

  //this makes attractors in the areas  
  makeSpot (); 
  updatePixels();


  // Cycle through all Finger systems, run them and delete old ones
  for (int i = psystems.size()-1; i >= 0; i--) {
    ParticleSystem psys = (ParticleSystem) psystems.get(i);
    psys.smirkys();
    psys.run();
    if (psys.dead()) {
      psystems.remove(i);
    }
  }

  for (int q = 0; q < t.length; q++) {
    t[q].go();
  }
  
    for (int q = 0; q < b.length; q++) {
    physics.update();
    b[q].display();
  }
  
}


////////////////////////// END DRAW ////////////////////////////////////////////////////

// When the mouse is pressed, add a new Finger system
//void mousePressed() {
//  psystems.add(new ParticleSystem(int(random(1,5)),new PVector(mouseX,mouseY)));
//}

//void mousePressed() {
//  psystems.add(new ParticleSystem(int(random(1,5)),new PVector(mouseX,mouseY)));
//}


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
      int rawDepth = depth[offset];
      //  if (depth == null) return;
      if (rawDepth < backThreshold) {
        allX += x;
        allY += y;
        all++;
      }
    }
  }

  //fingerX and fingerY are the location of the new attractors
  fingerX = width - allX / all;
  fingerY =  allY / all;

  if (all != 0) {

    if (dist(lastX, lastY, fingerX, fingerY) > distanceApart) {
      lastX = fingerX;
      lastY = fingerY;

      psystems.add(new ParticleSystem(int(random(1, 5)), new PVector(width-fingerX, fingerY)));

      oktoplace = false; 
      counter++; 

      println ("counter " + counter);
    }
  }


  println ("FingerX = " + fingerX + " FingerY= " + fingerY);
}


// check all particles if mouse pos is less than snap distance
void mousePressed() {
  selected=null;
  Vec2D mousePos=new Vec2D(mouseX, mouseY);
  for (Iterator i=physics.particles.iterator(); i.hasNext();) {
    VerletParticle2D p=(VerletParticle2D)i.next();
    // if mouse is close enough, keep a reference to
    // the selected particle and lock it (becomes unmovable by physics)
    if (p.distanceToSquared(mousePos)<snapDist) {
      selected=p;
      selected.lock();
      break;
    }
  }
}

// only react to mouse dragging events if we have a selected particle
void mouseDragged() {
  if (selected!=null) {
    selected.set(mouseX, mouseY);
  }
}

// if we had a selected particle unlock it again and kill reference
void mouseReleased() {
  if (selected!=null) {
    selected.unlock();
    selected=null;
  }
}
//////stop kinect///////
public void stop() {
  kinect.quit();
  super.stop();
}

