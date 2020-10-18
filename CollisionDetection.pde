Shape s[];

float speed = 2.5;

final boolean debugMode = false;
final boolean dynamicMode = true;

void setup() {
  size(1280, 720, P3D);
  
  frameRate(1000);
  PJOGL pgl = (PJOGL)beginPGL();
  pgl.gl.setSwapInterval(1);
  endPGL();
  
  s = new Shape[3];
  
  {
    float step = 360 / 5;
    PVector[] verts = new PVector[5];
    for (int i = 0; i < 5; i++) {
      verts[i] = PVector.fromAngle(radians(step * i));
    }
    
    s[0] = new Shape(true, new PVector(width / 4 * 3, height / 4 * 3), new PVector(), new PVector(75, 75), verts);
    
    println((Object[])s[0].getVerts());
  }
  
  {
    float step = 360 / 3;
    PVector[] verts = new PVector[3];
    for (int i = 0; i < 3; i++) {
      verts[i] = PVector.fromAngle(radians(step * i));
    }
    
    s[1] = new Shape(true, new PVector(width / 4, height / 4), new PVector(), new PVector(75, 75), verts);
  }
  
  {
    float step = 360 / 4;
    PVector[] verts = new PVector[4];
    for (int i = 0; i < 4; i++) {
      verts[i] = PVector.fromAngle(radians(step * i));
    }
    
    s[2] = new Shape(false, new PVector(width / 2, height / 2), new PVector(), new PVector(75, 75), verts);
  }
}

void draw() {
  surface.setTitle("Collision Detection - Treidex | FPS: " + frameRate);
  
  updateConfort();
  
  if (keys[VK_LEFT] == HELD)
    s[0].rot.z -= 2;
  if (keys[VK_RIGHT] == HELD)
    s[0].rot.z += 2;
    
  if (keys[VK_UP] == HELD)
    s[0].pos.add(PVector.fromAngle(radians(s[0].rot.z)).mult(speed));
  if (keys[VK_DOWN] == HELD)
    s[0].pos.sub(PVector.fromAngle(radians(s[0].rot.z)).mult(speed));
    
    if (keys[VK_A] == HELD)
    s[1].rot.z -= 2;
  if (keys[VK_D] == HELD)
    s[1].rot.z += 2;
    
  if (keys[VK_W] == HELD)
    s[1].pos.add(PVector.fromAngle(radians(s[1].rot.z)).mult(speed));
  if (keys[VK_S] == HELD)
    s[1].pos.sub(PVector.fromAngle(radians(s[1].rot.z)).mult(speed));
  
  background(57);
  noFill();
  boolean colliding;
  for (int sc = 0; sc < s.length; sc++) {
    colliding = false;
    for (int sc1 = (sc + 1) % s.length; sc1 != sc; sc1 = (sc1 + 1) % s.length) {
      colliding |= checkCollision(s, sc, sc1);
    }
    
    stroke(colliding ? #FF0000 : #000000);
    
    PVector[] sp = s[sc].getVerts();
    
    beginShape();
    
    for (int i = 0; i < sp.length; i++) {
      vertex(sp[i].x, sp[i].y, sp[i].z);
    }
    
    endShape(CLOSE);
  }
  
  {
    PVector front = PVector.fromAngle(radians(s[0].rot.z));
    PVector dir = PVector.mult(front, s[0].scale.x);
    stroke(0, 255, 0);
    line(s[0].pos.x, s[0].pos.y, s[0].pos.x + dir.x, s[0].pos.y + dir.y);
  }
  
  {
    PVector front = PVector.fromAngle(radians(s[1].rot.z));
    PVector dir = PVector.mult(front, s[1].scale.x);
    stroke(0, 0, 255);
    line(s[1].pos.x, s[1].pos.y, s[1].pos.x + dir.x, s[1].pos.y + dir.y);
  }
}

boolean lineIntersecting(PVector[] l1, PVector[] l2, PVector[] ptr_dist) {
  /* ---------- https://gamedev.stackexchange.com/questions/26004/how-to-detect-2d-line-on-line-collision ---------- */
  
  PVector a = l1[0];
  PVector b = l1[1];
  PVector c = l2[0];
  PVector d = l2[1];
  
  float denominator = ((b.x - a.x) * (d.y - c.y)) - ((b.y - a.y) * (d.x - c.x));
  float numerator1 = ((a.y - c.y) * (d.x - c.x)) - ((a.x - c.x) * (d.y - c.y));
  float numerator2 = ((a.y - c.y) * (b.x - a.x)) - ((a.x - c.x) * (b.y - a.y));

  ptr_dist[0] = new PVector();

  if (denominator == 0)
    return numerator1 == 0 && numerator2 == 0;

  float r = numerator1 / denominator;
  float s = numerator2 / denominator;
  
  ptr_dist[0] = new PVector((1 - r) * (b.x - a.x), (1 - r) * (b.y - a.y));

  return (r >= 0 && r <= 1) && (s >= 0 && s <= 1);
}

boolean checkCollision(Shape[] csa, int cs1, int cs2) {
  Shape s1 = csa[cs1], s2 = csa[cs2];
  
  boolean isColliding = false;
  
  for (int sc = 0; sc < 2; sc++) {
    if (sc == 1) {
      s1 = csa[cs2];
      s2 = csa[cs1];
    }
    
    PVector[] v1 = s1.getVerts();
    PVector[] v2 = s2.getVerts();
    
    for (int vc = 0; vc < v1.length; vc++) {
      PVector dis = new PVector();
      
      for (int ec = 0; ec < v2.length; ec++) {
        PVector[] ptr_dist = new PVector[1];
        boolean intersected;
        isColliding |= intersected = lineIntersecting(new PVector[] { s1.pos, v1[vc] },
          new PVector[] { v2[ec], v2[(ec + 1) % v2.length] }, ptr_dist
        );
        
        if (dynamicMode && intersected) {
          if (s1.dynamic)
            dis.add(ptr_dist[0]);
          else if (s2.dynamic)
            dis.sub(ptr_dist[0]);
        }
        
        if (debugMode) {
          line(v2[ec].x, v2[ec].y, v2[(ec + 1) % v2.length].x, v2[(ec + 1) % v2.length].y);
          line(s1.pos.x, s1.pos.y, v1[vc].x, v1[vc].y);
        }
      }
      
      if (dynamicMode) {
        if (s1.dynamic)
          s1.pos.add(PVector.mult(dis, sc == 0 ? -1 : +1));
        else if (s2.dynamic)
          s2.pos.add(PVector.mult(dis, sc == 0 ? -1 : +1));
      }
    }
  }
  
  return !dynamicMode && isColliding;
}
