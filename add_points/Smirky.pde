// Attraction
// Daniel Shiffman <http://www.shiffman.net>

// A class to describe a Smirky in our world, has vectors for location, velocity, and acceleration
// Also includes scalar values for mass, maximum velocity, and elasticity

class Smirky {
  PVector loc;
  PVector vel;
  PVector acc;
  float mass;
  float max_vel;
  float bounce = .5; // How "elastic" is the object
    
  Smirky(PVector a, PVector v, PVector l, float m_) {
    acc = a.get();
    vel = v.get();
    loc = l.get();
    mass = m_;
    max_vel = .8;
  }
  
  PVector getLoc() {
    return loc;
  }

  PVector getVel() {
    return vel;
  }
  float getMass() {
    return mass;
  }

  void applyForce(PVector force) {
    force.div(mass);
    acc.add(force);   
  }

  // Main method to operate object
  void go() {
    update();
    render();
    
    
  }
  
  // Method to update location
  void update() {
    vel.add(acc);
    vel.limit(max_vel);
    loc.add(vel);
    // Multiplying by 0 sets the all the components to 0
    acc.mult(0);
  }
  
  // Method to display
  void render() {
    ellipseMode(CENTER);
    stroke (0); 
    fill(random (100, 130), random (100, 130), random (100, 130), 100);
    ellipse(loc.x,loc.y,mass,mass);

  }
}


