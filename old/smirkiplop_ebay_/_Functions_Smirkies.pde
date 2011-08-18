
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
      if (rawDepth < Threshold4) {  
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


float whereSmirky () {
  for (Smirky p: Smirkys) {
    for (int i = asystems.size()-1; i >= 0; i--) {
      AttractorSystem asys = (AttractorSystem) asystems.get(i);
      locationSmirky = p.getPreviousPosition();
      locationAttractor = asys.getAttLocation();
      helloDist = dist(locationSmirky.x, locationAttractor.x, locationSmirky.y, locationAttractor.y );
      
      if (helloDist < distanceToChange) {
      smirkyDist = map (helloDist, 0, 30, 25, 5); 
      }

      
      println ("hooray! smirkydist is " + smirkyDist);
    }
  }
  
  return smirkyDist; 

}






