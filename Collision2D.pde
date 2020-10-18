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
