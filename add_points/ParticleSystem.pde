// Simple Finger System
// Daniel Shiffman <http://www.shiffman.net>

// A class to describe a group of particles
// An ArrayList is used to manage the list of particles

class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are birthed
  boolean returnvalue; 

  ParticleSystem(int num, PVector v) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.get();                        // Store the origin point

      particles.add(new Finger(origin, 10, 0.4));
  }


  void run() {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Finger p = (Finger) particles.get(i);
      p.go();


      if (p.dead()) {
        particles.remove(i);
      }
    }
  }

  void smirkys() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Finger p = (Finger) particles.get(i);

      for (int q = 0; q < t.length; q++) {
        //    // Calculate a force exerted by "attractor" on "Smirky"
        PVector f = p.calcGravForce(t[q]);
        // Apply that force to the Smirky
        t[q].applyForce(f);
        // Update and render
      }
    }
  }

  // test if something is nearby 
  boolean checkLocation (PVector testSmirky) {
    for (int i = particles.size()-1; i >= 0; i--) {
      //   if (origin == particles[].x) {
      println ("yes!"); 
      returnvalue = false;
    }
    return returnvalue;
  }


  // A method to test if the Finger system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } 
    else {
      return false;
    }
  }
}

