class Blanket {
  ArrayList<Particle> particles;
  ArrayList<Connection> springs;

  PVector loc;
  PVector vel;
  PVector acc;
  float mass;
  float max_vel;
  float bounce = .5; // How "elastic" is the object

  Blanket(PVector a, PVector v, PVector l, float m_) {
    particles = new ArrayList<Particle>();
    springs = new ArrayList<Connection>();

    int w = 20;
    int h = 20;

    float len = 10;
    float strength = 0.125;
    
    acc = a.get();
    vel = v.get();
    loc = l.get();
    mass = m_;
    max_vel = .8;

    for (int y=0; y< h; y++) {
      for (int x=0; x < w; x++) {

        Particle p = new Particle(new Vec2D(100+x*len, y*len));
        //physics.addParticle(p);
        particles.add(p);

        if (x > 0) {
          Particle previous = particles.get(particles.size()-2);
          Connection c = new Connection(p, previous, len, strength);
          //physics.addSpring(c);
          springs.add(c);
        }

        if (y > 0) {
          Particle above = particles.get(particles.size()-w-1);
          Connection c=new Connection(p, above, len, strength);
          //physics.addSpring(c);
          springs.add(c);
        }
      }
    }


    
    Particle topleft= particles.get(int(loc.x));
    topleft.lock();


    Particle topright = particles.get(int(loc.y));
    topright.lock();
    
    
    
  }

  void display() {
    for (Connection c : springs) {
      c.display();
    }
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

  // Method to update location
  void update() {
    vel.add(acc);
    vel.limit(max_vel);
    loc.add(vel);
    // Multiplying by 0 sets the all the components to 0
    acc.mult(0);
  }  
}

