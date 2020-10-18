boolean checkCollision3D(Shape[] csa, int cs1, int cs2) {
  Shape s1 = csa[cs1], s2 = csa[cs2];

  boolean isColliding = false;
  boolean intersected;

  for (int sc = 0; sc < 2; sc++) {
    if (sc == 1) {
      s1 = csa[cs2];
      s2 = csa[cs1];
    }
    
    PVector[] v1 = s1.getVerts();
    PVector[] v2 = s2.getVerts();
    
    int[][] fc = s2.fc;
    
    for (int vc = 0; vc < v1.length; vc++) {
      PVector dis = new PVector();

      for (int fcc = 0; fcc < fc.length; fcc++) {
        
        
        //int faceVtxCount = fc[fcc].length;
        //PVector[] vertexArray = v1;
        //int[] faceVertexIndx = fc[fcc];
        
        //PVector normal = new PVector();
        //for (int i = 0, j = 1; i < faceVtxCount; i++, j++) {
        //  if (j == faceVtxCount) j = 0;
        //  normal.x += (((vertexArray[faceVertexIndx[i]].z) + (vertexArray[faceVertexIndx[j]].z)) *
        //     ((vertexArray[faceVertexIndx[j]].y) - (vertexArray[faceVertexIndx[i]].y)));
        //  normal.y += (((vertexArray[faceVertexIndx[i]].x) + (vertexArray[faceVertexIndx[j]].x)) *
        //     ((vertexArray[faceVertexIndx[j]].z) - (vertexArray[faceVertexIndx[i]].z)));
        //  normal.z += (((vertexArray[faceVertexIndx[i]].y) + (vertexArray[faceVertexIndx[j]].y)) *
        //     ((vertexArray[faceVertexIndx[j]].x) - (vertexArray[faceVertexIndx[i]].x)));
        //}
      }
    }
  }

  return isColliding;
}
