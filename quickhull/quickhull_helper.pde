import java.util.*;

class QuickhullHelper {
  
  public QuickhullHelper() {
  }
  
  public void shufflePoints(ArrayList<Point> points, int minX, int maxX, int minY, int maxY) {
    if(points == null || points.size() == 0)
      return;
    
    for(int i=0; i < points.size(); ++i) {
      Point p= points.get(i);
      p.setPosition(random(minX, maxX), random(minY, maxY));
      p.setDrawable(true);
    }
  }
  
  public ArrayList<Point> createRandomPoints(int maxPoints, int minX, int maxX, int minY, int maxY) {
    ArrayList<Point> points= new ArrayList<Point>(maxPoints);
    for(int i=0; i < maxPoints; ++i) {
      addRandomPoint(points, minX, maxX, minY, maxY);
    }
    return points;
  }
  
  public void addRandomPoint(ArrayList<Point> points, int minX, int maxX, int minY, int maxY) {
    points.add(new Point(random(minX, maxX), random(minY, maxY), 4, #cccccc));
  }
  
  public void removePoint(ArrayList<Point> points) {
    points.remove(points.size()-1); // Removes the last point
  }
  
  public int getPointAt(ArrayList<Point> points, float x, float y) {
    
    if(points == null || points.size() == 0)
      return -1;
    
    for(int i=0; i < points.size(); ++i) {
      if(points.get(i).isWithinBoundary(x,y,20))
        return i;
    }
    
    return -1;
  }
  
  public ArrayList<Point> solveConvexHull(ArrayList<Point> points, ArrayList<QuickhullStep> steps) {
    
    if(points == null || points.size() == 0)
      return new ArrayList<Point>();
    
    if(points.size() < 3) {
      
      if(steps != null)
        steps.add(new QuickhullStep(points, true));
       
      changePointsColor(points, #cccccc);
      return points;
    }
    
    points= (ArrayList<Point>) points.clone();
    sortPointsHorizontally(points);
    
    Point leftMost= points.get(0);
    Point rightMost= points.get(points.size()-1);
    Line mainEdge= new Line(leftMost, rightMost);
    
    ArrayList<Point> upperHull= getPointsAboveLine(mainEdge, points);
    ArrayList<Point> lowerHull= getPointsBelowLine(mainEdge, points);
    ArrayList<Point> result= new ArrayList<Point>(points.size());
    
    System.out.println("Upper-Count: " + upperHull.size() + " Lower-Count:" + lowerHull.size());
    changePointsColor(upperHull, #cc0000);
    changePointsColor(lowerHull, #0000cc);
    
    if(upperHull.size() > 2 && lowerHull.size() > 2) {
      leftMost.setDrawable(false);
      rightMost.setDrawable(false);
    }
    
    if(upperHull.size() > 0)
      result.addAll(processUpperHull(upperHull, leftMost, rightMost, steps));
    
    if(lowerHull.size() > 0)
      result.addAll(processLowerHull(lowerHull, leftMost, rightMost, steps));
    
    return result;
  }
  
  public ArrayList<Point> processUpperHull(ArrayList<Point> points, Point leftMost, Point rightMost, ArrayList<QuickhullStep> steps) {
    
    points= (ArrayList<Point>) points.clone();
    
    if(points == null || points.size() == 0)
      return new ArrayList<Point>();
    
    if(points.size() <= 3) {
      
      if(steps != null)
        steps.add(new QuickhullStep(points, true));
      return points;
    }
    
    ArrayList<QuickhullStackItem> stack=  new ArrayList<QuickhullStackItem>((int)Math.ceil(points.size() * 0.5));
    ArrayList<Point> result= new ArrayList<Point>(points.size());
    Line mainEdge= new Line(leftMost, rightMost);
    points.remove(0);
    points.remove(points.size()-1);
    
    result.add(leftMost);
    result.add(rightMost);
    stack.add(new QuickhullStackItem(mainEdge, true));
    
    boolean isFirstIteration= true;
    Triangle triang= new Triangle();
    
    while(!stack.isEmpty()) {
      int lastIndexStack= stack.size()-1;
      QuickhullStackItem item= stack.get(lastIndexStack);
      ArrayList<Integer> pointsSubSet;
      
      if(isFirstIteration) {
        isFirstIteration= false;
        pointsSubSet= range(0, points.size());
      } else {
        pointsSubSet= getPointsIndicesAboveLine(item.edge, points);
      }
      
      stack.remove(lastIndexStack); // Pop and process edge from stack...
      
      if(pointsSubSet.isEmpty())
        continue;
      
      int newExtremePointIndex= farthestPointIndex(item.edge, points, pointsSubSet);
      Point newExtremePoint= points.get(newExtremePointIndex);
      result.add(newExtremePoint);
      
      stack.add(new QuickhullStackItem(new Line(item.edge.p1, newExtremePoint), item.atUpperHull));
      stack.add(new QuickhullStackItem(new Line(item.edge.p2, newExtremePoint), item.atUpperHull));
      
      if(steps != null)
        steps.add(new QuickhullStep(result, true));
      
      triang.setPoints(item.edge.p1, item.edge.p2, newExtremePoint);
      for(int i=pointsSubSet.size()-1; i >= 0; --i) {
        int index= pointsSubSet.get(i);
        if(index == newExtremePointIndex || triang.intersects(points.get(index)))
          points.remove(index); // not an extreme point...
        // dont forget to remove the points that make the triangle which dont need to be checked again
      }
    }
    
    sortPointsHorizontally(result);
    return result;
  }
  
  public ArrayList<Point> processLowerHull(ArrayList<Point> points, Point leftMost, Point rightMost, ArrayList<QuickhullStep> steps) {
    
    points= (ArrayList<Point>) points.clone();
    
    if(points == null || points.size() == 0)
      return new ArrayList<Point>();
    
    if(points.size() <= 3) {
      
     if(steps != null)
        steps.add(new QuickhullStep(points, false)); 
      return points;
    }
    
    ArrayList<QuickhullStackItem> stack=  new ArrayList<QuickhullStackItem>((int)Math.ceil(points.size() * 0.5));
    ArrayList<Point> result= new ArrayList<Point>(points.size());
    Line mainEdge= new Line(leftMost, rightMost);
    points.remove(0);
    points.remove(points.size()-1);
    
    result.add(leftMost);
    result.add(rightMost);
    stack.add(new QuickhullStackItem(mainEdge, false));
    
    boolean isFirstIteration= true;
    Triangle triang= new Triangle();
    
    while(!stack.isEmpty()) {
      int lastIndexStack= stack.size()-1;
      QuickhullStackItem item= stack.get(lastIndexStack);
      ArrayList<Integer> pointsSubSet;
      
      if(isFirstIteration) {
        isFirstIteration= false;
        pointsSubSet= range(0, points.size());
      } else {
        pointsSubSet= getPointsIndicesBelowLine(item.edge, points);
      }
      
      stack.remove(lastIndexStack); // Pop and process edge from stack...
      
      if(pointsSubSet.isEmpty())
        continue;
      
      int newExtremePointIndex= farthestPointIndex(item.edge, points, pointsSubSet);
      Point newExtremePoint= points.get(newExtremePointIndex);
      result.add(newExtremePoint);
      
      stack.add(new QuickhullStackItem(new Line(item.edge.p1, newExtremePoint), item.atUpperHull));
      stack.add(new QuickhullStackItem(new Line(item.edge.p2, newExtremePoint), item.atUpperHull));
      
      if(steps != null)
        steps.add(new QuickhullStep(result, false));
      
      triang.setPoints(item.edge.p1, item.edge.p2, newExtremePoint);
      for(int i=pointsSubSet.size()-1; i >= 0; --i) {
        int index= pointsSubSet.get(i);
        if(index == newExtremePointIndex || triang.intersects(points.get(index)))
          points.remove(index); // not an extreme point...
        // dont forget to remove the points that make the triangle which dont need to be checked again
      }
    }
    
    sortPointsHorizontally(result);
    return result;
  }
  
  public void printArray(ArrayList<Point> points) {
    for(int i=0; i < points.size(); ++i) {
      System.out.print("  (" + points.get(i).getX() + "," + points.get(i).getY() + ")");
    }
    System.out.println();
  }
  
  public void sortPointsHorizontally(ArrayList<Point> points) {
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
  
  public ArrayList<Integer> range(int start, int end) {
    ArrayList<Integer> result= new ArrayList<Integer>(); 
    for(int i=start; i < end; ++i) {
      result.add(i);
    }
    return result;
  }
  
  public ArrayList<Point> getPointsAboveLine(Line edge, ArrayList<Point> points) {
    
    ArrayList<Point> result= new ArrayList<Point>();
    
    for(int i=0; i < points.size(); ++i) {
      
      PVector v2= edge.p1.createVector(points.get(i));
      
      if(v2.cross(edge.directionVector).z <= 0)
        result.add(points.get(i));
    }
    
    return result;
  }
  
  public void changePointsColor(ArrayList<Point> points, color c) {
    for(int i=0; i < points.size(); ++i) {
      Point p= points.get(i);
      p.setColor(c);
      p.setDrawable(true);
    }
  }
  
  public ArrayList<Integer> getPointsIndicesAboveLine(Line edge, ArrayList<Point> points) {
    
    ArrayList<Integer> result= new ArrayList<Integer>();
    
    for(int i=0; i < points.size(); ++i) {
      
      PVector v2= edge.p1.createVector(points.get(i));
      
      if(v2.cross(edge.directionVector).z <= 0)
        result.add(i);
    }
    
    return result;
  }
  
  public ArrayList<Point> getPointsBelowLine(Line edge, ArrayList<Point> points) {
    
    ArrayList<Point> result= new ArrayList<Point>();
    
    for(int i=0; i < points.size(); ++i) {
      
      PVector v2= edge.p1.createVector(points.get(i));
      
      if(v2.cross(edge.directionVector).z >= 0)
        result.add(points.get(i));
    }
    
    return result;
  }
  
  public ArrayList<Integer> getPointsIndicesBelowLine(Line edge, ArrayList<Point> points) {
    
    ArrayList<Integer> result= new ArrayList<Integer>();
    
    for(int i=0; i < points.size(); ++i) {
      
      PVector v2= edge.p1.createVector(points.get(i));
      
      if(v2.cross(edge.directionVector).z >= 0)
        result.add(i);
    }
    
    return result;
  }
  
  // pointsIndices is the subset of points
  int farthestPointIndex(Line edge, ArrayList<Point> points, ArrayList<Integer> pointsIndices) {
    
    int result= -1;
    float farthest=-1;
    for(int i=0; i < pointsIndices.size(); ++i) {
      int index= pointsIndices.get(i);
      float distLineToPoint= edge.shortestDistanceSqTo(points.get(index));
        
      if(farthest < distLineToPoint) {
        farthest= distLineToPoint;
        result= index;
      }
    }
    
    return result;
  }
  
  public void drawPolygon(ArrayList<Point> points, color c, int lineThickness) {
    
    if(points == null || points.size() <= 1)
      return;
    
    for(int i=0; i < points.size(); ++i) {
      
      Point p1= points.get(i);
      Point p2= (i+1 == points.size()) ? points.get(0) : points.get(i+1);
      
      if(!p1.isDrawable() && !p2.isDrawable())
        continue;
      
      noFill();
      stroke(c);
      strokeWeight(lineThickness);
      
      line(p1.getX(), p1.getY(),
           p2.getX(), p2.getY());
    }
  }
}
