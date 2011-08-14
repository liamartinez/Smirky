/**
 * <p>This example demonstrates how to use the behavior handling
 * (new since toxiclibs-0020 release) and specifically the attraction
 * behavior to create forces around the current locations of particles
 * in order to attract (or deflect) other particles nearby.</p>
 *
 * <p>Behaviors can be added and removed dynamically on both a
 * global level (for the entire physics simulation) as well as for
 * individual particles only.</p>
 * 
 * <p>Usage: Click and drag mouse to attract particles</p>
 */


 
import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

int NUM_PARTICLES = 750;

VerletPhysics2D physics;
AttractionBehavior mouseAttractor;

Vec2D mousePos;

void setup() {
  size(680, 382,P3D);
  // setup physics with 10% drag
  physics = new VerletPhysics2D();
  physics.setDrag(0.05f);
  physics.setWorldBounds(new Rect(0, 0, width, height));
  // the NEW way to add gravity to the simulation, using behaviors
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.15f)));
}

void addParticle() {
  VerletParticle2D p = new VerletParticle2D(Vec2D.randomVector().scale(5).addSelf(width / 2, 0));
  physics.addParticle(p);
  // add a negative attraction force field around the new particle
  physics.addBehavior(new AttractionBehavior(p, 20, -1.2f, 0.01f));
}

void draw() {
  background(255,0,0);
  noStroke();
  fill(255);
  if (physics.particles.size() < NUM_PARTICLES) {
    addParticle();
  }
  physics.update();
  for (VerletParticle2D p : physics.particles) {
    ellipse(p.x, p.y, 5, 5);
  }
}

void mousePressed() {
  mousePos = new Vec2D(mouseX, mouseY);
  // create a new positive attraction force field around the mouse position (radius=250px)
  mouseAttractor = new AttractionBehavior(mousePos, 250, 0.9f);
  physics.addBehavior(mouseAttractor);
}

void mouseDragged() {
  // update mouse attraction focal point
  mousePos.set(mouseX, mouseY);
}

void mouseReleased() {
  // remove the mouse attraction when button has been released
  physics.removeBehavior(mouseAttractor);
}

