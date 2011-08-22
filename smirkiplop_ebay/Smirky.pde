class Smirky extends VerletParticle2D {

  float smirkySize; 
  PImage smirkyPic; 


  Smirky (Vec2D loc) {
    super(loc);
    
    physics.addParticle(this);
    //attractor, radius, strength, jitter
    physics.addBehavior(new AttractionBehavior(this, 20, -1.9f, 0.1f));
    smirkyPic = smirkyPics[int(random(0, 12))];
  }

  void display () {
    fill (175);
    stroke (0);
    pushMatrix();
    translate(x, y);
    image (smirkyPic, 0, 0, smirkySize, smirkySize); 
    popMatrix();
    
  }


  void isSmirkyNear(ReadonlyVec2D attloc) {
    float smirkyDist = this.distanceTo(attloc);
    println ("smirkyDist " + smirkyDist); 
    if (smirkyDist < 100) {
      smirkySize = map (smirkyDist, 0, 100, 0, 30);   
      println ("smirkySize" + smirkySize) ;
    } 
    else {
      smirkySize = 30;
    }
  }
}

