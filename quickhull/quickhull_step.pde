class QuickhullStep {
  private ArrayList<Point> points;
  private color drawingColor;
  private int edgeThickness;
  private boolean atUpperHull;
  
  public QuickhullStep(ArrayList<Point> points, boolean isAtUpperHull, color c, int lineThickness) {

    this.points= (ArrayList<Point>)points.clone();
    this.sortPointsHorizontally();
    this.drawingColor= c;
    this.edgeThickness= lineThickness;
    this.atUpperHull= isAtUpperHull;
  }
  
  public QuickhullStep(ArrayList<Point> points, boolean isAtUpperHull) {
    
    this.points= (ArrayList<Point>)points.clone();
    this.sortPointsHorizontally();
    this.drawingColor= #cccccc;
    this.edgeThickness= 2;
    this.atUpperHull= isAtUpperHull;
  }
  
  public void setPoints(ArrayList<Point> points) {
    this.points= points;
  }
  
  public void setColor(color c) {
    this.drawingColor= c;
  }
  
  public void setEdgeThickness(int thickness) {
    this.edgeThickness= thickness;
  }
  
  // order points horizontally - left to right
  public void sortPointsHorizontally() {
    points.sort(new Comparator<Point>() {
      public int compare(Point p1, Point p2) {
        if(p1.getX() < p2.getX())
          return -1;
         
        if(p1.getX() == p2.getX())
          return 0;
        return 1;
      }
    });
  }
  
  public void draw() {
    
    if(points == null || points.size() <= 1)
      return;
    
    for(int i=0; i < points.size(); ++i) {
      noFill();
      stroke(this.drawingColor);
      strokeWeight(this.edgeThickness);
      
      Point p1= points.get(i);
      Point p2= (i+1 == points.size()) ? points.get(0) : points.get(i+1);
      
      line(p1.getX(), p1.getY(),
           p2.getX(), p2.getY());
    }
  }
}
