class Attractor extends VerletParticle2D {

  float r;
  float lifespan;

  float strength = 0.01; 

  Attractor (Vec2D loc) {
    super (loc);

    //this sets the location to lastX, lastY 
    lock();
    set(loc);

    r = 24;
    lifespan = 2.0;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, width, strength));
  }

  void display () {
    fill(0, 50);
    ellipse (x, y, r*2, r*2);
    println ("REAL attractor strength is " + strength);   
    //set(x,y); 
    //ellipse (l.x, l.y, r*2, r*2);
  }


  //the speed which the attractor dies
  void lifespan() {
    lifespan -= .25 ;
  }

  float getStrength() {
    return strength;
  }

  void setStrength(float s) {
    strength =  s;
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

