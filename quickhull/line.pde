class Line {
  private Point p1;
  private Point p2;
  private PVector directionVector;
  private color drawingColor;
  
  public Line(Point p1, Point p2) {
    
    // order points from left to right
    if(p1.getX() <= p2.getX()) {
      this.p1= p1;
      this.p2= p2;
    } else {
      this.p1= p2;
      this.p2= p1;
    }
    
    this.directionVector= this.p1.createVector(this.p2);
    this.drawingColor= #cccccc;
  }
  
  // dist= |APxu| / |u|, where u is the direction vector and AP is the vector from one point of the line to P
  // APxu is the cross product between vector AP and u
  // To get better performance the method returns de distance squared, so it doesnt need to use the square root
  public float shortestDistanceSqTo(Point p) {
    
    PVector AP= this.p1.createVector(p);
    float APxu= AP.cross(this.directionVector).magSq();
    float u= this.directionVector.magSq();
    
    return APxu / u;
  }
  
  public void draw() {
    stroke(this.drawingColor);
    line(this.p1.getX(), this.p1.getY(),
         this.p2.getX(), this.p2.getY());
  }
}
