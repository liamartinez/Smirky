class ParticleSystem {

  ArrayList attractors;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are birthed
  boolean returnvalue; 

  ParticleSystem(Vec2D v) {
    attractors = new ArrayList();              // Initialize the arraylist
    //origin = v.get();                        // Store the origin point

      //particles.add(new Finger(origin,10,0.4)); 
    //attractors = new Attractor(new Vec2D(origin,width/2,height/2));
    attractors.add(new Attractor(new Vec2D(v)));

    
  }


  void run() {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = attractors.size()-1; i >= 0; i--) {
      Attractor a = (Attractor) attractors.get(i);
      a.display();


      if (a.dead()) {
        attractors.remove(i);
      }
    }
  }

/*
  void smirkys() {
    for (int i = attractors.size()-1; i >= 0; i--) {
      Attractor a = (Attractor) attractors.get(i);

      for (int q = 0; q < a.length; q++) {
        //    // Calculate a force exerted by "attractor" on "Smirky"
        PVector f = a.calcGravForce(t[q]);
        // Apply that force to the Smirky
        t[q].applyForce(f);
        // Update and render
      }
    }
  }
  
  */

  // test if something is nearby 
  boolean checkLocation (PVector testSmirky) {
    for (int i = attractors.size()-1; i >= 0; i--) {
      //   if (origin == attractors[].x) {
      println ("yes!"); 
      returnvalue = false;
    }
    return returnvalue;
  }


  // A method to test if the Finger system still has particles
  boolean dead() {
    if (attractors.isEmpty()) {
      return true;
    } 
    else {
      return false;
    }
  }
}

