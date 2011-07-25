/**
 * This example is adapted from Karsten Schmidt's SoftBodySquare example
 * Daniel Shiffman, 2011
 * The Nature of Code book
 */

/* <p>Softbody square demo is showing how to create a 2D square mesh out of
 * verlet particles and make it stable enough to avoid total structural
 * deformation by including an inner skeleton.</p>
 *
 * <p>Usage: move mouse to drag/deform the square</p>
 */

/* 
 * Copyright (c) 2008-2009 Karsten Schmidt
 * 
 * This demo & library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

<<<<<<< HEAD

=======
>>>>>>> d28d0b830f76d8d0cc24708d0fb8cfbeda39ea87
import toxi.physics2d.behaviors.*;
import toxi.physics2d.*;

import toxi.geom.*;
import toxi.math.*;

VerletPhysics2D physics;
<<<<<<< HEAD
=======
VerletParticle2D selected=null;

// squared snap distance for picking particles
float snapDist=10*10;
>>>>>>> d28d0b830f76d8d0cc24708d0fb8cfbeda39ea87

Blanket b;


void setup() {
<<<<<<< HEAD
  size(400,300);
  smooth();
  physics=new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0,0.1)));
=======
  size(800,600 );
  smooth();
  physics=new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0,0.1)));
  physics.setWorldBounds(new Rect(0,0,width,height));
>>>>>>> d28d0b830f76d8d0cc24708d0fb8cfbeda39ea87

  b = new Blanket();
}

void draw() {

  background(255);

  physics.update();

  b.display();
}

<<<<<<< HEAD
=======

// check all particles if mouse pos is less than snap distance
void mousePressed() {
  selected=null;
  Vec2D mousePos=new Vec2D(mouseX,mouseY);
  for(Iterator i=physics.particles.iterator(); i.hasNext();) {
    VerletParticle2D p=(VerletParticle2D)i.next();
    // if mouse is close enough, keep a reference to
    // the selected particle and lock it (becomes unmovable by physics)
    if (p.distanceToSquared(mousePos)<snapDist) {
      selected=p;
      selected.lock();
      break;
    }
  }
}

// only react to mouse dragging events if we have a selected particle
void mouseDragged() {
  if (selected!=null) {
    selected.set(mouseX,mouseY);
  }
}

// if we had a selected particle unlock it again and kill reference
void mouseReleased() {
  if (selected!=null) {
    selected.unlock();
    selected=null;
  }
}
>>>>>>> d28d0b830f76d8d0cc24708d0fb8cfbeda39ea87
