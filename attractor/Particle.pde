// class Spore extends the class "VerletParticle2D"
class Particle extends VerletParticle2D {

  float r;
  float smirkyStrength = -0.001; 

  Particle (Vec2D loc) {
    super(loc);
    r = 4;

    /*
    VerletParticle2D p = new VerletParticle2D(Vec2D.randomVector().scale(5).addSelf(width / 2, 0));
    physics.addParticle(p);
    // add a negative attraction force field around the new particle
    physics.addBehavior(new AttractionBehavior(p, 20, -1.2f, 0.01f));
    */
    
    

    
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

