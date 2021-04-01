int SCREEN_WIDTH= 800;
int SCREEN_HEIGHT= 600;
int SCREEN_MARGIN= 50;
int HALF_SCREEN_WIDTH= (int)Math.ceil(SCREEN_WIDTH*0.5);
int HALF_SCREEN_HEIGHT= (int)Math.ceil(SCREEN_HEIGHT*0.5);
int MAX_POINTS= 30;
boolean renderAnimation= true;
int animationCurrentStep= 0;
int animationCurrentStepAlpha= 255;
int animationCurrentStepAlphaDecrement= 5;
PFont fontArialBold12= null;
PFont fontArialBold24= null;
ArrayList<Point> points= null;
int pointIndexDragg= -1;
QuickhullHelper quickhullHelper= new QuickhullHelper();

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
  
  background(0);
  points= quickhullHelper.createRandomPoints(MAX_POINTS,
                                             -HALF_SCREEN_WIDTH + SCREEN_MARGIN, HALF_SCREEN_WIDTH - SCREEN_MARGIN,
                                             -HALF_SCREEN_HEIGHT + SCREEN_MARGIN, HALF_SCREEN_HEIGHT - SCREEN_MARGIN);
  
  fontArialBold12= createFont("Arial Bold", 12);
  fontArialBold24= createFont("Arial Bold", 24);
}

void draw() {
  
  background(0);
  translate(width/2,height/2);
  
  for(int i=0; i < points.size(); ++i) {
    if(pointIndexDragg == i) {
      Point p= points.get(i);
      p.setPosition(mouseX - HALF_SCREEN_WIDTH, mouseY - HALF_SCREEN_HEIGHT);
      p.setDrawable(true);
    }
    
    points.get(i).draw();
  }
  
  boolean isRenderAnimationActive= renderAnimation;
  ArrayList<QuickhullStep> steps= new ArrayList<QuickhullStep>();
  ArrayList<Point> solution= quickhullHelper.solveConvexHull(points, steps);
  quickhullHelper.drawPolygon(solution, #774477, 2);
  
  if(isRenderAnimationActive && steps.size() > 0) {
    
    if(animationCurrentStep >= steps.size()) {
      animationCurrentStep= 0;
      animationCurrentStepAlpha= 255;
    }
    
    QuickhullStep step= steps.get(animationCurrentStep);
    step.setColor(color(0,200,0,animationCurrentStepAlpha));
    step.draw();
    
    animationCurrentStepAlpha -= animationCurrentStepAlphaDecrement;
    if(animationCurrentStepAlpha <= 0) {
      animationCurrentStep= (animationCurrentStep+1) % steps.size();
      animationCurrentStepAlpha= 255;
    }
  }
  drawFrameRate();
  drawNumberOfSteps(steps.size());
}

void drawFrameRate() {
  textFont(fontArialBold12);
  fill(#cccccc);
  text("FPS: " + frameRate,20 - HALF_SCREEN_WIDTH,20 - HALF_SCREEN_HEIGHT);
}

void drawNumberOfSteps(int numSteps) {
  textFont(fontArialBold24);
  fill(#cccccc);
  text("Steps:" + numSteps,HALF_SCREEN_WIDTH - 200, 20 - HALF_SCREEN_HEIGHT);
}

void keyPressed() {
  
  switch(key) {
    case 'r':
    case 'R':
      background(0);
      quickhullHelper.shufflePoints(points,
                                    -HALF_SCREEN_WIDTH + SCREEN_MARGIN, HALF_SCREEN_WIDTH - SCREEN_MARGIN,
                                    -HALF_SCREEN_HEIGHT + SCREEN_MARGIN, HALF_SCREEN_HEIGHT - SCREEN_MARGIN);
    break;
    
    case 'a':
    case 'A':
      animationCurrentStepAlpha= 255;
      animationCurrentStep= 0;
      renderAnimation= !renderAnimation;
    break;
    
    case '+':
      quickhullHelper.addRandomPoint(points,-HALF_SCREEN_WIDTH + SCREEN_MARGIN, HALF_SCREEN_WIDTH - SCREEN_MARGIN,
                                            -HALF_SCREEN_HEIGHT + SCREEN_MARGIN, HALF_SCREEN_HEIGHT - SCREEN_MARGIN);  
    break;
    
    case '-':
      quickhullHelper.removePoint(points);
      
    break;
  }
}

void mousePressed() {
  pointIndexDragg= quickhullHelper.getPointAt(points, mouseX - HALF_SCREEN_WIDTH, mouseY - HALF_SCREEN_HEIGHT);
}

void mouseReleased() {
  pointIndexDragg= -1;
}
