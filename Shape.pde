class Shape {
  PVector pos, rot, scale;
  PVector[] mdl;
  
  boolean dynamic;
  
  Shape(boolean dynamic, PVector pos, PVector rot, PVector scale, PVector... mdl)
  {
    this.dynamic = dynamic;
    this.pos = pos;
    this.rot = rot;
    this.scale = scale;
    this.mdl = mdl;
  }
  
  PVector[] getVerts() {
    PVector[] out = mdl.clone();
    PMatrix3D mat4 = new PMatrix3D();
    mat4.translate(pos.x, pos.y, pos.z);
    mat4.rotateX(radians(rot.x));
    mat4.rotateY(radians(rot.y));
    mat4.rotateZ(radians(rot.z));
    mat4.scale(scale.x, scale.y, scale.z);
    
    for (int i = 0; i < out.length; i++) {
      out[i] = mat4.mult(out[i], new PVector());
    }
    
    return out;
  }
}
