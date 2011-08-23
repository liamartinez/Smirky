void setupAudio() {

  //initialize Audio
  audioSys = JOALUtil.getInstance();
  listener=audioSys.getListener();

   sound = new AudioSource[1];

  sound[0]=audioSys.generateSourceFromFile(dataPath("smirkyFLY.wav"));
  sound[0].setPosition(375, 0, 0); 
  sound[0].setReferenceDistance(5);

  sound[0].setLooping(true);
  sound[0].play();

//    sound[1]=audioSys.generateSourceFromFile(dataPath("smirkyFLY.wav"));
//    sound[1].setPosition(380, 0, 30); 
//    sound[1].setReferenceDistance(42);
//  
//    sound[1].setLooping(true);
//    sound[1].play();

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

  //for (int x = 300; x < 350; x++) {
  // for (int y = 200; y < 250; y++) {
  for (int x = SmirkyStartX; x < SmirkyEndX; x ++) {
    for (int y = SmirkyStartY; y < SmirkyEndY; y ++) { 
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

