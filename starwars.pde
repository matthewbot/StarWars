final int CELL_SIZE = 3;

Grid grid;
Starfield stars;
Camera camera;
boolean running = false;
boolean step = false;
boolean show_cam = false;
boolean shift_pressed = false;

void setup() {
  grid = new Grid(400, 200);
  camera = new Camera(grid, 50, 50);
  size(grid.getWidth()*CELL_SIZE, grid.getHeight()*CELL_SIZE, P3D);
  
  stars = new Starfield();
}

void draw() {  
  if (running || step) {
    step = false;
    grid.step();
    camera.step();
  }
  
  background(0);
  stars.render();
  translate(-.5, -.5, 0);
  grid.draw();
  
  if (show_cam) {
    stroke(255, 0, 0);
    noFill();
    rect(camera.xpos*CELL_SIZE, camera.ypos*CELL_SIZE, camera.w*CELL_SIZE, camera.h*CELL_SIZE);
  }
};

void mouseClicked() {
  int x = mouseX / CELL_SIZE;
  int y = mouseY / CELL_SIZE;
  if (mouseButton == LEFT) {
    grid.setCell(x, y, !shift_pressed ? Grid.ALIVE : Grid.DEATH_1); 
  } else if (mouseButton == RIGHT) {
    grid.setCell(x, y, Grid.DEAD);
  }
}

void mouseDragged() {
  mouseClicked();
}

void keyPressed() {
  if (key == ' ') {
    running = !running;
  }
  if (!running && key == 's') {
    step = true;
  }
  if (keyCode == SHIFT) {
    shift_pressed = true;
  }
  if (key == 'r') {
    grid.randomize();
    stars = new Starfield();
  }
  if (key == 'c') {
    grid.clear();
    stars = new Starfield();
  }
  if (key == '1') {
    show_cam = !show_cam;
  }
}

void keyReleased() {
  if (keyCode == SHIFT) {
    shift_pressed = false;
  }
}




