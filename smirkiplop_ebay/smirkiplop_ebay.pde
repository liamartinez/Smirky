
//Kinect
import org.openkinect.*;
import org.openkinect.processing.*;
Kinect kinect;

//Toxi
import toxi.audio.*;
import toxi.geom.*;

//Audio
AudioSource sound[];
SoundListener listener;
JOALUtil audioSys;

// Size of kinect image
int w = 640;
int h = 480;

PImage level1;
PImage level2;
PImage level3;
PImage level4;
PImage imgMask; 
PImage surface;

PImage depthDataImg;
PImage blurredDepthImg;

int Threshold0; 
int Threshold1 = 790; 
int Threshold2 = 780;
int Threshold3 = 770;
int Threshold4 = 660;
int Threshold5 = 350;

int[] depth;

boolean enableMask = false; 


float returnValue;




//----------------------------------------------------------------------------------------------------------

void setup() {

  size(w, h, P2D);



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


  setupAudio();     //disable this if you dont want audio



    level4 = loadImage("LVL4HELL.png");
  level3 = loadImage("LVL3GEMS2.png");
  level2 = loadImage("LV2Sand.png");
  level1 = loadImage("LVL1moon.png");

  imgMask = loadImage ("newmask2.jpg"); 
  imgMask.loadPixels();



  surface = new PImage(640, 480);
}




//----------------------------------------------------------------------------------------------------------------




void draw() { 

  depth = kinect.getRawDepth();
  background(0);


  enableMask(); //remove this if you dont want to use a mask
  drawSurface(); //the original without blending
  drawSurfaceBlended(); //with blending

  //getDeepestDepth(); //get the deepest depth based on a narrow area in the middle
  enableAudio(); //remember to enable setupAudio() in the setup 


  image (surface, 0, 0); //draw the surface
}













// next on to do list: make a function for blur


//blurring the kinect data : enable this if needed      
/*
   blurredDepthImg = new PImage( 640, 480 );
 System.arraycopy( kinect.getDepthImage().pixels, 0, blurredDepthImg.pixels, 0, kinect.getDepthImage().pixels.length );
 fastblur( blurredDepthImg, 15 ); // change the last number for the radius of the blur
 */


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

  sound = new AudioSource[2];

  sound[0]=audioSys.generateSourceFromFile(dataPath("smirky_conversation.wav"));
  sound[0].setPosition(300, 0, 0); 
  sound[0].setReferenceDistance(10);

  sound[0].setLooping(true);
  sound[0].play();

  sound[1]=audioSys.generateSourceFromFile(dataPath("smirkyFLY.wav"));
  sound[1].setPosition(225, 0, 0); 
  sound[1].setReferenceDistance(5);

  sound[1].setLooping(true);
  sound[1].play();


  for (int g = 0; g < sound.length; g++) {
      sound[g].play();
  }
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------
void enableAudio() {

  //enableAudio needs getDeepestDepth() declared



  /* //need loop?
   for (int x = 0; x < 640; x++) {
   for (int y = 0; y < 480; y++) {  
   */
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

  /* //this doesnt work; fix
   averagedepth = averagedepth / numpoints; 
   println ("average " + averagedepth);
   println ("numpoint " + numpoints);
   println ("deepest " + deepestdepth);
   
   */


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


//------------------------------------------------------------------------------------------------------------------------------------------------------------------

void fastblur(PImage img, int radius) {
  if (radius<1) {
    return;
  }
  img.loadPixels();
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum, gsum, bsum, x, y, i, p, p1, p2, yp, yi, yw;
  int vmin[] = new int[max(w, h)];
  int vmax[] = new int[max(w, h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++) {
    dv[i]=(i/div);
  }
  yw=yi=0;
  for (y=0;y<h;y++) {
    rsum=gsum=bsum=0;
    for (i=-radius;i<=radius;i++) {
      p=pix[yi+min(wm, max(i, 0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++) {
      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];
      if (y==0) {
        vmin[x]=min(x+radius+1, wm);
        vmax[x]=max(x-radius, 0);
      } 
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];
      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }
  for (x=0;x<w;x++) {
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for (i=-radius;i<=radius;i++) {
      yi=max(0, yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++) {
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if (x==0) {
        vmin[y]=min(y+radius+1, hm)*w;
        vmax[y]=max(y-radius, 0)*w;
      } 
      p1=x+vmin[y];
      p2=x+vmax[y];
      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];
      yi+=w;
    }
  }
  img.updatePixels();
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------

void stop () {

  kinect.quit();
}

