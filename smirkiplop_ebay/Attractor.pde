class Attractor extends VerletParticle2D {


  float lifespan;
  float strength = 0.01; 
  AttractionBehavior att;

  Attractor (Vec2D loc) {
    super (loc);

    //this sets the location to lastX, lastY 
    lock();
    set(loc);

    lifespan = 2.0;

    att = new AttractionBehavior(loc, 250, 0.9f);
    physics.addBehavior(att);
  }

  void display () {
    fill(0, 5);
    ellipse (x, y, 20, 20);
  }


  //the speed which the attractor dies
  void lifespan() {
    lifespan -= .25 ;
  }

  boolean dead() {
    if (lifespan < 0.0) {
      physics.removeBehavior(att);
      return true;
    } 
    else {
      return false;
    }
  }
}



