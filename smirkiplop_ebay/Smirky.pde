class Smirky extends VerletParticle2D {

  float r;
  float ro; 
  float smirkyStrength = -0.001; 
  Vec2D direction; 
  float smirkySize; 

  Smirky (Vec2D loc) {
    super(loc);
    r = 13;
    //this is to add repulsion behavior
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, 20, -1.2f, 0.2f));
  }

  void display () {
    fill (175);
    stroke (0);
    pushMatrix();
    translate(x, y);
    println (x + ", " + y); 
    image (greenbug, 0, 0, smirkySize, smirkySize); 


    popMatrix();
  }

  void isSmirkyNear(ReadonlyVec2D attloc) {
    float smirkyDist = this.distanceTo(attloc);
    println ("smirkyDist " + smirkyDist); 

    if (smirkyDist < 100) {
      smirkySize = map (smirkyDist, 0, 100, 0, 50);   

      println ("smirkySize" + smirkySize) ;
    } 
    else {
      smirkySize = 50;
    }
  }
}

