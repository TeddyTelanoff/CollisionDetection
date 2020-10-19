HashMap<Integer, Object[]> po = new HashMap<Integer, Object[]>();

enum AttributeType {
  Velocity(0),
  Speed(1),
  Friction(2),
  
  Last(Friction.index);
  
  int index;
  
  private AttributeType(int index) {
    this.index = index;
  }
}

int attachPhysics(Shape[] sa, int index) {
  int i = 0;
  while (po.containsKey(i)) {
    i++;
  }
  
  po.put(i, new Object[AttributeType.Last.index]);
  
  return i;
}

int attachPhysics(Shape[] sa) {
  return attachPhysics(sa, 0);
}

void setAttribute(int index, AttributeType att, Object value) {
  po.get(index)[att.index] = value;
}
