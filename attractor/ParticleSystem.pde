class ParticleSystem {

  ArrayList attractors;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are birthed
  boolean returnvalue; 

  ParticleSystem(Vec2D v) {
    attractors = new ArrayList();              // Initialize the arraylist
    attractors.add(new Attractor(new Vec2D(v)));

    
  }


  void run() {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = attractors.size()-1; i >= 0; i--) {
      Attractor a = (Attractor) attractors.get(i);
      a.display();
      a.lifespan(); 
      if (a.dead()) {
        attractors.remove(i);
      }
    }
  }





  // test if something is nearby 
  boolean checkLocation (PVector testSmirky) {
    for (int i = attractors.size()-1; i >= 0; i--) {
      //   if (origin == attractors[].x) {
      println ("yes!"); 
      returnvalue = false;
    }
    return returnvalue;
  }


/*
  boolean dead() {
    if (attractors.isEmpty()) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  */
  

}

