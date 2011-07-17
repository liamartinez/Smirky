// Simple Finger System
// Daniel Shiffman <http://www.shiffman.net>

// A simple Finger class

class Finger {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  
  float mass;    // Mass, tied to size
  float G;       // Gravitational Constant


Finger (PVector l_,float m_, float g_) {
    loc = l_.get();
    mass = m_;
    G = g_;
     timer = 1000.0;
//    drag = new PVector(0.0,0.0);
  }

  void go() {
    render();
     timer();

  }
  
  
   PVector calcGravForce(Smirky t) {
    PVector dir = PVector.sub(loc,t.getLoc());        // Calculate direction of force
    float d = dir.mag();                              // Distance between objects
    d = constrain(d,20.0,43.0);                        // Limiting the distance to eliminate "extreme" results for very close or very far objects
    dir.normalize();                                  // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    float force = (G * mass * t.getMass()) / (d * d); // Calculate gravitional force magnitude
    dir.mult(force);                                  // Get force vector --> magnitude * direction
    return dir;
  }

  // Method to display
  void render() {
    ellipseMode(CENTER);
    stroke(0);
    fill (100); 
    ellipse(loc.x,loc.y,mass*2,mass*2);
  }



  void timer() {
    timer -= 1.0;
  }


  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } 
    else {
      return false;
    }

}
}


