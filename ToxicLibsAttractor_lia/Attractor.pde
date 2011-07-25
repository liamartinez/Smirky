class Attractor extends VerletParticle2D {

  float r;
  float timer;


  Attractor (Vec2D loc) {
    super (loc);
 
    r = 24;
    timer = 5.0;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, width, 0.1));
  }

  void display () {
    fill(0,50);
    ellipse (x, y, r*2, r*2);
    //set(x,y); 
    //ellipse (l.x, l.y, r*2, r*2);
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

