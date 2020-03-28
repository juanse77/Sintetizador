class Tecla{
  private final int posX;
  private final boolean natural;
  private final int tono;
  private final int posTecla;
  
  public Tecla(int posX, boolean natural, int tono, int posTecla){
    this.posX = posX;
    this.natural = natural;
    this.tono = tono;
    this.posTecla = posTecla;
  }
  
  public int getPosX(){
    return posX;
  }
  
  public boolean getNatural(){
    return natural;
  }
  
  public int getTono(){
    return tono;
  }
  
  public int getPosTecla(){
    return posTecla;
  }
}
