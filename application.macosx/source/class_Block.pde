class Block extends FBox{
  FLine topLine;
  Player holdingPlayer;
  boolean isHeld;
  
  int iDex;
  int jDex;

  Block(){
    super(0,0);
    holdingPlayer = null;
    isHeld = false;
    //Set size (always square)
    setWidth(tileSize);
    setHeight(getWidth());
    //other features
    setRotatable(false);
    setDensity(1);
    setRestitution(0);
    setFriction(1);
    setGrabbable(false);
    
    if(int(random(2)) == 0){
      attachImage(blockImages[0]);
    }else{
      attachImage(blockImages[1]);
    }
  }//End constructor
  
  
  void update(){
    //Update positon depending on condition
    if(isHeld){
      setPosition(holdingPlayer.getX(),holdingPlayer.getY()-(getHeight()+holdingPlayer.getHeight())/2);
      setDensity(1);
    }else{
      for(FBox currSpace : gridList){
        if((currSpace.getX()-currSpace.getWidth()/2 <= getX())&&(getX() <= currSpace.getX()+currSpace.getWidth()/2)){
          setVelocity(0,getVelocityY());
          setPosition(currSpace.getX(), getY());
          if((currSpace.getY()-currSpace.getHeight()/2 <= getY())&&(getY() <= currSpace.getY()+currSpace.getHeight()/2)){
            for(int j = 0; j < 20; j++){
              for(int i = 0; i < 20; i++){
                if(currSpace == grid[i][j]){
                  iDex = i;
                  jDex = j;
                }//End currSpace if
              }//End i for loop
            }//End j for loop
          }//End y contain if
        }//End x contain if
      }//End gridList for loop
      setDensity(500);
    }//End if(isHeld)
  }//End update() 

}//End class Block
