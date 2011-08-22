class Rock extends VerletParticle2D {

  float smirkySize; 
  PImage smirkyPic; 


  Rock (Vec2D loc) {
    super(loc);
    
    physics.addParticle(this);
    //attractor, radius, strength, jitter
    physics.addBehavior(new AttractionBehavior(this, 3, 0.09f));
    //smirkyPic = smirkyPics[int(random(0, 2))];
  }

  void display () {
    fill (175);
    stroke (1);
    pushMatrix();
    translate(x, y);
    ellipse (0,0, smirkySize,smirkySize); 
    //image (smirkyPic, 0, 0, smirkySize, smirkySize); 
    popMatrix();
    
  }


  void isRockNear(ReadonlyVec2D attloc) {
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

