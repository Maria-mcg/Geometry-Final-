class QuickhullStackItem {
  public Line edge;
  public boolean atUpperHull;
  
  public QuickhullStackItem(Line edge, boolean atUpperHull) {
    this.edge= edge;
    this.atUpperHull= atUpperHull;
  }
}
