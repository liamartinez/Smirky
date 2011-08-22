
// This makes new attractors
void makeSpot () {

  int[] depth = kinect.getRawDepth();

  int allX = 0;
  int allY = 0;
  int all = 0;

  int pointX; 
  int pointY;


  for (int x = SmirkyStartX; x < SmirkyEndX; x ++) {
    for (int y = SmirkyStartY; y < SmirkyEndY; y ++) { 
      int offset = x + y * w;
      //int offset = w-x-1+y*w;
      int rawDepth = depth[offset];
      if (depth == null) return;
      //if (rawDepth < backThreshold) {
      if (rawDepth < Threshold3) {  
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

