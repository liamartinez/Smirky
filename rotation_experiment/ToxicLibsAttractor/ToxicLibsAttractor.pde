import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

ArrayList<Smirky> Smirkys;
Attractor attractor;

VerletPhysics2D physics;

PImage greenbug; 




void setup () {


  size (400, 400);
  smooth();
  physics = new VerletPhysics2D ();
  physics.setDrag (0.01);
  greenbug = loadImage ("bug1_green.png"); 

  Smirkys = new ArrayList<Smirky>();
  for (int i = 0; i < 50; i++) {
    Smirkys.add(new Smirky(new Vec2D(random(width), random(height))));
  }

  attractor = new Attractor(new Vec2D(width/2, height/2));
}


void draw () {
  background (255);  
  physics.update ();

  attractor.display();
  for (Smirky p: Smirkys) {
    p.display();
  }
  if (mousePressed) {
    attractor.lock();
    attractor.set(mouseX, mouseY);
  } 
  else {
    attractor.unlock();
  }
}

