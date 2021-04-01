class Point {
  private float x;
  private float y;
  private color drawingColor;
  private float drawingRadius;
  private boolean drawable;
  
  public Point(float x, float y) {
    this.x= x;
    this.y= y;
    this.drawingColor= #cccccc;
    this.drawingRadius= 4;
    this.drawable= true;
  }
  
  public Point(float x, float y, float radius, color c) {
    this.x= x;
    this.y= y;
    this.drawingColor= c;
    this.drawingRadius= radius;
    this.drawable= true;
  }
  
  public Point clone(boolean isDrawable) {
    Point p= new Point(this.x, this.y, this.drawingRadius, this.drawingColor);
    p.setDrawable(isDrawable);
    return p;
  }
  
  public boolean isDrawable() {
    return this.drawable;
  }
  
  public void setDrawable(boolean drawable) {
    this.drawable= drawable;
  }
  
  public void setPosition(float x, float y) {
    this.x= x;
    this.y= y;
  }
  
  public void setColor(color c) {
    this.drawingColor= c;
  }
  
  public void setRadius(float radius) {
    this.drawingRadius= radius;
  }
  
  public float getX() {
    return this.x;
  }
  
  public float getY() {
    return this.y;
  }
  
  public float getRadius() {
    return this.drawingRadius;
  }
  
  public Point add(Point q) {
    return new Point(this.x + q.getX(), this.y + q.getY());
  }
  
  public Point subtract(Point q) {
    return new Point(this.x - q.getX(), this.y - q.getY());
  }
  
  public PVector createVector(Point q) {
    return new PVector(q.getX() - this.x, q.getY() - this.y);
  }
  
  public boolean isWithinBoundary(float xPos, float yPos) {
    
    float leftEdge= this.x-this.drawingRadius;
    float rightEdge= this.x+this.drawingRadius;
    float topEdge= this.y-this.drawingRadius;
    float bottomEdge= this.y+this.drawingRadius;
    
    // System.out.println("l: " + leftEdge + " r:" + rightEdge + " t:" + topEdge + " b:" + bottomEdge + " xPos:" + xPos + " yPos:" + yPos);
    return xPos >= leftEdge && xPos <= rightEdge &&
           yPos >= topEdge && yPos <= bottomEdge;
  }
  
  public boolean isWithinBoundary(float xPos, float yPos, float radius) {
    
    float leftEdge= this.x-radius;
    float rightEdge= this.x+radius;
    float topEdge= this.y-radius;
    float bottomEdge= this.y+radius;
    
    return xPos >= leftEdge && xPos <= rightEdge &&
           yPos >= topEdge && yPos <= bottomEdge;
  }
  
  public void draw() {
    ellipseMode(RADIUS);
    fill(this.drawingColor);
    noStroke();
    ellipse(this.x, this.y, this.drawingRadius, this.drawingRadius);
  }
}
