class Triangle {
  public Point p1;
  public Point p2;
  public Point p3;
  public color drawingColor;
  
  public Triangle() {
    this.p1= null;
    this.p2= null;
    this.p3= null;
    this.drawingColor= #cc0000;
  }
  
  public Triangle(Point a, Point b, Point c, color co) {
    this.p1= a;
    this.p2= b;
    this.p3= c;
    this.drawingColor= co;
  }
  
  public Triangle(Point a, Point b, Point c) {
    this.p1= a;
    this.p2= b;
    this.p3= c;
    this.drawingColor= #cc0000;
  }
  
  public void setPoints(Point a, Point b, Point c, color co) {
    this.p1= a;
    this.p2= b;
    this.p3= c;
    this.drawingColor= co;
  }
  
  public void setPoints(Point a, Point b, Point c) {
    this.p1= a;
    this.p2= b;
    this.p3= c;
    this.drawingColor= #cc0000;
  }
  
  // P= p1 + w1 * (p2-p1) + w2 * (p3-p1)
  // if w1 and w2 are positive and w1+w2 is between 0 and 1 then P is inside triangle
  public boolean intersects(Point p) {
    
    if(p1 == null || p2 == null || p3 == null)
      return false;
    
    float diff_p3p1y= p3.y - p1.y;
    float diff_p2p1y= p2.y - p1.y;
    float diff_p3p1x= p3.x - p1.x;
    
    float w1= (p1.x *  diff_p3p1y + (p.y - p1.y)*diff_p3p1x - p.x * diff_p3p1y) / (diff_p2p1y*diff_p3p1x - (p2.x-p1.x)*diff_p3p1y);
    float w2= (p.y - p1.y - w1*diff_p2p1y) / diff_p3p1y;
    
    return w1 >= 0 && w2 >= 0 && w1+w2 <= 1;
  }
  
  public void draw() {
    noFill();
    strokeWeight(2);
    stroke(this.drawingColor);
    triangle(p1.x, p1.y,
             p2.x, p2.y,
             p3.x, p3.y);
  }
}
