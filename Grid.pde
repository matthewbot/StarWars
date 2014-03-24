public class Grid {
  private byte[][] current;
  private byte[][] next;
  private byte[][] alive_counts;
  
  public static final byte ALIVE = 3;
  public static final byte DEATH_1 = 2;
  public static final byte DEATH_2 = 1;
  public static final byte DEAD = 0;
  
  public Grid(int w, int h) {
     current = new_array(w, h);
     next = new_array(w, h);
     alive_counts = new_array(w, h);
  }
  
  public int getWidth() { return current.length; }
  public int getHeight() { return current[0].length; }
  
  public byte getCell(int x, int y) { return current[x][y]; }
  public byte getCellAliveCount(int x, int y) { return alive_counts[x][y]; }
  public void setCell(int x, int y, byte val) { 
    current[x][y] = val;
    if (val == ALIVE) {
      alive_counts[x][y] = 2;
    } else {
      alive_counts[x][y] = 0;
    }
  }
  
  public int countActiveSquares(int sx, int sy, int w, int h, int minalive, int maxalive) {
    int ctr = 0;
    for (int x = sx; x < sx+w; x++) {
      for (int y = sy; y < sy+h; y++) {
        int wx = wrap(x, getWidth());
        int wy = wrap(y, getHeight());
        if (current[wx][wy] == ALIVE && alive_counts[wx][wy] >= minalive && alive_counts[wx][wy] < maxalive) {
          ctr++;
        }
      }
    }
    return ctr;
  }
  
  public void randomize() {  
    for (int x = 0; x < getWidth(); x++) {
      for (int y = 0; y < getHeight(); y++) {
        current[x][y] = random(0, 1) < .2 ? ALIVE : DEAD;
        alive_counts[x][y] = 0;
      }
    }
  }
  
  public void clear() {  
    for (int x = 0; x < getWidth(); x++) {
      for (int y = 0; y < getHeight(); y++) {
        current[x][y] = DEAD;
        alive_counts[x][y] = 0;
      }
    }
  }
  
  public void step() {
    for (int x = 0; x < getWidth(); x++) {
      for (int y = 0; y < getHeight(); y++) {
        byte next_val = next_cell(x, y, current);
        next[x][y] = next_val;
        if (next_val == ALIVE) {
          alive_counts[x][y] = (byte)min(alive_counts[x][y]+1, 100);
        } else if (next_val == DEAD) {
          alive_counts[x][y] = 0;
        }
      }
    }
    
    byte[][] tmp = current;
    current = next;
    next = tmp;
  }
  
  public void draw() {
    draw_type(50,100, 100,100,100, 25);
    draw_type(2,49, 255,255,50, 50);
    draw_type(0,1, 100,100,255, 150);    
  }
  
  private byte[][] new_array(int w, int h) {
    byte[][] grid = new byte [w][];
    for (int x = 0; x < w; x++) {
      grid[x] = new byte [h]; 
    }  
    return grid;
  }
  
  private byte next_cell(int x, int y, byte[][] grid) {
    byte self = grid[x][y];
    int neighbors = count_neighbors(x, y, grid);
    if (self == ALIVE) {
      return ((neighbors == 3) || (neighbors == 4) || (neighbors == 5)) ? ALIVE : DEATH_1; 
    } else if (self == DEAD) {
      return (neighbors == 2) ? ALIVE : DEAD;
    } else {
      return (byte)(self-1);
    }
  }
  
  private int count_neighbors(int x, int y, byte[][] grid) {
    int count = 0;
    
    int mx = grid.length-1;
    int my = grid[0].length-1;
    
    for (int nx = x-1; nx <= x+1; nx++) {
      for (int ny = y-1; ny <= y+1; ny++) {
        if (nx == x && ny == y) {
          continue;
        }
        if (grid[wrap(nx, mx)][wrap(ny, my)] == ALIVE) {
          count++;
        }
      }   
    }  
    return count;
  }
  
  private int wrap(int v, int m) {
    if (v < 0) {
      return v + m;
    } else if (v >= m) {
      return v - m;
    } else {
      return v;
    }
  }
  
  private void draw_type(int min_alive, int max_alive, int r, int g, int b, int s) {
    stroke(s);
    rectMode(CORNER);
    
    for (int x = 0; x < grid.getWidth(); x++) {
      for (int y = 0; y < grid.getHeight(); y++) {
        byte self = grid.getCell(x, y);
        if (self == DEAD) {
          continue;
        }
        
        int alive = grid.getCellAliveCount(x, y);
        if (alive < min_alive || alive > max_alive) {
          continue;
        }
        
        if (self == ALIVE) {
          fill(r, g, b);
        } else if (self == DEATH_1) {
          fill(r/2, g/2, b/2);
        } else if (self == DEATH_2) {
          fill(r/4, g/4, b/4);
        }

        rect(x*CELL_SIZE, y*CELL_SIZE, CELL_SIZE, CELL_SIZE);  
      }
    }  
  }
}
