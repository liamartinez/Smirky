// class Spore extends the class "VerletParticle2D"
class Particle extends VerletParticle2D {

  float r;

  Particle (Vec2D loc) {
    super(loc);
    r = 4;
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, width, .0001,2));
  }

  void display () {
    fill (175);
    stroke (0);
    ellipse (x, y, r*2, r*2);
  }
}

