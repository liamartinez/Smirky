class Smirky extends VerletParticle2D {

  float r;
  float ro; 
  float smirkyStrength = -0.001; 
  Vec2D direction; 
  float smirkySize; 
  Vec2D attloc; 

  Smirky (Vec2D loc, Vec2D attloc_ ) {
    super(loc);
    attloc = attloc_; 
    r = 13;
    //println ("location " + loc); 
    //ro = 0; 
    //ro = cos(0.1);
    //direction = Vec2D.randomVector();
    //smirkySize = smirkySize_; 
    
    
    //this is to add repulsion behavior
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior(this, 20, -1.2f, 0.2f));
  }

  void display () {
    fill (175);
    stroke (0);
    println ("yo" + smirkyDist); 
    //setRadius (smirkyDist); 
    pushMatrix();
    translate(x, y);
    //ellipse (x, y, r*2, r*2);
    
    
    //imageMode (CENTER); 
    image (greenbug, 0, 0, r*2, r*2); 
    //direction.rotate(radians(random(-30, 30))); 
    
    popMatrix();
    

  }
}

