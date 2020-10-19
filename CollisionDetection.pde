Shape s[];

float speed = 2.5;

final boolean debugMode = false;
final boolean dynamicMode = true;

int po0, po1, po2;

void setup() {
  size(1280, 720, P3D);

  frameRate(1000);
  PJOGL pgl = (PJOGL)beginPGL();
  pgl.gl.setSwapInterval(1);
  endPGL();

  s = new Shape[3];

  {
    float step = 360 / 3;
    PVector[] verts = new PVector[3];
    for (int i = 0; i < 3; i++) {
      verts[i] = PVector.fromAngle(radians(step * i));
    }

    s[0] = new Shape(true, new PVector(width / 4, height / 4), new PVector(), new PVector(75, 75), verts, new int[][] {
      { 0, 1 },
      { 1, 2 },
      { 0, 1, 2}
    });
    
    po0 = attachPhysics(s, 0);
  }

  {
    float step = 360 / 5;
    PVector[] verts = new PVector[5];
    for (int i = 0; i < 5; i++) {
      verts[i] = PVector.fromAngle(radians(step * i));
    }

    s[1] = new Shape(true, new PVector(width / 4 * 3, height / 4 * 3), new PVector(), new PVector(75, 75), verts, new int[][] {
      { 0, 1 },
      { 1, 2 },
      { 2, 3 },
      { 3, 4 },
      { 0, 1, 2, 3, 4 }
    });
    
    po1 = attachPhysics(s, 1);
  }

  {
    float step = 360 / 4;
    PVector[] verts = new PVector[4];
    for (int i = 0; i < 4; i++) {
      verts[i] = PVector.fromAngle(radians(step * i));
    }

    s[2] = new Shape(false, new PVector(width / 2, height / 2), new PVector(), new PVector(75, 75), verts, new int[][] {
      { 0, 1 },
      { 1, 2 },
      { 2, 3 },
      { 0, 1, 2, 3 }
    });
    
    po2 = attachPhysics(s, 2);
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

    PVector[] sv = s[sc].getVerts();
    int[][] sf = s[sc].fc;

    beginShape();

    for (int i = 0; i < sf.length; i++)
      for (int j = 0; j < sf[i].length; j++)
        vertex(sv[sf[i][j]].x, sv[sf[i][j]].y, sv[sf[i][j]].z);

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
