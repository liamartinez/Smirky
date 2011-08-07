class Attractor extends VerletParticle2D {

  float r;
  float lifespan;


  Attractor (Vec2D loc) {
    super (loc);
 
    lock();
    set(loc);
 
    r = 24;
    lifespan = 2.0;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, width, .1));
  }

  void display () {
    fill(0,50);
    ellipse (x, y, r*2, r*2);
    //set(x,y); 
    //ellipse (l.x, l.y, r*2, r*2);
  }

  void lifespan() {
    lifespan -= .25 ;
  }
  
  

  boolean dead() {
    if (lifespan < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}

