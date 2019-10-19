class bzPoint {
  float x, y;
  int type;
  bzPoint (float x, float y, int type) {
    this.x=x;
    this.y=y;
    this.type=type;
  }
  void display() {
    float radius=0;
    switch (type) {
    case 0:
      fill(0, 255, 0, 128);
      radius =min(3*sw,10);
      break;
    case 1:
      fill(255, 0, 0, 128);
      noStroke();
      radius =min(2*sw,5);
      break;
    }
    circle (x, y, radius);
  }
}
