class Milk {
  //Timing data
  int startTime;
  int ultimatum;
  int millSince;
  //for pauses
  int pauseStart;
  boolean milkPaused;
  
  //Sizing data
  int tall;
  int tly;
  int x = 0;
  int wide = width;
    
  Milk(int s, int u){
    startTime = s;
    ultimatum = u;
  }//End constructor
  
  void update(){
    if(!milkPaused){
      millSince = millis()-startTime;
      if(tly > 2.5*tileSize){
        tall = millSince*height/ultimatum;
      }
      tly = height-tall;
      noStroke();
      fill(#FFFFFF, 100);
      rect(x,tly,wide,tall);
    }else{
      noStroke();
      fill(#FFFFFF, 100);
      rect(x,tly,wide,tall);
    }
  }
  
  void setPaused(boolean p){
    milkPaused = p;
    if(milkPaused){
      pauseStart = millis();
    }else{
      startTime = startTime + millis() - pauseStart;
      ultimatum = ultimatum + millis() - pauseStart;
    }
  }
  
  int getY(){
    return tly;
  }
  
}//End class Milk
