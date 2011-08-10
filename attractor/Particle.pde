// class Spore extends the class "VerletParticle2D"
class Particle extends VerletParticle2D {

  float r;
  float smirkyStrength = 0; 

  Particle (Vec2D loc) {
    super(loc);
    r = 4;
    //this is to add repulsion behavior
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, width, smirkyStrength));
  }

  void display () {
    fill (175);
    stroke (0);
    ellipse (x, y, r*2, r*2);
  }

  float getSmirkyStrength() {
    return smirkyStrength;
  }

  void setSmirkyStrength(float sS) {
    smirkyStrength =  sS;
  }
}

