import static java.awt.event.KeyEvent.*;

final int NONE = -1, PRESSED = 1, HELD = 2, RELEASED = 3;

int[] keys = new int[348];

void keyPressed() {
  if (keyCode != -1)
    keys[keyCode] = PRESSED;
}

void updateConfort() {
  for (int i = 0; i < keys.length; i++)
    if (keys[i] == PRESSED)
      keys[i] = HELD;
}

void keyReleased() {
  if (keyCode != -1)
    keys[keyCode] = RELEASED;
}
