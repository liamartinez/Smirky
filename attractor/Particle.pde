// class Spore extends the class "VerletSmirky2D"
class Smirky extends VerletParticle2D {

  float r;
  float smirkyStrength = -0.001; 

  Smirky (Vec2D loc) {
    super(loc);
    r = 4;
    
    //this is to add repulsion behavior
     physics.addParticle(this);
     physics.addBehavior(new AttractionBehavior(this, 20, -1.2f, 0.01f));

  }

  void display () {
    fill (175);
    stroke (0);
    ellipse (x, y, r*2, r*2);
  }
}

