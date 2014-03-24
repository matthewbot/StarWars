class Starfield {
  private PImage img;
  
  public Starfield() {
    img = makeImage(width, height);
  }
  
  public void render() {
    image(img, 0, 0);
  }
  
  private PImage makeImage(int w, int h) {
    PGraphics gfx = createGraphics(w, h);
    gfx.beginDraw();
    
    // Nebulas
    for (int i = 0; i < 20; i++) {
      float x = random(w);
      float y = random(h);
      
      float nw = random(300);
      float nh = nw * random(0.5, 2.0);

      gfx.noStroke();
      gfx.fill(random(10), random(10), random(10));
      gfx.blendMode(ADD);
      for (int j = 0; j < 40; j++) {
        float scale = (float)Math.exp(-j/4.0f);  
        gfx.ellipse(x, y, scale*nw, scale*nh);
      }
    }
    
    // Cross stars
    for (int i = 0; i < 50; i++) {
      int x = (int)random(w);
      int y = (int)random(h);
   
      gfx.stroke(100+random(100), 100+random(100), 255);
      gfx.line(x-3, y, x+3, y); 
      gfx.line(x, y-3, x, y+3);
      gfx.stroke(255);
      gfx.point(x, y);
    }
    
    // Point stars
    for (int i = 0; i < 500; i++) {
      gfx.stroke(random(255));
      gfx.point(random(w), random(h));
    }
    
    gfx.endDraw();
    return gfx.get();
  }
};
