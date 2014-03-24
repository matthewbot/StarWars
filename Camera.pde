class Camera {
  int xpos;
  int ypos;
  int vx;
  int vy;
  Grid grid;
  int w;
  int h;
  float idle_ctr;
  
  public Camera(Grid grid, int w, int h) {
    this.grid = grid;
    xpos = grid.getWidth()/2;
    ypos = grid.getHeight()/2;
    this.w = w;
    this.h = h;
  }
  
  private int calcscore(int x, int y) {
    int score = grid.countActiveSquares(x, y, w, h, 1, 10);
    score += 4*grid.countActiveSquares(x+w/2, y+h/2, w/2, h/2, 2, 10);
    return score;
  }
  
  public void step() {
    final int dxy = 5; 
   
    int best_score = 0;
    int best_dx = 0;
    int best_dy = 0;
    for (int dx = -dxy; dx <= dxy; dx++) {
      for (int dy = -dxy; dy <= dxy; dy++) {
        int score = calcscore(xpos+dx, ypos+dy);
        if (dx == 0 && dy == 0) {
          score += 2;
        } else if (abs(dx) > 2 || abs(dy) > 2) {
          score -= 10;
        }
        if (score > best_score) {
          best_score = score;
          best_dx = dx;
          best_dy = dy;
        }  
      }
    }
    
    xpos += best_dx;
    if (xpos < 0) {
      xpos += grid.getWidth();
    } else if (xpos >= grid.getWidth()) {
      xpos -= grid.getWidth();
    }
    ypos += best_dy;
    if (ypos < 0) {
      ypos += grid.getHeight();
    } else if (ypos >= grid.getHeight()) {
      ypos -= grid.getHeight();
    }
    if (best_dx == 0 && best_dy == 0) {
      idle_ctr += 1;
    } else {
      idle_ctr += .2;
    }
    
    if (idle_ctr > 120) {
      idle_ctr = 0;
      step_jump();
    }
  }
  
  public void step_jump() {
    int best_score = 0;
    int best_x = 0;
    int best_y = 0;
    for (int x = 0; x < grid.getWidth(); x += w) {
      for (int y = 0; y < grid.getHeight(); y += h) {
        int score = calcscore(x, y);

        if (score > best_score) {
          best_score = score;
          best_x = x;
          best_y = y;
        }
      }
    }
    xpos = best_x;
    ypos = best_y;
  }
};
